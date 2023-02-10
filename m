Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F63692286
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjBJPn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjBJPn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:43:56 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7515EA37;
        Fri, 10 Feb 2023 07:43:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id pj3so5583044pjb.1;
        Fri, 10 Feb 2023 07:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IVFNeMfOmmqZLaGBTDvOV9DdgTvmZraVnEzcOu9bPQI=;
        b=UsXru1m9OexHt9h15jTb85lNc48MbfJInoGvlXYiSdcg0ZFdYA9MKfH8FEL2CP9Hh2
         q5vvMEeeng6rBW4q5Hifgkh0n+C/vlfeGMQJDQAauquv1LizIpLPMK9ZEnvmb31Qf2xv
         qwd9I8QjFWf90AFlwJSo6Olqp9evdSEzn/EBmPrNSSeU9JTVEJ2p8ulQSB7Qa7QwoN5p
         l3SqtWBBfnxMuDOlH2qR2PUSEIn/uIcnX6PH/rxoHASQorAT464FELt4Q3nLjWDaTl00
         sSLKsLCQcrHwiK6xvS5zOCYP/9UvQIzuoDNzLuuAqNPPKWmD8oYeOsNn4zoFhSnel97o
         CZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IVFNeMfOmmqZLaGBTDvOV9DdgTvmZraVnEzcOu9bPQI=;
        b=KAmI9ZRAwcXS5OMr6rNGo+7nmEfm95FEDc3F2NHPHI2hmjYTPFxWA+WIqzPy7zm0th
         rm9gyyR52VDBRCnram/WG/SKOd589THyoS3cdJaQQwhupHCCpEEze4qYReY/tVf7TT6i
         AKLfhkOXwIhgBi1l8VhLaRBvmdNHzHnc2EkJgnWDC3jv/poPQRjaj8K8hyx6DfJJOw7h
         CC6LGlpRYWE4kSMd4Iae4tANIfsabLEtiD2WH1TFs9k16tY4NzF/AMIha1jODLHD2b4p
         Q2E0KTBUdtxd9B3977hqA9XMw0mk9/LbOxpAaJZz9MhAlt24T9RXihRZz43ddFGmJG7d
         jTTQ==
X-Gm-Message-State: AO0yUKV0GASMsWdmiN7Bqps/idtDJ7En7hL3QqIK5/rtM+rJ9PjA8PM9
        N0KBtRloO2VEevWC8CihRZU=
X-Google-Smtp-Source: AK7set+J4S/I4aGkeSswQLaN2/hAHfiKwDcF2uOq5gSNsP1uucdJTPO7G2kwFWZB7H9wt9YBQJJvPw==
X-Received: by 2002:a17:902:f1d1:b0:199:53bf:a2d8 with SMTP id e17-20020a170902f1d100b0019953bfa2d8mr6407039plc.4.1676043834648;
        Fri, 10 Feb 2023 07:43:54 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id 13-20020a170902c24d00b00198c41d0c86sm3569691plg.239.2023.02.10.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:43:54 -0800 (PST)
Message-ID: <826cc9912f56dddd3b0bccdaf742167d5006c669.camel@gmail.com>
Subject: Re: [PATCH net-next v7 5/9] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
Date:   Fri, 10 Feb 2023 07:43:51 -0800
In-Reply-To: <20230209095113.364524-6-o.rempel@pengutronix.de>
References: <20230209095113.364524-1-o.rempel@pengutronix.de>
         <20230209095113.364524-6-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-09 at 10:51 +0100, Oleksij Rempel wrote:
> Add replacement for phy_ethtool_get/set_eee() functions.
>=20
> Current phy_ethtool_get/set_eee() implementation is great and it is
> possible to make it even better:
> - this functionality is for devices implementing parts of IEEE 802.3
>   specification beyond Clause 22. The better place for this code is
>   phy-c45.c
> - currently it is able to do read/write operations on PHYs with
>   different abilities to not existing registers. It is better to
>   use stored supported_eee abilities to avoid false read/write
>   operations.
> - the eee_active detection will provide wrong results on not supported
>   link modes. It is better to validate speed/duplex properties against
>   supported EEE link modes.
> - it is able to support only limited amount of link modes. We have more
>   EEE link modes...
>=20
> By refactoring this code I address most of this point except of the last
> one. Adding additional EEE link modes will need more work.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phy-c45.c | 238 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mdio.h      |  58 ++++++++++
>  include/linux/phy.h       |   7 ++
>  include/uapi/linux/mdio.h |   8 ++
>  4 files changed, 311 insertions(+)
>=20
>=20

<...>

> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index e75583f5d967..e3568e44efd0 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -428,6 +428,64 @@ static inline void mii_eee_cap1_mod_linkmode_t(unsig=
ned long *adv, u32 val)
>  			 adv, val & MDIO_EEE_10GKR);
>  }
> =20
> +/**
> + * mii_eee_cap1_mod_linkmode_t
> + * @adv: the linkmode advertisement settings
> + *
> + * A function that translates linkmode to value for IEEE 802.3-2018 45.2=
.7.13
> + * "EEE advertisement 1" register (7.60)
> + */
> +static inline u32 linkmode_to_mii_eee_cap1_t(unsigned long *adv)

So the function comments don't match the name for the function. Perhaps
a copy/paste error? Otherwise the rest of the function description
looks fine.

> +{
> +	u32 result =3D 0;
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, adv))
> +		result |=3D MDIO_EEE_100TX;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, adv))
> +		result |=3D MDIO_EEE_1000T;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseT_Full_BIT, adv))
> +		result |=3D MDIO_EEE_10GT;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT, adv))
> +		result |=3D MDIO_EEE_1000KX;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT, adv))
> +		result |=3D MDIO_EEE_10GKX4;
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, adv))
> +		result |=3D MDIO_EEE_10GKR;
> +
> +	return result;
> +}
> +

