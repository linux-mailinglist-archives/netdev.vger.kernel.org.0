Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398BC374DEE
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 05:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhEFD2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 23:28:37 -0400
Received: from mail-eopbgr00093.outbound.protection.outlook.com ([40.107.0.93]:39173
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230225AbhEFD2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 23:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crLncw/krbPASJjzbZejTw4n3XQfWlFme5PFtc8QUoA0t5o6AcStZYyOpAlGd4V/+WZ9LVx+NI6IpSiFL4gY4xW6xDV/ZzsAYwE1yIQI9qRlmwEAybOfeTT8uJMp6x5OBvEZoB5FBvWux5bR1lRN3DC9TPaJrO/Zs+P4mWS1tKTwROYYT7WLyjmMF9yCdIl+NS499xDywEKP7N5NMqFZ81GO7czCMc8U07ug5NiIDsnX0qNocQ60/9t/tSU0rF53WWIWZxlY3C/2ymVcgq7xbAd76dNPHZZ9l7B1wOopUa6LI+Wa5YVoCGmnT+l5QY0TQyC4NFAsiBeigLq0ANN5CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3QEXgtmFt7BfXQkKvJBW+2Uurh5cFv17cYtMZDwH3k=;
 b=fuFV8SYYLKgr3+aI+W9/4UI82QpmaQ3QGbQr0KNztQT/VXc/q2MUL/6TPZSqeRqcJujalOMGmWEWworgBwMmqDMwqeFNuDSXeAXHMHDdvNWn09YOMCIpIzvk4fTEL5GmEmJ8Wff9GCW3lw7zc1foCFtS/Q1WS8ghfOFW7A/OYS8B9CARX8+Py+02O8Nk2yKNFQXNgjHjt7Z/MTtUVCfUCEH5GhBjRcSrHG4oMbOp6vRYojrGDs0eFacms/P501qGPRp00ykZ47BJwviET0R7qes2UtANAA1srl5bKoRTDeci3qnfALnxp3nPfrgbTKXUQ+zSgPbYj3I5JkCwrYOPjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3QEXgtmFt7BfXQkKvJBW+2Uurh5cFv17cYtMZDwH3k=;
 b=ErYa0nWeTIdXbKb/FlII1in8+7wkKkfII2US3a5xJWki3GjHGWB/76H3XcC9IpM09iQXhWuQFmUTbDGR1V3lfvshC3hSg19TymCZNuo/g//u55nWtXrCDnUjDm2dwgv94DjfjFm4nwz73X7ljACWKVw96vS0SjGjJxQ5XTZxXUU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from DB6PR05MB4598.eurprd05.prod.outlook.com (2603:10a6:6:4d::19) by
 DBAPR05MB7352.eurprd05.prod.outlook.com (2603:10a6:10:1a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25; Thu, 6 May 2021 03:27:37 +0000
Received: from DB6PR05MB4598.eurprd05.prod.outlook.com
 ([fe80::98b4:26bc:bb24:b674]) by DB6PR05MB4598.eurprd05.prod.outlook.com
 ([fe80::98b4:26bc:bb24:b674%3]) with mapi id 15.20.4020.023; Thu, 6 May 2021
 03:27:37 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au
Subject: [iproute2] tipc: call a sub-routine in separate socket
Date:   Thu,  6 May 2021 10:27:24 +0700
Message-Id: <20210506032724.4111-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: HE1PR0401CA0080.eurprd04.prod.outlook.com
 (2603:10a6:3:19::48) To DB6PR05MB4598.eurprd05.prod.outlook.com
 (2603:10a6:6:4d::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HE1PR0401CA0080.eurprd04.prod.outlook.com (2603:10a6:3:19::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 03:27:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4f3ea6b-d0d4-429e-af6a-08d9103ee50a
X-MS-TrafficTypeDiagnostic: DBAPR05MB7352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR05MB7352053B8C2BE9DA85092972F1589@DBAPR05MB7352.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RUJbwL4Tix7sD5Zty+RF8zBMSO6He50TdJCbyZkcpBBDCrMIJimJo3li3wri7qAKXx1h8ZQ4AcG1K9LLHJXn04SeAjSP3F4ZNOcAkyZoUSS+s9XZ2OvED4UHOc4pJ3+vrZARcLBEYgFXc+gClxlq7qwEoD63l2sOaP9DHn24iPY8JhKkYy0tQrHSkCP/4sOx+WeU6vUBruCkNszyTamAVBiiWPujTpzV6WSrwW6YpwjJFGbNmnM/WeZqClXfVArH7pxufKD/GJr9jwr5PmG+36YqvzjaQubn/0wJD+8mhFvjGuvmLoYk1UuIiHI5FAMA9dfH/sMkKHLwR7xjl8e76NXpHLTtO66WtsAqy2HiQYSj9ONnVTlitoWEl7d4hEarVeX0vfmxf63bx9FwMqjJWy60fuQ6pOqKpWCIKHTyj+RYy5/eqMZV0vJd4jQXPdMTI81X+OmdE6MvvBdDvNnjC2DrYVfnlkkjIijBMZjO6EDdHsYgQUzy9nxXjws6YnVb6/5W0IUR7GRZZrVZFpPoCt/xrc2aTe9y7H2eq8ztk1R70uYqWTUCnfdChzR9WNf8QT+eSkD2BA12IikJDLy86qMxednTB2MA+EhjQuFUJMKxowYEt2MF+btqJZmu9MAyJK8RC6BpUprYBfkwvbXHqBwVL4043qqha8WIqKynag0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR05MB4598.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39840400004)(376002)(346002)(136003)(52116002)(16526019)(38350700002)(55016002)(6666004)(83380400001)(5660300002)(7696005)(66946007)(316002)(66476007)(478600001)(36756003)(956004)(8936002)(2906002)(1076003)(38100700002)(66556008)(26005)(8676002)(2616005)(86362001)(6636002)(103116003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j/XHoZoKyQXzFYp7QKxdaXDKn1Hp8efVgxIVnJGcOIYQF6srLYf9yUt/38aS?=
 =?us-ascii?Q?gEH4v40HHc3NDHrt8DJ3AX1WL1su1ii2vfTOmz+bqQzZSAYo9gn41LG/0Qco?=
 =?us-ascii?Q?vj2mUUDqV44r4A4kCeX9WLJcmDTaVRwB/35jLQdSCa8rN0BrSxmBBGRgqzFG?=
 =?us-ascii?Q?QbFX/lJ/TgGGhbi6qxHlMZjHT/YpppT4ssO/4o3ahaFvWwAHKQnPwHh6sC/y?=
 =?us-ascii?Q?GW4CApB/pmt65EuAzWSnVkcI1Cb5na1zZ79APThWnF6hXQb9eZQy+04RSYzF?=
 =?us-ascii?Q?IZuKYEVwQ28FEqv4gmnIjS+n81Q6hHM3nkFiPZ9R/FBrLrToTzx5Y6esYzk5?=
 =?us-ascii?Q?UnVrX4vb922IWS25X4A0riRNBYSbHKHZS0E0lybQlbuC3HRg2PKhIlc0z98f?=
 =?us-ascii?Q?McsoznZ25addg41nkJoJQn10INUzy2y9cd8JTY05KRlwG04iGKo5as4+q3IQ?=
 =?us-ascii?Q?pncCzPsUhwAWS3nvF8hfBqPY6TWXVwo/mbusHWFfcQGRugVb3TCjHfvVEa7R?=
 =?us-ascii?Q?3tSmow5DoH+WthP9k0FhCqPoyn7rk/+09ZlnsI56kxa/ZlMlWT/y6pMMLf+h?=
 =?us-ascii?Q?1uoaE9OagsfcrTxWE0LIlhslvsRCNkTaak5lVW3pgM1I81AGUT3AS/H2gDux?=
 =?us-ascii?Q?pY54nmtVQCfy5ooMIdJxtxTNzVt9Mvp9gX5jDSWSa5dRZChgvwBmbhCcyfcN?=
 =?us-ascii?Q?9MgiwLoq7zc3bvK5GjmRLNEGYWfvG2DPDxEcSElaYXEzrFiB7aTl0GmTTNDc?=
 =?us-ascii?Q?GggsHM28t33XIqvZUsb3br12Tzyop9JoJqA+ZXzyNW1go8n2Mph4FIjoDXPs?=
 =?us-ascii?Q?YpnSkH5L4BuZDBhvEYdxfAPcC/ejN3xm/QMsOTghw/M2cyGTKrlPcHkpr6l8?=
 =?us-ascii?Q?kdcTL1aUvuoyJXAeaUWitFKimf/knRpsYT9Bj9Go+6mVkytEY6tW0pyJGeoK?=
 =?us-ascii?Q?3691cl/eHnyTDd92o46ZyF9blPvWptNPpKnMzfqJX8I+VlAMyRMyznHDiDTe?=
 =?us-ascii?Q?jXaUFFu71JxoeMnwwPP68KvrvftUXJBRJxORche2e2ykeAuvgRheXcxbysBS?=
 =?us-ascii?Q?zZg0iWdF0XLaOkcXJs5YyiKLBWzOv0gqQIA0YMYMzoS1c35H+j1xH+7m8VF9?=
 =?us-ascii?Q?0v3L6vyMyxSV7V7YiOOBNI0xEw+KnPDLiRmNMKDi/U+61CWCGp0yrSbZnvdG?=
 =?us-ascii?Q?1yiAt3Xq/P5y1yFMPb8Hc3PK94waf/T4pMHQ205p9wPuJW/H5nYqWzmTDvBd?=
 =?us-ascii?Q?BURwuOqzn5Wl9xju6atHeyElkgZvV4d6ZlXP37BBCdFxtiUInSOdkRVae5vd?=
 =?us-ascii?Q?XkMq+Sh62R7eicbqNjMk8QJm?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f3ea6b-d0d4-429e-af6a-08d9103ee50a
X-MS-Exchange-CrossTenant-AuthSource: DB6PR05MB4598.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 03:27:36.8134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vp5x+tOaXyrTZcWMV7hn4Fr0Y2wql67NoKPJLJwlgBVUxbHI41WKHfoWdsItr+cPyGf6YqRjOj6R2yR41THcW6C0XMFpt0br+cY9Kc+VgpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7352
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a result from first query to netlink, we may exec
a another query inside the callback. If calling this sub-routine
in the same socket, it will be discarded the result from previous
exection.
To avoid this we perform a nested query in separate socket.

Fixes: 202102830663 ("tipc: use the libmnl functions in lib/mnl_utils.c")
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 tipc/bearer.c | 50 +++++++++++++++++++++++++++++++++++++++++++++-----
 tipc/link.c   | 15 +++++++++++++--
 tipc/socket.c | 17 +++++++++++++++--
 3 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/tipc/bearer.c b/tipc/bearer.c
index 2afc48b9b108..968293bc9160 100644
--- a/tipc/bearer.c
+++ b/tipc/bearer.c
@@ -20,7 +20,9 @@
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
 #include <linux/if.h>
+#include <libmnl/libmnl.h>
 
+#include "mnl_utils.h"
 #include "utils.h"
 #include "cmdl.h"
 #include "msg.h"
@@ -98,16 +100,28 @@ static int get_netid_cb(const struct nlmsghdr *nlh, void *data)
 
 static int generate_multicast(short af, char *buf, int bufsize)
 {
+	struct mnlu_gen_socket bearer_nlg;
 	struct nlmsghdr *nlh;
 	int netid;
+	int err = 0;
 
-	nlh = msg_init(TIPC_NL_NET_GET);
+	err = mnlu_gen_socket_open(&bearer_nlg, TIPC_GENL_V2_NAME,
+				   TIPC_GENL_V2_VERSION);
+	if (err)
+		return -1;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&bearer_nlg, TIPC_NL_NET_GET,
+					  NLM_F_REQUEST | NLM_F_DUMP);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialization failed\n");
+		mnlu_gen_socket_close(&bearer_nlg);
 		return -1;
 	}
-	if (msg_dumpit(nlh, get_netid_cb, &netid)) {
+
+	err = mnlu_gen_socket_sndrcv(&bearer_nlg, nlh, get_netid_cb, &netid);
+	if (err) {
 		fprintf(stderr, "error, failed to fetch TIPC network id from kernel\n");
+		mnlu_gen_socket_close(&bearer_nlg);
 		return -EINVAL;
 	}
 	if (af == AF_INET)
@@ -115,6 +129,7 @@ static int generate_multicast(short af, char *buf, int bufsize)
 	else
 		snprintf(buf, bufsize, "ff02::%u", netid);
 
+	mnlu_gen_socket_close(&bearer_nlg);
 	return 0;
 }
 
@@ -794,10 +809,35 @@ static int bearer_get_udp_cb(const struct nlmsghdr *nlh, void *data)
 	if ((cb_data->attr == TIPC_NLA_UDP_REMOTE) &&
 	    (cb_data->prop == UDP_PROP_IP) &&
 	    opts[TIPC_NLA_UDP_MULTI_REMOTEIP]) {
-		struct genlmsghdr *genl = mnl_nlmsg_get_payload(cb_data->nlh);
+		struct mnlu_gen_socket bearer_nlg;
+		struct nlattr *attr;
+		struct nlmsghdr *h;
+		const char *bname;
+		int err = 0;
+
+		err = mnlu_gen_socket_open(&bearer_nlg, TIPC_GENL_V2_NAME,
+					   TIPC_GENL_V2_VERSION);
+		if (err)
+			return -1;
+
+		h = mnlu_gen_socket_cmd_prepare(&bearer_nlg,
+						TIPC_NL_UDP_GET_REMOTEIP,
+						NLM_F_REQUEST | NLM_F_DUMP);
+		if (!h) {
+			fprintf(stderr, "error, message initialization failed\n");
+			mnlu_gen_socket_close(&bearer_nlg);
+			return -1;
+		}
 
-		genl->cmd = TIPC_NL_UDP_GET_REMOTEIP;
-		return msg_dumpit(cb_data->nlh, bearer_dump_udp_cb, NULL);
+		attr = mnl_attr_nest_start(h, TIPC_NLA_BEARER);
+		bname = mnl_attr_get_str(attrs[TIPC_NLA_BEARER_NAME]);
+		mnl_attr_put_strz(h, TIPC_NLA_BEARER_NAME, bname);
+		mnl_attr_nest_end(h, attr);
+
+		err = mnlu_gen_socket_sndrcv(&bearer_nlg, h,
+					     bearer_dump_udp_cb, NULL);
+		mnlu_gen_socket_close(&bearer_nlg);
+		return err;
 	}
 
 	addr = mnl_attr_get_payload(opts[cb_data->attr]);
diff --git a/tipc/link.c b/tipc/link.c
index 2123f109c694..9994ada2a367 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -17,7 +17,9 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
+#include <libmnl/libmnl.h>
 
+#include "mnl_utils.h"
 #include "cmdl.h"
 #include "msg.h"
 #include "link.h"
@@ -993,13 +995,20 @@ exit:
 
 static int link_mon_peer_list(uint32_t mon_ref)
 {
+	struct mnlu_gen_socket link_nlg;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 	int err = 0;
 
-	nlh = msg_init(TIPC_NL_MON_PEER_GET);
+	err = mnlu_gen_socket_open(&link_nlg, TIPC_GENL_V2_NAME,
+				   TIPC_GENL_V2_VERSION);
+	if (err)
+		return -1;
+	nlh = mnlu_gen_socket_cmd_prepare(&link_nlg, TIPC_NL_MON_PEER_GET,
+					  NLM_F_REQUEST | NLM_F_DUMP);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
+		mnlu_gen_socket_close(&link_nlg);
 		return -1;
 	}
 
@@ -1007,7 +1016,9 @@ static int link_mon_peer_list(uint32_t mon_ref)
 	mnl_attr_put_u32(nlh, TIPC_NLA_MON_REF, mon_ref);
 	mnl_attr_nest_end(nlh, nest);
 
-	err = msg_dumpit(nlh, link_mon_peer_list_cb, NULL);
+	err = mnlu_gen_socket_sndrcv(&link_nlg, nlh, link_mon_peer_list_cb,
+				     NULL);
+	mnlu_gen_socket_close(&link_nlg);
 	return err;
 }
 
diff --git a/tipc/socket.c b/tipc/socket.c
index deae12af4409..597ffd91af52 100644
--- a/tipc/socket.c
+++ b/tipc/socket.c
@@ -15,7 +15,9 @@
 #include <linux/tipc.h>
 #include <linux/tipc_netlink.h>
 #include <linux/genetlink.h>
+#include <libmnl/libmnl.h>
 
+#include "mnl_utils.h"
 #include "cmdl.h"
 #include "msg.h"
 #include "socket.h"
@@ -44,12 +46,21 @@ static int publ_list_cb(const struct nlmsghdr *nlh, void *data)
 
 static int publ_list(uint32_t sock)
 {
+	struct mnlu_gen_socket sock_nlg;
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
+	int err;
 
-	nlh = msg_init(TIPC_NL_PUBL_GET);
+	err = mnlu_gen_socket_open(&sock_nlg, TIPC_GENL_V2_NAME,
+				   TIPC_GENL_V2_VERSION);
+	if (err)
+		return -1;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&sock_nlg, TIPC_NL_PUBL_GET,
+					  NLM_F_REQUEST | NLM_F_DUMP);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
+		mnlu_gen_socket_close(&sock_nlg);
 		return -1;
 	}
 
@@ -57,7 +68,9 @@ static int publ_list(uint32_t sock)
 	mnl_attr_put_u32(nlh, TIPC_NLA_SOCK_REF, sock);
 	mnl_attr_nest_end(nlh, nest);
 
-	return msg_dumpit(nlh, publ_list_cb, NULL);
+	err = mnlu_gen_socket_sndrcv(&sock_nlg, nlh, publ_list_cb, NULL);
+	mnlu_gen_socket_close(&sock_nlg);
+	return err;
 }
 
 static int sock_list_cb(const struct nlmsghdr *nlh, void *data)
-- 
2.25.1

