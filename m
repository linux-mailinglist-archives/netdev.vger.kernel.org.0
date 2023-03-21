Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A078E6C3236
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCUNC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjCUNC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BA94D40A
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXta949xKUw4JCZxyZYlofMJRf/s/uPnXYeQ/DmWaPHExZplGUYGo6L3n1s+0Wxm1ZySCHWgNmLlk59FrkYg0T0nEtycY9fMF7bNUOdGLlSUz3WDDNknWrhHcdHdvbdXKt3PJK2Or0g3SWHERXdxzh5CVTzETBsFvHzVaYt2k3//UeVe2FDgMw0OOvsoO+3ZX12pJr6ULkQtisdZ+25nX77A2msZr9LlIn9N/dUzUA8OlRlIjn7qEz7tic7E+iHUXQAPCnNagb+n9mOeziDp6gCGlUoVHFSO5my3jsBJrt907IhxDCw24+iDC8FuQouWMxDiheIDu8GTgRsMut7ssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqbuMXuJlOvdq+e6zJZGt3O1B5Eaf0G9zr1YDqiYkug=;
 b=aTiz0LwbSgG6rr95JDPEn/L86uboKEHsEN0ASuTm3s1tO3KM99xeja/DaAcnmZzweF4m6DEnSFxac7aByQNe1lzDLrd+ks7pYN0cGDwNsvVrzJ4MSxb8dYKDzW+0oQOPLRjRhiJ1wcBBUZaO1/xjTjOTn0IOcDf8mp8RW68+U/voLl24ncD2Xl5vHIQnvxvCwSF3xehmogQGhKiua4rRhqvluTELGbSsdSRpDqDYlLqaQbh0mERH60LWO99U6X9Pl2aMGsQirpQl5Eu7VLHSdM0UqgoZWMQOuKBYNxFsGX/KvkJ4nyLv8aioBC3P2tclETlWQr73hAxo+06cF7ot9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqbuMXuJlOvdq+e6zJZGt3O1B5Eaf0G9zr1YDqiYkug=;
 b=gLAS2etI/q7GCuD7m93SQJrNukSc4AobVo6tFukH6Omo9L+7+qUiPSok2TtN4H/LsMnrPlSosS0/9PDb1M04JupLiCNi+mtUBVyni0A5wnCAindhoC3U9lTikTbqPn27QM5EW6ZqFkHLYPg6x7/zj+UoApwMethxLrFeTiKS9PRCxER4fEiqZBqqCgS9YSRHoE0CfZclL17K0KoU7NFx/1YKU0FlDb0fZEVBFxdx7scRkMkiyUtUVCCX/pkVR9Nkaq/9o0eB0ruZMIYsCVpTbHBfzsoTu30C1XIT0MkBNaRZaNZnrtevKb0vwJ6J0z/071qkoHnUynWOXiWlubNYug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM8PR12MB5478.namprd12.prod.outlook.com (2603:10b6:8:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:43 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 5/7] bridge: mdb: Add source VNI support
Date:   Tue, 21 Mar 2023 15:01:25 +0200
Message-Id: <20230321130127.264822-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM8PR12MB5478:EE_
X-MS-Office365-Filtering-Correlation-Id: 96bd647d-4cea-44e0-9f01-08db2a0c8f26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 829dC3VIAT/hLwqIGIpkLGSlVJhFduGSSXof/YUSmCLkmwo15fsOocip6JAvtVBRyCpCsVd+ki5bDtp6sN0DY7Iug+5m1oZ/ej6mpZ6eCmCcAqtn19GVqsH6Ugto05uaX9f4sDwGTxgwqL3vpBo4yPf2QQ3jM+ZkFZZXjCSpymhOoWY6NAf7Vlv3NwttMtiYl8mLaR6Lf/q045Lz10LB59IiUzgQfN9+ZmcuT+MpYru94h9MDft3PBepSJBl27+VPX+zm98DZhZ8PrLQ3dyvhhZ0JK9+HYIoKeBGSVhMTwekcG9HM3WDm0l5bCP7Xe3iZt7j4m3ZT2sYB46FZwVgYxHCOq0tqj9O6m2qF3+cqlR8WfH8467K7ORJPLzUwIBD3D/apOt4iYYoiX/PiqsFm7mjxr6oimfX6eO18HBHNIyR6/tRMM8f4G/+9nFUb0AT0BZhn1wyt7SeU9ske38/ODU19SmEgkx7Jfty3gPHxK7ghj1fvXtY66PBu3EHkBQBtUKfHbQBM1okeXtZBO3bEH8A+lxk0aCrQFLMujKxGTCidgGQC6CuXmrZauKUT4n/f/P38NUTBE/FHWmBhDx+z4wyKsIzEzSMzitp6p8294ibHWc7/YdPU85HWcHMkg7D1HunEprpof6bYghovICuJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199018)(8936002)(41300700001)(5660300002)(36756003)(86362001)(38100700002)(4326008)(2906002)(83380400001)(6506007)(1076003)(6512007)(478600001)(107886003)(66574015)(6666004)(186003)(6486002)(26005)(8676002)(66476007)(66556008)(66946007)(6916009)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6H+U+dnN4537pF3DMMUf0fmC8hZHDGeERrwoY14mIN43tzZWbENQJhm5UKdx?=
 =?us-ascii?Q?Smf9phZViKKDLnydFqp4g1yuqTtszesYCT5wIArbVIYJsCTjvO3acohA1RQy?=
 =?us-ascii?Q?3Yxhi+BwwXDWwo50Op3NBkDgYMQQGZyc31JaIbVlwdPlROcWkU4njMf+78LC?=
 =?us-ascii?Q?6DyfVFyasu7BHVc+ef4iJcVxPDhmQ9laJLoTLnTbiL6xH/2zoi0BjCZHvhU1?=
 =?us-ascii?Q?NkBXQ8srqP6dNNBioMrkPE7ghkOsXeVUFn6vr/cAv+3M8OeuM79X68ff8gsW?=
 =?us-ascii?Q?nL/xyxR2tCUorXWC1QZYtCTxgYfX0JllCIp3I7UzDYxJWLRPpfuh3JMo7DnL?=
 =?us-ascii?Q?2+wB1Xbw6SSHUMdTSvV3Y0qliQfUhuY0T2t0RkWb82oZDlF3a5Jj8B8b+JIJ?=
 =?us-ascii?Q?xHtPpy51E3hKsQd87VcZm05Nih5kyRI8XdjeJHcc1PfMb/ANbJP9SsbW74C/?=
 =?us-ascii?Q?rySbyU7RebYwMfD/I0tK2fM76Kn9d1FZzGoVGubguCCZPlLishivFAtT7bXA?=
 =?us-ascii?Q?O36ZMw34WSJHhZ+K3k9DEyJrjSEHerzSeSqoPjYVXhMh3KtJ7EWEzeqtRAcQ?=
 =?us-ascii?Q?RPd1VHZ5CKyTVXqvvDaTpO4MGz4kX2KNddzPlvspGuidrsi61tUUEMZVWy79?=
 =?us-ascii?Q?d26HIrTbCQphtaaMjyivT9rJyWZa57rXxvLdk8xaTzWjVuDbOTJrLh0IwD19?=
 =?us-ascii?Q?jItmDBQDfNQYOj2CEvCn+95yKrdEdavmIo9Qj56qF3pd+vLFizJEFCg58qfv?=
 =?us-ascii?Q?j5UdnuwMdLiWidgvfyxX0lXEVKqycJGEcq2FmLSTG15+kBBDfXxTztj/WCqf?=
 =?us-ascii?Q?bZC8UsQWvGgIwIAREPPB36ZPYzqeSQzqkh3jYfuZXtBxPSD7E2EAdJACvFF3?=
 =?us-ascii?Q?AiGtj+5vMIqPbfkGp1ToxfV8d1Qxm35Q4uiZEYkCKxzE9yVhWjr6vSMcXsGf?=
 =?us-ascii?Q?hu4IpwpiXCsVak6kPvnbI0WwX6xVahiDUep1ueV23pGnBf8+/Pkq+05oVJ0M?=
 =?us-ascii?Q?6J54px5m/Ui6H/8Y+SZPxYatN/4PwVw2/BphNeJkA1OtQ9aE5lk0ad/64G0O?=
 =?us-ascii?Q?hM5T17voO4TrjbGtFxARuOcDqk2UxwWPgX1zeJtVayOdGMVCzG8aDh//F1rt?=
 =?us-ascii?Q?qzvgBqQdMhAhe7J7f46gjKXcF/ulRMEwS3V/KuXcDlKLCRyZ4ZQJwTgM2Lvl?=
 =?us-ascii?Q?A1oAAuYVk1iTIptkJS3afCR6wOWAzjq9QeHCAtNbBg+dsHZ/2ilueE79ATzW?=
 =?us-ascii?Q?nX7UjtHnPmgjfP/Vyg2GR5JyQBa1dnPVuYOynQUylqInmP69mGxJ52dfZQXu?=
 =?us-ascii?Q?bvOjv3mFDW4UGsAQb4GA/8xKus6nFaKFLZtrCTfcyKWd8slqI1GC8S1ot3s6?=
 =?us-ascii?Q?3vRN3v0zGSHrPQGWGDhS3arXONTCbVJiKTAleaK2Ry5KfBtLhY3t7adZKdy1?=
 =?us-ascii?Q?IlXhKEbYI/Z6wP8t/as8qazr+WDOI5HBqSoJiVeWBaRBpaj3S+vGf1mLPB8P?=
 =?us-ascii?Q?w99iALWvQ6sB51kO1UDRDyzRT44L6C5v8eWTqEXMRRSxzTiPRtTIbBKJtYKQ?=
 =?us-ascii?Q?De/6NtVPWXGFNIa+X3hjB+iUkrq9z4SnmV8Aakj6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96bd647d-4cea-44e0-9f01-08db2a0c8f26
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:43.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITcobl5tkN33dvDzvmQJAcsrI1xy51MOV5g8+1nwWsr3xcyff8Y41fnQUQpOS2vL5/GDMewOnCt7QtdQ2Ff8Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a similar fashion to VXLAN FDB entries, allow user space to program
and view the source VNI of VXLAN MDB entries. Specifically, add support
for the 'MDBE_ATTR_SRC_VNI' and 'MDBA_MDB_EATTR_SRC_VNI' attributes in
request and response messages, respectively.

The source VNI is only relevant when the VXLAN device is in external
mode, where multiple VNIs can be multiplexed over a single VXLAN device.

Example:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 src_vni 2222

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 src_vni 2222    0.00

 $ bridge -d -s -j -p mdb show
 [ {
         "mdb": [ {
                 "index": 16,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "198.51.100.1",
                 "src_vni": 2222,
                 "timer": "   0.00"
             } ],
         "router": {}
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 18 ++++++++++++++++--
 man/man8/bridge.8 | 10 +++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 2174eeb6e933..ee83aa38bced 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -34,7 +34,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ] [ dst IPADDR ]\n"
-		"              [ dst_port DST_PORT ] [ vni VNI ]\n"
+		"              [ dst_port DST_PORT ] [ vni VNI ] [ src_vni SRC_VNI ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -268,6 +268,10 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 		print_uint(PRINT_ANY, "vni", " vni %u",
 			   rta_getattr_u32(tb[MDBA_MDB_EATTR_VNI]));
 
+	if (tb[MDBA_MDB_EATTR_SRC_VNI])
+		print_uint(PRINT_ANY, "src_vni", " src_vni %u",
+			   rta_getattr_u32(tb[MDBA_MDB_EATTR_SRC_VNI]));
+
 	if (show_stats && tb && tb[MDBA_MDB_EATTR_TIMER]) {
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
@@ -668,8 +672,8 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.bpm.family = PF_BRIDGE,
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
+	char *dst_port = NULL, *vni = NULL, *src_vni = NULL;
 	char *src_list = NULL, *proto = NULL, *dst = NULL;
-	char *dst_port = NULL, *vni = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
 	short vid = 0;
@@ -720,6 +724,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			vni = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "src_vni") == 0) {
+			NEXT_ARG();
+			src_vni = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -792,6 +800,12 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (src_vni && mdb_parse_vni(&req.n, sizeof(req), src_vni,
+					     MDBE_ATTR_SRC_VNI)) {
+			fprintf(stderr, "Invalid source VNI \"%s\"\n", src_vni);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f39d434fa20a..88046dc1a2b4 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -151,7 +151,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B dst_port
 .IR DST_PORT " ] [ "
 .B vni
-.IR VNI " ]
+.IR VNI " ] [ "
+.B src_vni
+.IR SRC_VNI " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -998,6 +1000,12 @@ the VXLAN VNI Network Identifier to use to connect to the remote VXLAN tunnel
 endpoint. If omitted, the value specified at VXLAN device creation will be used
 or the source VNI when the VXLAN device is in external mode.
 
+.TP
+.BI src_vni " SRC_VNI"
+the source VNI Network Identifier this entry belongs to. Used only when the
+VXLAN device is in external mode. If omitted, the value specified at VXLAN
+device creation will be used.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

