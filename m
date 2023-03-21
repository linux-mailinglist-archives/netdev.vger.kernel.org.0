Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D316C3235
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjCUNCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCUNCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD024D2A4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJXwnFB5G2RuC6HmZXPXAB+bIe7AKRlE2G+B8Hpjlmm4cPqKha5Pet2JEDLN4nbnScUpc8bNbWhqbxstCJznDw0WozpQt2nUWnP23eQ97JEUiwJ7B5evX5tcz/cQqvaAJwWXNVJJzHUu3NM/ZFs8SYLFm6NQU5ohD+9fnuktPXza9YxLuUFpy/Z8kX0DyvjOispnihQB4fB33L6djRD+I997Ax7JC29Z7UA01dCFuHaBHZx9C7mi92Jr4m0Aygr+vxYe1M764IPGawtpleIE1h/FelEZ+pSpIXGFyf4NUVr0x2R6DVyqM0Y+HAkIc/0yfW9C5SvJgCk0qinEXDK0uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crUqdsXYLVZ3RbQQMOFzsU8l0HBGfvR+4D6ENSHIvVg=;
 b=ZCWoiupXY9+pdHgR3ktnMK2Pi42Vzx0hK5ejyhgNTKQiNhnLND+e0SUaYPSodprntq1Z0tZw6XcRvCr49FyZZ5xN1RSmTy8vAxU5PuibwWU5+ozNcG2qZUvR3LT7uP5Ds9pN6XJ7MhO4Wd2SNrRivK0GgTk9mVLCghUAKm/Qzc5B5PHbVjA0R8rvKrM46FYdlP5KQkBKsU9sg7neEVvde5e6G73MVQkDB/7hsZqSq7m7gNcJTmcsqdA/OsVfM0tlRvJxXMQvC6vhqhQGvi47jPV9EjoVd0Rvrsx+fgGYzHY/MNfVl0Nrtf7QH+EFHLGD5FR0lpBA3GToCjaIXXrbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crUqdsXYLVZ3RbQQMOFzsU8l0HBGfvR+4D6ENSHIvVg=;
 b=VPRB4sX0v6jIVLOrnKrkK7BQcCkttjD2K3zd7e4fbUOqYiq9Z8j7mAt/CvasLFz4831xb0nXXuioVV9fTOMDFgB2D7WqDh4XTbhAw4BhYL+GFM2/BqnpVwwG0wCtm+/2uMr5McaY1BBWTBaU/B6QG869xc9/L6YGDilFsH3N2FO5eGhQbVwU8Oc8Vi68M6wY2WFF2ChqWYNNkWYiKLBvYXneqAhore0O1hRb6kl9a/UEaVwRfXlKjGOhM8evcH8+4ik9mB4MDiqkhcPEC5u0f/eGC9N6hE7kdrKkNDil+aYXnNfZeA8SyypaujGKrFk3LXspRVA3oVwN4qx3d/I7Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:35 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:35 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 4/7] bridge: mdb: Add destination VNI support
Date:   Tue, 21 Mar 2023 15:01:24 +0200
Message-Id: <20230321130127.264822-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
References: <20230321130127.264822-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f0d162-fa51-40b3-0e10-08db2a0c8a83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUTacdw3SkO62lT+dwD531QpJAYtN6Kk7Ny/X3EuaaNJxhUEs1FLXGGd3xdLQLtcc9c5BOVi0xriL4JqZN/STsi5LTzWosI2JEC4v6aZk9Lg/jWz1m4rG+fyJaW+7N0UnSgvZl6ZSgaeLC59EOM/oFp3b+kNFWVeGsC4srVHOPDBttXXnEuuY5xBam80CDKrF+wNzIGNiSbUXq8vP3ryrydN7n6n/xtI96Hc2z5iYlZIFnVzjGeHHgNqw3CRvsnis2Q8P+tOMIaw2fuW+YUwaplXJDcHJB0bvITK+2xdYbmKpFbDXaTMlxF/D/h5tEKM1Eu7ih4LKh56DSMmoOxFmZbFxQTJeM76mR0dRp32/YcEkiutV71dY+StU4S7Q1IxK90HSnafUHJpMGMXLWExZEjR5KXsjXipixB0yHw/MxSNHrQ3xwfyJcBkWfQNexlKlkQJgTxN8zQAWFByXUPFcn/yw6nIse6hKHU8OwQJy7r0d6lpoEwcR+ufyMo0bwqVoJFf3JVDKsq/z4QozwkHSnuO455NagPpAG+ean5B3vr0mrkzBl3eArnOkcFIttAFGoZU8rPhekULmMS3zXAd4SBjnISEBUtyOKXymy7FysT5CeCbl7DTRnbkWK0HV1/A7Qr9iDOXDRNh/iGInX5NpWxheIrGCyNBMunchpH43hfvlKQL/xAaZibIbRKcsTu5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2616005)(6486002)(478600001)(966005)(6506007)(83380400001)(66574015)(6666004)(107886003)(316002)(66556008)(66946007)(66476007)(8676002)(6916009)(1076003)(186003)(26005)(6512007)(4326008)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aalq1ZIM8/j4SZ+wVF8My35/IrbM8s8qmjlNUBfHQZLN8GxbbE0U8BmqZ/KW?=
 =?us-ascii?Q?nIQfD8yj7eR6AfRdfM4hR92W7Xsl9CNjrVDJTzue8Kp2wOBNP+0i+YBT5K2N?=
 =?us-ascii?Q?QyT3Aci/P+M2fNJ4UDe0w6p/nltWq9W0PtZzTkQfUKAygzj8p6V+Mcvwi2kM?=
 =?us-ascii?Q?x3NdDqpeH+U1m7CwGwnQkXS7DcZs8v3Yc2CsKuffwN2rkY1kS/GP5QpS91uA?=
 =?us-ascii?Q?AcKKha3UwbQ9YJDePkT+XEb48G45HBaqcCXJn+A7jbzZLUQLywWJ8Y/zG+Cu?=
 =?us-ascii?Q?Seufz883uOrdNiOnAPBDHCA0WtOGplePSgqUauBiXsb7iuk7pj6IU7Jp5LTT?=
 =?us-ascii?Q?fBqDeqHZdxkMbkL61onjcnNPXEDtXe7ql9G7rwj23Pp8cyn16QV1VL9CHUh6?=
 =?us-ascii?Q?wh1A7taNiNmQL7xVRjn36Wkjzsx6o6iZLGjP1N3TRylSIUKILqAYhtEJBnbF?=
 =?us-ascii?Q?sklW10H6cNG3isEwvKYQcC9hFEUXDn8gJ+XzEVkG9/BvAvXw/6CQeXllqadj?=
 =?us-ascii?Q?PoVUgRa5vWP9/W2+iEHwOHFWGTI3ofnoQxRvd24ZIknZLnVXErNp08H17dQu?=
 =?us-ascii?Q?RgZXpLNuyuWBTEkjyIx+YLC6CJBi7wBycsDDB9eqH7osLt/L9znQCC/L3U6/?=
 =?us-ascii?Q?894yEufzesrO51lfEnRnPgmVv9l2oCHPJzudIl1Gyl7E8u+38FXf9wD/ozgC?=
 =?us-ascii?Q?1Y7N6Yy8TIMUDke/wsHJp5UZzRX/g74kXUYS32eHYWxVUB0c/qBsw6p83cGG?=
 =?us-ascii?Q?58UOJxrxfc33oEhBY/WCfJu0fN71zjPlAa6GLbaoWVHFoQ3RXWwFe0BKzNj7?=
 =?us-ascii?Q?NyvJ4ECta88s+q9f8qNRrXsZxVek7gnDdxfM+N87spBA23BK2sDB9/BPkKwk?=
 =?us-ascii?Q?1qd02mDoeDV9iCsorOhgHeo2Me5puJRWpIud1ozRt8KjvhBLVpADLD5ZQidP?=
 =?us-ascii?Q?LKwd+MnTROQWmn0nVgJoL8a2FmX+Z02T5dX//DZ5gQLhNk0LQxlsZvCzdh4N?=
 =?us-ascii?Q?Dn9N+BlEv0wfVmChEg9oFm3qJZ0YvCss4dMIvzU0r3auqJgsxn07Rz1VPYVS?=
 =?us-ascii?Q?2Jm7R7zNBPrzgDs9fZftX9lJtoxxn56kZEJO+vKnWscvpqpaDMHsi7thXNmv?=
 =?us-ascii?Q?y6DRjgjMPzGeLeVsXcTQHfTcf5WBkva7Ns+qPMe+rMllitBn+3L02sxjC5OA?=
 =?us-ascii?Q?yICckQ72scACfA+Nje1e6akLgOLkoVTT7LfcxGLmMFTCqs0CO2iHRKjTVL1n?=
 =?us-ascii?Q?ARXpTceDbBd2lXrNVp+a6F4ddXRhnPr1ho+Efjcp2/oeILOLWvVgGX/6aeCO?=
 =?us-ascii?Q?Awc7qGEnmPcKxq2G3knjDLbTMj84VbJCANkjBLSRMO9NxEJhtbT9EhxWYw8X?=
 =?us-ascii?Q?QCnWEq1OVWS6FkbwjZHD9AQWyMUuDlD5sVSUpp3cWm2NP3VqeAUSlCp1HJPH?=
 =?us-ascii?Q?Ngu2/A+QeU6VkrjjuJ4OIk/HasxvZBPiWV/Jb/JDH9QyrQS3udklqKQKOkYY?=
 =?us-ascii?Q?4FjZPfU74xD99ZRRyxw7mUzvKE93W0b76oToD3eSzyjopEBTf7BARaTjhdCt?=
 =?us-ascii?Q?vTooCy55ftG5eW39YolW8DuGVO4HjvjeYp8ijVS1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f0d162-fa51-40b3-0e10-08db2a0c8a83
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:35.6125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9pdZ8geybe0tH6esFes/SyNBOC5/A/RBJ4pyCfFJpbU0V/7RHKlHHjgS24JjDXtlGbb7ReZnklZ1ZkqslFFB6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395
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
and view the destination VNI of VXLAN MDB entries. Specifically, add
support for the 'MDBE_ATTR_VNI' and 'MDBA_MDB_EATTR_VNI' attributes in
request and response messages, respectively.

This is useful when ingress replication (IR) is used and the destination
VXLAN tunnel endpoint (VTEP) is not a member of the source broadcast
domain (BD). In this case, the ingress VTEP should transmit the packet
using the VNI of the Supplementary Broadcast Domain (SBD) in which all
the VTEPs are member of [1].

Example:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1 vni 1111

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1 vni 1111    0.00

 $ bridge -d -s -j -p mdb show
 [ {
         "mdb": [ {
                 "index": 15,
                 "dev": "vxlan0",
                 "port": "vxlan0",
                 "grp": "239.1.1.1",
                 "state": "permanent",
                 "filter_mode": "exclude",
                 "protocol": "static",
                 "flags": [ ],
                 "dst": "198.51.100.1",
                 "vni": 1111,
                 "timer": "   0.00"
             } ],
         "router": {}
     } ]

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-3.2.2

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 34 ++++++++++++++++++++++++++++++++--
 man/man8/bridge.8 | 10 +++++++++-
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 893488211911..2174eeb6e933 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -34,7 +34,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ] [ dst IPADDR ]\n"
-		"              [ dst_port DST_PORT ]\n"
+		"              [ dst_port DST_PORT ] [ vni VNI ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -264,6 +264,10 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 		print_uint(PRINT_ANY, "dst_port", " dst_port %u",
 			   rta_getattr_u16(tb[MDBA_MDB_EATTR_DST_PORT]));
 
+	if (tb[MDBA_MDB_EATTR_VNI])
+		print_uint(PRINT_ANY, "vni", " vni %u",
+			   rta_getattr_u32(tb[MDBA_MDB_EATTR_VNI]));
+
 	if (show_stats && tb && tb[MDBA_MDB_EATTR_TIMER]) {
 		__u32 timer = rta_getattr_u32(tb[MDBA_MDB_EATTR_TIMER]);
 
@@ -636,6 +640,21 @@ static int mdb_parse_dst_port(struct nlmsghdr *n, int maxlen,
 	return 0;
 }
 
+static int mdb_parse_vni(struct nlmsghdr *n, int maxlen, const char *vni,
+			 int attr_type)
+{
+	unsigned long vni_num;
+	char *endptr;
+
+	vni_num = strtoul(vni, &endptr, 0);
+	if ((endptr && *endptr) || vni_num == ULONG_MAX)
+		return -1;
+
+	addattr32(n, maxlen, attr_type, vni_num);
+
+	return 0;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -650,7 +669,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
 	char *src_list = NULL, *proto = NULL, *dst = NULL;
-	char *dst_port = NULL;
+	char *dst_port = NULL, *vni = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
 	short vid = 0;
@@ -697,6 +716,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			dst_port = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "vni") == 0) {
+			NEXT_ARG();
+			vni = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -762,6 +785,13 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (vni && mdb_parse_vni(&req.n, sizeof(req), vni,
+					 MDBE_ATTR_VNI)) {
+			fprintf(stderr, "Invalid destination VNI \"%s\"\n",
+				vni);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9385aba0ee68..f39d434fa20a 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -149,7 +149,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B dst
 .IR IPADDR " ] [ "
 .B dst_port
-.IR DST_PORT " ]
+.IR DST_PORT " ] [ "
+.B vni
+.IR VNI " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -990,6 +992,12 @@ the UDP destination port number to use to connect to the remote VXLAN tunnel
 endpoint. If omitted, the value specified at VXLAN device creation will be
 used.
 
+.TP
+.BI vni " VNI"
+the VXLAN VNI Network Identifier to use to connect to the remote VXLAN tunnel
+endpoint. If omitted, the value specified at VXLAN device creation will be used
+or the source VNI when the VXLAN device is in external mode.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

