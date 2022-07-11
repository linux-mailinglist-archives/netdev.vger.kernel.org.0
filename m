Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D5556D2CE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiGKCCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 22:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGKCB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 22:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F15F6DFA0
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657504916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dtGmLvgMVrjBsXPDcs0lR3PF5YdXW4PPSQrac0ALdQg=;
        b=LJA7/91M2t3KW9GiQ9QQJMFdSXEPA0tpODZIlOQ2ZFN1C/kbtMwgqpjHfoIsSe8xHZUv1p
        P1L9oI+0aVDjn9k5VcpxLGyjIp5w2dnPnn77ARqJ1c6aVDb1G8sDyZ/desvUmYGtjs1APr
        26546RTRRL4FmhpTzQPefHuwjhwCMSI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-7pvEkRb_P56vtLNpBTHzJw-1; Sun, 10 Jul 2022 22:01:55 -0400
X-MC-Unique: 7pvEkRb_P56vtLNpBTHzJw-1
Received: by mail-qt1-f199.google.com with SMTP id z14-20020ac8454e000000b0031ead2bfe77so3794074qtn.2
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 19:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtGmLvgMVrjBsXPDcs0lR3PF5YdXW4PPSQrac0ALdQg=;
        b=qkyYEzpc/3woA9yUuL19U6hzGJzp7f47n70j8Ge/8htvf/EkhUxxSgB8yiWOzDIY0b
         31uBjQUNORA7bsYLFXmoio0gUuO8iKIb5jMqrE4FUL7MZ3d/2glyX5jFcWF26vNl3Lyu
         D4yJss+4GIm9rVceRNNGhJ8v/SFGlWBNXIiC5oko5J3L+aS5jGqchJDi5dYC5qiRr/NB
         fwvvZCOGWwPbLpG0WfchK08qfqoOzsA+4//HyOiNG6SeeRoXuyLXOR9DpzzMbrLVTY6a
         YRo43IKcUzYRtkcd589cY/iWssMtuSGzCXspIC8tLiW0vEmc+mYz67enYvqZwjOwfIjw
         vbXg==
X-Gm-Message-State: AJIora8a56o2ew35KaRUXbmxiF1qnQ5Iu1e66G5qz5tlnlKAdU7ZWUiX
        BIJ/j8Uwsc4rh6J7r1YlNtVmXcz/UJjul3EzIVzTaOqmR7aPyyMilZ1RrRDsNPtWUIlJ3wS13Hc
        ylg/Hc8wjTwH1y+UT8LLSja/oCI1YWvoM
X-Received: by 2002:a05:622a:130b:b0:31e:ac55:947f with SMTP id v11-20020a05622a130b00b0031eac55947fmr7143836qtk.339.1657504914541;
        Sun, 10 Jul 2022 19:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s+4QWQAz9S6VUHnnj1EkcpLlFpZLIeLG0B9WpxwYNpoQl4l3EVvNJ4LX0kZkEJHfR5w5Y/o8qC5aPmwpO5N3M=
X-Received: by 2002:a05:622a:130b:b0:31e:ac55:947f with SMTP id
 v11-20020a05622a130b00b0031eac55947fmr7143824qtk.339.1657504914366; Sun, 10
 Jul 2022 19:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com> <20220701143052.1267509-21-miquel.raynal@bootlin.com>
In-Reply-To: <20220701143052.1267509-21-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 10 Jul 2022 22:01:43 -0400
Message-ID: <CAK-6q+hS-6esVw7ebAsr8MoDDsEkorTLKVQupW1xoTZaawCHZA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 20/20] ieee802154: hwsim: Allow devices to be coordinators
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

On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> In order to be able to create coordinator interfaces, we need the
> drivers to advertize that they support this type of interface. Fill in
> the right bit in the hwsim capabilities to allow the creation of these
> coordinator interfaces.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index a5b9fc2fb64c..a678ede07219 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -776,6 +776,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
>         /* 950 MHz GFSK 802.15.4d-2009 */
>         hw->phy->supported.channels[6] |= 0x3ffc00;
>
> +       hw->phy->supported.iftypes |= BIT(NL802154_IFTYPE_COORD);

I think we can do that for more than one driver (except ca8210). What
about the other iftypes?

- Alex

