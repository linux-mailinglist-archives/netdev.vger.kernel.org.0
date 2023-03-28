Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010246CBCD6
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 12:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjC1KtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 06:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjC1KtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 06:49:10 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23DA6183;
        Tue, 28 Mar 2023 03:49:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A5429240002;
        Tue, 28 Mar 2023 10:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680000547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YcAVZxrol8sJCDpLcTmeIdWOWavc1Uiq8RyPwQ5WwwE=;
        b=md988PTmh5TlAklTAHKZjQyEBHowcSxi5+GbphBOtqRbyFiG0KziKyv+ykf3lBl3tLEVcz
        FTYP/ojqNXXOIZ1HD8ChM4f2A0kp1qnOjLnOdGh61r0ecwlQzvK93aINomHWm1GfcU76IA
        EtNI9Wi2fHwEDXkPVttytjNgB9j9Ka3zTit/THwB5di9o5Spn4FlDQw9QE/Q/J38Ikoprw
        v1EdOMPNOi9NJ/AWbVizUIU91pMDFeFVCQyTi1CicdSmITSVNJ0zP/0YCjJfvjfFS8cSbs
        2tdopXaYj62KoOO9pJrddI+ciTSsM0HmK/q/3lglJtPwBIM6+ZNGs/0mLzCnIw==
Date:   Tue, 28 Mar 2023 12:48:59 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH 07/12] net: ieee802154: adf7242: drop of_match_ptr for
 ID table
Message-ID: <20230328124859.12f3c329@xps-13>
In-Reply-To: <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
        <20230311173303.262618-7-krzysztof.kozlowski@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

krzysztof.kozlowski@linaro.org wrote on Sat, 11 Mar 2023 18:32:58 +0100:

> The driver will match mostly by DT table (even thought there is regular
> ID table) so there is little benefit in of_match_ptr (this also allows
> ACPI matching via PRP0001, even though it might not be relevant here).
>=20
>   drivers/net/ieee802154/adf7242.c:1322:34: error: =E2=80=98adf7242_of_ma=
tch=E2=80=99 defined but not used [-Werror=3Dunused-const-variable=3D]
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

I see Stefan already acked most of the ieee802154 patches, but I didn't
got notified for this one, so in case:

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/ad=
f7242.c
> index 5cf218c674a5..509acc86001c 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1336,7 +1336,7 @@ MODULE_DEVICE_TABLE(spi, adf7242_device_id);
>  static struct spi_driver adf7242_driver =3D {
>  	.id_table =3D adf7242_device_id,
>  	.driver =3D {
> -		   .of_match_table =3D of_match_ptr(adf7242_of_match),
> +		   .of_match_table =3D adf7242_of_match,
>  		   .name =3D "adf7242",
>  		   .owner =3D THIS_MODULE,
>  		   },


Thanks,
Miqu=C3=A8l
