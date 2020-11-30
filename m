Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7A2C7D0A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 03:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgK3C4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 21:56:48 -0500
Received: from mail-vi1eur05on2104.outbound.protection.outlook.com ([40.107.21.104]:60897
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbgK3C4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 21:56:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcHe7XPcBbq5/Qlz0WtBrFxAEmlgkQ5TzwccrivO+admYrLP9yvWmt/FEi0cMVySZFINmkrK6QEWroVF4/Wz6LNLN5UbehzQkbLB+w12HLXqpoX2+qOpIVhJVF+QE050ZOfvTkDyGJY8DxS2TndQlUBznjjPhhhcZ6+1Poi1Y/AJ9fZ3yKhkvIyeUrDy75JcRd8Ps9vQGYpVj1QN10Yirzi6SDOuwsDYYHoVSJMU0RIyiIGxZITuqwpVubvNMG8mKTswwSiNgyodRw4+ktQxj+Eg63zOWJ7v25exwOjOm/vTCSf4X9W14B+WFuawHEdcw1VihR7vmhhW1xGo6kcvig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0NUo50KoeglmPrzh/2eyRcAyJv9pzilWl3eKpFgUyY=;
 b=WahISOzuth9ayBCZPoM4Rz3Jlr1/AzPsRbuTHkXbcmxWOfgvtbKBIx0ISGRlWtJ5Um+9Iw1DQD92pMHinj0vgiD5asFvbn9k4/qldOvqyIlfy2y34Lk8ysjbbD0YZXXHYu0VAc2OfcQgmSM6ounOKf/fBLOKnfXf27qwNMNHZ15JpF9nnOQfxegjVP1PPA0ZE0EcYhNW6neNtX/erIGdjtIvAdikd0XBdFfTb/dm1VU8E45rGocywStRau+aFHzg8lEM3eSGZ5MsoXps9DeEr8uyZ3Mo1SLnGVhrDMbm21JTmyaZCia+dd1gv76Qex/cupprocGfQqMX+8gV9nDIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0NUo50KoeglmPrzh/2eyRcAyJv9pzilWl3eKpFgUyY=;
 b=jQOA+xcefYHtU+YEzh+dH/bDx/UcmEtVlCOATOjOnjegoP13yV4CRzwTwxHKh0bzIU383mibALQzLM97tZ+CGyPa0L9vx4ZiPRGK/l8eQrz+0fXLu1gJLJ+reUc/lOXKN37MkuEIl5kOwLKFP6+T/PdWYFBb50cmrpJbL5XeWus=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR0502MB3694.eurprd05.prod.outlook.com (2603:10a6:803:5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 02:55:58 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3611.024; Mon, 30 Nov 2020
 02:55:58 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net] tipc: fix incompatible mtu of transmission
Date:   Mon, 30 Nov 2020 09:55:44 +0700
Message-Id: <20201130025544.3602-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0157.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::13) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0157.apcprd01.prod.exchangelabs.com (2603:1096:4:28::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 02:55:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10cc3e6f-c5ef-4a3d-2d68-08d894db7680
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3694E8E866A8B2B043961BD8F1F50@VI1PR0502MB3694.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0AxM4yDEbJk8o42Y7Tr0wsUmytxvr1EB0HwfkF9NJv7pbQ0voHGiB3JlwlAgR+zFYKpT1Mf3Bng2tGzOMyIxA322WiH+mU3+uiKbk0kYEnUThIjanc7Q7xKRYqge7biEeXwammSqvw355BeIp4P9MXFBzqwrUyN53m5JTty/cuS4ArZAUc1XaDo65YhlKYyvuCda5MgUdU6zuo9fSi77QzNu4zhMLXf4122xiS4tED3251s1DJCT7SBZVihyhrl6zKEEgmq7rb1kLQcnw9FOu79p9j0qkI7QtV+X/FA8OAxe1IB14N6y0dk/LTtcE7ohvb5xBY7McFW33A0CetHGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39840400004)(136003)(396003)(366004)(2616005)(956004)(478600001)(1076003)(66476007)(5660300002)(86362001)(83380400001)(66556008)(6666004)(7696005)(316002)(52116002)(2906002)(66946007)(8676002)(107886003)(55016002)(186003)(8936002)(103116003)(16526019)(36756003)(26005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qOox6aopz8DwSBKhUQ5ql6EmNtAlj1sUOkTnSohsoo1BS2xqrwYTdk6Ik8K/?=
 =?us-ascii?Q?fLVsuER9rfJO/2sADw7hNacxfsGSi9db5vc7+XyPlUa2wR2OyaAwjadhwJSf?=
 =?us-ascii?Q?ZYUHur/Cbr7uciDCu75P4IrOXD2D4wrUvlYS9Wi1YFnucWSLEU4Ywxzw569m?=
 =?us-ascii?Q?U0ld9gWyKxi9SwChkp2Fg210BukloSOJLCEu3VDonljMURZcsThSFZh22Z3b?=
 =?us-ascii?Q?tiefmChuBBQfH31o5L6t62Y1QwXeNiaI9mBMO8oOMJM5n7fglPy5UWj4YP/4?=
 =?us-ascii?Q?e4c/bE4LkEzWxv1Nnhzxx/yKa1qN5pmpyk3J7pPYNTxg3xJguwx7JmWzqu5y?=
 =?us-ascii?Q?vU6NuQ71QTNsgPc335OH1yFD6LLrxSl8cmzFPPC10L9duJmTAYZTOXXxO9NS?=
 =?us-ascii?Q?mVa9K+IUSYtNMc2db6zfM+Zew0wbNpvyTCkWjyZ3bWCexuHSvF+E+qTIGE/P?=
 =?us-ascii?Q?B2Gw5T4vQTNjU2BWf+LkPye6VJi7ammwp0Edatn5QYYkgezm4lXYmsFq812V?=
 =?us-ascii?Q?GmpymbuSUug/QkSYoS3CYgxR8IRQFDts3Ll9wmF/h9PF50Q76weN5MfeDDNA?=
 =?us-ascii?Q?DeHrfJrO4gzF2NyC4FDCFHXKVFeiq0PzkrmHszyksLepUN+KC94eDARrlWzQ?=
 =?us-ascii?Q?LBCHzf27my5oSyfGXzb68bafvBkO7GnoRQHJ6ktekdU9srUcCT/G04gcUeMz?=
 =?us-ascii?Q?o2+9qPXCKuqCTLI/ZIEzinUBFe95gOhFXeZgQ1Tai405H5kTbPIxBjAe//Ce?=
 =?us-ascii?Q?mH4Ajq12wgTAK/nynbKVymz3vpoPoEA/KMp8yGZatJ7faAWTF2uEX9MlXLlS?=
 =?us-ascii?Q?JZ9eOSj5ZTd6dpzZiAKdI6fLcFNv+ZcI7hSXj0PYZRNJAqz0sEJJUXusIu6G?=
 =?us-ascii?Q?JezqGXP9i9X8IYWXoApYb0IHabE8m22MFym9jMKOxybJOa0UopYouCmI4Pvk?=
 =?us-ascii?Q?E7UG7nlbZpC9/xrWy2dKwFc2Cqjblh5V5t7tn2uFAUxrVtojN+YVFAZDkuaS?=
 =?us-ascii?Q?M8IW?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 10cc3e6f-c5ef-4a3d-2d68-08d894db7680
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 02:55:58.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RXOY9o+Gp0V51+Tugf1xZRMuEtamtb0UsohIMtRtYJ45J/VMU9QJLbGhRDpd2iNnHPCS8Xc0Uy9Zl5UdKR3aDfkUt3kzsfCMNh22gktDknQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

In commit 682cd3cf946b6
("tipc: confgiure and apply UDP bearer MTU on running links"), we
introduced a function to change UDP bearer MTU and applied this new value
across existing per-link. However, we did not apply this new MTU value at
node level. This lead to packet dropped at link level if its size is
greater than new MTU value.

To fix this issue, we also apply this new MTU value for node level.

Fixes: 682cd3cf946b6 ("tipc: confgiure and apply UDP bearer MTU on running links")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index cd67b7d5169f..9f6975dd7873 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2182,6 +2182,8 @@ void tipc_node_apply_property(struct net *net, struct tipc_bearer *b,
 			else if (prop == TIPC_NLA_PROP_MTU)
 				tipc_link_set_mtu(e->link, b->mtu);
 		}
+		/* Update MTU for node link entry */
+		e->mtu = tipc_link_mss(e->link);
 		tipc_node_write_unlock(n);
 		tipc_bearer_xmit(net, bearer_id, &xmitq, &e->maddr, NULL);
 	}
-- 
2.25.1

