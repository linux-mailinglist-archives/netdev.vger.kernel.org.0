Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615D7519309
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbiEDAzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240558AbiEDAzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:55:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E8884130D
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 17:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651625506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1XbtzBgsCNIgqsfL6WIx3SWsD0KKMo9JNuYw2HLynG8=;
        b=g/vsgCaIvfuSok8O9oV5I7xF9Gl+6zsy4iY1KKsEiCbXrHMs145Ugkj1I7rlVccgR/8zwP
        ttajgr7z4XqPRw7Alow4jXy03tm9M4U+fzZrkZP29+SN9EHrZFXy2wHs9AF9B9vPNCNcxR
        XR0WCgA9R6d/gp3WivqsLLohSoZG0ZE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-FjFkUAftNuSXtYz1IsKMbA-1; Tue, 03 May 2022 20:51:43 -0400
X-MC-Unique: FjFkUAftNuSXtYz1IsKMbA-1
Received: by mail-qv1-f70.google.com with SMTP id bz15-20020ad44c0f000000b0045641657fd2so14483725qvb.22
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 17:51:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XbtzBgsCNIgqsfL6WIx3SWsD0KKMo9JNuYw2HLynG8=;
        b=Ld6NimjUEWGBLZz8lHKqNA3izHuUSjpMpKPTgt9f9aXUB9QXyVa6lPveydCVfxuOEd
         Hi41IeFDOqXYLhSFSAgji24pT+/pVJTxUbbjOx1Oyz9ZzCe/IYm79tdkinqIY+23MPdU
         06zv8d09fuv6F+GLyQxbY7YyOPOds/zljSyyXlgrCnPJ/y/a+WiGWqiuHL9bkE1GWJlD
         0WXFRto/+cvB3gQXehr//HC1W1odk2h7qMolrP3o3bSzD4m3LA5wCYZyKttOGLUwZbb3
         /QcXZ+wKkPb2NKHLdYU4C81zX2817RpV9eURIPzooM2nmLPgQuR+HmD4Tq+6MaW1yy2B
         n84Q==
X-Gm-Message-State: AOAM531IF/orYrjAkt98XppytOysT4kxb258BbJph4XZBAkXtEFp3Lpt
        FtJKIRy9tDFEJ66l5N/B2JqRIsYiPPrTE0eW21tIIu4KJeqYrh/jW4wjL1RKsmTbv9Tyo8aY12a
        Ro9mbG/HZJlU4vvjVGqFMxdBulTH7kc8W
X-Received: by 2002:a37:350:0:b0:69f:8c4e:9fa5 with SMTP id 77-20020a370350000000b0069f8c4e9fa5mr14244658qkd.770.1651625502914;
        Tue, 03 May 2022 17:51:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8+HxR7idfgUwM1OvxIgZU5AqDKEKFYmEoLg7WmqW9ChXwV6oPblakSQGw+8P0A2HSCs2G1HhPPMggSylg0iA=
X-Received: by 2002:a37:350:0:b0:69f:8c4e:9fa5 with SMTP id
 77-20020a370350000000b0069f8c4e9fa5mr14244646qkd.770.1651625502709; Tue, 03
 May 2022 17:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com> <20220427164659.106447-7-miquel.raynal@bootlin.com>
In-Reply-To: <20220427164659.106447-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 3 May 2022 20:51:32 -0400
Message-ID: <CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 06/11] net: mac802154: Hold the transmit queue
 when relevant
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 27, 2022 at 12:54 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Let's create a hold_txs atomic variable and increment/decrement it when
> relevant. Currently we can use it during a suspend. Very soon we will
> also use this feature during scans.
>
> When the variable is incremented, any further wake up call will be
> skipped until the variable gets decremented back.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h      |  3 ++-
>  net/mac802154/cfg.c          |  2 ++
>  net/mac802154/ieee802154_i.h | 24 ++++++++++++++++++++++++
>  net/mac802154/tx.c           | 15 +++++++++++++++
>  net/mac802154/util.c         |  3 +++
>  5 files changed, 46 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index 473ebcb9b155..043d8e4359e7 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -214,8 +214,9 @@ struct wpan_phy {
>         /* the network namespace this phy lives in currently */
>         possible_net_t _net;
>
> -       /* Transmission monitoring */
> +       /* Transmission monitoring and control */
>         atomic_t ongoing_txs;
> +       atomic_t hold_txs;
>
>         char priv[] __aligned(NETDEV_ALIGN);
>  };
> diff --git a/net/mac802154/cfg.c b/net/mac802154/cfg.c
> index dafe02548161..0540a2b014d2 100644
> --- a/net/mac802154/cfg.c
> +++ b/net/mac802154/cfg.c
> @@ -46,6 +46,7 @@ static int ieee802154_suspend(struct wpan_phy *wpan_phy)
>         if (!local->open_count)
>                 goto suspend;
>
> +       ieee802154_hold_queue(local);
>         ieee802154_stop_queue(local);
>         synchronize_net();
>
> @@ -72,6 +73,7 @@ static int ieee802154_resume(struct wpan_phy *wpan_phy)
>                 return ret;
>
>  wake_up:
> +       ieee802154_release_queue(local);
>         ieee802154_wake_queue(local);
>         local->suspended = false;
>         return 0;
> diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> index 3f59a291b481..b55fdefb0b34 100644
> --- a/net/mac802154/ieee802154_i.h
> +++ b/net/mac802154/ieee802154_i.h
> @@ -142,6 +142,30 @@ enum hrtimer_restart ieee802154_xmit_ifs_timer(struct hrtimer *timer);
>   */
>  void ieee802154_wake_queue(struct ieee802154_local *local);
>
> +/**
> + * ieee802154_hold_queue - hold ieee802154 queue
> + * @local: main mac object
> + *
> + * Hold a queue, this queue cannot be woken up while this is active.
> + */
> +void ieee802154_hold_queue(struct ieee802154_local *local);
> +
> +/**
> + * ieee802154_release_queue - release ieee802154 queue
> + * @local: main mac object
> + *
> + * Release a queue which is held. The queue can now be woken up.
> + */
> +void ieee802154_release_queue(struct ieee802154_local *local);
> +
> +/**
> + * ieee802154_queue_is_held - checks whether the ieee802154 queue is held
> + * @local: main mac object
> + *
> + * Checks whether the queue is currently held.
> + */
> +bool ieee802154_queue_is_held(struct ieee802154_local *local);
> +
>  /**
>   * ieee802154_stop_queue - stop ieee802154 queue
>   * @local: main mac object
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index 8c0bad7796ba..d088aa8119e8 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
> @@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
>         return NETDEV_TX_OK;
>  }
>
> +void ieee802154_hold_queue(struct ieee802154_local *local)
> +{
> +       atomic_inc(&local->phy->hold_txs);
> +}
> +
> +void ieee802154_release_queue(struct ieee802154_local *local)
> +{
> +       atomic_dec(&local->phy->hold_txs);
> +}
> +
> +bool ieee802154_queue_is_held(struct ieee802154_local *local)
> +{
> +       return atomic_read(&local->phy->hold_txs);
> +}

I am not getting this, should the release_queue() function not do
something like:

if (atomic_dec_and_test(hold_txs))
      ieee802154_wake_queue(local);

I think we don't need the test of "ieee802154_queue_is_held()" here,
then we need to replace all stop_queue/wake_queue with hold and
release?

- Alex

