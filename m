Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9170E64DE21
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 16:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLOP7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 10:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLOP7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 10:59:01 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEAC26A9F;
        Thu, 15 Dec 2022 07:59:00 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id t18so6967658pfq.13;
        Thu, 15 Dec 2022 07:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k2Ee5Gpf8XLw3DI5K6asWDBHnppcEcpHivWWfeAntMc=;
        b=Ce59VFY4Ap98ol3M5tGauWUvIzpJql2x7ll++zwfZT8dsi0YD99IIw5QY87jM8g31r
         oDfTRfZ8quaPbdcZzN946MeR1semTPerW++YQkZtdQiR/RExuxoUxfLtnhwSkfC3fIre
         Rg2VP4zFWaQJVYwcqCB+zrFTAQ7letbk10S1i7wVjRDlwvoLyJGTrcgHe4860DfPreAb
         GsiCFlXla/pDGyNK3+EZvpuH4BSVlOL71SD1i0IAWXUN2js0jL++9aACDzZsReJd8Riq
         m91+K1T48HpVkIu8ms7DAqIjB3Gl7u6ubw35ri2KJabACW8QtkYimnexY/VBHYMGhBiR
         slbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k2Ee5Gpf8XLw3DI5K6asWDBHnppcEcpHivWWfeAntMc=;
        b=uJsSKdkDuQVZotyIeOpA266rw0FhUji10tk+a7SIvEjwhT/V5HTYvN96j66zaEh2qe
         lxPUJWVs6wwLSGaIcW10uxB7v7T0c493ZUbEd0FhAxADn/quvtEhgLLOer+J1mxHq48f
         nb8FS3FcPqzPEEteiTpEA3hY6uG8h0DegF31fLlb+E5kmDw/te2AU7T1qgJMNbr7tZz9
         w4svEWxEWyNTfOW2j6bMNZsYgnBmsBeUwMq10r1zVJtq0Ert3fuCe81vm/tzSjfJInPa
         D25sSfRn0y/o6UoHil1Dk44RuqH5VdICk5IxtHh8iNWDgczny/HpD4ClnTEOa9N/ulzS
         MnGA==
X-Gm-Message-State: ANoB5pnLLuOC1FZ9Ex7nQtk/gO0qJTeAoscy0jOGoBhMvg4yz+hz6lth
        Sy/cJnp0fk1WJQW+3D7MjUQ=
X-Google-Smtp-Source: AA0mqf7V4e2ElBrFRCbWfuqUdca0qmNNptb6HsYF8mQCH/vNi1WBt8xseZdvrnb8BH3DLnTMrhOVvQ==
X-Received: by 2002:a62:1687:0:b0:574:e5aa:a8dd with SMTP id 129-20020a621687000000b00574e5aaa8ddmr27960179pfw.17.1671119939417;
        Thu, 15 Dec 2022 07:58:59 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id p3-20020aa79e83000000b00576ce9ed31csm1923351pfq.56.2022.12.15.07.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 07:58:58 -0800 (PST)
Message-ID: <c2040e16d69d251f1a0690f0805388817aba8ab7.camel@gmail.com>
Subject: Re: [RESEND PATCH v5 net-next 2/2] net: phy: micrel: Fix warn:
 passing zero to PTR_ERR
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com
Cc:     UNGLinuxDriver@microchip.com
Date:   Thu, 15 Dec 2022 07:58:57 -0800
In-Reply-To: <20221214092524.21399-3-Divya.Koppera@microchip.com>
References: <20221214092524.21399-1-Divya.Koppera@microchip.com>
         <20221214092524.21399-3-Divya.Koppera@microchip.com>
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

On Wed, 2022-12-14 at 14:55 +0530, Divya Koppera wrote:
> Handle the NULL pointer case
>=20
> Fixes New smatch warnings:
> drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero=
 to 'PTR_ERR'
>=20
> vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v4 -> v5:
> - Removed run time check and added compile time check for PHC
>=20
> v3 -> v4:
> - Split the patch for different warnings
> - Renamed variable from shared_priv to shared.
>=20
> v2 -> v3:
> - Changed subject line from net to net-next
> - Removed config check for ptp and clock configuration
>   instead added null check for ptp_clock
> - Fixed one more warning related to initialisaton.
>=20
> v1 -> v2:
> - Handled NULL pointer case
> - Changed subject line with net-next to net
> ---
>  drivers/net/phy/micrel.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 1bcdb828db56..650ef53fcf20 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -3017,10 +3017,6 @@ static int lan8814_ptp_probe_once(struct phy_devic=
e *phydev)
>  {
>  	struct lan8814_shared_priv *shared =3D phydev->shared->priv;
>=20
> -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> -		return 0;
> -
>  	/* Initialise shared lock for clock*/
>  	mutex_init(&shared->shared_lock);
>=20
> @@ -3040,12 +3036,16 @@ static int lan8814_ptp_probe_once(struct phy_devi=
ce *phydev)
>=20
>  	shared->ptp_clock =3D ptp_clock_register(&shared->ptp_clock_info,
>  					       &phydev->mdio.dev);
> -	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
> +	if (IS_ERR(shared->ptp_clock)) {
>  		phydev_err(phydev, "ptp_clock_register failed %lu\n",
>  			   PTR_ERR(shared->ptp_clock));
>  		return -EINVAL;
>  	}
>=20
> +	/* Check if PHC support is missing at the configuration level */
> +	if (!shared->ptp_clock)
> +		return 0;
> +
>  	phydev_dbg(phydev, "successfully registered ptp clock\n");
>=20
>  	shared->phydev =3D phydev;
>=20

Looks good to me. You may need to resubmit once net-next opens.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
