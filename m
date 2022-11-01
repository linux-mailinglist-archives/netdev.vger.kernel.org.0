Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FDD614AE3
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiKAMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKAMkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:40:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96A1A397
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:40:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXxGxfrykCfTVnHSmzw70zAsP8sqhA/Dfx9YXpROfoufXcR0VeECc8bWWEq622sNA9lCitkjyi7yTW4MUbloRCgqis+Z4dNURvHylUpaB8ZS70TBragtdmBY/Y5Z0MmCsKwgdceszwX85mopRX/hflPr5Kf5d/1MojhJD6S5zZgriFuvrOaSuvLXT/NfUdY420axTS4AlVNz9IHJXzdN/4h1j9OTgqKqL2AEAYtBZDunS33FFQP2iLm1t17rldah/Skw593MSQx5OVSJx5vp69PGFvJpu5Vlh51ZkhWD+yJTsD0nKGi0XUNjIMf9DvtJLiB6l4U5ZV3sA3E8+FjzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nX+gFJV30YsQJY8TDJawaXYRyYuJ1g8vMIbHM8Tle9s=;
 b=cuy6K0XKlg7VIMzSF1yGm9VkU9XJAntjUApmoSpjjWtLkhjVZF7XKCCr9Ut58oZLx7E6qTy/P8Mq+CX6fZs0erbt0g6SH6j9NU6OXssSWIbyWG/iIpAKQtbaLksrgsg5YmgYkGwGcs9KBlTA4NxPVvM8dJBgLRdYMndrV1zksOwUSxxaTVeH3kJsea9Ud9G332RlZdEc7YRfoi7Tp/03MO96NyehxK9hJZJN3zhW47A2/iITDBVBhr8BCz8AOOay9H30DzQSHz5Y98M4LOFsLMi23cnUu7Lsim726DBQpfpeco7JfUkHgFY2MMCZAuUBo/2DrD0P5jsHkYlXpXZaYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nX+gFJV30YsQJY8TDJawaXYRyYuJ1g8vMIbHM8Tle9s=;
 b=FEeMjExtWsJKJpHzNi9d+n96y+vMMH69jKPg6creoad8h2cCOgtAYaKmJ3WwjGjbNCzTqqyhxRxZuELBLJewc9Oip9gTfj2hX25NTfIzCKejom1DxfmwHcksKHsr+LG8/iH/k7B1cJT+IgxQXmkoht5XzUPO3hnwGCkIuOoDhfLqWKH/EPmzNmYTBprlGqaRRY90NKw2JtnNjtvtu14+hKe3r1WRRPaMkAfl+c/RF2a13QMCxJA1bWE3wBDgUkdM55TOR6lL4Pu5UkOwglno5InHUc04YN69iRHTYpAAU8fLdpXeO3iWRmFKP6L/a6NbdUP/qHgy5cxgYTO+J5BUlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 12:40:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 12:40:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@resnulli.us, vladimir.oltean@nxp.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 2/2] rocker: Explicitly mark learned FDB entries as offloaded
Date:   Tue,  1 Nov 2022 14:39:36 +0200
Message-Id: <20221101123936.1900453-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221101123936.1900453-1-idosch@nvidia.com>
References: <20221101123936.1900453-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM6PR12MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: aa6d6434-1559-47d8-aad3-08dabc06341b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cx38H0I74557mFH47dSQ54KYmtGW85uDLI6cbvvtlkMYNhJJRy3u9FFTYgw0Bk0kwPJr7ve5N9JXj6j2K/wF2HSkE8wZtalPVaI40Vau9PPqHj0JbfeIMojFqX7ZXTCfpNVP+kgkhj6lUGilQ10k14b+BAKms3zxrm5w9v+laGqQk7AociATRMwJ9C1Kyug91j9DrpXDdf6iZOqSIUA9sID/T0toXp8MwJLCap2rz3KHusazjnNzkKZoYbM31XqOVsC+yx1vijYwADRinaDmz57+9XxfapXhawd1bldIZaG0ydyTZ2JsFZkTpyBhApVayhUWj2yEzGhH2FjlVLk7TF6DeCf/IAhb853Oj00nX9Z/Bepyiw/+CDNpooS5INjHQvDIDlbrYqn4YbyrUi8Rchv2Y+x3kCXRNqEN97vQ0GTCUoay8Q1/5C5ws2I2CezoIgZPx6LhKTFSujCFfkzcIb9iat1DtUDv5E1VCgqFWAJx9IH47bt7RnbjHA4KkC/FcepuwxmRFVNPhOwi9MpGf2i8wqMospRTOUyKUFx32PLAKVdKpDbqElF9RYl5Obndv3fEsj1kl3XEfBK9+AnWzAiaEZfzWfZQdmb9h4M/A3Qabv/U4Q86SmZUQcniAsGeA5WjJwe+GaTSRZ476xgMTySpZw619z/bKACLvgOaUR1KBT/EVddJiVhXLk/z5nyy/j3nTBDvRyZvUeRxpHfEjvvQb10dmR+mYI9uObx93IAaahaoMBdHK2yKANpqs/jN9jAYDULyYeA6w+jfg56P1IVv3bwUdbSTCnk6HyTnAno=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(86362001)(2906002)(5660300002)(66476007)(66946007)(4326008)(66556008)(8676002)(6916009)(316002)(2616005)(478600001)(36756003)(186003)(6512007)(26005)(6506007)(6486002)(966005)(41300700001)(8936002)(83380400001)(6666004)(38100700002)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PS5iHhNTVS396t8hjZXSNZreaGqJOqtIdcrbzWwQr8EdR0x1h0ce1DESJNz5?=
 =?us-ascii?Q?MjC14cUjNad643VWILG5rS/t4kHezvzOSC2Zy+AIRb+YYKiWSHUa4AvCiEY4?=
 =?us-ascii?Q?OJ6bj3ffof+mzsDWhCa/Gx67fHt2nCSMfeeNdEsFY78fCrZeJP0Xq7orjKpF?=
 =?us-ascii?Q?NSKpYXTSK3acuQEyP2hlm6K3jSScdPt7H0XgulGt96GKcxvFdgJpuv3xJ7uh?=
 =?us-ascii?Q?kUno8bvSXnEB5U4azK3V2djs7LZNEKTMq4V8oW2/JDjI+vG3zHo7cvGMUY0l?=
 =?us-ascii?Q?VImoJ3qNw6AoUR0wCj44E5V/TPBfMf9xIG2YqfwJGBE6YbUibG3QKrmOwE08?=
 =?us-ascii?Q?++k4Q5idDG/0N/5ZA844PDqSvaqF8E+bBaF1bXA2avcybqaTSv6FY5V7mHCi?=
 =?us-ascii?Q?0BirludQpRudpSll2LFDnJBD0n/ZYULRxWtHqN09ZWRq/ru/s0CyaNyFcXfw?=
 =?us-ascii?Q?E8x5DaPM3Eu1W27O1Fjgr8zToIN1LzoOQdp7g8AxIQQ8vC/vhZvGZ5iqp4F2?=
 =?us-ascii?Q?z/LUKq6x8ND+jo3nksBJmSTGRGhHUHqWpy2rBQD1uvzabRMXWMzLV8sYhTUw?=
 =?us-ascii?Q?ETq9sfPIxntHJrgQcKrQ8ADUlXcSiv1/T0fhU9P/f7DETcJHHm/7VCdxu6/m?=
 =?us-ascii?Q?Sq9ts+vjsA7lQSyg4QoseENiLNO3wRDwcFSV+e9G6IklD2TkdnL2kx7nWJ6y?=
 =?us-ascii?Q?eZyUvKzR37TlhYkI9bE/kvm2Qe3omlby1N+ljwBMPOwdKh81wl7hRJk/ccmm?=
 =?us-ascii?Q?TGy4jKfi1XHPVhoaUSSE6cqvk6i9YK7P1Rm4vEGrAkYNV7b14ToKegiyVPZ9?=
 =?us-ascii?Q?DrTlG2BrcYFi5be3pip9lz21O1GKOBUOInj0w9vYGTpPcEeTAnUu8UPHWNdW?=
 =?us-ascii?Q?t4KhFOFBpFlunf5TmAHKEsej9uFAGYR7N3DFE/WNnSGNBDi4VPV8PhaHcGuT?=
 =?us-ascii?Q?uxKjbPEUkK58+3YYo9ClLMmfgm3lAUnDeDApR5yF0PegDxSDaFkJWGRksZwj?=
 =?us-ascii?Q?vA0YXsfuzJaPnW4WaiMkjXiADjNBGazJWw5OIjFWZJQXkdRgew37ayCkGztA?=
 =?us-ascii?Q?1oAYnFvM0GdUWLc5xsWgyh9vxHbzRQcz4fiwLZT2aGkwtLf7JQrRMjdXIk5b?=
 =?us-ascii?Q?dzuUfylH6HHetupDCCw43yICKFNYJV7HJYNHWu4QCT+RmSXMgxNIoyunlmBm?=
 =?us-ascii?Q?l5xOCPv156tJUAdh4R8dhtwM+Bm46U4+7dy8O5SbH9w2BqP8T+rJgo3Pcszl?=
 =?us-ascii?Q?9nb0lImQAgQjYCzMY4ddZJpt5UbDupYtetxmn6HBvoROX7MA9PAOFC4KdLF6?=
 =?us-ascii?Q?qXaInH1gt1Vl41Kz9PjhthWrF1fm6tIDiVXyW6TrBLG51dRD399Yk+uubaJB?=
 =?us-ascii?Q?qGO6Tj3JUGBtuzBb35esKPOoF0CZDNmiMPnErb3/2iSycxfin1/kbWcs4SG3?=
 =?us-ascii?Q?ZJLGMiqjpxLbXP9lyNVuLSKGasyAg4xClKczINqRG1P7z6cAYW6GTmgQVzI/?=
 =?us-ascii?Q?NCTYB0A7cxZtmL1qVG/h63lmQYjIaosg41zFO2VmJN+JJ/3ADZeDw27zqsfa?=
 =?us-ascii?Q?nIGg3mcdHZog/AP/cRpSPuQVyaYQB9AdO8N+sTJh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6d6434-1559-47d8-aad3-08dabc06341b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 12:40:05.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwdSEhmJ/qSAqxBnPPLz2NiBdySUfFClTRtthyTfWIsoiUpkn/XEKw3phqaAJRFiF3kdVuZtvygGQr5bCJw7EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, FDB entries that are notified to the bridge driver via
'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded by the
bridge. With MAB enabled, this will no longer be universally true.
Device drivers will report locked FDB entries to the bridge to let it
know that the corresponding hosts required authorization, but it does
not mean that these entries are necessarily programmed in the underlying
hardware.

We would like to solve it by having the bridge driver determine the
offload indication based of the 'offloaded' bit in the FDB notification
[1].

Prepare for that change by having rocker explicitly mark learned FDB
entries as offloaded. This is consistent with all the other switchdev
drivers.

[1] https://lore.kernel.org/netdev/20221025100024.1287157-4-idosch@nvidia.com/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * Simplify condition.

 drivers/net/ethernet/rocker/rocker_ofdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 77ad09ad8304..826990459fa4 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1826,6 +1826,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 
 	info.addr = lw->addr;
 	info.vid = lw->vid;
+	info.offloaded = !removing;
 	event = removing ? SWITCHDEV_FDB_DEL_TO_BRIDGE :
 			   SWITCHDEV_FDB_ADD_TO_BRIDGE;
 
-- 
2.37.3

