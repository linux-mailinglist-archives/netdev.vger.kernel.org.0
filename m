Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC3307B23
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhA1Qiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhA1QiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:38:09 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4089BC061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:37:29 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id r12so8706544ejb.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FxpXC795C1PwI4TBIT6W0rcGCi09uioONR7GXp5aguQ=;
        b=JX125lGfXAXoLnlGntGl+N26KoubKtFeqq85fjMFJ/QB+sgM6qcoxzOzk+Rh2yKnOd
         ZrWZzL5sUKDgecVbO1QJ/zmAJ0mLwjvqMU6hVuGyumlmu8JMNcMS5yUTJCTBJItYZTAR
         TYd+9SuBcyXAGxoO2YygNRZRz+jUPhA5vg6ZAnkGhshjQNz58Fvy+3uBSrjNPYH3RJvP
         IAqrFKLK6xgHuYYCiW+GVNVAuvwYHWK+xQ1lku5Mcb/tKBILvrIv+B1/6s1pZyo/KVbn
         xPfqPMRLvGlpUrfBowKoEVgrUTuuqL86tal071kH/DAC8Lh885cxJgdgmn7mtmuPwcTj
         zM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FxpXC795C1PwI4TBIT6W0rcGCi09uioONR7GXp5aguQ=;
        b=gCqB0Ghx/6/TLWlV+IBX3/4KnuO5Po/6zZjJpo4Zat0etkXsE+Nrvv7pjDPmPSv+Ob
         RU7fIJvwqkMJblydcmTvbHa4tlNNBDNLCH71PpTsjXvA1v4G+Atl2S9oyYnTQ2IUWTX5
         kA2CLgcQYnq+AQd/+z8tJLj6gEd024ZhjG3+kezw7Xs/+jDQ4xlDH3tbDdE5fa0HwM2z
         h/q8BoRwhAlPdWe0XiP9JDhQXWRzdWIY8g6DJnXxEE0K5kfEReeYJZsNELK79k9rSTkx
         jWebQANPBtii+iwDD+HMdLsYzl/AmvEsvO1xhelgqH3gdqNdxpelp6fXqb4pegO2yau8
         15UQ==
X-Gm-Message-State: AOAM5307PgfWC2sd/UR1q1qg4gvPut2+ddYezZPoOqbsUbMUugsvOo30
        Iv9E7jt967tjJqvJYo/XWe0=
X-Google-Smtp-Source: ABdhPJziiKI/qupOXzXtKxZHr739eapbf7e6DBlnSC5V08HGdnVnYGBaiuuMJHRGiqBhOPhVPy5epw==
X-Received: by 2002:a17:906:a384:: with SMTP id k4mr240414ejz.194.1611851846836;
        Thu, 28 Jan 2021 08:37:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u9sm3266313edv.32.2021.01.28.08.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 08:37:26 -0800 (PST)
Date:   Thu, 28 Jan 2021 18:37:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO
 dependency
Message-ID: <20210128163724.q7d2j57phwbmbh7w@skbuf>
References: <20210128163338.22665-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128163338.22665-1-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 05:33:38PM +0100, Kurt Kanzenbach wrote:
> Add missing dependency to TAPRIO to avoid build failures such as:
>
> |ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> |ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
>
> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/hirschmann/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> Note: It's not against net, because the fixed commit is not in net tree, yet.
>
> diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
> index e01191107a4b..9ea2c643f8f8 100644
> --- a/drivers/net/dsa/hirschmann/Kconfig
> +++ b/drivers/net/dsa/hirschmann/Kconfig
> @@ -5,6 +5,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
>  	depends on NET_DSA
>  	depends on PTP_1588_CLOCK
>  	depends on LEDS_CLASS
> +	depends on NET_SCH_TAPRIO
>  	select NET_DSA_TAG_HELLCREEK
>  	help
>  	  This driver adds support for Hirschmann Hellcreek TSN switches.
> --
> 2.20.1
>

Note that for sja1105, Arnd solved it this way. I am still not sure why.

commit 5d294fc483405de9c0913ab744a31e6fa7cb0f40
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Oct 25 09:26:35 2019 +0200

    net: dsa: sja1105: improve NET_DSA_SJA1105_TAS dependency

    An earlier bugfix introduced a dependency on CONFIG_NET_SCH_TAPRIO,
    but this missed the case of NET_SCH_TAPRIO=m and NET_DSA_SJA1105=y,
    which still causes a link error:

    drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_setup_tc_taprio':
    sja1105_tas.c:(.text+0x5c): undefined reference to `taprio_offload_free'
    sja1105_tas.c:(.text+0x3b4): undefined reference to `taprio_offload_get'
    drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_tas_teardown':
    sja1105_tas.c:(.text+0x6ec): undefined reference to `taprio_offload_free'

    Change the dependency to only allow selecting the TAS code when it
    can link against the taprio code.

    Fixes: a8d570de0cc6 ("net: dsa: sja1105: Add dependency for NET_DSA_SJA1105_TAS")
    Fixes: 317ab5b86c8e ("net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload")
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index f40b248f0b23..ffac0ea4e8d5 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -26,8 +26,8 @@ config NET_DSA_SJA1105_PTP

 config NET_DSA_SJA1105_TAS
        bool "Support for the Time-Aware Scheduler on NXP SJA1105"
-       depends on NET_DSA_SJA1105
-       depends on NET_SCH_TAPRIO
+       depends on NET_DSA_SJA1105 && NET_SCH_TAPRIO
+       depends on NET_SCH_TAPRIO=y || NET_DSA_SJA1105=m
        help
          This enables support for the TTEthernet-based egress scheduling
          engine in the SJA1105 DSA driver, which is controlled using a
