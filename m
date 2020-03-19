Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0CA18B7D8
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgCSNgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:36:18 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39304 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgCSNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:10:17 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JDA5DD061902;
        Thu, 19 Mar 2020 08:10:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584623405;
        bh=SBBrZzkb2E7HPlrCtxk5PrJICSjHhhKeRTUaGwHvp9k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UDPiBny1cnDEdprAZNdpNaemRHJTpRRzgaa5v/D0PRJBleLTQ5iCh/p2+vvN90Q12
         EbVkbI/y2CPZFoKwNrXPSomlHorO7MDFo+dTgSxGyAyCqFEJ16e7CU7R6DN+AyPxM9
         /Ze7wqHFuyqX51gpcUtXdweqQndXZn1ST7lvg+ug=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JDA5C6074181
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 08:10:05 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 08:10:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 08:10:05 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JDA0oK003728;
        Thu, 19 Mar 2020 08:10:02 -0500
Subject: Re: [PATCH net-next v4 06/11] net: ethernet: ti: introduce
 am65x/j721e gigabit eth subsystem driver
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20200317072739.23950-1-grygorii.strashko@ti.com>
 <20200317072739.23950-7-grygorii.strashko@ti.com>
 <dcd70320-8f1e-dbb5-c275-3b203e9b5851@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <78bc1ee2-5a56-82e7-229d-52cea8002eec@ti.com>
Date:   Thu, 19 Mar 2020 15:09:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <dcd70320-8f1e-dbb5-c275-3b203e9b5851@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/03/2020 13:46, Peter Ujfalusi wrote:
> Hi Grygorii,
> 
> On 17/03/2020 9.27, Grygorii Strashko wrote:
>> The TI AM65x/J721E SoCs Gigabit Ethernet Switch subsystem (CPSW2G NUSS) has
>> two ports - One Ethernet port (port 1) with selectable RGMII and RMII
>> interfaces and an internal Communications Port Programming Interface (CPPI)
>> port (Host port 0) and with ALE in between. It also contains
>>   - Management Data Input/Output (MDIO) interface for physical layer device
>> (PHY) management;
>>   - Updated Address Lookup Engine (ALE) module;
>>   - (TBD) New version of Common platform time sync (CPTS) module.
>>
>> On the TI am65x/J721E SoCs CPSW NUSS Ethernet subsystem into device MCU
>> domain named MCU_CPSW0.
>>
>> Host Port 0 CPPI Packet Streaming Interface interface supports 8 TX
>> channels and one RX channels operating by TI am654 NAVSS Unified DMA
>> Peripheral Root Complex (UDMA-P) controller.
>>
>> Introduced driver provides standard Linux net_device to user space and supports:
>>   - ifconfig up/down
>>   - MAC address configuration
>>   - ethtool operation:
>>     --driver
>>     --change
>>     --register-dump
>>     --negotiate phy
>>     --statistics
>>     --set-eee phy
>>     --show-ring
>>     --show-channels
>>     --set-channels
>>   - net_device ioctl mii-control
>>   - promisc mode
>>
>>   - rx checksum offload for non-fragmented IPv4/IPv6 TCP/UDP packets.
>>     The CPSW NUSS can verify IPv4/IPv6 TCP/UDP packets checksum and fills
>>     csum information for each packet in psdata[2] word:
>>     - BIT(16) CHECKSUM_ERROR - indicates csum error
>>     - BIT(17) FRAGMENT -  indicates fragmented packet
>>     - BIT(18) TCP_UDP_N -  Indicates TCP packet was detected
>>     - BIT(19) IPV6_VALID,  BIT(20) IPV4_VALID - indicates IPv6/IPv4 packet
>>     - BIT(15, 0) CHECKSUM_ADD - This is the value that was summed
>>     during the checksum computation. This value is FFFFh for non fragmented
>>     IPV4/6 UDP/TCP packets with no checksum error.
>>
>>     RX csum offload can be disabled:
>> 	 ethtool -K <dev> rx-checksum on|off
>>
>>   - tx checksum offload support for IPv4/IPv6 TCP/UDP packets (J721E only).
>>     TX csum HW offload  can be enabled/disabled:
>> 	 ethtool -K <dev> tx-checksum-ip-generic on|off
>>
>>   - multiq and switch between round robin/prio modes for cppi tx queues by
>>     using Netdev private flag "p0-rx-ptype-rrobin" to switch between
>>     Round Robin and Fixed priority modes:
>> 	 # ethtool --show-priv-flags eth0
>> 	 Private flags for eth0:
>> 	 p0-rx-ptype-rrobin: on
>> 	 # ethtool --set-priv-flags eth0 p0-rx-ptype-rrobin off
>>
>>     Number of TX DMA channels can be changed using "ethtool -L eth0 tx <N>".
>>
>>   - GRO support: the napi_gro_receive() and napi_complete_done() are used.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/ethernet/ti/Kconfig             |   19 +-
>>   drivers/net/ethernet/ti/Makefile            |    3 +
>>   drivers/net/ethernet/ti/am65-cpsw-ethtool.c |  747 +++++++
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.c    | 1965 +++++++++++++++++++
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.h    |  143 ++
>>   drivers/net/ethernet/ti/k3-udma-desc-pool.c |  126 ++
>>   drivers/net/ethernet/ti/k3-udma-desc-pool.h |   30 +
> 
> I would rather loose the 'udma' from the name and API. It is more like
> CPPI5 descriptor pool than UDMA. UDMA is just happen to use CPPI5.
> Probably ti-cppi5-desc-pool?

ok. I'll update and re-send

> 
>>   7 files changed, 3031 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/ti/am65-cpsw-ethtool.c
>>   create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>   create mode 100644 drivers/net/ethernet/ti/am65-cpsw-nuss.h
>>   create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.c
>>   create mode 100644 drivers/net/ethernet/ti/k3-udma-desc-pool.h
> 
>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>> index 8a6ca16eee3b..89cec778cf2d 100644
>> --- a/drivers/net/ethernet/ti/Kconfig
>> +++ b/drivers/net/ethernet/ti/Kconfig
>> @@ -6,7 +6,7 @@
>>   config NET_VENDOR_TI
>>   	bool "Texas Instruments (TI) devices"
>>   	default y
>> -	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE
>> +	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3
>>   	---help---
>>   	  If you have a network (Ethernet) card belonging to this class, say Y.
>>   
>> @@ -31,7 +31,7 @@ config TI_DAVINCI_EMAC
>>   
>>   config TI_DAVINCI_MDIO
>>   	tristate "TI DaVinci MDIO Support"
>> -	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
>> +	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST
>>   	select PHYLIB
>>   	---help---
>>   	  This driver supports TI's DaVinci MDIO module.
>> @@ -95,6 +95,21 @@ config TI_CPTS_MOD
>>   	imply PTP_1588_CLOCK
>>   	default m
>>   
>> +config TI_K3_AM65_CPSW_NUSS
>> +	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
>> +	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
>> +	select TI_DAVINCI_MDIO
>> +	imply PHY_TI_GMII_SEL
>> +	help
>> +	  This driver supports TI K3 AM654/J721E CPSW2G Ethernet SubSystem.
>> +	  The two-port Gigabit Ethernet MAC (MCU_CPSW0) subsystem provides
>> +	  Ethernet packet communication for the device: One Ethernet port
>> +	  (port 1) with selectable RGMII and RMII interfaces and an internal
>> +	  Communications Port Programming Interface (CPPI) port (port 0).
>> +
>> +	  To compile this driver as a module, choose M here: the module
>> +	  will be called ti-am65-cpsw-nuss.
>> +
>>   config TI_KEYSTONE_NETCP
>>   	tristate "TI Keystone NETCP Core Support"
>>   	select TI_DAVINCI_MDIO
>> diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
>> index ecf776ad8689..6362a9b0bb8a 100644
>> --- a/drivers/net/ethernet/ti/Makefile
>> +++ b/drivers/net/ethernet/ti/Makefile
>> @@ -23,3 +23,6 @@ obj-$(CONFIG_TI_KEYSTONE_NETCP) += keystone_netcp.o
>>   keystone_netcp-y := netcp_core.o cpsw_ale.o
>>   obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) += keystone_netcp_ethss.o
>>   keystone_netcp_ethss-y := netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o cpsw_ale.o
>> +
>> +obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) += ti-am65-cpsw-nuss.o
>> +ti-am65-cpsw-nuss-y := am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cpsw_ale.o k3-udma-desc-pool.o
> 
> Would not be better to have the desc-pool (silent) Kconfig selectable?
> The not yet upstream icssg-prueth also needs the same desc-pool library
> as cpsw.
>

I'd prefer not to add new Kconfig options unless required.
This driver simply not work without it, so no Kconfig option for now.

-- 
Best regards,
grygorii
