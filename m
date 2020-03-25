Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5149D192C76
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCYP2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:28:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40581 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgCYP2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:28:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id u10so3646333wro.7;
        Wed, 25 Mar 2020 08:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+TuwiFh6ptZG2bbIYvP+HL4r312J6Ae1r0580dUYeiw=;
        b=SsqRu3VfcjXQUd9sQY1p9+YtlAipWWtLkXyxyN+z5kEmeY6VzKak39ao6cznTfg2NT
         JGvYzxeRy82Skqt0L0EeJ7KyEtEAJa4GelLcPLwZBSfUIxv8GEsZ8y71GTFSz+6JYZc0
         mbPMZscQZSFuAK4K9ov0Cg0S3QfQrec8EP2g8u26qflS20jrXCrfd10JfFWdIktqPBow
         bq8CuQtwRSDDab3bGWNndTVDVDFa41Rzh0N2INsWTeH4TJh/LawHbmORV9q4nKu1eEOk
         b1JumXhAYajXIY5ZDjfQy/g+N96lmcjadnjE07w4JCA++a0mStooP3PiMSZwDRR9yyLX
         F4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+TuwiFh6ptZG2bbIYvP+HL4r312J6Ae1r0580dUYeiw=;
        b=S8QAMXCC7Yl3HIHqDRuoejOOR5Hqmvq+gBoIpZAa8772X9XvwohY+a7No3UDouL/9p
         LfdiBehuW/oAQMWTiZyFIMhQeY46PVG350oS2H2/NT88I5gqRwmTV0/V/0RkIAeepkZ9
         /FHh6c6pT36mqUjRFPqZ49f6PF6L5yzf3n5Yqpw+ony3bgcLCfQ5Q49pOu7vFTiRYzTH
         VufRC3BsG4Da6vioSDe//UB1dwwG8kGwHrt2mT6y0fXM+KtCX4D0llPvVt3DJOWBvNLi
         5YcHCSFZBhUocEXnW4W/qxddpNHTc8HOgeikFp106/vrYGkW8XGGdpJrW9Fl8eWLSMiU
         88ug==
X-Gm-Message-State: ANhLgQ3BiEHFQwFCCiekpErRGmFCh2Hg5lPO5ktnRAjcnZz8p202clLU
        7HpG0d1Q/b/aZ1xkJYNY5tY=
X-Google-Smtp-Source: ADFU+vv2WmXZviwL1prI7g4XxxAMgN1uOZn5i5kh4PmLtj27KlvZBV9mmlfSXaQ1afOTdfZN0W2zpA==
X-Received: by 2002:adf:fdc6:: with SMTP id i6mr4134003wrs.252.1585150108315;
        Wed, 25 Mar 2020 08:28:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f4a0:1b38:2faf:56e9? (p200300EA8F296000F4A01B382FAF56E9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f4a0:1b38:2faf:56e9])
        by smtp.googlemail.com with ESMTPSA id b6sm18851817wrp.59.2020.03.25.08.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:28:27 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: phy: micrel.c: add rgmii interface delay
 possibility to ksz9131
To:     Philippe Schenker <philippe.schenker@toradex.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        mark.rutland@arm.com
Cc:     o.rempel@pengutronix.de, linux-kernel@vger.kernel.org,
        silvan.murer@gmail.com, s.hauer@pengutronix.de,
        a.fatoum@pengutronix.de, "David S. Miller" <davem@davemloft.net>
References: <20200325150329.228329-1-philippe.schenker@toradex.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7948ffaa-e530-f82e-0f58-39fa7e8f082f@gmail.com>
Date:   Wed, 25 Mar 2020 16:28:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325150329.228329-1-philippe.schenker@toradex.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2020 16:03, Philippe Schenker wrote:
> The KSZ9131 provides DLL controlled delays on RXC and TXC lines. This
> patch makes use of those delays. The information which delays should
> be enabled or disabled comes from the interface names, documented in
> ethernet-controller.yaml:
> 
> rgmii:      Disable RXC and TXC delays
> rgmii-id:   Enable RXC and TXC delays
> rgmii-txid: Enable only TXC delay, disable RXC delay
> rgmii-rxid: Enable onlx RXC delay, disable TXC delay
> 
> Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
> ---
> 
>  drivers/net/phy/micrel.c | 45 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 63dedec0433d..d3ad09774847 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -704,6 +704,48 @@ static int ksz9131_of_load_skew_values(struct phy_device *phydev,
>  	return phy_write_mmd(phydev, 2, reg, newval);
>  }
>  
> +/* MMD Address 0x2 */
> +#define KSZ9131RN_RXC_DLL_CTRL		76
> +#define KSZ9131RN_TXC_DLL_CTRL		77
> +#define KSZ9131RN_DLL_CTRL_BYPASS	BIT_MASK(12)
> +#define KSZ9131RN_DLL_ENABLE_DELAY	0
> +#define KSZ9131RN_DLL_DISABLE_DELAY	BIT(12)
> +
> +static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
> +{
> +	int ret;
> +	u16 rxcdll_val, txcdll_val;
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		rxcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		rxcdll_val = KSZ9131RN_DLL_DISABLE_DELAY;
> +		txcdll_val = KSZ9131RN_DLL_ENABLE_DELAY;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	ret = phy_modify_mmd_changed(phydev, 2, KSZ9131RN_RXC_DLL_CTRL,

Using a constant for the device address would be good.

Last but not least your patch misses the net-next annotation
(except you consider it a fix, then the net annotation and
a Fixes tag would be needed).

> +				     KSZ9131RN_DLL_CTRL_BYPASS, rxcdll_val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_modify_mmd_changed(phydev, 2, KSZ9131RN_TXC_DLL_CTRL,
> +				     KSZ9131RN_DLL_CTRL_BYPASS, txcdll_val);
> +}
> +
>  static int ksz9131_config_init(struct phy_device *phydev)
>  {
>  	const struct device *dev = &phydev->mdio.dev;
> @@ -730,6 +772,9 @@ static int ksz9131_config_init(struct phy_device *phydev)
>  	if (!of_node)
>  		return 0;
>  
> +	if (phy_interface_is_rgmii(phydev))
> +		ksz9131_config_rgmii_delay(phydev);
> +
>  	ret = ksz9131_of_load_skew_values(phydev, of_node,
>  					  MII_KSZ9031RN_CLK_PAD_SKEW, 5,
>  					  clk_skews, 2);
> 

