Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3023F2D34B5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgLHU5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgLHU5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:57:05 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9FCC0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:56:24 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b73so19004712edf.13
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6DdKBi1cgyoljGzBWCPffDWHeqJxmio3GBFfS+NIfpY=;
        b=Z3uH/CLDgd4c8a3xYlBrJg+iZwA7p/MEKgN6YvCW3b+0aUn2POp3Y7BT2rNa/HG9a0
         LtLgfUOutgciB9Tl1ovHmN8PDhy8YhHFvR4mmKcckckrifYyYTU88EaHbhMQzmZUgLt/
         5ka33ut76coqFuFP8Xo1AdY1YZsNlMVjz8CAMVFG8z42Yynmk3NtNh9cU4wqtVC0Xzhh
         9M7epuoYWSGEuCCdzehdfQGbDNsrHEKpsIIEe5fXPFhNcTDlCel2AvYSe/8qeP8KS3G6
         cwFyjF8yc+mLZEo6gGFr3kDn6amVQVIouA4ZAKMIN8CefaPFgod6VRAloIfsfSevkhcf
         8uOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6DdKBi1cgyoljGzBWCPffDWHeqJxmio3GBFfS+NIfpY=;
        b=dh2AidehyOLn6E2W/boluH9nYAai3W644hjFioFczMDlio5/2J+QjeFvQmMEvwN2tb
         5GRGArwhDSy2Utgmeo9nn2DG0sYOXLDaE8T3lvamMpaPZmubYTFOJeWnSrQ0jnz39TTN
         FPJolSid3yCKF0DpdV/NVW4ayTTl2ybvuMxoxNFGhPSWuo53yTVsngc4Eg7Ai4Re/lsM
         gCPQj0bQeJQ9kdG7mOEw3452qq0AoNKFsddTOVcFs5hMNhiaPgqiOm0TieExyFvrWlah
         y6bQwK3Wk38FB4xzt+ZMTFOsUCVQU0ZwRokfUFylDTpYYxmxJz9HarQT7aLv7NPsVYf5
         YqCg==
X-Gm-Message-State: AOAM530DUMyUhcTgE3Yp7/lG4o7KcNJhLbVpR5AI60I6bEwJorjiysWr
        3hJbW451f0FlX+cBvGGH1NA=
X-Google-Smtp-Source: ABdhPJxa21e6yip2uA76uaSWYELHefCaNi/orwRfb/Csqj7vcOGqrq4tdzivCuwG1N34Xep7QlME1A==
X-Received: by 2002:a05:6402:491:: with SMTP id k17mr26388321edv.370.1607460983588;
        Tue, 08 Dec 2020 12:56:23 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id l1sm9130705eje.12.2020.12.08.12.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 12:56:23 -0800 (PST)
Date:   Tue, 8 Dec 2020 22:56:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support setting ageing time
Message-ID: <20201208205621.2xxscilegk4k4t4g@skbuf>
References: <20201208070028.3177-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208070028.3177-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 03:00:28PM +0800, DENG Qingfang wrote:
> MT7530 has a global address age control register, so use it to set
> ageing time.
> 
> The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 41 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/mt7530.h | 13 +++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 6408402a44f5..99bf8fed6536 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -870,6 +870,46 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
>  	return ARRAY_SIZE(mt7530_mib);
>  }
>  
> +static int
> +mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	unsigned int secs = msecs / 1000;
> +	unsigned int tmp_age_count;
> +	unsigned int error = -1;
> +	unsigned int age_count;
> +	unsigned int age_unit;
> +
> +	/* Applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds */
> +	if (secs < 1 || secs > (AGE_CNT_MAX + 1) * (AGE_UNIT_MAX + 1))
> +		return -ERANGE;
> +
> +	/* iterate through all possible age_count to find the closest pair */
> +	for (tmp_age_count = 0; tmp_age_count <= AGE_CNT_MAX; ++tmp_age_count) {
> +		unsigned int tmp_age_unit = secs / (tmp_age_count + 1) - 1;
> +
> +		if (tmp_age_unit <= AGE_UNIT_MAX) {
> +			unsigned int tmp_error = secs -
> +				(tmp_age_count + 1) * (tmp_age_unit + 1);
> +
> +			/* found a closer pair */
> +			if (error > tmp_error) {
> +				error = tmp_error;
> +				age_count = tmp_age_count;
> +				age_unit = tmp_age_unit;
> +			}

I feel that the error calculation is just snake oil. This would be enough:

		if (tmp_age_unit <= AGE_UNIT_MAX)
			break;

Explanation:

You are given a number X, and must find A and B such that the error
E = |(A x B) - X| should be minimum, with
1 <= A <= A_max
1 <= B <= B_max

It is logical to try with A=1 first. If X / A <= B_max, then of course,
B = X / 1, and the error E is 0.

If that doesn't work out, and B > B_max, then you go to A=2. That gives
you another B = X / 2, and the error E is 1. You check again if B <=
B_max. If it is, that's your answer. B = X / 2, with an error E of 1.

You get my point. Iterating ascendingly through A, and calculating B as
X / A, already gives you the smallest error as soon as it satisfies the
B <= B_max requirement.

> +
> +			/* found the exact match, so break the loop */
> +			if (!error)
> +				break;
> +		}
> +	}
> +
> +	mt7530_write(priv, MT7530_AAC, AGE_CNT(age_count) | AGE_UNIT(age_unit));
> +
> +	return 0;
> +}
> +
>  static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> @@ -2564,6 +2604,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
>  	.phy_write		= mt753x_phy_write,
>  	.get_ethtool_stats	= mt7530_get_ethtool_stats,
>  	.get_sset_count		= mt7530_get_sset_count,
> +	.set_ageing_time	= mt7530_set_ageing_time,
>  	.port_enable		= mt7530_port_enable,
>  	.port_disable		= mt7530_port_disable,
>  	.port_change_mtu	= mt7530_port_change_mtu,
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index ee3523a7537e..32d8969b3ace 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -161,6 +161,19 @@ enum mt7530_vlan_egress_attr {
>  	MT7530_VLAN_EGRESS_STACK = 3,
>  };
>  
> +/* Register for address age control */
> +#define MT7530_AAC			0xa0
> +/* Disable ageing */
> +#define  AGE_DIS			BIT(20)
> +/* Age count */
> +#define  AGE_CNT_MASK			GENMASK(19, 12)
> +#define  AGE_CNT_MAX			0xff
> +#define  AGE_CNT(x)			(AGE_CNT_MASK & ((x) << 12))
> +/* Age unit */
> +#define  AGE_UNIT_MASK			GENMASK(11, 0)
> +#define  AGE_UNIT_MAX			0xfff
> +#define  AGE_UNIT(x)			(AGE_UNIT_MASK & (x))
> +
>  /* Register for port STP state control */
>  #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
>  #define  FID_PST(x)			((x) & 0x3)
> -- 
> 2.25.1
> 
