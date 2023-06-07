Return-Path: <netdev+bounces-8922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B417264CA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84B021C20E06
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7F6370DB;
	Wed,  7 Jun 2023 15:37:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A3A34D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:37:32 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721D8125
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZkqMnF3H108zy20XCBDlmPVKT9bf4TJKdDiOZpkmBYqthkSb6+BvHXvTgqjHoUa6ezxe90uCzdPK07jNlqLpD8m2xRUDq0WdlicgqIEwQmKSpns1ER7P9pm6vnl0dcno6GN7gXo84BLCIcY8S6RL3CQoKmmf9Zp0D2hvG2NrbHNEQ89ZeotMnwt20Y/Z6v8srgtWC03quWAgRFJxp8BAMdrCBnRj9kv7iMNntNZC1hKxouZJGztBmGw+VutlitC1r646BKlM9QpYFYdqz8IlZq2fg1iK6HTAlbNFt69FHcjxjt1OECCCsUFABLZEb7EFh/LTsq4Mpn1lYeWq5yCOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYKof1jr9XN+Zhvk1p7yHKVn/uOcreVze/0mFvuRYT0=;
 b=ENP9wFBpwgwRloVodV2qpyuyPdKyEedvpgubD8od7FM0k7hGtqlSW6vaz7vY+XLTn7ofAfpEBt/CLgNnLbpb5rb+EPVT6Jj/ag+SOesKHh/XVVRyocz2VXNaL93m1iNqpGNISIT1xjgzXBfaXiqviUXITb23eGW9vNXzCNN98wDKqmGfcCiBzN1dKQXhXH/Ney/DbymayeJLyjkVoUBQJi2KnAxvkeWUrY7FHdUwwIMZvIKxhRiTaCSrmsqLPdYt2X2c3bSGcI5wwFd7Mxm49LR7bu5G1tSjX+NJICSrAcEYHMdHLTqtzOH67LPDCVJN2WvpEEm3qeGIoaDFEEIumg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYKof1jr9XN+Zhvk1p7yHKVn/uOcreVze/0mFvuRYT0=;
 b=Y8Ad3O0qp/M3l/W++4kP78JeGg7l6jAgIpVwK3+rSqNfABlMf+oOzu2Sdod+ZvHV/j75ryleBrDDV4tWN2ajR/iBSzT97HaUXzsX8CwqrKDr8ISsz8DoRrYqfm95frLFiaBKpEs8Xu8M7LSK7bnaxYFM1QCbrN5Y+vFwjEeWyd4YS4noG9kc/Tp3s920aHYu6rMuurStzZrJtCkAbuYN+aq61KM6XZ9OpAfL5SCUJS6oPjaIK+J1plSdngRsBk0ygm3sM5dLOKjlk3F8/gbVL0hY9yrSRpjdqzEZ/KfJhyHu8Y1+VUV69k5jXZrgcMW1JTw5EqVCZgpOYx9wz7b4ew==
Received: from PH0PR07CA0044.namprd07.prod.outlook.com (2603:10b6:510:e::19)
 by PH8PR12MB7423.namprd12.prod.outlook.com (2603:10b6:510:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:37:27 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:510:e:cafe::a9) by PH0PR07CA0044.outlook.office365.com
 (2603:10b6:510:e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19 via Frontend
 Transport; Wed, 7 Jun 2023 15:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Wed, 7 Jun 2023 15:37:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 7 Jun 2023
 08:37:14 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 7 Jun 2023 08:37:12 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@gmail.com>, <stephen@networkplumber.org>, <jiri@nvidia.com>,
	<razor@blackwall.org>, <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next] f_flower: Add l2_miss support
Date: Wed, 7 Jun 2023 18:35:50 +0300
Message-ID: <20230607153550.3829340-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|PH8PR12MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 561f04da-2f48-4c1b-ccbc-08db676d18f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4mCA4rBTuenOZO3IB+okofLa3ZvtDSKwHvjutjjpe/2Cwt9AX8mPCWsTe6Kn6cs/AuioxJvCCPbf0J0T+nFMufB+Saz9+e5hnJjtiwSwPoy8wEnivyxxhNBBwL82LFkqTWiLB+PoslQy5qN2RtHEQMXcamxVFXfdmlxC6TvHbcN7lVzjmIhtH0gfkpqc3erqZiPCLLw5VxZiJqu86uNxGO7Tkgne1EI8TisFzRGXGHMWeAgc7t+A0O9vdLk2/31zrUuk1s7zeZZtwbBmCMeb0gETZ2eN6yoz7tXUo+/G+bNcvj3Jp9talcwog68XErQi6gosCZRQu3DduWL8k/8tzYmbTeDjb1QjGDZBza7Oi+NWXmnPaXi5ntC/Ixw0p8iBPYK6JkUOOo88UXyUVq0eJEzLN271Bx6vevTC/auon89r7F9x9YEb90YCJYWB94MMmDehiYWRiWGxoVDweFbepBAlkKQD6hecXyLIX5AFFPadhnzNjTkQrC1fYE9J0asgLpnuOUaTHDHmAvTT8YJo7AvH0KuJsO5otak7MAr1uid1lvT0TRsew8AJrygqupbSO+JDSq9SRRWwuytWDfLhCSJT3+9woimXcEcSktgj4Pyp2x3VHMut7OD3zeCYXRS0c4agtlnNNxdiWX3nOLCSyQw6S4OF747aJIg51FuOK/o2EQ9BNK+W44zfGNsGcx9W+Th90BUeXjICHvNkTsUaAXe8pTvb9zuUIciPy62zhrIZXpwMda3rQwrsxLnVs1O/
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199021)(36840700001)(40470700004)(46966006)(86362001)(47076005)(83380400001)(336012)(426003)(478600001)(40480700001)(82740400003)(40460700003)(8936002)(8676002)(316002)(41300700001)(356005)(54906003)(7636003)(70586007)(70206006)(6916009)(5660300002)(4326008)(6666004)(36756003)(2906002)(82310400005)(36860700001)(26005)(107886003)(186003)(16526019)(1076003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:37:26.9665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 561f04da-2f48-4c1b-ccbc-08db676d18f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the ability to match on packets that encountered a layer 2 miss in
bridge driver's FDB / MDB. Example:

 # tc filter add dev swp2 egress pref 1 proto all flower indev swp1 l2_miss 1 action drop
 # tc filter add dev swp2 egress pref 1 proto all flower indev swp1 l2_miss 0 action drop

 # tc filter show dev swp2 egress
 filter protocol all pref 1 flower chain 0
 filter protocol all pref 1 flower chain 0 handle 0x1
   indev swp1
   l2_miss 1
   not_in_hw
         action order 1: gact action drop
          random type none pass val 0
          index 1 ref 1 bind 1

 filter protocol all pref 1 flower chain 0 handle 0x2
   indev swp1
   l2_miss 0
   not_in_hw
         action order 1: gact action drop
          random type none pass val 0
          index 2 ref 1 bind 1

 # tc -j -p filter show dev swp2 egress
 [ {
         "protocol": "all",
         "pref": 1,
         "kind": "flower",
         "chain": 0
     },{
         "protocol": "all",
         "pref": 1,
         "kind": "flower",
         "chain": 0,
         "options": {
             "handle": 1,
             "indev": "swp1",
             "keys": {
                 "l2_miss": 1
             },
             "not_in_hw": true,
             "actions": [ {
 [...]
                 } ]
         }
     },{
         "protocol": "all",
         "pref": 1,
         "kind": "flower",
         "chain": 0,
         "options": {
             "handle": 2,
             "indev": "swp1",
             "keys": {
                 "l2_miss": 0
             },
             "not_in_hw": true,
             "actions": [ {
 [...]
                 } ]
         }
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Initially I used true / false instead of 1 / 0. If this patch is
accepted, I will adjust the kernel selftest accordingly.
---
 man/man8/tc-flower.8 | 10 +++++++++-
 tc/f_flower.c        | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index fc73da93c5c3..cd99745065cf 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -100,7 +100,9 @@ flower \- flow based traffic control filter
 }
 .IR OPTIONS " | "
 .BR ip_flags
-.IR IP_FLAGS " }"
+.IR IP_FLAGS " | "
+.B l2_miss
+.IR L2_MISS " }"
 
 .ti -8
 .IR LSE_LIST " := [ " LSE_LIST " ] " LSE
@@ -493,6 +495,12 @@ respectively. firstfrag and nofirstfrag can be used to further distinguish
 fragmented packet. firstfrag can be used to indicate the first fragmented
 packet. nofirstfrag can be used to indicates subsequent fragmented packets
 or non-fragmented packets.
+.TP
+.BI l2_miss " L2_MISS"
+Match on layer 2 miss in the bridge driver's FDB / MDB. \fIL2_MISS\fR may be 0
+or 1. When 1, match on packets that encountered a layer 2 miss. When 0, match
+on packets that were forwarded using an FDB / MDB entry. Note that broadcast
+packets do not encounter a miss since a lookup is not performed for them.
 .SH NOTES
 As stated above where applicable, matches of a certain layer implicitly depend
 on the matches of the next lower layer. Precisely, layer one and two matches
diff --git a/tc/f_flower.c b/tc/f_flower.c
index c73c46dd234b..f1a351fbaa03 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -91,6 +91,7 @@ static void explain(void)
 		"			erspan_opts MASKED-OPTIONS |\n"
 		"			gtp_opts MASKED-OPTIONS |\n"
 		"			ip_flags IP-FLAGS |\n"
+		"			l2_miss L2_MISS |\n"
 		"			enc_dst_port [ port_number ] |\n"
 		"			ct_state MASKED_CT_STATE |\n"
 		"			ct_label MASKED_CT_LABEL |\n"
@@ -1520,6 +1521,15 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "Illegal \"ip_flags\"\n");
 				return -1;
 			}
+		} else if (strcmp(*argv, "l2_miss") == 0) {
+			__u8 l2_miss;
+
+			NEXT_ARG();
+			if (get_u8(&l2_miss, *argv, 10)) {
+				fprintf(stderr, "Illegal \"l2_miss\"\n");
+				return -1;
+			}
+			addattr8(n, MAX_MSG, TCA_FLOWER_L2_MISS, l2_miss);
 		} else if (matches(*argv, "verbose") == 0) {
 			flags |= TCA_CLS_FLAGS_VERBOSE;
 		} else if (matches(*argv, "skip_hw") == 0) {
@@ -2983,6 +2993,14 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 				    tb[TCA_FLOWER_KEY_FLAGS],
 				    tb[TCA_FLOWER_KEY_FLAGS_MASK]);
 
+	if (tb[TCA_FLOWER_L2_MISS]) {
+		struct rtattr *attr = tb[TCA_FLOWER_L2_MISS];
+
+		print_nl();
+		print_uint(PRINT_ANY, "l2_miss", "  l2_miss %d",
+			   rta_getattr_u8(attr));
+	}
+
 	flower_print_ct_state(tb[TCA_FLOWER_KEY_CT_STATE],
 			      tb[TCA_FLOWER_KEY_CT_STATE_MASK]);
 	flower_print_ct_zone(tb[TCA_FLOWER_KEY_CT_ZONE],
-- 
2.40.1


