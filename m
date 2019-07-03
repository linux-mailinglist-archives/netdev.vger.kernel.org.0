Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF68D5ED61
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfGCUSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:18:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39129 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCUSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:18:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so3877837qkd.6
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bkikyEsPp/F/lyGTUMYkhINszh6ssHACtXvD7E7R8r0=;
        b=iMtFvdN/HLQUVN2/izzHHh77KwximeFqU/BT9eVWVDqXcyM4ZpubaPk0Q4FlF6iGxa
         s3buYLskL9gE8ojKQPoHgqWptw9wAWoMp8SLIvXqzzcAmEb9jpEt/nr8808MmvfFFegp
         qQ83BN34LORm1e8VlXqQWnK+3oxp5ovi96oTMEiJ9+tEuVCSUNx+mVgFGBYpZ6kqrpie
         5dfkEvgV7kqdUAAG22YYJv0Lcc2Dynyr1HN5HNM4POjceXTFtq+32q+xNV0N/2ogSugS
         BzSKaeGxE6Jkd37bsz0uB/NfwbTGwmzpfF4QfzaRpmQjSNvYSynnJ7RrSp24Ez6TiTTq
         mjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bkikyEsPp/F/lyGTUMYkhINszh6ssHACtXvD7E7R8r0=;
        b=G/fkYMX0nXxNjNJ4pKt100Jxxtp7zIN2k37YgiEPW+0rjIP6DrUnPZPMqucWgt2xOv
         JuOmUuGZgW/ciW0itimNkYKDabAWQVdRchXEcYV/9vmwTcHqztpHdeSSJ3clZYW0f2Jo
         qaorr4+YCJjiQg/caPhQrJ5U0RaJLlipy5QdRpPUQ89eRofEHBdGY4S1HQUoPGvcJf0h
         jPsWu7BAbdIa9MCUzMdBAUHmNiflP9oeJOuI8qhw2e5sjTZ9In6sjUnxuk7iA5mmFTdX
         E54LfeVG6JX8QA/LctoOJ2nzykAl7fFWf5bI9qW8TsXYdOIGg0+sjzajPFqU5qckLI2z
         nnfw==
X-Gm-Message-State: APjAAAUnJUCKFNJfDZ3gaS6/0JUXA3pPqIYufKuVlb6QUteMyrntseVP
        UbML362/BBEHzWF/F/uYv0tBTw==
X-Google-Smtp-Source: APXvYqx5L3IJiCJXtOOcMAtf3QcBzfoutHFawXK/gtVmcoc5gUhnOz7mQExGxwqmiHHoDosSMczpyQ==
X-Received: by 2002:a37:9cc2:: with SMTP id f185mr1989999qke.172.1562185121606;
        Wed, 03 Jul 2019 13:18:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id y6sm1277932qki.67.2019.07.03.13.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Jul 2019 13:18:41 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hiliC-0007Gr-Nm; Wed, 03 Jul 2019 17:18:40 -0300
Date:   Wed, 3 Jul 2019 17:18:40 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 10/13] IB/mlx5: Enable subscription for
 device events over DEVX
Message-ID: <20190703201840.GA27910@ziepe.ca>
References: <20190630162334.22135-1-leon@kernel.org>
 <20190630162334.22135-11-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630162334.22135-11-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:23:31PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
> 
> Enable subscription for device events over DEVX.
> 
> Each subscription is added to the two level XA data structure according
> to its event number and the DEVX object information in case was given
> with the given target fd.
> 
> Those events will be reported over the given fd once will occur.
> Downstream patches will mange the dispatching to any subscription.

BTW Matt,

Here is another vote for a 64 bit indexing xarray in the kernel.. Any
further thought on doing that?

Jason
