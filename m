Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36652291601
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 07:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgJRFVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 01:21:23 -0400
Received: from mail-eopbgr30105.outbound.protection.outlook.com ([40.107.3.105]:23936
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgJRFVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 01:21:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ab6DHbE3Gr/rmXu+MW/jiy9PHdhUXuXcCglIVjCUs1qhtRFzFdMFPYJ5jppDyZctCU8NGVvOjJ6RVbvenptO0UOQ04PQLgEre4XbM1LuB5b8P76Iarj4xHYEddo0booPaZZsK3PPTcB/bGcOVxgTN0WRJEzRyK/PZVfIE6px7oPgRJfX0EdmFppRWPQmGagbgjCp56v1V+SKH7YQFOE2ZSeP2QOXAmlSgnWvDEUxbsV4A6LE2auSmli1yCHx1RUekA5UT94eukyCxWXV+C3NJsc35zyEbmMNH7i/hf2iGJqFCqNS+nj2VqrfoLcepzBsex3OKohRkixfb1ulUcTjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk9VZ+zqnFTUmDbjJ8PCCOqPKB4h1m//bx9xccAQcwk=;
 b=OZa9ZgbGfHAd84SE/CnXJnfXkZT8jmOjlxd1e1v9h60GDkmdIpQ9ndwMAEuZyrcaoNw7wBNRog7+ODhHQQoV0Grnd7j2vqDa8pJYcGCe8zuN1gG1lYibWvww2OQQS+OqJtnWAHfQhW21U4Q8/OYyQJ0ajFA2f9K3NXiDwMgKU1Z0dUWbctTG5LBWC+TiDM96vj3ice3WNKWtpXoQUbh2mZjQBLwXPPIaZ/GuWgdPjRGYVt/+uEKW7orlv2oVNxJLjzfjFhwxHT7jt+JSqWzfVPwW3Cm8PsFCSK7XIa/xpm2GOLTSnopDSZe/B/MPsMQUhgXMqHKguNH/S3CPugg5iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk9VZ+zqnFTUmDbjJ8PCCOqPKB4h1m//bx9xccAQcwk=;
 b=YAv9+1rktPVwubytzb8fCmX1L5SFlOKPVVU4hgGVhFlWcgtTHb2jGUha2h0hXulAnSLc7TWpFrDVHsYTgNL6t316srYLxH/CymJrU8zr2k5aDwBAgN1UAzS9Ybwmw5z+o6kdtHz41iXR0H/leoUUOePwR0bomgTPe4E4Xzc96a8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB4131.eurprd05.prod.outlook.com (2603:10a6:208:5c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Sun, 18 Oct
 2020 05:21:14 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::e846:1ad7:c6f1:ab9f]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::e846:1ad7:c6f1:ab9f%3]) with mapi id 15.20.3477.027; Sun, 18 Oct 2020
 05:21:14 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     dsahern@gmail.com, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [iproute2-next 1/2] tipc: add option to set master key for encryption
Date:   Fri, 16 Oct 2020 23:02:00 +0700
Message-Id: <20201016160201.7290-2-tuong.t.lien@dektech.com.au>
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
Received: from dektech.com.au (113.20.114.51) by AM4PR07CA0009.eurprd07.prod.outlook.com (2603:10a6:205:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.11 via Frontend Transport; Sun, 18 Oct 2020 05:21:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9933b084-0e1c-4ae0-8da1-08d87325a247
X-MS-TrafficTypeDiagnostic: AM0PR05MB4131:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4131C179AEF22BDADAAD51E2E2010@AM0PR05MB4131.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkdvL+PI33PUdzqn4HGajnqQdKuForBR63wjI51ocqtTV9eeSWkJYsI7wSgevzR1Qnt6u3b7MOuSkVFo9tQUjeZPPqcHFY/S3jHw3OxOg3HjkC4FhLCRDj4ki1H+0HGvvx3CxMFOGk4uQI7JGSTugzuSapxDrzycVCUWEPkAE04A8Bu4tVljL17dV0dFaoa0+/80L7esTcnew5VGYbkKrv4VmySSVrXdUmI1BhRfyY7T7QRkxwAQXLhxk6KhRvpfmyZT8mLkhv1tzbTF3wx6asZcUTTOlb3AbsbNJTUi3AgsiMG5sGo7WvMla4UY+ZAVsuEuJMMUDAGsFQQzUlArtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39830400003)(376002)(26005)(5660300002)(8676002)(16526019)(8936002)(66946007)(1076003)(6666004)(52116002)(66476007)(7696005)(66556008)(83380400001)(86362001)(36756003)(478600001)(4326008)(186003)(55016002)(2616005)(2906002)(956004)(316002)(103116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FWgV1etJUufR3TErB+47Pob+iVbMqsUtZAtWtvhLPpA8z/GT1SxEZ3FJ6+MovJRuqyb2CikTNAded30zuNpx/JFlrJuHf/vuTlpkhUrR8STxB/SIoHGyQ7F5TcjXBMdn+fO6DuwKy8saRilcsytbxnzh53VWvpsDqZFjOf+LjzCLjM6F6SouvkEf2XUtnds8r6uJUM4Ml+oWN0HcloJ+ldUH8NGr8+LOLtnk37O+2tuBsMIiG+Ss9qGQu9yjFwj8XfVJQuRyeYZf/mymSE5v8XZmv4hWs2BBrpKj+lStdL7wnXte4U5mB+b+1wQS8Q4467vesgbzlbAnlwG2w+wXoq7AfuSokK2pg3MLAJrqUYazxZvZWLEIOX8a0hr87HbE5hzxv9O00yc+tF5qfzaUCqzPGIgULwVrA3ReIXowRYB5dOSU3EenyzRfTelFmxs7Js1w3juCNS/I0bbFfI1LuZEr+qfGFpfr72q68guQvzmq343U8x9KDxo/cL88CMQ732NnXzm/9RROgylrOZ3hUQ8er46A/te1Mlx9JKpzHO4sQftEW/tISG246GLDXqQxINQJte5vl2j0p5lZKjkienH53L8c821wMYLjdRhR1Ka8firQwBKrxJsxyqXnN4jVtwH8Ar4ebWvHT5/d45/35g==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 9933b084-0e1c-4ae0-8da1-08d87325a247
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2020 05:21:14.8498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGc/eYNU/si9PY9K7SgwSKOrNGyZJo/N5m33zU+BrBMcNs2KPUB54VYZ0gnojLG7WiKx8yQ6RNDb+RPrMeK0Zo+eBxihpmKuuc6wPAKk6b8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In addition to the support of master key in kernel, we add the 'master'
option to the 'tipc node set key' command for user to be able to
specify a key as master key during the key setting. This is carried out
by turning on the new netlink flag - 'TIPC_NLA_NODE_KEY_MASTER'.
For example:

$ tipc node set key "this_is_a_master_key" master

The command's help menu is also updated to give a better description of
all the available options.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 tipc/node.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/tipc/node.c b/tipc/node.c
index ffdaeaea..1ff0baa4 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -160,19 +160,21 @@ static int cmd_node_set_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
 static void cmd_node_set_key_help(struct cmdl *cmdl)
 {
 	fprintf(stderr,
-		"Usage: %s node set key KEY [algname ALGNAME] [nodeid NODEID]\n\n"
+		"Usage: %s node set key KEY [algname ALGNAME] [PROPERTIES]\n\n"
+		"KEY\n"
+		"  Symmetric KEY & SALT as a composite ASCII or hex string (0x...) in form:\n"
+		"  [KEY: 16, 24 or 32 octets][SALT: 4 octets]\n\n"
+		"ALGNAME\n"
+		"  Cipher algorithm [default: \"gcm(aes)\"]\n\n"
 		"PROPERTIES\n"
-		" KEY                   - Symmetric KEY & SALT as a normal or hex string\n"
-		"                         that consists of two parts:\n"
-		"                         [KEY: 16, 24 or 32 octets][SALT: 4 octets]\n\n"
-		" algname ALGNAME       - Default: \"gcm(aes)\"\n\n"
-		" nodeid NODEID         - Own or peer node identity to which the key will\n"
-		"                         be attached. If not present, the key is a cluster\n"
-		"                         key!\n\n"
+		"  master                - Set KEY as a cluster master key\n"
+		"  <empty>               - Set KEY as a cluster key\n"
+		"  nodeid NODEID         - Set KEY as a per-node key for own or peer\n\n"
 		"EXAMPLES\n"
-		"  %s node set key this_is_a_key16_salt algname \"gcm(aes)\" nodeid node1\n"
-		"  %s node set key 0x746869735F69735F615F6B657931365F73616C74 nodeid node2\n\n",
-		cmdl->argv[0], cmdl->argv[0], cmdl->argv[0]);
+		"  %s node set key this_is_a_master_key master\n"
+		"  %s node set key 0x746869735F69735F615F6B657931365F73616C74\n"
+		"  %s node set key this_is_a_key16_salt algname \"gcm(aes)\" nodeid 1001002\n\n",
+		cmdl->argv[0], cmdl->argv[0], cmdl->argv[0], cmdl->argv[0]);
 }
 
 static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
@@ -187,24 +189,21 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 	struct opt opts[] = {
 		{ "algname",	OPT_KEYVAL,	NULL },
 		{ "nodeid",	OPT_KEYVAL,	NULL },
+		{ "master",	OPT_KEY,	NULL },
 		{ NULL }
 	};
 	struct nlattr *nest;
-	struct opt *opt_algname, *opt_nodeid;
+	struct opt *opt_algname, *opt_nodeid, *opt_master;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint8_t id[TIPC_NODEID_LEN] = {0,};
 	int keysize;
 	char *str;
 
-	if (help_flag) {
+	if (help_flag || cmdl->optind >= cmdl->argc) {
 		(cmd->help)(cmdl);
 		return -EINVAL;
 	}
 
-	if (cmdl->optind >= cmdl->argc) {
-		fprintf(stderr, "error, missing key\n");
-		return -EINVAL;
-	}
 
 	/* Get user key */
 	str = shift_cmdl(cmdl);
@@ -230,17 +229,30 @@ static int cmd_node_set_key(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 	}
 
+	/* Get master key indication */
+	opt_master = get_opt(opts, "master");
+
+	/* Sanity check if wrong option */
+	if (opt_nodeid && opt_master) {
+		fprintf(stderr, "error, per-node key cannot be master\n");
+		return -EINVAL;
+	}
+
 	/* Init & do the command */
 	nlh = msg_init(buf, TIPC_NL_KEY_SET);
 	if (!nlh) {
 		fprintf(stderr, "error, message initialisation failed\n");
 		return -1;
 	}
+
 	nest = mnl_attr_nest_start(nlh, TIPC_NLA_NODE);
 	keysize = tipc_aead_key_size(&input.key);
 	mnl_attr_put(nlh, TIPC_NLA_NODE_KEY, keysize, &input.key);
 	if (opt_nodeid)
 		mnl_attr_put(nlh, TIPC_NLA_NODE_ID, TIPC_NODEID_LEN, id);
+	if (opt_master)
+		mnl_attr_put(nlh, TIPC_NLA_NODE_KEY_MASTER, 0, NULL);
+
 	mnl_attr_nest_end(nlh, nest);
 	return msg_doit(nlh, NULL, NULL);
 }
-- 
2.26.2

