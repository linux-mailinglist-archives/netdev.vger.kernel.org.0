Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC77B305339
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhA0GbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:31:13 -0500
Received: from mail-eopbgr40109.outbound.protection.outlook.com ([40.107.4.109]:37539
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232531AbhA0DIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:08:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG8ZZYgaRJ6v1RE2dsfUMdi5aBbtGPvGL85fSxw5UTAbQfwV9NlzMJHFd7MXNXxq7rSxL/OfaKlc2WGFRBqkl3jw2Laq5wqwuz+P0ZCpcXOZF56S9nbWD8zAWlwvBDSYHLViP9IMC04BM1EJIN1uyxh8PG3CYr65THw6ziw03eY+h8Iui8KSoMWtbKVjIJaIy1pRB9P5nGym9VL2e7KYX7NC9luQuMU3PjhgbG0fQJ4SYn2FdQ9E9wa3ePZ/vYkEeQlnHC29D+9vWWDD5S76NLG/3URD/RR/IznHxnyUJTSDJz7QKls74/poFGNo/MfismQq6nZWciIAkG1hi2icZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvqqBpao4cixn3snPQ+ev4Oa5fjyTt9/8snlyw3mMeY=;
 b=b46Gm0Gd2sEaQiMlj/RnZJPFrsgMX+QHhNrPtdhvRVMWOc2SFha13CeiUtFxwkniKx4uZzT192sraiB4R45UjJ7cJ8lG5YL30ZXHg3vCwwcVx9xOornGH9t1B3VA9LvH8WSUquTGKwbI0sg6Vz6BfV3bizO2THAeJBnB2rl1W4A0F56RNO+725+xkFZNiyLZmbj2FvOtZ+lAToS4+/RJ0F+ToifXw/bXe1cA+P6QV7ZxJzZALym19P42+cFIIP0nyap0bflRty0pNIY2fYtdx6TUFReL339vpc9bmxHc6F0Z0hHk+8DrkZEigp+qsj4c2LjvnBWHcSxvDdPhBxvX6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvqqBpao4cixn3snPQ+ev4Oa5fjyTt9/8snlyw3mMeY=;
 b=Rn1hLbW7keYCc923eUsgue/5vxd1duhZbVkh/Vq4d5aDsfkBYG8zudDy8HyiamywnB7rVMBkHfzZ7INi1UjZjMnMMWA42JS6qNzcsyCn3i0cB99oynixJDA67laury4Z/z9e4uGbFOcqWGOHLZSnJhyDSbzHxEK0tCQ2HT52x8g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6926.eurprd05.prod.outlook.com (2603:10a6:800:182::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 02:51:37 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 02:51:37 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, ying.xue@windriver.com
Cc:     maloy@donjonn.com, jmaloy@redhat.com
Subject: [net-next] tipc: remove duplicated code in tipc_msg_create
Date:   Wed, 27 Jan 2021 09:51:23 +0700
Message-Id: <20210127025123.6390-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: HK2PR02CA0145.apcprd02.prod.outlook.com
 (2603:1096:202:16::29) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR02CA0145.apcprd02.prod.outlook.com (2603:1096:202:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 02:51:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a255b6f-822d-4988-f4c0-08d8c26e76be
X-MS-TrafficTypeDiagnostic: VI1PR05MB6926:
X-Microsoft-Antispam-PRVS: <VI1PR05MB692623F119B282B7A54505ABF1BB0@VI1PR05MB6926.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VatHwhOVTtByMEGGlvv20tU2rnSw7mUSxEMSHMBwmV+Csv+Ci93M7kImRH2jDZpd5oSdBlBESiA7W4K4v3Wk25M2+ZvWdz2hnoNVXqe8UvimyxMZNdilJuAPYXYwWm8pWEJ4wfKKhv9WE4env+ZHCSt3yUhVpHEJ5jq3T26uNgAtxX8TpT/VhIky+7knXYcbH3V0SZmGAslaT+j57DyXah28dFeOnCGQK5M7rGsiYKkZlJXNv6plNtlY/uj0eF9DB/8y0br4YJCJOVN7UwtNl7eBh+t3K+RZe2/absK1QbUVnujR7YAxvFCOllUpg0B4mXf2JVaucFkKNYQUPp5hvCgFw7sxs5pqq7AeZ/qy9CDB3rhdDLZbTAXHMWG3zwMmDbCNzzNYAy+d468ZsdDd9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39830400003)(316002)(4326008)(26005)(8936002)(83380400001)(66946007)(2906002)(52116002)(478600001)(186003)(36756003)(8676002)(103116003)(66556008)(86362001)(6666004)(4744005)(5660300002)(1076003)(16526019)(55016002)(956004)(7696005)(66476007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5ZqDdyvAmnO7R1MVyqQpNUwIuBdLsg0mFAuUM+SVXef6D1b4u0p8+oY15sgP?=
 =?us-ascii?Q?l6dYgsg3yA0xXnl5AZbeJUKMm+nHC4kfVnqnQl/zlZyCU4nmdfFa5YZ0uUeS?=
 =?us-ascii?Q?DPLNYCkeZThxpLc4aq8C0wLpAitDaFPHa/uc3UTuGxmJWlYIQe4usAt4iPWh?=
 =?us-ascii?Q?I5saKjXhJXBJEjU9UnUT0uyZmdHMq0XOE+CP2QHi51Ngeg4jIK6zZJT8C9uF?=
 =?us-ascii?Q?1iClfA1GTnzjYUzp42H4/W3sfBH+agFoO8WpRZYsSncTHyX3xk8+tNfcGnfs?=
 =?us-ascii?Q?WKzdB+WvHTxFyaX6764OSsEdRN2SK+BfH7679QbtNqS2X4Zct0pgvg3hhlKr?=
 =?us-ascii?Q?L+Hjw6xoQDcBj0JG9YZAZTwb66K1mwX+UQc5kZKo8Q5Wxs/8SQ3XjYODehzV?=
 =?us-ascii?Q?Dq+3AkKr4N1XYzIa+hJ4ryvJN4q1mHnh8MCyvqKVV/g7HKntdKnDAEvCLmxh?=
 =?us-ascii?Q?g1o3XE4FU8NU7aUiOC58bMENq5riL+LY59pwzPF75vg/95h6Bl9oBwEoaZDG?=
 =?us-ascii?Q?x1YDhOd3/sOReQ9Yrk7OcfQDTEfHjapdtEDTodU2THpGmePB7Qu1QjASJBBR?=
 =?us-ascii?Q?8sjbw+nkRkISJ1XKwcL4XMbzwLirUZKiWs3siIROrivFr4sJhhedcBDMNx7y?=
 =?us-ascii?Q?3rC3eOIygyA2YGkXlgBgpKyd4AqlDniNVMj2A496Qxc6qAohQasDGOUmCXAk?=
 =?us-ascii?Q?EoZlFzpuQBb2x6XJ/VWNJ2TXuHsYnSt9nuA1qMydY4DfNzenIp5Dg2reWDCg?=
 =?us-ascii?Q?wHdXauKmHsX2V1Mb8QpeFSoNO19/LKuS/crJhPyHx0pIy0cNZPFlcEA9TTvk?=
 =?us-ascii?Q?h8A0nd6uoO+4QBAY7Athm4IHkDmQB9ST1S5ZZ1kv+dZBydsTZMdKqvdd2Cpq?=
 =?us-ascii?Q?mUGXVUuqcaPOyibMYoSaaD2NrWQbloB9zIWEyw2VBrvAIJ/ol9Gurk6j05aA?=
 =?us-ascii?Q?47030vOPxCeSy4V7VGGzp3YBQnWi86tv5WT96fcSI9BY43BL/EWExCcOKLwQ?=
 =?us-ascii?Q?+lzjBXf0WyNOMadEkccJlt8fES2HMoDY2+Oor/Y1CzbgTlZtmDidDw8CrFpD?=
 =?us-ascii?Q?7rx8RqQk?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a255b6f-822d-4988-f4c0-08d8c26e76be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 02:51:37.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZzxLR1b/4E1irxpoEDNH6zaW89LbXTuG0V10se1iXl7UFFlJ++ChnvrH3A0O7aPlzBvvRgnGTFDIOkNk+CKBQjfs0r2vYhsl4pkGMRlNdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6926
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a duplicate code checking for header size in tipc_msg_create() as
it's already being done in tipc_msg_init().

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/msg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 2aca86021df5..e9263280a2d4 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -117,10 +117,6 @@ struct sk_buff *tipc_msg_create(uint user, uint type,
 	msg_set_origport(msg, oport);
 	msg_set_destport(msg, dport);
 	msg_set_errcode(msg, errcode);
-	if (hdr_sz > SHORT_H_SIZE) {
-		msg_set_orignode(msg, onode);
-		msg_set_destnode(msg, dnode);
-	}
 	return buf;
 }
 
-- 
2.25.1

