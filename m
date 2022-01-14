Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17DB48E404
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbiANF6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiANF6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:58:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B332C061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 21:58:49 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bu18so3940385lfb.5
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 21:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbjOZwaz/cFw+D9848oxskueHTe5Hg2hq0+o1K7BgP0=;
        b=LwqEP4uWaX4WwCUvac7QcyOZfjCYxDVTpn+jsSIfKws/Ho9vIvwlEdwgTd63XGhywB
         zBVrEjoQctMAyMvNbstggl1wnxellMsoV4a+bmbFTzwQp+E7SC4SSb+m6nP1FgF394I5
         yfYG9IaS94W0xXjweM7Kua5ZOVakOzggEokjPOb/pXPQZhKLBQWmbH3WQIXUHJvMXb3b
         zBXgsxFS1C6EzXQ5GT3x5ZR0al7th9i6uJjoHq4VcDjkkZt6EKypvviqClN5UircC2rF
         /eqXsXYRKMvdo4BEj7jiUe8baOUfvc3f0HGJS8zMvoXJTVnoadBCRvZyEMrAz6y+rA3c
         3c1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbjOZwaz/cFw+D9848oxskueHTe5Hg2hq0+o1K7BgP0=;
        b=nIkTw25IV1A8Nf3t5+lcGk0nw5yzIv0ZaR9xW3A5Om2qM+hxJl+nKAwLmxUB2NVSXD
         V9FNWq5vVEvN3aRaRSpdrV3z4lHgEQwJw0Qi38STLe1gNwi4OyFOORzr7g9O23txlz3l
         XcZtMwEG0xNNSe3hd2PoUTQvHV9VUD8cD8Q/AUGkVMW7lXwBF5YhiOpMJ4vhFIQn6lI3
         VYBjyCZnLqWurH9UhDnKjWRsQuNXm1I5BMSx9G3sHzcfJI6QRFjQHtB3hb5dzM/BdTrL
         FqIpI7b/7iaAp4bp09O++JiXmJUbbUHQQE9sYwQ6w0o5hi+8viT2ShefP8zLVF3C6rAl
         ho/w==
X-Gm-Message-State: AOAM533ix6b2C67ksO+pogOaYV4YBXnVRal+rGwxPffFDaDtM0EKuVzU
        +cS0hT7e6/eWjUK3Su9allNzoERgGdx3c8HgqVkntcF7suA=
X-Google-Smtp-Source: ABdhPJwzlnSDoivimB1vSh5bfU08uA6cjxATISJkehZojrkTLd71WkWzXT9DZfUugAeX9NzVe365KIAzT7NMz4Rnbu0=
X-Received: by 2002:ac2:5b89:: with SMTP id o9mr5704351lfn.592.1642139927720;
 Thu, 13 Jan 2022 21:58:47 -0800 (PST)
MIME-Version: 1.0
References: <1642006975-17580-1-git-send-email-sbhatta@marvell.com>
 <20220112110314.358d5295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CALHRZuouqa76eNYgYe5qs71oHqdZ0OeE_P1UYJU8uaaG0-qAyw@mail.gmail.com> <20220113103113.59e4836d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220113103113.59e4836d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 14 Jan 2022 11:28:35 +0530
Message-ID: <CALHRZuo-sO+eE09JDw_TzeUBeRAGyHWp7-zjQxsqkqKCOZS5gQ@mail.gmail.com>
Subject: Re: [net-next PATCH] octeontx2-pf: Change receive buffer size using ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jan 14, 2022 at 12:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 13 Jan 2022 12:07:42 +0530 sundeep subbaraya wrote:
> > > Should we use rx_buf_len = 0 as a way for users to reset the rxbuf len
> > > to the default value? I think that would be handy.
> > >
> > Before this patch we calculate each receive buffer based on mtu set by user.
> > Now user can use rx-buf-len but the old mtu based calculation is also there.
> > Here I am using rx_buf_len == 0 as a switch to calculate buffer length
> > using mtu or
> > just use length set by user. So here I am not setting rx_buf_len to some
> > default value.
> >
> > > > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > > > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > > > @@ -66,6 +66,8 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
> > > >                   netdev->mtu, new_mtu);
> > > >       netdev->mtu = new_mtu;
> > > >
> > > > +     pf->hw.rbuf_len = 0;
> > >
> > > Why reset the buf len on mtu change?
> > >
> > As explained above buffer size will be calculated using mtu
> > now instead of rx-buf-len from ethtool.
>
> IIUC you're saying that the way to get back to the default buffer size
> is to change the MTU?
>
> It was discussed on the list in the past in the context of RSS
> indirection tables and the conclusion was that we should not reset
> explicit user configuration (in case of RSS indir table this means
> user-set table survives change in the number of queues).
>
> Having one config reset another is pretty painful to deal with for
> the users. I had to fix many cases of this sort of problem in the
> production env I'm working with. Turning one knob resets other knobs
> so it takes multiple runs of the config daemon (chef or alike) to
> get to the target configuration.
>
> In my mind if user has set the rx-buf-len it should survive all other
> config changes. User can reset to default by setting rx-buf-len to 0.
> It should be possible to set rx-buf-len and mtu in any order and have
> the same result.

Thanks for the clear explanation. I will change as per your comments
and send the next spin.

Sundeep
