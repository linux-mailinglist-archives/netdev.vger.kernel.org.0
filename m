Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007215759E1
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 05:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbiGODQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 23:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiGODQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 23:16:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A8CC76972
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 20:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657855012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmtcGMfYg686hXvrQqOUlaN04B2am1yWRAo3lh34hGg=;
        b=GxkM1zd7MRzBdfWeToLbr9ZHk+BPN2T72f3eLZMx8vcdkBq4cfizTPPFPutMnkQXkt/q0f
        tAr8GF0K89ChLOn+X6I9QcXw0768KND/R/UWOUHN5dxUZIuS9mS1dMIqkBaWpelx+ff4/A
        3tsqbhdLsMHqYTPNHquZA1aHToXFTcI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-seSB8MQ5Nj6PlZAcFje4lA-1; Thu, 14 Jul 2022 23:16:45 -0400
X-MC-Unique: seSB8MQ5Nj6PlZAcFje4lA-1
Received: by mail-qv1-f72.google.com with SMTP id m11-20020a0cfbab000000b004738181b474so2402763qvp.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 20:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmtcGMfYg686hXvrQqOUlaN04B2am1yWRAo3lh34hGg=;
        b=eiFeo0v5mEFHpNsj8ZoUbjslSs1hJpIGqVM3Yx4Hqhm5p63IvfzzdzzQSvTBZvB6z5
         +DmqZw7oxTr5W8FhtRCjzLH+WLkscWyilFSwq+uuSGOEhEctlveDnyAlrev5h/M9I66C
         NYXVCm+O8IK2I0AniDVBf3u5VV5y/VbDM4cN6QLZKnlLY1gGBM7v2/dzm3oxhPKLKdQf
         reI26bPKodRu/3ymAcHH3S+s3nP23KDfySGmkhiTqK1A5CXZDNbeUGqO1kBkg3xqBK6W
         Ax4s1sjlQ0kjWrs4fwiEZ/5SsOjnRW/cvaMUqbd8TZNKwAWIztVmW75YzIxKKJIqBz7w
         P0YQ==
X-Gm-Message-State: AJIora8eiiQQEwyVXAqjeszqYt+Wu2rMXFxIqAUP3Iik2xOVcHJGMRvd
        NKGXZkq/fGlAKqXBHXGk5tWXoL+w4UYmm7rbA2BgBW9qRhRGD4qFb/Gh+e5v9A3Q6pZXGdQk4lD
        +Ii9Ym61zxpwfMTs2HI9pzz8gQEgOiUsP
X-Received: by 2002:ac8:5c12:0:b0:31e:9f86:1632 with SMTP id i18-20020ac85c12000000b0031e9f861632mr10533979qti.123.1657855005142;
        Thu, 14 Jul 2022 20:16:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usvWSZwU0LBvK4kfhxb45xCglRan9aFm84Ll3MKaEwQJs2VIX0cV84ZnYu2J83th6F1f9wzt7x+RIU9SfIcdY=
X-Received: by 2002:ac8:5c12:0:b0:31e:9f86:1632 with SMTP id
 i18-20020ac85c12000000b0031e9f861632mr10533966qti.123.1657855004896; Thu, 14
 Jul 2022 20:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com> <20220701143052.1267509-18-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-18-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 14 Jul 2022 23:16:33 -0400
Message-ID: <CAK-6q+ifj5DNrq31qjjyk3OoAsf0+LuBttM5o8Rs8Pt_TA_JMg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 17/20] net: ieee802154: Handle limited devices
 with only datagram support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Some devices, like HardMAC ones can be a bit limited in the way they
> handle mac commands. In particular, they might just not support it at
> all and instead only be able to transmit and receive regular data
> packets. In this case, they cannot be used for any of the internal
> management commands that we have introduced so far and must be flagged
> accordingly.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/cfg802154.h   | 3 +++
>  net/ieee802154/nl802154.c | 6 ++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> index d6ff60d900a9..20ac4df9dc7b 100644
> --- a/include/net/cfg802154.h
> +++ b/include/net/cfg802154.h
> @@ -178,12 +178,15 @@ wpan_phy_cca_cmp(const struct wpan_phy_cca *a, const struct wpan_phy_cca *b)
>   *     setting.
>   * @WPAN_PHY_FLAG_STATE_QUEUE_STOPPED: Indicates that the transmit queue was
>   *     temporarily stopped.
> + * @WPAN_PHY_FLAG_DATAGRAMS_ONLY: Indicates that transceiver is only able to
> + *     send/receive datagrams.
>   */
>  enum wpan_phy_flags {
>         WPAN_PHY_FLAG_TXPOWER           = BIT(1),
>         WPAN_PHY_FLAG_CCA_ED_LEVEL      = BIT(2),
>         WPAN_PHY_FLAG_CCA_MODE          = BIT(3),
>         WPAN_PHY_FLAG_STATE_QUEUE_STOPPED = BIT(4),
> +       WPAN_PHY_FLAG_DATAGRAMS_ONLY    = BIT(5),
>  };
>
>  struct wpan_phy {
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 00b03c33e826..b31a0bd36b08 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1404,6 +1404,9 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
>         if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
>                 return -EPERM;
>
> +       if (wpan_phy->flags & WPAN_PHY_FLAG_DATAGRAMS_ONLY)
> +               return -EOPNOTSUPP;
> +

for doing a scan it's also required to turn the transceiver into
promiscuous mode, right?

There is currently a flag if a driver supports promiscuous mode or
not... I am not sure if all drivers have support for it. For me it
looks like a mandatory feature but I am not sure if every driver
supports it.
We have a similar situation with acknowledge retransmit handling...
some transceivers can't handle it and for normal dataframes we have a
default behaviour that we don't set it. However sometimes it's
required by the spec, then we can't do anything here.

I think we should check on it but we should plan to drop this flag if
promiscuous mode is supported or not. I also think that the
promiscuous driver_ops should be removed and moved as a parameter for
start() driver_ops to declare which "receive mode" should be
enabled... but we can do that in due course.

- Alex

