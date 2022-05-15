Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472B3527AAC
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiEOWXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 18:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiEOWXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 18:23:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A046E08B
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652653397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VyHLqP2a1cOGNPMyTkzdR2ELmMdeIuv3NZdOMZeRAr4=;
        b=LNmQquRvFWgO/sgplE83N3s5c33R3Rld9Ul9HVJukNAW/sP2Fdxc70A5BZiFDUxHpZ2Quk
        hH2U4p0gSU9PZ6hOcIZMcDNP4sZPuhgsQCWAEUKD6KF4TFVYTF+//zshkknJq+DOcq9A8X
        PZIcXG5BQ82FxaAZlnr7ZgR3b4hFcQQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-m6DiDGsoMJyPUJGeC7Xq-w-1; Sun, 15 May 2022 18:23:16 -0400
X-MC-Unique: m6DiDGsoMJyPUJGeC7Xq-w-1
Received: by mail-qt1-f197.google.com with SMTP id d15-20020ac85d8f000000b002f3b3b7e0adso10323372qtx.20
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 15:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VyHLqP2a1cOGNPMyTkzdR2ELmMdeIuv3NZdOMZeRAr4=;
        b=ayYaQr4yc4HxTgX4EUW7xDT/uF0RkVdr11F/7P3XsWdJNtoL9F0hU2/9nrVxstMOKf
         mIuBjU4tFXLj0ON/khu6m1tpEJnA/I2A2eVks54kncEFiSC+7ahdZG5yzWgoHcdvmPvz
         QJCSS1xx+ADWvUMXdd/zNjax1fN2hWtMM7BeCx8AzMSr3bZC34FqrIWX1eo5rO9Xj1Q6
         tn8xJx6HGZFnU6VpJax4A5QtmS/6p6q0p8pbPJCK8W5FeoEUPgg6vbnEXbdCrRI1pOfa
         ckU45mBOtvgFPJdCht6F5E1pGXFHvauphbiV1efbchzuuG80eEfydab6C192wBEMS+/Y
         yZIQ==
X-Gm-Message-State: AOAM532zK3G5LDWNJwQpoDCtGHopWV0FbiTCNVZV/OdPukbWL/s2Z1wx
        GIiBJzxLVkGf8ZB4awREjzdbR8gYadX9XV3oR+xoZaxRdfwPsT2JJJjeIF7GSTTSmJ+dCIAgFZE
        Yy8i3amUFQHKY4nrgsZWp8zQCSiLW96s7
X-Received: by 2002:a05:622a:46:b0:2f3:d16c:8053 with SMTP id y6-20020a05622a004600b002f3d16c8053mr13217553qtw.339.1652653395813;
        Sun, 15 May 2022 15:23:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw71sgEz9iEiQ02MD075uyDjyArqZqNGVBTkeUfu7Cd0pRe756stawtje40UndHaQMA5EyP8sSRy4PkoSCGxP8=
X-Received: by 2002:a05:622a:46:b0:2f3:d16c:8053 with SMTP id
 y6-20020a05622a004600b002f3d16c8053mr13217534qtw.339.1652653395594; Sun, 15
 May 2022 15:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com> <20220512143314.235604-9-miquel.raynal@bootlin.com>
In-Reply-To: <20220512143314.235604-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 15 May 2022 18:23:04 -0400
Message-ID: <CAK-6q+iazXHZmf2vteXGEEpSXLLp9279g5JD2whBn-_FPL0piw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 08/11] net: mac802154: Introduce a tx queue
 flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Right now we are able to stop a queue but we have no indication if a
> transmission is ongoing or not.
>
> Thanks to recent additions, we can track the number of ongoing
> transmissions so we know if the last transmission is over. Adding on top
> of it an internal wait queue also allows to be woken up asynchronously
> when this happens. If, beforehands, we marked the queue to be held and
> stopped it, we end up flushing and stopping the tx queue.
>
> Thanks to this feature, we will soon be able to introduce a synchronous
> transmit API.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h      |  1 +
>  net/ieee802154/core.c        |  1 +
>  net/mac802154/cfg.c          |  2 +-
>  net/mac802154/ieee802154_i.h |  1 +
>  net/mac802154/tx.c           | 26 ++++++++++++++++++++++++--
>  net/mac802154/util.c         |  6 ++++--
>  6 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index ad3f438e4583..8b6326aa2d42 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -218,6 +218,7 @@ struct wpan_phy {
>         struct mutex queue_lock;
>         atomic_t ongoing_txs;
>         atomic_t hold_txs;
> +       wait_queue_head_t sync_txq;
>
>         char priv[] __aligned(NETDEV_ALIGN);
>  };
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index d81b7301e013..f13e3082d988 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
>         wpan_phy_net_set(&rdev->wpan_phy, &init_net);
>
>         init_waitqueue_head(&rdev->dev_wait);
> +       init_waitqueue_head(&rdev->wpan_phy.sync_txq);
>
>         mutex_init(&rdev->wpan_phy.queue_lock);
>
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index b51100fd9e3f..93df24f75572 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
>         if (!local->open_count)
>                 goto suspend;
>
> -       ieee802154_hold_queue(local);
> +       ieee802154_sync_and_hold_queue(local);
>         synchronize_net();
>
>         /* stop hardware - this must stop RX */
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index e34db1d49ef4..a057827fc48a 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -124,6 +124,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
> +int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 607019b8f8ab..38f74b8b6740 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -44,7 +44,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
>  err_tx:
>         /* Restart the netif queue on each sub_if_data object. */
>         ieee802154_release_queue(local);
> -       atomic_dec(&local->phy->ongoing_txs);
> +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> +               wake_up(&local->phy->sync_txq);
>         kfree_skb(skb);
>         netdev_dbg(dev, "transmission failed\n");
>  }
> @@ -100,12 +101,33 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>
>  err_wake_netif_queue:
>         ieee802154_release_queue(local);
> -       atomic_dec(&local->phy->ongoing_txs);
> +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> +               wake_up(&local->phy->sync_txq);
>  err_free_skb:
>         kfree_skb(skb);
>         return NETDEV_TX_OK;
>  }
>
> +static int ieee802154_sync_queue(struct ieee802154_local *local)
> +{
> +       int ret;
> +
> +       ieee802154_hold_queue(local);
> +       ieee802154_disable_queue(local);
> +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
> +       ret = local->tx_result;
> +       ieee802154_release_queue(local);

I am curious, why this extra hold, release here?

- Alex

