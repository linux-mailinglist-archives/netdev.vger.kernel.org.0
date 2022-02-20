Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D134BD2BF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 00:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245247AbiBTXtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:49:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiBTXtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:49:41 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9F64133B;
        Sun, 20 Feb 2022 15:49:19 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id u20so15508915lff.2;
        Sun, 20 Feb 2022 15:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+Wt+U09pMGd7NB+8zPGdBBX5dtKvusDtPHAdgAqVss=;
        b=LSjmopzb7FGHRk9za/tw68DczF0caXJrN3LVRsBs5vBGV5AvSIo0cZHwDfhN+sJfo+
         E0qVy1Qh8+OTwvPV+Xr0OUTaaNd34tPxErVh4D9yyAEeUr36rKAxEfSjXX5Ves4oHWsv
         lAvq2QJg2Lrk85Ge+UDM8sL7GEM7PEDd/vF0JfPWNhpXT6JrLd618/kfYhlUwze25EVd
         wn4XtOq9RQUkuw+4zUAGy9zZLQVDUKLZAgHxBBa58LzW2k78KUIurdIGngtlDsL8X/yJ
         AAN2c/SK+15s9lfZ9IIUsh3azeMTVohsAH/2xySN5pPOz15Q/WAAAzQXdsooBhlgYnKd
         H41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+Wt+U09pMGd7NB+8zPGdBBX5dtKvusDtPHAdgAqVss=;
        b=mgudXnogX8Bd2y3MnJ9uanADcjil6qEn8PV8qVAydXjGfG6iS5Y0WpKxSi80qPqBbz
         Fu2CHsAOgU54qUD122hPoCZP5msimwVS4M6CowzC3JO+ABjfgHbpIZ5RHwOIShAM5l6/
         RJBQpoNlQCwceZckcXZX1qpRvOCzuGKlHU8sjuXtvKGpKYW3khgOC9T7oJkeULvCn4XY
         lV189+6nRd7hA4X9XjN2haRL4wu9lc6YVw5X0RNylSRETz1sNoO0DERsSOA7QN1/0lv0
         8B+OltgnOzvPShQSKIeo1Za/1lXQDLTo79TDYE3rPpmar+tenQBYBvVHv+5ECekY7E+g
         lwCQ==
X-Gm-Message-State: AOAM531qFFLgm89KAouH28Gs/f2nXBf0s6IXRHG72XgcPf6qpTeCY6CA
        XvQQi49CY+4Qmi5V34mdx4UoueSa3+CDJNk2vvk=
X-Google-Smtp-Source: ABdhPJzXkZvME6C1yW+nn6zzddCsVcpA3j+yNQORv5RUo4wNPA8sTPuv84lRyS7Ly12e59HV/4zQ/4bvvEMfMdRU/Vo=
X-Received: by 2002:a05:6512:1194:b0:43e:8e84:4eca with SMTP id
 g20-20020a056512119400b0043e8e844ecamr11879520lfr.611.1645400957725; Sun, 20
 Feb 2022 15:49:17 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com> <20220207144804.708118-14-miquel.raynal@bootlin.com>
In-Reply-To: <20220207144804.708118-14-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 20 Feb 2022 18:49:06 -0500
Message-ID: <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue
 flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
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
>  net/mac802154/cfg.c          |  5 ++---
>  net/mac802154/ieee802154_i.h |  1 +
>  net/mac802154/tx.c           | 11 ++++++++++-
>  net/mac802154/util.c         |  3 ++-
>  6 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 043d8e4359e7..0d385a214da3 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -217,6 +217,7 @@ struct wpan_phy {
>         /* Transmission monitoring and control */
>         atomic_t ongoing_txs;
>         atomic_t hold_txs;
> +       wait_queue_head_t sync_txq;
>
>         char priv[] __aligned(NETDEV_ALIGN);
>  };
> diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
> index de259b5170ab..0953cacafbff 100644
> --- a/net/ieee802154/core.c
> +++ b/net/ieee802154/core.c
> @@ -129,6 +129,7 @@ wpan_phy_new(const struct cfg802154_ops *ops, size_t priv_size)
>         wpan_phy_net_set(&rdev->wpan_phy, &init_net);
>
>         init_waitqueue_head(&rdev->dev_wait);
> +       init_waitqueue_head(&rdev->wpan_phy.sync_txq);
>
>         return &rdev->wpan_phy;
>  }
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index e8aabf215286..da94aaa32fcb 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
>         if (!local->open_count)
>                 goto suspend;
>
> -       atomic_inc(&wpan_phy->hold_txs);
> -       ieee802154_stop_queue(&local->hw);
> +       ieee802154_sync_and_stop_tx(local);
>         synchronize_net();
>
>         /* stop hardware - this must stop RX */
> @@ -73,7 +72,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
>                 return ret;
>
>  wake_up:
> -       if (!atomic_dec_and_test(&wpan_phy->hold_txs))
> +       if (!atomic_read(&wpan_phy->hold_txs))
>                 ieee802154_wake_queue(&local->hw);
>         local->suspended = false;
>         return 0;
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index 56fcd7ef5b6f..295c9ce091e1 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -122,6 +122,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
> +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index abd9a057521e..06ae2e6cea43 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -47,7 +47,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
>                 ieee802154_wake_queue(&local->hw);
>
>         kfree_skb(skb);
> -       atomic_dec(&local->phy->ongoing_txs);
> +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> +               wake_up(&local->phy->sync_txq);
>         netdev_dbg(dev, "transmission failed\n");
>  }
>
> @@ -117,6 +118,14 @@ ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         return ieee802154_tx(local, skb);
>  }
>
> +void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
> +{
> +       atomic_inc(&local->phy->hold_txs);
> +       ieee802154_stop_queue(&local->hw);
> +       wait_event(local->phy->sync_txq, !atomic_read(&local->phy->ongoing_txs));
> +       atomic_dec(&local->phy->hold_txs);

In my opinion this _still_ races as I mentioned earlier. You need to
be sure that if you do ieee802154_stop_queue() that no ieee802154_tx()
or hot_tx() is running at this time. Look into the function I
mentioned earlier "?netif_tx_disable()?".

- Alex
