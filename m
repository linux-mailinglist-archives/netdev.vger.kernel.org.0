Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303564B81E5
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiBPHnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:43:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiBPHnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:43:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22122657D;
        Tue, 15 Feb 2022 23:42:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMPPg4wu7khqIyAsYF6DeMIOjU33W4mngFidUhddGh3y1vG6Kc6HNxSH17QbX2MvoZb4Bz0Rn8G/Rxr/aGO+QQ1FJB5fWtBItnNfYT2iS7sh7oqmJVPpN3zsysDQRx6J64eZvGP2djhqEVcTrlpJfOGk9uhGTlXxjAiT9yYpC7t+W3QOP8NZGO+OfdEP1Wd79EtzYmQoPky4o+g80x3PpSGVynOFV24mu4ujsWkSF9EzSPFfMRqW2N8oS2sFmQXoPYyJ+PHOsTA05ccE/rtvecNJ+dQ7zdehP+sOb6zBfYsWFCNYmlUgQCNzf3r/y5PSPHVTFBbjKSo7yCyX5nfN8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlRv9PIHCenu+hb/CrphlizXkAQyT97oMWW+pozXQ1Y=;
 b=CAxySMKPZF+qNjaeLuzc1ur2omokuNiiTrP3uN5nglUZo8Dc4feFchV7ox1nhwey7Aift4KGap7vyf6rSItmaRwNhVDjoXCDltL4UXzdkEK4TQeNDW0bFUs9THT55SlDdxwuXrraDItACbFZfijzV2w3OLm7jEOYaaQ20/a+BcK71hfMfMp90uL2uH4bYDS1KljJLsMkkz7/ePJeONuCb29MoX9LtEcX1oRn9Ads64dm7125KE5pxXj6pVEVu0rJ1+D02trNeAU9neP2cexBy3nbv1m2+K8AYhl3haAqUDChDQyTAXWnJUZAemQUY7LVN+dLdgjxu6AYU48EJkwc1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlRv9PIHCenu+hb/CrphlizXkAQyT97oMWW+pozXQ1Y=;
 b=rKz8Xyz7Q2KA1pDtFWNuIeesr7cojqQZwfJwRl7vCAGS3/8IhRxAC0maMwHdIRjWRqc/hh01cbnue7Zv3pruesEXUja1iIC8DIIcx9HUbfuYAtKFebcA7sJOA82mYcyXuLV/7VaE9SUPn9YYKq+piOpeODKqxe5KG+RvQcKmM1w=
Received: from SN7PR04CA0053.namprd04.prod.outlook.com (2603:10b6:806:120::28)
 by SA0PR02MB7193.namprd02.prod.outlook.com (2603:10b6:806:ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Wed, 16 Feb
 2022 07:41:48 +0000
Received: from SN1NAM02FT0038.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:120:cafe::d7) by SN7PR04CA0053.outlook.office365.com
 (2603:10b6:806:120::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Wed, 16 Feb 2022 07:41:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0038.mail.protection.outlook.com (10.97.5.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 07:41:47 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 15 Feb 2022 23:41:47 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 15 Feb 2022 23:41:47 -0800
Envelope-to: trix@redhat.com,
 davem@davemloft.net,
 kuba@kernel.org,
 gary@garyguo.net,
 rdunlap@infradead.org,
 esben@geanix.com,
 huangguangbin2@huawei.com,
 michael@walle.cc,
 moyufeng@huawei.com,
 arnd@arndb.de,
 chenhao288@hisilicon.com,
 andrew@lunn.ch,
 prabhakar.mahadev-lad.rj@bp.renesas.com,
 yuehaibing@huawei.com,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.254.241.49] (port=51946)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <michal.simek@xilinx.com>)
        id 1nKEwd-0000Gd-7t; Tue, 15 Feb 2022 23:41:47 -0800
Message-ID: <54168947-f587-2209-b6df-80aefb968123@xilinx.com>
Date:   Wed, 16 Feb 2022 08:41:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: ethernet: xilinx: cleanup comments
Content-Language: en-US
To:     <trix@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <gary@garyguo.net>, <rdunlap@infradead.org>, <esben@geanix.com>,
        <huangguangbin2@huawei.com>, <michael@walle.cc>,
        <moyufeng@huawei.com>, <arnd@arndb.de>, <chenhao288@hisilicon.com>,
        <andrew@lunn.ch>, <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20220215190447.3030710-1-trix@redhat.com>
From:   Michal Simek <michal.simek@xilinx.com>
In-Reply-To: <20220215190447.3030710-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59cc8481-8133-471c-a14c-08d9f11fc9bf
X-MS-TrafficTypeDiagnostic: SA0PR02MB7193:EE_
X-Microsoft-Antispam-PRVS: <SA0PR02MB7193A54AF9E74062C7786C21C6359@SA0PR02MB7193.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KLB0buYQ5T3AU/lpTbEM08DczB4HQn7Uergr/ZQkzM+RTQ8dT/iEaLtYjbSYCebtg4gm+cpWVNqvzKIDLPNtHXHFZtpURPfdcdvBjhjKNqkgC/1Te+LAVLqvIYH3ijZVExovCFxag1RTcun/q4WbQ81hQ9dNdhZN/5lkeAVqDWYRPGz4Fe412yw+d8BSsgldrVSWrZ3acf/+v8xh8xsIek8CGkwlaw8wJWAoZ7IMu3MBMcYWQ4oT/SqVrLP83/4C7//QUOnoGwfn3APzLVwdkC7B1EK1pFtcFltW+I1c2Y1d6tMtkiT2iMzwE59NZlnwisNHw5SpDovA1e3JTsjBFzO++EvH0u476SA5/Rk1iJbq8fUhvc5L43jPl92/fsSXjf4O7B3CFVKxgKiXyd08klvvhcVT0gSmzG0NEll/57DADyb61M/lwtruszAPEBAeVK0nvZaQ9uswE+YjutmMqKk5TbFgcMKzMvfIrOm7/pWq3aeFq9/bzmiYLAlK4lLKkGd02Zm3U3fWd25HGBDtq3+UaYuNXncOFqC9ym5olmY7vTU85WT1tebj2P+BDD9+Q3qXMkwpgaYhrdHu98NkB6cogi2odAauGghL0dWDF0tcAWHdV5ogMdH5ymR9Rlj+XR+e9D6A/H/JExGZsJEMN2L9TykNSxdygl+8zPZibnveMCuEiXA4eEzpz+r3QrOSAvvmM/+io9vKlOIcfWF95sPZPg8FBlOeptphiqlqs0AEGh/k+ge6cOiGDWfNwyKdP1r4mDRIxUICHBuWQON0JMnzjcnsRXhyPnikw2oFnyk=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(47076005)(36860700001)(6666004)(53546011)(2616005)(70206006)(82310400004)(26005)(54906003)(110136005)(70586007)(83380400001)(186003)(4326008)(316002)(8936002)(44832011)(7636003)(336012)(426003)(508600001)(7416002)(31686004)(2906002)(31696002)(36756003)(9786002)(921005)(356005)(5660300002)(40460700003)(50156003)(83996005)(43740500002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 07:41:47.9913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cc8481-8133-471c-a14c-08d9f11fc9bf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0038.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7193
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/22 20:04, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'the'.
> Replacements:
> endiannes to endianness
> areconnected to are connected
> Mamagement to Management
> undoccumented to undocumented
> Xilink to Xilinx
> strucutre to structure
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/xilinx/Kconfig               | 2 +-
>   drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
>   drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
>   drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>   drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
>   5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
> index 911b5ef9e680..0014729b8865 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   #
> -# Xilink device configuration
> +# Xilinx device configuration
>   #
>   
>   config NET_VENDOR_XILINX
> diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
> index 4a73127e10a6..ad8d29f84be6 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac.h
> +++ b/drivers/net/ethernet/xilinx/ll_temac.h
> @@ -271,7 +271,7 @@ This option defaults to enabled (set) */
>   
>   #define XTE_TIE_OFFSET			0x000003A4 /* Interrupt enable */
>   
> -/**  MII Mamagement Control register (MGTCR) */
> +/**  MII Management Control register (MGTCR) */


When you touch this you should remove /** which points to kernel-doc format.

When fixed you can add my
Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal
