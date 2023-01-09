Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C46662719
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjAINcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjAINcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410F71CFF8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:31:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xg5q6lcC/A367rp1+dmeLzPCOILIMnibABAcaRKUXK84itgLrmkNjqp/AHfIS7L3kqLWiVfiFQBD69C5b3QNSYxkWG9qpII/oo9jiRHMbNRf74pkxglCvP4o2ngSNq23v5g8tYmt6LusxssaTkRpHyimCR0/ZXRBHbqoGCtHhYr0uO1p+xAk2xDHkgxe3S8t1D8JAOB1M1SHNLS4aQN6AAn799pspNxGQ1mLRhcmD45ynO/Jlchjnj3miO2c36Vh9o6j2J2XO6zhGu1cLGTP+ElzRb/5bGQl/5oZZof6gusY6phx2xtjEpu+pdyL8k5CwvvUIM536gzNmcanP57hAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xujxbk3UHoXPvsKZe8TaQASWug4Gd6EQPMG+Yx6TJj4=;
 b=ECn+5reOlhAROxEHTb0N7CbWTL3SycNsqrmV7WtrKvJw9yRHGgjZNvTYmTsC4NwkS/x2/NFobONoXvAjkkTgLyf89tvO75IGXCpwCcf7iMyJ7kUBsyCjZwtcgmvE2SfB/AQtv08kQ0DbQpogJfakmYlotPGgyGhrZbzv5AkTGuq/I+gHIp2jEo/Iy9ngeu5SeKEm2iMEEejZF73IRJ7KKo+k4+7zTSXPbbCmh78w2ppOsiOO7RHeabtFeB90T7ALTwW9TP2VJKNExffGdoSThqnkR7b3HJ5hSets4af3vZM/dgbVrtduLYx/xvNoXh/d7s5T1Mt6sZc3VjzJjBStxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xujxbk3UHoXPvsKZe8TaQASWug4Gd6EQPMG+Yx6TJj4=;
 b=KezZDJjp9AhYtlKQItYDT0FUm2mXSgJCcsJ23JaShcrm+lv32lTPLr24q7MRtinygO0Mry7bhy8qyTSIB+wzjqwONEBIZ65I329lFFwkkomNw35q5k0HYAeKcPicFZrdMPQZXMkUK64QNgbaenXdW8t8lqxbEFnRg1K98bPg8RzAeRFjT6lwgiZ8SCrBXuMW6mrkZKjuoNQWzzZFE2gPC36rkMd+zNRpwB9S30vK7rqGyMWTdzY1OTvbUW7LLm1EvjxaCzdDW7RwZC0UIdZXfo7q8GBsNlrANwIci8r/4vDI61iqXrbCYxMESYrSWTSgUpFfXq9dN30pBb7mn9VE0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:31:49 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:31:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
Date:   Mon,  9 Jan 2023 15:30:54 +0200
Message-Id: <20230109133116.20801-4-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: aa366a4c-abdf-46d7-c70f-08daf245dbe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iI3Gjt2+z00AFBuLfb+C/ko4tigYpOMQ2S200rOuE3eBwHfSs5vIcEK0Bkv54jIJMrbanlKiavR+nmr/99Iq60j7nV+mVGZ4MhFW7kcNzsA0cSvYKoOqHfVGDJZIgW4jAxJa8ng6NxN6Fo1vO8fueQ/ZaGMMcMKGVSWF+itpkEtekp/fWXNK1iEj4Jd18peppGe8hlScPauVtT/ShVddvu9sjNNIz8GeO+ei8LrtObIFhVik9j4CwyIt3aB7X1OsaZ0j6H/oNkkMiWVVuNdPlLl3IhHs0oMQ41vuFFBvzoMm4NY/rBMlNWcqRNeRDDU8SYAhswLEtzvGgi00rbh5rT3v8J+UMn3sXIgNEjpwFSmP32FYk+btc70pzQrlxQwBhq1xKaHgKYaO/cpJq6oXDniDUxKmM46o67MP7xadQPfxHVy17FUAr8K73JejSNB5fsHyqkuCCOEDhGwnaHMmIMaoNit4BZtWq17XttNKlQtf55bewby4Sp1blXbDw3egcX/0mcBKAYT0ot8VZnh5jntNTi+hZFqb/S6YjccgpVLeneIGFrzUhWjFvATGu0JvzIjbqZSE49AwM4+ntN/JV4rlUfrJJVWTHEYSdYp6xPFC+2lRSgFEDylCM49sDpCs/Zsq/OIrovjSxGP261uBdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(30864003)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SWeMtU6JDL1tfab9UH3YFCL6tiPCLoVrDdYl8qslIrUCdcaLKWqSqb18Mzvv?=
 =?us-ascii?Q?mcFglrnf0TIm2BCB9lgtGRsN4u4eHny3bS2NrISoPnYKikv2QkPu6b59Ek6t?=
 =?us-ascii?Q?v41+oXldCkftVPRorojVeHJLTYcW5RlEbjxExM5mKVdQcnomJO2Y/IWJFTuc?=
 =?us-ascii?Q?2FFC3p25adZkJE74AtvxkkwocYPrfCPifwkkKhTnwA39XcEKckbRHz/PP/Jw?=
 =?us-ascii?Q?ypw3dxUWrgcEQPPzLO9GMEpA3ksVk5A7QWL0+vKwXzxqGZ6zX7rgk6uXrnCp?=
 =?us-ascii?Q?6K8ERIFYrmtFyKhA699WyyrClkZSNEz14qwm6B/yGIlw5gVsjQoS02dhCyAw?=
 =?us-ascii?Q?FbK6VspY/k/g0R0BfqMQ7qSXL+PUlnjQiZ7VLY2ccEvZvraWtrMLdPtvKhrA?=
 =?us-ascii?Q?0ZRHTJqt2Dg6Ws2y2gq3IZNz3ffKIsYfVU00CwmIccGQxpV2N3IAp388Bn+L?=
 =?us-ascii?Q?/3OBYGM8y0DRCAEMTZsv95fgGs2TAdn4/KXnR0NyoteHOu1qcNfev1GaTCI4?=
 =?us-ascii?Q?0tKXlYmNe/euPlhwOxWEBFopKzYakcKaYKwyTOk/imdy0qVAlor/wD1KrGFa?=
 =?us-ascii?Q?ZfoLpz2PUHZdREMO/OyHLjwGZ7OivikmtCqoWMBJHCShvta4sfEVyF8SoyMa?=
 =?us-ascii?Q?wHCdVUlXlpCQvFCd2xpTl3IRU9r6OWZc1DLhRs62dJHepUOn7Tgsoh+rPILG?=
 =?us-ascii?Q?JDaknqglO4YGTl8oQOjjV9tx+IGUf2b98LzO98dlg8z2sAztttdJibonoQrL?=
 =?us-ascii?Q?4+98mzwjXRGOhwUsoTzRKn+N+awTqKzzb85hfsDeHCsG+rI399GAo9bVNh/b?=
 =?us-ascii?Q?j4div3KX21odtV0WovrFz8nT9FawRw9JY7DCnSuACUSm5rGGW0JH7cgYiqA+?=
 =?us-ascii?Q?EoSifb14iQ0Xk7g4PtQDZIWFZ//NhQFQ3YzQekr+WnNFDTQEi7BC7aghgYZt?=
 =?us-ascii?Q?eJjFjYq5Ff6h/N6tQEHwDgOh/yIE+otKxYhTMX0vBBTfNGweQXhxCn6c25kZ?=
 =?us-ascii?Q?mHduzhoBz35N6FZ13rD60gWY7Ug0CsCzkAMgsZZHAr/KHUzSs69a+SKoB9Jy?=
 =?us-ascii?Q?pKVZd2X98IXPU2aNm90322akONflS/VrrRNRHWLNoR4U9AmZ3Ed+1XiIMSjU?=
 =?us-ascii?Q?jQeAl7BEN9d1JDBjV1p3Zgo0csoWyb07gKdTtlpAEenQyKGWI5Te/OJeiuFw?=
 =?us-ascii?Q?D/dEWLWSx0jMZq0ejW9CPKMEG3ze5mbmFQlBKc2hg5GjfAvM5yb/gUUH2HsI?=
 =?us-ascii?Q?EF2umbRHb7GlJzlLRge6OKy0Q51WiZHmBEUz5Y3+TuyY1NZJIheBtchKaFKg?=
 =?us-ascii?Q?B1SoELSumPEdnAlEI7M5axcjh1h4xiPXxQ+vm9xD69VO7Ps7n5gmghnlh+Ts?=
 =?us-ascii?Q?23k4kUa+EXERhSRx7SIYh+42zowr5EaWCOwsJU4zaAF5YCM1xU4vrvWgPTbQ?=
 =?us-ascii?Q?FDfx82vWnPn+b76RPMq8e0IZUjcWlQTM9PRNnF5bWwbdQN7Y06lyxxGg9965?=
 =?us-ascii?Q?JlKsVXHVf1JRt4n99xdxKlrDg5mMu6GwmPo/KfjeUjqVt+OtNHTu24qNMFOd?=
 =?us-ascii?Q?eBGVzOz7Wu3UNLR8P7jf6mFNxNhZNERxy4sykY4B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa366a4c-abdf-46d7-c70f-08daf245dbe9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:31:48.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvaFl56+aubol6pQZv1C0WUO/DBq8pO5+B/aF0ZoP9MU/CwR6CNTxlTrGiiE7AjOyngZbDk+SSfxF7vFXJCo6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds:

- 2 new netlink messages:
  * ULP_DDP_GET: returns a bitset of supported and active capabilities
  * ULP_DDP_SET: tries to activate requested bitset and returns results

- 2 new netdev ethtool_ops operations:
  * ethtool_ops->get_ulp_ddp_stats(): retrieve device statistics
  * ethtool_ops->set_ulp_ddp_capabilities(): try to apply
    capability changes

ULP DDP capabilities handling is similar to netdev features
handling.

If a ULP_DDP_GET message has requested statistics via the
ETHTOOL_FLAG_STATS header flag, then per-device statistics are
returned to userspace.

Similar to netdev features, ULP_DDP_GET capabilities and statistics
can be returned in a verbose (default) or compact form (if
ETHTOOL_FLAG_COMPACT_BITSET is set in header flags).

Verbose statistics are nested as follows:

    STATS (nest)
        COUNT (u32)
        MAP (nest)
            ITEM (nest)
                NAME (strz)
                VAL  (u64)
            ...

Compact statistics are nested as follows:

    STATS (nest)
        COUNT (u32)
        COMPACT_VALUES (array of u64)

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/linux/ethtool.h              |   2 +
 include/uapi/linux/ethtool_netlink.h |  49 +++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/netlink.c                |  17 ++
 net/ethtool/netlink.h                |   4 +
 net/ethtool/ulp_ddp.c                | 430 +++++++++++++++++++++++++++
 6 files changed, 503 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/ulp_ddp.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..7b7ba8a89cb1 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -777,6 +777,8 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_ulp_ddp_stats)(struct net_device *dev, u64 *ulp_ddp_stats);
+	int	(*set_ulp_ddp_capabilities)(struct net_device *dev, unsigned long *bits);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5799a9db034e..7a4a66a9b3ea 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,8 @@ enum {
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
 	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_ULP_DDP_GET,
+	ETHTOOL_MSG_ULP_DDP_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -99,6 +101,8 @@ enum {
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
 	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_SET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -894,6 +898,51 @@ enum {
 	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
 };
 
+/* ULP DDP */
+
+enum {
+	ETHTOOL_A_ULP_DDP_UNSPEC,
+	ETHTOOL_A_ULP_DDP_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_ULP_DDP_HW,				/* bitset */
+	ETHTOOL_A_ULP_DDP_ACTIVE,			/* bitset */
+	ETHTOOL_A_ULP_DDP_WANTED,			/* bitset */
+	ETHTOOL_A_ULP_DDP_STATS,			/* nest - _A_ULP_DDP_STATS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_CNT,
+	ETHTOOL_A_ULP_DDP_MAX = __ETHTOOL_A_ULP_DDP_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_COUNT,			/* u32 */
+	ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES,		/* array, u64 */
+	ETHTOOL_A_ULP_DDP_STATS_MAP,			/* nest - _A_ULP_DDP_STATS_MAP_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAX = __ETHTOOL_A_ULP_DDP_STATS_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_MAP_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM,		/* next - _A_ULP_DDP_STATS_MAP_ITEM_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_MAP_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_MAX = __ETHTOOL_A_ULP_DDP_STATS_MAP_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_UNSPEC,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME,		/* string */
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_VAL,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_CNT,
+	ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_MAX = __ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 228f13df2e18..c1c6ddce7d3f 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
-		   pse-pd.o
+		   pse-pd.o ulp_ddp.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index aee98be6237f..1ebd512dca2e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -288,6 +288,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_MODULE_GET]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PSE_GET]		= &ethnl_pse_request_ops,
 	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_GET]	= &ethnl_ulp_ddp_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1047,6 +1048,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_rss_get_policy,
 		.maxattr = ARRAY_SIZE(ethnl_rss_get_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_ULP_DDP_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_ulp_ddp_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_ULP_DDP_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_ulp_ddp,
+		.policy = ethnl_ulp_ddp_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3753787ba233..8040fb1e86e4 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,6 +347,7 @@ extern const struct ethnl_request_ops ethnl_phc_vclocks_request_ops;
 extern const struct ethnl_request_ops ethnl_module_request_ops;
 extern const struct ethnl_request_ops ethnl_pse_request_ops;
 extern const struct ethnl_request_ops ethnl_rss_request_ops;
+extern const struct ethnl_request_ops ethnl_ulp_ddp_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -388,6 +389,8 @@ extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MO
 extern const struct nla_policy ethnl_pse_get_policy[ETHTOOL_A_PSE_HEADER + 1];
 extern const struct nla_policy ethnl_pse_set_policy[ETHTOOL_A_PSE_MAX + 1];
 extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
+extern const struct nla_policy ethnl_ulp_ddp_get_policy[ETHTOOL_A_ULP_DDP_HEADER + 1];
+extern const struct nla_policy ethnl_ulp_ddp_set_policy[ETHTOOL_A_ULP_DDP_WANTED + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -408,6 +411,7 @@ int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
 int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/ulp_ddp.c b/net/ethtool/ulp_ddp.c
new file mode 100644
index 000000000000..f4339e964d2d
--- /dev/null
+++ b/net/ethtool/ulp_ddp.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * ulp_ddp.c
+ *     Author: Aurelien Aptel <aaptel@nvidia.com>
+ *     Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+#include <net/ulp_ddp_caps.h>
+
+static struct ulp_ddp_netdev_caps *netdev_ulp_ddp_caps(struct net_device *dev)
+{
+#ifdef CONFIG_ULP_DDP
+	return &dev->ulp_ddp_caps;
+#else
+	return NULL;
+#endif
+}
+
+/* ULP_DDP_GET */
+
+struct ulp_ddp_req_info {
+	struct ethnl_req_info	base;
+};
+
+struct ulp_ddp_reply_data {
+	struct ethnl_reply_data	base;
+	DECLARE_BITMAP(hw, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(active, ULP_DDP_C_COUNT);
+	const char (*stat_names)[ETH_GSTRING_LEN];
+	int stat_count;
+	u64 *stats;
+};
+
+#define ULP_DDP_REPDATA(__reply_base) \
+	container_of(__reply_base, struct ulp_ddp_reply_data, base)
+
+const struct nla_policy ethnl_ulp_ddp_get_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+/* When requested (ETHTOOL_FLAG_STATS) ULP DDP stats are appended to
+ * the response.
+ *
+ * Similar to bitsets, stats can be in a compact or verbose form.
+ *
+ * The verbose form is as follow:
+ *
+ * STATS (nest)
+ *     COUNT (u32)
+ *     MAP (nest)
+ *         ITEM (nest)
+ *             NAME (strz)
+ *             VAL  (u64)
+ *         ...
+ *
+ * The compact form is as follow:
+ *
+ * STATS (nest)
+ *     COUNT (u32)
+ *     COMPACT_VALUES (array of u64)
+ *
+ */
+static int ulp_ddp_stats64_size(const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base,
+				ethnl_string_array_t names,
+				unsigned int count,
+				bool compact)
+{
+	unsigned int len = 0;
+	unsigned int i;
+
+	/* count */
+	len += nla_total_size(sizeof(u32));
+
+	if (compact) {
+		/* values */
+		len += nla_total_size(count * sizeof(u64));
+	} else {
+		unsigned int maplen = 0;
+
+		for (i = 0; i < count; i++) {
+			unsigned int itemlen = 0;
+
+			/* name */
+			itemlen += ethnl_strz_size(names[i]);
+			/* value */
+			itemlen += nla_total_size(sizeof(u64));
+
+			/* item nest */
+			maplen += nla_total_size(itemlen);
+		}
+
+		/* map nest */
+		len += nla_total_size(maplen);
+	}
+	/* outermost nest */
+	return nla_total_size(len);
+}
+
+static int ulp_ddp_put_stats64(struct sk_buff *skb, int attrtype, const u64 *val,
+			       unsigned int count, ethnl_string_array_t names, bool compact)
+{
+	struct nlattr *nest;
+	struct nlattr *attr;
+
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, ETHTOOL_A_ULP_DDP_STATS_COUNT, count))
+		goto nla_put_failure;
+	if (compact) {
+		unsigned int nbytes = count * sizeof(*val);
+		u64 *dst;
+
+		attr = nla_reserve(skb, ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES, nbytes);
+		if (!attr)
+			goto nla_put_failure;
+		dst = nla_data(attr);
+		memcpy(dst, val, nbytes);
+	} else {
+		struct nlattr *map;
+		unsigned int i;
+
+		map = nla_nest_start(skb, ETHTOOL_A_ULP_DDP_STATS_MAP);
+		if (!map)
+			goto nla_put_failure;
+		for (i = 0; i < count; i++) {
+			attr = nla_nest_start(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM);
+			if (!attr)
+				goto nla_put_failure;
+			if (ethnl_put_strz(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME, names[i]))
+				goto nla_put_failure;
+			if (nla_put_u64_64bit(skb, ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_VAL,
+					      val[i], -1))
+				goto nla_put_failure;
+			nla_nest_end(skb, attr);
+		}
+		nla_nest_end(skb, map);
+	}
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int ulp_ddp_prepare_data(const struct ethnl_req_info *req_base,
+				struct ethnl_reply_data *reply_base,
+				struct genl_info *info)
+{
+	struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct ethtool_ops *ops = reply_base->dev->ethtool_ops;
+	struct net_device *dev = reply_base->dev;
+	struct ulp_ddp_netdev_caps *caps;
+	int nstats;
+
+	caps = netdev_ulp_ddp_caps(dev);
+	if (!caps)
+		return -EOPNOTSUPP;
+
+	bitmap_copy(data->hw, caps->hw, ULP_DDP_C_COUNT);
+	bitmap_copy(data->active, caps->active, ULP_DDP_C_COUNT);
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		if (!ops->get_sset_count || !ops->get_strings || !ops->get_ulp_ddp_stats)
+			return -EOPNOTSUPP;
+
+		nstats = ops->get_sset_count(dev, ETH_SS_ULP_DDP_STATS);
+		if (nstats < 0)
+			return nstats;
+
+		data->stats = kcalloc(nstats, sizeof(u64), GFP_KERNEL);
+		if (!data->stats)
+			return -ENOMEM;
+
+		if (!compact) {
+			data->stat_names = kcalloc(nstats, ETH_GSTRING_LEN, GFP_KERNEL);
+			if (!data->stat_names) {
+				kfree(data->stats);
+				return -ENOMEM;
+			}
+			ops->get_strings(dev, ETH_SS_ULP_DDP_STATS,
+						      (u8 *)data->stat_names);
+		}
+		data->stat_count = nstats;
+		ops->get_ulp_ddp_stats(dev, data->stats);
+	}
+	return 0;
+}
+
+static int ulp_ddp_reply_size(const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	unsigned int len = 0;
+	int ret;
+
+	ret = ethnl_bitset_size(data->hw, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset_size(data->active, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	if ((req_base->flags & ETHTOOL_FLAG_STATS) && data->stats) {
+		ret = ulp_ddp_stats64_size(req_base, reply_base,
+					   data->stat_names, data->stat_count, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+	return len;
+}
+
+static int ulp_ddp_fill_reply(struct sk_buff *skb,
+			      const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_HW, data->hw,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_names, compact);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_ACTIVE, data->active,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if ((req_base->flags & ETHTOOL_FLAG_STATS) && data->stats) {
+		ret = ulp_ddp_put_stats64(skb, ETHTOOL_A_ULP_DDP_STATS,
+					  data->stats,
+					  data->stat_count,
+					  data->stat_names,
+					  compact);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+static void ulp_ddp_cleanup_data(struct ethnl_reply_data *reply_data)
+{
+	struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_data);
+
+	kfree(data->stat_names);
+	kfree(data->stats);
+}
+
+const struct ethnl_request_ops ethnl_ulp_ddp_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_ULP_DDP_GET,
+	.reply_cmd		= ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_ULP_DDP_HEADER,
+	.req_info_size		= sizeof(struct ulp_ddp_req_info),
+	.reply_data_size	= sizeof(struct ulp_ddp_reply_data),
+
+	.prepare_data		= ulp_ddp_prepare_data,
+	.reply_size		= ulp_ddp_reply_size,
+	.fill_reply		= ulp_ddp_fill_reply,
+	.cleanup_data		= ulp_ddp_cleanup_data,
+};
+
+/* ULP_DDP_SET */
+
+const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_ULP_DDP_WANTED]	= { .type = NLA_NESTED },
+};
+
+static int ulp_ddp_send_reply(struct net_device *dev, struct genl_info *info,
+			      const unsigned long *wanted,
+			      const unsigned long *wanted_mask,
+			      const unsigned long *active,
+			      const unsigned long *active_mask, bool compact)
+{
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len = 0;
+	int ret;
+
+	reply_len = ethnl_reply_header_size();
+	ret = ethnl_bitset_size(wanted, wanted_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+	ret = ethnl_bitset_size(active, active_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_ULP_DDP_SET_REPLY,
+				ETHTOOL_A_ULP_DDP_HEADER, info,
+				&reply_payload);
+	if (!rskb)
+		goto err;
+
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_WANTED, wanted,
+			       wanted_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_ACTIVE, active,
+			       active_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+
+	genlmsg_end(rskb, reply_payload);
+	ret = genlmsg_reply(rskb, info);
+	return ret;
+
+nla_put_failure:
+	nlmsg_free(rskb);
+	WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+err:
+	GENL_SET_ERR_MSG(info, "failed to send reply message");
+	return ret;
+}
+
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info)
+{
+	DECLARE_BITMAP(old_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(new_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_wanted, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_mask, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(all_bits, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(tmp, ULP_DDP_C_COUNT);
+	struct ethnl_req_info req_info = {};
+	struct nlattr **tb = info->attrs;
+	struct ulp_ddp_netdev_caps *caps;
+	struct net_device *dev;
+	int ret;
+
+	if (!tb[ETHTOOL_A_ULP_DDP_WANTED])
+		return -EINVAL;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_ULP_DDP_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+	rtnl_lock();
+	caps = netdev_ulp_ddp_caps(dev);
+	if (!caps) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	ret = ethnl_parse_bitset(req_wanted, req_mask, ULP_DDP_C_COUNT,
+				 tb[ETHTOOL_A_ULP_DDP_WANTED],
+				 ulp_ddp_names, info->extack);
+	if (ret < 0)
+		goto out_rtnl;
+
+	/* if (req_mask & ~all_bits) */
+	bitmap_fill(all_bits, ULP_DDP_C_COUNT);
+	bitmap_andnot(tmp, req_mask, all_bits, ULP_DDP_C_COUNT);
+	if (!bitmap_empty(tmp, ULP_DDP_C_COUNT)) {
+		ret = -EINVAL;
+		goto out_rtnl;
+	}
+
+	/* new_active = (old_active & ~req_mask) | (wanted & req_mask)
+	 * new_active &= caps_hw
+	 */
+	bitmap_copy(old_active, caps->active, ULP_DDP_C_COUNT);
+	bitmap_and(req_wanted, req_wanted, req_mask, ULP_DDP_C_COUNT);
+	bitmap_andnot(new_active, old_active, req_mask, ULP_DDP_C_COUNT);
+	bitmap_or(new_active, new_active, req_wanted, ULP_DDP_C_COUNT);
+	bitmap_and(new_active, new_active, caps->hw, ULP_DDP_C_COUNT);
+	if (!bitmap_equal(old_active, new_active, ULP_DDP_C_COUNT)) {
+		ret = dev->ethtool_ops->set_ulp_ddp_capabilities(dev, new_active);
+		if (ret)
+			netdev_err(dev, "set_ulp_ddp_capabilities() returned error %d\n", ret);
+		bitmap_copy(new_active, caps->active, ULP_DDP_C_COUNT);
+	}
+
+	ret = 0;
+	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
+		DECLARE_BITMAP(wanted_diff_mask, ULP_DDP_C_COUNT);
+		DECLARE_BITMAP(active_diff_mask, ULP_DDP_C_COUNT);
+		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+		/* wanted_diff_mask = req_wanted ^ new_active
+		 * active_diff_mask = old_active ^ new_active -> mask of bits that have changed
+		 * wanted_diff_mask &= req_mask    -> mask of bits that have diff value than wanted
+		 * req_wanted &= wanted_diff_mask  -> bits that have diff value than wanted
+		 * new_active &= active_diff_mask  -> bits that have changed
+		 */
+		bitmap_xor(wanted_diff_mask, req_wanted, new_active, ULP_DDP_C_COUNT);
+		bitmap_xor(active_diff_mask, old_active, new_active, ULP_DDP_C_COUNT);
+		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask, ULP_DDP_C_COUNT);
+		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,  ULP_DDP_C_COUNT);
+		bitmap_and(new_active, new_active, active_diff_mask,  ULP_DDP_C_COUNT);
+		ret = ulp_ddp_send_reply(dev, info,
+					 req_wanted, wanted_diff_mask,
+					 new_active, active_diff_mask,
+					 compact);
+	}
+
+out_rtnl:
+	rtnl_unlock();
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
-- 
2.31.1

