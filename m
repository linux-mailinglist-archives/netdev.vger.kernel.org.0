Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5572A250E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgKBHS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:18:29 -0500
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:29920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727306AbgKBHS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 02:18:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/kvmgjNKF+qyJuFsxuF+Ymq17P+io3JqjdwprR1JiOp9QAdwwcNsFjwsow/d/NClQb9JIFwOTcoJLQHoNYpoJxbye0/vuu4PX34ltAt2iWx16vZqV37Hc9RSzjragMwtilpjBJteX3oZGqBzETDCeD3QjjzRXqHZomWHI+PiOsultPdAq2R/K5z/axZmz77erMR1ipCUzehlWux92rTepR9i1Q9T2Y5YeREy4b/qHF5PM0TwEKMhH9bl5pa2ljpPP5q86dfZS86RwyJLnh70q7LCeL+mv/NLVbs7GuyoFH2X1w7SKNs1I+FSzxpwzUQqqzcJIj+hgSmxG4rY5YDFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTcGGpxqcFWTBg906SBc+elNsOr10ycpP5SjFMJlypg=;
 b=VzUP8pFFaYh883bRn61mzIw9md0iD8isV2v80jQ/yom9u8PE6QqP62sAyJbs/mScHSFFu2gw/dMGJbF/cVgVxFMW0rPcGKn6Gek8ac6S9vpy/1E+px3SyaVS/fVGTVbCEHbW3HMbKb087pj3aMCxW9RX59mKWhVlHGXKCaqHu6Gri5ih8pu7A03EM4PZDCN4DLj4OgN9A23CJ9kl0MSwC6nRQ9cNmPhL1lFERv/s5td99oSXzkQ7YwFHkGUy5ii0swbKT13eo9+qVTw9+vAq5dMQft1avYaDxDH5AmoCuBCK6BqE6UQoVBKHKMSzjcYWo6wDfAfysB+GRI9tgCGWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sTcGGpxqcFWTBg906SBc+elNsOr10ycpP5SjFMJlypg=;
 b=JoRYUqzwx3l5qg1eBnTUD60mE69Tz8oJdsUIoe/aFKhypJ1HUDeX01ppRPMU8UESW+PruEi6VWKwpJhJLNOUw+LtKoVUjTBNLt1lVcV4CfkIuGsqHAMZPDkrobAwS0s5nDntFqJKFtHzxvRAjrzTDRpWk66W2bLm4kq5pFPE/pI=
Received: from BL1PR13CA0161.namprd13.prod.outlook.com (2603:10b6:208:2bd::16)
 by BN6PR02MB2772.namprd02.prod.outlook.com (2603:10b6:404:fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 07:18:24 +0000
Received: from BL2NAM02FT034.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:2bd:cafe::e5) by BL1PR13CA0161.outlook.office365.com
 (2603:10b6:208:2bd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend
 Transport; Mon, 2 Nov 2020 07:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT034.mail.protection.outlook.com (10.152.77.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Mon, 2 Nov 2020 07:18:24 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Sun, 1 Nov 2020 23:18:21 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Sun, 1 Nov 2020 23:18:21 -0800
Envelope-to: radhey.shyam.pandey@xilinx.com,
 michal.simek@xilinx.com,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 andrew@lunn.ch
Received: from [172.30.17.110] (port=45022)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1kZU6f-00042x-4C; Sun, 01 Nov 2020 23:18:21 -0800
Subject: Re: [PATCH net-next 1/3] drivers: net: xilinx_emaclite: Add missing
 parameter kerneldoc
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-2-andrew@lunn.ch>
From:   Michal Simek <michal.simek@xilinx.com>
Autocrypt: addr=michals@xilinx.com; keydata=
 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
 0Z1MQlmNcq2bhOMzTxuXX2NDzUZs4aqEyZQ=
Message-ID: <11c4349d-1323-5e56-a910-ede56fdd9286@xilinx.com>
Date:   Mon, 2 Nov 2020 08:18:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201031174721.1080756-2-andrew@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcebf996-e9e3-4f88-f62e-08d87eff7c96
X-MS-TrafficTypeDiagnostic: BN6PR02MB2772:
X-Microsoft-Antispam-PRVS: <BN6PR02MB27722BDFB9193DF7595EFCB8C6100@BN6PR02MB2772.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3jZxAfATaL3BinyV5ZlQ04L4nG9rautpFmzs2vsNjgI8ZkDGpSYlzgMn7JLVjA3H+yq1+cqBDeUhqUEtSp3oXSi/JolLbwQUOuF6z2EzrlraqPEMhqsM5g25ucebPw3+1JGuQ1HZT+5W84mpAhIPvKQWnCEg1sc+XK6+YE6jel5W12DYfsUwMX3cdIwuhJgaIHCgw0yV9nBuhvRFIQNEq+2EHa7p32lzm+WMwYLDg4BrCTe2staE++UstIPgxUfHqo4KjVcXun2XAjncavjF4NuW6/ZFvZBTC9WcVMpv8LGcbmWy4zhD5rCJW0i2P6UJpNWpmz8n9Xa0n13mmsaWq7htgV+c3UKzWh+jM+QWBtGu3L4o6tAUbw+cy80S8VPoeMdOS02bOIFxfE0NafoojubNn2aDEGpSN/rTWu4v1eKD96dDActXD4NX70bHEShCMteamFqTH12ZC5TvIaVKw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39850400004)(46966005)(47076004)(82740400003)(426003)(44832011)(7636003)(4326008)(478600001)(186003)(336012)(107886003)(2906002)(31686004)(26005)(2616005)(36756003)(4744005)(8676002)(316002)(54906003)(110136005)(5660300002)(8936002)(82310400003)(31696002)(70586007)(70206006)(6666004)(356005)(36906005)(9786002)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 07:18:24.3524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcebf996-e9e3-4f88-f62e-08d87eff7c96
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT034.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31. 10. 20 18:47, Andrew Lunn wrote:
> The txqueue parameter to the watchdog callback is unused in this
> driver. But it still needs to be documented.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 0c26f5bcc523..2c98e4cc07a5 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -518,6 +518,7 @@ static int xemaclite_set_mac_address(struct net_device *dev, void *address)
>  /**
>   * xemaclite_tx_timeout - Callback for Tx Timeout
>   * @dev:	Pointer to the network device
> + * @txqueue:	Unused
>   *
>   * This function is called when Tx time out occurs for Emaclite device.
>   */
> 


Fixes: 0290bd291cc0 ("netdev: pass the stuck queue to the timeout handler")
Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
