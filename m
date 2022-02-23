Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984B24C09C8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbiBWDAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiBWDAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:00:11 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC86D53E21
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645585182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h74JOeVSl8oOoWOAMazqdffP0RbIFhqoE9rf4wX3IPA=;
        b=M45w2hNwzDYEKttaLC9I8VZfEpP5W2eBsQQ2rdVOIYJAOcagoFuQjAkYGUUpdVqF9n/OgK
        E6k69Nv30OlRzn5clgzMMFPYFfs2EkMAu1rFRPoRWeCis2nyR1BLPnTxFmJWk5UCYUATP/
        xrX76+AKcmLkhTGAEv6N0fp441Vg/+4=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-14-GoJZbsfVOqSl4U8v0Y_Q9g-1; Wed, 23 Feb 2022 03:59:41 +0100
X-MC-Unique: GoJZbsfVOqSl4U8v0Y_Q9g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6HqKd2Aq/zgVpUrFTE0Kf3F9MYlH1FN+jhYn9lgT1Jd9toZAhF/5bDBOBeRorhZgA0zgKCyI0LK1lI7M5Hmk9zdamKpNDR9tnP3RfmVo5ZO1B90EDhNy5CV2SBwarTPrDqxoTozXO1pOD85VIh5vgPgd4jPcWJQmOM+1h8ibnpb9/iu8u2Dtku60YslR35nXRElWWyi7VAIR0sLn9P33tHTRZgxOhcwVvLZFTfr1Q0iJv7RMEb7RMCdFT41SdtTXeq9GS2V+mX/auideOUzsB0bEsh0avlNhpPWKpEUzXlxZlo8BlvizymE+t57fo4q2WYt+A4nmipWEedWChQ7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uzzGQzCnq3kLAYLSS7hRNekC+wNsuFLK9JcO7Fz+M9c=;
 b=gmZoKFiZ1fnixo1mJG2biTYpKS1bRytFNfl0G6KOSDtpUu8m7nVXSuDSPDGHKzsS6hvi2XpjZMnXYEJYQpfmtjUofFWwefrBRn8iswVfHG0HUEEtrzgmELBHDcrvVEMpzo3BToPkZcAaPfqbNkubPspNi5pHmp+flLpY2FuuEsB7OL7y7Hbp8hQdezk4Dhc8X0okb2HwpotBcuQ+qpYV1aUZgi2bM+xegBSM6itqnRJ0R4Cf7JpI4reUlY5BgwfcnJ2tC1C4geheAfW/ZzhCrJC5HOnMK5VLtSV6NS4a8r54GF/OfijJVLU2NDgYSoThGM8zyEw18rapd3HyU22Log==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DB8PR04MB6362.eurprd04.prod.outlook.com (2603:10a6:10:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 02:59:39 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 02:59:39 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v2 2/3] mptcp: add fullmesh support for setting flags
Date:   Wed, 23 Feb 2022 10:59:48 +0800
Message-ID: <66b764a16aff656947eafac2fd37b55a549a5afc.1645584573.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645584573.git.geliang.tang@suse.com>
References: <cover.1645584573.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0186.apcprd04.prod.outlook.com
 (2603:1096:4:14::24) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e475dea-0201-4e6f-fe85-08d9f6788844
X-MS-TrafficTypeDiagnostic: DB8PR04MB6362:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB6362F535D1FAEDF95834E434F83C9@DB8PR04MB6362.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pyGX7kA+9zPZOLsvOptYtegZBzP1Bqv9qaWz/qaAIVSli/4ii6lcWfqnCtYwUC69S6/1nKv60af+utOWcAom/QgmFX/85y7j+VjuRx+ugHb37V59Z8Fh8LDa31hHomfd4ztN2p3TgI5o4NzIt9Sc29Y0vdsjEpCTa3m7LYeHQx/mhzoDBxBv+aMSIX8XR67yvx4lE0BNXJ9vYGnc3xcY4V0b5TPlsX4itvA+j+UP/1wA4WLvj5bHIJBIODOyodzNODa/fyGMGdeMsa+TYc77+Ieaf+UFftWlZltBDHkyTHMNr91Fxlzp/cxhxh1SrFR89NDRohi7j00oe6bFamO6xPGkUxPX5waU7Tnbd7HSffQwpXaaQKPWquBYUx/lfUGQ50hq+xNmxPAQXn0SCZiextuLN+lNreZ3ySOxjNb7MdQ36ULCxooZHqh2htrt/Yvv1kes1QZJRw+hut3AxvZyGCMarlku0OGV3bcBkqOg07uuA5t8u9PbgTiDXPxxbW++ZAjLuMb3KQWMfsTg5tqg1xw6sJCaV/aLglHseNlKlqagVieqgsYUOIoJsg6680Hpqnhw4EetlOOqK1blTwfZR4AJ+1Q1wFyD5R7kMuOIvnFMNpM877ncok9U6l6vZMjI6b9odgBPVgrsE6KvMGeUaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(316002)(5660300002)(6666004)(110136005)(86362001)(54906003)(4326008)(8676002)(66476007)(66556008)(6486002)(8936002)(508600001)(66946007)(186003)(26005)(83380400001)(2906002)(44832011)(55236004)(6512007)(6506007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U1DGbwlWTlxOifr9G3l1BSxsCfB0ocD+8QfE2EtUBqjOcLUoLBuXWze/zzP9?=
 =?us-ascii?Q?vKwYoIS8aahPyXB3TH+9KbhlF4kEtu38VtcXDuKqIVaoD/LtAHWofN1wbGZd?=
 =?us-ascii?Q?F7PRDauffSJOqQ7r/FAkXrEQEAAjRKR3namHwuqrCF4l7eF1G52Tl2jBuclJ?=
 =?us-ascii?Q?WtMnOxmhcv9a2OXpnmfHHSMKqkfUyLH9EwTxrlfj3n8BmULVPL59RffKSenR?=
 =?us-ascii?Q?edwrRVd8JHwZ6lVWd7q1GBlxChZdW6Gk5kdta2bs3Rzi1WGtwrnfQfHnbBxC?=
 =?us-ascii?Q?gKkkuIMmFQBPALDWYL1Kjql82CEoQtZw24GEzPpWgmYB2MMg1rijQy0r6LRb?=
 =?us-ascii?Q?qnElqURRPrafdK3CDholcxxB3WIDenwBaBNUCOGHmLBRq78AI6kXLn11y29h?=
 =?us-ascii?Q?qS0/0J6htSko8FUie82OqJC4cjL5G2JHu0i4dsJHtcYPyw5HH439ifRsK5Cy?=
 =?us-ascii?Q?EPYpRaG6+dQYtC2KVbmBgdFt7w1khzp29G8BTGV8hgbdmTxh1znb8a0ebf1O?=
 =?us-ascii?Q?Uh9wDITs26xKm9SYqBEPjOFfvSxxGcpHB3xsJWvg57Asmtk3LDKiElJiE9NH?=
 =?us-ascii?Q?DXVhWQNGn8GAbWXK73yrBM36z+rOJn74s/2S2FjalsLubmqySfLXW+XRkJDK?=
 =?us-ascii?Q?aYDEJD8FgjqRZ07wDGjlPwxm4At9jvKJIA1+U/mCgseiThyf06vsEgy05xN5?=
 =?us-ascii?Q?4qRR6kOpRrYEfHi2BS09/YZ9iaYY2xQh5eVsc6KL8/PQBgJ5+AU2BgNd9QfB?=
 =?us-ascii?Q?YWOG6b/oZY4tUze4hFxK500bXX23CUM3UssBYXcjp/ufUzwKKLZaukb+KDfI?=
 =?us-ascii?Q?ak8VEH9LDyMrhViR41J6NXWC488iOffTwzJ9wqy1hDN2VGln/jUgPSyavHdw?=
 =?us-ascii?Q?i+8Ps5EBmwDeMp1SArEFQxoSRxxWO7CptN6QL+GsmYz9jYZMk4EA9o9sd3dJ?=
 =?us-ascii?Q?qVzgl4N5YwJCdqFierBx0ME8PiHxZ7FlheJRPkJKZnMeSBEG6puze9hLARJx?=
 =?us-ascii?Q?uIkrKpVLqp0W0JCDY0BGdeM96Ih7Lx19Pskrnur3GjdylRzMBDr6EwqVtE39?=
 =?us-ascii?Q?hRY9Eylz5CGvLNh9S5LzVBS8KPLJXZX/855p3TsSHTsFUKqVocacGXjTJsXF?=
 =?us-ascii?Q?8ZWiskLW96I0zdjQZDxZ2zRLLVZOz9a+mZflSq5X8qm+m81MVVDCnz7VK8W7?=
 =?us-ascii?Q?o7Uk7M4697KNNhMLQRFMWXKwlL3mlv7CYwMbBzhpWny2ilyXhqsYBeSAprL4?=
 =?us-ascii?Q?IpShB91kPPywB0e94VQAfgQnmo29KSzem45xVUPH7b1+O5xAH8WaPIDQClm5?=
 =?us-ascii?Q?sWtl2xw43WV6DNV19EUPk9I8Eiolewfe4HbL5xK/pn/edB1EZJdcIQbEuZ8p?=
 =?us-ascii?Q?XmC6FFUtBDnTvhJHMF+N304v0YeIOaL1JBFi6ReqjYvKq1D+OJRqsu/9UZik?=
 =?us-ascii?Q?GwSYfFSfsxvR3KmeBybNq/+7eVb1d7aDdB7Wth7q+tQaGip0/riZNuJzkU+f?=
 =?us-ascii?Q?L9bBsebVcOM+01vZchV+ywIoLBJ+VJ3KyuPRxhnDlwRcbN0ThDuL0fPKiA84?=
 =?us-ascii?Q?Klyr9+bCY/IOxVPUf639Gz5TTgxQBjagppLIKUS8ablUrLBPHuQez5tUjCxl?=
 =?us-ascii?Q?UeUWHA5/CBet4asr/HhnKis=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e475dea-0201-4e6f-fe85-08d9f6788844
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:59:39.4554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAI7q63nEf9eurroItPDjSQ/s+I2WF9WILzg1lvrfRc5mm0ph0iBwS8upo+9O+oq/nVx+kd/E1Z8MYS/hC9pVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6362
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
 ip/ipmptcp.c        | 18 +++++++++++-------
 man/man8/ip-mptcp.8 |  8 ++++++--
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 0b744720..247d1caf 100644
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
@@ -121,9 +124,10 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
 				invarg("invalid flags\n", *argv);
=20
-			/* allow changing the 'backup' flag only */
-			if (cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS &&
-			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
+			/* allow changing the 'backup' and 'fullmesh' flags only */
+			if (setting &&
+			    (flags & ~(MPTCP_PM_ADDR_FLAG_BACKUP |
+				       MPTCP_PM_ADDR_FLAG_FULLMESH)))
 				invarg("invalid flags\n", *argv);
=20
 		} else if (matches(*argv, "id") =3D=3D 0) {
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

