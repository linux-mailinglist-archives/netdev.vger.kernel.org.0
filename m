Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE34BD2A0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 00:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbiBTXcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBTXcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:32:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97F74E32
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 15:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645399916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VVO3Rr5UL6iYYrvPBeDVyYAqqdU9yg9+wE39qf4x+gg=;
        b=HNKve/4brwbz2Qf4yzm+dT+6WXC9vj+P71Fy4BUxfzZCAmrVd/HZK3RlBwTyCVPcuOfz6W
        G7GeJUg9o6MA51fKfXjCc4XhOloJb5YjNtkuCwuVkjnsEGUFMIQkkko0PYh3K9dLE+FtMF
        175uW636QX9QjrSq4qIP9rx/M/Z4G5Y=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-L_rrFeNGOvinqrwoNRoQSw-1; Sun, 20 Feb 2022 18:31:55 -0500
X-MC-Unique: L_rrFeNGOvinqrwoNRoQSw-1
Received: by mail-qv1-f70.google.com with SMTP id jv14-20020a05621429ee00b004300c413db6so15235966qvb.1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 15:31:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VVO3Rr5UL6iYYrvPBeDVyYAqqdU9yg9+wE39qf4x+gg=;
        b=kyUffUY5tSBjAsMWFbd5FXUcBHn6OiZgK8LBDLYMRomYkSEvB6qNcuOeJMqk5iQ4g4
         2Me8J+28vXMdlLBBUgdlXTRqHVokvl7ltgGlR6+F3B3RSPiQT7t11vY0HGKJxU0c9IxB
         Yut6z+H+rZm5Zn/iM1uxPnOsZZGVCEkAQvIcZH5VEbHpJqLXcE/voQWdLShSYKnlgGtV
         kmQOADSsUuwmJ3/4oL8Df82aH1qR9ZpaJzqxw9iPrInU9RQlMKLWP9JGn1CGuOgFafOP
         r/zkE45XDLDbreppZZrdhX0m+UnNsXbJ7uK81z2taJywnNc9R/AJt+kyDryMVjtqBXiD
         XsJw==
X-Gm-Message-State: AOAM531qyaLFxGJWd4MHKIY9400FF4URLXP4im8y5i816NZoLE0F1zZP
        kHXdNtB0e6thKAVB/JsTRBZXWwCB4zuEyV79/sZEk32vANkvx45azKJ8oxyDYg6YpIw9EMcY+0t
        WHVCvw47dBWDA0WVrujeUhrzfqnTzqqTB
X-Received: by 2002:a05:622a:203:b0:2de:64f:6231 with SMTP id b3-20020a05622a020300b002de064f6231mr4621761qtx.291.1645399915104;
        Sun, 20 Feb 2022 15:31:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzY5mlnz93c/O6ggm+6il/aGAitsw1Yo+ElFz2WJUfVeaOm8nXDWUTWhwt8bbPMREushrAJPIBViuN7bt6Mxpk=
X-Received: by 2002:a05:622a:203:b0:2de:64f:6231 with SMTP id
 b3-20020a05622a020300b002de064f6231mr4621739qtx.291.1645399914877; Sun, 20
 Feb 2022 15:31:54 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com> <20220207144804.708118-3-miquel.raynal@bootlin.com>
In-Reply-To: <20220207144804.708118-3-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 20 Feb 2022 18:31:44 -0500
Message-ID: <CAK-6q+iebK43LComxxjvg0pBiD_AK0MMyMucLHmeVG2zbHPErQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 02/14] net: mac802154: Create a transmit
 error helper
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

On Mon, Feb 7, 2022 at 10:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> So far there is only a helper for successful transmission, which led
> device drivers to implement their own handling in case of
> error. Unfortunately, we really need all the drivers to give the hand
> back to the core once they are done in order to be able to build a
> proper synchronous API. So let's create a _xmit_error() helper.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  include/net/mac802154.h | 10 ++++++++++
>  net/mac802154/util.c    | 10 ++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index 2c3bbc6645ba..9fe8cfef1ba0 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -498,4 +498,14 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
>  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
>                               bool ifs_handling);
>
> +/**
> + * ieee802154_xmit_error - frame transmission failed
> + *
> + * @hw: pointer as obtained from ieee802154_alloc_hw().
> + * @skb: buffer for transmission
> + * @ifs_handling: indicate interframe space handling
> + */
> +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> +                          bool ifs_handling);
> +
>  #endif /* NET_MAC802154_H */
> diff --git a/net/mac802154/util.c b/net/mac802154/util.c
> index 6f82418e9dec..9016f634efba 100644
> --- a/net/mac802154/util.c
> +++ b/net/mac802154/util.c
> @@ -102,6 +102,16 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(ieee802154_xmit_complete);
>
> +void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
> +                          bool ifs_handling)
> +{
> +       unsigned int skb_len = skb->len;
> +
> +       dev_kfree_skb_any(skb);
> +       ieee802154_xmit_end(hw, ifs_handling, skb_len);
> +}

Remove ieee802154_xmit_end() function and just call to wake up the
queue here, also drop the "ifs_handling" parameter here.

- Alex

