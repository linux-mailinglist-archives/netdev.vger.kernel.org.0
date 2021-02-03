Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A69B30DC3D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhBCOHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhBCOHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 09:07:14 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7E0C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 06:06:34 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id e10so5656433vkm.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAExRUNzOcZumEIzQSLJkvNSF4NLA49MhsuzeN12mUQ=;
        b=Gpysw8GOdywgLhUaEy039D53V+Es0BkEAuEZL5sgupW4S51huQAbmn+p8Hw1Bt0UEF
         q1nxMrudsgRRwbkSf9Sp3rsiubdEb5k5WTstpjaklrNbcZxBZOExrn3cYzzSqRAH8fDc
         IKME0YiX1D0+0WRKnjZhe48F6ySgFwyKfCs4Dsgd8AkmvS8wJIqANqQJALnXpI3FN26b
         j4CHuxDc/MLUdqrNiGG304pyS1O1hb6eCzwr7fvyDKAM+gnuclq/KCUw6xh4fEcq7Sjh
         fJNBVvnpvEhcmJ0q91ox25SP+bt5C3iUM+ffTlhK59KD/S97HiFjivcg5ZJ4lLvh3JGF
         zchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAExRUNzOcZumEIzQSLJkvNSF4NLA49MhsuzeN12mUQ=;
        b=BjDd3WIXTigbC+jSZsuLudfa4TpissatO2UhJfl5aU04UsO6eGao+Je9PpibHkYj8p
         Xzd9bs4kt3ohNBI0FKOiUL8U9PE/3mEn62qCCHp1InszV49DJQWjzpQt0WE26jYdCCrG
         BWQqTqoNghgq2yZvF4GwyREI9fD1Q6BfXk3UokPA0E5LRe5qUpif6r0a/6hWnX36FP2Q
         17ZFlOJVeU+n8s9Hc/J0J0m9Eq5SdGitPkdwgF/PlnRWFj8HK2YkfNJoT4Wqb2yewtx1
         t928m0G7GqeLYbR7eclrFbN06Co6qrACdS2S1d0c4hRZHAMtYge+A7ZVjZaYh+380WUS
         NNfA==
X-Gm-Message-State: AOAM533MU9VcYws2k6q7RVjuFECcMsXMsNUZXfFeJAwLR9wztSoEkDwS
        Kb/XOZWIK3NVJAOSrxbwzr7nMDryzB4=
X-Google-Smtp-Source: ABdhPJwlLmKKyNoo3xA2b6OiGlHt0IpyQkYQpBDKOEpLEstN3YigEFOKLQs029HTMz71SWwyQ4uilQ==
X-Received: by 2002:a1f:8d54:: with SMTP id p81mr1699223vkd.10.1612361191965;
        Wed, 03 Feb 2021 06:06:31 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id u16sm253594vsi.16.2021.02.03.06.06.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 06:06:31 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id g5so8330486uak.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:06:30 -0800 (PST)
X-Received: by 2002:ab0:60b5:: with SMTP id f21mr1646758uam.141.1612361189682;
 Wed, 03 Feb 2021 06:06:29 -0800 (PST)
MIME-Version: 1.0
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
 <CAF=yD-JWw9TsXrOT_83bDECrX1J9NvkesoG37pXq8zOkQpiUqg@mail.gmail.com> <CAMZdPi9-_Y5unZ+4n8v_nt0g+RsTH=BxkphDJdCiJMdsMYcEvw@mail.gmail.com>
In-Reply-To: <CAMZdPi9-_Y5unZ+4n8v_nt0g+RsTH=BxkphDJdCiJMdsMYcEvw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 09:05:53 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfJLdGj07p-B-sUfovrvj5xdt96Y=aCsu1_Bia+h5aYHg@mail.gmail.com>
Message-ID: <CA+FuTSfJLdGj07p-B-sUfovrvj5xdt96Y=aCsu1_Bia+h5aYHg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: mhi-net: Add de-aggeration support
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> [...]
> > >  static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> > >                                 struct mhi_result *mhi_res)
> > >  {
> > > @@ -142,19 +175,42 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> > >         free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> > >
> > >         if (unlikely(mhi_res->transaction_status)) {
> > > -               dev_kfree_skb_any(skb);
> > > -
> > > -               /* MHI layer stopping/resetting the DL channel */
> > > -               if (mhi_res->transaction_status == -ENOTCONN)
> > > +               switch (mhi_res->transaction_status) {
> > > +               case -EOVERFLOW:
> > > +                       /* Packet can not fit in one MHI buffer and has been
> > > +                        * split over multiple MHI transfers, do re-aggregation.
> > > +                        * That usually means the device side MTU is larger than
> > > +                        * the host side MTU/MRU. Since this is not optimal,
> > > +                        * print a warning (once).
> > > +                        */
> > > +                       netdev_warn_once(mhi_netdev->ndev,
> > > +                                        "Fragmented packets received, fix MTU?\n");
> > > +                       skb_put(skb, mhi_res->bytes_xferd);
> > > +                       mhi_net_skb_agg(mhi_netdev, skb);
> > > +                       break;
> > > +               case -ENOTCONN:
> > > +                       /* MHI layer stopping/resetting the DL channel */
> > > +                       dev_kfree_skb_any(skb);
> > >                         return;
> > > -
> > > -               u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > > -               u64_stats_inc(&mhi_netdev->stats.rx_errors);
> > > -               u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > > +               default:
> > > +                       /* Unknown error, simply drop */
> > > +                       dev_kfree_skb_any(skb);
> > > +                       u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > > +                       u64_stats_inc(&mhi_netdev->stats.rx_errors);
> > > +                       u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > > +               }
> > >         } else {
> > > +               skb_put(skb, mhi_res->bytes_xferd);
> > > +
> > > +               if (mhi_netdev->skbagg_head) {
> > > +                       /* Aggregate the final fragment */
> > > +                       skb = mhi_net_skb_agg(mhi_netdev, skb);
> > > +                       mhi_netdev->skbagg_head = NULL;
> > > +               }
> > > +
> > >                 u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > >                 u64_stats_inc(&mhi_netdev->stats.rx_packets);
> > > -               u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> > > +               u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
> >
> > might this change stats? it will if skb->len != 0 before skb_put. Even
> > if so, perhaps it doesn't matter.
>
> Don't get that point, skb is the received MHI buffer, we simply set
> its size because MHI core don't (skb->len is always 0 before put).
> Then if it is part of a fragmented transfer we just do the extra
> 'skb = skb_agg+ skb', so skb->len should always be right here,
> whether it's a standalone/linear packet or a multi-frag packet.

Great. I did not know that skb->len is 0 before put for this codepath.
It isn't for other protocols, and then any protocol headers would have
been counted.
