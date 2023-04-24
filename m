Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584536ED221
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjDXQKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjDXQKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:10:33 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44C46587
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gO55Q0X3zrzTx2SjTUPSpMpmZ1/CKqj6B2Hb9FUy9OHisordsr5D0TiuVdbkrcLPXpn6f0sCPuF+g/2zPl9WIJIZ8CPgksW/TBpRrIvkam8JdO19qKh0gvjPYrZIkOidS6BvbYAK7XEZ2sWO5/NIQIwwseuUEDNzMKOtM+NNcYGUyh2p9h4N4tBRYT4raVb8NrxJZxuruuL3LExPQvjTT5W5WBqtWmpAQ3s28MDs5TylhA2b+86I/xHJndZWwvcGs6MBsCFtZ4JD1N7fF99u/z9VPyzu6Xh/Ph4vwsyIvidK2wCGyK5YRPwjUXMf+HVIEuMacZslrgDK8O3z16pjZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N65Yd5NX/3sphoI/ptrZPQ1bAkcKJ+D9jifzqG3hSFA=;
 b=KvpDCrHfvlbIG2WvBiKETbgJ1CS280zlXdtyICX/S2QrBr6p9+gL23i0DligeQwbgw4rc3gZizXcdkeZLO92JJLK1HDLLBd4Jc3nr92NELmTg/1Z/Zo6LYndq1j4HK1Exp1Iq/T+Ifh/r20Of8NiPsDjDRnOQi8BNcT1JVLRDZOYwL2DLTLP/dtU6UBa+41ZbVQLO9C6cqopgWBusXRfn+BHD5UN0eSp9ji3AqSGeXDEwSWhwajYKXD1H2YtM1jrRbN1a041ued5nMFIwEKfogC6dc57Em8RFxyth4JiZw02vX/adfAS18Q3lIcZTEwvFopVkmahJZrnbCw+yYYcPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N65Yd5NX/3sphoI/ptrZPQ1bAkcKJ+D9jifzqG3hSFA=;
 b=BDpaQMhAOo1/wgRZkdjruUJ5a2XoC6Z/AgP0Itk1luX09Fm+sIifOAR+Dat6R+kGBZf6ZwDsqFAjSplQW2pNXNCNBt+WzPFzlrB/5iSodsHRYMf5/sab8QiBn/Ks4lbjTr+A1nv4/JhaY4ui8YLkAywC0PLwJAxeEWmMaX0mqjZGCzA0dKPCpc/Lkts35oQKt32I0OmALBXmBWzn1sNNEs+7i+h5Pd041n9DPFbdPZ8kBG3R6tYalkJgEr4PJD5rCATFvVWHKq9bEVtqoKCoBvAMmIfRtYknLSjcQ9ioHTBIzCORiWBbjyaKkZnzMLS/OyOyHVbJI9P2W1p7cxpXdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:10:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 16:10:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        liuhangbin@gmail.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 1/2] bridge: vlan: Add support for neigh_suppress option
Date:   Mon, 24 Apr 2023 19:09:50 +0300
Message-Id: <20230424160951.232878-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424160951.232878-1-idosch@nvidia.com>
References: <20230424160951.232878-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0449.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: b2535c58-12e4-465f-9891-08db44de6971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: krkOfWfkZQIZGV4syN/mb1vPchDbfpXEPs2+dbOCV9DFxVtTVcgPSOxWkKJ6Q7GYwyWScd6TOPlBkkl1nOvrqZfpbI+pG5YJVgt2dHa70y/b/U8/7kUNeCklyBihi5f24AFJOc1f49Jm7xqvGhPfDIjNOeddcnTe90OvCEeZjgYQXQvSvHJ5cjV1gDNgpS+ImGJJZjnkj+4L1df//w/YmYgVheDb6WP33iv8svn5W/RiY3P4Qgjrgd+TfdBLG+8BYz8Wlmy/JEIHGtoLmxhurHxpeku5Kj1o3UyQVK0JVXEyl5ksm4ujmncXQlMGMQz49XQoo/IyjzsbcY426dYcaaUgP05h2U4k1PDpIvhswMiUIXFedqxwpvh9r3h8iG33ghQnoHZgfKbVdPdzvI4akrMml7Mx2WRbbOPTk6eD27FSanKgmX6uhe7lWgGgvgzRvguium99JJelEj2anMdgNMUKYkntmpcD8uVvvDlAPp9yunn+2F0eElbbjBkhn+3kF5N/fkWbaP6/LlZd8krVu/L5Pr7KAxxR85pylX5FD70+JikSTedjNaA7xiFvBGzn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(36756003)(478600001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(2906002)(8936002)(8676002)(5660300002)(38100700002)(2616005)(6512007)(6506007)(1076003)(26005)(86362001)(186003)(107886003)(6666004)(83380400001)(66574015)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5UsSrVPGDbGV89rqxLVGJm6opYpxzy0ortDH/htlotyYCTNjhb0Y6CDV/3V?=
 =?us-ascii?Q?iNGgLRJlC3HB14aV5HN9y1zR8JEDMm6yJpzrOopzgukMgln9/Aw1I7Vx4uKg?=
 =?us-ascii?Q?CuZ6nu+rlSMQLSmi1bPBJUjuI9cwAQYKo293Ku1vHQ0Ic7gTId0GvjuPnyek?=
 =?us-ascii?Q?fr550kSWAPra0mqYLwv/t6YS8NE3dvG3VFMXFcLE/z2pf58XZ+KMDKb/K7j7?=
 =?us-ascii?Q?4l0wLHSm5qVI7iN0yG4Pv7+nuCBImYNxF8NSSeX++/TIvtXGOvPTxLLzd6ay?=
 =?us-ascii?Q?unDHzNwvynnMrADmr15HSknAvOJIIyf+Pat+3pq5fLFgqliBfQN8sl7CSOmr?=
 =?us-ascii?Q?q+FoYhpDad812g3Qpn9CUEsS6L6NlPa8uel6h0Uy1lb4HeMyJPSRKt3MtSHm?=
 =?us-ascii?Q?d3/+s1s0TKbcFPRhrSabgUXIu/HninlZLm+gedkb+3evJgqiDXzBEKj7XSHH?=
 =?us-ascii?Q?8TgMfe6/NEgEekgXVnCu7rEcFmyAbuo5BfcEIPtyQlfbpzxAilwJg2mdlq4S?=
 =?us-ascii?Q?RBi5PMRH+HPULbZa4r54gCbx7MBuQYATCS4rg82I4KAE+it9KGlvCvRkCKv/?=
 =?us-ascii?Q?VnvQgdGobJS1URLxKPzhwsWjJAPsNhJ7PAcLjhKRcbVoj9HFQA5xykt3ySav?=
 =?us-ascii?Q?qW9GXUKpA6QNY73VydZ6jsP+D690CVMMTaTWLeKImVpAIhurFs/yKesZYFhL?=
 =?us-ascii?Q?s7JyFqbKG5KRQlPOmCUnxRot4HnsaXCMzfwYHyHzi2fqA0j9R4mG7OkO+dxq?=
 =?us-ascii?Q?jHc+Sfb8ABQYYiG98mZzs9HgIDJ9Va+4JvVYZZdFtujkNw/NK1d6WQC0HJY5?=
 =?us-ascii?Q?IobI+wX3bbkIWs2mjNrhsKqzdY3J9XABqO6KLtUWoc5M+3Ch1Wem1AhQPo9x?=
 =?us-ascii?Q?O4uazYhyVvAInKTgcDniWgRIgrvhX/8nt6vfq+CUSxCMREFLZvU8iQkc54u9?=
 =?us-ascii?Q?Lk3nbFA1pdSUAMjS8San30UkpqIRGZLgQRLc2JQdwLCegB2WdT+9nxJFjtwn?=
 =?us-ascii?Q?SHF3yY6+3m42UkfA5nbF05xV0FFxvPSMZ8HKj/3obCTZeG2Ze+XR0MEu/r9W?=
 =?us-ascii?Q?CfMPq3hGXdLHEwO29yntlACnmzi59+gzEgqsgQ3it6l2MaM0xp67vtsCJVL5?=
 =?us-ascii?Q?FO8nR41S+/bRpc3pMpaXYzPWul1JSwyK/Ms1odGbZG20DPLFIU5KCQkP0f3T?=
 =?us-ascii?Q?+xufuPCUm7FUW7qfU9fUx0ydFbV+HhYQ289Od4pBqBEy++xd3WKArnxHdPdc?=
 =?us-ascii?Q?8ljqhDSOHjau4RSnwRjkbDspAKZkQ96tq9yxZztTXdpsrj6mDf9u2FfTsh8v?=
 =?us-ascii?Q?7nONilAoTN0kVHWee7TAJVS5oUvUUf26bmiQTk4ALaTWJ/hyy8YyqsCnIN2w?=
 =?us-ascii?Q?k2uGcTE6lbAWLim6SFIOi8uI9RJlbReQtPo3lV5CglylhyHSBamXzS8EIv5y?=
 =?us-ascii?Q?u72Lpdxv3IpwKad4bglUgAHmGBrpBVhoOUsNGJM8bFYOyoVl8APWby7NTuQW?=
 =?us-ascii?Q?nG1JR1Ymh92UvLpzTaeJVSSMf/9GZ2Z9gtBAh7voMe+KUL5j0Eto1WI5ZtlS?=
 =?us-ascii?Q?stcj16ybGTq461VsRBUSGrg9UPA6oHa1vNcSKKdl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2535c58-12e4-465f-9891-08db44de6971
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:10:24.6720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iaFV0baSSnSq3veQnrGFk/PAPlxURwWcXBjNP/pNDYSjrZfpBfZOKDtGvR6QMEb4QWXCvqjBH77kTu0qOrtPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the per-VLAN neigh_suppress option. Example:

 # bridge vlan set vid 10 dev swp1 neigh_suppress on
 # bridge -d -j -p vlan show dev swp1 vid 10
 [ {
         "ifname": "swp1",
         "vlans": [ {
                 "vlan": 10,
                 "state": "forwarding",
                 "mcast_router": 1,
                 "neigh_suppress": true
             } ]
     } ]
 # bridge -d vlan show dev swp1 vid 10
 port              vlan-id
 swp1              10
                     state forwarding mcast_router 1 neigh_suppress on

 # bridge vlan set vid 10 dev swp1 neigh_suppress off
 # bridge -d -j -p vlan show dev swp1 vid 10
 [ {
         "ifname": "swp1",
         "vlans": [ {
                 "vlan": 10,
                 "state": "forwarding",
                 "mcast_router": 1,
                 "neigh_suppress": false
             } ]
     } ]
 # bridge -d vlan show dev swp1 vid 10
 port              vlan-id
 swp1              10
                     state forwarding mcast_router 1 neigh_suppress off

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/vlan.c     | 18 ++++++++++++++++++
 man/man8/bridge.8 | 11 ++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 44e1ba39f01d..5b304ea94224 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -38,6 +38,7 @@ static void usage(void)
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"                                               [ mcast_router MULTICAST_ROUTER ]\n"
 		"                                               [ mcast_max_groups MAX_GROUPS ]\n"
+		"                                               [ neigh_suppress {on | off} ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
@@ -354,6 +355,18 @@ static int vlan_option_set(int argc, char **argv)
 			addattr32(&req.n, sizeof(req),
 				  BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
 				  max_groups);
+		} else if (strcmp(*argv, "neigh_suppress") == 0) {
+			bool neigh_suppress;
+			int ret;
+
+			NEXT_ARG();
+			neigh_suppress = parse_on_off("neigh_suppress", *argv,
+						      &ret);
+			if (ret)
+				return ret;
+			addattr8(&req.n, sizeof(req),
+				 BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS,
+				 neigh_suppress);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -1041,6 +1054,11 @@ static void print_vlan_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_max_groups", "mcast_max_groups %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS];
+		print_on_off(PRINT_ANY, "neigh_suppress", "neigh_suppress %s ",
+			     rta_getattr_u8(vattr));
+	}
 	print_nl();
 	if (show_stats)
 		__print_one_vlan_stats(&vstats);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 4006ad23ea74..3bda6dbd61d0 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -184,7 +184,8 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_max_groups
 .IR MAX_GROUPS " ] [ "
 .B mcast_router
-.IR MULTICAST_ROUTER " ]"
+.IR MULTICAST_ROUTER " ] [ "
+.BR neigh_suppress " { " on " | " off " } ]"
 
 .ti -8
 .BR "bridge vlan" " [ " show " | " tunnelshow " ] [ "
@@ -1204,6 +1205,14 @@ may be either
 enable multicast traffic forwarding. This mode is available only for ports.
 .sp
 
+.TP
+.BR "neigh_suppress on " or " neigh_suppress off "
+Controls whether neigh discovery (arp and nd) proxy and suppression is enabled
+for a given VLAN on a given port. By default this flag is off.
+
+Note that this option only takes effect when \fBbridge link\fR option
+\fBneigh_vlan_suppress\fR is enabled for a given port.
+
 .SS bridge vlan show - list vlan configuration.
 
 This command displays the current VLAN filter table.
-- 
2.40.0

