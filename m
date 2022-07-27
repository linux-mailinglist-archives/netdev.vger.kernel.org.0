Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1758200B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiG0GZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiG0GZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:25:01 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E960C402F1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKOMnl2fj8BQTqaAtJWNBn3LzJnj/RPoG6KIFekdNb2amOurSMDVpAVKFes3dsh3DhkDnOr2wChKlM9t1LZE9Hsz1P1ME5ytDPxAeUgqcjybnY9lzBuvLoxK3w0WeV75n+PvREalVNePSYBj/qWv0SPppjwsqligJeFUFus+FZ30+ultCDexMKASKLyYlUfK1wzeI63asm3wor/xmVFHHvMgjKtmW5FO/adHqNcNQjvqQacxU8+D8F9UlQy5Hs2+UrJYHpP18TDgj0g3ovtzkgNQBgxuX6tm9WEs/3fWNMf9DEJELhy3KQ4sFth95GY/P6P2Jg3hVqbmRofCIBSk1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAMjsee1vFqFpARfY1pJqBWCAYW6/0KoD1x8uxz1uCI=;
 b=E8ioQbe9rl4BsDOiwDriVJCH3laz4Kwf2yFMXw3JSO4iX++hBV/yFv0Q4ptsGLfouexityK6j5LY09Yvve7oFEIrGTiWEYwvWwE7i6d662k7nGZLOYZvjHktTJetFYjvGVnGTcUrOBOX2iJ4vJQXyHxmuiTG2p632U+x+ar2cUUfG8VekFDRyiFxs8qXsCIVXgF65KzBMmXMhVbbZQsxOtndhqwVUuwIfPyU5jDthmFiqCRwmQRWq6QOIJ3CHOAJ02bWg7y/EmdKii6BCWf2lGb6gNDjxMjbF2H2lrBZ2Czl3vA4mgUgTFHbh46VukQu2nVwkoH0YswlbQ1KpMTwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAMjsee1vFqFpARfY1pJqBWCAYW6/0KoD1x8uxz1uCI=;
 b=ZplBnfGDr5p36vfGd7CBMj8xCoDvvF2BtuU/rc+vUdE2R6i/usQHMtIe8RDoMlk+N6Dv40H9GpFIbSleAKwr+qzEREjRgHBm5oeWNe8LGeMfBqxCI+PPAp/fov2zd6WF+phQrfVMEgueGga71LSdNzNK3ac4FTH94h8UoO+PXb8iXVp49AT23UZk4pGpaHrVvG29EMk3IEIz7tP3+eF+S/v33SHgOs2euq8vlT/2g8uFVJPkGufOsIg8JQumcIyJLLPRohEjThZGqS85WE1ADsPK88KVvz2wdfREVO5iJ2gRSoMdfmiSBjWpzf+MJoIg/fvNbRh2w/9cqjExyPEy0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1697.namprd12.prod.outlook.com (2603:10b6:404:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 06:24:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] mlxsw: spectrum: Support ethtool 'get_ts_info' callback in Spectrum-2
Date:   Wed, 27 Jul 2022 09:23:28 +0300
Message-Id: <20220727062328.3134613-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0005.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a670c3b-bcbf-4b4d-be24-08da6f98b94a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1697:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+zacAXolv3LLIlQI3o8ZbBPRh3R9Iz8d7y/zIsaaf7OScuKLzQx5CFept885VFJTc6nlVXFOx8Mrc0uBTgK+f2Vs14VGbVbaY9M2kwVJHi2SM9p+Jj7mo9gMREd4sU4eLPoM9WPG++Rv/tHAQ7rpPTBP8p5Y2sC/dKdeIA++C4biQzuVTWOyTK+naKYNEBmTdcg78TC4kkgWMBSC9+tJefdVCowhbfITHL6HoTuuYYoY4U8IGFnACyIa/FDQ8IvHxCHPO2RBq17SvI4TbKpx2ND0/fyHh5sexF0427xJeOh0ffXrR0cGLQFrEAsSQbnCAhq6F1MMlCQH4ECGWY4eD0B2A9ea3VF9btIgd2eGG2OrjDcLeBvGMPRO8R9E83tC+kqobNOTVlfRictWICZcKQviag/uEJNPNCXr9YlfanIoz7VqN50W1d+y3lpwHF7ym/fW2PMROM9nEuGAUd8KypwwXvlt02dk0QqbITvwTqidd8uAdr5CX/z6LZJMTSBrvebMBOFp4RLCEK/ILC657KxWcC4ZrcR+KACjwkuZINa5AWrSRYOkFi6tDKWGYubzVLBT9TxRzhLNhCke9RFvfz1+LONsMmG/jtaG6bmYJWKYBlY+3tJmk04f/icwnElrAlOII37DluD6AVHPvrkyzRX+TQHiao2mfBGkrCrxquFiHNvk4CRS1hqnDDzvyW0arue5b5itzNZ1YaeLspBZJEWjjnRzljmGsm11jWhYcDnOFZo5Y+gXfTGpMLxg8L2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(8936002)(5660300002)(36756003)(66556008)(8676002)(66476007)(4326008)(316002)(6916009)(478600001)(6486002)(2906002)(6506007)(38100700002)(41300700001)(6666004)(86362001)(6512007)(26005)(83380400001)(186003)(66946007)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lVUXDgPz7uxHN+7xAXUDgBs2wPuSBWeN6EVpc9hLwjSUGmJJaDYhOyqsnV4a?=
 =?us-ascii?Q?T1VSF4uMObu0IFjL+VVy56M7tXreBN2mmxUHDDIWb7b3onlTcM5ENamC9vba?=
 =?us-ascii?Q?GMlJALLzviLgzFDFepQY3fUhN4htKOONV1nAca+/Qiahrx8DdQ2HhtirVZ29?=
 =?us-ascii?Q?tdq8o04KkuCYqaFT4q5VrT42Lfpk849z+3dV8OUabfGZEUBQf6uQmFTPi+hx?=
 =?us-ascii?Q?Pk/+zoYWRZqhA6voilIU1V6P7y4iWpy2U4/parDf8QbAqaKVqyMC/FYlieeS?=
 =?us-ascii?Q?m45shlM9ZSvok8A3C5yih2StdlOJ/h2gEszVMP16LvKEvNxfWudn0A7bQMqi?=
 =?us-ascii?Q?8MHmsEYyLh/Bh95J06/slUCNsu3QZ4cK0CRKOIaSzDreg6YUBUFcb9iFhviw?=
 =?us-ascii?Q?kZiMTFSNHLmEJugmCQMJ2UiRf950PhKPOsG6/ihYnO5G1wbI/ZAav2wbgr8T?=
 =?us-ascii?Q?ixym25E/XkOlXsA9e6MJYUdwCVZccAL1K02JN4eY4gPCdhZr2YF4ELuQkv9k?=
 =?us-ascii?Q?3hwE00ozFw5dEFSmWYgcGr7EZMe5ZikhdSQcz27l1kOJGJ4bYx2dlOaSKkIT?=
 =?us-ascii?Q?QG3yxz4honCJF5NVqXBtaa/qJDct/qdpeHaCFMFDPbtseVdY/KAaBHdQj1oA?=
 =?us-ascii?Q?B8yBH3jbQexerbTWhB1tt8kZBUjqMj862xBLAEeZJOCc+B7FGFq1GfzMyx1U?=
 =?us-ascii?Q?qBxl3/unH98wpRdip+UQXI4vftOiGGsarQnXb7A0iwJNkWglGnDDcWokCttJ?=
 =?us-ascii?Q?SMBLFswsxXGZ73pq+Gmvt4V3rM1ploTSBo8OnMdu6dDmgCmUmw/R0tYfrjkc?=
 =?us-ascii?Q?Le4HwiA9I7GQlW1wnUQJHKqgCM4/QfaMNBOG5SBf9c1IC9aPUk+NQ2habXci?=
 =?us-ascii?Q?Sot63S3ZaqL41oouwlrTcGDp1WeHX76MxEUR/kzfUCaT1d3eCZystp9xb4/8?=
 =?us-ascii?Q?61oIZXwtnAMPKRaUz5s01KJWgSRCYqXNg5OL1rlnppjQHMm8HRVAxT40CH5D?=
 =?us-ascii?Q?UCvumNGN3DlcWic2F2FobnLUjrij4J2Ag8G483pjPI3XNuaCKds99fIxmSEa?=
 =?us-ascii?Q?29MbrZsIccvDyzzklpsK0w8UyRU7wCdXauui2D+x6ybPbHnWXSngZI41b42v?=
 =?us-ascii?Q?Nn/My0BS9EZhr8IxigZbtiWUb8ZVKhqnsf9qwJqne5L859qtwmvoNUz+thND?=
 =?us-ascii?Q?IvPqG8fVxSgzTU593a4aFf0SLwL+AmJgZCRqtyUyXsd1xvwbX0ES7PA4iP2n?=
 =?us-ascii?Q?85C9Euitgitl95kJ6a5xhccLlx+gsmSKWaVZCPprZcwq1Q4jnLVHCNrruq/z?=
 =?us-ascii?Q?nCwvG36umpM7I3JRBLD1CNAJlja7RLT0ILYeY/3vWtrgFIs8VU/ofT5cbZMo?=
 =?us-ascii?Q?JD1/hoP7Q5WTg4fN+DXkE3XRiXXJ2lVHaX77o5r7Z3LtM5YoFzrXbSgbyNgr?=
 =?us-ascii?Q?sAqie+9wmMHP4SfbhoK08BIcc3VFN35G0yo+Ap1ii1LHgfYIWRocJqFmbRhQ?=
 =?us-ascii?Q?qtgLNvGBZlvhWdhaxNoLNEyLOY2HRiIVHz9cuh4ZLrYB5pa2TcjCi6bJWEsy?=
 =?us-ascii?Q?YQR5vkIKfgWUCqv4DzV5jPFKscO+7GPu9hlpWhq0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a670c3b-bcbf-4b4d-be24-08da6f98b94a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:56.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTL76lfEewf2ICA/8UeB9EKrqYqQJUA3GDXNW4J+QvGKfp4FDYDV1+ETcJ00J+LcRkhcTMedPBP0V8W1/Emn7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1697
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The 'get_ts_info' callback is used for obtaining information about
time stamping and PTP hardware clock capabilities of a network device.

The existing function of Spectrum-1 is used to advertise the PHC
capabilities and the supported RX and TX filters. Implement a similar
function for Spectrum-2, expose that the supported 'rx_filters' are all
PTP event packets, as for these packets the driver fills the time stamp
from the CQE in the SKB.

In the future, mlxsw driver will be extended to support one-step PTP in
Spectrum-2 and newer ASICs. Then additional 'tx_types' will be supported.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 19 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 15 +++++++++------
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 774db250fc37..2e0b704b8a31 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1656,6 +1656,25 @@ int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
+int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+			      struct ethtool_ts_info *info)
+{
+	info->phc_index = ptp_clock_index(mlxsw_sp->clock->ptp);
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V1_L4_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
 int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				 struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index fbe88ac44bcd..2d1628fdefc1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -83,6 +83,9 @@ int mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config);
 
+int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+			      struct ethtool_ts_info *info);
+
 int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				  struct mlxsw_sp_port *mlxsw_sp_port,
 				  struct sk_buff *skb,
@@ -222,6 +225,12 @@ mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+					    struct ethtool_ts_info *info)
+{
+	return mlxsw_sp_ptp_get_ts_info_noptp(info);
+}
+
 int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				  struct mlxsw_sp_port *mlxsw_sp_port,
 				  struct sk_buff *skb,
@@ -235,12 +244,6 @@ static inline void mlxsw_sp2_ptp_shaper_work(struct work_struct *work)
 {
 }
 
-static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
-					    struct ethtool_ts_info *info)
-{
-	return mlxsw_sp_ptp_get_ts_info_noptp(info);
-}
-
 static inline int mlxsw_sp2_get_stats_count(void)
 {
 	return 0;
-- 
2.36.1

