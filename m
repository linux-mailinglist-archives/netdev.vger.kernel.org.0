Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BA4692295
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjBJPrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBJPrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:47:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E2673592;
        Fri, 10 Feb 2023 07:47:50 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z1so6870850plg.6;
        Fri, 10 Feb 2023 07:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1mKKmgtXOklrqEOQJZVyoAGxw7umHy+D4bQ/D9NEh7M=;
        b=SXoFu65pJ7tAJd9SEJLKcf4f+Ds1cZKUWR4J/MzYpONOWtvhgcm5RLOiUy29eAQ3HI
         kYjWB2Wb23ucRe7dLwYnw0WOTQYLe0R7cegUIBJSGkJ0EOOUJXnawPoroi6LwdeH8Iec
         QRB0XCB/irWEmYF9C9lkm3F9EITz8lspssMW2mTGExTrmyvRROMRVBKRy2SXqQBKdR/v
         YjWfysxWssgSGjqeQcCqYgPElf1qmd9+jx+EiX6v5BAlEu+/erwoGscu+UldgX3/DC/m
         toKptF8bJm+FfzKAJCfD7HEvssmp5v2dw0mSoC0EZ3I4eAJrzLFnBxBivo4KXeUT6jS9
         s0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1mKKmgtXOklrqEOQJZVyoAGxw7umHy+D4bQ/D9NEh7M=;
        b=ql3QUkb6/4F6sBcmpkoxaR0REEgq6m44sHVm2Fk6H2SGVGWRP3YU+Rtwtao9aZgW8H
         vWjlq0maEM+stZohCh9lRJ2jMEfjsoS0bQWHRJQ2oMPBZ21XoIASiSMviwUrXD2XfNC9
         PeayM0SV7liqoM5ukHt4majDJd9aoKEp2wEM60IVF9i/wgtAyfE6gK0MkPO8K4nze8F9
         NRVQ4kEAOD67QNJcDDS/R1S/pZGgCLnojtDbtxw8ZxMnSUK9O4fi8VQ7wuIRF/plIqOb
         MzGUs+pDycSdG2fsi31W6evq/sws7bKaVajngTq4ypIiwp2HG8F+n6KH71O5KuX9leNn
         7Ssg==
X-Gm-Message-State: AO0yUKX0DATbRAA4PnsO238RBAoNMbDeg3fmjvAtGRLki5LiflxuMN3R
        avd7INKp4atOZTrvtz4BHGE=
X-Google-Smtp-Source: AK7set+yAJyRNKE4O6y4atowfgvKXjLWB2w/ACyrc8HNGfjz8SjINtxlbm4SilTwUrQuZxL5pd2EbA==
X-Received: by 2002:a05:6a21:3391:b0:b8:42b0:1215 with SMTP id yy17-20020a056a21339100b000b842b01215mr20067494pzb.5.1676044070222;
        Fri, 10 Feb 2023 07:47:50 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id i23-20020aa79097000000b005821c109cebsm3408842pfa.199.2023.02.10.07.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:47:49 -0800 (PST)
Message-ID: <d98b70cfccfd764d4bd3964c50036cf7570ab17c.camel@gmail.com>
Subject: Re: [PATCH net-next v7 4/9] net: phy: export phy_check_valid()
 function
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
Date:   Fri, 10 Feb 2023 07:47:46 -0800
In-Reply-To: <20230209095113.364524-5-o.rempel@pengutronix.de>
References: <20230209095113.364524-1-o.rempel@pengutronix.de>
         <20230209095113.364524-5-o.rempel@pengutronix.de>
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
> This function will be needed for genphy_c45_ethtool_get_eee() provided
> by next patch.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phy.c | 4 ++--
>  include/linux/phy.h   | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 3378ca4f49b6..41cfb24c48c1 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -242,11 +242,11 @@ unsigned int phy_supported_speeds(struct phy_device=
 *phy,
>   *
>   * Description: Returns true if there is a valid setting, false otherwis=
e.
>   */
> -static inline bool phy_check_valid(int speed, int duplex,
> -				   unsigned long *features)
> +bool phy_check_valid(int speed, int duplex, unsigned long *features)
>  {
>  	return !!phy_lookup_setting(speed, duplex, features, true);
>  }
> +EXPORT_SYMBOL(phy_check_valid);
> =20
>  /**
>   * phy_sanitize_settings - make sure the PHY is set to supported speed a=
nd duplex
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index c183a8a27986..7a8e541de3f3 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1619,6 +1619,7 @@ int phy_start_aneg(struct phy_device *phydev);
>  int phy_aneg_done(struct phy_device *phydev);
>  int phy_speed_down(struct phy_device *phydev, bool sync);
>  int phy_speed_up(struct phy_device *phydev);
> +bool phy_check_valid(int speed, int duplex, unsigned long *features);
> =20
>  int phy_restart_aneg(struct phy_device *phydev);
>  int phy_reset_after_clk_enable(struct phy_device *phydev);

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

