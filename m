Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16F56B65EA
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 13:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCLMOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 08:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCLMOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 08:14:30 -0400
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642D36FE1;
        Sun, 12 Mar 2023 05:14:25 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailnew.west.internal (Postfix) with ESMTP id 2E8A02B066CB;
        Sun, 12 Mar 2023 08:14:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 12 Mar 2023 08:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678623258; x=1678630458; bh=uOiTi6/NTNM3M
        UGJcuvZvSM01KsroDdW5S+kXTtbd8w=; b=eHYyrL4NaW+yMUjCNptl5jYYtoi8E
        hLBKzStAuQkG4v/z4hhP3kqHJQ2dwsRiMM/zQZmYQuybV3ns2BtF/u+8yL8z2Lpx
        Fmm8zqjgnyTXuowli2+dSb8yfzjw4fhctK9VDp59jUGkHPWADWbTNq/qwMcS4V2D
        nJzvwzXB3DZqQONKCTj7Ai1tlKWl3EuFudxD2O4eOA/UZCCneHrJ2UESteRQ80wa
        DIqa4yLbBJCwUjKYoouq9gT2uFNwoaBp54W+m/0tweudxnh2fvhCVWnaKIgSmJRU
        6fTwksJ6D/49vNcKmO24kfNVAM+PfU+O0BFXGq6gmpmocg7/R3c1RWetw==
X-ME-Sender: <xms:GMINZGTf74JeblrjlpCh3YB4_QRRq8vjzK0oAN37uf84Wq2fmxR25A>
    <xme:GMINZLwR_DLRm0xvpbHAjBj56JOUxatnZe2vfFGNpmMYMmk-Rc5duszkyCP3ccJqd
    CMMbOhtJaOGzHw>
X-ME-Received: <xmr:GMINZD3N8oWjeD-ZblmcgytVfWOgbjI-9Urb4YeJ1SDeIiaSlgllXVS72rYf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvvddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GMINZCCd5Yv4ayURM5DOEpHnfT7iGftOXamBF3b0R3zWoNndjgvtew>
    <xmx:GMINZPhqsrHiMYhX0eZcE-3b2KPOlLyZft3GgY2KvKmPR4znhEQTFQ>
    <xmx:GMINZOr3mCJj8kq-QN1JeGycDSOV_iFTbuNK_uDCf3DOYZ8phjakwA>
    <xmx:GsINZCMz0m5ZZart7AcvGICSsoelDhvqQ3z5GzBg10_jUUYuoBThpmdI-JU>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Mar 2023 08:14:15 -0400 (EDT)
Date:   Sun, 12 Mar 2023 14:14:12 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Kaestle <peter@piie.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dmitry Osipenko <digetx@gmail.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        danieller@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com
Subject: Re: [PATCH v8 01/29] thermal/core: Add a generic
 thermal_zone_get_trip() function
Message-ID: <ZA3CFNhU4AbtsP4G@shredder>
References: <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <20221003092602.1323944-2-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003092602.1323944-2-daniel.lezcano@linaro.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 11:25:34AM +0200, Daniel Lezcano wrote:
> @@ -1252,9 +1319,10 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
>  		goto release_device;
>  
>  	for (count = 0; count < num_trips; count++) {
> -		if (tz->ops->get_trip_type(tz, count, &trip_type) ||
> -		    tz->ops->get_trip_temp(tz, count, &trip_temp) ||
> -		    !trip_temp)
> +		struct thermal_trip trip;
> +
> +		result = thermal_zone_get_trip(tz, count, &trip);
> +		if (result)
>  			set_bit(count, &tz->trips_disabled);
>  	}

Daniel, this change makes it so that trip points with a temperature of
zero are no longer disabled. This behavior was originally added in
commit 81ad4276b505 ("Thermal: Ignore invalid trip points"). The mlxsw
driver relies on this behavior - see mlxsw_thermal_module_trips_reset()
- and with this change I see that the thermal subsystem tries to
repeatedly set the state of the associated cooling devices to the
maximum state. Other drivers might also be affected by this.

Following patch solves the problem for me:

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 55679fd86505..b50931f84aaa 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1309,7 +1309,7 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
                struct thermal_trip trip;
 
                result = thermal_zone_get_trip(tz, count, &trip);
-               if (result)
+               if (result || !trip.temperature)
                        set_bit(count, &tz->trips_disabled);
        }

Should I submit it or do you have a better idea?

Thanks
