Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C068A771
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 02:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjBDBLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 20:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBDBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 20:11:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E6D54567;
        Fri,  3 Feb 2023 17:11:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id gr7so19976490ejb.5;
        Fri, 03 Feb 2023 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qqfZVRPG0odmwop2SRWZxGUPdrvoaTxo4/skd7wde9A=;
        b=pPqK+3Dw8pmeSk05ycX+JFGuXEM/oqEn4OmA7PYVwmfYu48LyQIlJNOlCB7TCsDilQ
         OqrBOuGEdJnxNwukwMmjHZMeF7t/+cKQwgeg/Bxl4d7ya3YLuMrfaBczlMu2XCF5f7uZ
         n0AYpOWzLL4m7/A4ChKlGAOkfYV9ja2I6/wx8s74I9zlMrYez1nSBXwwZuUXOZECMYEE
         v77FxLbrj6yT5o6fYHKDaEigVgkQ4dr+1M5f5FQThsrSYCB+WpLcQmr+fgousLl1fdqR
         ci67Xxyj46/+Qep+TY6TBgVPz3uQW7MxbR10M5T3eN/GNH8Sp02CUSiuG3fj6RokwKT+
         g6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqfZVRPG0odmwop2SRWZxGUPdrvoaTxo4/skd7wde9A=;
        b=xxEXhYNYr6FNO+sqchodNEBXI861Ov012h2ZDDdV03UUOnuTJD6Aw6pXqKtnNbcU79
         yCOo1hxbTBtcGjZ5l/ak4bWTqoDPu4r6llMb4fIcv+tvyZxpoHS1bTM8cwWhpMVTKB16
         qAK0qjI3m0Twas/PY19dko9nndOd2hzK/AFS8vIlWxqQ/dwAZmCkdAFr/sgweyBs49L2
         NtFRsfgP/0V9XuGsO9V09qtT+Y0lh3dGQRusye8g8q65GwPKXoyPeuzgQ+5dTbrfdy7i
         kWdh4St8HToBpwkH+hcCIbpEWw5K6rd/4Wkh7lBFxpqh0TZ9MQSTRUiFCq5LJB84cpJC
         KvLA==
X-Gm-Message-State: AO0yUKWrFCDYg7ZtMoDqjOp3I32dqYFEzh2yVaBykySYeMJJiAE7khlW
        ZDOT4eJzDibbtnfwjAoz0XA=
X-Google-Smtp-Source: AK7set8DV5gzvCghxDgyOTP/UCdf5kMGdnwpjZM5SIdQlNyoDe2oUw3IUtWY3CYCdKwcPFNeBYxusg==
X-Received: by 2002:a17:906:49c9:b0:884:c6d8:e291 with SMTP id w9-20020a17090649c900b00884c6d8e291mr12572217ejv.57.1675473096088;
        Fri, 03 Feb 2023 17:11:36 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id kg11-20020a17090776eb00b0088519b92074sm2093986ejc.128.2023.02.03.17.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:11:35 -0800 (PST)
Date:   Sat, 4 Feb 2023 03:11:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 05/23] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <20230204011133.5mgam2ik7znsrqxu@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-6-o.rempel@pengutronix.de>
 <20230201145845.2312060-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-6-o.rempel@pengutronix.de>
 <20230201145845.2312060-6-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:27PM +0100, Oleksij Rempel wrote:
> Add replacement for phy_ethtool_get/set_eee() functions.
> 
> - it is able to support only limited amount of link modes. We have more
>   EEE link modes...
> 
> By refactoring this code I address most of this point except of the last
> one. Adding additional EEE link modes will need more work.

> +/**
> + * genphy_c45_ethtool_get_eee - get EEE supported and status
> + * @phydev: target phy_device struct
> + * @data: ethtool_eee data
> + *
> + * Description: it reports the Supported/Advertisement/LP Advertisement
> + * capabilities.
> + */
> +int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
> +			       struct ethtool_eee *data)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(lp) = {};
> +	bool overflow = false, is_enabled;
> +	int ret;
> +
> +	ret = genphy_c45_eee_is_active(phydev, adv, lp, &is_enabled);
> +	if (ret < 0)
> +		return ret;
> +
> +	data->eee_enabled = is_enabled;
> +	data->eee_active = ret;
> +
> +	if (!ethtool_convert_link_mode_to_legacy_u32(&data->supported,
> +						     phydev->supported_eee))
> +		overflow = true;
> +	if (!ethtool_convert_link_mode_to_legacy_u32(&data->advertised, adv))
> +		overflow = true;
> +	if (!ethtool_convert_link_mode_to_legacy_u32(&data->lp_advertised, lp))
> +		overflow = true;

ah, ok, so since struct ethtool_eee stores the link modes in the old u32
format, link modes equal to ETHTOOL_LINK_MODE_25000baseKR_Full_BIT or
higher would truncate. Makes sense.

> +
> +	if (overflow)
> +		phydev_warn(phydev, "Not all supported or advertised EEE link modes was passed to the user space\n");

were passed

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
