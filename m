Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DACC4C0CC7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiBWGus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiBWGur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:50:47 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABE46E286
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645599019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FOiz53udsAO5Ixsj+2pEay2qh39q2lWPP75LTQw+TEw=;
        b=j4MVShYLnkmjaaKAca26ZFDuqTHFh55C1Dm/64yD/jbo8qniKUmSd9QwX4gaSzz/qIylNB
        oyNu1BxSSTmedIgcJQEwJ0pa0KJTTemmTzjxLqyz59PAzeJrBbqMyiQMyMwTf64W1gAteW
        18Md6zqn+lnJPgC8Hok/GOCE3GKth4I=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-kPRCISqIOj6sB5yuCwfznw-1; Wed, 23 Feb 2022 07:50:17 +0100
X-MC-Unique: kPRCISqIOj6sB5yuCwfznw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9g+TnbMOtvKwDzYSQ3QMvxpZxGAzN2uQfZjH9JuUaYbmDEiEDrqi2emIR7Sm4wbChWo2Fco/U7teMe9qTya2m3iFBkzdwYhE2UarrYqZwcSGzSufZW11cJpkIsbeJ9cSBYn2OLPciYKHWtg2u7VWKu5/gieSZsDg40jbhyzsScsDl8dqYYRBR6bYN3ZBKm4QpZ1gDAkXQaV1npvZxBH88jtJdAffa2o0B9XHdye9Dj9SsTdY60gwwgakyBbdoCWbSeyiIY/7LjQHt1X6GD3NeYBS8P45960pB8uuSDbbyOho6037rGiIOQTfiQ00TQuu8Eidh+LYp0qb7Dgv2AS3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keAT9dbX5v6/e3rLu0ICirtktJA/LOZfZdPYTlhmmdk=;
 b=ENBeeR2ZajMhmdEEBaEhzAMcmFU4A7ZfF/9jcP/ZySsuJ+mDe7zErODGwRj101mZuJpzqqeMQ44zABaYoA6Y44z5JVcH4kj2YhiQTopIrMdNFy703M27pdOCHB+8oF1LGnLmFwYMARca3ephoU/QCc4f1hYC2AWMX+VQA71zWqp47Bw7Ct5sQKL+fRDOIeR7tNst4VSPRJRewEjJznTOfYvYndWkKSm2mST4oCKP4EBALAnli3vaDi6Wb4eX4K48grGcgAScK7WLcCCmLZFWWt0JSEnYNF0TrcqfS2VYWOczQmzYoMvC0oHNtNSu9E7OKg4OF980nJ0Q6SkSLakCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR04MB3290.eurprd04.prod.outlook.com (2603:10a6:7:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 06:50:16 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 06:50:16 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v3 2/3] mptcp: add fullmesh support for setting flags
Date:   Wed, 23 Feb 2022 14:50:38 +0800
Message-ID: <fb00a0803b7244ce39bdc32a10d3d47053809565.1645598911.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645598911.git.geliang.tang@suse.com>
References: <cover.1645598911.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0024.apcprd06.prod.outlook.com
 (2603:1096:202:2e::36) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53111552-94ff-4d6b-fbb4-08d9f698bfb9
X-MS-TrafficTypeDiagnostic: HE1PR04MB3290:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB32902B949F609F1415A1A576F83C9@HE1PR04MB3290.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+C8rKpupRlYGIqlyI8LLJKslFKj7F7Vx8mSgBynBeTACfbFYMAvdjZCLOxbxFkbhcOj+UqfCftZNAI4PYFewt3BZP7LNw2m9/bLXj4Q0Fz9CAtTiW728ZESqZ08bbBUerkj9BvStJZBlcBb6wWNqln3wbkoUq2VcQ+tLqPpiDuknfhq/UBD83ILafdI4927+eHh/pfM8WF0k45V66v9LjYUjOBgdFy8wMt7I495CpbXd63RIlRWqqdPTFL3BXF+ROgUklXq3ZNG+haXxjnY6xEf4hFTWiTqcXpXNln/GDfMXHYiHLxDWdKC7ExuapQCmYdxL/Gc30DGQfbJ3P0uiVuwRoSHHyoiLBwS42uXUP49mQ+8wAc1J/mhe+cttO+cURUDiFmBZ40ECcQHvEysdz4Xqf58l1jXHF4I9Sha6prWlJ5zweVmD0NAz3dnYr/Qkw+8eP9stWW9YUlZ/japisafdmiD+s6tWzA8ufGYhLIZWOCPOFXIh54QZYKjnZgUqptYMQbK0zDwTHiyAqPZtdcVWlN0lHXiP17ebaailmEQkfqwjghBi3CIjisSMeYiDGqanT74WNBKUWvNLc73iLtipUgStdPYRaxuRK+Gg+DprBa00VDONCyXDNoPlcpxmXWM91KviG5xMhiaLGWO4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(44832011)(66476007)(66946007)(38100700002)(86362001)(4326008)(5660300002)(8936002)(2906002)(36756003)(6512007)(83380400001)(110136005)(186003)(26005)(2616005)(6486002)(508600001)(6506007)(54906003)(55236004)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bjn7oICOIX+k9h37QsaeGWYFMPt6wx3LFX0S6ZibcM+zmgOTwF3yM7o3fghP?=
 =?us-ascii?Q?qH23oGDjLJg+8KEDNolZl3vXxy/xbFD8nYpah+M7OovUfHfwrahjRYu2CRn9?=
 =?us-ascii?Q?4jzIgigtGZ7DnPSUozARFMmFSvwasgF4+nyk6xQaeeAaWo8JbQ6qOUdVwjlb?=
 =?us-ascii?Q?LAw4/Mes6QlvP9nhnjjAVB7dJz9osunLg9aZIe/NljxV+UK/k1O+hvLO28vw?=
 =?us-ascii?Q?pVOhKou9FGle5rRlrqD3pNQCtXxMa9c76W031GXJLXhyIN7m6/gq6AB8XAIz?=
 =?us-ascii?Q?kR1/QBwnmg89x9xr0GInaWbXO0SgQu/jlMB/t8WzVyeiBZZWFPZNcAcKeBBG?=
 =?us-ascii?Q?+HlreD7Rbs4y/9XbZEhzRHkjCuBUrgQSn0SBUNESw9uaUnL1bbwxrxW8XlY8?=
 =?us-ascii?Q?ViCaEnleSDMZBfNPqXP3auLJ7fI8p5p2j2OGBQpYuz5sb3DbEXGfCXUA+PMd?=
 =?us-ascii?Q?vi0f25ENqEj0YVeLcQcdgvg/07zoCohWKyHSatdrBM9jI5Qxo13+iwwblu8X?=
 =?us-ascii?Q?/z5WjcUe47KYDkk+I5MxVT7E43u9agDtuPrmCNCWvpgq+Z8wElD6heAYbRsR?=
 =?us-ascii?Q?wXRBZjS+qbp6BagOkSbnDE9jiOee1pJyDOm5pbkticbimF2tgA5fuiBz77cY?=
 =?us-ascii?Q?1vLgtDjKWJLqPjBuRY+1tXXMMQFYYOQmtFghjI7O3LNarsotvAHWXgnoyV2w?=
 =?us-ascii?Q?wRPjn7zophX250NQudZCwlXM+xMRuC+3BsUwJWvxxfDsnOPcZk9gESm4Ac93?=
 =?us-ascii?Q?OAMIF3Ms4685DpBd/90itT8bmtzKb/JMOa4G4hj736Mmnw6ZpOsJq5UgPhtE?=
 =?us-ascii?Q?75wlhyGjUFnDFS1LSeVy9R8u0emqS1TRL9XZjB3xjJBBUS+ULRML0deON58F?=
 =?us-ascii?Q?+TK9G97oCYAeKU5QXHW0G9v3s+8r0CxIMHQDg3VcL+c37hxFATSptAh+KIkA?=
 =?us-ascii?Q?pQVx1ZSAWtODJxrFKvtM6JQ3/wmp5QRLLzs/K8CxgkQZiCgfbbPGeqtqA0BY?=
 =?us-ascii?Q?2BciFfY6Q3U/MJnJJxinOCRv6YVmXQj/eO1/Uk13MxZcs/alFANY0Wevo7iv?=
 =?us-ascii?Q?sDvOfNia4nCmCRJXNG7oHQ0kkYdMsC1oPp/wqt147v1B7HeqnbpLRicXuCae?=
 =?us-ascii?Q?VDZWyIe4JpIUEnE596iff2p8UzBwS1neVGV4aPFMKVhtovK1fmFDBMQyqXM7?=
 =?us-ascii?Q?zKRrO9p0UJq6wZQwUf1EakS1JeIWe1W4vRxonAgWCiF3LFcQQDZc8hoqEgvu?=
 =?us-ascii?Q?gbI5Gnqoyi1J1++x9apTHRoOjIbpwlXPUksIcVT0t9bGZjnLj7GxirLk0tff?=
 =?us-ascii?Q?1Wkq7TndwWqTIU83xWBdHRfzceXaBUmYR3vWQxA6dAHfKUGniLlv5n9b9/HI?=
 =?us-ascii?Q?z9u+nTUkoYOPyTpIBN1gRrATNidkhxPsHofEEvIShdAf3WgPlfvGu4eZsWPs?=
 =?us-ascii?Q?UId9Ajq8SacANBFP0uYgIN2RN+W79kArb23vIcK1RGyGOIA6T+7yy4OxkfQI?=
 =?us-ascii?Q?VMAeg5EqLwZjocfPJsr6GTHmHza+yBGz+wxTpDP+kvKDfr8+Ypa2gw6kn5tI?=
 =?us-ascii?Q?9APizHDAR/gO1DtTyRxj6fFr0zeKBpMLgcEi/wYmuGsZ9f6hQ6F8Flt6dKMj?=
 =?us-ascii?Q?RlhJ3ZA/g/ROC8UMtAAB3Mw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53111552-94ff-4d6b-fbb4-08d9f698bfb9
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:50:16.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpzouTvi40f6coDdz5Nopolmk9J6AaTgoD4qX5GiVYZsqJdpJq4Dqb0ceZW7vl7Rq2TkZ2SNNVNaYXi+PWZtdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3290
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A pair of new flags, fullmesh and nofullmesh, had been added in the
setting flags of MPTCP PM netlink in kernel space recently by the commit
73c762c1f07d ("mptcp: set fullmesh flag in pm_netlink").

This patch added the corresponding logic to pass these two flags to the
netlink in user space.

These new flags can be used like this:

 ip mptcp endpoint change id 1 fullmesh
 ip mptcp endpoint change id 1 nofullmesh
 ip mptcp endpoint change id 1 backup fullmesh
 ip mptcp endpoint change id 1 nobackup nofullmesh

Here's an example of setting fullmesh flags:

 > sudo ip mptcp endpoint add 10.0.2.1 subflow
 > sudo ip mptcp endpoint show
 10.0.2.1 id 1 subflow
 > sudo ip mptcp endpoint change id 1 fullmesh
 > sudo ip mptcp endpoint show
 10.0.2.1 id 1 subflow fullmesh
 > sudo ip mptcp endpoint change id 1 nofullmesh
 > sudo ip mptcp endpoint show
 10.0.2.1 id 1 subflow

It can be seen that 'ip mptcp endpoint show' already supports showing
the fullmesh flag.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c        | 20 ++++++++++++--------
 man/man8/ip-mptcp.8 |  8 ++++++--
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 5682c7df..c7b63761 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -25,14 +25,15 @@ static void usage(void)
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
-		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
+		"	ip mptcp endpoint change id ID CHANGE-OPT\n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
 		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
 		"	ip mptcp limits show\n"
 		"	ip mptcp monitor\n"
 		"FLAG-LIST :=3D [ FLAG-LIST ] FLAG\n"
-		"FLAG  :=3D [ signal | subflow | backup | fullmesh ]\n");
+		"FLAG  :=3D [ signal | subflow | backup | fullmesh ]\n"
+		"CHANGE-OPT :=3D [ backup | nobackup | fullmesh | nofullmesh ]\n");
=20
 	exit(-1);
 }
@@ -46,7 +47,7 @@ static int genl_family =3D -1;
 	GENL_REQUEST(_req, MPTCP_BUFLEN, genl_family, 0,	\
 		     MPTCP_PM_VER, _cmd, _flags)
=20
-#define MPTCP_PM_ADDR_FLAG_NOBACKUP 0x0
+#define MPTCP_PM_ADDR_FLAG_NONE 0x0
=20
 /* Mapping from argument to address flag mask */
 static const struct {
@@ -57,7 +58,8 @@ static const struct {
 	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
 	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
 	{ "fullmesh",		MPTCP_PM_ADDR_FLAG_FULLMESH },
-	{ "nobackup",		MPTCP_PM_ADDR_FLAG_NOBACKUP }
+	{ "nobackup",		MPTCP_PM_ADDR_FLAG_NONE },
+	{ "nofullmesh",		MPTCP_PM_ADDR_FLAG_NONE }
 };
=20
 static void print_mptcp_addr_flags(unsigned int flags)
@@ -102,6 +104,7 @@ static int get_flags(const char *arg, __u32 *flags)
=20
 static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int =
cmd)
 {
+	bool setting =3D cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS;
 	bool adding =3D cmd =3D=3D MPTCP_PM_CMD_ADD_ADDR;
 	bool deling =3D cmd =3D=3D MPTCP_PM_CMD_DEL_ADDR;
 	struct rtattr *attr_addr;
@@ -121,10 +124,11 @@ static int mptcp_parse_opt(int argc, char **argv, str=
uct nlmsghdr *n, int cmd)
 			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
 				invarg("flags mustn't have both signal and fullmesh", *argv);
=20
-			/* allow changing the 'backup' flag only */
-			if (cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS &&
-			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
-				invarg("invalid flags\n", *argv);
+			/* allow changing the 'backup' and 'fullmesh' flags only */
+			if (setting &&
+			    (flags & ~(MPTCP_PM_ADDR_FLAG_BACKUP |
+				       MPTCP_PM_ADDR_FLAG_FULLMESH)))
+				invarg("invalid flags, backup and fullmesh only", *argv);
=20
 		} else if (matches(*argv, "id") =3D=3D 0) {
 			NEXT_ARG();
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 0e789225..bddbff3c 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -41,7 +41,7 @@ ip-mptcp \- MPTCP path manager configuration
 .BR "ip mptcp endpoint change id "
 .I ID
 .RB "[ "
-.I BACKUP-OPT
+.I CHANGE-OPT
 .RB "] "
=20
 .ti -8
@@ -68,10 +68,14 @@ ip-mptcp \- MPTCP path manager configuration
 .RB  "]"
=20
 .ti -8
-.IR BACKUP-OPT " :=3D ["
+.IR CHANGE-OPT " :=3D ["
 .B backup
 .RB "|"
 .B nobackup
+.RB "|"
+.B fullmesh
+.RB "|"
+.B nofullmesh
 .RB  "]"
=20
 .ti -8
--=20
2.34.1

