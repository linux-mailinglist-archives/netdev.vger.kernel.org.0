Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8A48F35B
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 01:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiAOAKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 19:10:21 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:58774 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230211AbiAOAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 19:10:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1642205419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ykliOT0ztmaJCjg3qBeqAc+afqzrb7w/rnQWYbVID84=;
        b=CoI66Frt6jvkfBSt1JDIIzpFQ49R4ndbpNm4bREmBBpB9QOGnb/2ENpvrf1IqW969g4pkC
        4HxrnscDynV61CoD5KdMN9zqrvt7lbZwOnCDdA1vOeXDDwv4N5MjMIH7sn1yD9CBElwS1J
        Q+1GTSIVBQo0n0eY7dqNBhSDwhB5510=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-W-UWW8-4M0mhKApgo25VJg-1; Sat, 15 Jan 2022 01:10:17 +0100
X-MC-Unique: W-UWW8-4M0mhKApgo25VJg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBtoH9DQ+Ccv9jw+MhhpSAtCn9G+tk0s0g37pguMb7EiWZdp8xeS3JB/oMmQKG0ORi0xMOIz6b+XXLFq7wo7DuTrkAYEzRTQK0z+iF0wPeduOK4G0BMgPkpB+ua0k3OUGPfqh1i/Zv0iOfhS9nLCQWy10m+Fo8Ftu+ywRdl+/sLktwygGZllpv26X8vEfX0NVgRE51V+xjRQzCJRTVWBODKGgFp2bcRGS/yKV9G4c8CE2hcVjxiBVmVlRJqO8Vsb2UB7U8EHvthlYFjkosGV47/IBD/i6nwE5QKbYh7I5GX0+pqf4iEpktQw3TPZ9dvP8SezSLOrPwWcJfhcH+ALhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om0XGuUEq/WoaprrFx/b6dVmdManAo6BealY5Ld9FbM=;
 b=V+VHm7Lx+ML32YF1f+mU+tXQjUhUISMtbzru8dgsCsJV9H7oDZMASSV96Rqcb6Ec/AgJHzO8I8g0Sp0UOtCNreIXz78PMP8lO5OxyDJcgh634PFBax9L1xqphoF8TRftHjxnA8iz2KSOY24KvduOM6/7SopDwNx14/M15xAz6XKAP1WVu08FqXV3d2D+sK8j5MR2pFMcv5xlMNz0U/DwSzOSUCM9Y8Fu/IXSWxa9mn6Qpv4tEk3muIykfamg5WDxTyxAQfeeFJMhKY21JY9LwOWZ+OALnF0PidFs8pvIRKYhFoMGyPjjPX7T/XmGfbM0K8CpWOjHn+3WZUfpyqm8Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR0402MB2732.eurprd04.prod.outlook.com (2603:10a6:3:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Sat, 15 Jan
 2022 00:10:16 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879%3]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 00:10:16 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     netdev@vger.kernel.org
CC:     Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next] mptcp: add id check for deleting address
Date:   Sat, 15 Jan 2022 08:10:09 +0800
Message-ID: <0e01aafaba6df6ff7adf255999d64259d7ae8d50.1642204990.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:202:16::12) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77ba56fd-ba83-4410-db4f-08d9d7bb680f
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2732:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB27322262B5727196B1371BD4F8559@HE1PR0402MB2732.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6JIXZz8UvRr41pCeqnikpkk9NtO4jy078Ew8WV/pVbESj2Vdx9FqOVC52hz4dU7SgDpZKu0JJMlvF7jZ0n0HOdc1L3pIIJfX2QpYbM0Zu26cdpC1GeaCsV5x+b4EI1+v9hh8R5HtV2CdW9iMdI4Hyqykcf6WU/MYLkTiGLHDucbAMprKRr2ea/25/b78RTC3SAx6zkbtwU6RCIRpUn3mEjHc3/vX27wIMs9BLH0pY0GSRO0qSEtQtqgWL/JujpJgI4eDLRkDs1eVOfgeVXHdk0idYuUJovSfyRZmNK5ou4n+wICRaxS85nhpc4dnetHIYIIBuo7tXfI9jf1ArXVhsNbi4pzRu8+wggiK95Jcou4A89i5k+/crc/KwdvrMt9XGElaV1Dut+Po+M9sgvsoLXyD8QGazu7w7fMHLzz22DQbSde8evW/T9QG8UTY1975prAWbhC9P6AlYaf8A/V2jaUzjshXMwZMppfi99M9n3HfDtkt803H7n/dJr2DpMMariTcZrn/5Bv9p9mm/Vq+JUa5R+fS41Q4lD5U/8oxOiHa9JaeSz532LdhdjHWWJaKupy0VGVnabcmsWsjB60KXtPzbNYDU9Kdyhrqp1YYT7gYRc8+ADBB70kZXnMJJDPtJVMSn6Ro3EhAwH7lY/e3NTVrWH7qwE397Vy+cfrBbuVZwdonNk6ApFe3h+Cecyvc22mryuxsjFDGEobzEk/JPisvgMzqAYPlhI5hbH2rFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(66556008)(186003)(6486002)(44832011)(5660300002)(966005)(36756003)(6916009)(66946007)(66476007)(2906002)(6506007)(316002)(83380400001)(38100700002)(86362001)(6512007)(54906003)(6666004)(4326008)(2616005)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EYlcmomZjoiT2sajRaXylplh/y3RntcwpN5XCeYrL7Fpo9Pjg7rltmZeEUyZ?=
 =?us-ascii?Q?0q5I10yQ6vzJO6llfXVwHRrbJ/XKuxDvc2g8l/eyoTXUR22C/6A6odgT8X4A?=
 =?us-ascii?Q?pVbUU0+LvhF+2YFFvY/HYO1AuXcpYop9bBKVdxh7fl8ObYzmNG1WywqA/TO0?=
 =?us-ascii?Q?Zn3FNzUSA+nE8p36gnNPdsUMsrCzf/asPc/v3RRK6NGYuVzx3Elh2MPgGVs6?=
 =?us-ascii?Q?IhjKg5oa22PAidu7JqCOO1nTYWM7JAGhvL9mBjlZlNLw2BQkOG5b7SmfREXR?=
 =?us-ascii?Q?10+Cy8/jU+iOUgYsJxngJFPxb5vxDkcG86f8+lSgUC/WS9FYF6ZhNPJRiHOR?=
 =?us-ascii?Q?x1dyQYH+JFEZ0u/bZEUqbgehbHD8bQWQW7Jv1XG2lHTDAhd057B1QH6rpPU3?=
 =?us-ascii?Q?shgpvVyNEXmAeVkBso/oSTg32ddds/BZZXG5cXG1LAOGxU9Ns+xPb0Bfr1N6?=
 =?us-ascii?Q?XO06SXRzITYfCaK5Ri21ge4Ryd0upF5nEsdHHw3TBnkr6OgdPR6g62l2qwXm?=
 =?us-ascii?Q?Sky0MfZiDpTKH5evWBaBUGd90qMCY1jPojvSHCFzA8fn2dpK6JOCWEq7iucO?=
 =?us-ascii?Q?YhvwJTrvQU4sp3O0G1OAAlymISMRjIMLWa/wO4TnYhS6oI+JsM9PgKGNKLFO?=
 =?us-ascii?Q?67Q7eWBBSNM7JvT6TieE81HdotlELcd7TieBI5EfW29i+oqlgLgkQwLxw+bn?=
 =?us-ascii?Q?ksefQGO1VEKiJ1T5hS9p/5rm+mhC0O+Vi8qyyRvqhYyO+rhmsmk/TBCtS1HG?=
 =?us-ascii?Q?Vwad/DQlTut03IA4QymkG8TweIxAyJT0FRRauHL4FVqgYXJIVAFC1IARSWcF?=
 =?us-ascii?Q?pTkNXtE9JDp32zfvQLUL8Hz/1YFRhlrrl7Xz30DrfK1QCcrtrOqyR86eLzkE?=
 =?us-ascii?Q?hjUxq+GMPluGYMkHCL0cSahGipd1JcUM+6M1FJ3vOdmssX6YSykmckO7w6rM?=
 =?us-ascii?Q?aG1Lv+jMMdCxqdX/vTj/RnmZ5DJ/y9JvLFs437nnEqXjj5igno1u51D4sv5J?=
 =?us-ascii?Q?Pz0crMH4vRxP3kZseJtBom0z4pM2BtdqoI8WSixd15g1bWWhgQJL+15trc3D?=
 =?us-ascii?Q?mp17XBBwaXYtjduMKUoA2OAPqe8VKcKii/ho/8kq1bstzvOkEzWVLehV1I7l?=
 =?us-ascii?Q?BB1YTZD/Ag24f4ozaCRyAj9aHrP80X5HVHkp22Sj6yvEc7MeC7PtNSTmDWFo?=
 =?us-ascii?Q?Q3hhKXjhZRPbiyPpCdbOEjzpUmcFjju22rkrZMY+36CKJCaMs44nXLozIbpE?=
 =?us-ascii?Q?DAxkQ3PeMgP8VC5d91L0ylanPmZK1nSXuTW1PZgOcwnCqxX7Z470evc76kus?=
 =?us-ascii?Q?NIDjFQ+Wg/PDAfzhIu4DKbhZbrX8z8PvdHSnx1MD7vSMcxTCs5wU60Xs6PgI?=
 =?us-ascii?Q?wDAE0g7bzOsXAmTVIH50+K2WFPlhMPXzr7qhBlw7IKrjh2UNEPjvKckg46lH?=
 =?us-ascii?Q?CYJycUBgOA3cBy6vXkNn52ncOFpYOX9r3C7S/PRinH48Brv1gOGZEKRSlwEj?=
 =?us-ascii?Q?gwAILqxGpn8j+C0qiuxbPPu9dVVohLQr7BhuJNRDQCQcjMq90h4x0pXCybFk?=
 =?us-ascii?Q?nU5/yhOQgsqBMf8oe42DNTkQ8rjqgoLY5Rf7Z4dGgI0XN+hw2zokMksd17tt?=
 =?us-ascii?Q?Jd78bIKdo4j7gZGY78BF4VuAY2TVgu2Yf+JirEDDHv5TwJfEg9+Lh9BRJ31X?=
 =?us-ascii?Q?sScvnN8ED5spqeAwWzPGQOfh3bA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ba56fd-ba83-4410-db4f-08d9d7bb680f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 00:10:15.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1aca2cCobXP5c2/O9tqcaZiFJmndKnLKFqhBHxd9tB41sretKZvYuNqwQ7Y04pJhS6tIu88DvWYcVzRA3oKdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2732
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the id check for deleting address in mptcp_parse_opt().
The ADDRESS argument is invalid for the non-zero id address, only needed
for the id 0 address.

 # ip mptcp endpoint delete id 1
 # ip mptcp endpoint delete id 0 10.0.1.1

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/171
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 ip/ipmptcp.c        | 11 +++++++++--
 man/man8/ip-mptcp.8 | 16 +++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index e7150138..4363e753 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -24,7 +24,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
-		"	ip mptcp endpoint delete id ID\n"
+		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
 		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
@@ -103,6 +103,7 @@ static int get_flags(const char *arg, __u32 *flags)
 static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int =
cmd)
 {
 	bool adding =3D cmd =3D=3D MPTCP_PM_CMD_ADD_ADDR;
+	bool deling =3D cmd =3D=3D MPTCP_PM_CMD_DEL_ADDR;
 	struct rtattr *attr_addr;
 	bool addr_set =3D false;
 	inet_prefix address;
@@ -156,8 +157,14 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 	if (!addr_set && adding)
 		missarg("ADDRESS");
=20
-	if (!id_set && !adding)
+	if (!id_set && deling)
 		missarg("ID");
+	else if (id_set && deling) {
+		if (id && addr_set)
+			invarg("invalid for non-zero id address\n", "ADDRESS");
+		else if (!id && !addr_set)
+			invarg("address is needed for deleting id 0 address\n", "ID");
+	}
=20
 	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 		invarg("flags must have signal when using port", "port");
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 0e6e1532..0e789225 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -31,8 +31,11 @@ ip-mptcp \- MPTCP path manager configuration
 .RB "] "
=20
 .ti -8
-.BR "ip mptcp endpoint del id "
+.BR "ip mptcp endpoint delete id "
 .I ID
+.RB "[ "
+.I IFADDR
+.RB "] "
=20
 .ti -8
 .BR "ip mptcp endpoint change id "
@@ -107,6 +110,16 @@ ip mptcp endpoint show	get existing MPTCP endpoint
 ip mptcp endpoint flush	flush all existing MPTCP endpoints
 .TE
=20
+.TP
+.IR IFADDR
+An IPv4 or IPv6 address. When used with the
+.B delete id
+operation, an
+.B IFADDR
+is only included when the
+.B ID
+is 0.
+
 .TP
 .IR PORT
 When a port number is specified, incoming MPTCP subflows for already
@@ -114,6 +127,7 @@ established MPTCP sockets will be accepted on the speci=
fied port, regardless
 the original listener port accepting the first MPTCP subflow and/or
 this peer being actually on the client side.
=20
+.TP
 .IR ID
 is a unique numeric identifier for the given endpoint
=20
--=20
2.31.1

