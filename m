Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8822A251B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgKBHU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:20:56 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:32608
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727902AbgKBHUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 02:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRTrLlusiQrX/O8zKNWDez3gDheD1P7QbjP3mYqlyrNmkctMNmRq8TRDsrckGxaEapH2qfZHDn3rAggduL1rj9bv/LnQy0SfHAig6FR5hvP2XdWqL5IMd+jkSOvsFDFcGRckXC6YqWTQmmgrQXLE/vdHMkGbklzgQ9Q44f8fI6dQxQVzbY4rk54VGfBSdm07uAxaO9TMKoj8CYO88JNnuB5igwE5R20FIPDckJh2E4Zv18s1L56eLVjoZeSX12O2VBTrbaQLdzCy8vhiSWcHom1uuPyiHNDQ9Ohqac2LwMWRDfqwhm6fRUCqiU7+n9Dyla8ANhQ69UZTAhbIIx6BxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Fh2kFvfmq+g8abbmBcgf4DXFgnuFIMHvArMRjwWtgo=;
 b=SALamsVOwKj+Rap7RPJfUC4eCqKuptZfyk9rpRG1o2vfezazemgGJXQ+1djaec98L2cyhU4PmIn9oq+Tpa5Ij7J2YmwmcWELm6NwL6VG1nwVmN02r/Lr9hrTHH8Hy+H2xd8L6ZbZ7iIg9vmShWSsD+SZcl5J1W/soFZi7kX8DlPTms0TbWeWfxiWXDP/QgOgP5ymkyZC1klU29L4kQGQ9vjK31/ydG1yjglAKqtVC5qXruzhEyHIr4GzDQiO3ksV9qgsYXnXFK7LBi8+lhdy0V0qePegomtaRUuitOR7mNrtuaUyL5ZIF3g2krXu1iI9O6+Jp446H2f3UmR1TDsZQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Fh2kFvfmq+g8abbmBcgf4DXFgnuFIMHvArMRjwWtgo=;
 b=fDfuctAMs7Cv95S4FhvqoMv8PY3Sd/JH5aLo5nDMWWxThBW6XGZ7c76EeESbTdHNbza7sCP9QCdRlJ+2QlbVD16S2GPn1OOsKg4iFcTH/UOfN66/07FxIYMeYidMwbovt8Mrd0ACLf1QL9HnFKPrT+j8f5kww+rxsfpAH6rdtoY=
Received: from BL1PR13CA0041.namprd13.prod.outlook.com (2603:10b6:208:257::16)
 by SN6PR02MB4303.namprd02.prod.outlook.com (2603:10b6:805:ac::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 2 Nov
 2020 07:20:51 +0000
Received: from BL2NAM02FT042.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:257:cafe::a8) by BL1PR13CA0041.outlook.office365.com
 (2603:10b6:208:257::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend
 Transport; Mon, 2 Nov 2020 07:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT042.mail.protection.outlook.com (10.152.76.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Mon, 2 Nov 2020 07:20:51 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Sun, 1 Nov 2020 23:20:49 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Sun, 1 Nov 2020 23:20:49 -0800
Envelope-to: radhey.shyam.pandey@xilinx.com,
 michal.simek@xilinx.com,
 netdev@vger.kernel.org,
 kuba@kernel.org,
 andrew@lunn.ch
Received: from [172.30.17.110] (port=45238)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1kZU93-0004YN-Et; Sun, 01 Nov 2020 23:20:49 -0800
Subject: Re: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-3-andrew@lunn.ch>
From:   Michal Simek <michal.simek@xilinx.com>
Autocrypt: addr=michals@xilinx.com; keydata=
 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
 0Z1MQlmNcq2bhOMzTxuXX2NDzUZs4aqEyZQ=
Message-ID: <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
Date:   Mon, 2 Nov 2020 08:20:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201031174721.1080756-3-andrew@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea30332f-9aa1-489d-b17b-08d87effd419
X-MS-TrafficTypeDiagnostic: SN6PR02MB4303:
X-Microsoft-Antispam-PRVS: <SN6PR02MB4303FBEEA7948A455374748BC6100@SN6PR02MB4303.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hG0YkGCE3Avb0id6bQAHPVa5+dGy//nCHcezINHyh61lfc2h7oCbOPUMkbXyqQXZtyUVP13aDP9/TogQ0kWl0IUHcQOGOsWP8jrY1Uu2TMdzZHrvKj6R+MR+HhVf28ElThBemvCWA3ixhetf+/7r3sRwvZEDznOjhbN56PMVb1Ht+YUV76pdR33Wm79MyBPl3cE76TS2/P/rZU5jkyj5tDYQiMDdWeNruZvD6+DRYoNW32YcVKTJmGJoMYBCkuDxp0qFGfgHQtTVu8+PHmeJfoP6AidAaZfAVwVl2Ea06j98KM/cl2rK1E0nAqYMg35sx40ShoWNiNOHSebKtjr46sa/weD8I18bSKZAl8lcilJ/tz6gwWyOizLyTHNzK11E15rNnPuyDazPKtb4rpaeDdMK8V3hmU0qEtEtoCMN33s1UmfZ1gFEtmxOzz/bEPNHo65pG+NNUjItuXa/+lgjGg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(346002)(376002)(46966005)(8936002)(9786002)(2906002)(82310400003)(2616005)(356005)(31696002)(26005)(478600001)(8676002)(336012)(186003)(44832011)(426003)(31686004)(107886003)(4326008)(36756003)(47076004)(83380400001)(7636003)(70586007)(70206006)(82740400003)(316002)(54906003)(110136005)(36906005)(5660300002)(50156003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 07:20:51.1729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea30332f-9aa1-489d-b17b-08d87effd419
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT042.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31. 10. 20 18:47, Andrew Lunn wrote:
> drivers/net/ethernet//xilinx/xilinx_emaclite.c:341:35: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   341 |   addr = (void __iomem __force *)((u32 __force)addr ^
> 
> Use long instead of u32 to avoid problems on 64 bit systems.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 2c98e4cc07a5..f56c1fd01061 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -97,7 +97,7 @@
>  #define ALIGNMENT		4
>  
>  /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignment. */
> -#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
> +#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((long)adr)) % ALIGNMENT)

I can't see any reason to change unsigned type to signed one.

>  
>  #ifdef __BIG_ENDIAN
>  #define xemaclite_readl		ioread32be
> @@ -338,7 +338,7 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
>  		 * if it is configured in HW
>  		 */
>  
> -		addr = (void __iomem __force *)((u32 __force)addr ^
> +		addr = (void __iomem __force *)((long __force)addr ^

ditto.

>  						 XEL_BUFFER_OFFSET);
>  		reg_data = xemaclite_readl(addr + XEL_TSR_OFFSET);
>  
> @@ -399,7 +399,7 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
>  		 * will correct on subsequent calls
>  		 */
>  		if (drvdata->rx_ping_pong != 0)
> -			addr = (void __iomem __force *)((u32 __force)addr ^
> +			addr = (void __iomem __force *)((long __force)addr ^

ditto.

>  							 XEL_BUFFER_OFFSET);
>  		else
>  			return 0;	/* No data was available */
> @@ -1192,9 +1192,9 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
>  	}
>  
>  	dev_info(dev,
> -		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
> +		 "Xilinx EmacLite at 0x%08X mapped to 0x%08lX, irq=%d\n",
>  		 (unsigned int __force)ndev->mem_start,
> -		 (unsigned int __force)lp->base_addr, ndev->irq);
> +		 (unsigned long __force)lp->base_addr, ndev->irq);

This is different case but I don't think address can be signed type here
too.

>  	return 0;
>  
>  error:
> 

Thanks,
Michal
