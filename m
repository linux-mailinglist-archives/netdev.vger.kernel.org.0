Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE8F48D2C7
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiAMHZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:25:31 -0500
Received: from mail-mw2nam10on2067.outbound.protection.outlook.com ([40.107.94.67]:25312
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230504AbiAMHZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 02:25:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwA9/S2DkrOVOZ7Ggk9qeR1cl7YpU2R8ejW0ZACReyhmP8OwFxb8CxkMxw0h9QsUrW5+2wqo++FAB7SewoJEjphG35XTa6sGGsHrJHZAdvPmpS6yt8CBwvvZEFcaK5gpdXfxfUP+xrtLhR1SqVMklpC4FvG66nrN/SDN3YYKPB4RPaWeng/K0mDV1Q3UvTeHncZ+dskGnBHLma3AP6dIs+X1iI28A8A4MTGqadaxEn+eC1oNW2EJgxNOkPZYn0wNXgdaPwnG39uQ4dmM+izqBYDzHt06LidFBjHBthf+Q5PQbUmqR9vk7lUig4SlPTzBm/OoeuopfBOSglAeuN2G2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6+1Gno9NcLfAcTFAO+vmiRowFMem+rJ4xUcEcA8iXE=;
 b=NgLOKXN4Ij6XF4vfhWFVEANCYkMmjlOjSW0eReuWUGZFSQxmWQ21JgV0mh8CEgp2i1wLeAHd1XFFmG/MxBOtJ+KskFdZ8MrcYn9VwkKTJDbOBhjJzdCP/KqcPpes/ae+PHJ3LAoHMkDUjre+ryS0p6PWtSV11RFw01baMFc8HK7hUNd5fLVRrDKRmAZx3uEjX92chE41SmkNoqp7wNX0wgrdLWwEuNKNEhV5XBlKSfDLtn8ZvC8M2Q8wrR2qHI6oPd4qYs+T10zGzKGgTMEE3ras1rS6Ng2jq3Hf4zQ4ZHIVh3L+iatnJsTV8uM35LYrkHk2RO27LIJqcFHr4ZN+rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=calian.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6+1Gno9NcLfAcTFAO+vmiRowFMem+rJ4xUcEcA8iXE=;
 b=kiesfvCElvYjuhSAjWB5PCqZX1CtFJMngUd0tu879TujVZbKH4D0HSf9xT08fbz/BC+rn74iZFxPWF2xfL3G5Gxo1gzXU2IRDPKr6nxUT+oXGix32MHtJAL77B1oTqJYRAVgjADiloFuuOSA5Wx4Bxe/W7wJt1kNQq9AIfLa4ds=
Received: from BN9PR03CA0581.namprd03.prod.outlook.com (2603:10b6:408:10d::16)
 by BYAPR02MB4839.namprd02.prod.outlook.com (2603:10b6:a03:51::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 07:25:27 +0000
Received: from BN1NAM02FT030.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::e1) by BN9PR03CA0581.outlook.office365.com
 (2603:10b6:408:10d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9 via Frontend
 Transport; Thu, 13 Jan 2022 07:25:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT030.mail.protection.outlook.com (10.13.2.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Thu, 13 Jan 2022 07:25:26 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 12 Jan 2022 23:25:25 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 12 Jan 2022 23:25:25 -0800
Envelope-to: robert.hancock@calian.com,
 netdev@vger.kernel.org,
 geert+renesas@glider.be,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com,
 devicetree@vger.kernel.org
Received: from [10.254.241.49] (port=57996)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1n7uU9-000Cps-AD; Wed, 12 Jan 2022 23:25:25 -0800
Message-ID: <d5952271-a90f-4794-0087-9781d2258e17@xilinx.com>
Date:   Thu, 13 Jan 2022 08:25:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <devicetree@vger.kernel.org>
References: <20220112181113.875567-1-robert.hancock@calian.com>
 <20220112181113.875567-2-robert.hancock@calian.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <20220112181113.875567-2-robert.hancock@calian.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e641342-7c8c-46cd-47cc-08d9d665df03
X-MS-TrafficTypeDiagnostic: BYAPR02MB4839:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB48396232C34D0D74E31B4904C6539@BYAPR02MB4839.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KezliR01mIEm16OZPumu/MqDEVy1WH8XA0zd8Mz7l3f9CIy6KmZkYbahNNtdeK2dIVIA+c0VyQI36ZIQ/kx9AcId+EQff31m+eMD3brQ9156V6CNebHFOPup53DcXfxi5gprpQ0p0P16A9EEdaQHmjTuAU1uhhDzG4ebDCMWI77rLqOgLtIKOofOMhxEj8e9nnwXvCSHKuNnwerRnH14fQO88J1mKOuEjOffzW4djZvhWfbK/tmdZN0OATdsCZV1vUqoz01SrxxQIhQk2JSnWIy/xm+esSjx3mpq8BjkJfEaQfG9dGeBoFDOBzfUM/rJwPx8en/AXzuglOJzIJEZdx80xrCUjF8rP4MkeUJbVluvnKXrx7qD6mHODZLg21a/1KWNAOp9OjgUnXsWcci/Xd/tECyDjxGoRotFcGu8Qx4tyUTKyyK5iewvrWbd9KaudQvVPEHcWF6khw8UolGonHxrMuo5G3DxmWnOH1gj7+GuKVC/KJmXGtDLsnTc5qwuSs/870ZJvMIbafANVJ3o1hbjwgdhRyTtX/NS+zrDFqraMea/CWSOZS5L7uxnyssiYkekZyYV0Maelc2cnzizz5A4822dsEWW4nKqix3OvgvIhQ5gNJsnstZGgvoRm8YIM4u52ytnnYFwOeDnoOFrqv60RUKHip1o3l9Y982XgJcbxo2tWFdNfPuEEyPYtO+mi43usxmlF8mZVMSltSM7UNi9cwiFLIdwd24/QYxacqujtNKqGAdhCI4EPIVz7EL6ngf//vj8ODSdptkCN1WU8L04WIGyYRYoL2NsBzKctVc=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7636003)(36860700001)(26005)(36756003)(2906002)(8676002)(31696002)(186003)(82310400004)(4326008)(356005)(31686004)(110136005)(44832011)(54906003)(47076005)(426003)(9786002)(336012)(6666004)(53546011)(70206006)(70586007)(8936002)(316002)(83380400001)(508600001)(2616005)(5660300002)(41533002)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 07:25:26.9648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e641342-7c8c-46cd-47cc-08d9d665df03
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT030.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/22 19:11, Robert Hancock wrote:
> Updated macb DT binding documentation to reflect the phy-names, phys,
> resets, reset-names properties which are now used with ZynqMP GEM
> devices, and added a ZynqMP-specific DT example.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>   .../devicetree/bindings/net/macb.txt          | 33 +++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index a1b06fd1962e..e526952145b8 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -29,6 +29,12 @@ Required properties:
>   	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
>   	Optional elements: 'tsu_clk'
>   - clocks: Phandles to input clocks.
> +- phy_names, phys: Required with ZynqMP SoC when in SGMII mode.
> +                   phy_names should be "sgmii-phy" and phys should
> +                   reference PS-GTR generic PHY device for this controller
> +                   instance. See ZynqMP example below.
> +- resets, reset-names: Recommended with ZynqMP, specify reset control for this
> +		       controller instance with zynqmp-reset driver.
>   
>   Optional properties:
>   - mdio: node containing PHY children. If this node is not present, then PHYs
> @@ -58,3 +64,30 @@ Examples:
>   			reset-gpios = <&pioE 6 1>;
>   		};
>   	};
> +
> +	gem1: ethernet@ff0c0000 {
> +		compatible = "cdns,zynqmp-gem", "cdns,gem";
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 59 4>, <0 59 4>;
> +		reg = <0x0 0xff0c0000 0x0 0x1000>;
> +		clocks = <&zynqmp_clk LPD_LSBUS>, <&zynqmp_clk GEM1_REF>,
> +			 <&zynqmp_clk GEM1_TX>, <&zynqmp_clk GEM1_RX>,
> +			 <&zynqmp_clk GEM_TSU>;
> +		clock-names = "pclk", "hclk", "tx_clk", "rx_clk", "tsu_clk";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		#stream-id-cells = <1>;
> +		iommus = <&smmu 0x875>;
> +		power-domains = <&zynqmp_firmware PD_ETH_1>;
> +		resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
> +		reset-names = "gem1_rst";
> +		status = "okay";
> +		phy-mode = "sgmii";
> +		phy-names = "sgmii-phy";
> +		phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
> +		fixed-link {
> +			speed = <1000>;
> +			full-duplex;
> +			pause;
> +		};
> +	};


Geert already converted this file to yaml that's why you should target this version.

Thanks,
Michal
