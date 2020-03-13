Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7A183F83
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgCMDSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:39 -0400
Received: from mail-eopbgr140110.outbound.protection.outlook.com ([40.107.14.110]:51014
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbgCMDSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:18:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFlFJEmeWvPGUDnerV+Tr5oLSinmE4MzhDeB7f9YPXVGpsSUhanHLiPKxWxdYtWmQPax5xhStVywcLn3Uew9gdTnmMXsskg1P4QQ+YTDvxvnZoc/vpO3r8TPIsV4asSjKd0BxbwDXTqOasCkPRSPVSL8gM0T3d/dIfnplostVjzPMdzENnBDubwVBOh3K02qSYFe2bsYw3p5Y2AIs1f90ZQZtYGmnXNOcJuqFN8eVSH2qnfK+Yp7aspWv2x1LqHpBQAhvUxs9DPiAqX5bcx7OyAKUQE10P2M8zC3ryQdiX1qKeBecHbXKdS4AjC/cyc3SWQxUaMWXl5nYlhCfU9qoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+RZOdLcGr567slWc7Y63kJ+k1M/svpR45bGousB8wY=;
 b=Lnl1NPM06ZOBC11qyozIj8QeILquhQoZn7uncQW7baUfCBTvIVA5v/Bm5iYVZANTv0lanTAsoahSi1v7j9PzpFbCqwESW1ru4LXJQqvPBvABmCioYJ45cfwj4/p93UGZ9vbqlV/xwINW2NbgjXC3rhEazj0HQREsoCn1LnUVeZNX6N22v4SrJerGXwcvA+PwB8NmBz6Ju97zkLBHZCEnLFFpcpaHQa8XUnyVsFs9SHZs4c4lFOA35ZXMIjFQTVMNA8QQ40Ij8lzOH4/nJOkkHhYtcjhqBHWP+HfyrAIYJli6J6xqntK14tMjBzw2+AMBhnGLP+Xy6ww9bINKX2mxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+RZOdLcGr567slWc7Y63kJ+k1M/svpR45bGousB8wY=;
 b=TCwlTuOjoP2jhQArjmw1efC8seXLgWL2WG8Ob0/pDPcNqKN+cuIj2merTu1b1F72gBsK1rDvbbn1bOzs3vO+hfYD0BL58JalBdcjCqwtRAq6rE1BmjJwRQUxBSIOB99afqcRAk7+SA8lcAG28PD4qIyivgLYRBACu6W0MQ+ycro=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=hoang.h.le@dektech.com.au; 
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.4.149) by
 VI1PR05MB4512.eurprd05.prod.outlook.com (52.133.14.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.20; Fri, 13 Mar 2020 03:18:33 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec%5]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 03:18:33 +0000
From:   hoang.h.le@dektech.com.au
To:     ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     jmaloy@redhat.com, maloy@donjonn.com,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net-next 1/2] tipc: simplify trivial boolean return
Date:   Fri, 13 Mar 2020 10:18:02 +0700
Message-Id: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0023.apcprd06.prod.outlook.com
 (2603:1096:404:42::35) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by TY2PR06CA0023.apcprd06.prod.outlook.com (2603:1096:404:42::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Fri, 13 Mar 2020 03:18:31 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0987ab1d-ed62-4a57-fb0c-08d7c6fd3606
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45120A1692BA119006176478F1FA0@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(396003)(39850400004)(199004)(66476007)(186003)(5660300002)(508600001)(26005)(66946007)(6666004)(36756003)(8936002)(81166006)(8676002)(316002)(81156014)(16526019)(55016002)(4326008)(9686003)(956004)(86362001)(52116002)(66556008)(4744005)(7696005)(107886003)(2906002)(2616005)(103116003)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR05MB4512;H:VI1PR05MB4605.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: dektech.com.au does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZyBYXkZQxCI+n8AZRzpApxEZ0XkpynjZLoTrAB+hu08RjQNhVNF9ZIZuUluVgLJY8a35a/cBGIAyoczMkLzslSfWuRJ26MI/omp349XMj9+1127FgLXc6Tkima/JsbYrfdOy43bHOkC6rMV0PxfPlIcDV5jj9EAgK0qhBypkrmKXF/Qz9PMgA8yGtzZE5PVivQlXtsXjzPUkXGjnLyk9cKA+z5WTwofuiCjUY29Oa8kOSi0umhixYimAhpZCmLbLgr41SiS2xC0N4R94NlEgVChYpZF43zd+n51g4U3PTb7hl3h9roupjgjTtl+OXfbZHX0iYigHRSBMU296czGja209PpsrEQH8vNzQibOY4EWHIO3RXsCGtNyhwGZUA1weh0Sw9Xm76u8JB7rGhxPpqIw2Y+cww9P+l+M/OjDIQ0o+uOSlByULWscBSgLWh2VI
X-MS-Exchange-AntiSpam-MessageData: 3dlAs3+aAXHuShN8lG7NpmKgdGxco7QWJi+fT8yhObmgdN+kOe57J+kBFxRWdM9rWET+79UXTDq3XYB6WpMZATqVTk32CWRuuDJfsaB6UNzRd2KJ/F5iB0M2UZnqx8BZ6CBSjf2OfOZXBtM4RREdMg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 0987ab1d-ed62-4a57-fb0c-08d7c6fd3606
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 03:18:33.6154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYKZULNdGvEZSxj3hp/+5UxGlmlXAiuxrLZ+zQBc3DT3huHO6Fne1hFGPfSOOjjuPnUup39STCF23qBOa1h/Nb/xnt5INtHDIr/Vbb9fhcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

Checking and returning 'true' boolean is useless as it will be
returning at end of function

Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/msg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 0d515d20b056..4d0e0bdd997b 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -736,9 +736,6 @@ bool tipc_msg_lookup_dest(struct net *net, struct sk_buff *skb, int *err)
 	msg_set_destport(msg, dport);
 	*err = TIPC_OK;
 
-	if (!skb_cloned(skb))
-		return true;
-
 	return true;
 }
 
-- 
2.20.1

