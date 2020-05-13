Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9A1D1DBA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390218AbgEMSnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMSnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:43:18 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CE3C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:43:18 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f13so344324qkh.2
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NXrvQNeC1Xj02nUw5miKT8fMXE+WzxSqq6EctGKkuNI=;
        b=nWD1ls946alpVxKN77zxbZUZ+HrnneaGobCxCRt9Tk0xSC4PPClNiqgypoIR+KfoIU
         E5qbMtYATFCLpqLg6AJjVKw9p1ikx2kluRuRlUGk7YSSRedH6so1htbOO0ZdrXD0mpDX
         5n+Xa1Gtncgceoo3FslAH6if/VZwBcZP86caVTGnJbVc3n3Ccj8Bpcyj3KSuvgbgpGz5
         +WOcNCKg/sw14OrUMr2UfEJ4j4iTa3ycYdGXrQRpUwus6Z8o0sYQXJ8cSoQ2L7akZPqG
         2C98jEGaAlMvyFiVjM+s6XBo3JAsLh0oBbUq5RA46aD7LxRjuP1yW8Fhf+EOtjDI6hN6
         YKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NXrvQNeC1Xj02nUw5miKT8fMXE+WzxSqq6EctGKkuNI=;
        b=jLGkZdx1oi8pZJO1/Uh2NwiWzQo2PeYCctE4Jupx0cOLem5jbmFU/qm5cPlZRrc/xV
         3siF6HZ6JsazqiP/RFT5NPaSgLRrjYEwWA/x6LqtwCuIb0jfvpHGeyKo1x2pMZVyEOGL
         LUYALB/X/xhxH3Bs/AKyyeJFuiaummF31OsWtu6nqRmfQZDJ3M3OEUfIFMB/jCVkFtap
         oV3qiB4IACfxhYce2HEodtY0fF67D50rynfw5OK9A105RKay9iP6Bc08y4QJ5Adds+qN
         PTm/lkLjr+GqyVR0zYaJC8h8OMhm/mFOfMGADWIyJRMBlS9TnA/zvgqRplMfNeijPgKQ
         I+Fw==
X-Gm-Message-State: AOAM531+TNd/lHz4DEm7FlE5xo63taJsc/wDUsha2GZaQtieDC9D0/uW
        hKno818N3FA+IgUlOo6gBsvPuw==
X-Google-Smtp-Source: ABdhPJzgpvkBE4/Qkgv1I7UVhNmN6oXYlL2M9jIHRzZyiQC7ufYITkarA0NxI/DhgMaJZC05+rk3qA==
X-Received: by 2002:a37:6656:: with SMTP id a83mr1062345qkc.395.1589395397522;
        Wed, 13 May 2020 11:43:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id p137sm536595qke.60.2020.05.13.11.43.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2020 11:43:17 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jYwLc-0000c2-He; Wed, 13 May 2020 15:43:16 -0300
Date:   Wed, 13 May 2020 15:43:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200513184316.GA2217@ziepe.ca>
References: <20200507185921.GA15146@embeddedor>
 <20200509205151.209bdc9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509205151.209bdc9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 08:51:50PM -0700, Jakub Kicinski wrote:
> On Thu, 7 May 2020 13:59:21 -0500 Gustavo A. R. Silva wrote:
> > The current codebase makes use of the zero-length array language
> > extension to the C90 standard, but the preferred mechanism to declare
> > variable-length types such as these ones is a flexible array member[1][2],
> > introduced in C99:
> > 
> > struct foo {
> >         int stuff;
> >         struct boo array[];
> > };
> >
> > ...
> 
> Applied, thank you!

Jakub,

Please don't take RDMA patches in netdev unless it is a special
case. There is alot of cross posting and they often get into both
patchworks.

Thanks,
Jason
