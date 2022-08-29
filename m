Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41355A404B
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 02:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiH2AQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 20:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH2AQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 20:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEFB2A970
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 17:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661732193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzkAkorlo+AmttOHZ6iqjGEde1HkM0doNAcGjEIWZ4o=;
        b=UgpOLiMhLm2QiGP+kik5FokYWZQ1uJ1WpQDfo48pGtywOBFSlIoE9dSHfe5MF7kkMQBTHX
        mD8j5H9RhR3KCERfymdZbohYQHYfd8MsmnsTQVkKzepZL71wJM4zEVLwtiGWSHDf7lt+7L
        2ADqL+jG9ZdD+Oa/6IcqDLgNdfo5xJY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-39-G_VFmnrOPFKLpEq-Cv8rMA-1; Sun, 28 Aug 2022 20:16:32 -0400
X-MC-Unique: G_VFmnrOPFKLpEq-Cv8rMA-1
Received: by mail-qv1-f72.google.com with SMTP id gh7-20020a05621429c700b00496b1a465b1so4132344qvb.5
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 17:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=SzkAkorlo+AmttOHZ6iqjGEde1HkM0doNAcGjEIWZ4o=;
        b=jhS2CB+a6nuhX20w87/qYz2HuVO6hJATJFVvb4sbAR6E2yeczgoSJNA282y3Fyx/fr
         L6eHIeXg2hEgUrGX7ZxhoPHay4mFsoCoNf/6XAqdA3IGa4LxPKxlHutAeoZvskOgohCy
         Zbs6RM4/rqdKLRHZtNW4UBlJje/vE+sWrLIhRp5AY6bIvAxSzfFjQaLxrawrhyvYyKJG
         qUD2YtGxCHNBqJlqh+4km7Q7QmiZeEGHBiuddCgkpg+DcyXR+nAd1Wr0cXdVGuAKa2J/
         pNhNSEuu7f6GDMqE5/GCEa9xUyJ/qEaeyx8s7JcoRpKnBojqIYkF3hQ5EqTtDbuIfReo
         ZDmw==
X-Gm-Message-State: ACgBeo2pNAKOGHXQmbrvIA4NLs9RrkTtFCRfCKhYu8ra7cQQ3dfdWheg
        ImZmkCXPV0Hvx2kp9qsuDpIMnZ9PeKbtFN6tS6xDJ+vFVMYFTYoVdZwTpxEm9JtEzsEtM3/D7D+
        WN68+Vw1dcucnKtwihk48aTdB8ZcmBGjt
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id v2-20020a05622a130200b003448a9d817dmr8364115qtk.339.1661732191499;
        Sun, 28 Aug 2022 17:16:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6YH2nJIo0b6SviiSUMGBKXXeJaHL95jdsa0u6iUg5nlt6EWo3hqWiTPzDu5EZVS+GBLuTCvNVZOaiGzM0z1Ys=
X-Received: by 2002:a05:622a:1302:b0:344:8a9d:817d with SMTP id
 v2-20020a05622a130200b003448a9d817dmr8364092qtk.339.1661732191317; Sun, 28
 Aug 2022 17:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220826142954.254853-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 28 Aug 2022 20:16:20 -0400
Message-ID: <CAK-6q+imPjpBxSZG7e5nxYYgtkrM5pfncxza9=vA+sq+eFQsUw@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 26, 2022 at 10:31 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Upon reception, a packet must be categorized, either it's destination is
> the host, or it is another host. A packet with no destination addressing
> fields may be valid in two situations:
> - the packet has no source field: only ACKs are built like that, we
>   consider the host as the destination.
> - the packet has a valid source field: it is directed to the PAN
>   coordinator, as for know we don't have this information we consider we
>   are not the PAN coordinator.
>
> There was likely a copy/paste error made during a previous cleanup
> because the if clause is now containing exactly the same condition as in
> the switch case, which can never be true. In the past the destination
> address was used in the switch and the source address was used in the
> if, which matches what the spec says.
>
> Cc: stable@vger.kernel.org
> Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/mac802154/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> index b8ce84618a55..c439125ef2b9 100644
> --- a/net/mac802154/rx.c
> +++ b/net/mac802154/rx.c
> @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
>
>         switch (mac_cb(skb)->dest.mode) {
>         case IEEE802154_ADDR_NONE:
> -               if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
> +               if (hdr->source.mode != IEEE802154_ADDR_NONE)
>                         /* FIXME: check if we are PAN coordinator */
>                         skb->pkt_type = PACKET_OTHERHOST;
>                 else


This patch looks okay but it should not be addressed to stable. Leave
of course the fixes tag.

Wpan sends pull requests to net and they have their own way to get
into the stable tree when they are in net.

Thanks.

- Alex

