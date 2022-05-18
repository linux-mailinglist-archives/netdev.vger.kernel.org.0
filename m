Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5424C52AF3B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiERAhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiERAhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4941536E0C
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652834271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m9x3dEHHI9vT8kzTo2Q1aOZl/Kuyhe2/Mpy2g+7kuvc=;
        b=d7Hd36zl5aX7xzwPLh9ta0Vn3Ns3/bnJDGvp1McjAjDHG+sWlpAr+yJow82g8FfnkM3VFY
        02d5aKgpvINo0dju2/odeBYnvV3dcJQHA6i97sHWZSHPRqvlnKq6+h7jVo7/xweqOjCv0q
        rS4K0twYVQLQ0rlgUlFmHqVpLOCUlzA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-miuurMmaPjeDBrqNuoe6Rw-1; Tue, 17 May 2022 20:37:50 -0400
X-MC-Unique: miuurMmaPjeDBrqNuoe6Rw-1
Received: by mail-qt1-f200.google.com with SMTP id ay35-20020a05622a22a300b002f3fdcb1bb1so587747qtb.8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m9x3dEHHI9vT8kzTo2Q1aOZl/Kuyhe2/Mpy2g+7kuvc=;
        b=z2yf+y4narCRhv/8IP0r6dGWkhYuoYDdY4SUZzj6Hj5PdE6u+iBPuVfsfhhuTpp3HF
         QDo3ItBUaAY+3iJdV9iXJxUSjEemdnD9MYraT0KS3A3u68CVKzGkMGgGNscp35NR2xXW
         tOK68G9/hU/VBEty8rTRgflnNzvEpAQsHRas/3XBBgx9IcJs04J9SlIZ5TZFwiy6dzaE
         inUvBxRrcDTHVpySiH6HnMVWY3K7Wqp+4F3YxglMrGe268WJSG2EhOSyIJlh3g4WBs5S
         OIRp14CHQH1Lclj7dnWdo7wWN1x3gCMIO6IRN+fe1XEUpeVd9vt4uwyZfC6Mc0KVI2rB
         qbkA==
X-Gm-Message-State: AOAM533cNGEXEj6KcYJ2sdSs6zmkPvc5IG2AZZnZkgsmVmeTUk0UF0t3
        Y+zBIQnECGCCe773IYlR7n2xnq/FxJ9if7kVTjwlS30B1eY5/JHCQIthX9nbjPu9nTAKbTq+W68
        IuUv5iQCByi1WMmm4S9k2c6wFBlggFjDf
X-Received: by 2002:a05:620a:919:b0:69f:e373:3de8 with SMTP id v25-20020a05620a091900b0069fe3733de8mr17970414qkv.27.1652834269474;
        Tue, 17 May 2022 17:37:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlg9XmcKm6BmHLkYFuuDImEsNPIdGfI8TgiiUEWmyRI8/LasE85n0ZjtdnLUh3JkKRcfVMmEue0rakCkuggRM=
X-Received: by 2002:a05:620a:919:b0:69f:e373:3de8 with SMTP id
 v25-20020a05620a091900b0069fe3733de8mr17970396qkv.27.1652834269134; Tue, 17
 May 2022 17:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com> <20220517163450.240299-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220517163450.240299-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 20:37:38 -0400
Message-ID: <CAK-6q+jh_PfkWB4odE8Dr+sxwWTqhirr8hyOxFFyEUzLDJC7+w@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 05/11] net: mac802154: Bring the ability to
 hold the transmit queue
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Create a hold_txs atomic variable and increment/decrement it when
> relevant, ie. when we want to hold the queue or release it: currently
> all the "stopped" situations are suitable, but very soon we will more
> extensively use this feature for MLME purposes.
>
> Upon release, the atomic counter is decremented and checked. If it is
> back to 0, then the netif queue gets woken up. This makes the whole
> process fully transparent, provided that all the users of
> ieee802154_wake/stop_queue() now call ieee802154_hold/release_queue()
> instead.
>
> In no situation individual drivers should call any of these helpers
> manually in order to avoid messing with the counters. There are other
> functions more suited for this purpose which have been introduced, such
> as the _xmit_complete() and _xmit_error() helpers which will handle all
> that for them.
>
> One advantage is that, as no more drivers call the stop/wake helpers
> directly, we can safely stop exporting them and only declare the
> hold/release ones in a header only accessible to the core.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h      |  6 +++--
>  include/net/mac802154.h      | 27 -------------------
>  net/ieee802154/core.c        |  2 ++
>  net/mac802154/cfg.c          |  4 +--
>  net/mac802154/ieee802154_i.h | 19 +++++++++++++
>  net/mac802154/tx.c           |  6 ++---
>  net/mac802154/util.c         | 52 +++++++++++++++++++++++++++++++-----
>  7 files changed, 75 insertions(+), 41 deletions(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 473ebcb9b155..7a191418f258 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -11,7 +11,7 @@
>
>  #include <linux/ieee802154.h>
>  #include <linux/netdevice.h>
> -#include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  #include <linux/bug.h>
>
>  #include <net/nl802154.h>
> @@ -214,8 +214,10 @@ struct wpan_phy {
>         /* the network namespace this phy lives in currently */
>         possible_net_t _net;
>
> -       /* Transmission monitoring */
> +       /* Transmission monitoring and control */
> +       spinlock_t queue_lock;
>         atomic_t ongoing_txs;
> +       atomic_t hold_txs;
>
>         char priv[] __aligned(NETDEV_ALIGN);
>  };
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index bdac0ddbdcdb..357d25ef627a 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -460,33 +460,6 @@ void ieee802154_unregister_hw(struct ieee802154_hw *hw);
>   */
>  void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb,
>                            u8 lqi);
> -/**
> - * ieee802154_wake_queue - wake ieee802154 queue
> - * @hw: pointer as obtained from ieee802154_alloc_hw().
> - *
> - * Tranceivers usually have either one transmit framebuffer or one framebuffer
> - * for both transmitting and receiving. Hence, the core currently only handles
> - * one frame at a time for each phy, which means we had to stop the queue to
> - * avoid new skb to come during the transmission. The queue then needs to be
> - * woken up after the operation.
> - *
> - * Drivers should use this function instead of netif_wake_queue.
> - */
> -void ieee802154_wake_queue(struct ieee802154_hw *hw);
> -
> -/**
> - * ieee802154_stop_queue - stop ieee802154 queue
> - * @hw: pointer as obtained from ieee802154_alloc_hw().
> - *
> - * Tranceivers usually have either one transmit framebuffer or one framebuffer
> - * for both transmitting and receiving. Hence, the core currently only handles
> - * one frame at a time for each phy, which means we need to tell upper layers to
> - * stop giving us new skbs while we are busy with the transmitted one. The queue
> - * must then be stopped before transmitting.
> - *
> - * Drivers should use this function instead of netif_stop_queue.
> - */
> -void ieee802154_stop_queue(struct ieee802154_hw *hw);
>
>  /**
>   * ieee802154_xmit_complete - frame transmission complete
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index de259b5170ab..47a4de6df88b 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -130,6 +130,8 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
>
>         init_waitqueue_head(&rdev->dev_wait);
>
> +       spin_lock_init(&rdev->wpan_phy.queue_lock);
> +
>         return &rdev->wpan_phy;
>  }
>  EXPORT_SYMBOL(wpan_phy_new);
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index 1e4a9f74ed43..b51100fd9e3f 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -46,7 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
>         if (!local->open_count)
>                 goto suspend;
>
> -       ieee802154_stop_queue(&local->hw);
> +       ieee802154_hold_queue(local);
>         synchronize_net();
>
>         /* stop hardware - this must stop RX */
> @@ -72,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
>                 return ret;
>
>  wake_up:
> -       ieee802154_wake_queue(&local->hw);
> +       ieee802154_release_queue(local);
>         local->suspended = false;
>         return 0;
>  }
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index a8b7b9049f14..0c7ff9e0b632 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -130,6 +130,25 @@ netdev_tx_t
>  ieee802154_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
>
> +/**
> + * ieee802154_hold_queue - hold ieee802154 queue
> + * @local: main mac object
> + *
> + * Hold a queue by incrementing an atomic counter and requesting the netif
> + * queues to be stopped. The queues cannot be woken up while the counter has not
> + * been reset with as any ieee802154_release_queue() calls as needed.
> + */
> +void ieee802154_hold_queue(struct ieee802154_local *local);
> +
> +/**
> + * ieee802154_release_queue - release ieee802154 queue
> + * @local: main mac object
> + *
> + * Release a queue which is held by decrementing an atomic counter and wake it
> + * up only if the counter reaches 0.
> + */
> +void ieee802154_release_queue(struct ieee802154_local *local);
> +
>  /* MIB callbacks */
>  void mac802154_dev_set_page_channel(struct net_device *dev, u8 page, u8 chan);
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 33f64ecd96c7..6a53c83cf039 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -43,7 +43,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
>
>  err_tx:
>         /* Restart the netif queue on each sub_if_data object. */
> -       ieee802154_wake_queue(&local->hw);
> +       ieee802154_release_queue(local);
>         atomic_dec(&local->phy->ongoing_txs);
>         kfree_skb(skb);
>         netdev_dbg(dev, "transmission failed\n");
> @@ -75,7 +75,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         }
>
>         /* Stop the netif queue on each sub_if_data object. */
> -       ieee802154_stop_queue(&local->hw);
> +       ieee802154_hold_queue(local);
>         atomic_inc(&local->phy->ongoing_txs);
>
>         /* Drivers should preferably implement the async callback. In some rare
> @@ -99,7 +99,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         return NETDEV_TX_OK;
>
>  err_wake_netif_queue:
> -       ieee802154_wake_queue(&local->hw);
> +       ieee802154_release_queue(local);
>         atomic_dec(&local->phy->ongoing_txs);
>  err_free_skb:
>         kfree_skb(skb);
> diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> index 76dc663e2af4..6176cc40df91 100644
> --- a/net/mac802154/util.c
> +++ b/net/mac802154/util.c
> @@ -13,7 +13,17 @@
>  /* privid for wpan_phys to determine whether they belong to us or not */
>  const void *const mac802154_wpan_phy_privid = &mac802154_wpan_phy_privid;
>
> -void ieee802154_wake_queue(struct ieee802154_hw *hw)
> +/**
> + * ieee802154_wake_queue - wake ieee802154 queue
> + * @local: main mac object
> + *
> + * Tranceivers usually have either one transmit framebuffer or one framebuffer
> + * for both transmitting and receiving. Hence, the core currently only handles
> + * one frame at a time for each phy, which means we had to stop the queue to
> + * avoid new skb to come during the transmission. The queue then needs to be
> + * woken up after the operation.
> + */
> +static void ieee802154_wake_queue(struct ieee802154_hw *hw)
>  {
>         struct ieee802154_local *local = hw_to_local(hw);
>         struct ieee802154_sub_if_data *sdata;
> @@ -27,9 +37,18 @@ void ieee802154_wake_queue(struct ieee802154_hw *hw)
>         }
>         rcu_read_unlock();
>  }
> -EXPORT_SYMBOL(ieee802154_wake_queue);
>
> -void ieee802154_stop_queue(struct ieee802154_hw *hw)
> +/**
> + * ieee802154_stop_queue - stop ieee802154 queue
> + * @local: main mac object
> + *
> + * Tranceivers usually have either one transmit framebuffer or one framebuffer
> + * for both transmitting and receiving. Hence, the core currently only handles
> + * one frame at a time for each phy, which means we need to tell upper layers to
> + * stop giving us new skbs while we are busy with the transmitted one. The queue
> + * must then be stopped before transmitting.
> + */
> +static void ieee802154_stop_queue(struct ieee802154_hw *hw)
>  {
>         struct ieee802154_local *local = hw_to_local(hw);
>         struct ieee802154_sub_if_data *sdata;
> @@ -43,14 +62,33 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw)
>         }
>         rcu_read_unlock();
>  }
> -EXPORT_SYMBOL(ieee802154_stop_queue);
> +
> +void ieee802154_hold_queue(struct ieee802154_local *local)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&local->phy->queue_lock, flags);
> +       ieee802154_stop_queue(&local->hw);
> +       atomic_inc(&local->phy->hold_txs);
> +       spin_unlock_irqrestore(&local->phy->queue_lock, flags);
> +}

I think that works, but I would expect something like:

if (!atomic_fetch_inc(hold_txs))
      ieee802154_stop_queue(&local->hw);

- Alex

