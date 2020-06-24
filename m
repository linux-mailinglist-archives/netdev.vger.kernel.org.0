Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5772420706F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390111AbgFXJvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:51:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34051 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389824AbgFXJvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:51:45 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624095143euoutp01616e0e718a425dbde5e68af86a82fcf7~bcg9qent02939529395euoutp01V;
        Wed, 24 Jun 2020 09:51:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624095143euoutp01616e0e718a425dbde5e68af86a82fcf7~bcg9qent02939529395euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992303;
        bh=ZO5/qrGQfr7hzhZhYr2qv1+xBW+SnjBs6PMGC0QxS6c=;
        h=From:Subject:To:Cc:Date:In-Reply-To:References:From;
        b=UdBDO6scpgve8SgJVtLkVm2Uojl4qx+y2Cegd/e+7fl2jEPK/FVCq0/45vkVWE+bJ
         olUPOU2D8Aqq0bYbLjrIENMqpbGiiCz5JT1Uy5/TWOyEJtz2piIHP1ojmov6hg6oyg
         DBdCMVm9MniMw8Fc2tndE73fArlKdYGxQfDpRpWQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624095143eucas1p265a25817889932df1ef5cce4e63d8b79~bcg9hreoa1402514025eucas1p2U;
        Wed, 24 Jun 2020 09:51:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id AE.09.06318.F2223FE5; Wed, 24
        Jun 2020 10:51:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624095143eucas1p24640fa3ecba414c54ce3916e56d1aa1a~bcg9MZZXi1469214692eucas1p2X;
        Wed, 24 Jun 2020 09:51:43 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200624095143eusmtrp21b421527db9cf30eeef19116158e455c~bcg9LDyBf2538725387eusmtrp2t;
        Wed, 24 Jun 2020 09:51:43 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-d0-5ef3222f9b73
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D5.14.06314.F2223FE5; Wed, 24
        Jun 2020 10:51:43 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624095141eusmtip15e141546d7b9799a3ddc14276e979f32~bcg7T_idL1499814998eusmtip1w;
        Wed, 24 Jun 2020 09:51:41 +0000 (GMT)
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 07/11] thermal: Use mode helpers in drivers
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
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
Message-ID: <313ca24a-0cc4-a976-19bb-0f30aa845226@samsung.com>
Date:   Wed, 24 Jun 2020 11:51:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-8-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1DTZRy+9/sbat7XafBGeV7r8i5OmEh/fK4fJFbX9/QuvY4r6wKb+g25
        +OHtC5T2R3KGwAJEC9ExYRjJNjvBDcemtDhmkq2WueCEWMcEdZgjYVDi8aNt37j473me9/m8
        z+d5716OVNaxSVxeYbGoLdTkq5h4yn5l1puiVoVzNlR71oL5hwUK/vHOEnBm9A8Kjp1YJOF8
        WYCApvAaMPzyGQW6lg1QbvfTEOjfBofDJyhYvPlnhPW8AoNllwgwBEvhpknPgs1bTYOl3knB
        aXMLA85AiIE21xEE1tEBGnQPzSSEay4juDA+QcDUSCTonmmYhSrbUQTuC0YC3BUuGq4YE6Dv
        eC0NDfcbEVy79h6c7Q6S8JPnOg1jgVoG5rusFAQ7E8FzqRi+Lf+VBJu1noQBY5iCtpGL7Kb1
        QtM3nwi3HAZa8NXWEILD34qETvMgIZim1IJT72cFmylZ+Kp7nBCslipGGB7oZoQJrzeit34q
        TN4bY4XbDW5CqLsfYrbjd+Nf3CPm55WKWnXG+/F7w30+dp/hqY8df/WzB5ElSYfiOMw/hw9N
        DxI6FM8peRPCXs8kI5NphDu7fiNlEka42j/DLo3caW+l5YM2hH3NP1IyCUXma0bJqIvhn8dH
        Kywoilfxm/F5n4+J4tV8Op61h9joAMnrFDh0xxW7VsFn4AajKzZM8c9gc/1QTH+M34GnRty0
        7FmJr54co6I4jn8Jd8xcjmGST8RDY82EjNfirpCBlFf9Ow4Heh6X8au40WUgZLwK3+3r/K/O
        k3jR2Rx7AcyfQ3i+MkjKpAvhti8WGNn1Ah72PoxgLpLwLG6/qJblTFze9CAmY34FvhFaKe+w
        Ah+zN5CyrMCVh5Wyex3uONPBLMXqnGayDqn0y5rpl7XRL2uj/z/XiCgLShRLpIJcUUovFD9K
        lTQFUklhburuogIrivwTz0LfjAO55nb1Ip5DqkcVHSOTOUpaUyrtL+hFmCNVqxWbf/bkKBV7
        NPsPiNqindqSfFHqRU9wlCpRkX56PFvJ52qKxQ9FcZ+oXToluLikgyiLu/75DcWpdfZHWt54
        elvdXOquxi1leV/PlWdkqZVvT6ce+Z3Z1Hvg5S8t32fbW7dmietRmqk/ZYe0pttfOfHd0F3r
        B7X5ZQ9OVirOhTbOv244XuEybNntnn/rzfadvrSqnqu25ImEBDHlVkJRe1Byoa3vvHY203wo
        2xXItjtObcy8raKkvZq0ZFIraf4FiCpJAiMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxSH897PYmhyV3G8NnObTcgWx0rLhxwQ2YLJcmO2zGwxWTaHdnoD
        jbTF3gspuGS6iIxmVjCpYKlYGSrtTIAWoQwk2hrKgkMGswkCGygqDlGkmo1Fce2aJfz3nHN+
        T05OcmSkoplRyvRGSTAbdSUqZg01tBKaejdNFSnUzDcy4B5coeCv4WUCzt/5nYITDS9J6Dg8
        Q0BTZAM4bxyhwHpWA1VdUzTM3PwYjkYaKHh5ez5aXdkG44d7CXDOlcPtVgcLvuHvafDYeyho
        dp9loGdmgYEL/ccReO+EabD+4yYhcuwagksPHhGwNB1d9LB1koUaXx2C4CUXAcHqfhoGXK9C
        6KSNhvrFRgQjI7vgx745Eq4PjdIwO2Nj4EW3l4K5zmQY6pXgctWvJPi8dhLCrggFF6Z/Yt9P
        5ZsuHuTv+p00P2Y7RvD+qRbEd7rHCb51KY3vcUyxvK91E/9D3wOC93pqGH4y3Mfwj4aHo/2W
        b/gnD2dZ/l59kOBrFxeYHfhzdZ7ZVCYJbxabRGmr6gstpKu1OaBOz8xRazOyv8xNz1Kl5eft
        E0r05YI5LX+PujgSGmNLnRst/sc32UPIo7SiBBnmMvH9thbaitbIFNw5hK8E6kgrkkUHr+FQ
        W3k8sxY/D1uZeGYe4QF/kIgNGC4X11V7UIzXcgW4Y2yMiXESl4GXuxbYmEByNjnuvXeRjdtV
        BA78PUrHUnIuH9e7+skYU1wKdttvsTFex32Gg34HimdewT+fmqVinMBtxe3Prv3HJPcWft40
        SsY5Gd+aPUPE+Q3cveAka5HCsUp3rFIcqxTHKsWFKA9KEspEQ5FB1KpFnUEsMxap95oMXhT9
        z66BZZ8fjXZ8GkCcDKkS5e3TTwoVtK5crDAEEJaRqiR5wS9DhQr5Pl1FpWA27TaXlQhiAGVF
        j6sjlev2mqLfbpR2a7O02ZCjzc7IztgMqmT5d9zVXQquSCcJ+wWhVDD/7xGyBOUhtL0gUdz5
        540DG1M3pI5P2PZ3ksajlhfPvhXaKjsqHS1vL71X09j9xx5BI7WHJsJnFLYjyU+tW5wnRvTN
        jz+x1zLnlStXLR/MdT79aEv3h7ma192Diq70U5PrExcbvtI3SimnLdUVeSlfawbZNld9jeYd
        /Y7M0su/UZI96eBmy8T1gIoSi3XaTaRZ1P0LywTyErUDAAA=
X-CMS-MailID: 20200624095143eucas1p24640fa3ecba414c54ce3916e56d1aa1a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192211eucas1p1dc9b49e1288321503954ed16d9e3001b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192211eucas1p1dc9b49e1288321503954ed16d9e3001b
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192211eucas1p1dc9b49e1288321503954ed16d9e3001b@eucas1p1.samsung.com>
        <20200528192051.28034-8-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Use thermal_zone_device_{en|dis}able() and thermal_zone_device_is_enabled().
> 
> Consequently, all set_mode() implementations in drivers:
> 
> - can stop modifying tzd's "mode" member,
> - shall stop taking tzd's lock, as it is taken in the helpers
> - shall stop calling thermal_zone_device_update() as it is called in the
> helpers
> - can assume they are called when the mode truly changes, so checks to
> verify that can be dropped
> 
> Not providing set_mode() by a driver no longer prevents the core from
> being able to set tzd's mode, so the relevant check in mode_store() is
> removed.
> 
> Other comments:
> 
> - acpi/thermal.c: tz->thermal_zone->mode will be updated only after we
> return from set_mode(), so use function parameter in thermal_set_mode()
> instead, no need to call acpi_thermal_check() in set_mode()
> - thermal/imx_thermal.c: regmap writes and mode assignment are done in
> thermal_zone_device_{en|dis}able() and set_mode() callback
> - thermal/intel/intel_quark_dts_thermal.c: soc_dts_{en|dis}able() are a
> part of set_mode() callback, so they don't need to modify tzd->mode, and
> don't need to fall back to the opposite mode if unsuccessful, as the return
> value will be propagated to thermal_zone_device_{en|dis}able() and
> ultimately tzd's member will not be changed in thermal_zone_device_set_mode().
> - thermal/of-thermal.c: no need to set zone->mode to DISABLED in
> of_parse_thermal_zones() as a tzd is kzalloc'ed so mode is DISABLED anyway
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/acpi/thermal.c                        | 21 ++++++-----
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 37 +++++++++----------
>  drivers/platform/x86/acerhdf.c                | 17 +++++----
>  drivers/thermal/da9062-thermal.c              |  6 ++-
>  drivers/thermal/hisi_thermal.c                |  6 ++-
>  drivers/thermal/imx_thermal.c                 | 33 +++++++----------
>  .../intel/int340x_thermal/int3400_thermal.c   |  5 +--
>  .../thermal/intel/intel_quark_dts_thermal.c   | 18 ++-------
>  drivers/thermal/rockchip_thermal.c            |  6 ++-
>  drivers/thermal/sprd_thermal.c                |  6 ++-
>  drivers/thermal/thermal_core.c                |  2 +-
>  drivers/thermal/thermal_of.c                  | 10 +----
>  drivers/thermal/thermal_sysfs.c               | 11 ++----
>  13 files changed, 80 insertions(+), 98 deletions(-)

[...]

> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 32c5fe16b7f7..3efe749dc5a0 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -397,19 +397,16 @@ static inline void acerhdf_revert_to_bios_mode(void)
>  {
>  	acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
>  	kernelmode = 0;
> -	if (thz_dev) {
> -		thz_dev->mode = THERMAL_DEVICE_DISABLED;
> +	if (thz_dev)
>  		thz_dev->polling_delay = 0;
> -	}
> +
>  	pr_notice("kernel mode fan control OFF\n");
>  }
>  static inline void acerhdf_enable_kernelmode(void)
>  {
>  	kernelmode = 1;
> -	thz_dev->mode = THERMAL_DEVICE_ENABLED;
>  
>  	thz_dev->polling_delay = interval*1000;
> -	thermal_zone_device_update(thz_dev, THERMAL_EVENT_UNSPECIFIED);
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> @@ -723,6 +720,8 @@ static void acerhdf_unregister_platform(void)
>  
>  static int __init acerhdf_register_thermal(void)
>  {
> +	int ret;
> +
>  	cl_dev = thermal_cooling_device_register("acerhdf-fan", NULL,
>  						 &acerhdf_cooling_ops);
>  
> @@ -736,8 +735,12 @@ static int __init acerhdf_register_thermal(void)
>  	if (IS_ERR(thz_dev))
>  		return -EINVAL;
>  
> -	thz_dev->mode = kernelmode ?
> -		THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED;
> +	if (kernelmode)
> +		ret = thermal_zone_device_enable(thz_dev);
> +	else
> +		ret = thermal_zone_device_disable(thz_dev);
> +	if (ret)

Cleanup on error seems to be missing here.

> +		return ret;
>  
>  	if (strcmp(thz_dev->governor->name,
>  				acerhdf_zone_params.governor_name)) {

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
