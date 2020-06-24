Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF963207095
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390047AbgFXKC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:02:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38234 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387647AbgFXKCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:02:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624100222euoutp011db24646a41e870db7597ae0664fc24f~bcqQ2CnEd0612406124euoutp01j;
        Wed, 24 Jun 2020 10:02:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624100222euoutp011db24646a41e870db7597ae0664fc24f~bcqQ2CnEd0612406124euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992942;
        bh=zS7BBcIf8Er4wztyqZriZDzfVjYDv4HA67jYgilMcYw=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=UQ0QJjQgi6CBTf3zF7M84ccG/AKMnIkKVBA04dSPmlhvFlgXnojIYoHSHNI8JaSlE
         Fv2YoH08hjijRKaHfTfPsuBrMkZE4d4ISG/Vsu1oK+IxAT8xo6RRPX8ER7ZqvnGETX
         I+ccM3oetX7iecJqaxxPZMQIQNUyqhZg67TmyNxU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200624100222eucas1p10a5cfceffc5ce4734ede8694d051b79d~bcqQtEPGG1072510725eucas1p1D;
        Wed, 24 Jun 2020 10:02:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 8F.EA.06318.EA423FE5; Wed, 24
        Jun 2020 11:02:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624100222eucas1p11aefed06847804a9445c4c7858e0c219~bcqQOzNkS0259002590eucas1p1O;
        Wed, 24 Jun 2020 10:02:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624100222eusmtrp18a681d259c048efb5efcaa2eb9b73532~bcqQNiFL10684506845eusmtrp1m;
        Wed, 24 Jun 2020 10:02:22 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-35-5ef324aecf9b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A3.D5.06314.DA423FE5; Wed, 24
        Jun 2020 11:02:22 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200624100220eusmtip243a748218d3af717d49d92a57478c61f~bcqOTWYY62653526535eusmtip2O;
        Wed, 24 Jun 2020 10:02:20 +0000 (GMT)
Subject: Re: [PATCH v4 09/11] thermal: core: Stop polling DISABLED thermal
 devices
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
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <31d0e28b-adb3-3cf6-4cd9-ce273ba94b01@samsung.com>
Date:   Wed, 24 Jun 2020 12:02:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-10-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0ybZRTHfd5rKZa86y48Mi+xislQxwx+OFGziG7x/aTMLHExyOzYG0Ch
        LC0U2GLW6dhGw1gHG2DF2U2kFxVoYaXdWDNhFrVb3WYkslFXLmpRyqCdlxJXbPuyyLf//5zf
        ec4leSSk3MBmScpUVYJapSxXMFLK6Y35n+5+PFq0qdudDdZv4hT87Y8R0DX1MwXN7Usk2A9M
        EHAq+hB0fH+QAv3pTVDvDNAw8eNrcCjaTsHS5B8Jd/FlGDtwnoCOkBYmLUYW+vyNNNhOuik4
        Yz3NgHsizIDZcwyBY2qUBv2ilYTo0UsIzs7MERAJJhrNWsZZaOg7jmD4rImA4cMeGrymdTDS
        2kRD2/xHCK5eLYTPB0MkXPZdp2F6oomBuwMOCkL9meA7XwUX6q+R0Oc4ScKoKUqBOXiOffEp
        /tQX+/hfXB00/0PTUYJ3BToR328dI3hLJJd3GwMs32fJ4T8dnCF4h62B4cdHBxl+zu9PxDv3
        8wuz0yz/a9swwRvmw0wBflP6wm6hvEwrqHM3vy0ttdsa2T32jNqbNy6yOhRJ1yOJBHPPYm94
        ix5JJXLOgrBpapYRzR2EF2/rkWiiCEdalhImLVXhmWwlxYQZYd18zzIVRrgtbKGT1GpuOz4Y
        G01VrOHycMwZZpMQyellOPybh00mGO45fPywLQXJuM04cn2KSWqKy8at/lkyqddyO3AkOEyL
        zCr87YfTVFKnJfhm81zqHZLLxDemPyFE/QgeCHekxsPcX2lYZ3ctz70FG96/wop6Nf59pH9Z
        P4h9LY2UWNCN8N0joeXqAYTNLXFGpJ7H4/5FJnkzktuAe87liuF83GQYosRTZuCfwqvEITJw
        s7ONFMMyfOSQXKSfwL1dvcy9tnq3lTQghXHFasYV6xhXrGP8v68JUTaUKVRrKkoETZ5KqNmo
        UVZoqlUlG4srKxwo8U988ZE/Xcjz764hxEmQ4n5Zb3ChSE4rtZq6iiGEJaRijeylK74iuWy3
        sm6voK7cqa4uFzRDaL2EUmTK8s7MvCXnSpRVwruCsEdQ38sSkrQsHRrboG0o3n7JWLaUvq+g
        JKf41swDpVt10tqv1sfrtj1meWNrfqiwKAAZdwhfYehEb/WXOx9956bT9XWc2/aq7p+snkDN
        fQUq+5OVtzpz6rPL/BeCasob/A5NBn3X1pUaQvt3nCj++BVveo/q4bW3dy3s/eCz2DFDzXvt
        2vzXmcvyLk2tgtKUKp/JIdUa5X/Kvta/IwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0ybVRiAc75rQWs+OzZOyPDSsMwQV1Y65O2cRJ1m359dkmmiDsFmfIFN
        2i79WiISI4swtobVQSxg1zFwc4XKNtsyLoMhA4WRap0Yq8NRudQGMoqM6hYWGLarJvx7znmf
        JycneSWkrJlJkRzSGQWDTlMsZxIp78PhwJZLaZG8rWNp0HrjIQX3fUsEXJgOUFDbsEqC6+gk
        AY2RVLD/WEGBuXkrVHaM0zD5y144FmmgYHXqTvTUvxNuHe0hwD5TAlMtNhY8vmoanNZuCr5o
        bWagezLMgKPvUwTuaT8N5getJEROfovgyuw8AYsT0YfmWm6zcMJTg2DwShMBg1V9NAw1bYDh
        OgsN9QunEdy8mQtf9c6Q8L13lIbgpIWBlU43BTPtyeDtMcK1yp9I8LitJPibIhQ4Jq6yLz/P
        N7aV8X922Wn+Z8tJgu8aP4/49tZbBN+ymMF328ZZ3tOSzp/rnSV4t/MEw9/29zL8vM8XvT//
        MX93LsjyofpBgj+1EGb24XcUOwx6k1F4pkgvGl+SH1BCpkKpBkXmNrVCqcp+d3tmljwjZ0eB
        UHyoRDBk5LynKHI5q9kjric++H2sny1Hi4+ZUYIEc9tw31QdaUaJEhn3JcKrod+QGUmig414
        +HJJ3FmHl/1mJu7cQXhl6jQdG6zj3sAVS34U4yROhZc6wmxMIjmLFPeE2th4cYzA5wIVVMxi
        uO24psr5qJByOXhxdJqJMcVtwnW+OTLG67m38GCX7T/nSTzyefBRmxD1ax3zbIxJbjNebhwl
        45yMx4JniTg/jTvDdvIUktnW5LY1iW1NYluTNCHKiZIEk6gt1IpKhajRiiZdoeKgXutG0fXs
        GFrydKFR1/4BxEmQ/HHp1xN382S0pkQs1Q4gLCHlSdJXf/DmyaQFmtIPBYM+32AqFsQBlBX9
        XA2Zsv6gPrrsOmO+MkuZDWpltipb9QLIk6XHueu5Mq5QYxTeF4QjguH/jpAkpJSjLfWwbyio
        LrCPdCbcU1XW3tid//ryrur2e3s2jP39jTq8vy/QuDDyimfc/Gv48F9npAOBw6kmVFY6t4t7
        7qNnn3L0z/6jC7W9HRrR1hG7H/juf7Yn/TVHQ6LLWnY2zVp+pnuj99ImlHT8xYtVueqdKzi3
        Ij9Sn3r9D/ewaLFefPOT7+SUWKRRppMGUfMvOAcie7QDAAA=
X-CMS-MailID: 20200624100222eucas1p11aefed06847804a9445c4c7858e0c219
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192216eucas1p19e192fbee4848c95c4077b10c46d8017
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192216eucas1p19e192fbee4848c95c4077b10c46d8017
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192216eucas1p19e192fbee4848c95c4077b10c46d8017@eucas1p1.samsung.com>
        <20200528192051.28034-10-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Polling DISABLED devices is not desired, as all such "disabled" devices
> are meant to be handled by userspace. This patch introduces and uses
> should_stop_polling() to decide whether the device should be polled or not.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/thermal/thermal_core.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 14baf0288759..e9c0b990e4a9 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -301,13 +301,22 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
>  		cancel_delayed_work(&tz->poll_queue);
>  }
>  
> +static inline bool should_stop_polling(struct thermal_zone_device *tz)
> +{
> +	return !thermal_zone_device_is_enabled(tz);
> +}
> +
>  static void monitor_thermal_zone(struct thermal_zone_device *tz)
>  {
> +	bool stop;
> +
> +	stop = should_stop_polling(tz);
> +
>  	mutex_lock(&tz->lock);
>  
> -	if (tz->passive)
> +	if (!stop && tz->passive)
>  		thermal_zone_device_set_polling(tz, tz->passive_delay);
> -	else if (tz->polling_delay)
> +	else if (!stop && tz->polling_delay)
>  		thermal_zone_device_set_polling(tz, tz->polling_delay);
>  	else
>  		thermal_zone_device_set_polling(tz, 0);
> @@ -517,6 +526,9 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
>  {
>  	int count;
>  
> +	if (should_stop_polling(tz))
> +		return;
> +
>  	if (atomic_read(&in_suspend))
>  		return;
>  
> 
