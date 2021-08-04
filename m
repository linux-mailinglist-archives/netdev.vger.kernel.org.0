Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680433E09A6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbhHDUxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237989AbhHDUxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 16:53:21 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52041C061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 13:53:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id j3so4422693plx.4
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 13:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rK3k+rHc8/RnfuN3prVZdmtdlxSgIiV7Am4HL9pa+EE=;
        b=z4wh9vO35AyKSHTEq83Ox3ONe5kSLlV6p6v6I70eE7eo32A3/xb4LfMwlgBz2F1dR0
         ACaL8TA6u0a71F84LaJZja6HQNMXZiiI0QzUk84kz+4kvGKy4twIYxxoMve7qF7BBPkF
         IWyGICKoRWHWP2tgRjEIwu9rUNvbeqwESDId7zSA4bT0sn5D6wRQFbroBDDodREnt0SC
         jOWfRtWdlboGt5VfbNC/kBxzrWLvwbm3L7IBmk1ff1+VPxkd00pUWjQcreO+gMn9F1LH
         LXzI0MVH9oU0sjnIXjdXRVharjZcP4lipatd0FvGojzbUB31/3KzOJ+r+3+bwXy24BQC
         HsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rK3k+rHc8/RnfuN3prVZdmtdlxSgIiV7Am4HL9pa+EE=;
        b=BqVV3nz7KON7P5RI7DmJjJgoH0EZKE4lZmRJsd+hLCLpKHsqu73+5xZZdCBWEOAl8b
         sOo32TfN6/n9UGIi/VlF214wM7BhXqo1xUSefpM37RKwUwG7bfX6sg7U6dyDraPY3pyD
         AbqsdIowwGo2Dp3Ysbp6/YKtMDsE3QQy6oUH5S91qJueXV0XnOVU2Hf6ETHWUPu1bEmt
         K/pH7sDBoRiYTauUDOJvLPQ0Pfsa62arFbzs0yqxVavWF7p48rRKs1n4xoM+jS1WDnZf
         SlICmD8jwo/EEnd2EwHKCEAWsGG1/aeMTsSOCkJ+sQ2mBa7z2/pWSBySxoqpGAXuNwy4
         fNtA==
X-Gm-Message-State: AOAM530q2SNxwVOkmGpC2J/DFeU63jJ4q6AVa1pNcs6QVD/M3xFBRO7B
        /v8ThA+85Bb8DVRzCdZKCr5kfg==
X-Google-Smtp-Source: ABdhPJxmqvMa7dvxygw6pvQHFSb91+HBNZcfuAfCw2o0x4Q9n3vPAkr6yQpeRTCbfkRnqswKx2a+vQ==
X-Received: by 2002:a63:e214:: with SMTP id q20mr957879pgh.134.1628110387829;
        Wed, 04 Aug 2021 13:53:07 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id p17sm7195060pjg.54.2021.08.04.13.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:53:07 -0700 (PDT)
Subject: Re: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        drivers@pensando.io, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <20210804121318.337276-1-arnd@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <61f766be-b384-29a5-3bf1-c8f3ac6c4a94@pensando.io>
Date:   Wed, 4 Aug 2021 13:53:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804121318.337276-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 4:57 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent
> it from being disabled manually or built as a loadable module when the
> user is built-in. In the ICE driver, the latter now causes a link failure:
>
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_eth_ioctl':
> ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
> ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_get_ts_config'
> aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to `ice_ptp_set_ts_config'
> ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_set_ts_config'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_prepare_for_reset':
> ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
> ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_release'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_rebuild':
>
> This is a recurring problem in many drivers, and we have discussed
> it several times befores, without reaching a consensus. I'm providing
> a link to the previous email thread for reference, which discusses
> some related problems.
>
> To solve the dependency issue better than the 'imply' keyword, introduce a
> separate Kconfig symbol "CONFIG_PTP_1588_CLOCK_OPTIONAL" that any driver
> can depend on if it is able to use PTP support when available, but works
> fine without it. Whenever CONFIG_PTP_1588_CLOCK=m, those drivers are
> then prevented from being built-in, the same way as with a 'depends on
> PTP_1588_CLOCK || !PTP_1588_CLOCK' dependency that does the same trick,
> but that can be rather confusing when you first see it.
>
> Since this should cover the dependencies correctly, the IS_REACHABLE()
> hack in the header is no longer needed now, and can be turned back
> into a normal IS_ENABLED() check. Any driver that gets the dependency
> wrong will now cause a link time failure rather than being unable to use
> PTP support when that is in a loadable module.
>
> However, the two recently added ptp_get_vclocks_index() and
> ptp_convert_timestamp() interfaces are only called from builtin code with
> ethtool and socket timestamps, so keep the current behavior by stubbing
> those out completely when PTP is in a loadable module. This should be
> addressed properly in a follow-up.
>
> As Richard suggested, we may want to actually turn PTP support into a
> 'bool' option later on, preventing it from being a loadable module
> altogether, which would be one way to solve the problem with the ethtool
> interface.
>
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
> Link: https://lore.kernel.org/netdev/CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/20210726084540.3282344-1-arnd@kernel.org/
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v3:
> - rewrite to introduce a new PTP_1588_CLOCK_OPTIONAL symbol
> - use it for all driver, not just Intel's
> - change IS_REACHABLE() to IS_ENABLED() in the header
>
> Changes in v2:
> - include a missing patch hunk
> - link to a previous discussion with Richard Cochran
> ---
>   drivers/net/dsa/mv88e6xxx/Kconfig             |  1 +
>   drivers/net/dsa/ocelot/Kconfig                |  2 +
>   drivers/net/ethernet/amd/Kconfig              |  2 +-
>   drivers/net/ethernet/broadcom/Kconfig         |  6 +--
>   drivers/net/ethernet/cadence/Kconfig          |  1 +
>   drivers/net/ethernet/cavium/Kconfig           |  4 +-
>   drivers/net/ethernet/freescale/Kconfig        |  2 +-
>   drivers/net/ethernet/hisilicon/Kconfig        |  2 +-
>   drivers/net/ethernet/intel/Kconfig            | 14 +++---
>   drivers/net/ethernet/mellanox/mlx4/Kconfig    |  2 +-
>   .../net/ethernet/mellanox/mlx5/core/Kconfig   |  2 +-
>   drivers/net/ethernet/mellanox/mlxsw/Kconfig   |  2 +-
>   drivers/net/ethernet/mscc/Kconfig             |  2 +
>   drivers/net/ethernet/oki-semi/pch_gbe/Kconfig |  1 +
>   drivers/net/ethernet/pensando/Kconfig         |  2 +-

[...]

>   drivers/net/ethernet/qlogic/Kconfig           |  2 +-
> diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
> index 202973a82712..3f7519e435b8 100644
> --- a/drivers/net/ethernet/pensando/Kconfig
> +++ b/drivers/net/ethernet/pensando/Kconfig
> @@ -20,7 +20,7 @@ if NET_VENDOR_PENSANDO
>   config IONIC
>   	tristate "Pensando Ethernet IONIC Support"
>   	depends on 64BIT && PCI
> -	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
> +	depends on PTP_1588_CLOCK_OPTIONAL
>   	select NET_DEVLINK
>   	select DIMLIB
>   	help
>

Acked-by: Shannon Nelson <snelson@pensando.io>

