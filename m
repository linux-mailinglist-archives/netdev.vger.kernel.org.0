Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6005D48D25B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 07:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiAMGh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 01:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiAMGh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 01:37:57 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F088EC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:37:56 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id x22so16031797lfd.10
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/F3JmYd/iiHpw2rbnfVF4dRhmv1u8M8RjM8RySPnR+Q=;
        b=Fe4O5NyLjXar+d1dz6bp1T1QyjomFgsCTIVDy7EdoWsQ/F35HHLH2/nYRI4WCafDVH
         kLmlniSAT66RyRdG4fq5A9+4nLNE9ut4g48nRp0vpwWMdYIK7Y3EJZ2UPqhswH57E3lU
         VKMGAPx8iHx+w33J7Rp1/daSSMc5rm9A9+zzNv0UAU0MHKGo55GYtGchPOBIHzD0DUvk
         6v9LuDcMOry7yt1ICbwoBU51VMWDeVuyzQ30VuZ5JYsM1sehjhioHe4dryi3BikkdYGD
         4YwQJe13CBSANNWnAfarmzVLLZlHbPSvKa1yZy/g9eRDbhBkTlzWIOLoa7/s7B3tP3tb
         oGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/F3JmYd/iiHpw2rbnfVF4dRhmv1u8M8RjM8RySPnR+Q=;
        b=nld1D2T2UyeBs1lEOMjkVIWXNSN6kRTohzlzfB3g5UiavnXrv0s8mi09RqGYMF5Xlr
         A7Hol2ecWz75aFiQa/GI7BTEIdpJ83xorzeopAoT9rLBFg8cqEV7K921f48BPmtxq68J
         gP2nFGqWz7PDH4h4NEEVfHPtxDJ1AezFd2NotDdramWAVq3za8DLDVR3R9Gk4ebG4ipA
         0JX8NH2QSQGMW588/l1obzBY+pGb/oKMm7fcElV9WiHzSIAoWKbT9SKoZ4FFLiMnm7lc
         Pij/Cxoytk3HbAbWCbKj0leCiUjykKGQg4lllRJ0jiY/kYgRYfnat6CkicBiFsO0U0y4
         5BdQ==
X-Gm-Message-State: AOAM533GE1DUHGB28ZXy4a8+zlZIuyCe8dZhznhOfAJEltFYNFPowwmu
        AWH7dd5dt+TSCYEgtPfVRk0PHroXgXpK4BiGvb5ZZ3I2AzY=
X-Google-Smtp-Source: ABdhPJzEi/8E3niIRKkE0ahaYppOX7ACMx/YeAfdsjL9MUUdMdTPtniM4gNWQv0LyoO/1fmvtDiJ6waiZ3/ydhjFK8E=
X-Received: by 2002:a05:6512:41a:: with SMTP id u26mr2310235lfk.438.1642055874616;
 Wed, 12 Jan 2022 22:37:54 -0800 (PST)
MIME-Version: 1.0
References: <1642006975-17580-1-git-send-email-sbhatta@marvell.com> <20220112110314.358d5295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112110314.358d5295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 13 Jan 2022 12:07:42 +0530
Message-ID: <CALHRZuouqa76eNYgYe5qs71oHqdZ0OeE_P1UYJU8uaaG0-qAyw@mail.gmail.com>
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

On Thu, Jan 13, 2022 at 5:24 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 12 Jan 2022 22:32:55 +0530 Subbaraya Sundeep wrote:
> > ethtool rx-buf-len is for setting receive buffer size,
> > support setting it via ethtool -G parameter and getting
> > it via ethtool -g parameter.
>
> I don't see a check against current MTU, in case MTU is larger than
> the buffer length the device will scatter?
>
Yes correct. The idea is to have an option for user to choose either one big
frame or multiple fragments for a frame.

> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > index 61e5281..6d11cb2 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > @@ -177,6 +177,7 @@ struct otx2_hw {
> >       u16                     pool_cnt;
> >       u16                     rqpool_cnt;
> >       u16                     sqpool_cnt;
> > +     u16                     rbuf_len;
> >
> >       /* NPA */
> >       u32                     stack_pg_ptrs;  /* No of ptrs per stack page */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > index d85db90..a100296 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > @@ -371,6 +371,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
> >       ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
> >       ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
> >       ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
> > +     kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
> >  }
> >
> >  static int otx2_set_ringparam(struct net_device *netdev,
> > @@ -379,6 +380,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
> >                             struct netlink_ext_ack *extack)
> >  {
> >       struct otx2_nic *pfvf = netdev_priv(netdev);
> > +     u32 rx_buf_len = kernel_ring->rx_buf_len;
> >       bool if_up = netif_running(netdev);
> >       struct otx2_qset *qs = &pfvf->qset;
> >       u32 rx_count, tx_count;
> > @@ -386,6 +388,15 @@ static int otx2_set_ringparam(struct net_device *netdev,
> >       if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> >               return -EINVAL;
> >
> > +     /* Hardware supports max size of 32k for a receive buffer
> > +      * and 1536 is typical ethernet frame size.
> > +      */
> > +     if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
> > +             netdev_err(netdev,
> > +                        "Receive buffer range is 1536 - 32768");
> > +             return -EINVAL;
> > +     }
> > +
> >       /* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
> >       rx_count = ring->rx_pending;
> >       /* On some silicon variants a skid or reserved CQEs are
> > @@ -403,7 +414,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
> >                          Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
> >       tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
> >
> > -     if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
> > +     if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt && !rx_buf_len)
>
> Should we use rx_buf_len = 0 as a way for users to reset the rxbuf len
> to the default value? I think that would be handy.
>
Before this patch we calculate each receive buffer based on mtu set by user.
Now user can use rx-buf-len but the old mtu based calculation is also there.
Here I am using rx_buf_len == 0 as a switch to calculate buffer length
using mtu or
just use length set by user. So here I am not setting rx_buf_len to some
default value.

> >       if (if_up)
> > @@ -413,6 +424,10 @@ static int otx2_set_ringparam(struct net_device *netdev,
> >       qs->sqe_cnt = tx_count;
> >       qs->rqe_cnt = rx_count;
> >
> > +     if (rx_buf_len)
> > +             pfvf->hw.rbuf_len = ALIGN(rx_buf_len, OTX2_ALIGN) +
> > +                                 OTX2_HEAD_ROOM;
> > +
> >       if (if_up)
> >               return netdev->netdev_ops->ndo_open(netdev);
> >
> > @@ -1207,6 +1222,7 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
> >  static const struct ethtool_ops otx2_ethtool_ops = {
> >       .supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> >                                    ETHTOOL_COALESCE_MAX_FRAMES,
> > +     .supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
> >       .get_link               = otx2_get_link,
> >       .get_drvinfo            = otx2_get_drvinfo,
> >       .get_strings            = otx2_get_strings,
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index 6080ebd..37afffa 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -66,6 +66,8 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
> >                   netdev->mtu, new_mtu);
> >       netdev->mtu = new_mtu;
> >
> > +     pf->hw.rbuf_len = 0;
>
> Why reset the buf len on mtu change?
>
As explained above buffer size will be calculated using mtu
now instead of rx-buf-len from ethtool.

Thanks,
Sundeep

> >       if (if_up)
> >               err = otx2_open(netdev);
> >
> > @@ -1306,6 +1308,9 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
> >       int total_size;
> >       int rbuf_size;
> >
> > +     if (pf->hw.rbuf_len)
> > +             return pf->hw.rbuf_len;
> > +
> >       /* The data transferred by NIX to memory consists of actual packet
> >        * plus additional data which has timestamp and/or EDSA/HIGIG2
> >        * headers if interface is configured in corresponding modes.
>
