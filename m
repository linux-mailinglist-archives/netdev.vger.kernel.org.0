Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0129D4BD2CF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 01:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiBTXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:53:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBTXxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:53:30 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD312AE16;
        Sun, 20 Feb 2022 15:53:04 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id p20so3839134ljo.0;
        Sun, 20 Feb 2022 15:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=27AGmAa3udM5tBlxi5FVJ+hzb+9/4pSfsBoqJMjHxEU=;
        b=bD3F93OrhMNU2ydFH8XSS57YAe/sX8cQnkyUI22TCiyxa4zdiqKXID1S3jdfp21diG
         AdQj3zXrS4QUS0FLgKUy/R+sboM7qFLn9wtmq0sUWQ+p/ikNueoaj2C07HJ/dWDGrLL5
         LvDO3orzfJL2DgLT/WJcubPFlkzvzAnm73RkN+VNJZ5AEKXfEBTM2PJIJuf//fvmAeg9
         RQnIfvWrdr1OovkRz2hhTWEx7ih1lSwwRYkGFJEJRg/S730Otap0Grd9gY9KVVDaLi0Q
         GWvEib9nRdt0aiGklwy4xxrDtn0Te1zujCr3NsLLm7Pj92GtWqARp2Q6ddHrpVwAKOWU
         wrlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=27AGmAa3udM5tBlxi5FVJ+hzb+9/4pSfsBoqJMjHxEU=;
        b=pzls5Wjmc/xg9m9uLkCb/o8UtVMmLnEzNFGSDbe4XY0kqV2FOEQrV2Vxb5StLWRXzo
         7d77+sfQGj5/9nJDQWHoXusIVb0F9OEKIOwcsabArVIJ5JeGQxuXqjV7FfbXweHHTwjl
         5+KWFMIxVUig+Kv8nD/1HGVeFS0J/mASrEeufaoFORAldZzrj1VKh6ZB2PA/vMHGV1Be
         jRmsxyywUmCGeAWjNQ88c5jSNg7XpxAdpG38QyEBzun57zuO/fyWCUEOZf1SfgHbGgNU
         Lu0fOMwB/kkpcAsCUhYKvindhTwLQ3ur79+h2lCdqZ0qeDK5FadueHtYMeXU6tKqy3pw
         Eq3A==
X-Gm-Message-State: AOAM530Dv1sylgrSl6whp0481d3b7soQZSO8/YmE+DiW0VvOIXspLylI
        IU8LmffowhC6WEy7xFvayZ2QD110RxLhJftoiUo=
X-Google-Smtp-Source: ABdhPJwPrKzVerEoO9CIdu+YACJNX8schLeJBl4+SGTGYvthT9GJ1zVgbShK5E/V8tS0epiCP8+sECHn6glvbGsVUmk=
X-Received: by 2002:a2e:b16e:0:b0:244:d368:57e with SMTP id
 a14-20020a2eb16e000000b00244d368057emr12860468ljm.251.1645401183051; Sun, 20
 Feb 2022 15:53:03 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com> <20220207144804.708118-15-miquel.raynal@bootlin.com>
In-Reply-To: <20220207144804.708118-15-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 20 Feb 2022 18:52:51 -0500
Message-ID: <CAB_54W45p6e5sY6O=yHq39vsN+h_Yi6e9=GGky+1vO_H3oUj9A@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 14/14] net: mac802154: Introduce a
 synchronous API for MLME commands
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
> This is the slow path, we need to wait for each command to be processed
> before continuing so let's introduce an helper which does the
> transmission and blocks until it gets notified of its asynchronous
> completion. This helper is going to be used when introducing scan
> support.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/ieee802154_i.h | 1 +
>  net/mac802154/tx.c           | 6 ++++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index 295c9ce091e1..ad76a60af087 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -123,6 +123,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
>  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
>  void ieee802154_xmit_sync_worker(struct work_struct *work);
>  void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
> +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
>  netdev_tx_t
>  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  netdev_tx_t
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 06ae2e6cea43..7c281458942e 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -126,6 +126,12 @@ void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
>         atomic_dec(&local->phy->hold_txs);
>  }
>
> +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> +{
> +       ieee802154_tx(local, skb);
> +       ieee802154_sync_and_stop_tx(local);

Some of those functions can fail, in async case we can do some stats
but here we can deliver the caller an error. Please do so.

- Alex
