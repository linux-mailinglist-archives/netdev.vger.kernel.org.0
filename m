Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8D550DCB
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiFTAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 20:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiFTAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 20:25:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A73A7615D
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655684701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=US7qenfy4xTqnJqJ4FXH2SXINmqQKvIojVigmxTRfwY=;
        b=G+pyWdVqAkWrGsZVql4zP8qPfbpQzCGPt+VQwsTAKo++pXluVHaM7Ko21Dzs88IYiBpGhN
        1daWGwiJUmK7V+PQYjUBQDw9nrtaVr49CCsaidfq2lbbqxcNdVCELghvgZ+7e3NgMB5RAT
        41VIEGaMA1ZcXm5jt7MvTcWP+ywuAb0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-2NTj5f-cP1CMK0LjSx-9Cw-1; Sun, 19 Jun 2022 20:25:00 -0400
X-MC-Unique: 2NTj5f-cP1CMK0LjSx-9Cw-1
Received: by mail-qk1-f198.google.com with SMTP id i10-20020a05620a404a00b006a7609f54c6so11449418qko.7
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=US7qenfy4xTqnJqJ4FXH2SXINmqQKvIojVigmxTRfwY=;
        b=hiKf/FX+ptD8jU+HGRAtSKtWrv8RfBx9484qWMVsEJSpMfNY0154RE9R6fORwuRkO5
         llhPqAQwOzomU7h7qeNwEFNTOIMRbS1lQUO2eZ1f1Mqqyk9472uquyQ7dr6ZPgQcX5NE
         wGZB8Gh1wvQ9MbZGPhS7mngBF134/fuFCXvrNbPZ/hVCCnKE31RbaGrgG8idarIOLkvw
         GmoLm0yyYUWhLk4ttsVxr8LULTrLKfyW4HFRCb2PdBtebazDsbehVNwIilGRLe3hxXyG
         VLAK4+CvUdmPhvcUtkO5Z4dUPzZckCv5F5WMebO223du4oRcyBifncqwnToERtROgzHN
         zKiQ==
X-Gm-Message-State: AJIora+hd2l2j3YOSU+uiA2XvpUKxPduaqHkQD3ovaNc6WzI3fZy5zQ1
        I+B/5jVDpepnqzTyn3uKnQYBPCMnfR3Lj7tlJdFRqg/x0/QQArmQThelS4bf5pyMbt8BBatPEMZ
        ZctF11wB22ftfLryfDvurUUAiIF20UU37
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id e18-20020ac85dd2000000b00304ea094688mr18078101qtx.526.1655684699897;
        Sun, 19 Jun 2022 17:24:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v/kJVYb5JelpoZw9BhE31t8P/bFnXcZc6jqa4YRq6VQHrBY7W7uK1bYHZE6SmiWKKJhfLkWdAVk9UE9dYDKMs=
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id
 e18-20020ac85dd2000000b00304ea094688mr18078094qtx.526.1655684699722; Sun, 19
 Jun 2022 17:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com> <20220617193254.1275912-3-miquel.raynal@bootlin.com>
In-Reply-To: <20220617193254.1275912-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 19 Jun 2022 20:24:48 -0400
Message-ID: <CAK-6q+iJaZvtxXsFTPsYyWsDYmKhgVsMHKcDUCrCqmUR2YpEjg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 2/6] net: ieee802154: Ensure only FFDs can
 become PAN coordinators
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

On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> This is a limitation clearly listed in the specification. Now that we
> have device types,let's ensure that only FFDs can become PAN
> coordinators.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/ieee802154/nl802154.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 638bf544f102..0c6fc3385320 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -924,6 +924,9 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
>                         return -EINVAL;
>         }
>
> +       if (type == NL802154_IFTYPE_COORD && !cfg802154_is_ffd(rdev))
> +               return -EINVAL;
> +

Look at my other mail regarding why the user needs to set this device
capability, change the errno to "EOPNOTSUPP"... it would be nice to
have an identically nl80211 handling like nl80211 to see which
interfaces are supported. Please look how wireless is doing that and
probably we should not take the standard about those "wording" too
seriously. What I mean is that according to FFD or RFD it's implied on
what interfaces you can create on.

- Alex

