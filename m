Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE95192E7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbiEDAoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbiEDAoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEDDA12092
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 17:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651624832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mLAQfNS9bxV5UUONuHMYWtLooFAoUcb9nN3xkf4uzEs=;
        b=aKpI45a539cEzs1M8RyUhTd+xI75q5Bl4xt/+nb5S6OJNxPtWtU9+lFYgpEZgdoIlWmYFf
        Bgdt1oCOZmfeOMjYlZaH7MJTeH//2tzh7fTGqT7siRU2E9PBEJLACOzPFBL92UynVNqIOF
        j1bciGSqh6va0N8RmevM7qmMwLBmGTA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-mrBtNZN7MAuI5GdBtIFL5w-1; Tue, 03 May 2022 20:40:31 -0400
X-MC-Unique: mrBtNZN7MAuI5GdBtIFL5w-1
Received: by mail-qv1-f72.google.com with SMTP id kl11-20020a056214518b00b0045a9af67efbso3738630qvb.18
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 17:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLAQfNS9bxV5UUONuHMYWtLooFAoUcb9nN3xkf4uzEs=;
        b=lsviVgZB4k+rJg+1Rin4keGyHZ166/JEPhBt8+UVM0QDkXlROLVEb0opVDyEFVlWUu
         CUYMJuM0iRKEW+foeHG1sOQRe+hUA1ZLuucVm7svNAo0otH66afyl6sP0QBphM9bfIVo
         LaGcZX3eWC7zBUW3O4XcHK8BWpSCuG+RJeuMt02JWm09Q0w68W6re00uRUKrPcG8U7q0
         JC0jwRkopvvWW6ZEbCIMmV8IPLz/1HvZInfBCRc3+jA9MY0QS47lzGri/vxbkavetWy9
         qGB+k08rCKzh/MSADKvNmIZlhqW5Odc6Q/VWMxAXTp6AE8/9DtR7+5BlyPRIBKV6qYsi
         JesA==
X-Gm-Message-State: AOAM532RWlgbZic/RZvp+HPNgjcP556pnPFZlEWaaL5i7T5wQEWqN/8d
        REBWxuMsx8Bbb/DGG60Esm1PV43TQ+yP6w1iyjtm72FGYgvuotHg+mGnJQR2ed/OyprmbscB5nd
        om3IIAiFd/2W88rR17NT3PVF9yoTJF5NW
X-Received: by 2002:ac8:7e81:0:b0:2f3:9a1d:3732 with SMTP id w1-20020ac87e81000000b002f39a1d3732mr17256733qtj.339.1651624831089;
        Tue, 03 May 2022 17:40:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmRta/5dz57eHGaZAZaApDGeL8uCIFZvdMqxAsvJ5V/0ZNqBP+vcVj+tL79ZmFnh087L9aAEn5NDrx0Mdy2dw=
X-Received: by 2002:ac8:7e81:0:b0:2f3:9a1d:3732 with SMTP id
 w1-20020ac87e81000000b002f39a1d3732mr17256719qtj.339.1651624830872; Tue, 03
 May 2022 17:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com> <20220427164659.106447-11-miquel.raynal@bootlin.com>
In-Reply-To: <20220427164659.106447-11-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 3 May 2022 20:40:20 -0400
Message-ID: <CAK-6q+gkMbf7HGFWtaB2QX9z10dvbk2ac28to3TMUDS9MdWuvA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 10/11] net: mac802154: Introduce a tx queue
 flushing mechanism
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 27, 2022 at 12:55 PM Miquel Raynal
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
>  net/mac802154/cfg.c          |  3 +--
>  net/mac802154/ieee802154_i.h |  1 +
>  net/mac802154/tx.c           | 24 +++++++++++++++++++++++-
>  net/mac802154/util.c         |  7 +++++--
>  6 files changed, 32 insertions(+), 5 deletions(-)
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
> index 0540a2b014d2..c17e38bef425 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -46,8 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
>         if (!local->open_count)
>                 goto suspend;
>
> -       ieee802154_hold_queue(local);
> -       ieee802154_stop_queue(local);
> +       ieee802154_sync_and_hold_queue(local);
>         synchronize_net();
>
>         /* stop hardware - this must stop RX */
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index c686a027555a..c87c7fa04435 100644
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
> index 021dddfea542..5f94973b57e4 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -45,7 +45,8 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
>         /* Restart the netif queue on each sub_if_data object. */
>         ieee802154_wake_queue(local);
>         kfree_skb(skb);
> -       atomic_dec(&local->phy->ongoing_txs);
> +       if (!atomic_dec_and_test(&local->phy->ongoing_txs))
> +               wake_up(&local->phy->sync_txq);
>         netdev_dbg(dev, "transmission failed\n");
>  }

There is a missing handling of dec() wake_up() in ieee802154_tx()
"err_tx" label.

- Alex

