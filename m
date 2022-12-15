Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552FD64E00F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiLORzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLORy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:54:59 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B458C46678
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:54:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2pZyWjf3oukY8YTSKkrmJe48zyG0xUImKr/1MqVPldXQHP3DJNmzi3hZqJ3+NShmfmN6OWkT7EoY+kLDDGkUzeQeGg3D44TTfmPchhiDy5t3vDoj93SAYorTRwvZg3SsBscDmTT12dKSpxR4OOdxJi/RECuhGaCGwlpASreGvn7gCQz9BfTyjrEaDa5UynzHQ1V9gbdtzd3qW5q4oAQwVwgSXmye5HGRu1jdbVihd8qsvy9b3ikmQrSCY4/+LmVP5uQWHUy2uKcyf+aFyMqhDxJNldiBVaEr5+Pz166oqJxMjVOzC6BXvdE5vYfr5sJAuMISPe3RXvpUDKSJy7UXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qK2wDTU9Aod3KVHf5NzZKVWw/CptEfI5qc0V12dn3sQ=;
 b=DFHD9Dzp2J9V1KlJsYi1lMPm1rbUC+oP/1QbkJyFBIQwoJGiAjepXWO98yXUeTS7i24752Be7Esh6N+P9aCpiXBvPBAGO/tKqSKNMvW4zOdsRrD2cSmJguildVbgiwhtr2yKVUqbvsNvLfK3Wix6PhED5lGjdUgEMoKWBOToOWMAnqhml3yy3LhOddj3xgl2tA1NRgbJ77o81FRg4IPc8qycQp1rLIwWmvk3u9agBa8hi54NAWUtKEgJ/lBQpnwwvBs3Eol4tMMD91EjhRdWzRSZu+qB+HM1dzwQHQIDoj+WOzar3jDkGxfEq5ZpLEo7H6ldUimlpGTS8a+gzvoO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qK2wDTU9Aod3KVHf5NzZKVWw/CptEfI5qc0V12dn3sQ=;
 b=bdMR2X82kaVPxuGvB4l2B4oYyfqw5lb4u69uQRIUIl5eds1LZP3DkaIsH4lteI5GiDDuJEZLC0T2pM0gW0xVOGGPCtJj9nJpi+BTyvTDGteRBe6NsFILTyJOvA6ZZx7oEHM8yxFppJaoz0VwS1urHXc8GSb1sX1VnybHNkULKjnz8Bgjg3q4vTloOnOtudhSQPlNqb4QDsk7eZWMMNM3CW/3wNzqcdOQVAuECb6ZnGRrpt5hWjipqavayjavYktRN2cpTGCVSwwe3keA+5oUp2eKH3EJI2pFraWCm8f7vPXLwi40Ey0SHQuznWr3hOdpTCsNwfd0xeMcEetMsv5wkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:54:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:54:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 4/6] bridge: mdb: Add source list support
Date:   Thu, 15 Dec 2022 19:52:28 +0200
Message-Id: <20221215175230.1907938-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0039.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: d72ec710-c50a-4f3c-de02-08dadec577af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bCONjFx5hPlaxiC+ztjiRZ3zJFFW8TbPyoRAFO8SUUEnuHavaw4JBL+12F9CYyXNBT0CIo/JuvfGgXHAbNjI4nBA7ShJ2pUuGDkLYM5IhzyNyFKZYYYLi4FCU29xlrqoHa5ZID6FvYXJd4Ik6nP9253mmZV9iBTzkVSC7s7+qwmHFi8WGqQNgysgnI2ec92gEN9l+xsX29ecYtSLLpfpdu5Gy94c+cPkPKoaQS4j/C6x7o9m+N34d3Snu4b8UdPVNAFcXk6AJIMdqvssAb1ieB17l/vi8tdlfqLjkorF/K/YF2+6ScfAgV19izOslFp1ScOkNLwfcQWZSVZGCj1g+MaI2aZetE/izCpuC1o/osi8sfkKF9xj4j4brZDJcYv1DpGI5aV3pW0tJxHTBFxWJtHJCTihozl45pTwSjvxU3OzHPYfrYXWaYPLkiYJ3NH7X8+IbvUydyPhRx1dj2gf4lcyK9sJgQy+hxBvz76qhyUwABiDzTrJ/+Jcvag7pfNc6aJFcTQ6emKWD/yc7AD7Gxw/xnoRt5Nk3drS48xfddUO1wbgvQbimBqWHrnGM+2yiE/khU99HRZoxHV0qdEiwJsB/iwrqitQY/iVYRkoPkzgNSEIUmkntZq+OT3b/1miytQmgiTMNcPdtGlJGT+Z9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199015)(83380400001)(8936002)(86362001)(8676002)(38100700002)(5660300002)(2906002)(66946007)(66476007)(4326008)(66556008)(41300700001)(6512007)(26005)(6506007)(107886003)(6666004)(186003)(2616005)(66574015)(1076003)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DmGLTfQSIW+o+oez5wAYAsRtgma30Xcd+e0q0qNOEvEAumUVsE5muELJxbPF?=
 =?us-ascii?Q?gi/R2daUi44IVlQD5mdMKuyZfPCYHAyeTtnco0ZG9xlcju64rrGo+yy9CDQG?=
 =?us-ascii?Q?x6Ebo8bwtRD3ERLzu1ZymHKQB4jNh10W98B+33wb17UeiA17a8pBMOsf/Nbc?=
 =?us-ascii?Q?86aopjn1o04UG5KAS8+/W2YRMUmljLHlmfxp6CprU0MUQxXrbyyuuPtX7/0H?=
 =?us-ascii?Q?Mv8SU67H14EXnYEX2XYP2uPJaJ87GPUiaGhJ6z1F1Fj7G/8pD5XX0d6Ukts/?=
 =?us-ascii?Q?CjjIDXtzQorsWw6MLuaI5noBq+EPO79UYO+pAYuvyPvLNbnU7aTA3/6W9TuH?=
 =?us-ascii?Q?ZUf4PepY2mAnDXSJnn8WUA/fuGB/ILUStWUsgGDxqrogPAN+TAw22aekeOip?=
 =?us-ascii?Q?QtfkSeZhBF53pZ7zRwNjKGVP53GUg3m4XBnL0gD1NJjg1UBzzEhD+jB4tU6S?=
 =?us-ascii?Q?E4vZPFM6gbGWR218aRW2BepdCDqZSeeMVAOx/tuOm1GHOMvXxMjGIc5I4b11?=
 =?us-ascii?Q?ZdQGo7fx0dBK+6MM2cK/nmtll1gnyKqNlnc5MpEtCp3cJrfbMLo8pQ0+7KT2?=
 =?us-ascii?Q?Jloe0To176gc6KaKrv3gJ7g0knJhRUVhSB3h/XGw+eIj+HGZxiQglo1RalPf?=
 =?us-ascii?Q?ZeSSH9EOljuuT/Ozmqq7zFAa+wV4kVc7eE4TzXRrOoRsGKVsZ1F2mVHtA3gn?=
 =?us-ascii?Q?Q4FwrS3sX5NmlSa6zbmn74meA6jQVFLzAwAhTH/3R3cPu5Z/qHKPORb9dBQ9?=
 =?us-ascii?Q?4gHhNI1G6Gkh6lVy610ymzLaQT5ftxb/mScYCICmqzYK46xBfEytO32K1+Un?=
 =?us-ascii?Q?ak2CFOk4qN6BKRecIFx9jgrvhOin2bSKj+Wc4CjPe/jWW2mv3brHXDN5xHDG?=
 =?us-ascii?Q?rZHyTYoryyo0YzmHaL2CZmt01XDIeFTN/qwvsIEVhY+5+kSS8c0or3gQZ9I4?=
 =?us-ascii?Q?dC60TEEGvgJcnPq81YnoRhNPkXT0NIS5YCuZgUtVz8wzUlQ8O8+Sm5uQ2hua?=
 =?us-ascii?Q?YWWnBfg6eQMcAAK+7ZDTb/z7Z1B5J75+D3IVAAjsG3w2X3QRJzyxZgR2AE/+?=
 =?us-ascii?Q?xIj9hx/J5vHwAXLsmC07bVP611OkSj/RzUjxpkCCBWxLnw4yU8H8pVIh7MMB?=
 =?us-ascii?Q?1+4giFuYS8Kg9OFFm8Rvb/dfFMpOkQ61sPPiOMOwkGnU41BfPW3xHNUhH/pe?=
 =?us-ascii?Q?3/gp4FqQOiqUnM3p89Jdm9PV18Tqe1pyMKAyoclhMWqhTiZa/btQOFASglz/?=
 =?us-ascii?Q?w99y3qDDPfUHB90BLd0ZZdCpNsq/KGt4sHOP4khLik4W5vUJPmvSA6ei9d2w?=
 =?us-ascii?Q?Qudm1cDH/SV8I8ctdcJ55x7lrFcWebDWfksnIN1FZ12JR2FkWYqSuQp1Ubfb?=
 =?us-ascii?Q?wkZEWBlHmZ3xu27LzS/RtVRmPsqkHKedp95neowH7Ll8zmyMB824wbvdKqZJ?=
 =?us-ascii?Q?2h6aIrOIx5qjvGhI3DCmXNPWEh3u6AErSp4wg/AyBQfEHkkxoyd6jMjgT40S?=
 =?us-ascii?Q?PY4wPepKXw+u2D/H8dOEjrhsN1mrERbVYWVCpBuSI1avhFYwFRS51U0bO/Wo?=
 =?us-ascii?Q?hsEdedaM5H3Z66bktl1nX39psgCPZ1Z0WO4ORN+x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72ec710-c50a-4f3c-de02-08dadec577af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:54:52.5064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMicw8iHk3HOMoJgmEVbnra+IFLjJHe4J0R7eJkDf8uIxU77Xt+Xg/D1ibJcGC4E2wsFsfQtsCwYvpbvDUZkXg==
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

Allow user space to specify the source list of (*, G) entries by adding
the 'MDBE_ATTR_SRC_LIST' attribute to the 'MDBA_SET_ENTRY_ATTRS' nest.

Example:

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 temp source_list 198.51.100.1,198.51.100.2 filter_mode exclude

 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 198.51.100.2 temp filter_mode include proto static  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 src 198.51.100.1 temp filter_mode include proto static  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 temp filter_mode exclude source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto static   256.42

 # bridge -j -p -d -s mdb show
 [ {
         "mdb": [ {
                 "index": 10,
                 "dev": "br0",
                 "port": "dummy10",
                 "grp": "239.1.1.1",
                 "src": "198.51.100.2",
                 "state": "temp",
                 "filter_mode": "include",
                 "protocol": "static",
                 "flags": [ "blocked" ],
                 "timer": "   0.00"
             },{
                 "index": 10,
                 "dev": "br0",
                 "port": "dummy10",
                 "grp": "239.1.1.1",
                 "src": "198.51.100.1",
                 "state": "temp",
                 "filter_mode": "include",
                 "protocol": "static",
                 "flags": [ "blocked" ],
                 "timer": "   0.00"
             },{
             },{
                 "index": 10,
                 "dev": "br0",
                 "port": "dummy10",
                 "grp": "239.1.1.1",
                 "state": "temp",
                 "filter_mode": "exclude",
                 "source_list": [ {
                         "address": "198.51.100.2",
                         "timer": "0.00"
                     },{
                         "address": "198.51.100.1",
                         "timer": "0.00"
                     } ],
                 "protocol": "static",
                 "flags": [ ],
                 "timer": " 251.19"
             } ],
         "router": {}
     } ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/bridge.8 | 11 ++++++++-
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index ceb8b25b37a5..58adf424bdcd 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -32,7 +32,7 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
-		"              [ filter_mode { include | exclude } ]\n"
+		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -509,6 +509,53 @@ static int mdb_parse_mode(struct nlmsghdr *n, int maxlen, const char *mode)
 	return -1;
 }
 
+static int mdb_parse_src_entry(struct nlmsghdr *n, int maxlen, char *src_entry)
+{
+	struct in6_addr src_ip6;
+	struct rtattr *nest;
+	__be32 src_ip4;
+
+	nest = addattr_nest(n, maxlen, MDBE_SRC_LIST_ENTRY | NLA_F_NESTED);
+
+	if (inet_pton(AF_INET, src_entry, &src_ip4))
+		addattr32(n, maxlen, MDBE_SRCATTR_ADDRESS, src_ip4);
+	else if (inet_pton(AF_INET6, src_entry, &src_ip6))
+		addattr_l(n, maxlen, MDBE_SRCATTR_ADDRESS, &src_ip6,
+			  sizeof(src_ip6));
+	else
+		return -1;
+
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
+static int mdb_parse_src_list(struct nlmsghdr *n, int maxlen, char *src_list)
+{
+	struct rtattr *nest;
+	char *sep;
+
+	nest = addattr_nest(n, maxlen, MDBE_ATTR_SRC_LIST | NLA_F_NESTED);
+
+	do {
+		sep = strchr(src_list, ',');
+		if (sep)
+			*sep = '\0';
+
+		if (mdb_parse_src_entry(n, maxlen, src_list)) {
+			fprintf(stderr, "Invalid source entry \"%s\" in source list\n",
+				src_list);
+			return -1;
+		}
+
+		src_list = sep + 1;
+	} while (sep);
+
+	addattr_nest_end(n, nest);
+
+	return 0;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -524,6 +571,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
+	char *src_list = NULL;
 	short vid = 0;
 
 	while (argc > 0) {
@@ -552,6 +600,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			mode = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "source_list") == 0) {
+			NEXT_ARG();
+			src_list = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -595,6 +647,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			return -1;
 		}
 
+		if (src_list && mdb_parse_src_list(&req.n, sizeof(req),
+						   src_list))
+			return -1;
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index e829b9cb592a..801bf70c0e43 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -139,7 +139,9 @@ bridge \- show / manipulate bridge addresses and devices
 .BR permanent " | " temp " ] [ "
 .B vid
 .IR VID " ] [ "
-.BR filter_mode " { " include " | " exclude " } ] "
+.BR filter_mode " { " include " | " exclude " } ] [ "
+.B source_list
+.IR SOURCE_LIST " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -937,6 +939,13 @@ the VLAN ID which is known to have members of this multicast group.
 controls whether the sources in the entry's source list are in INCLUDE or
 EXCLUDE mode. Can only be set for (*, G) entries.
 
+.TP
+.BI source_list " SOURCE_LIST"
+optional list of source IP addresses of senders for this multicast group,
+separated by a ','.  Whether the entry forwards packets from these senders or
+not is determined by the entry's filter mode, which becomes a mandatory
+argument. Can only be set for (*, G) entries.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

