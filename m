Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8442876EE
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgJHPPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:15:15 -0400
Received: from mail-am6eur05on2069.outbound.protection.outlook.com ([40.107.22.69]:11904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730650AbgJHPPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 11:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX7IaCTlLtYG5AuHwlSfHQPkNIVlBQVRTtWJkjuIlyM=;
 b=nuW8tl+3VGTP9a1FRaVOhjU2mzKYfdBddrGl0y4yl3MICIhHcFOTp8btdvSUBxM3nR6/qNH3ZHfbXZaTIg7H+J/RJPVpKKpUAcC2J8AaLcCdm+S4Snd9hcHIg+e3fmJLL/wH2z2eIjuPoQ/CUQjVjyox/CuU/oLuzfWIN2uu17c=
Received: from MR2P264CA0035.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::23) by
 DB7PR08MB3867.eurprd08.prod.outlook.com (2603:10a6:10:7f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.37; Thu, 8 Oct 2020 15:15:09 +0000
Received: from VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:0:cafe::c0) by MR2P264CA0035.outlook.office365.com
 (2603:10a6:500::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend
 Transport; Thu, 8 Oct 2020 15:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT003.mail.protection.outlook.com (10.152.18.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23 via Frontend Transport; Thu, 8 Oct 2020 15:15:08 +0000
Received: ("Tessian outbound 7a6fb63c1e64:v64"); Thu, 08 Oct 2020 15:15:08 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 19cca4a1fe76f0f0
X-CR-MTA-TID: 64aa7808
Received: from a404e1ccae16.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7B827246-6D10-4899-8288-886D324ED575.1;
        Thu, 08 Oct 2020 15:14:33 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a404e1ccae16.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 08 Oct 2020 15:14:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyddwOUReVAHCOJ+okQrGogcA7PRvLacg93p4S3JyWfVxag7MWlAmU8kFHuPQglpUhA2tRjdkda4a7S3ExpFaq8hHz2fq/KKUDNUByW+QtNH+7KLNCGbjTPrWo2qIeXm4FaeDhvELHSugHVpeeIRHIOTtQ5M/XIW4WiUwjWq/IjIag/225JILbU+Sogb+8YQ4rLi9cBU6gz79bA515UYFEgQPpDSIYGmNJQY9z0i5unjJTwGT8CULrcu+LbmupleFG4olSEQnuTyMDP/cgXYF+BTrxka9bZTUJkWQnRJh2dh40c+X8aQX0WdPyfIEg/wY8IoeL8JljXOSh+85UKv8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX7IaCTlLtYG5AuHwlSfHQPkNIVlBQVRTtWJkjuIlyM=;
 b=Gem2yvanvovU4PvhtZI6wTWB1pLWnJQ9kx+KVbtw+BOf/uk7fafpD59fDc9NXkwscvW1EDmxslxk2hW+bXVjIGjqReVThfAE87Iy9E9eGUd4XnwZQMRCDs7VBNiTO0IbyHG22z9FBArrwmSomCeG6QCIAk5PdOW9IYgnVLjmemuyhEDlatz5ChWvkoDQFmQab47Z2lXoM1dEFfn4GH4BX9zVOORCIZ2HLJqhoAsHtU6KwL9Yte5FWUtTp987xSZoepqT72wvk3SdgYOGTF3r098T6T18d5fqNnwW5fRZ3KaVGC8Q9GAsMUZ4Lh0p6dvnmWiATx4lK5c6H5StwYMUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX7IaCTlLtYG5AuHwlSfHQPkNIVlBQVRTtWJkjuIlyM=;
 b=nuW8tl+3VGTP9a1FRaVOhjU2mzKYfdBddrGl0y4yl3MICIhHcFOTp8btdvSUBxM3nR6/qNH3ZHfbXZaTIg7H+J/RJPVpKKpUAcC2J8AaLcCdm+S4Snd9hcHIg+e3fmJLL/wH2z2eIjuPoQ/CUQjVjyox/CuU/oLuzfWIN2uu17c=
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com (2603:10a6:10:ab::15)
 by DBBPR08MB4903.eurprd08.prod.outlook.com (2603:10a6:10:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Thu, 8 Oct
 2020 15:14:30 +0000
Received: from DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::98af:2036:2908:bb3a]) by DB8PR08MB4010.eurprd08.prod.outlook.com
 ([fe80::98af:2036:2908:bb3a%5]) with mapi id 15.20.3433.045; Thu, 8 Oct 2020
 15:14:30 +0000
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to
 drivers/net/mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        robh+dt@kernel.org
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <35c67d2a-4458-118a-1b8c-6ad23acaad23@arm.com>
Date:   Thu, 8 Oct 2020 16:14:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.30.223.185]
X-ClientProxiedBy: LO2P265CA0134.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::26) To DB8PR08MB4010.eurprd08.prod.outlook.com
 (2603:10a6:10:ab::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.178] (188.30.223.185) by LO2P265CA0134.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Thu, 8 Oct 2020 15:14:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b147b253-8ac1-443a-099e-08d86b9cf17f
X-MS-TrafficTypeDiagnostic: DBBPR08MB4903:|DB7PR08MB3867:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3867B887D8DBB58BDD76F25D950B0@DB7PR08MB3867.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:473;OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: fLgsTH3SxrZHw4R6/Xte0fBqQUTTkqHkEQlCQ5z5rYUEXYe9rQXkAtnmLvylMcu9cECtBXbQKEaPZVPuBcIdz+fxQD8fMpGjxiBGUiK3FQzzrWWedarnZLYf0UuG8pHSdSzXcRGkwV1h+5Na5AmpoZ3rX4zvEQNLvMysT1H6TX+YVCSpXVlWrl0d4Mwe4VERmM7Lw8tPAExXMef7P57LonFaI+6UOewW4drByirRoW7H93dnNfncsAzr5Z+F9dZk2nyplF5+hMinH265VRpIUb3RVMQMi9ioeEGTcvBMGI/irmXA3gOPyeQkIytLUl4mfmPQ6R7JJCkpusugsRUoPmhSO4+ZPiV6peahdhhbhktnKf7dm5dKSWzLsIgVLUxvy5dKyfv9//sODzdMcX8pVQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB4010.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(8676002)(2616005)(7416002)(36756003)(66476007)(66556008)(478600001)(66946007)(956004)(31696002)(186003)(54906003)(316002)(5660300002)(16576012)(6486002)(4326008)(52116002)(31686004)(86362001)(53546011)(55236004)(26005)(110136005)(83380400001)(16526019)(2906002)(44832011)(8936002)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UuXsKZuaoi6vcHNNOwLLoW29EX21BzJH6wC+47DGl4djCsEoC2NayPfLpUjuNixfApQmlNJGSdXdPSoY4WKbQ68quFZirPuTw2yLmZ24oD74Hf5uClzAz+USdB5IibRdlXZturtJNOiTGl1qglRGvYHBmY36TpXcjsJ7H27Qi+0OoQDr/Kap5fBn4XtGxpjZGpzPCif19esf2DNo5CS+ej/o1A9+nc+IK9YTkzVdxxt5ytltkGX24HOmHexIkv5Rdl1Te64g2fyZdHqo/ioGG7Swbjwu+fkSFuI8YFWCMqBh+cxoK7dUxh74kP6Ds7J+q4zRv9/UToBpOWGano/FSnpw6+Jc42skNCChgijpVuUclrFGlSl4HHeJD+6ApaT4S2gjzfjH6xKX+6END8A16OEVwSoy16eaZHXSL7DNeCE/xlmFLc4jykNp+o+g8YK62LYR873LnJjf7+jB738hO6tOP4uIpqlxdxW7Dg2fEeKZ4vCQS2aJhCpm6+tff+UwtLwl1dTQIchwfnn5rHKhmyRqdKbye7RWiuh8nHHOQeokyeRMqPKQhToaXBZRMIZqrYbb6D3HyYwPN71GuPp2stbZrFm74Hr3pSoQ6DWx1JKh9yCh05Y/T5YKKdbN4QoAzlEettg/0QMOp/OEPcDEHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4903
Original-Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: d889bf68-b14f-45a6-5239-08d86b9cda98
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMQPNeTeHDPdlZME0ahowalk2VymHk8wKuwFuuz+LFKVGzkGa104hAtb6Qk6Za2blKRl9L1P20owTQK3iXYGLUZB+6pP8IGHToyNlr9suYthVhl/zFXRQbH2KE1RImu/6CRichy3xjIzynQqHO02PD0gEja4dVeUqbfXwbeOtm4q56ad/cwH+Uu3RU4rq1twst8hodDm/WIXr0UQcYhqVHlCsKZ0Y9I6An/tMYj9+QpR41KLlmbX6ye1SI0Pgc+8SEsWba+aZShAl8N3BwK3bKwgIIkKFk9CgKaX+SdXALezIUKNA+wbJMaOtIU2hsggEVFjXH15/c9Tz1yOQBm+sApy+wmm+2sFcB4awLzeAnGNNgGdktPqwYRetQpiUqF5owR69JHAu2pwRqxcMIZwaYtbUfGMkbsSvi7d/o7I+ESNT5ZKpftHPOcL+ERHoWWy
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966005)(8676002)(47076004)(54906003)(5660300002)(36756003)(4326008)(31686004)(956004)(450100002)(44832011)(16576012)(336012)(82310400003)(2616005)(478600001)(16526019)(110136005)(82740400003)(70586007)(6486002)(70206006)(356005)(31696002)(83380400001)(26005)(186003)(86362001)(81166007)(53546011)(55236004)(316002)(8936002)(2906002)(921003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 15:15:08.1491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b147b253-8ac1-443a-099e-08d86b9cf17f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT003.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3867
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/10/2020 15:47, Calvin Johnson wrote:
> Better place for of_mdio.c is drivers/net/mdio.
> Move of_mdio.c from drivers/of to drivers/net/mdio
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

In-Principle-Acked-By: Grant Likely <grant.likely@arm.com>

... but I've not tested or compiled *anything*!

g.

> ---
> 
>   MAINTAINERS                        | 2 +-
>   drivers/net/mdio/Kconfig           | 8 ++++++++
>   drivers/net/mdio/Makefile          | 2 ++
>   drivers/{of => net/mdio}/of_mdio.c | 0
>   drivers/of/Kconfig                 | 7 -------
>   drivers/of/Makefile                | 1 -
>   6 files changed, 11 insertions(+), 9 deletions(-)
>   rename drivers/{of => net/mdio}/of_mdio.c (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8ff71b1a4a99..d1b82a3a1843 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6525,9 +6525,9 @@ F:	Documentation/devicetree/bindings/net/mdio*
>   F:	Documentation/devicetree/bindings/net/qca,ar803x.yaml
>   F:	Documentation/networking/phy.rst
>   F:	drivers/net/mdio/
> +F:	drivers/net/mdio/of_mdio.c
>   F:	drivers/net/pcs/
>   F:	drivers/net/phy/
> -F:	drivers/of/of_mdio.c
>   F:	drivers/of/of_net.c
>   F:	include/dt-bindings/net/qca-ar803x.h
>   F:	include/linux/*mdio*.h
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 27a2a4a3d943..a10cc460d7cf 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -19,6 +19,14 @@ config MDIO_BUS
>   	  reflects whether the mdio_bus/mdio_device code is built as a
>   	  loadable module or built-in.
>   
> +config OF_MDIO
> +	def_tristate PHYLIB
> +	depends on OF
> +	depends on PHYLIB
> +	select FIXED_PHY
> +	help
> +	  OpenFirmware MDIO bus (Ethernet PHY) accessors
> +
>   if MDIO_BUS
>   
>   config MDIO_DEVRES
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 14d1beb633c9..5c498dde463f 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -1,6 +1,8 @@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for Linux MDIO bus drivers
>   
> +obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
> +
>   obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
>   obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
>   obj-$(CONFIG_MDIO_BCM_UNIMAC)		+= mdio-bcm-unimac.o
> diff --git a/drivers/of/of_mdio.c b/drivers/net/mdio/of_mdio.c
> similarity index 100%
> rename from drivers/of/of_mdio.c
> rename to drivers/net/mdio/of_mdio.c
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index d91618641be6..18450437d5d5 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -74,13 +74,6 @@ config OF_NET
>   	depends on NETDEVICES
>   	def_bool y
>   
> -config OF_MDIO
> -	def_tristate PHYLIB
> -	depends on PHYLIB
> -	select FIXED_PHY
> -	help
> -	  OpenFirmware MDIO bus (Ethernet PHY) accessors
> -
>   config OF_RESERVED_MEM
>   	bool
>   	depends on OF_EARLY_FLATTREE
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index 663a4af0cccd..6e1e5212f058 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -9,7 +9,6 @@ obj-$(CONFIG_OF_ADDRESS)  += address.o
>   obj-$(CONFIG_OF_IRQ)    += irq.o
>   obj-$(CONFIG_OF_NET)	+= of_net.o
>   obj-$(CONFIG_OF_UNITTEST) += unittest.o
> -obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
>   obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>   obj-$(CONFIG_OF_RESOLVE)  += resolver.o
>   obj-$(CONFIG_OF_OVERLAY) += overlay.o
> 
