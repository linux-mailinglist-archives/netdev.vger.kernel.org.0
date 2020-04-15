Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4E21A9B4C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 12:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgDOKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 06:20:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40000 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896454AbgDOKTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 06:19:02 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200415101830euoutp01d235c1f50c19fefda39773c2110f8ade~F9uXPA7ej2855128551euoutp01r
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 10:18:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200415101830euoutp01d235c1f50c19fefda39773c2110f8ade~F9uXPA7ej2855128551euoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586945910;
        bh=Fwm50T/nZ6Q2k3MWGzt6zeBPATrNUNxyHfySoKDQwlY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=lXPF7cxnDACNCik/GROwnay4jk8bk4K5g6tynb7zIkCJu/yp3Av9f81xYtr+uETgM
         41kcOO6CUNtwyQzEuYuU+uUtdgrI0k8QdHuv8MgrwZh0ue5dKfCsT8YywPXmQhkFqY
         A8b4VZkg6uVbljSW62MRzEnu7OzYYL/zfofd4FdA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200415101830eucas1p2be6eac13c3466aa1d65852252569e21c~F9uWtYhif2165521655eucas1p2O;
        Wed, 15 Apr 2020 10:18:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 31.D0.61286.57FD69E5; Wed, 15
        Apr 2020 11:18:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200415101829eucas1p18e21324d3c39926fffc6c8b5dc52f206~F9uWKjmky2321723217eucas1p1N;
        Wed, 15 Apr 2020 10:18:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200415101829eusmtrp2613be7d6379690c8e59bf53666811072~F9uWJhCso1953519535eusmtrp2R;
        Wed, 15 Apr 2020 10:18:29 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-3c-5e96df7569df
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 67.C1.08375.57FD69E5; Wed, 15
        Apr 2020 11:18:29 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200415101828eusmtip2f5c4763ad14611bd3948c396b71632d9~F9uVHoPir2416924169eusmtip2b;
        Wed, 15 Apr 2020 10:18:28 +0000 (GMT)
Subject: Re: [RFC 7/8] thermal: of: Monitor thermal zone after enabling it
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <40316054-5e39-f1fa-81f2-bfda787d2167@samsung.com>
Date:   Wed, 15 Apr 2020 12:18:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407174926.23971-8-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0wTaRTNNzOdDsWSoai9EVxjE00kUVA0+aIrakQzMWbdGGM2ZkVHnUUi
        LaYF1DXxLUpVQAzS7RJey6OFFbAQaHdZ0aq0Bq34jPiuogKxRlpEqzxsGcjy79xzz8m5J7kM
        qbDT05hkTZqg1fApKlpGNbX5XXPTX5xPjC0bWILNzmEKf3b5CVz5+jmF8wwjJC7yTceFt49R
        WF8ai90P1uFMn4HC7ssrcefhfwlc2J2BG1ynJbg630Zhm9tD46pLOQhbXj+UYP1XM4l9Z64h
        3FYyFXd0/IprWrpJfLP9rgR3ubNpPNRsoXB3oxL/d/wOiRss+eTyKM76rBxxjeZOgjN5Yzib
        8ZmUazBFc3+19BCcpTqL5p4+bKG5Dy5XgC8/yPW975JybwuuElzuRw/NXfxgJbicoVjuy733
        kp8jNsl+3CGkJGcI2pj4rbKd2d/60O4v8r2n7S+kh1BNqB6FMMAuhCdnzhF6JGMUrAnBrdYB
        Shz6EVzoO0KLgw+BafAdPW7J8j8hxUUVgotFeok4eBBct3pRUBXBrgFjzRVpEE9m48Df5JEG
        RSQ7IAX7/R4yuKDZxXD2RPWoQc7Gw/XHXiKIKXYWOIYdkiCewv4C3pdXJaImHG780UUFcQi7
        FJzOktEAklXC465iQsQzoNlTOHoesDkh0HtbLxXvToB77X9SIo6AXkfjGB8FI7ZiQjTUIhg6
        2T3mbkZQdW54rPUSeOr6GsBMIGIO1P0TI9IroLPIQAZpYMPgkSdcPCIM8poKxmg5nMxUiOrZ
        UF9ZT4/H6m1mMhepjBOqGSfUMU6oY/w/twRR1UgppOvUSYJuvkbYM0/Hq3XpmqR521PVFhT4
        7PZhh9eKPt3dZkcsg1ST5M6/8xMVEj5Dt09tR8CQqsnyOnWAku/g9/0uaFO3aNNTBJ0dRTKU
        SimPK+vZrGCT+DRhlyDsFrTjW4IJmXYIZST6jh8onLmeHdHq41InzckMz3NurzNcKJ3S1lp3
        av0Vvrw+6yh6Eyrn1nb8VPtupkYWZpa9Ki2u/PSGfxkTNejamB232R1fua6iYpHQs7x1WWu0
        dWnHlsH+fmRKS/ihd0FyrT90RuRqlUFaEJkwd3XuqooBh7K2fP+G3xyhqWX7VZRuJz8/mtTq
        +O+XxsAh1QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85OztWo9PU9iJFsRJDa3pcttewFfWhQ/ewQMqyaYdpuS12
        Nsmki1BW67JWmTWGTcrSKYqb1SSL1FK7YGZkaXZZjTJqkkroKq1NC/z2e5//78/DCw+FizsE
        EVSW1sDptapsKTmJeDza8naB8d2F7XE9ZeGovHWUQENtfgxd+/iWQGcv/sFR8eBMZHt6mECm
        kjjkebEeFQxeJJDn3grUlX8bQ7beHORqOylAjsI6AtV5fCS6ftcMkPNjpwCZfpbjaPDUfYCa
        7dNRe3sqqqjvxdGTxx0C5PWcJtHILSeBemsl6M6RZzhyOQvxZTNY95urgK0t78LYsoFYts76
        Rsi6yqLZK/VfMNbpOE6yPZ31JNvX1haYXz3I9n/zCtlPRU0Ye+a7j2Rr+twYax6JY4effxNs
        CN0iS9LrjAZudqaONyyRbmVQvIxJRLL4hYkyRq7Ytjg+QRqrTNrJZWflcPpY5Q5Z5ulf/WDP
        sGjvycZ3wkOgYrIJhFCQXgiP+1/jJjCJEtOlAA6frww8qEAwA7ZU54w7ofB3p4kcd74CaKs5
        QgSDUHoVtFY0CIMcRsuh/6ZPGJRwelgIf3SX4cFATOtg3echQZBJejG0HHWAIItoJXzQPYAF
        maAjYctoy5gTTqfAJrf1nzMNPrzkHVsWQi+Bra32sWU4HQV/F3fg4yyB3d7L2DjPgrd8NvwM
        EFsn1K0TKtYJFeuEih0QDhDGGXmNWsMzMl6l4Y1atSxDp3GCwD3dbPa73KCjJrkR0BSQThG1
        VhZuFwtUOXyuphFACpeGiao1gZFopyp3H6fXpemN2RzfCBICn7PgEeEZusB1ag1pTAKjQImM
        Qq6QL0JSiegY3ZAqptUqA7eb4/Zw+v89jAqJOATmdbWbzbupjHS/BHu5Pz3Z8n5zWlMK1K4R
        js7aURxTpH7lKHJF1pbIMzYueLRsnW7u1I3ql5OJpaUHCsin55Iv5a9azUQWqEvTRBbLsSiJ
        4nbz3RP+OT1np/7ElVURucon/UT8rg+2whuPlq+13svb5Mmab7d/yTXz7LOYKnfeSinBZ6qY
        aFzPq/4COBkTEmUDAAA=
X-CMS-MailID: 20200415101829eucas1p18e21324d3c39926fffc6c8b5dc52f206
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200415101829eucas1p18e21324d3c39926fffc6c8b5dc52f206
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200415101829eucas1p18e21324d3c39926fffc6c8b5dc52f206
References: <20200407174926.23971-1-andrzej.p@collabora.com>
        <20200407174926.23971-8-andrzej.p@collabora.com>
        <CGME20200415101829eucas1p18e21324d3c39926fffc6c8b5dc52f206@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/20 7:49 PM, Andrzej Pietrasiewicz wrote:
> thermal/of calls its own ->set_mode() method, so monitor thermal zone
> afterwards. This is needed for the DISABLED->ENABLED transition.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/thermal/of-thermal.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index b7621dfab17c..cf2c43ebcb78 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -523,8 +523,11 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id, void *data,
>  		if (sensor_specs.np == sensor_np && id == sensor_id) {
>  			tzd = thermal_zone_of_add_sensor(child, sensor_np,
>  							 data, ops);
> -			if (!IS_ERR(tzd))
> +			if (!IS_ERR(tzd)) {
>  				tzd->ops->set_mode(tzd, THERMAL_DEVICE_ENABLED);
> +				thermal_zone_device_update(tzd,
> +						THERMAL_EVENT_UNSPECIFIED);
> +			}
>  
>  			of_node_put(sensor_specs.np);
>  			of_node_put(child);
> 

This patch is bogus/redundant, please look at ->set_mode implementation for
thermal/of drivers:

static int of_thermal_set_mode(struct thermal_zone_device *tz,
			       enum thermal_device_mode mode)
{
	struct __thermal_zone *data = tz->devdata;

	mutex_lock(&tz->lock);

	if (mode == THERMAL_DEVICE_ENABLED) {
		tz->polling_delay = data->polling_delay;
		tz->passive_delay = data->passive_delay;
	} else {
		tz->polling_delay = 0;
		tz->passive_delay = 0;
	}

	mutex_unlock(&tz->lock);

	data->mode = mode;
	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);

	return 0;
}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
