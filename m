Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB74A92C2
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347848AbiBDD3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:29:00 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:24357 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236970AbiBDD27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:28:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643945338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9r9i5mOMAYjZQuVmuXUBUuLKn7dYeIYNRCd6MKcfQdE=;
        b=DbrysoIbkoQRIbfK69UNr9stmgrQ+wa1C10xafVCdBg9R/777dGYmBVFEVCc2Y0qvc6C/m
        TgC9asJlFRVDUFvRS1dRZ/+5+erua81ZPFfXf61GoS3+bgq4u4b29ucT+B66YJUy5M6Hv6
        IjTltC/YT4K/gX9wp4FBm0qmpaEXUf4=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2110.outbound.protection.outlook.com [104.47.18.110]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29-G-KJItXhNYq56n6v4iRe9Q-1; Fri, 04 Feb 2022 04:28:57 +0100
X-MC-Unique: G-KJItXhNYq56n6v4iRe9Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyHfa4NHk/YpGNqKMA+SuPMLWTnhREeJbr7vl7R+bLZc6DvLCQMtsJ9zJYdPHU5HAClgBjb0cWPSiCT2NE9ae9U6omnJndZwPUA+bPdU32L02v/GINkYj9ifJHommpUtoZYRz51/prW4DXtwiKWu4PiXSNcaqx6rkp1tLAMHuwkB/P060lR6L/1bCKYNV9wRvZCN/xCWF0C6uhZmcYmM4XxQghI4I9HiBkIBrcUDrFsPySGRkNX6HnYkZM9TpnbKMw8Nv1qU5LyyzB6irlhqN1eCf3j3KQHqq5x8L3RmaClz7CmLUndJ1AtgKoHMAmzzCMj/WDEAEFlK9NWVJnSjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H33OFHGfDQ2DXf7+X6w0GkZcvoFBDL1szERuPsbfm8s=;
 b=dqhT9rTZHaDDkfKgD3bimrws7o9c4+g2vKz0rAdzaNSIfL+auLqJJ487ACfA+ksFNtRUEih4V103Z6TVjprhs4gKIbcGO5kreSfxtLOwpAsXSBYtcMOeMfdUqSfyz+a8gbMIJwWT4pRXRzWrwGrhyhO4p+Y5BYfA5lcsXaNlkCzZr6SYQ3FoGAFVDABKF6lrb5Xw19UA+7mOQ7esrF8BrKO1e5vcuW9Jq/Wgz2OYTG9D3td63fjo9gLD5RPHdfBsik6IwJPh8Cc+56Udb2m9Go83KCbe2IYZCPbSx7cBrgwfBb7BeiHAkqz9Odzq5MRYrTuOgxlwd6GKYJax4CO6rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by AM0PR0402MB3713.eurprd04.prod.outlook.com (2603:10a6:208:d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Fri, 4 Feb
 2022 03:28:54 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f559:5790:2983:dbff]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::f559:5790:2983:dbff%6]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 03:28:53 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
CC:     Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next] mptcp: add the fullmesh flag setting support
Date:   Fri,  4 Feb 2022 11:29:03 +0800
Message-ID: <49c0f49f6aabf0f55a16034b79d30fbceb1bc997.1643945076.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0194.apcprd02.prod.outlook.com
 (2603:1096:201:21::30) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c65528b6-eea7-4266-6f39-08d9e78e77cf
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3713:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3713FE6D7C6A0E7BAD68EACDF8299@AM0PR0402MB3713.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNTr2ZOsZox9BYWCoQiqrXU64MxHIEbYZfZXJ3XtFOF3NqG7h0p5W2Ih47g5GsxhMHrAvmG+wGuqxX2r8SUCmBi0W2BUikch/JdYx3oLg9U2PT75QoA0Frcl6xKafPHFz7DgS9uVS2JEAZ+yWlyfIxI0cjT/DtE3NxsYSpA6Q9JsBx1eN232QJWS70d0b6HKsvlPJCsUWpQmiXR3Q3z45kx+4cevXJJUyqsa4DhjFtwEQQH84tXGxASyouBaQ5na1iMT1kdFhg7aGxHVXJbogknOecQ5vhpEQugujaVx2XGE9MyXublVQkrp9UkcvWbJ7r9+9bfligqAjU4PmVENS3eW5ysiybpz0XG/nqz+c36ObNIal8+vcyUQbUhZ6oT/wdsXcyWxVAEdkzkcnuoK9wd8YhVb9BIePNV7RpF8kev1iW5H/tNPBddrOoDh0+V2t4fnhTwqSyIsQqBvP9uPvN33nPmHqxEzahYWAaV1suQCtjJHytryTvar2/1runjb/AFnOARBBV12y3LJ16Mmca4cO37iYQnboOMIqC8xuFCcDJRlKgYjg2eCzted+LmZL5xbTvZMT+Vi415egBpHNuOFlNHJAfBbZIM7Rbh3a7Ap320zjLIDyocN8vS4dCpx5NXT331ZqwyE6cGVFyVJqGTm6L29YlAF6ZtvKR8rGb0Yok6y/hhIeBxjFi58yZvg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(54906003)(26005)(186003)(86362001)(36756003)(5660300002)(38100700002)(44832011)(83380400001)(4326008)(66556008)(8676002)(66946007)(66476007)(8936002)(6512007)(6666004)(316002)(6506007)(508600001)(110136005)(2616005)(6486002)(13296009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C/GOKpGBfDLJT8A5n+YO358AUHqvDB5gQKc9w9Kf8yklFF4sz8XRTxkp5LHb?=
 =?us-ascii?Q?0RlE8asblnaG2uAjX2w87LHmhlrA2ml/5sYDTgtibvcI6fX0s6G22e8XeHDB?=
 =?us-ascii?Q?Ir0d1J11AhUz5BaqXKpBc+FhNJIGayQEpsGWHmt6cUdhJtzusBNNnPsvTBJn?=
 =?us-ascii?Q?0mv9YYWQw9IFincrLRlGYMD7H8LAPjaZ/r/bszS6t3Uqi8Twn678v4YtIfeV?=
 =?us-ascii?Q?rwJawzkQEeN01Egtr9Irs/HRlYGweIAWTIJTG5rESPXnNkK6ssN4R5ZkECDf?=
 =?us-ascii?Q?w1HfB2CdfbFFP4DRd6kNLmeSnT+Ig22bz7I1HMI7w4PK3i2ggwVJFJBDTEWg?=
 =?us-ascii?Q?JeV/3TBkngbDe4MczUI62TJJPiKCChyApBnC42jYoCu29uGMPiD0HVxz3Qsi?=
 =?us-ascii?Q?OmNINPyeAFA/PXL/O0iued5S4XniYiB0Bq/Yrd2MKJidE+cPYxZOH9PrecvH?=
 =?us-ascii?Q?PZ/Cngr18vtPq53tdYvGf7w/3HnlusI62CjHykAQ/7se6o9cqt2XuYzAM44m?=
 =?us-ascii?Q?e2XoSI2aMETy63bJInrIIfdiyWsSHkZIvVHaKS4aVd0EhaP0iB9Xm0/w77lW?=
 =?us-ascii?Q?8Yr//GcmyLA71hSnJtZr/VXmF+SGuqPXl0gHJQu/bWXwEew4p4WPYNecfbCm?=
 =?us-ascii?Q?71UodxP9HE2JzSOd9zoGx7/4j/EWbD2fOUvH0x7mAWtqE5HyJTU/EIwzX1w5?=
 =?us-ascii?Q?9P6rliFtRdwkqLac5mPyF+MX/lxClaNiXPtN5XDfVpipF1PeT59OyUXi7kFf?=
 =?us-ascii?Q?UiidflEIvWpeXHCHgVVFynv6SXAVg1Mj1OmRn7157/zDPmzSXWryP19dwQLD?=
 =?us-ascii?Q?rNUB3lrjWuCA+y7z2UZMA9Hd+UY7J9m9OMmSnFqWTGmNBRQEAlCosFHFnkUz?=
 =?us-ascii?Q?S0Za8K3oALB1//vyZuVJADM3jOOYPWpwY8K5JsnSRtXGuG3VL6PeE8Sbd9dN?=
 =?us-ascii?Q?FHAgSqDIHl8aSGqGZrDWJ4PYeF//fijDVTAc+ga8U6JrYkdvyCYHtLEvTZ2n?=
 =?us-ascii?Q?/4YwhJhuIZTHqYbcd4+mE25cIOoIdrRyFnBegsEUKSiRmeTir50NMQcYmVM5?=
 =?us-ascii?Q?HgPEIJRhjTT3Os9682YpayH/IIynZsnOanP5jCRZGgPaSKMOhZvETAUM8AuK?=
 =?us-ascii?Q?N2SF9XLZPZXyUbnl5wXFiSTtyn35sS6nw9vFZHIjZFsziZChVsGKvKl9Tipp?=
 =?us-ascii?Q?JpNtUNQPab2CQAe8vlnast8HvPl+RxjDNuzHU4eAz/jlN/Da8fZqNGrGjIOz?=
 =?us-ascii?Q?e3lqWypIini9/+0byPezBQrcJZzCTneQ0v2c11eHdto7g7GyJA6G8X5ZbE4k?=
 =?us-ascii?Q?2sviucXRQqY/tvSC6jK0cK7oSgpQY/Gf1Y5c1PuouURHLCtxa1Ue4RiTQjx2?=
 =?us-ascii?Q?Qkjf1w+IWq3P/pvmW82vvkhrjuOQZU6/jgcp3DaUzLjkHZMClRbfJGko2PqR?=
 =?us-ascii?Q?LIFNErtLuzUOgMjAv6mFnbOqjD1gwuFmoWJ7/LttfzNXsKEAw0tvpMC9f9V7?=
 =?us-ascii?Q?C02nAU5q4SjQgqJKBQoa6RavE+iZmdIrzM40w9C1cpUTckvbwXlMM3DsKIwn?=
 =?us-ascii?Q?dYHRAYtVDl5acy5xJ0JyqNmYN2v2EIP3MTOWUJ97WURcmHi0aUxqvf1yPoeU?=
 =?us-ascii?Q?OmvlaZIb+J3ZBkTpId0MwUc=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c65528b6-eea7-4266-6f39-08d9e78e77cf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 03:28:53.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0Od+yZX7WV0qnF4HKhRN5GecfuQvsdAqur1KQbTx3x3gNXWOSrQQQeRDdpq2VsUgnT3736FVaQfOrfqxFZQnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3713
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the fullmesh flag setting support, use it like this:

 ip mptcp endpoint change id 1 fullmesh
 ip mptcp endpoint change id 1 nofullmesh
 ip mptcp endpoint change id 1 backup fullmesh
 ip mptcp endpoint change id 1 nobackup nofullmesh

Add the fullmesh flag check for the adding address, the fullmesh flag
can't be used with the signal flag in that case.

Update the port keyword check for the setting flags, allow to use the
port keyword with the non-signal flags. Don't allow to use the port
keyword with the id number.

Update the usage of 'ip mptcp endpoint change', it can be used in two
forms, using the address directly or the id number of the address:

 ip mptcp endpoint change id 1 fullmesh
 ip mptcp endpoint change 10.0.2.1 fullmesh
 ip mptcp endpoint change 10.0.2.1 port 10100 fullmesh

Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c        | 26 +++++++++++++++++++-------
 man/man8/ip-mptcp.8 | 17 ++++++++++++-----
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index eef7c6f4..efda7ef2 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -25,14 +25,15 @@ static void usage(void)
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
-		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
+		"	ip mptcp endpoint change [ id ID ] [ ADDRESS ] CHANGE-OPT\n"
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
@@ -116,9 +119,15 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 	ll_init_map(&rth);
 	while (argc > 0) {
 		if (get_flags(*argv, &flags) =3D=3D 0) {
-			/* allow changing the 'backup' flag only */
+			if (adding &&
+			    (flags & MPTCP_PM_ADDR_FLAG_SIGNAL) &&
+			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
+				invarg("invalid flags\n", *argv);
+
+			/* allow changing the 'backup' and 'fullmesh' flags only */
 			if (cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS &&
-			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
+			    (flags & ~(MPTCP_PM_ADDR_FLAG_BACKUP |
+				       MPTCP_PM_ADDR_FLAG_FULLMESH)))
 				invarg("invalid flags\n", *argv);
=20
 		} else if (matches(*argv, "id") =3D=3D 0) {
@@ -166,9 +175,12 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 			invarg("address is needed for deleting id 0 address\n", "ID");
 	}
=20
-	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+	if (adding && port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 		invarg("flags must have signal when using port", "port");
=20
+	if (id_set && setting && port)
+		invarg("port can't be used with id", "port");
+
 	attr_addr =3D addattr_nest(n, MPTCP_BUFLEN,
 				 MPTCP_PM_ATTR_ADDR | NLA_F_NESTED);
 	if (id_set)
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 0e789225..72762f49 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -38,11 +38,14 @@ ip-mptcp \- MPTCP path manager configuration
 .RB "] "
=20
 .ti -8
-.BR "ip mptcp endpoint change id "
+.BR "ip mptcp endpoint change "
+.RB "[ " id
 .I ID
-.RB "[ "
-.I BACKUP-OPT
-.RB "] "
+.RB "] [ "
+.IR IFADDR
+.RB "] [ " port
+.IR PORT " ]"
+.RB "CHANGE-OPT"
=20
 .ti -8
 .BR "ip mptcp endpoint show "
@@ -68,10 +71,14 @@ ip-mptcp \- MPTCP path manager configuration
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
2.31.1

