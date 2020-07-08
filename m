Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938E7218563
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgGHLA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgGHLA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:00:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CD0C08C5DC;
        Wed,  8 Jul 2020 04:00:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o22so1030349pjw.2;
        Wed, 08 Jul 2020 04:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WQAPN1hAQam2av0WhfnqIVYaNg3SC9fQz/Ka5GFz6Ws=;
        b=EXA+noGZ+QiKjPe/iFQtfBxipDUKoecxCDly/pBM5G+icsXqWpgK0rzNP6Zsj8TgSZ
         X7uQyxbRiIiDA2HgMCtjL6hF7F5ikciVebuV9kPY999iu6d0W4OisVJMj/kReYNK6x3b
         EzYZ2DPira7wtUgxBXzeoRD8pPjdYLCSE45deQgOf5Gtw9hBdfOFJ8SVaWWx2rwUOCrP
         xqwNp9XWzok1i5JR9eceELOZ/Vnpbm0LJvduiYFTMrJYm4XOo7LAW4IxC23Ojsmp7aTq
         vrnguCU6XiFySCsegN4k+vwyIT942/hzo+K69aWCKfTmuBl2ADpVf2QKDtqB7S84ycmu
         dc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WQAPN1hAQam2av0WhfnqIVYaNg3SC9fQz/Ka5GFz6Ws=;
        b=LZfoO9A4lylxCiNp2BFrivLCyh8GNGZZ5rY4fXmVuwWti+7VK5V2C926N7TTmUMCOz
         gBC5YgZqA88XYZvPgAW5aeoTlfNvVtm8zTfE4ZLFQPku8h/C3275AjbqxaU33yUCLwDI
         G2hXcqBlqjQt7d/QhuCuxuwNvOlBk8OvXRgP4Da7UuyZY5t6IBqW51B4UJEWHBt/JrCk
         JZPo8TZYZ0Q1zQFdwViiD2VdLEDB4IGTwF+nwrLS+lPQeiWWI8pcA5xNoEbPj9TaaG1s
         Oe8gfPOy6daC7SvXYThejz7vq5/U7oqX8f+GGOzyr2KoGTQ7ZW5hqdcdDqRC3VTiyBmx
         2Swg==
X-Gm-Message-State: AOAM5339U0sFtz1GSp7n4qhmabBWc8QMdEAFnU6i1HpK3MzKpZGafV2L
        9F7Dz4q8Ho4aGgplNjt109X4UVS8
X-Google-Smtp-Source: ABdhPJyGDD6J5LQEkV26+QM9gAEzSZezx31l2HRYAa4n3YjmaDLfFX9eksnhrDV1Xt5VtqrQkWV3eQ==
X-Received: by 2002:a17:90a:1f06:: with SMTP id u6mr8993990pja.33.1594206056366;
        Wed, 08 Jul 2020 04:00:56 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v10sm8762192pfc.118.2020.07.08.04.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:00:55 -0700 (PDT)
Date:   Wed, 8 Jul 2020 04:00:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sergey Organov <sorganov@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
Message-ID: <20200708110053.GC9080@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-2-sorganov@gmail.com>
 <20200706150814.kba7dh2dsz4mpiuc@skbuf>
 <87zh8cu0rs.fsf@osv.gnss.ru>
 <20200706154728.lfywhchrtaeeda4g@skbuf>
 <87zh8cqyrp.fsf@osv.gnss.ru>
 <20200707070437.gyfoulyezi6ubmdv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707070437.gyfoulyezi6ubmdv@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 10:04:37AM +0300, Vladimir Oltean wrote:
> > > We do it like this:
> > > - DSA: If there is a timestamping switch stacked on top of a
> > >   timestamping Ethernet MAC, the switch hijacks the .ndo_do_ioctl of the
> > >   host port, and you are supposed to use the PTP clock of the switch,
> > >   through the .ndo_do_ioctl of its own (virtual) net devices. This
> > >   approach works without changing any code in each individual Ethernet
> > >   MAC driver.
> > > - PHY: The Ethernet MAC driver needs to be kind enough to check whether
> > >   the PHY supports hw timestamping, and pass this ioctl to that PHY
> > >   while making sure it doesn't do anything stupid in the meanwhile, like
> > >   also acting upon that timestamping request itself.
> > >
> > > Both are finicky in their own ways. There is no real way for the user to
> > > select which PHC they want to use. The assumption is that you'd always
> > > want to use the outermost one, and that things in the kernel side always
> > > collaborate towards that end.

Vladimir, your explanations in this thread are valuable.  Please
consider converting them into a patch to expand

   Documentation/networking/timestamping.rst


Thanks,
Richard
