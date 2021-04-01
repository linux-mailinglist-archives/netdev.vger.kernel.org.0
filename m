Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8E1350CB9
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 04:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhDACet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 22:34:49 -0400
Received: from mail-eopbgr130110.outbound.protection.outlook.com ([40.107.13.110]:48291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229497AbhDACe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 22:34:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZ6gEGpGGHYQDZlP/Zkz87cUk61nz3WcTBYM23dOCr9GTKPcjFvpUeg0UE8CoEj5QuJH5z14Rs354rIJbIg+YvR07dK6Qq5q0HcXlpcxuvQzH7TLrGnp0VteY5EkW2I58dHIYjWS9qJatFOd4lwyRIx6wVfywwdRHjLSEKhUWvtS3z9GcaZCNopWTOJz1ChEYr/+mPRHDAOJc/AntxiHsd2ul4mp/8w45nntVaHaQ/MEeKN7B8+eh7C9f00zUj2AnNEHF58p2ElCyIA45y+FMUEzPDW2kadLcEjQDdUPnBexBhmn7EtRPfrR6hehCwBCY2/jdheYBqaVCV8XaYUCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Djafhpbj2eolLtH4PRdoJe4Hb0ldUb0hT7V/M2As/dk=;
 b=IrVguOBuVkPhwx15vY6HnHXiZ6sf1vqIgPu0Kxl6AIinmvxL0Ix5qPDT5sXL29Gl2fjD8XNOfexqU3xw7fiiEBe/2+4TtDt/jWk0ImagfyZhmmDCzcEw50CKOp/Vy+IHfFXTVhqWZmjKo9EJnCaUe8Z+X9/pr5gVZ92pHGnR8uujwiJT2OZtFvOfPMFwngtFGgyGb2xcGMNO8DUIlolNaOpYewDnUG7l4F6v5fAAQYnMXesknnF0HD+aZD2APeAJB7ksytixj9IDqJeiOHrO+lq0JzSBeAfAzFjeXMxJBtuYLT9SadI+b4725TgbKNMbRRonNJB4lSC7tXAtgbY8RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Djafhpbj2eolLtH4PRdoJe4Hb0ldUb0hT7V/M2As/dk=;
 b=QPEDO5M0J+Q2KgpwM5XDmz+bw5XhXET5fejyILaEbeCroZ0AX+wNpoJ0Iwxfi+xc+tmOjldIs94J0pa8RttAex9UP6F0Td+GkXqS+RmLFN9GL+J6TmTeVl9k2kPGPuvxJoBTpT3LmP6e9F1w2VSnDXSaMOHjqutGO1xIr6g9CSQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB3231.eurprd05.prod.outlook.com (2603:10a6:802:1f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Thu, 1 Apr
 2021 02:34:24 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%6]) with mapi id 15.20.3955.024; Thu, 1 Apr 2021
 02:34:24 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
Subject: [iproute2-next] tipc: use the libmnl functions in lib/mnl_utils.c
Date:   Thu,  1 Apr 2021 09:34:09 +0700
Message-Id: <20210401023409.6332-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0150.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::30) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0150.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 02:34:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b3b172e-54a6-43e0-7296-08d8f4b6a980
X-MS-TrafficTypeDiagnostic: VI1PR05MB3231:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3231C60E64561AE5B9D365BCF17B9@VI1PR05MB3231.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcRuoO/6Iks0dBEzqygaQ/lFi1bQwO9QV1utjectkZoXWBOuDf+VQlmed5In9SRtIqpeZoGYCETkZWW5/JcXu3M0cAfQ2epc4fRGN7AZMarnuZDr3/oppUrbO21k1dwubKKAU5OaSDm73RSZXKeWLIFB4ekp/Vtjb8ipIKzL+bcThBGkjqvhTKXdYOGv3WW1QFbRSvzLh2ICNV/HvtWc0P9z29OIjC6qTWvyAW0yp5ZOF4sajcO1hhk3+BMSrdrXteTRxFpBerZfBRmzbGauoIkFkujPa2l1zGeB/2FgqjznxoszISAwRTkVNFRyxZ5gwPNHjvpWdacqLIo1nbAsG/vklawUnvHPDWcHlMdAZrheccfDJBYqeUB3yneFVFb0JN76qCQs5EzdVUtuenOcdhSE1ggaM6WcDhUqWOgvpajVBmV6ckQ3Y8dVbG3wqnPbY7/UCDFrq8J1rrxNN+FgVgJAJ2nOwng+gHZPHb4XLCy59nFA1BZ0Km+bKsXhtrm2yf9U+NOAhm+KIc8sJQGPpV1wnD8dqRS0qugT54O2jrhi0X3lwkCu7duFdZuN3bwXXWckAQdwSAZate4ib+m2KuV0qr3JHYKPhOkbJnVuoSC8hzyl1XFjy84eCLUlQrreEg+8AFCtQmyn45r+HhVt9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(39840400004)(366004)(186003)(316002)(30864003)(2616005)(16526019)(86362001)(38100700001)(26005)(7696005)(2906002)(52116002)(55016002)(66476007)(66946007)(1076003)(66556008)(956004)(6666004)(8936002)(8676002)(5660300002)(103116003)(36756003)(83380400001)(478600001)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?K+iG8XyJp2AalqnOLTzhQLDFPQPBTa9TxRIYhVfB0mh/4fss0IDRYWMf8+H9?=
 =?us-ascii?Q?4e29BfhHaqyKP0wbOnwfny9NjMHof9lJxhkH2bflkTWyCqpLG+kx8iirmjTD?=
 =?us-ascii?Q?mn4BLkrcgIBDJbhmXJcFlGz0up/C74T/gqToT3WqUzkS+5jc6vgWDa22HXOl?=
 =?us-ascii?Q?Is6udrwQ7IGsVii6/B3G94omnHBAyVAS9eoR/x8km/NFOtxuz+cCOgUlL5Uh?=
 =?us-ascii?Q?+3Bg2B2XyG9gOaky0ofMlhhdLHwierM1yLozCmLRIDJUDgxZM7WkaVRAG5Ti?=
 =?us-ascii?Q?UBFHlSa2PWWiXxossChlGLKPI3PboqNHx8DhqJPtSwaAWx9gtPfcnuYAQsvc?=
 =?us-ascii?Q?umaaCcA5ZLkkb7qAbjfyR7cd4gAsItA9CRzCpPy8qhqYdHui1E+t+kO7mxRD?=
 =?us-ascii?Q?pyTRmAbMuE5UxIrFxLhaFCZT/SWgBODhtgKRm+S0iQZmxSDPWIarG/HGwBgn?=
 =?us-ascii?Q?+t1uqP8Uq98uacraANXbybnVLAOjZi/kMY+xxbTQT3igFvfBUbbAicSwz7g2?=
 =?us-ascii?Q?ufvqW6VmHyg3wBy3p1lMcyo2ZYAJ30n1CHAfA6s4hcjgT0wAi2/PxK5obJGw?=
 =?us-ascii?Q?86JUUBJQjKlrpHYlriLkMvEb1b3mubMXQ8tTfMxprn2z5HmZIaRYOhfC0ff6?=
 =?us-ascii?Q?t/ZkYHKJKxmxxlbPBpXF3min+dcrvq5YYSkg2bXmspIqAaSGlx/M89Bs58zm?=
 =?us-ascii?Q?ryVir6XFtOJNjxfKQrMkXZ1Fnu+vx4BUZaGewPXyqQp0p/TYPaVnLBHmTVu2?=
 =?us-ascii?Q?Vcq1O2CmG1lK+Mrlo9tEcw4kKRbJ5AfLi1/+p1xGq6hslMfLOdCJAjy5gjgk?=
 =?us-ascii?Q?E78awEG/ou+yerIXS5qXXhmWJ6Z4yH6MVS1u1oFtt1Rj3TOFwnbDITneHj7g?=
 =?us-ascii?Q?a21GGwu/PEPDMOjhD9w74xV0DucQfZ87cedTj5oUhRO2oNo6nTAHIPl/defH?=
 =?us-ascii?Q?0sgO2y2qhrqt4+LWYRxzw5SWK+VPibE5+L24h7PHs3HEC0+4XzPFWjQTFExv?=
 =?us-ascii?Q?q/iBz44c2I8pFVztsZN13m2jw268KOQEyYsp0XmTSJ9LC5J3xPXVxGJm0LAu?=
 =?us-ascii?Q?fuGkTafrbKdttNaQGHQCMIl4LAvEqwOsXPuugw1f80bq53VxDlVTVr5Y+KWI?=
 =?us-ascii?Q?HbfRdqfQ2Uzm7lSiEJqyt6FJK5+Y1mrc3VE4mrmySG3K9fTkFrX6PONgmgM+?=
 =?us-ascii?Q?8HJLMhvrvIIMkUVH/jh7UYPlXw5rQ/3JZ53A7fV1v78r/aPheqAzZh3O1ssC?=
 =?us-ascii?Q?zaoPPqgeB5CyeQWWltPJtuPPTBdkBkaBfnLynJvZlaI9/vYczOQ7AMdkMEpw?=
 =?us-ascii?Q?9TXJLiRtBUaPY1lZKfjFhiKU?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b3b172e-54a6-43e0-7296-08d8f4b6a980
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 02:34:24.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Ej9Ug7u34xf6NRmCYkao+mAWBGVBhyJCvKUWy77mFj1ocU/O4M7w5sgSx1zVTbi0HDox5KWGck/Kw+K+g8a2ntc/pqaybWD/xxkjF1YWks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3231
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid code duplication, tipc should be converted to use the helper
functions for working with libmnl in lib/mnl_utils.c

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 tipc/bearer.c    |  38 ++++++--------
 tipc/cmdl.c      |   2 -
 tipc/link.c      |  37 +++++--------
 tipc/media.c     |  15 +++---
 tipc/msg.c       | 132 +++--------------------------------------------
 tipc/msg.h       |   2 +-
 tipc/nametable.c |   5 +-
 tipc/node.c      |  33 +++++-------
 tipc/peer.c      |   8 ++-
 tipc/socket.c    |  10 ++--
 tipc/tipc.c      |  21 +++++++-
 11 files changed, 83 insertions(+), 220 deletions(-)

diff --git a/tipc/bearer.c b/tipc/bearer.c
index 4470819e4a96..2afc48b9b108 100644
--- a/tipc/bearer.c
+++ b/tipc/bearer.c
@@ -21,9 +21,6 @@
 #include <linux/genetlink.h>
 #include <linux/if.h>
 
-#include <libmnl/libmnl.h>
-#include <sys/socket.h>
-
 #include "utils.h"
 #include "cmdl.h"
 #include "msg.h"
@@ -101,11 +98,11 @@ static int get_netid_cb(const struct nlmsghdr *nlh, void *data)
 
 static int generate_multicast(short af, char *buf, int bufsize)
 {
-	int netid;
-	char mnl_msg[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	int netid;
 
-	if (!(nlh = msg_init(mnl_msg, TIPC_NL_NET_GET))) {
+	nlh = msg_init(TIPC_NL_NET_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialization failed\n");
 		return -1;
 	}
@@ -399,7 +396,6 @@ static int cmd_bearer_add_media(struct nlmsghdr *nlh, const struct cmd *cmd,
 {
 	int err;
 	char *media;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct opt *opt;
 	struct nlattr *attrs;
 	struct opt opts[] = {
@@ -435,7 +431,8 @@ static int cmd_bearer_add_media(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_ADD))) {
+	nlh = msg_init(TIPC_NL_BEARER_ADD);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -482,7 +479,6 @@ static int cmd_bearer_enable(struct nlmsghdr *nlh, const struct cmd *cmd,
 	int err;
 	struct opt *opt;
 	struct nlattr *nest;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct opt opts[] = {
 		{ "device",		OPT_KEYVAL,	NULL },
 		{ "domain",		OPT_KEYVAL,	NULL },
@@ -508,7 +504,8 @@ static int cmd_bearer_enable(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_ENABLE))) {
+	nlh = msg_init(TIPC_NL_BEARER_ENABLE);
+	if (!nlh) {
 		fprintf(stderr, "error: message initialisation failed\n");
 		return -1;
 	}
@@ -563,7 +560,6 @@ static int cmd_bearer_disable(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
 	int err;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *nest;
 	struct opt opts[] = {
 		{ "device",		OPT_KEYVAL,	NULL },
@@ -584,7 +580,8 @@ static int cmd_bearer_disable(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_DISABLE))) {
+	nlh = msg_init(TIPC_NL_BEARER_DISABLE);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -628,7 +625,6 @@ static int cmd_bearer_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	int err;
 	int val;
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *props;
 	struct nlattr *attrs;
 	struct opt opts[] = {
@@ -675,7 +671,8 @@ static int cmd_bearer_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 		}
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_SET))) {
+	nlh = msg_init(TIPC_NL_BEARER_SET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -876,7 +873,6 @@ static int cmd_bearer_get_media(struct nlmsghdr *nlh, const struct cmd *cmd,
 {
 	int err;
 	char *media;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct opt *opt;
 	struct cb_data cb_data = {0};
 	struct nlattr *attrs;
@@ -918,7 +914,8 @@ static int cmd_bearer_get_media(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_GET))) {
+	nlh = msg_init(TIPC_NL_BEARER_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -956,7 +953,6 @@ static int cmd_bearer_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 {
 	int err;
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *attrs;
 	struct opt opts[] = {
 		{ "device",		OPT_KEYVAL,	NULL },
@@ -1001,7 +997,8 @@ static int cmd_bearer_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 		}
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_GET))) {
+	nlh = msg_init(TIPC_NL_BEARER_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -1056,14 +1053,13 @@ static int bearer_list_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_bearer_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			   struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		fprintf(stderr, "Usage: %s bearer list\n", cmdl->argv[0]);
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_BEARER_GET))) {
+	nlh = msg_init(TIPC_NL_BEARER_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
diff --git a/tipc/cmdl.c b/tipc/cmdl.c
index 981e268ebf94..feaac2da175f 100644
--- a/tipc/cmdl.c
+++ b/tipc/cmdl.c
@@ -13,8 +13,6 @@
 #include <string.h>
 #include <errno.h>
 
-#include <libmnl/libmnl.h>
-
 #include "cmdl.h"
 
 static const struct cmd *find_cmd(const struct cmd *cmds, char *str)
diff --git a/tipc/link.c b/tipc/link.c
index 192736eaa154..2123f109c694 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -17,7 +17,6 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -60,7 +59,6 @@ static int link_list_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_link_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			 struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int err = 0;
 
 	if (help_flag) {
@@ -68,7 +66,7 @@ static int cmd_link_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_LINK_GET);
+	nlh = msg_init(TIPC_NL_LINK_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -126,7 +124,6 @@ static int cmd_link_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 			     struct cmdl *cmdl, void *data)
 {
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *attrs;
 	struct opt *opt;
 	struct opt opts[] = {
@@ -151,7 +148,7 @@ static int cmd_link_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (parse_opts(opts, cmdl) < 0)
 		return -EINVAL;
 
-	nlh = msg_init(buf, TIPC_NL_LINK_GET);
+	nlh = msg_init(TIPC_NL_LINK_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -241,7 +238,6 @@ static int cmd_link_get_bcast(struct nlmsghdr *nlh, const struct cmd *cmd,
 			     struct cmdl *cmdl, void *data)
 {
 	int prop = TIPC_NLA_PROP_BROADCAST;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *attrs;
 
 	if (help_flag) {
@@ -249,7 +245,7 @@ static int cmd_link_get_bcast(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_LINK_GET);
+	nlh = msg_init(TIPC_NL_LINK_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -284,7 +280,6 @@ static int cmd_link_stat_reset(struct nlmsghdr *nlh, const struct cmd *cmd,
 			       struct cmdl *cmdl, void *data)
 {
 	char *link;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct opt *opt;
 	struct nlattr *nest;
 	struct opt opts[] = {
@@ -302,7 +297,7 @@ static int cmd_link_stat_reset(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_LINK_RESET_STATS);
+	nlh = msg_init(TIPC_NL_LINK_RESET_STATS);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -550,7 +545,6 @@ static int cmd_link_stat_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
 	char *link = NULL;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct opt *opt;
 	struct opt opts[] = {
 		{ "link",		OPT_KEYVAL,	NULL },
@@ -564,7 +558,7 @@ static int cmd_link_stat_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_LINK_GET);
+	nlh = msg_init(TIPC_NL_LINK_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -626,7 +620,6 @@ static int cmd_link_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 {
 	int val;
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *props;
 	struct nlattr *attrs;
 	struct opt *opt;
@@ -658,7 +651,7 @@ static int cmd_link_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (parse_opts(opts, cmdl) < 0)
 		return -EINVAL;
 
-	nlh = msg_init(buf, TIPC_NL_LINK_SET);
+	nlh = msg_init(TIPC_NL_LINK_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -704,7 +697,6 @@ static void cmd_link_set_bcast_help(struct cmdl *cmdl)
 static int cmd_link_set_bcast(struct nlmsghdr *nlh, const struct cmd *cmd,
 			     struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *props;
 	struct nlattr *attrs;
 	struct opt *opt;
@@ -734,7 +726,7 @@ static int cmd_link_set_bcast(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_LINK_SET);
+	nlh = msg_init(TIPC_NL_LINK_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -788,7 +780,6 @@ static int cmd_link_mon_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 				 struct cmdl *cmdl, void *data)
 {
 	int size;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *attrs;
 
 	if (cmdl->argc != cmdl->optind + 1) {
@@ -797,7 +788,7 @@ static int cmd_link_mon_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	}
 	size = atoi(shift_cmdl(cmdl));
 
-	nlh = msg_init(buf, TIPC_NL_MON_SET);
+	nlh = msg_init(TIPC_NL_MON_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -841,7 +832,6 @@ static int link_mon_summary_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_link_mon_summary(struct nlmsghdr *nlh, const struct cmd *cmd,
 				struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int err = 0;
 
 	if (help_flag) {
@@ -849,7 +839,7 @@ static int cmd_link_mon_summary(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_MON_GET);
+	nlh = msg_init(TIPC_NL_MON_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -1004,11 +994,10 @@ exit:
 static int link_mon_peer_list(uint32_t mon_ref)
 {
 	struct nlmsghdr *nlh;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *nest;
 	int err = 0;
 
-	nlh = msg_init(buf, TIPC_NL_MON_PEER_GET);
+	nlh = msg_init(TIPC_NL_MON_PEER_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -1080,7 +1069,6 @@ static void cmd_link_mon_list_udp_help(struct cmdl *cmdl, char *media)
 static int cmd_link_mon_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			     struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	char bname[TIPC_MAX_BEARER_NAME] = {0};
 	struct opt opts[] = {
 		{ "media",	OPT_KEYVAL,	NULL },
@@ -1112,7 +1100,7 @@ static int cmd_link_mon_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_MON_GET);
+	nlh = msg_init(TIPC_NL_MON_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -1176,9 +1164,8 @@ static int link_mon_get_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_link_mon_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 				 struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 
-	nlh = msg_init(buf, TIPC_NL_MON_GET);
+	nlh = msg_init(TIPC_NL_MON_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
diff --git a/tipc/media.c b/tipc/media.c
index 969ef6578b3b..a3fec681cbf4 100644
--- a/tipc/media.c
+++ b/tipc/media.c
@@ -15,9 +15,7 @@
 #include <errno.h>
 
 #include <linux/tipc_netlink.h>
-#include <linux/tipc.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -45,14 +43,13 @@ static int media_list_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_media_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			 struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		fprintf(stderr, "Usage: %s media list\n", cmdl->argv[0]);
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_MEDIA_GET))) {
+	nlh = msg_init(TIPC_NL_MEDIA_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -89,7 +86,6 @@ static int cmd_media_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *nest;
 	struct opt *opt;
 	struct opt opts[] = {
@@ -116,7 +112,8 @@ static int cmd_media_get_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (parse_opts(opts, cmdl) < 0)
 		return -EINVAL;
 
-	if (!(nlh = msg_init(buf, TIPC_NL_MEDIA_GET))) {
+	nlh = msg_init(TIPC_NL_MEDIA_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -179,7 +176,6 @@ static int cmd_media_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 {
 	int val;
 	int prop;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *props;
 	struct nlattr *attrs;
 	struct opt *opt;
@@ -213,7 +209,8 @@ static int cmd_media_set_prop(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (parse_opts(opts, cmdl) < 0)
 		return -EINVAL;
 
-	if (!(nlh = msg_init(buf, TIPC_NL_MEDIA_SET))) {
+	nlh = msg_init(TIPC_NL_MEDIA_SET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
diff --git a/tipc/msg.c b/tipc/msg.c
index dc09d05048f3..1225691c9a81 100644
--- a/tipc/msg.c
+++ b/tipc/msg.c
@@ -13,13 +13,13 @@
 #include <time.h>
 #include <errno.h>
 
-#include <linux/tipc_netlink.h>
-#include <linux/tipc.h>
-#include <linux/genetlink.h>
 #include <libmnl/libmnl.h>
 
+#include "mnl_utils.h"
 #include "msg.h"
 
+extern struct mnlu_gen_socket tipc_nlg;
+
 int parse_attrs(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
@@ -30,141 +30,23 @@ int parse_attrs(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int family_id_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nlattr *tb[CTRL_ATTR_MAX + 1] = {};
-	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
-	int *id = data;
-
-	mnl_attr_parse(nlh, sizeof(*genl), parse_attrs, tb);
-	if (!tb[CTRL_ATTR_FAMILY_ID])
-		return MNL_CB_ERROR;
-
-	*id = mnl_attr_get_u16(tb[CTRL_ATTR_FAMILY_ID]);
-
-	return MNL_CB_OK;
-}
-
-static struct mnl_socket *msg_send(struct nlmsghdr *nlh)
-{
-	int ret;
-	struct mnl_socket *nl;
-
-	nl = mnl_socket_open(NETLINK_GENERIC);
-	if (nl == NULL) {
-		perror("mnl_socket_open");
-		return NULL;
-	}
-
-	ret = mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID);
-	if (ret < 0) {
-		perror("mnl_socket_bind");
-		return NULL;
-	}
-
-	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
-	if (ret < 0) {
-		perror("mnl_socket_send");
-		return NULL;
-	}
-
-	return nl;
-}
-
-static int msg_recv(struct mnl_socket *nl, mnl_cb_t callback, void *data, int seq)
-{
-	int ret;
-	unsigned int portid;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
-	portid = mnl_socket_get_portid(nl);
-
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, callback, data);
-		if (ret <= 0)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1)
-		perror("error");
-
-	mnl_socket_close(nl);
-
-	return ret;
-}
-
-static int msg_query(struct nlmsghdr *nlh, mnl_cb_t callback, void *data)
-{
-	unsigned int seq;
-	struct mnl_socket *nl;
-
-	seq = time(NULL);
-	nlh->nlmsg_seq = seq;
-
-	nl = msg_send(nlh);
-	if (!nl)
-		return -ENOTSUP;
-
-	return msg_recv(nl, callback, data, seq);
-}
-
-static int get_family(void)
-{
-	int err;
-	int nl_family;
-	struct nlmsghdr *nlh;
-	struct genlmsghdr *genl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type	= GENL_ID_CTRL;
-	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
-
-	genl = mnl_nlmsg_put_extra_header(nlh, sizeof(struct genlmsghdr));
-	genl->cmd = CTRL_CMD_GETFAMILY;
-	genl->version = 1;
-
-	mnl_attr_put_u16(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
-	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, TIPC_GENL_V2_NAME);
-
-	if ((err = msg_query(nlh, family_id_cb, &nl_family)))
-		return err;
-
-	return nl_family;
-}
-
 int msg_doit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data)
 {
 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
-	return msg_query(nlh, callback, data);
+	return mnlu_gen_socket_sndrcv(&tipc_nlg, nlh, callback, data);
 }
 
 int msg_dumpit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data)
 {
 	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
-	return msg_query(nlh, callback, data);
+	return mnlu_gen_socket_sndrcv(&tipc_nlg, nlh, callback, data);
 }
 
-struct nlmsghdr *msg_init(char *buf, int cmd)
+struct nlmsghdr *msg_init(int cmd)
 {
-	int family;
 	struct nlmsghdr *nlh;
-	struct genlmsghdr *genl;
-
-	family = get_family();
-	if (family <= 0) {
-		fprintf(stderr,
-			"Unable to get TIPC nl family id (module loaded?)\n");
-		return NULL;
-	}
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type	= family;
 
-	genl = mnl_nlmsg_put_extra_header(nlh, sizeof(struct genlmsghdr));
-	genl->cmd = cmd;
-	genl->version = 1;
+	nlh = mnlu_gen_socket_cmd_prepare(&tipc_nlg, cmd, 0);
 
 	return nlh;
 }
diff --git a/tipc/msg.h b/tipc/msg.h
index 41fd1ad1403a..56af5a705fb9 100644
--- a/tipc/msg.h
+++ b/tipc/msg.h
@@ -12,7 +12,7 @@
 #ifndef _TIPC_MSG_H
 #define _TIPC_MSG_H
 
-struct nlmsghdr *msg_init(char *buf, int cmd);
+struct nlmsghdr *msg_init(int cmd);
 int msg_doit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data);
 int msg_dumpit(struct nlmsghdr *nlh, mnl_cb_t callback, void *data);
 int parse_attrs(const struct nlattr *attr, void *data);
diff --git a/tipc/nametable.c b/tipc/nametable.c
index d899eeb67c07..b09ed5fc7280 100644
--- a/tipc/nametable.c
+++ b/tipc/nametable.c
@@ -15,7 +15,6 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -82,7 +81,6 @@ static int cmd_nametable_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
 	int iteration = 0;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int rc = 0;
 
 	if (help_flag) {
@@ -90,7 +88,8 @@ static int cmd_nametable_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_NAME_TABLE_GET))) {
+	nlh = msg_init(TIPC_NL_NAME_TABLE_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
diff --git a/tipc/node.c b/tipc/node.c
index 05246013487f..ae75bfff7d2f 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -17,7 +17,6 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -52,14 +51,13 @@ static int node_list_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_node_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			 struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		fprintf(stderr, "Usage: %s node list\n", cmdl->argv[0]);
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_NODE_GET))) {
+	nlh = msg_init(TIPC_NL_NODE_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -73,7 +71,6 @@ static int cmd_node_set_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 	char *str;
 	uint32_t addr;
 	struct nlattr *nest;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 
 	if (cmdl->argc != cmdl->optind + 1) {
 		fprintf(stderr, "Usage: %s node set address ADDRESS\n",
@@ -86,7 +83,8 @@ static int cmd_node_set_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (!addr)
 		return -1;
 
-	if (!(nlh = msg_init(buf, TIPC_NL_NET_SET))) {
+	nlh = msg_init(TIPC_NL_NET_SET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -126,7 +124,6 @@ static int cmd_node_get_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 static int cmd_node_set_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 			       struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint8_t id[16] = {0,};
 	uint64_t *w0 = (uint64_t *) &id[0];
 	uint64_t *w1 = (uint64_t *) &id[8];
@@ -145,7 +142,7 @@ static int cmd_node_set_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_NET_SET);
+	nlh = msg_init(TIPC_NL_NET_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -201,7 +198,6 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 	};
 	struct nlattr *nest;
 	struct opt *opt_algname, *opt_nodeid, *opt_master, *opt_rekeying;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint8_t id[TIPC_NODEID_LEN] = {0,};
 	uint32_t rekeying = 0;
 	bool has_key = false;
@@ -262,7 +258,7 @@ get_ops:
 	}
 
 	/* Init & do the command */
-	nlh = msg_init(buf, TIPC_NL_KEY_SET);
+	nlh = msg_init(TIPC_NL_KEY_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -287,15 +283,13 @@ get_ops:
 static int cmd_node_flush_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		(cmd->help)(cmdl);
 		return -EINVAL;
 	}
 
 	/* Init & do the command */
-	nlh = msg_init(buf, TIPC_NL_KEY_FLUSH);
+	nlh = msg_init(TIPC_NL_KEY_FLUSH);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -332,14 +326,12 @@ static int nodeid_get_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_node_get_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 			       struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		(cmd->help)(cmdl);
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_NET_GET);
+	nlh = msg_init(TIPC_NL_NET_GET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
@@ -370,14 +362,13 @@ static int netid_get_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_node_get_netid(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		(cmd->help)(cmdl);
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_NET_GET))) {
+	nlh = msg_init(TIPC_NL_NET_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -389,7 +380,6 @@ static int cmd_node_set_netid(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
 	int netid;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *nest;
 
 	if (help_flag) {
@@ -397,7 +387,8 @@ static int cmd_node_set_netid(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_NET_SET))) {
+	nlh = msg_init(TIPC_NL_NET_SET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
diff --git a/tipc/peer.c b/tipc/peer.c
index f14ec35e6f71..ed18efc552fa 100644
--- a/tipc/peer.c
+++ b/tipc/peer.c
@@ -17,7 +17,6 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -30,7 +29,6 @@ static int cmd_peer_rm_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 	char *str;
 	uint32_t addr;
 	struct nlattr *nest;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 
 	if ((cmdl->argc != cmdl->optind + 1) || help_flag) {
 		fprintf(stderr, "Usage: %s peer remove address ADDRESS\n",
@@ -47,7 +45,8 @@ static int cmd_peer_rm_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 	if (!addr)
 		return -1;
 
-	if (!(nlh = msg_init(buf, TIPC_NL_PEER_REMOVE))) {
+	nlh = msg_init(TIPC_NL_PEER_REMOVE);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -62,7 +61,6 @@ static int cmd_peer_rm_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 static int cmd_peer_rm_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 			      struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	__u8 id[16] = {0,};
 	__u64 *w0 = (__u64 *)&id[0];
 	__u64 *w1 = (__u64 *)&id[8];
@@ -81,7 +79,7 @@ static int cmd_peer_rm_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
-	nlh = msg_init(buf, TIPC_NL_PEER_REMOVE);
+	nlh = msg_init(TIPC_NL_PEER_REMOVE);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
diff --git a/tipc/socket.c b/tipc/socket.c
index 852984ecd1e7..deae12af4409 100644
--- a/tipc/socket.c
+++ b/tipc/socket.c
@@ -15,7 +15,6 @@
 #include <linux/tipc.h>
 #include <linux/tipc_netlink.h>
 #include <linux/genetlink.h>
-#include <libmnl/libmnl.h>
 
 #include "cmdl.h"
 #include "msg.h"
@@ -46,10 +45,10 @@ static int publ_list_cb(const struct nlmsghdr *nlh, void *data)
 static int publ_list(uint32_t sock)
 {
 	struct nlmsghdr *nlh;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlattr *nest;
 
-	if (!(nlh = msg_init(buf, TIPC_NL_PUBL_GET))) {
+	nlh = msg_init(TIPC_NL_PUBL_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
@@ -103,14 +102,13 @@ static int sock_list_cb(const struct nlmsghdr *nlh, void *data)
 static int cmd_socket_list(struct nlmsghdr *nlh, const struct cmd *cmd,
 			   struct cmdl *cmdl, void *data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-
 	if (help_flag) {
 		fprintf(stderr, "Usage: %s socket list\n", cmdl->argv[0]);
 		return -EINVAL;
 	}
 
-	if (!(nlh = msg_init(buf, TIPC_NL_SOCK_GET))) {
+	nlh = msg_init(TIPC_NL_SOCK_GET);
+	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
diff --git a/tipc/tipc.c b/tipc/tipc.c
index 60176a044f8d..9f23a4bfd25d 100644
--- a/tipc/tipc.c
+++ b/tipc/tipc.c
@@ -13,7 +13,11 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <unistd.h>
+#include <linux/tipc_netlink.h>
+#include <libmnl/libmnl.h>
+#include <errno.h>
 
+#include "mnl_utils.h"
 #include "bearer.h"
 #include "link.h"
 #include "nametable.h"
@@ -26,6 +30,7 @@
 
 int help_flag;
 int json;
+struct mnlu_gen_socket tipc_nlg;
 
 static void about(struct cmdl *cmdl)
 {
@@ -110,8 +115,20 @@ int main(int argc, char *argv[])
 	cmdl.argc = argc;
 	cmdl.argv = argv;
 
-	if ((res = run_cmd(NULL, &cmd, cmds, &cmdl, NULL)) != 0)
-		return 1;
+	res = mnlu_gen_socket_open(&tipc_nlg, TIPC_GENL_V2_NAME,
+				   TIPC_GENL_V2_VERSION);
+	if (res) {
+		fprintf(stderr,
+			"Unable to get TIPC nl family id (module loaded?)\n");
+		return -1;
+	}
 
+	res = run_cmd(NULL, &cmd, cmds, &cmdl, &tipc_nlg);
+	if (res != 0) {
+		mnlu_gen_socket_close(&tipc_nlg);
+		return -1;
+	}
+
+	mnlu_gen_socket_close(&tipc_nlg);
 	return 0;
 }
-- 
2.25.1

