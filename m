Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE33F49C453
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbiAZHal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:30:41 -0500
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:25313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229681AbiAZHal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 02:30:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7BZw9g807hv94KCsYibUpMAax5B+nmlnnP5IgbNsxFSsNJ07ETPJz2wga95sEK4yqwz+Nd0WGanB8J6q9LuaVTZnYEb2Syl+FdloZG42VdIHMRLd21NfzxdXhIVkFXaoeAqw4C9KK/i3mSpaFxFMwRfOUGAGNa6P2yZ64L9F1eVsCtv2FeCFGlNfAiJPYDCzo+rdZThOPbzvAfUGkNVLsCR3Ajuw12Zg2YRri0RESv/Bk7tXs9D74taKkRDidjt9s1x2Tj8X8h4L1ScMPnOTd1vCoz5aPlJ/AHv+97Sm/TNI7SvwJ+OiBLQv5jA/Wk++A/GhpWPqgRFYiKSF6YYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4TWk4JFraOSOXvQnV+7LuZpW32o4SaR2/OvhRN/Mgw=;
 b=H5cAUcKP2plXsfNfKPfoZgp8MFTYYUZA4VUpG53QAWclmjuJRJJ7xdjEWpdJOzflJLoXml6FXzuQ2Vz8AqDfvSPTv8mbIKNhS98V7Q72gKIRVXCK8Vce9gNigXKTP7tKhJV7Bb0iAeLXduqJwcLrOYEfq6ivS0mT+dQF1TS/J+3uJ5ICiYzOZ8AZJslq1rI2iMNQaOyEjJ/q7Uzgr1Z/Tmho77MReipNgK9QWjDGRS70gPrPDWrSjKQTnZmCRLp6kw/DjL4xWwOkKDWFXv8QosWNZZSsN9WAsIuYz18Ld+VGEiBwl2V8v4BqDWRu1TE2HN2PBzo+se5wqqNaoiOV1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=calian.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4TWk4JFraOSOXvQnV+7LuZpW32o4SaR2/OvhRN/Mgw=;
 b=mjA0dCmhz3FDGBc+lwdPcgU1S0wHcvo3IQ02N4NtQKSboSEpAE90NS90CRmk0dBQaurL+ybjsD1DAzNjugB45rjdlZYWdR8S6M+fymTKEyBqSoDDydhOzdMq1sBAXNCw51/POuJaPnYRNF7GHtLyShcywru7ea2SU1SQo7irsv8=
Received: from BN6PR1401CA0020.namprd14.prod.outlook.com
 (2603:10b6:405:4b::30) by BL3PR02MB8300.namprd02.prod.outlook.com
 (2603:10b6:208:347::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 07:30:39 +0000
Received: from BN1NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::70) by BN6PR1401CA0020.outlook.office365.com
 (2603:10b6:405:4b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Wed, 26 Jan 2022 07:30:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT011.mail.protection.outlook.com (10.13.2.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 07:30:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 25 Jan 2022 23:30:35 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 25 Jan 2022 23:30:35 -0800
Envelope-to: robert.hancock@calian.com,
 netdev@vger.kernel.org,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com,
 devicetree@vger.kernel.org
Received: from [10.254.241.49] (port=55998)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1nCclH-000Ain-Bs; Tue, 25 Jan 2022 23:30:35 -0800
Message-ID: <ad19fcf6-7976-4fd4-bded-97e1021c99cf@xilinx.com>
Date:   Wed, 26 Jan 2022 08:30:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 2/3] net: macb: Added ZynqMP-specific
 initialization
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <devicetree@vger.kernel.org>
References: <20220125170533.256468-1-robert.hancock@calian.com>
 <20220125170533.256468-3-robert.hancock@calian.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <20220125170533.256468-3-robert.hancock@calian.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9778b9d7-a497-401f-5377-08d9e09dbfed
X-MS-TrafficTypeDiagnostic: BL3PR02MB8300:EE_
X-Microsoft-Antispam-PRVS: <BL3PR02MB8300B77ED8873F494319A1FCC6209@BL3PR02MB8300.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4UkvDVEIsG/bJmTR4NNqHYosPE2ki2OiEWoOSwGScVbhgSRIkmKTBoTkwY1sFGFcOC9QBKjUkFOvrbhCSy0f6C6q5lgBgqZlsYYIOv7iJ6AIhAZyeoMG6M90PM5hE7CVak4WtQLBKDRnCQzcBiXi5oENa/tw5X8yREwecI0OOotVP/97EE7k4MCUOFdn3qF2I0wz1WkmfjjEA3pm3tdOPwTHQyP0m7/ilRE9ZelR9k2i/u7tczw70cAUg48fNfmtaXPzs4y7CvzaPTfUQZuE5XwE5lrwTsSiZNp+WT4WfpQHx/Oe1mQoA0VPJnrPxxz5rswhjrgtLDgWilSmMf7T9pgPW2OkRMYLutXjNj0hVGMvBlkvKa8+CHPYwkiL8dzwQn+8ozTtBKWFDgQwdhHMdpjDw59n1zFlF1fGGcl8eyfvEEYrt1CAhKEYRMTa5FG+rO7JcFjU8C5aF/+mjkaXfHabObylTcEy/ViznZt6r4+DitjAmXATHVv78V/9hhtileQY0X2uOFYa7c8yLLjnEsN7y4ncOWJQD64OpvvWL5FXQVRiBDXeQXoydMfJBV4xpAgGXymL4BfkoYXRoWf+10JX93hvuzLgVMUCK+NzGBHZjKcfFxe57+3BL+L6je86LYpyvvMOGlvPqLfyDdVay+KCp3//slPN1l/bisey3P++nzzvnA0h5Cg3or2XbHn4Zkd7x4Ti8w/oy/aPc0Sozfo5wPEUX2E5yn9SU5nx+s=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(83380400001)(508600001)(54906003)(26005)(110136005)(2616005)(36756003)(47076005)(36860700001)(186003)(316002)(336012)(426003)(31686004)(40460700003)(70586007)(44832011)(5660300002)(4326008)(8676002)(82310400004)(53546011)(6666004)(9786002)(7636003)(356005)(8936002)(31696002)(2906002)(70206006)(50156003)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 07:30:38.2718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9778b9d7-a497-401f-5377-08d9e09dbfed
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT011.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8300
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/22 18:05, Robert Hancock wrote:
> The GEM controllers on ZynqMP were missing some initialization steps which
> are required in some cases when using SGMII mode, which uses the PS-GTR
> transceivers managed by the phy-zynqmp driver.
> 
> The GEM core appears to need a hardware-level reset in order to work
> properly in SGMII mode in cases where the GT reference clock was not
> present at initial power-on. This can be done using a reset mapped to
> the zynqmp-reset driver in the device tree.
> 
> Also, when in SGMII mode, the GEM driver needs to ensure the PHY is
> initialized and powered on when it is initializing.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 48 +++++++++++++++++++++++-
>   1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a363da928e8b..80882908a68f 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -34,7 +34,9 @@
>   #include <linux/udp.h>
>   #include <linux/tcp.h>
>   #include <linux/iopoll.h>
> +#include <linux/phy/phy.h>
>   #include <linux/pm_runtime.h>
> +#include <linux/reset.h>
>   #include "macb.h"
>   
>   /* This structure is only used for MACB on SiFive FU540 devices */
> @@ -4455,6 +4457,50 @@ static int fu540_c000_init(struct platform_device *pdev)
>   	return macb_init(pdev);
>   }
>   
> +static int zynqmp_init(struct platform_device *pdev)
> +{
> +	struct net_device *dev = platform_get_drvdata(pdev);
> +	struct macb *bp = netdev_priv(dev);
> +	int ret;
> +
> +	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> +		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
> +		struct phy *sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
> +
> +		if (IS_ERR(sgmii_phy)) {
> +			ret = PTR_ERR(sgmii_phy);
> +			dev_err_probe(&pdev->dev, ret,
> +				      "failed to get PS-GTR PHY\n");
> +			return ret;
> +		}
> +
> +		ret = phy_init(sgmii_phy);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
> +				ret);
> +			return ret;
> +		}

I think reset below should be here to follow correct startup sequence.

Thanks,
Michal


> +
> +		ret = phy_power_on(sgmii_phy);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to power on PS-GTR PHY: %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}
> +
> +	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
> +	 * if mapped in device tree.
> +	 */
> +	ret = device_reset_optional(&pdev->dev);
> +	if (ret) {
> +		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
> +		return ret;
> +	}
> +
> +	return macb_init(pdev);
> +}
> +
>   static const struct macb_usrio_config sama7g5_usrio = {
>   	.mii = 0,
>   	.rmii = 1,
> @@ -4550,7 +4596,7 @@ static const struct macb_config zynqmp_config = {
>   			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
>   	.dma_burst_length = 16,
>   	.clk_init = macb_clk_init,
> -	.init = macb_init,
> +	.init = zynqmp_init,
>   	.jumbo_max_len = 10240,
>   	.usrio = &macb_default_usrio,
>   };
