Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E931A6036D2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJRX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJRX5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:57:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99DACA8A1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666137452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PGywE1yLJDCgQD3UKpQDgXpybKsCI0XInRlMdrpJ5nc=;
        b=ScCLDFv17laVu1w4nS16ovy6MxcJZmptVhBu4g3IZJD6q+hI1b8x/pHXXHdHAPG7I2AT4X
        JHpYt02un1SUI3nYz9wFojNYV4bCMPtPZsp1sWc5XJfn4Auh08XStHJR2dF0dQfYtoTaIu
        GgVPmnMBnpgdWWSVfynBVgT4amazVn0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-448-PRn0UD9VOnWn_koawHMjpg-1; Tue, 18 Oct 2022 19:57:31 -0400
X-MC-Unique: PRn0UD9VOnWn_koawHMjpg-1
Received: by mail-wm1-f72.google.com with SMTP id n6-20020a7bc5c6000000b003c6bbe5d5cfso12016886wmk.4
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PGywE1yLJDCgQD3UKpQDgXpybKsCI0XInRlMdrpJ5nc=;
        b=P5Hk0ZEAkAQ2Dzz0mlIRIU0bHO6i3o5SwrffwEhZ6eO1dIsWcE3CTK1vMyE/6Qvf8J
         7YhAPsBXDp37+k2ds56tTSc54rERzh+fW6NAEFq9rh2KE9pqA8NFe93rnyxiXyOidbUs
         7o40eLGmQu1mimqzKwkI1lpO7wwRxsnHYk/XMdZbax8u1VU4z3cNKG8h7+ptpEDHuuX7
         DAlPRBO0pUEClbsVwIF6CihC8f3F4nydInddAnthWhikXn9XZiqGInqI+IBsoEFK3Vaa
         La75qJMtDYeI5U82eqBsUBkwpUz/hVig3inTAm/hYj4B5QwMepG1M3b4UD464Jiv8Pet
         x9zw==
X-Gm-Message-State: ACrzQf3AQpXExxr+KfIHpL7cQ9MOXloC/jdyWxMBVv23x/CCtKuYdGib
        FshmgYJIM2w1MRQJ5TiCISw/85RrYsbLm19hljWDJUkjPLOzMYixnSBf8l36QXEMR1jJsC8Kc5/
        w1PAnc+nlvTYlkKXuL1Vyi1dzOaX2lGG4
X-Received: by 2002:adf:ffc8:0:b0:231:ce45:7e02 with SMTP id x8-20020adfffc8000000b00231ce457e02mr3230462wrs.383.1666137450505;
        Tue, 18 Oct 2022 16:57:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM673mAv5Or8qOXeGGbw57MF/Oyw1OtQYAUyaz5Pu/u+Rv+MAq01eJhQ7EJdXJPcuijOKZzD6FSzZeRwtXb6ztY=
X-Received: by 2002:adf:ffc8:0:b0:231:ce45:7e02 with SMTP id
 x8-20020adfffc8000000b00231ce457e02mr3230448wrs.383.1666137450257; Tue, 18
 Oct 2022 16:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221018183639.806719-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 18 Oct 2022 19:57:19 -0400
Message-ID: <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
Subject: Re: [PATCH wpan-next] mac802154: Allow the creation of coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Oct 18, 2022 at 2:36 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> As a first strep in introducing proper PAN management and association,
> we need to be able to create coordinator interfaces which might act as
> coordinator or PAN coordinator.
>
> Hence, let's add the minimum support to allow the creation of these
> interfaces. This support will be improved later, in particular regarding
> the filtering.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/iface.c | 14 ++++++++------
>  net/mac802154/main.c  |  2 ++
>  net/mac802154/rx.c    | 11 +++++++----
>  3 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> index d9b50884d34e..682249f3369b 100644
> --- a/net/mac802154/iface.c
> +++ b/net/mac802154/iface.c
> @@ -262,13 +262,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
>                 if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
>                         int ret;
>
> -                       /* TODO currently we don't support multiple node types
> -                        * we need to run skb_clone at rx path. Check if there
> -                        * exist really an use case if we need to support
> -                        * multiple node types at the same time.
> +                       /* TODO currently we don't support multiple node/coord
> +                        * types we need to run skb_clone at rx path. Check if
> +                        * there exist really an use case if we need to support
> +                        * multiple node/coord types at the same time.
>                          */
> -                       if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
> -                           nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
> +                       if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
> +                           nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
>                                 return -EBUSY;
>
>                         /* check all phy mac sublayer settings are the same.
> @@ -565,6 +565,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
>         wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
>
>         switch (type) {
> +       case NL802154_IFTYPE_COORD:
>         case NL802154_IFTYPE_NODE:
>                 ieee802154_be64_to_le64(&wpan_dev->extended_addr,
>                                         sdata->dev->dev_addr);
> @@ -624,6 +625,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
>         ieee802154_le64_to_be64(ndev->perm_addr,
>                                 &local->hw.phy->perm_extended_addr);
>         switch (type) {
> +       case NL802154_IFTYPE_COORD:
>         case NL802154_IFTYPE_NODE:
>                 ndev->type = ARPHRD_IEEE802154;
>                 if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
> diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> index 40fab08df24b..d03ecb747afc 100644
> --- a/net/mac802154/main.c
> +++ b/net/mac802154/main.c
> @@ -219,6 +219,8 @@ int ieee802154_register_hw(struct ieee802154_hw *hw)
>
>         if (hw->flags & IEEE802154_HW_PROMISCUOUS)
>                 local->phy->supported.iftypes |= BIT(NL802154_IFTYPE_MONITOR);
> +       else
> +               local->phy->supported.iftypes &= ~BIT(NL802154_IFTYPE_COORD);
>

So this means if somebody in the driver sets iftype COORD is supported
but then IEEE802154_HW_PROMISCUOUS is not supported it will not
support COORD?

Why is IEEE802154_HW_PROMISCUOUS required for COORD iftype? I thought
IEEE802154_HW_PROMISCUOUS is required to do a scan?

>         rc = wpan_phy_register(local->phy);
>         if (rc < 0)
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index 2ae23a2f4a09..aca348d7834b 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -208,6 +208,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
>         int ret;
>         struct ieee802154_sub_if_data *sdata;
>         struct ieee802154_hdr hdr;
> +       struct sk_buff *skb2;
>
>         ret = ieee802154_parse_frame_start(skb, &hdr);
>         if (ret) {
> @@ -217,7 +218,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
>         }
>
>         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> -               if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
> +               if (sdata->wpan_dev.iftype == NL802154_IFTYPE_MONITOR)
>                         continue;

I guess this will work but I would like to see no logic about if it's
not MONITOR it's NODE or COORD, because introducing others requires
updating those again... however I think it's fine. I would like to see
a different receive path for coord_rx() and node_rx(), but yea
currently I guess they are mostly the same... in future I think they
are required as PACKTE_HOST, etc. will be changed regarding pan
coordinator or just coordinator (so far I understood).

>
>                 if (!ieee802154_sdata_running(sdata))
> @@ -230,9 +231,11 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
>                     sdata->required_filtering == IEEE802154_FILTERING_4_FRAME_FIELDS)
>                         continue;
>
> -               ieee802154_subif_frame(sdata, skb, &hdr);
> -               skb = NULL;
> -               break;
> +               skb2 = skb_clone(skb, GFP_ATOMIC);
> +               if (skb2) {
> +                       skb2->dev = sdata->dev;
> +                       ieee802154_subif_frame(sdata, skb2, &hdr);
> +               }
>         }
>
>         kfree_skb(skb);

If we do the clone above this kfree_skb() should be move to
ieee802154_rx() right after __ieee802154_rx_handle_packet(). This
patch also changes that we deliver one skb to multiple interfaces if
there are more than one and I was not aware that we currently do that.
:/

- Alex

