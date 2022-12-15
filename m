Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C8264E00D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiLORyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLORys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:54:48 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2049.outbound.protection.outlook.com [40.107.100.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988113721D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:54:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WotqNlk6ixRSXb0kgtQi/ykG0IuLYsFhfeXzbrpvmuRK7lVHYG8ryGzwwXS+ydT93PApiyWvB6dgFQXPrfMmtTdhoTqMKCRiImy0rhEJoeY24eQ6GvPo8soHPwJWYwKKDMUm7CdPbL83OqA7aVZVuSn4IVPsQqrJPysMVcj1rAVhUFcDdqMKjZq3FxU7Kv5BGysUKiQNbyJ88IThhdZJelFQTW2FY68uouLLltEYNfcfNmpOjeUiy3gbZId0gy7AaAf7CDIk2GbbQgEhp3SXaczlZbVGAfQRHWonBxCXe6UONFEEqXd5azFrJljgFVgij/2g/d345bHwoVrgG8Buaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejVH7+b/HEKF8/K8l7x6WM0jAgWho/vPW/cGsc4VCrc=;
 b=d3cnDM2gSjh4Rr2D16UZACJgswyRAspk0cjtBgDFn6plvdeN1eINECP9ZCWcLL3KnYfIPEW/tGjcIok9kZIJ4aObglt33biHZ3WnkbFc/Jt0u+OY3h4TWUmpIxbxOzjn4NrfDvtiG88HyPtwR4qgdoGIcuzGCPhDztiVi+h47zafhJQOTjaNr1dZ+hGks4f2+0e1NLLH+/caQ873M54m1/poUGu2wtLIcdNY0O0tWzR869uHWaQ8OLaSaEi6H3cNQ9fMlJgG/gAHKeXSgosEU2a7Xgm+RJ0rxFsfXfq+RtVKqWFxk6/+FGAuvcXoNXRE9twaOefhs+w7gsGpO+/d+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejVH7+b/HEKF8/K8l7x6WM0jAgWho/vPW/cGsc4VCrc=;
 b=beJXUpJJqLjfxT+MbfW8qFFTnKJUDN4twojvrp1O7m1GoUiYS7loE/zve2kp8Ge+oawughKSrMC+Y6MlalhuER38mw0PMhPHcm5mC4Nssw49Ji0aM30w6BXGoMQkYmNVMr+wIhn5m22tBM4kCNOaX+jGKWwi/D+A7M6ORTfil5qyoldF3c8blg08om+mFHaCpyDfdnniWVIlFqAEBlBNDQbEfHzakZE9FOHyjiv5CfwNDxR1nCHl+LTtcOxn6179jO4zvcGSqC2O/BnABl1LUEFRczY/6iVl7fHmIKK//5PJFNvfY5r7whQ/G0TKXh6XpkGOk2dbbfj+VRVuRfMgsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:54:45 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:54:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 3/6] bridge: mdb: Add filter mode support
Date:   Thu, 15 Dec 2022 19:52:27 +0200
Message-Id: <20221215175230.1907938-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0136.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: df1f86d0-f1fc-4d63-418e-08dadec5739b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGE8JAHHedVPRFp0XajH0JtAsxYIGav8DTiTf1baFg1eGu64hgmJZcWR4iW6VujI71rQ387wKDnc9DHZYSMvf4IHTO7RxbGF1YSYVP7pum7NbJEZTy+aI5dvR6199iCYaiSJqRoEKZyDnWBB2+qdjbCwygUvBl+9g6qca12HEQFy9eXnNina5FoFzqDchFG72SNi7KhYQiGW6lGLttgJHxxaMMdqakVkHW1k+Gb7dLzDZqnNlJCSO/53l03dpoh6OMm/hDMVrcEOnFhXxneq/tgbFelONCNV0cKM0xc7DLNAk9fnOLAyrStvHnSbNKLARPbQDWI1Jr1e9ygYAK2IMl92lMaDGoEmqXuT2TDLTDw/Z6w1WTXELngoXDqi+KUo5wqk0ZJEs/RQJWYM3l6frTwr53rYaW88mynJXL19yTQNo10gf5l2a8gU+voET4hbB8UU/Ixv06nZ3ZIME5lrjD+edVoHbP2vcjSdLR3/9t2yr5gTKjQwVlmHWyqDfBLqnAsnMcd0ig192eXJx4GSnEMSWwiyQVgjF79gEIoxJvCx8Z3yacpsqAJINB0gc8n6UAMiYj3LxmlQ2QlTUhlmqS27Li8Y2CKT6S2joMqo4jZeFk41NQwu4DbfLfiuCvyB95GEGOEvs1LR1sAsJFVvSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(8936002)(86362001)(8676002)(38100700002)(5660300002)(2906002)(66946007)(66476007)(4326008)(66556008)(41300700001)(6512007)(26005)(6506007)(107886003)(6666004)(186003)(2616005)(1076003)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OpFn9AG0Cq0YzI3HCDDsdh15q4bTfRwpZS/GeZ/SBkx8zGxjbaS94186ho4T?=
 =?us-ascii?Q?1GkZ1p2BK7hnuU3TVpITyFXL6QE/a+RnIShK43Hw9NF7N2fPghy7/uA7NY/f?=
 =?us-ascii?Q?kOcNFAgOGdkUG/4RSnz+49OOAY5WxCxGWdkgev1HU1KtnRrxZB2VPHR+7QJE?=
 =?us-ascii?Q?7xaMUlGcnIa0yVa52SlGiG1Wj5TP6WwQ1EbqRzhYMNhYE/eAlpMJIllQRWDT?=
 =?us-ascii?Q?Qp0YB4aXXX8X19CRZbWZ62La+fZPna7/wMGDfeVZJXCJHVXdkmX1TCwWXs4X?=
 =?us-ascii?Q?K4GLOFozKYOgCgCbPkrIMmRKmt17ob2kgRkCJzpTamqrKhLvsHjCdSecS1pd?=
 =?us-ascii?Q?NOinD2xLZFtDVPeLFvcWR0xVgk+1FEgxiq+9SX73Dws4oiNbDOyZ5lwzqlUB?=
 =?us-ascii?Q?+yRxRrkbnAgPRdhjp6jGyctlx/5w3SAGho1s9BPGQFWliuoKQZU4NSxLxJGf?=
 =?us-ascii?Q?eHjp96TLcakEB7tNsTny+Eq6wSBsapvuHGmcEwIv1ZPQwzG8S2CHsEq8GHWV?=
 =?us-ascii?Q?Rd+gkWiYYMcACly2hNNMXPxwxLmjlHPGl5/smYHq7A6cRX4Y00D73VmcvjTz?=
 =?us-ascii?Q?O5dRrqDKDqq8xEbEj32jxydyqOwUFU11KcZPgEANJbrlL9ArWEqYw4vO88b+?=
 =?us-ascii?Q?NrDdP8QA/LNJh1b5yKzB7l2XEYlxXlPTETZA9kMkirgLm5SnIISjxocFU4Rx?=
 =?us-ascii?Q?VWLpfc7B6vVF8dunP0Vtbs/Iynrt7PXOFERQ4LummGCoW6cO+rrB3qrg1JJH?=
 =?us-ascii?Q?dNbKVixlVjbGVUCFGRcHGM8FFq8mFA3tHMjJl/OKZuMqbz4Uu4AjRwxLBs2w?=
 =?us-ascii?Q?LQxhJrV8xeWXfVWds/z0jbCmiA2fC428FVsKSnxTXImg2JMhUOnV3WtvRXTv?=
 =?us-ascii?Q?OuJ7XR47K5AlMH8wmt5gsGJwwjPRAEbnbnXGx3U+aE4yIoPYDdp5VcIGAf06?=
 =?us-ascii?Q?4ghWGe8Eys146wUYiXOWlLBftDt8VWBkp6VtGHAHrSjt2XMuQoAZLRNVK3g9?=
 =?us-ascii?Q?Wm69eVbXsGmhp8OfGaBxWEqZru7NyOsH99ZzAPykmHAAHu+rFOY/HY9MgG/w?=
 =?us-ascii?Q?JK7yQljqzmJdsK1lwYTmPAlsbBG00P08XVlhvabkH3u67DzmFxQZPSMbtGrp?=
 =?us-ascii?Q?ES4RsBmkfnKNq+XwVflYdv2nRJkXL5cbUFg2MpxOAlJBdvnv5F+kzd+s2VR8?=
 =?us-ascii?Q?Ir5nFpAL6BrjnT/7FKgCyxsxx8jcSK4XDk9+Ay+8oDd7ocJHB4etESe3zK9o?=
 =?us-ascii?Q?HC4vwvB9ZEmHZTap/K8P8zIfWuFsVEGH36Yi3w34YX7ro3wNIVecpH6H851M?=
 =?us-ascii?Q?Qi2DdWdK9UCTtDKD/fbv0kVli4SM8nDDYa3yZXJzhqTX+QMwedtFy8boSnJr?=
 =?us-ascii?Q?lrEgKjRwr6AvJZyghzSkUkyElSTVvQ1fr2GzA7NbDY2mfCPvFcDWj84jC1s1?=
 =?us-ascii?Q?F92jaRgZy/onT8KmTz1otiq4GBP0MXNbUHHN5aes4JO1uLAmwz0VuB0thcwH?=
 =?us-ascii?Q?QU/vzc52V1mZRd6XmB4Av5RPnsEgy5Al7B9TgIgGxXDpPBjCyFDQf1wzLCVm?=
 =?us-ascii?Q?AV9N2xKefkfUMp3mDql/IgcSRO8IAxly6sW6Rqyg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1f86d0-f1fc-4d63-418e-08dadec5739b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:54:45.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Mxdjc8Oqm7EgB7xnTYfjr7t+3TjD1TsW9dbiH1rZ8NtvzKvaqCAyWBzM1TX0/si5WgRRh37B8oQjAGCdBCarw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user space to specify the filter mode of (*, G) entries by adding
the 'MDBE_ATTR_GROUP_MODE' attribute to the 'MDBA_SET_ENTRY_ATTRS' nest.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 27 ++++++++++++++++++++++++++-
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 64db2ee03c42..ceb8b25b37a5 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -32,6 +32,7 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
+		"              [ filter_mode { include | exclude } ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -493,6 +494,21 @@ static int mdb_parse_src(struct nlmsghdr *n, int maxlen, const char *src)
 	return -1;
 }
 
+static int mdb_parse_mode(struct nlmsghdr *n, int maxlen, const char *mode)
+{
+	if (strcmp(mode, "include") == 0) {
+		addattr8(n, maxlen, MDBE_ATTR_GROUP_MODE, MCAST_INCLUDE);
+		return 0;
+	}
+
+	if (strcmp(mode, "exclude") == 0) {
+		addattr8(n, maxlen, MDBE_ATTR_GROUP_MODE, MCAST_EXCLUDE);
+		return 0;
+	}
+
+	return -1;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -505,7 +521,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.bpm.family = PF_BRIDGE,
 	};
-	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL;
+	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
 	short vid = 0;
@@ -532,6 +548,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			src = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "filter_mode") == 0) {
+			NEXT_ARG();
+			mode = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -570,6 +590,11 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (mode && mdb_parse_mode(&req.n, sizeof(req), mode)) {
+			fprintf(stderr, "Invalid filter mode \"%s\"\n", mode);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index e72826d750ca..e829b9cb592a 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -138,7 +138,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR SOURCE " ] [ "
 .BR permanent " | " temp " ] [ "
 .B vid
-.IR VID " ] "
+.IR VID " ] [ "
+.BR filter_mode " { " include " | " exclude " } ] "
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -931,6 +932,11 @@ forwarding multicast traffic.
 .BI vid " VID"
 the VLAN ID which is known to have members of this multicast group.
 
+.TP
+.BR "filter_mode include " or " filter_mode exclude "
+controls whether the sources in the entry's source list are in INCLUDE or
+EXCLUDE mode. Can only be set for (*, G) entries.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

