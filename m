Return-Path: <netdev+bounces-9176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B58C0727C50
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B1521C20F50
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97638BA26;
	Thu,  8 Jun 2023 10:07:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D829A945
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:07:00 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::627])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D592D65
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lg6kRWLjXYIEXlUtnIrmVOlzxHaR47rLRGZZrVGrR/JyThqR+daiSntJ4r4SwQXIANZxe5fsh4b6AS0dxOw8UOJUoAbLnw1R/1LmpOG58LfK+r+b5E8rbiBozApyOaAToqlNoyBctm8GKoxhqIZz8ixJo4v4K3q2votbUCovOwbZN8qO47zbC+/uNS3SQZHE8Pv/+NdXra3+CidEKuvO5hyARP4BpsX7nOLiDPzdB/EfU5mXD51KGT50Au7vywWKSyJSeU91wHGDFD6wT8tXYe8m8+b/WawK7YlFmOGsIpLXtrM8xjsi9Tti3WU6HD+99J0l34NFi+p82M01vrQtVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+msxoza05NmpAkVu86jFS6y82ULnUOG+WwooMrMCAg=;
 b=ZD7wrgqptGAmYNWu25USwbQnwO4WqD0s9Zr/zbn7DRtH+FxYDPQ9Gt3I0Y830A+XJtmTIU9RxHT/zhPuRw1nODIBBUv59r1ROiEXTPhRi/K5Djo2z5HUMRAWGyfEsS9+vs4O7vtJ4Q5C0iJGm4+Z5qfvI6EAF6tplpyPA4Q93KhIz6kINjtX5Y2HHbMzKOPeKHFaclts9CFLNJ+FDgENNhw+GSguxjgs6OY9G1YWhpVUiZCmd6NIqjiqqCD1tmmxrvRCKgtHwkDLrwhnrbYUZ29Aieo2lf1qOQt+A6HY8vZOnuIASSa9Sq9NNSIP31ntYLYV07vSTVUEF4E+u2t8BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+msxoza05NmpAkVu86jFS6y82ULnUOG+WwooMrMCAg=;
 b=l1+Cofchxv0SsGex/JQ+Cg63klGuQIn9u9CViJLTuVAD6rUPqY3400dzntF+sF53fLoz+YKmS6KQcU0lnkVqmGBMmSeOAjzgJA7Ot409NnL462KRcft3BFuA5Lny024CWblS2+ydqSs4OTzkXNzWggzhhEv71hmkxFZa148BHKx+kNQR2iR3cBLiZUObXTAjuF8KVRmdZloKR5Zhgcay9aWw2fzZyntTKiW2kG9A6DZXIfX32SSiELBcBpA44gtu4mm/jGcLMMUaMqtpEyb9YejBDPb6Jn/uN24U7oIO3uUWe5LqBZDt4x78r9KCqF37EXrVaATF1j0qajVs+QEvfA==
Received: from BN9PR03CA0122.namprd03.prod.outlook.com (2603:10b6:408:fe::7)
 by SJ0PR12MB8116.namprd12.prod.outlook.com (2603:10b6:a03:4ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Thu, 8 Jun
 2023 10:06:15 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c8) by BN9PR03CA0122.outlook.office365.com
 (2603:10b6:408:fe::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Thu, 8 Jun 2023 10:06:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.24 via Frontend Transport; Thu, 8 Jun 2023 10:06:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 8 Jun 2023
 03:06:04 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 8 Jun 2023 03:06:01 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@gmail.com>, <stephen@networkplumber.org>, <jiri@nvidia.com>,
	<razor@blackwall.org>, <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next v2] f_flower: Add l2_miss support
Date: Thu, 8 Jun 2023 13:05:32 +0300
Message-ID: <20230608100532.4146080-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT037:EE_|SJ0PR12MB8116:EE_
X-MS-Office365-Filtering-Correlation-Id: 48db1af5-30fd-4284-1e02-08db6807fed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oSX/2SqFo2Q0r/sG8U8QmM5FAC1W3VIPIxwA/AwJtiBTGooho8Ut5HLVLu49pHhcMAEwn74EUJWfD8Oaqy7Mne5CdkRSOjADkDgHKG3rAdGFWtjx/5gHVsA7uHF+6NfyT8Hzv+thR12bre4wlgBKY4yIPO1Gdl0BWxZlqQaMSUysS7ieHfRxtkIyuURMvmsq+KsuP91npPx7VxPMhCA2R74hX0xW73Bf63nyXG0oaYLENifBfbCMLjicF2vj4S//P4Zud3W0V4L4/7NK5uEO1jTnkdWm6u1sTl/UbrqP/TgecZEUDyj1TqjQh5k5Cip1w/jCkT4OI7L0ioncR5Y+mt3ecjWITOpuJitUf09ZXwk/nw+8fMD3hb64yhO0cNTB43mhriz0l93FzFMKJDEQUWDuhkP7LLy0OAwZzlCLgWV4wQwLDvugc1t9OyuZ9SnzLKE1xcWkDx/EwStNIs/OrZyR+j1rkg2qSsqMwwxDgJN4HuqvJdb1VdQOW+zqYsGNvlUOV9uMn8HYWncn2Pf0YcFSTwS0sUGiLdHobdYCobPtUOqlz48o5JxAxtaAbAqoN3NixGHmdmXx8pz1B4WEHceq9sfff3whTZsOuQGYLReBYyASTHz05rzaFuVvHq/zWSP/UWyWjsZ9+9JflsA0XIpAJ781R+yS+QzKToF1aERfPR4LMXEYAzr84R+9H+WXVTjSumFiTKckdBldhpLD08+xNRceybUPXzvZZZHCtDzIf5TJF2tOBNLgQMkZWpXK
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199021)(46966006)(40470700004)(36840700001)(47076005)(26005)(1076003)(2616005)(6916009)(356005)(40480700001)(7636003)(316002)(83380400001)(70206006)(70586007)(4326008)(16526019)(6666004)(107886003)(186003)(36860700001)(336012)(426003)(82310400005)(54906003)(478600001)(36756003)(40460700003)(2906002)(5660300002)(8936002)(8676002)(82740400003)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:06:15.0687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48db1af5-30fd-4284-1e02-08db6807fed6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
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

Notes:
    v2:
    * Use '%u' instead of '%d'.

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
index c73c46dd234b..b9fe6afb49b2 100644
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
+		print_uint(PRINT_ANY, "l2_miss", "  l2_miss %u",
+			   rta_getattr_u8(attr));
+	}
+
 	flower_print_ct_state(tb[TCA_FLOWER_KEY_CT_STATE],
 			      tb[TCA_FLOWER_KEY_CT_STATE_MASK]);
 	flower_print_ct_zone(tb[TCA_FLOWER_KEY_CT_ZONE],
-- 
2.40.1


