Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41736DBAF
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhD1Pc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhD1Pc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:32:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B6C061573;
        Wed, 28 Apr 2021 08:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=GYT2LCMhy6nDkJqGf6hC469YOFILkKh7rgUUoEsmUHU=; b=pfBH3HSKGWjSfHp68rPUKeqfw4
        6fHTDaL1HDPrc63gyzKq16bRRDFfACS+sNnje9Y6jCSyex9++pAgdAIEz9TMbNxUAq+Zn/JL1PigG
        HffM2PqeWRm/MMA4y6oApi2g+FEn/rvRbPziphsIh5tvAzqc3RWH9aKBdQKD837FVOdbShC5fayHC
        ZchFv0aHaNoMumHHd0Z/NIRavDiiX6ogaLXLPjBoH+6llPzjtYVv0QMBWH1yaH8n8ZB++bA8xarQs
        +TVx+CxtrUiJwXFGFaF8Gbu5WxhxJbCujnVPr/Q7ZbAajhl4kaiLNm4mrRrB2XAUgXveaKKs1ifdB
        vADos5vg==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbm9o-008Sn1-LK; Wed, 28 Apr 2021 15:31:21 +0000
Subject: Re: [PATCH net-next v1 1/1] net: selftest: fix build issue if INET is
 disabled
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210428130947.29649-1-o.rempel@pengutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8a6612ee-8bb7-7287-265f-1a57d9532904@infradead.org>
Date:   Wed, 28 Apr 2021 08:31:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210428130947.29649-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 6:09 AM, Oleksij Rempel wrote:
> In case ethernet driver is enabled and INET is disabled, selftest will
> fail to build.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/ethernet/atheros/Kconfig   |  2 +-
>  drivers/net/ethernet/freescale/Kconfig |  2 +-
>  include/net/selftests.h                | 19 +++++++++++++++++++
>  net/Kconfig                            |  2 +-
>  net/core/Makefile                      |  2 +-
>  net/dsa/Kconfig                        |  2 +-
>  6 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
> index 6842b74b0696..482c58c4c584 100644
> --- a/drivers/net/ethernet/atheros/Kconfig
> +++ b/drivers/net/ethernet/atheros/Kconfig
> @@ -20,8 +20,8 @@ if NET_VENDOR_ATHEROS
>  config AG71XX
>  	tristate "Atheros AR7XXX/AR9XXX built-in ethernet mac support"
>  	depends on ATH79
> -	select NET_SELFTESTS
>  	select PHYLINK
> +	imply NET_SELFTESTS
>  	help
>  	  If you wish to compile a kernel for AR7XXX/91XXX and enable
>  	  ethernet support, then you should always answer Y to this.
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index 3d937b4650b2..2d1abdd58fab 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -26,8 +26,8 @@ config FEC
>  		   ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
>  	default ARCH_MXC || SOC_IMX28 if ARM
>  	select CRC32
> -	select NET_SELFTESTS
>  	select PHYLIB
> +	imply NET_SELFTESTS
>  	imply PTP_1588_CLOCK
>  	help
>  	  Say Y here if you want to use the built-in 10/100 Fast ethernet
> diff --git a/include/net/selftests.h b/include/net/selftests.h
> index 9993b9498cf3..61926c33a022 100644
> --- a/include/net/selftests.h
> +++ b/include/net/selftests.h
> @@ -4,9 +4,28 @@
>  
>  #include <linux/ethtool.h>
>  
> +#if IS_ENABLED(CONFIG_NET_SELFTESTS)
> +
>  void net_selftest(struct net_device *ndev, struct ethtool_test *etest,
>  		  u64 *buf);
>  int net_selftest_get_count(void);
>  void net_selftest_get_strings(u8 *data);
>  
> +#else
> +
> +static inline void net_selftest(struct net_device *ndev, struct ethtool_test *etest,
> +		  u64 *buf)
> +{
> +}
> +
> +static inline int net_selftest_get_count(void)
> +{
> +	return 0;
> +}
> +
> +static inline void net_selftest_get_strings(u8 *data)
> +{
> +}
> +
> +#endif
>  #endif /* _NET_SELFTESTS */
> diff --git a/net/Kconfig b/net/Kconfig
> index 8d955195c069..f5ee7c65e6b4 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -431,7 +431,7 @@ config SOCK_VALIDATE_XMIT
>  
>  config NET_SELFTESTS
>  	def_tristate PHYLIB
> -	depends on PHYLIB
> +	depends on PHYLIB && INET
>  
>  config NET_SOCK_MSG
>  	bool
> diff --git a/net/core/Makefile b/net/core/Makefile
> index 1a6168d8f23b..f7f16650fe9e 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_NETPOLL) += netpoll.o
>  obj-$(CONFIG_FIB_RULES) += fib_rules.o
>  obj-$(CONFIG_TRACEPOINTS) += net-traces.o
>  obj-$(CONFIG_NET_DROP_MONITOR) += drop_monitor.o
> +obj-$(CONFIG_NET_SELFTESTS) += selftests.o
>  obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += timestamping.o
>  obj-$(CONFIG_NET_PTP_CLASSIFY) += ptp_classifier.o
>  obj-$(CONFIG_CGROUP_NET_PRIO) += netprio_cgroup.o
> @@ -33,7 +34,6 @@ obj-$(CONFIG_NET_DEVLINK) += devlink.o
>  obj-$(CONFIG_GRO_CELLS) += gro_cells.o
>  obj-$(CONFIG_FAILOVER) += failover.o
>  ifeq ($(CONFIG_INET),y)
> -obj-$(CONFIG_NET_SELFTESTS) += selftests.o
>  obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
>  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
>  endif
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index cbc2bd643ab2..183e27b50202 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -9,7 +9,7 @@ menuconfig NET_DSA
>  	select NET_SWITCHDEV
>  	select PHYLINK
>  	select NET_DEVLINK
> -	select NET_SELFTESTS
> +	imply NET_SELFTESTS
>  	help
>  	  Say Y if you want to enable support for the hardware switches supported
>  	  by the Distributed Switch Architecture.
> 


-- 
~Randy

