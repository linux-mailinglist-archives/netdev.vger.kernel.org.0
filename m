Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE565086C9
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 13:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377960AbiDTLUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 07:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376877AbiDTLUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 07:20:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D28E30F75;
        Wed, 20 Apr 2022 04:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTJSj9x6zvCyvy+1YhVuuVplERK4f4VHsonwePo5aTp2a7kftp3/J+A2HVQML1/0h9YIfu9bl25/0jcme7SqTdddGErTMb5OLCqeVjzbRPb3BE1OX3/qlL7HUT+fVy79ilyXAIBWhqY3Uy0H8Ge0JopSCpDYAzcQWECoXBmGHHE+BAEpbRhhs3zgQtc8S2ihRyWsStgVO8LyX10Ww7/LprzKVi5HzhKkDr6SG1SkyI8oxP5xG1zqmXvcVXbHeq0bbe2Fj7q+F7WypX4mf4Uc0dYUVEPegGM0BpnbJyICdw0/sviqg3apqMvBphA2dJ4bq/0FojZmbnLhqstQ1bIP8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtkqNVxnHtOO4IBmOowEnDnsq9i4POkmbX1fJsXPCLU=;
 b=C7XSfFZRPyOXKFpO1vBucVEamczLWQSOi5pOBtEN9dvWGpfhCm8JeJwOX9FoRiDi80Rnc5sEvtfpSCA9PhmP8HPEyPBK5H/NDEwsaBQ5cdbrfHJKCpb0pBJ0edl6TDrvJpD5wd2qCDNt0X+KpifnbOBSX2eDvz23hWzYh3CyV9UBMCIMc2MMD/3/0sLzzug/RkaRaFOjQBBw2iCdu+iwkG0vDMyKtcBviha/QPDKpHL3hLsaIxuEF04+pu4CE829Hq/Psse69goyKcZHbYSw9hU3n5nP9suO0pWsqBhXc662yQt7lXEk/COSMkDjguAIHDM74AdwHiTy2jTsLHPmbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtkqNVxnHtOO4IBmOowEnDnsq9i4POkmbX1fJsXPCLU=;
 b=rUJqNMkjKn6NaEe9/AYFR/FS5F3F/2pVLlzrBkfudLYGQs0AtHfH0u8uz/SjFdTywKbix1ScDn4/B8vse8hWw+DZp4pEYCaDZtfGz9Qr53eblttxG38z5BjFZfLpxhAFGGI3PET782wnXqBS4L4fcJYlIpK07DN4zb0J3NT+jQs=
Received: from DM6PR02CA0166.namprd02.prod.outlook.com (2603:10b6:5:332::33)
 by DM6PR02MB6249.namprd02.prod.outlook.com (2603:10b6:5:1d0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 11:17:20 +0000
Received: from DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::54) by DM6PR02CA0166.outlook.office365.com
 (2603:10b6:5:332::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Wed, 20 Apr 2022 11:17:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT013.mail.protection.outlook.com (10.13.5.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5186.14 via Frontend Transport; Wed, 20 Apr 2022 11:17:19 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Apr 2022 04:17:18 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Apr 2022 04:17:17 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzk+dt@kernel.org,
 nicolas.ferre@microchip.com,
 claudiu.beznea@microchip.com,
 netdev@vger.kernel.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org
Received: from [10.254.241.50] (port=50612)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1nh8Kj-0002wf-KO; Wed, 20 Apr 2022 04:17:17 -0700
Message-ID: <df99f712-f02b-c331-601b-5e61e4766ccc@xilinx.com>
Date:   Wed, 20 Apr 2022 13:17:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/2] net: macb: In ZynqMP initialization make SGMII phy
 configuration optional
Content-Language: en-US
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzk+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinik@xilinx.com>,
        <git@xilinx.com>
References: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1650452590-32948-3-git-send-email-radhey.shyam.pandey@xilinx.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <1650452590-32948-3-git-send-email-radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 241a0fb6-36c6-48d1-4cb5-08da22bf55b6
X-MS-TrafficTypeDiagnostic: DM6PR02MB6249:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB624910E3AC63144EE0C6E014C6F59@DM6PR02MB6249.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyCl7YBc5p8GwDWhU16Wr4tXlTwqWp9kOGomz5Y03nxUW5r+Br8bB2eyDjy9x8Btw8XjglZPzEUGbC/xufYIrnT9b8C6rSez0X7Vc77F4m968M862eF4syop2Bm3GdbBwHmxJxdqCKRM19iudGR+BT3jRoB0TSMvHzl6zujc1aVHQWrfzxQw+JemPeHh6QXk7YxWh8A1nKHSSgjkFNsw4Q77aN2XG0u4UeSuMvRdcfPlQJ/Q+vNMyVeQK+9WIgV14HTBIUUoZIYcyoLIonUGRILIJtVeThpRImJILZJ/Lr2ALozOLzCdQ3N1jhyVFdex6+OYJ353XKdpP1wL2dXHkPY90sRDXDoGdUqqGc3SN2PCj8KvYkSE6zz+XnLzcskNOYGysOZdJkfmW3R6mnjhLbyufew2WedFAwd6ZGvlXXj8rb6da92tnxIhepVUPASibbBqUuGamkl2w4uTbX4zAfWu33Uqh9kQQ6M5hD1BKmF+oK9nFiLm616MeYfPW+ERid4rYUdYMDhAUZCX9sbh+sYxDYbNhSRLTt6D9sZI0TJEXIlNsAU7Jp30ud8Q5sZ9kkxK19eDgZFsj7Wbcx6e0+72t9aiiO/qZNsSNj9RPJhaPA3v5uro/A8B4NPkzDWeMAZZjCexdkTY51RZk02W3gKQioarPYoXpDA6o8Usy0Lb0HXNlMQ5zbkMgkzCohmvdZwhDEZhr4Peo7RB9Inzu0zLe+LxQ5casfATzNf14B4=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(44832011)(7636003)(2616005)(54906003)(83380400001)(110136005)(31686004)(6666004)(316002)(36860700001)(82310400005)(40460700003)(356005)(107886003)(31696002)(36756003)(26005)(186003)(70586007)(508600001)(70206006)(53546011)(4326008)(8676002)(336012)(8936002)(426003)(47076005)(2906002)(5660300002)(9786002)(7416002)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 11:17:19.7517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 241a0fb6-36c6-48d1-4cb5-08da22bf55b6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT013.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6249
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/22 13:03, Radhey Shyam Pandey wrote:
> In the macb binding documentation "phys" is an optional property. Make
> implementation in line with it. This change allows the traditional flow
> in which first stage bootloader does PS-GT configuration to work along
> with newer use cases in which PS-GT configuration is managed by the
> phy-zynqmp driver.
> 
> It fixes below macb probe failure when macb DT node doesn't have SGMII
> phys handle.
> "macb ff0b0000.ethernet: error -ENODEV: failed to get PS-GTR PHY"
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a5140d4d3baf..6434e74c04f1 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4588,7 +4588,7 @@ static int zynqmp_init(struct platform_device *pdev)
>   
>   	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
>   		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
> -		bp->sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
> +		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
>   
>   		if (IS_ERR(bp->sgmii_phy)) {
>   			ret = PTR_ERR(bp->sgmii_phy);

Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
