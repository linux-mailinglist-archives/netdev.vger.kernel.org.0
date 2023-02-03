Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89ADF6899AD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjBCN1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjBCN1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:27:40 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00C38E079
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:27:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzDdhxTvHCRsO8ikE/tCX1ZVgpRL7KV0925C6I1kt2F4hZ3nhQgXblkmM9xqgJDP/eROKTJjWifYOvabxyb39rMxl+hejGzaJIY4g36jpiFEhAovpHfQL60ywDPgbUeCCMB4xmGk1ODODPEVLDNbEreyAR5TXtzOn5PREHm+98AcqNaOWEQHl9VrFfXtIXYY4PVHkmoAzcKJoiJxIHxfsVmdLP3GGjYGgagoHp2hG7obykzaO/d+5EBk11L6+6YaDYo0xyt6mnf2V3FCaqGy1o4Rv6SAFw2vMamyTu39YpPaZcC2lVTeTxJOKpQSS34Ja0KusLmm78zwV8LbNE2u+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwRRsayFrS3yenR8XvXUFZCiV/4l2ag6XJS/D31XDb8=;
 b=Ca9putXjptaFJWnlpb586dYuq3Z0CwUAyXp7NnMobT/oyFu0dgH5jGfW1BAsdqcNg49t5jd/BIvza/qCyczBMM5zZY0cw+f2lRwXlAZ7j/7ULHg1gmKMd/9j3UYVwSQTeZ3uYWfxiPV2usefIdyV+cRkxPFB+QA5grYwb3u/XQ7xPGn6JUtQN+R4tNGkPOKdy9xRf3Mx16uOUPILCBUdVK8tTy3OQG9FLdWFM1TCfWxfd6WSy9kzn8NGx/AxVCYmsUP1E4y72l7/23gcUyep+sd3a55QGGZpNmY1I7Uun231/po7y8oEQOv6J+wb+IEOAd9rr+b//sUdlSRz9aXDNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwRRsayFrS3yenR8XvXUFZCiV/4l2ag6XJS/D31XDb8=;
 b=fipk2Cw/rIqePh4r/bBL02zqo1zNdFnV8MBDQ+R/YNRqxSM23aR58EARx5FpLIsbC7IgpRdKOxnMFCo6G55PT/U8obJo6x0Z3n2sT4rK4ukOkcxltNL6w+S+f/Sfogx1jnoOvxbcXWdutWVTlioTEXZVjd4M7GpPQei2lI3OvDiBG6TL8r7Y9I+ghCrIHPB9tlDDBZf9cUsSapkkU3o1pBHwIR3f5igwzfnRc6fvVHuV0s7YTwisrF4FOqpgbq4tCTlejGUkUb3icTcZWfXMXTOXUulrM3adXe+f+zd6cUJD8rJxFzQomZJzCu4q2mmcbA5y71LQ8G5YY897zo1iJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:27:33 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:27:33 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
Date:   Fri,  3 Feb 2023 15:26:43 +0200
Message-Id: <20230203132705.627232-4-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::23) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 7acdb766-2bea-4aa6-fd99-08db05ea6827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 58H6pnCYyz8pwXgCw1sHPbUvThGuYxPCJhZQVwXF9kR0bpu/mgvwVQ04joAjrm08kgozyxuzhu+zcrFU9R44HYWfaAmnblmFQsv/TOPIknAtX14uZMSjWL4Fb3r3KhspMihzTmiCHOXCaWc2FORUAnVzbjGjdR0DJ/pGspSMwnM5n3w9L3h6UXSV3HQha9SI9mrAhBFpTljCMNwo05RB2LFIQQMRykTO/oVWmIY/ZW6QO0rco976UFqa7uccBE+6QkXQcRNMhFIL7MNKjzGwP5xg87g+CKyrL3KkcWfPINdS+OkgMlpsrAG18SKmXBfTYgivMn75Tqpa9Z+GshC87Fqk3vdzAGeepx79nHFSxIJAw4jd66qmmDNM8LbjfjonDoJWWmyN8aGpO5Vht27jbwbvZozUPUjGlonXCzSfC1pYRjVApuio5nqKjMQYnKsQh2w2VQAfIJWNOiKtiCr3nDwoCq7PmTaNWjgYiukDaM5AK1M/UQqx8rpICWRisrK2AeLHkK0hjPTCyhqfPOPZ/Vky0Buktlsehr2m4VI51xzX+oVXOqc50dW1oRtLCMtF+cxLWofnLg4skJtnTclp1iTbV7a9789bUkzoEttOcSEBqJeYlXrlFGYYzFL9Sp5eFEgstAjM/kKshbbVF2apAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(30864003)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oSyZGIZyZN8RJHRkluEuC9uIsieS7Q72G9N6krYnq1zqU0e9TvpiA/AIbZYN?=
 =?us-ascii?Q?2P3Bij9BfxKxMwcIVRTNEH2QcNjazMFDtxWR9nLJbeGF1ev8lZ+fv95JzjqD?=
 =?us-ascii?Q?a7QXj134XS0nS2ofV57A8f5qRKiffi9nR1Tv5lXhndKh0QyWzbKuImXDtwb7?=
 =?us-ascii?Q?Hy2sKyz2cQY3Nz4D8VvyGD21M4RH+wAtBm9JTHTFECvPM33/HOBOXEwMN1fn?=
 =?us-ascii?Q?sUvZrdunoQhM8bTEQqfUJJ/9eI/nLF1dZYiR821GbTxcj0ZF4nuPAfK15mnH?=
 =?us-ascii?Q?W+LAxKIL5gemqxF7jyfZ7ypZicSazxd5kPO/1z4lMyKz5m2/+ZBCjE+bhCw1?=
 =?us-ascii?Q?07Np3ksW8qDUrIv+5oKvVz8CxY2dNNwVo1H/rUsz046TYbF9CpdUaXqSKUvW?=
 =?us-ascii?Q?jMF/XWJke3/DUJE4XNX32uJVjmhp2hAbuNaGioNIWXj9cXkcl6S2oBXLflYo?=
 =?us-ascii?Q?BkXTVATII5aoGTIHg58bZrUM5L7FcTEvuLFXirrNMWkx0YhhKGjLaHVF+T1f?=
 =?us-ascii?Q?gmxrAPX9a1JudQAqUvW2xx2YHnmLefmGGtDUxVyap6tnO+I6Z7MOE8hKNMob?=
 =?us-ascii?Q?LvRoyelpU94yY10AD++Gtg7tD0pqQ6aWdsgVBbWVljyfk8Vuc3AB+q/C5v5i?=
 =?us-ascii?Q?RIKm18plTVeZ6zdZN3euaEnlYXJ2by+IRPlgXBp/2OedP9+Q15imfi4d9c0c?=
 =?us-ascii?Q?C7//0DS1rRJmTMsWI4Nmgei5O7zJHKVQcnYKuLrk9kUD+NhhxL8BEfgkLuvA?=
 =?us-ascii?Q?7lKpgG5J3n11YDRX00iy0Zcm67L/pl4PHtF7R5aIwPXQVaNU8BfRjwkdDsbg?=
 =?us-ascii?Q?sIxS3QQEr7VXuj2roW/1Qd8nVmiLyJR17VGSq4Cyfqf1R8872MyS3uBVGo8p?=
 =?us-ascii?Q?FZfeH0ez85pGYPI0v4domO0yEIKa3E2RuIcWb6HZ0swFQSAM+P4sTaIxjHXH?=
 =?us-ascii?Q?pCgqSalAOxU3iPRkKTR6F02V0oB2OQtIFCKbOXwGNvwPlUlaEegOZZhHElfH?=
 =?us-ascii?Q?IzORE9pHBJpW9OauBB1JSfbkvQ09LFPAy0tjmSJ/yMEwx4SJ0NRYSQJIuPnZ?=
 =?us-ascii?Q?Z0K2mAswbbnzXlm8dbObCKS8UzOl/TrNx59GVoTh1rzIIObUp5rjYlklk/iY?=
 =?us-ascii?Q?SS/iVgoC5wKxY78V5fhHMmujigkz2Iso7/rOfeGZovfODL0/ToCEDF0KVCp2?=
 =?us-ascii?Q?z3VR1SDLBfP+MGJqBuU0LO5pE5pd5lFlCDFO+gkrTw5Ji/Odpi/XmvNSyw9R?=
 =?us-ascii?Q?y6zzoB4/tAYbQhjYXYdZnvYlVeNzQSm42DEVoWZbpsWjHWn9W+HCIU+FEZgC?=
 =?us-ascii?Q?p4xMDnwHS+/9SNwYlHHbBF+pC4VOs3b/LC+DAuI8gRYNhqQ+PwbZ993yWEql?=
 =?us-ascii?Q?PzNMSPZgGlo9bDaxsREGWXCALrd65ub2eKSOWAOCj8uRDT+Q1FW8oCcim/eb?=
 =?us-ascii?Q?XxPtwBevKgLDZHvjqKjX0axumg0oKmezjcG2GvP8bl8eM1pwlAAsyq7T/yQx?=
 =?us-ascii?Q?Of3HKQHpVObuGueQcGOGAz7XxZ9YTLjmGZIGF66369098WQUndh9wi7ZGQvN?=
 =?us-ascii?Q?As3BArjEZNo7aSXQSa7UI+ZyFnwIY3PEztfgC+hC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acdb766-2bea-4aa6-fd99-08db05ea6827
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:27:33.2400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXDPiYWiC0tPO0QgEh4lendhAqS4Dz1l2xL9B8V8FCJU9eqrzJeQLSAdDt3uO1fYP43kIiuaGA/sqiLxXWxfsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
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

- 3 new netlink messages:
  * ULP_DDP_GET: returns a bitset of supported and active capabilities
  * ULP_DDP_SET: tries to activate requested bitset and returns results
  * ULP_DDP_NTF: notification for capabilities change

Rename and export bitset_policy for use in ulp_ddp.c.

ULP DDP capabilities handling is similar to netdev features
handling.

If a ULP_DDP_GET message has requested statistics via the
ETHTOOL_FLAG_STATS header flag, then statistics are returned to
userspace.

  ULP_DDP_GET request: (header only)
  ULP_DDP_GET reply:

      HW             (bitset)
      ACTIVE         (bitset)
      STATS          (nest, optional)
          STATS_xxxx (u64)
          ....

  ULP_DDP_SET request:
      WANTED         (bitset)
  ULP_DDP_SET reply:
      WANTED         (bitset)
      ACTIVE         (bitset)

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/uapi/linux/ethtool_netlink.h |  18 ++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/bitset.c                 |  20 +-
 net/ethtool/netlink.c                |  20 ++
 net/ethtool/netlink.h                |   4 +
 net/ethtool/ulp_ddp.c                | 316 +++++++++++++++++++++++++++
 6 files changed, 369 insertions(+), 11 deletions(-)
 create mode 100644 net/ethtool/ulp_ddp.c

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 1722581b2db6..f6bac0ae15f6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -57,6 +57,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_STATUS,
 	ETHTOOL_MSG_MM_GET,
 	ETHTOOL_MSG_MM_SET,
+	ETHTOOL_MSG_ULP_DDP_GET,
+	ETHTOOL_MSG_ULP_DDP_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -109,6 +111,9 @@ enum {
 	ETHTOOL_MSG_PLCA_NTF,
 	ETHTOOL_MSG_MM_GET_REPLY,
 	ETHTOOL_MSG_MM_NTF,
+	ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_SET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -974,6 +979,19 @@ enum {
 
 /* ULP DDP */
 
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
 enum {
 	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
 	ETHTOOL_A_ULP_DDP_STATS_PAD,
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 504f954a1b28..a2fdc5ed7655 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
-		   module.o pse-pd.o plca.o mm.o
+		   module.o pse-pd.o plca.o ulp_ddp.o
diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index 0515d6604b3b..1bef91fcce4b 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -302,7 +302,7 @@ int ethnl_put_bitset32(struct sk_buff *skb, int attrtype, const u32 *val,
 	return -EMSGSIZE;
 }
 
-static const struct nla_policy bitset_policy[] = {
+const struct nla_policy ethnl_bitset_policy[] = {
 	[ETHTOOL_A_BITSET_NOMASK]	= { .type = NLA_FLAG },
 	[ETHTOOL_A_BITSET_SIZE]		= NLA_POLICY_MAX(NLA_U32,
 							 ETHNL_MAX_BITSET_SIZE),
@@ -327,11 +327,11 @@ static const struct nla_policy bit_policy[] = {
  */
 int ethnl_bitset_is_compact(const struct nlattr *bitset, bool *compact)
 {
-	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
+	struct nlattr *tb[ARRAY_SIZE(ethnl_bitset_policy)];
 	int ret;
 
-	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, bitset,
-			       bitset_policy, NULL);
+	ret = nla_parse_nested(tb, ARRAY_SIZE(ethnl_bitset_policy) - 1, bitset,
+			       ethnl_bitset_policy, NULL);
 	if (ret < 0)
 		return ret;
 
@@ -553,15 +553,15 @@ int ethnl_update_bitset32(u32 *bitmap, unsigned int nbits,
 			  const struct nlattr *attr, ethnl_string_array_t names,
 			  struct netlink_ext_ack *extack, bool *mod)
 {
-	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
+	struct nlattr *tb[ARRAY_SIZE(ethnl_bitset_policy)];
 	unsigned int change_bits;
 	bool no_mask;
 	int ret;
 
 	if (!attr)
 		return 0;
-	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, attr,
-			       bitset_policy, extack);
+	ret = nla_parse_nested(tb, ARRAY_SIZE(ethnl_bitset_policy) - 1, attr,
+			       ethnl_bitset_policy, extack);
 	if (ret < 0)
 		return ret;
 
@@ -606,7 +606,7 @@ int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
 		       ethnl_string_array_t names,
 		       struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[ARRAY_SIZE(bitset_policy)];
+	struct nlattr *tb[ARRAY_SIZE(ethnl_bitset_policy)];
 	const struct nlattr *bit_attr;
 	bool no_mask;
 	int rem;
@@ -614,8 +614,8 @@ int ethnl_parse_bitset(unsigned long *val, unsigned long *mask,
 
 	if (!attr)
 		return 0;
-	ret = nla_parse_nested(tb, ARRAY_SIZE(bitset_policy) - 1, attr,
-			       bitset_policy, extack);
+	ret = nla_parse_nested(tb, ARRAY_SIZE(ethnl_bitset_policy) - 1, attr,
+			       ethnl_bitset_policy, extack);
 	if (ret < 0)
 		return ret;
 	no_mask = tb[ETHTOOL_A_BITSET_NOMASK];
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 08120095cc68..33f1b0992383 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -306,6 +306,8 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
 	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
 	[ETHTOOL_MSG_MM_SET]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_GET]	= &ethnl_ulp_ddp_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_SET]	= &ethnl_ulp_ddp_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -669,6 +671,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PLCA_NTF]		= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_NTF]	= &ethnl_ulp_ddp_request_ops,
 };
 
 /* default notification handler */
@@ -764,6 +767,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PLCA_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_ULP_DDP_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1156,6 +1160,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_mm_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
 	},
+	{
+		.cmd    = ETHTOOL_MSG_ULP_DDP_GET,
+		.doit   = ethnl_default_doit,
+		.start  = ethnl_default_start,
+		.dumpit = ethnl_default_dumpit,
+		.done   = ethnl_default_done,
+		.policy = ethnl_ulp_ddp_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_ULP_DDP_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_default_set_doit,
+		.policy = ethnl_ulp_ddp_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index ae0732460e88..4852f567c0be 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -395,10 +395,12 @@ extern const struct ethnl_request_ops ethnl_rss_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
 extern const struct ethnl_request_ops ethnl_mm_request_ops;
+extern const struct ethnl_request_ops ethnl_ulp_ddp_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_strset_get_policy[ETHTOOL_A_STRSET_COUNTS_ONLY + 1];
+extern const struct nla_policy ethnl_bitset_policy[ETHTOOL_A_BITSET_MASK + 1];
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINFO_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMODES_HEADER + 1];
@@ -441,6 +443,8 @@ extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1]
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
 extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
+extern const struct nla_policy ethnl_ulp_ddp_get_policy[ETHTOOL_A_ULP_DDP_HEADER + 1];
+extern const struct nla_policy ethnl_ulp_ddp_set_policy[ETHTOOL_A_ULP_DDP_WANTED + 1];
 
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/ulp_ddp.c b/net/ethtool/ulp_ddp.c
new file mode 100644
index 000000000000..e5451689fef9
--- /dev/null
+++ b/net/ethtool/ulp_ddp.c
@@ -0,0 +1,316 @@
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
+#include <net/ulp_ddp.h>
+
+#define ETHTOOL_ULP_DDP_STATS_CNT \
+	(__ETHTOOL_A_ULP_DDP_STATS_CNT - (ETHTOOL_A_ULP_DDP_STATS_PAD + 1))
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
+static const struct ulp_ddp_dev_ops *netdev_ulp_ddp_ops(struct net_device *dev)
+{
+#ifdef CONFIG_ULP_DDP
+	return dev->netdev_ops->ulp_ddp_ops;
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
+	struct ethtool_ulp_ddp_stats stats;
+};
+
+#define ULP_DDP_REPDATA(__reply_base) \
+	container_of(__reply_base, struct ulp_ddp_reply_data, base)
+
+const struct nla_policy ethnl_ulp_ddp_get_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+static int ulp_ddp_put_stats64(struct sk_buff *skb, int attrtype, const u64 *val,
+			       unsigned int count)
+{
+	struct nlattr *nest;
+	unsigned int i, attr;
+
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	/* skip attributes unspec & pad */
+	attr = ETHTOOL_A_ULP_DDP_STATS_PAD + 1;
+	for (i = 0 ; i < count; i++, attr++)
+		if (nla_put_u64_64bit(skb, attr, val[i], ETHTOOL_A_ULP_DDP_STATS_PAD))
+			goto nla_put_failure;
+
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
+	const struct ulp_ddp_dev_ops *ops = netdev_ulp_ddp_ops(reply_base->dev);
+	struct ulp_ddp_netdev_caps *caps = netdev_ulp_ddp_caps(reply_base->dev);
+	struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+
+	if (!caps || !ops)
+		return -EOPNOTSUPP;
+
+	bitmap_copy(data->hw, caps->hw, ULP_DDP_C_COUNT);
+	bitmap_copy(data->active, caps->active, ULP_DDP_C_COUNT);
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		if (!ops->get_stats)
+			return -EOPNOTSUPP;
+		ops->get_stats(reply_base->dev, &data->stats);
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
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset_size(data->active, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		len += nla_total_size_64bit(sizeof(u64)) * ETHTOOL_ULP_DDP_STATS_CNT;
+		len += nla_total_size(0); /* nest */
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
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_ACTIVE, data->active,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		ret = ulp_ddp_put_stats64(skb, ETHTOOL_A_ULP_DDP_STATS,
+					  (u64 *)&data->stats,
+					  ETHTOOL_ULP_DDP_STATS_CNT);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+/* ULP_DDP_SET */
+
+const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_ULP_DDP_WANTED] = NLA_POLICY_NESTED(ethnl_bitset_policy),
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
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+	ret = ethnl_bitset_size(active, active_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_ULP_DDP_SET_REPLY,
+				ETHTOOL_A_ULP_DDP_HEADER, info,
+				&reply_payload);
+	if (!rskb) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_WANTED, wanted,
+			       wanted_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_ACTIVE, active,
+			       active_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
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
+static int ulp_ddp_set_validate(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	const struct ulp_ddp_dev_ops *ops;
+
+	if (GENL_REQ_ATTR_CHECK(info, ETHTOOL_A_ULP_DDP_WANTED))
+		return -EINVAL;
+
+	ops = netdev_ulp_ddp_ops(req_info->dev);
+	if (!ops || !ops->set_caps || !netdev_ulp_ddp_caps(req_info->dev))
+		return -EOPNOTSUPP;
+
+	return 1;
+}
+
+static int ulp_ddp_set(struct ethnl_req_info *req_info, struct genl_info *info)
+{
+	DECLARE_BITMAP(old_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(new_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_wanted, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_mask, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(all_bits, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(tmp, ULP_DDP_C_COUNT);
+	const struct ulp_ddp_dev_ops *ops;
+	struct ulp_ddp_netdev_caps *caps;
+	int ret;
+
+	caps = netdev_ulp_ddp_caps(req_info->dev);
+	ops = netdev_ulp_ddp_ops(req_info->dev);
+	ret = ethnl_parse_bitset(req_wanted, req_mask, ULP_DDP_C_COUNT,
+				 info->attrs[ETHTOOL_A_ULP_DDP_WANTED],
+				 ulp_ddp_caps_names, info->extack);
+	if (ret < 0)
+		return ret;
+
+	/* if (req_mask & ~all_bits) */
+	bitmap_fill(all_bits, ULP_DDP_C_COUNT);
+	bitmap_andnot(tmp, req_mask, all_bits, ULP_DDP_C_COUNT);
+	if (!bitmap_empty(tmp, ULP_DDP_C_COUNT))
+		return -EINVAL;
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
+		ret = ops->set_caps(req_info->dev, new_active, info->extack);
+		if (ret < 0)
+			return ret;
+		bitmap_copy(new_active, caps->active, ULP_DDP_C_COUNT);
+	}
+
+	if (!(req_info->flags & ETHTOOL_FLAG_OMIT_REPLY)) {
+		bool compact = req_info->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+		DECLARE_BITMAP(wanted_diff_mask, ULP_DDP_C_COUNT);
+		DECLARE_BITMAP(active_diff_mask, ULP_DDP_C_COUNT);
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
+		ret = ulp_ddp_send_reply(req_info->dev, info,
+					 req_wanted, wanted_diff_mask,
+					 new_active, active_diff_mask,
+					 compact);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* return 1 to notify */
+	return bitmap_equal(old_active, new_active, ULP_DDP_C_COUNT);
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
+
+	.set_validate		= ulp_ddp_set_validate,
+	.set			= ulp_ddp_set,
+	.set_ntf_cmd		= ETHTOOL_MSG_ULP_DDP_NTF,
+};
-- 
2.31.1

