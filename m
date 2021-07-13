Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3A3C676F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 02:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhGMA2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 20:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhGMA2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 20:28:03 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F25C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 17:25:14 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id v14so177419qtc.8
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 17:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w20DmUyhGwyvm6OG3nMhHQGwJ507eSHhoqM5kvg9RsA=;
        b=kAYRK1NSb+PDjJvOpeyaT3+bJTaQRx5t+5ikdPz7tFL9YEaJ4QempD6HMKateobWFY
         okps/Y26K/uNa21FAHuGj1AydVDvXg+11Gr8EFqmniWH/ZWQzztx8kzJrBfWkS6nh/O/
         Bvg/vUOgSufvLPkArx6aqa5UNgslh/aN7dHZVdh3ZvDAIbKGgVACP3L0bV+jGPtzryV6
         AAncXjd7Vefe9PF5IxvIY5vVx+IV+3PGu74pywcPve4PilGoc0H5YahTdj6iDwdBkhH/
         ILz1rDEvYDUJjTrNPxKvTwQ2zDpWtA3OxToIKEw4ujz7YiIYrjVaCyu099jaGrFv/ATf
         YoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w20DmUyhGwyvm6OG3nMhHQGwJ507eSHhoqM5kvg9RsA=;
        b=TsMRVLfATbv9nUexZNUWq/sjMX9lfPvecfcBAs1BJ89IQY37uLD1p24YsU+GNUwbaD
         AmV4qBkrB7QW1oulQyUj3ImSxmHloEKIrmT+8sWONHctu5GEP4pl0v2UMWyKysWBzIfx
         ufJRKs2VBZIMQSKEb9gOypZSdMxqG8ZToLRZYNfwbfM3+RTVDpPokYRthViJasmS08L5
         TqJ+/HjaiUkbos2umfNJrJP7F1C0KH1u5R2CXfOETCZK1wbm7jROti398vy66oHExvf0
         ZKPia/OJl+GzV83kwqdgyeqp4efWMSH56t3L1A+1bwDHB+2mUJpXuHzOrBwM6goYfuT1
         d6JA==
X-Gm-Message-State: AOAM530x5eS2XJMjM/9UA/QisWGgwCe6OQB7t+4rcrLpJkqe3lNEdrc4
        +Y85vlBms5ei5EH8D7MU6XYH5RuKGB8QASdAVZbdkA==
X-Google-Smtp-Source: ABdhPJzPWa034XkRwg//pBCjxXu5M5VNgmFsdfDouuOwSLkWT3hWBG8JlR7tWzMD7mzfvjmnqUYzmNU5HjyFeghLjpk=
X-Received: by 2002:ac8:5c06:: with SMTP id i6mr1441095qti.343.1626135913802;
 Mon, 12 Jul 2021 17:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <E1m2y9R-0005wP-7n@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1m2y9R-0005wP-7n@rmk-PC.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 13 Jul 2021 02:25:03 +0200
Message-ID: <CAPv3WKf8bYkPTtQ-t7MYcDo1LVsHWA5KPDLsT6sZJmSNRsFJfg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: mvpp2: deny disabling autoneg for
 802.3z modes
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

pon., 12 lip 2021 o 17:47 Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> napisa=C5=82(a):
>
> The documentation for Armada 8040 says:
>
>   Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
>   When <PortType> =3D 1 (1000BASE-X) this field must be set to 1.
>
> We presently ignore whether userspace requests autonegotiation or not
> through the ethtool ksettings interface. However, we have some network
> interfaces that wish to do this. To offer a consistent API across
> network interfaces, deny the ability to disable autonegotiation on
> mvneta hardware when in 1000BASE-X and 2500BASE-X.
>

s/mvneta/mvpp2/

With that change you can add my:
Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin

> This means the only way to switch between 2500BASE-X and 1000BASE-X
> on SFPs that support this will be:
>
>  # ethtool -s ethX advertise 0x20000006000 # 1000BASE-X Pause AsymPause
>  # ethtool -s ethX advertise 0xe000        # 2500BASE-X Pause AsymPause
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> net-next is currently closed, but I'd like to collect acks for this
> patch. Thanks.
>
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 3229bafa2a2c..878fb17dea41 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6269,6 +6269,15 @@ static void mvpp2_phylink_validate(struct phylink_=
config *config,
>                 if (!mvpp2_port_supports_rgmii(port))
>                         goto empty_set;
>                 break;
> +       case PHY_INTERFACE_MODE_1000BASEX:
> +       case PHY_INTERFACE_MODE_2500BASEX:
> +               /* When in 802.3z mode, we must have AN enabled:
> +                * Bit 2 Field InBandAnEn In-band Auto-Negotiation enable=
. ...
> +                * When <PortType> =3D 1 (1000BASE-X) this field must be =
set to 1.
> +                */
> +               if (!phylink_test(state->advertising, Autoneg))
> +                       goto empty_set;
> +               break;
>         default:
>                 break;
>         }
> --
> 2.20.1
>
