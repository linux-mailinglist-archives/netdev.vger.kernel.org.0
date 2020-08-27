Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EAA253BD9
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 04:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH0Ca7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 22:30:59 -0400
Received: from mail-eopbgr150130.outbound.protection.outlook.com ([40.107.15.130]:9485
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgH0Ca7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 22:30:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj+fYjmDTTsFq7XiXEacCq1+/lzkcVbY9AULDZZVDre760W4qCOJtEj/IQAcE4chO6TXXolp2gmB4YA8voxJAWBicKc+yuue/UQGr/AaClz/8yl/SAGDbyD93JiBTPVjdLaC1l+6dhHfV6ARMt6rtOtRDcat3/tVDTGlj6Hx1QM2+tMAqnhmk4zCOtld7CluTOU8sWi2MNFZyS7EUstMKcpoQ2daMT+rFzCVNJ1u58uApVyTVjTTkoBUmidCtgKe1gX+MmYlUaZ6MwIhqqywxczy9MbeFLm5bbW4/RZbG/TRNIOoHzgEQQlPJ2LJXrL54WCiXwzqf40LUJ0ieD1/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMhTiZNIKqqJuGAAFPb+biVFrpmcpxRR7/VE4HOO+oI=;
 b=RinxZL0XGtQxHYBLhPtOYaM52vISm9fxuWQThMgIdnnDOE+Wk+6/tUlttxCMt6VLDv7dEGD8u7Y5XEvhf1S1KnFetA10WSoimOmhAK6KFdP+Rsq0reD6QhTR0/pJGquCzyxaAKD0ybxP0hp3fueWKHn+AFNK2q+92etUtpDWq9nkuCfBoE8hB2Y7HcX4tR5ukWJlIASScr+e/tgwFe2orBHkLNfa5sKv5+uyyIzqQmZs4esiMytIPTonUP+y+KwlbQkzB0U8kqH/9C8hduXMjCHovWxsSDW2SLSFAMGC8/IRmsLCn7e6YA/ZCspleNqeDmgefFqXm0YWggppunfCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMhTiZNIKqqJuGAAFPb+biVFrpmcpxRR7/VE4HOO+oI=;
 b=HF97BKAr4nYHWnLAT4xrnPZs48wve1IiHE09/jcuv80AsmeSr6Ly+U5hG25r78yryC87G8oLOp73rBWHFa/ItGlP3I2rZW9puaQWmBR0jgto157Jm/OkcL2alRqgW/b7IYpl5yDAA4VSE1CWks1PFjJZrwDb0hMwSP2O1KD+EVc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VE1PR05MB7326.eurprd05.prod.outlook.com (2603:10a6:800:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 27 Aug
 2020 02:30:54 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::8dac:a296:42d9:e90b]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::8dac:a296:42d9:e90b%7]) with mapi id 15.20.3305.026; Thu, 27 Aug 2020
 02:30:54 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Hoang Le <hoang.h.le@dektech.com.au>
Subject: [iproute2-next] tipc: support 128bit node identity for peer removing
Date:   Thu, 27 Aug 2020 09:30:37 +0700
Message-Id: <20200827023037.3204-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0122.apcprd01.prod.exchangelabs.com (2603:1096:4:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 02:30:51 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c95a65ff-e27a-4bf2-a14a-08d84a31388e
X-MS-TrafficTypeDiagnostic: VE1PR05MB7326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB732676C58E9B094C364B6314F1550@VE1PR05MB7326.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZuZI5N1aUsIfLqAyeotV+WfXidlL81zA6slsW9L+1kpIHz4reKQXHC9tB1bN0YkXyi3Pzct/dI6v1ngd7HrH8rDQsQlb9vOctdqShqS+ke7KhUd/c/jRBcUvDW7/7g0JOTs3RO5kbp7NuFT5oPrK1kFubXQLyVHgN9bMCo0tMs7qEM0UIERMpbpHJg/u9r7yBsEITAIbDYUBo6d37hfZC9jbxhD8ykmHNgRBryF9sXlaYo2nh4//FM6PffUc/vOq/FopIEucR7XWJoq/LRsEl21USY7Ip1A0g2/M1z5XC9jUsJ//4T80+qxtwphjhVckGA09sTRR0lX4P7W98k+/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(376002)(136003)(396003)(366004)(107886003)(478600001)(86362001)(316002)(2906002)(7696005)(186003)(83380400001)(4326008)(52116002)(5660300002)(26005)(55016002)(16526019)(8936002)(8676002)(6666004)(66946007)(66476007)(66556008)(956004)(2616005)(36756003)(1076003)(103116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: KRaO5BIWhKKvqVRWI3RtnlRX6ZSPtB1ZoY5EfgWPJtmjkFa8rxMNuxVJ0WKWJqksaTqXqw9iG3fOpRfQq8zYSQ5Li2POLohIH9PnFi5AQArm8dsnxNChsElVuYAtRvgloilZ79JXoaKeKJVIZK4s34Up8s2dL4ov2/+wYroShE1sQCyGJGo5za3oYDD6mHILp+LKvpoYttWuSXCdp3Sm6/VAZ9n0aEDw3uEhrgrDyAbN9JSkLgqQlIie9/hP0tI07FP2nmTShYpOqdeb2QmM2j35wMPvxSmzVCJuv00gPRsoJmkyJMJgjVADduX5QVY2aAe4E/mW8zCy+WEIgxYSys/k5X2Ql05kbWTeYEs+fG/2eiFlpbLKNtzorfGuYoWM8K2wO4+1X/RlWWTjaGyvUEzMO1RZpOx13IYB4oPR88kq3oXadzmjydt7i+PzoDOUIpNtqol+MR5dF7E40s9iNWSC6h6Bop57X7zSKlhAX+aF0PR4S9+CsJBmvr3vSVGlVmhjnQfRzb4DFJUwsd5uMEp0/41saLZwtWS70ZM6qIpS63LXAp/yCTbZMA3m6hsyiCSiH77mJLAZow6aSYj5Z6g+MQDakA/4bni4/UnACyzUO3c08JybVBGkWD3AkOktTBmN/VmihBGhZqJOw49Vvg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: c95a65ff-e27a-4bf2-a14a-08d84a31388e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 02:30:53.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+C+7M96EhjMgcFANDBRJ71uRlGGUyJvQooDZrcF+im7OLAsgdR8wxInDwkWmkKwLRnGegiqEIRl6d7mFWu5jEzAJ+svmR7Ol+yjMXiRZcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

Problem:
In kernel upstream, we add the support to set node identity with
128bit. However, we are still using legacy format in command tipc
peer removing. Then, we got a problem when trying to remove
offline node i.e:

$ tipc node list
Node Identity                    Hash     State
d6babc1c1c6d                     1cbcd7ca down

$ tipc peer remove address d6babc1c1c6d
invalid network address, syntax: Z.C.N
error: No such device or address

Solution:
We add the support to remove a specific node down with 128bit
node identifier, as an alternative to legacy 32-bit node address.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 tipc/peer.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tipc/peer.c b/tipc/peer.c
index f6380777033d..f14ec35e6f71 100644
--- a/tipc/peer.c
+++ b/tipc/peer.c
@@ -59,17 +59,68 @@ static int cmd_peer_rm_addr(struct nlmsghdr *nlh, const struct cmd *cmd,
 	return msg_doit(nlh, NULL, NULL);
 }
 
+static int cmd_peer_rm_nodeid(struct nlmsghdr *nlh, const struct cmd *cmd,
+			      struct cmdl *cmdl, void *data)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	__u8 id[16] = {0,};
+	__u64 *w0 = (__u64 *)&id[0];
+	__u64 *w1 = (__u64 *)&id[8];
+	struct nlattr *nest;
+	char *str;
+
+	if (cmdl->argc != cmdl->optind + 1) {
+		fprintf(stderr, "Usage: %s peer remove identity NODEID\n",
+			cmdl->argv[0]);
+		return -EINVAL;
+	}
+
+	str = shift_cmdl(cmdl);
+	if (str2nodeid(str, id)) {
+		fprintf(stderr, "Invalid node identity\n");
+		return -EINVAL;
+	}
+
+	nlh = msg_init(buf, TIPC_NL_PEER_REMOVE);
+	if (!nlh) {
+		fprintf(stderr, "error, message initialisation failed\n");
+		return -1;
+	}
+
+	nest = mnl_attr_nest_start(nlh, TIPC_NLA_NET);
+	mnl_attr_put_u64(nlh, TIPC_NLA_NET_NODEID, *w0);
+	mnl_attr_put_u64(nlh, TIPC_NLA_NET_NODEID_W1, *w1);
+	mnl_attr_nest_end(nlh, nest);
+
+	return msg_doit(nlh, NULL, NULL);
+}
+
 static void cmd_peer_rm_help(struct cmdl *cmdl)
+{
+	fprintf(stderr, "Usage: %s peer remove PROPERTY\n\n"
+		"PROPERTIES\n"
+		" identity NODEID         - Remove peer node identity\n",
+		cmdl->argv[0]);
+}
+
+static void cmd_peer_rm_addr_help(struct cmdl *cmdl)
 {
 	fprintf(stderr, "Usage: %s peer remove address ADDRESS\n",
 		cmdl->argv[0]);
 }
 
+static void cmd_peer_rm_nodeid_help(struct cmdl *cmdl)
+{
+	fprintf(stderr, "Usage: %s peer remove identity NODEID\n",
+		cmdl->argv[0]);
+}
+
 static int cmd_peer_rm(struct nlmsghdr *nlh, const struct cmd *cmd,
 			struct cmdl *cmdl, void *data)
 {
 	const struct cmd cmds[] = {
-		{ "address",	cmd_peer_rm_addr,	cmd_peer_rm_help },
+		{ "address",  cmd_peer_rm_addr,   cmd_peer_rm_addr_help },
+		{ "identity", cmd_peer_rm_nodeid, cmd_peer_rm_nodeid_help },
 		{ NULL }
 	};
 
-- 
2.25.1

