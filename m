Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED26620708D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgFXKBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:01:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37610 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387927AbgFXKBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:01:05 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624100102euoutp01edcf1224efc3a947a8d50f8603c14816~bcpF00u3W0346003460euoutp01b;
        Wed, 24 Jun 2020 10:01:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624100102euoutp01edcf1224efc3a947a8d50f8603c14816~bcpF00u3W0346003460euoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992862;
        bh=Bqku5Z2OIdo8hodegXWtXPEDRyMLmFoXaOs44O9LgGY=;
        h=From:Subject:Cc:To:Date:In-Reply-To:References:From;
        b=TvRolLu9x/l07KHMASbAmXI4X4khbVZZ/2YpYMcwnxh+uGpSzxpblA4L2krFYs1kH
         wbVewVMrBFr/mPSPnMA0R2xDoSaK4FWDP3WVIpMYUCK18s/iMH6JWWUGZfG3bKgTOb
         DDK1WtBePxaL1iHIaunEgtnDfggGk8Qqw8sI0UFg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624100102eucas1p2d3f3756b2c2ba5b64ed39a767a9fb559~bcpFplRzk1977619776eucas1p2K;
        Wed, 24 Jun 2020 10:01:02 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id EE.7F.05997.D5423FE5; Wed, 24
        Jun 2020 11:01:02 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624100101eucas1p1760f7fa4f393ff936f9422265376fa69~bcpFSek221104111041eucas1p1M;
        Wed, 24 Jun 2020 10:01:01 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200624100101eusmtrp24c56acca41d3f004e7b71f5561752c8a~bcpFRBNrU3175831758eusmtrp2W;
        Wed, 24 Jun 2020 10:01:01 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-27-5ef3245dfa09
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 26.95.06314.D5423FE5; Wed, 24
        Jun 2020 11:01:01 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624100059eusmtip1177d3f27cc77414e1c5eea6c6dd73175~bcpDfatnW2149021490eusmtip1i;
        Wed, 24 Jun 2020 10:00:59 +0000 (GMT)
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 08/11] thermal: Explicitly enable non-changing
 thermal zone devices
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@collabora.com
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <0dc0796a-1559-d5e9-5297-c95281792a06@samsung.com>
Date:   Wed, 24 Jun 2020 12:00:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-9-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tb0xbZRTGfe9/iMW7Utc3c8RYlcSFwSaanKhDnYteFxf3xQTNwFW5gUVg
        swU29MMgc7AVh2wLMjtkdENo2TJqy7+yjhi60RmkAxnEOdgolFmQEkYJWgKtbe+IfPs9zzn3
        nuf58HKkvJLdxB3ILxA1+epcFRNLtfcGXFszX/BnbpvaDqZbQQr+cQUIaJy8T8GZcyESfi51
        E1DnT4Da299QoDNsg+PtYzS4hz+EMv85CkITf4fVL+/A3dJrBNR6i2DCqGfB6vqWhuZqGwUX
        TQYGbG4fA03d3yGwTI7QoFs2keA/dQNB2/QcAQvj4UOzxlEWTlpPI3C01RPgKO+mobd+Izi/
        r6ShZv48goGBfXDZ7iXht77fafC4KxlY7bBQ4G1VQt+1Arh+fJAEq6WahJF6PwVN413sW0lC
        3ZWvhanOWloYqjxFCJ1jDUhoNd0lBONCimDTj7GC1bhFuGSfJgRL80lGGB2xM8KcyxX2G44K
        j2Y9rPCwxkEIVfM+Zi/+JPaNLDH3QJGoSUnbH5szZXrAHupNOOJ0zpElKLhRh2I4zL+Clwbt
        rA7FcnLeiPBM6U+UJBYRfjgRIiThR3i5Uc+sfeJZnaYjLOebEB4wJElLPoSr3S0oMmD41/Dp
        8uYox/P78ErobPRPJK+TYd9f3WxkoOBTcaDdF2UZn4Yb/zWTEab4F7HBeSXKT/PpeGHcQUs7
        G/CvP3ioCMfwO7BjdCCaiOSV+E/PBULiZ3GHr5aUki7F4KEfWYl34YqKakrieDzjbH3sb8Yh
        24VoOMxfRXj1hJeURAfCTWeDjzu/jkddy2Hmwhdewi1dKZL9Nr7XtkBHbMzH4T98G6QMcfhM
        ew0p2TJ8okwubSdic6OZWTurs5nIKqTSr2umX9dGv66N/v+79YhqRkqxUJuXLWpfzhcPJ2vV
        edrC/Ozkzw/mWVD4lfQFnYudqGvlsx7Ec0j1pMw8/ihTTquLtMV5PQhzpEoh29nflymXZamL
        vxI1Bz/VFOaK2h70DEeplLLUi9MZcj5bXSB+IYqHRM3alOBiNpUgxdZdz2WU7J+0By+/++qt
        I/3EU8eykvoDM2mzixnJLV0B0/Ual+LBDVfFl/hmuj5krYuvLNvzvvf522WTO21Ve3LMK4n3
        l3LaPh6MU3Re3Wt4r2jz4YR7yoLAHWrYmGwoL95xKVW9m8s4ln7nA8PN84lDbz7Rm64s2V3Y
        MBw3/9HRqQkVpc1Rb99CarTq/wB6hO1FIQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xTVxiHc+6/FrNmdxXlrNG5NDMmZCu2yHhxSpZtMefDNkm2JWoR1+AN
        kNHW9bZV3JbBInM2wmSJwq5NBYdIkWXaIhYBs9GFCyl2DDcyHVWK1UC0TO0HZAFcS7OEb885
        7+85b07yU9Lqs5xGWWGxCzaLqVLLrWJCS3Lktb2vJEo2y9GN4B1aYmAuPE9B293bDHzX9IyG
        SzVRCjyJ9eD+7QgDrpbNUNsdYSH65074OtHEwLOpB8nTz2/DzZpeCtzTTphqlxTgDx9noeNk
        DwNnvS0c9ETjHJy/9i0C391xFlz/emlI1P2K4PLMLAVPJpOLHrZPKOCYvwFB8HIzBcGj11gY
        bF4L8ql6FhofnUYwOloMF/qmaRgJjbEQi9ZzsHjFx8B0VxaEeu3QX/s7DX7fSRrGmxMMnJ+8
        qnjzVeLp/IzcC7hZcqO+jiKBSCsiXd6bFGl/kkN6pIiC+NuzyQ99MxTxdRzjyMR4H0dmw+Hk
        feuX5PHDmILcbwxS5MSjOFeE9+i22awOu/ByuVW0b9ca9WDQ6QtAZ9hSoNPn5u/dasjT5hRu
        2y9UVjgFW07hx7rye947igOD6w/J8ixdjZbWulCGEvNbcGxxhnWhVUo1fw7hO7dHKBdSJgfr
        sPyTM51ZjRfGXVw68wDhH0eOKFIDjt+KG452oBSv5ovxX/2DdCpE8/Uq3Hu/U5E2aincV1fN
        pVKZfC6e744v2yq+ELc9vUinmOE34ha5c5nX8LtwMCChdOYFPPx9jElxBr8dBydGl9+h+U14
        wTNGpzkL34qdodK8AV+Ju+kTSC2t0KUVirRCkVYozYjpQJmCQzSXmUW9TjSZRYelTFdqNftQ
        sp/dg/P+ABq79MEA4pVI+5zq4uTjEjVrcopV5gGElbQ2U/XW9VCJWrXfVHVYsFn32RyVgjiA
        8pKfa6A1a0qtybZb7Pv0efp8KNDn5+bnvg7aLNU3/C/Far7MZBc+EYQDgu1/j1JmaKpRhiPg
        0UT+7v/0q7ZDqtJ38K2qePEwu2icILv733PvzJqUPJlXG4pk2fLFSKPxxfKKD5OV7roeDJ1e
        jB0M33j3jx2VRtfQ++4dPdrPD3L/7CkaqHK+dKop7yPPuqkNdQ6Q3EMJlWGusab1sOF49vQu
        jYVZeH7OeMEyPPZ0N3mD1zJiuUmfTdtE03/4YJSjtQMAAA==
X-CMS-MailID: 20200624100101eucas1p1760f7fa4f393ff936f9422265376fa69
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192214eucas1p183eafb73cad6465e71e779fb68679f03
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192214eucas1p183eafb73cad6465e71e779fb68679f03
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192214eucas1p183eafb73cad6465e71e779fb68679f03@eucas1p1.samsung.com>
        <20200528192051.28034-9-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Some thermal zone devices never change their state, so they should be
> always enabled.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c     |  8 ++++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c            |  9 ++++++++-
>  drivers/platform/x86/intel_mid_thermal.c               |  6 ++++++
>  drivers/power/supply/power_supply_core.c               |  9 +++++++--
>  drivers/thermal/armada_thermal.c                       |  6 ++++++
>  drivers/thermal/dove_thermal.c                         |  6 ++++++
>  .../thermal/intel/int340x_thermal/int3400_thermal.c    |  5 +++++
>  .../intel/int340x_thermal/int340x_thermal_zone.c       |  5 +++++
>  drivers/thermal/intel/intel_pch_thermal.c              |  5 +++++
>  drivers/thermal/intel/intel_soc_dts_iosf.c             |  3 +++
>  drivers/thermal/intel/x86_pkg_temp_thermal.c           |  6 ++++++
>  drivers/thermal/kirkwood_thermal.c                     |  7 +++++++
>  drivers/thermal/rcar_thermal.c                         |  9 ++++++++-
>  drivers/thermal/spear_thermal.c                        |  7 +++++++
>  drivers/thermal/st/st_thermal.c                        |  5 +++++
>  drivers/thermal/thermal_of.c                           | 10 +++++++++-
>  16 files changed, 101 insertions(+), 5 deletions(-)

[...]

> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 3c0397a29b8c..8e8c9af7e5f4 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -485,6 +485,10 @@ static int int3400_thermal_probe(struct platform_device *pdev)
>  		goto free_art_trt;
>  	}
>  
> +	result = thermal_zone_device_enable(priv->thermal);

I'm not sure about correctness of this addition.

This driver contains ->set_mode but doesn't call it on initialization
(in v3 it was using THERMAL_DEVICE_DISABLED as .initial_mode parameter).

> +	if (result)
> +		goto free_tzd;
> +
>  	priv->rel_misc_dev_res = acpi_thermal_rel_misc_device_add(
>  							priv->adev->handle);
>  
> @@ -518,6 +522,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
>  free_rel_misc:
>  	if (!priv->rel_misc_dev_res)
>  		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
> +free_tzd:
>  	thermal_zone_device_unregister(priv->thermal);
>  free_art_trt:
>  	kfree(priv->trts);

[...]

> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index 43a516a35d64..011fd7f0a01e 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -1066,7 +1066,7 @@ int __init of_parse_thermal_zones(void)
>  	for_each_available_child_of_node(np, child) {
>  		struct thermal_zone_device *zone;
>  		struct thermal_zone_params *tzp;
> -		int i, mask = 0;
> +		int i, ret, mask = 0;
>  		u32 prop;
>  
>  		tz = thermal_of_build_thermal_zone(child);
> @@ -1113,6 +1113,14 @@ int __init of_parse_thermal_zones(void)
>  			of_thermal_free_zone(tz);
>  			/* attempting to build remaining zones still */
>  		}
> +		ret = thermal_zone_device_enable(zone);

This doesn't seem correct as it is done too early and
there is already proper thermal_zone_device_enable() call
in thermal_zone_of_sensor_register().

> +		if (ret) {
> +			thermal_zone_device_unregister(zone);
> +			pr_err("Failed to enable thermal zone\n");
> +			kfree(tzp);
> +			kfree(ops);
> +			of_thermal_free_zone(tz);
> +		}
>  	}
>  	of_node_put(np);
>  

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
