Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF25D64E010
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiLORzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLORzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:55:08 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2A346660
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:55:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgBbLaJy4fPQh5xQTsqoM1bwq/ZljNcZ2yKkuU8J4kXUcy48aIXvrdX44xmWaFyCRRQR1Aro0TXifPZ2RPOYSbewW+01ik5AEZ4zmw9ZRRD7JveATgmSCvgD3pLYDYE+VFZ+FUbt5u3y3jrx81RU3PQF/UkPRKSpv0p2tRM74aPefQCgul4/n0OuEvIoLdegUeJ8KTM+P3imh3a9OT4cfB2mPZBBiJ1qsjpnoc2VTJAfGfO8wdxexoCIv+ql57c+3TRBwLd6HNhDf0h1SjSjFd9D8m03CBcb/f75RN89wJFp+bbJy38lXnspkEWssVM777iuspipLlhrLgerdWuxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uln7dUWS6Yb09CL4g+IOlxPHjcZBkVOJL2PhnG79xk0=;
 b=gGXYlhJ2G4BL6qxY6k1LFgd8ydh6LfEiHh1Xie1WVks5g0/u0u/oJDFiZTH9BMD2QPubCm06OzTttg6fMgo+Mrs4PytpNm7Jj8bY54zX0vf4ZEN0KRM6txRV8j8S3UnaY7ZwTp+7F3EdIzA5IIVukpoJJi4enAmQPxGTOdG8h4HpZvX5sxborP4ll6A6mKYZZt5sxdklwPaA98auifViQ+LwBKWlauWdfUOFciFgTZVqAT/F9KWZHoOuX03Ct7dFYfh/I9tIxf1jVXbwGzRRlx9TXBdoqD0jQ+GfCpcEZP4FC5jHpyWn2DcFr1oSCOH0BuYPfWbG/Vfj14O1HzoNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uln7dUWS6Yb09CL4g+IOlxPHjcZBkVOJL2PhnG79xk0=;
 b=gQ/mwg2PlpXqpuJd/eqcIwKKKOvZ0pJmL4hDJGZ2LFsL0LB8lwR2o1QizlM8o6cnH91LHvGWVEWNTzEDHU48Ilh9znut/wEAiCn8GW1ReqMEuj/yIviiG9qpDCsaML4bqrtgi4LRnQekHPeDKQEoSyPBEmE8QedTiHMTNxnHvZ6LSYIpMrj/zW7dpys8VxOt3+aTqMoEzFCBXTfw91RvJBHsna5q31pSxLH3SmW/QRxODK+Mkb5BBHip8HUz9HDw99QQSTDF2EgwQlaS5UjOyNGcSGDYSPfmA7AZHKVn0RQMhihGG/Hk1Ryeewa8Ms0CK2Pb7F0FlNBWBHFaOK5q6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:55:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:55:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 5/6] bridge: mdb: Add routing protocol support
Date:   Thu, 15 Dec 2022 19:52:29 +0200
Message-Id: <20221215175230.1907938-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0019.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: f748ca11-9571-4d28-78ba-08dadec57c2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4i99vVeIj460tPoQ9tHMZvM1A+difDzvmFNn8VJCoF1Qf8wKonPYUk/rhuRAkiUEfS3MAgi5KmMpY1NRQkqSZnuXeK8+IC1mhmPwe+syP7hXxOxFbGM4cF/unDTx7Lx5qJaAWWj3AWGac2C+peN55Mi4dPfhknnvYftw9Oi1NVnZv7FmqemBy1S62yFofUrX1QGMymCtWGm665Ad8mla8OzDgJvId3hpNF+Fcw6eVoMtQhIUxysfZJaib6fGKS0YLjREtH3mm15GkzPZ6WUIu8JknK+IbpMctF0+Lv0Je75vnUL0DkmHsbTrYWJJTmPQvwb3+t8Nwh+5c1t9fCZcgUlt9We9+N2kD7xWudGw2iQzYsFFW3ZdNSoK3Gsv6wY/KtddAsDfUMwiT4HPsVx/CxAz3+eFk31wSae07wsKPhyQZ8WiIT1QqlQry6Aig5DTS77QILKe/4tY6GAsBritFXbrCDrJXF1YX8iz8XcGjI0rZKXUdsvua3esfh2RYHE5sWiMueNFaUwwyk5iAJZL6L0IfrYZJV1otZH3num0FQeCNN6rvrkWorGbiMQBtETjcjrq52Z2qKCNyBiViyapAX9NhV+IHEpSEiOkcWwYtC3qAbrWRmzHjZZdJWqM9t945q8gRHD7GLR3GBoG1rRj9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(6486002)(316002)(6506007)(26005)(186003)(6512007)(38100700002)(478600001)(6916009)(107886003)(6666004)(41300700001)(1076003)(8936002)(83380400001)(5660300002)(2616005)(8676002)(66556008)(66946007)(2906002)(4326008)(36756003)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5wKdRSFeYvDXlbfW8B4P/bnmHQziFU+yrgxJSagSdOH0j9vpmWRV6iVu+MGS?=
 =?us-ascii?Q?lZ6wrbRV3C2YzXr/U/mfzrVtnlAdwcC5Ys90o/0PoFx0i2vi1pAZ4ft8oxpD?=
 =?us-ascii?Q?I/H8vQKVi1xYVXW20sc1IL+WpzUOjXMl7nfCqAaDxU3HxKp5sF/MISjLVpC7?=
 =?us-ascii?Q?NMC6mmKO0gEMxFKVEzC0yotx4OQlZmvlrPxUY0RWlMPcvPPh5YAAJ2DVqBEo?=
 =?us-ascii?Q?uGQC+0FQVVm3GJlna+Dyq1rpWnCert8ScxVw1Ph+EZ0nBVJ0xZtKPFbqhLek?=
 =?us-ascii?Q?Hot4rB2jnpLvyzmmnfJ6FKUokw3NmV1gRNNnMppAGA0Rw7fk+g0dku1gj/v4?=
 =?us-ascii?Q?xed0ZofyKHKyvd+1z5lDO97xYNDgMlsIllcOKbuCb67sDnPMWzmFfmYK6Ed9?=
 =?us-ascii?Q?A39lO34EzrP75pFA5yz3j1o3KC+MsS/MtsKagijrSJX9laSRRhxbOub4BJKn?=
 =?us-ascii?Q?JZWR0oP7F23AYn2bxNA59fGkEG0TwipK/3GxOX9lhrLNNjle6SIhUOd/zhgs?=
 =?us-ascii?Q?dT1312L1JejZmUfwHiYu+oCVAG1FSEELnWJJZ1r4lOrMEoC55mm9hnFHFwkm?=
 =?us-ascii?Q?KuVTbWpUF30UulGvbq6BB/m9uL3npIssmjqdJdPwewbLWF/d8NLlP0WK8flV?=
 =?us-ascii?Q?BsedEfLSg9QqKUHDxFWRR6p5H1n50iJ9SEONKEs4k6SyfWR2u1QSBvcwk2Ep?=
 =?us-ascii?Q?cvOGNrfwVwuVs7ExcNFZCvB7dMm0T48rljW+oipJMwawQVP3xpFY2aAPM9hc?=
 =?us-ascii?Q?jVxopM1kc7TbMTtpD0yEi7ulBfd07H6qELf73AxtrKl8v5pl0Ld48RSsGStZ?=
 =?us-ascii?Q?Y3BR4TnZN/hvx77fqsC+TONdzD8+jr1A7wW8RknnpJxryfHy0mJT7giX25KN?=
 =?us-ascii?Q?aSuOeGtpHYmRgfgcYrSVVLDcIMNwfuLMxc75z8ioPXBGv3SVH7xzdC9/0ALu?=
 =?us-ascii?Q?ggG1/II+sI65KstPA4TcsGFKEhuFA9fDWRoDyn0XJEincP/FAkw+iKJ0vLrG?=
 =?us-ascii?Q?Xy1tsxLx+bJTCDtLWFE82gHZdnOjNZ5TxDThHd9oZDj5kA8Qu3VPxCOLLt5K?=
 =?us-ascii?Q?pQG3+qBxcj2tN7LL/5/q0ntAmOUnFO2GpMuZzyEyTn4bU4+Uzc3aV00A8EBM?=
 =?us-ascii?Q?XXfZ4S1uuumeJWxwd+2IWUxKOQvRZj6TeQuD/5X7WtYfLAhaj3kzB7cuR1bc?=
 =?us-ascii?Q?8oUoKBxcD9upybdaS+TlJEJO4uHU2R/NlDSVOfD7BGpYh3nXvnuVkwNmX24t?=
 =?us-ascii?Q?iiNEn0kdBYZjuBZuwB+uUovr/rECtU7LlAeiYlrUtEoL5O8sRXHaJWMI5faD?=
 =?us-ascii?Q?3Wkv/7HWDgmwPS3P5txg18mBbAN9DiXn7ajmUMQCuW4nQjGMz06sNWhSs8s/?=
 =?us-ascii?Q?/QYlBJL7Hjia4JowWUSvhdQWpewDAuZj5OkxBaIu6RltMEqbu5XUSdBryLpe?=
 =?us-ascii?Q?4Q3eS1HTTrWaM/I/x8QqqVmbFct/32op6wQNApSFK3niTUh3TlpkKfAT5XjE?=
 =?us-ascii?Q?4jF7d2Ulon8NI1mvDAE2TXMbwDrmEN8cvIeYE7IADV1zvT7tOQM3dkpELF7s?=
 =?us-ascii?Q?rRy7CvzAzxXTH9/6+koLMZqkfcvJUUBBKuM6+wBF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f748ca11-9571-4d28-78ba-08dadec57c2f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:55:00.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWMWwoM52lDpii31XzHxCQLgC0bptpLQCa5q41wtfQSWszuzlUPLz1yKeugt3c6FLxizThlbjrjHKu0OMEpTsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user space to specify the routing protocol of the MDB port group
entry by adding the 'MDBE_ATTR_RTPROT' attribute to the
'MDBA_SET_ENTRY_ATTRS' nest.

Examples:

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto zebra

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent

 # bridge -d mdb show
 dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode exclude proto static
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto zebra

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      | 28 ++++++++++++++++++++++++++--
 man/man8/bridge.8 | 12 +++++++++++-
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 58adf424bdcd..195a032c211b 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -32,7 +32,7 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
-		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ]\n"
+		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -556,6 +556,20 @@ static int mdb_parse_src_list(struct nlmsghdr *n, int maxlen, char *src_list)
 	return 0;
 }
 
+static int mdb_parse_proto(struct nlmsghdr *n, int maxlen, const char *proto)
+{
+	__u32 proto_id;
+	int err;
+
+	err = rtnl_rtprot_a2n(&proto_id, proto);
+	if (err)
+		return err;
+
+	addattr8(n, maxlen, MDBE_ATTR_RTPROT, proto_id);
+
+	return 0;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -569,9 +583,9 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.bpm.family = PF_BRIDGE,
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL, *mode = NULL;
+	char *src_list = NULL, *proto = NULL;
 	struct br_mdb_entry entry = {};
 	bool set_attrs = false;
-	char *src_list = NULL;
 	short vid = 0;
 
 	while (argc > 0) {
@@ -604,6 +618,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 			NEXT_ARG();
 			src_list = *argv;
 			set_attrs = true;
+		} else if (strcmp(*argv, "proto") == 0) {
+			NEXT_ARG();
+			proto = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -651,6 +669,12 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 						   src_list))
 			return -1;
 
+		if (proto && mdb_parse_proto(&req.n, sizeof(req), proto)) {
+			fprintf(stderr, "Invalid protocol value \"%s\"\n",
+				proto);
+			return -1;
+		}
+
 		addattr_nest_end(&req.n, nest);
 	}
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 801bf70c0e43..3e6e928c895f 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -141,7 +141,9 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " ] [ "
 .BR filter_mode " { " include " | " exclude " } ] [ "
 .B source_list
-.IR SOURCE_LIST " ]
+.IR SOURCE_LIST " ] [ "
+.B proto
+.IR PROTO " ]
 
 .ti -8
 .BR "bridge mdb show" " [ "
@@ -946,6 +948,14 @@ separated by a ','.  Whether the entry forwards packets from these senders or
 not is determined by the entry's filter mode, which becomes a mandatory
 argument. Can only be set for (*, G) entries.
 
+.TP
+.BI proto " PROTO"
+the routing protocol identifier of this mdb entry. Can be a number or a string
+from the file /etc/iproute2/rt_protos. If the routing protocol is not given,
+then
+.B static
+is assumed.
+
 .in -8
 .SS bridge mdb delete - delete a multicast group database entry
 This command removes an existing mdb entry.
-- 
2.37.3

