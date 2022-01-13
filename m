Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A35F48D2CF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiAMH16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:27:58 -0500
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:60800
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230176AbiAMH15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 02:27:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwoX+QcfwsFVXHUJC051PUfqW72p3aUBRDMUS5LeH6ZimMiRH4caIoLUO9xc4wU2AVtq6slUFwJ9N/U2rFbg8LixUxobA9plv1JzU9uQyPz6P5JTI17Zv4tzwqtwkPHXnJWIySbrhkE4EHQelUlY70uOabDDTfDhqA97eLAvGqjp7t8N4UHaCVfxH02AL9oAPbKVaX5HJhocw0fLUDdQNF+gZrHAQY/EF623YJgCp+Wmf+isAAwPVAtLGx2OtsZlgilRQVrH+aGcIiRbRIvV5HWUCKdAwi926mESLckstMGK0Y//spNs8rmzIrcP9QjtC+CmNC1lPD0ibKsrXoPSsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vY5/iFX5JhKWu7N00fbBDLU4awD3rriGeFHR98EcHFw=;
 b=botFmUpxqm/loLjYxzc0zQEOuCD3mBqVsrS8OxVMVbXbtFWUg1nVlWoAx/98Rhsb5RAT9Hvo1XpEx//RX2gnAf/WNCvB6XUfUb2c88nHHfDj3vY21nT/W5mxdbG3dWlmCslCt7/y50tX1Xv5SD4XVCVJDw1VrPMbJ7/0YXRibrFuVfwi0TO1VFKVrdmHru6ZbveYh7aBCE9aRYj7vl9JP2nOX0GWYcMmFTUHUfqtEETbRHyfQ/+a5yxBm03gZ2Lu0ggJonNVKVUF8w8tflmVWfjj5a/y2xJOt8SmAldCZ/3/1p3VScUCWCRqezfRDyoqDnTZK/ya+c/ANF4OaN481g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=calian.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY5/iFX5JhKWu7N00fbBDLU4awD3rriGeFHR98EcHFw=;
 b=pA25lwvFTpasMvp1nu+quYJ4Ra9WxhX2vdROD8gwyiLNWJW6vs+06KxWKjyFEMgN1A9UavZCJOlX2swWj4JoMiQTGyKZapVolZeTWGE0lpCxQkyVss6uH+/2MHSBLPRo38yt3dqbOI9TGvxnCuij/XtoRN+5i99lL4UdAQxMtgA=
Received: from SA9PR13CA0133.namprd13.prod.outlook.com (2603:10b6:806:27::18)
 by SN6PR02MB5549.namprd02.prod.outlook.com (2603:10b6:805:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 07:27:54 +0000
Received: from SN1NAM02FT0036.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:27:cafe::ed) by SA9PR13CA0133.outlook.office365.com
 (2603:10b6:806:27::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.7 via Frontend
 Transport; Thu, 13 Jan 2022 07:27:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0036.mail.protection.outlook.com (10.97.4.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4888.9 via Frontend Transport; Thu, 13 Jan 2022 07:27:54 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 12 Jan 2022 23:27:53 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 12 Jan 2022 23:27:53 -0800
Envelope-to: robert.hancock@calian.com,
 netdev@vger.kernel.org,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com,
 devicetree@vger.kernel.org
Received: from [10.254.241.49] (port=58198)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1n7uWX-000Fbc-4F; Wed, 12 Jan 2022 23:27:53 -0800
Message-ID: <3caae1db-b577-1e1f-3377-11272945054c@xilinx.com>
Date:   Thu, 13 Jan 2022 08:27:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific
 initialization
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        <netdev@vger.kernel.org>, Harini Katakam <harinik@xilinx.com>,
        Piyush Mehta <piyush.mehta@xilinx.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <devicetree@vger.kernel.org>
References: <20220112181113.875567-1-robert.hancock@calian.com>
 <20220112181113.875567-3-robert.hancock@calian.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <20220112181113.875567-3-robert.hancock@calian.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27d6ed80-f3e3-4c9f-b96a-08d9d66636a9
X-MS-TrafficTypeDiagnostic: SN6PR02MB5549:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB554917DD1520CEF07F8A1EB3C6539@SN6PR02MB5549.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gCheczRhxDY6elBCBn1DQ31MBkKtjjh0b4Kvyuylb7O5iNYAnQv/mTKMSoho8TlsD2C+YyWJcaEwLfx0L/oB7hsxgdRTqLBlDm1Jc1Rqhx6TjUM0xiwW1KZI6rSH+aCGRybKRXPLc071lss5hSTaQ4a2CWmtprChWDs6604R8s/Coxx8W7hLhhu6AFVx6cl3TODASMFcEcKbRlgmUhcMbv0giLLNOtNrhiRWUE1sqP++GuEIs31dYaLJpgC4CLeW4zFIxJybSXWodaxkG1MNcp9mrdVuih6WWmg0dmpDhbon6U8Xu0x8EYsqw/QTLjaS9YL2VPxQD2TxQ1gUUc98BoreSuhlCC8mM1ht3vAaMkVvPAb5cOAAm3tYJzukigDmZEWq3xzlEGrtzNXXU2JTPzv1EI/i4ZfxFaKDywiNYjAfA+dgyWCJFVADhtur+RAJxJ2Ml+1lecO0FMYHUThZaiQXIXBVEdgmfdiL0Uj2CH2TaoSPLlfM0cCTLoaxT+mIqm6tUGL9iLEBGA4+S9x0lsdP5PgrTi12XURjoIBusBWEbkSkoX431HuR/bSOr96NuSmERw2IDYL/VrsbdNCZEyaXg635htrmdqErPM79faM97CRqOP/COmm1S4BD2pTMySaVULyowHPjE+HO4LDOoLnsZIhlWujjrdYbqO/pJSyrrxacg/6yw81w8M48kOpnhEcKchwa55rSJAfTlk8H+7ErR44mANC0xMxSTJ5nqIdRyO35bCroQ108yJ1Y0l/BMvllJgCOcn3+1NskaPxY8w==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(31686004)(70586007)(110136005)(336012)(54906003)(82310400004)(2616005)(83380400001)(31696002)(426003)(508600001)(47076005)(5660300002)(36756003)(9786002)(2906002)(316002)(186003)(44832011)(70206006)(53546011)(6636002)(8676002)(8936002)(36860700001)(356005)(7636003)(26005)(4326008)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 07:27:54.0955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d6ed80-f3e3-4c9f-b96a-08d9d66636a9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0036.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/22 19:11, Robert Hancock wrote:
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
>   drivers/net/ethernet/cadence/macb_main.c | 47 +++++++++++++++++++++++-
>   1 file changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a363da928e8b..65b0360c487a 100644
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
> @@ -4455,6 +4457,49 @@ static int fu540_c000_init(struct platform_device *pdev)
>   	return macb_init(pdev);
>   }
>   
> +static int zynqmp_init(struct platform_device *pdev)
> +{
> +	struct net_device *dev = platform_get_drvdata(pdev);
> +	struct macb *bp = netdev_priv(dev);
> +	int ret;
> +
> +	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
> +	 * if mapped in device tree.
> +	 */
> +	ret = device_reset(&pdev->dev);
> +	if (ret) {
> +		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
> +		return ret;
> +	}
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

I was playing with it recently on u-boot side and device reset should happen 
between phy init and phy power on to finish calibration.
At least that's I was told and that's I use in u-boot driver.

Harini/Piyush: Please correct me if I am wrong.

Thanks,
Michal
