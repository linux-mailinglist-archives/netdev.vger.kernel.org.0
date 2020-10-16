Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72C0291602
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 07:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgJRFV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 01:21:27 -0400
Received: from mail-eopbgr30105.outbound.protection.outlook.com ([40.107.3.105]:23936
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgJRFV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 01:21:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXA1D0yboCeX4+4LKMwwWmoavut3uDeniZeWO5zKj7hCoVMEtqCUPsSeIF4myXMfm16rau9tGMGPoIMPoynvZ4eogBHEJiOQJuTJ49OpR1U6F/vZCKXIGcOGEk7tYvIrMbdD7G7Q7jDXU4AiOOKmlh2g3FmXmJlXLLr4BEHy69Ao8VIYn+jJpGCKfvbHQVsQITTIgK54p+YFg6LkDsa8WoIgoNv02BO26wat0ko0/nUwyht+9A39H0FUeCDdLRZCZnj91bDcc8bLwnHwPzyeUKWySsQwfQCfmxNMeAoO/m/n4jCcrFT5oQjAJIC5JXFy8A3Ru5+9oogC0Cf6vvZ34Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj/f4WGO5odmZWydLs/aNNzEUCEWB3HU6KQ3uSCFPxU=;
 b=QZw1zBeg7uaLCXDUfdrdSHsAN6CbmqxauvIUv7YTtO/wgFO4rflXK8qsstm5GWlD3MdJX8JjFF6wMZQ94BplsL7ezKol1PzplKmWhPRmhoZ6JXtnkL94x3VwjXyzJvsKiFpopxn40DLus3o/7O6m6xAF93nAacpNOLoUwMyvwcZWo6yLW/zA7CHWMBdx6OO0/TMdZ8fOpXlmhvkFifqg4iEo3ytOeQ1DKkBdpA+otcRxbtEgiRP6s3tJKf5O4z9J1uwDPmOFCSRalniKLl16Bps5+t/5izcAk8yK5X3aK9VCb7b7PVYKo9jU7oXJVq+Ii1dpHnH3ekpLzIZVydxm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj/f4WGO5odmZWydLs/aNNzEUCEWB3HU6KQ3uSCFPxU=;
 b=neDbHMIsmrU6GvLp8g1uoUhATaW5iSAkz05uOFA15Hac3LW0R+r2HMbw5ep0CB4rzjS96DbI9YMVc/LmCC8ozINLEnKOhQGzPBh5cqnZ0FtetGImKKqy2/tUlCLcCl/20DInFSMgcD/dDkqV2NW2nIYnrs0G4ZhQbOPYzVMZjLE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB4131.eurprd05.prod.outlook.com (2603:10a6:208:5c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Sun, 18 Oct
 2020 05:21:17 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::e846:1ad7:c6f1:ab9f]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::e846:1ad7:c6f1:ab9f%3]) with mapi id 15.20.3477.027; Sun, 18 Oct 2020
 05:21:17 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     dsahern@gmail.com, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [iproute2-next 2/2] tipc: add option to set rekeying for encryption
Date:   Fri, 16 Oct 2020 23:02:01 +0700
Message-Id: <20201016160201.7290-3-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016160201.7290-1-tuong.t.lien@dektech.com.au>
References: <20201016160201.7290-1-tuong.t.lien@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: AM4PR07CA0009.eurprd07.prod.outlook.com
 (2603:10a6:205:1::22) To AM8PR05MB7332.eurprd05.prod.outlook.com
 (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by AM4PR07CA0009.eurprd07.prod.outlook.com (2603:10a6:205:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.11 via Frontend Transport; Sun, 18 Oct 2020 05:21:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99ca5c6b-40f6-4dca-3e88-08d87325a38f
X-MS-TrafficTypeDiagnostic: AM0PR05MB4131:
X-Microsoft-Antispam-PRVS: <AM0PR05MB413185E0DCF58439D8989F3AE2010@AM0PR05MB4131.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:415;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcMssKab9qBRN7E2z5OxwPkZ+4KEn060WzAIr2VsqokKmNfq87hTwvv07fvIfx908z2AYnvXxqltTw2g3YN3WhHnnno09UNZ/O/hfFMxEAYIQS7qKToYbZA7n5IAA6sKhKtEbXmItvMyzzohqAp0vj/Yv4K/NkJ68vgaPgWkTmV8LEh8NmH+6r6XtHS1CNN5G5Q9dEGcDJty6mGUQFPei0fSGnd9Ggis1jw18N7dO7cUbi7Ot+SRKy/IBZo5U7oWIJlag5f7oVk3m0/OE7p1IpvraMlk4bCkRulEE8sTvZMzoGnKn+1r/Qp9QKM5DNc+Smgl8Y6ahY9uMLjR7ArKdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39830400003)(376002)(26005)(5660300002)(8676002)(16526019)(8936002)(66946007)(1076003)(6666004)(52116002)(66476007)(7696005)(66556008)(83380400001)(86362001)(36756003)(478600001)(4326008)(186003)(55016002)(2616005)(2906002)(956004)(316002)(103116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ic7+WuwqF/ynHEcMnBh2dr0qN9IhoOOrNlWVgoh7ioKWLbS4WVMx8/xR5o4lWs3zAHCQ2Cn7SAKqNxkb3aR5rI2d9Sa0bOKT3EROinTwpvEvEE2sbWzOfY+oAp8y1bw7jNodvVyJzrTTzcVzWt1sD5aIgIsJw0pi8PXfH/m2Bo3WMp54hhl1ivi0WcSQ8tPRYY6NX5UXN+o149QqsNAr8F2kTCJxYIqk7BYyuW0WRiILv+5msa7OVxB53U0p2LHbwFBWRmTYodfb3qN4FH3y90Z0kBp6rmIrfvOIEw8/I7KN7ev3A9wSoNr+BOuvPLoNSw5nNyIAKcUHOOY44lr/Mbtr2qADdyvVzd43OEwEed8nJMhFWqZDq3d2Jye5Z0c/YlYSBAN9PnMYh0Ob4/1EbQegyjxsVr+8xvmMJpx+X8Rwp2JKYpanbdh1x1R2udknZb6qS4s986IZqgyvth2bfTkthNawCminUyLbnXOGnfWdP70fhi9Zt1Ys6fccOZeg4vUHLzRr6TT4DfPHGJxmyEfOy+na8z+7ynoaaQGJb8JOoRTzBDcPF9xj4cUf5qgyYaSphHLwAamXvWNh2WH8fT5/siuOEcndTD/OqQAR9P2YyE5GYOU4czV8mhIpfaDlly2FfRl6dT1qyKT0HXIzQQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ca5c6b-40f6-4dca-3e88-08d87325a38f
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2020 05:21:16.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QxZ1dbVISaxBn+7O7VWt10wMBr7uOQ+8KvgCsssdSd91vvh6z06rXyfnof/hEGshUpH8vVsPWi5WxvmmikAQfXASw3cT6DJ3xiAAexOz4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As supported in kernel, the TIPC encryption rekeying can be tuned using
the netlink attribute - 'TIPC_NLA_NODE_REKEYING'. Now we add the
'rekeying' option correspondingly to the 'tipc node set key' command so
that user will be able to perform that tuning:

tipc node set key rekeying REKEYING

where the 'REKEYING' value can be:

INTERVAL              - Set rekeying interval (in minutes) [0: disable]
now                   - Trigger one (first) rekeying immediately

For example:
$ tipc node set key rekeying 60
$ tipc node set key rekeying now

The command's help menu is also updated with these descriptions for the
new command option.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 tipc/cmdl.c |  2 +-
 tipc/cmdl.h |  1 +
 tipc/node.c | 47 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/tipc/cmdl.c b/tipc/cmdl.c
index f2f259cc..981e268e 100644
--- a/tipc/cmdl.c
+++ b/tipc/cmdl.c
@@ -33,7 +33,7 @@ static const struct cmd *find_cmd(const struct cmd *cmds, char *str)
 	return match;
 }
 
-static struct opt *find_opt(struct opt *opts, char *str)
+struct opt *find_opt(struct opt *opts, char *str)
 {
 	struct opt *o;
 	struct opt *match = NULL;
diff --git a/tipc/cmdl.h b/tipc/cmdl.h
index 03db3599..dcade362 100644
--- a/tipc/cmdl.h
+++ b/tipc/cmdl.h
@@ -46,6 +46,7 @@ struct opt {
 	char *val;
 };
 
+struct opt *find_opt(struct opt *opts, char *str);
 struct opt *get_opt(struct opt *opts, char *key);
 bool has_opt(struct opt *opts, char *key);
 int parse_opts(struct opt *opts, struct cmdl *cmdl);
diff --git a/tipc/node.c b/tipc/node.c
index 1ff0baa4..05246013 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -160,7 +160,8 @@ static int cmd_node_set_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 static void cmd_node_set_key_help(struct cmdl *cmdl)
 {
 	fprintf(stderr,
-		"Usage: %s node set key KEY [algname ALGNAME] [PROPERTIES]\n\n"
+		"Usage: %s node set key KEY [algname ALGNAME] [PROPERTIES]\n"
+		"       %s node set key rekeying REKEYING\n\n"
 		"KEY\n"
 		"  Symmetric KEY & SALT as a composite ASCII or hex string (0x...) in form:\n"
 		"  [KEY: 16, 24 or 32 octets][SALT: 4 octets]\n\n"
@@ -170,11 +171,16 @@ static void cmd_node_set_key_help(struct cmdl *cmdl)
 		"  master                - Set KEY as a cluster master key\n"
 		"  <empty>               - Set KEY as a cluster key\n"
 		"  nodeid NODEID         - Set KEY as a per-node key for own or peer\n\n"
+		"REKEYING\n"
+		"  INTERVAL              - Set rekeying interval (in minutes) [0: disable]\n"
+		"  now                   - Trigger one (first) rekeying immediately\n\n"
 		"EXAMPLES\n"
 		"  %s node set key this_is_a_master_key master\n"
 		"  %s node set key 0x746869735F69735F615F6B657931365F73616C74\n"
-		"  %s node set key this_is_a_key16_salt algname \"gcm(aes)\" nodeid 1001002\n\n",
-		cmdl->argv[0], cmdl->argv[0], cmdl->argv[0], cmdl->argv[0]);
+		"  %s node set key this_is_a_key16_salt algname \"gcm(aes)\" nodeid 1001002\n"
+		"  %s node set key rekeying 600\n\n",
+		cmdl->argv[0], cmdl->argv[0], cmdl->argv[0], cmdl->argv[0],
+		cmdl->argv[0], cmdl->argv[0]);
 }
 
 static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
@@ -190,12 +196,15 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 		{ "algname",	OPT_KEYVAL,	NULL },
 		{ "nodeid",	OPT_KEYVAL,	NULL },
 		{ "master",	OPT_KEY,	NULL },
+		{ "rekeying",	OPT_KEYVAL,	NULL },
 		{ NULL }
 	};
 	struct nlattr *nest;
-	struct opt *opt_algname, *opt_nodeid, *opt_master;
+	struct opt *opt_algname, *opt_nodeid, *opt_master, *opt_rekeying;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint8_t id[TIPC_NODEID_LEN] = {0,};
+	uint32_t rekeying = 0;
+	bool has_key = false;
 	int keysize;
 	char *str;
 
@@ -204,17 +213,31 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
+	/* Check if command starts with opts i.e. "rekeying" opt without key */
+	if (find_opt(opts, cmdl->argv[cmdl->optind]))
+		goto get_ops;
 
 	/* Get user key */
+	has_key = true;
 	str = shift_cmdl(cmdl);
 	if (str2key(str, &input.key)) {
 		fprintf(stderr, "error, invalid key input\n");
 		return -EINVAL;
 	}
 
+get_ops:
 	if (parse_opts(opts, cmdl) < 0)
 		return -EINVAL;
 
+	/* Get rekeying time */
+	opt_rekeying = get_opt(opts, "rekeying");
+	if (opt_rekeying) {
+		if (!strcmp(opt_rekeying->val, "now"))
+			rekeying = TIPC_REKEYING_NOW;
+		else
+			rekeying = atoi(opt_rekeying->val);
+	}
+
 	/* Get algorithm name, default: "gcm(aes)" */
 	opt_algname = get_opt(opts, "algname");
 	if (!opt_algname)
@@ -246,12 +269,16 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 	}
 
 	nest = mnl_attr_nest_start(nlh, TIPC_NLA_NODE);
-	keysize = tipc_aead_key_size(&input.key);
-	mnl_attr_put(nlh, TIPC_NLA_NODE_KEY, keysize, &input.key);
-	if (opt_nodeid)
-		mnl_attr_put(nlh, TIPC_NLA_NODE_ID, TIPC_NODEID_LEN, id);
-	if (opt_master)
-		mnl_attr_put(nlh, TIPC_NLA_NODE_KEY_MASTER, 0, NULL);
+	if (has_key) {
+		keysize = tipc_aead_key_size(&input.key);
+		mnl_attr_put(nlh, TIPC_NLA_NODE_KEY, keysize, &input.key);
+		if (opt_nodeid)
+			mnl_attr_put(nlh, TIPC_NLA_NODE_ID, TIPC_NODEID_LEN, id);
+		if (opt_master)
+			mnl_attr_put(nlh, TIPC_NLA_NODE_KEY_MASTER, 0, NULL);
+	}
+	if (opt_rekeying)
+		mnl_attr_put_u32(nlh, TIPC_NLA_NODE_REKEYING, rekeying);
 
 	mnl_attr_nest_end(nlh, nest);
 	return msg_doit(nlh, NULL, NULL);
-- 
2.26.2

