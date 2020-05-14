Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8B1D2CD2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgENKaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:30:02 -0400
Received: from mail-eopbgr10043.outbound.protection.outlook.com ([40.107.1.43]:62653
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbgENKaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:30:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpZJnPBdQzZKcMx8PYh8Y+WLCU2xJEWyOrdlWCmIB5UmCGfnwN0k/3SLKQiu3Zu2iHdsD/PWu41YBZsINplZfajCBwjgzDPA1YFBzJZwW0TUARo9LE0TeUr9UZOXDLl6PYHuiMmE3t8jZEyZKzAkBfW9l3H5v6AtqYSY8Co3v5wMEYyVoWvAQr7fSpYIm3yszk1ow6wUWkYF+tino4R9wHrYaBHJbM7tRZKWCcQKSsMuShDvBEdzRUrahFaSiU426EbXOHKUYOXKWvu6sMliFibDxb8+qqlOpLKXbG7g3wx+BBQ5EY86+Ennx60Z12oLXUvI5LWq5yXI/A4qaFD4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aM+gx1QsU5ttEGtLawxzkFWknuflPwn2wtkvhcUxOA=;
 b=ZKmRlg2E0GVMtNrz/RCp4f0FcKvg2O7oofgbNR0r1+1x1p64nj41D1XBlOoXejIWr5M5yIwYpKTe5HMsgULQ7vmBScU42tqBpeqWuq0GQhy4S69U/4ZTTvjsMElbCADQq/PCENZo2fIevA4vCNC4RDIvgHBqR9qxZ8f2F4n3HDpQiwa7vI0UXqhML5ZLlsmVXWBYDzmvGSaJzdoo+88df7mYnMbmrk8vX/mfEg080aQO89GCnmIcZa49uTSDONSgGlwZ/QdZfDBEstWGmpFQiGPAvdCLsI+ivk50Y7oO90bKW3NsojK+ozE9RyPI4BLGVAQOaxMurx2sbNbApSLtiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aM+gx1QsU5ttEGtLawxzkFWknuflPwn2wtkvhcUxOA=;
 b=nuptmHPo6Nzi7SfDs9iNFD5sV08k3MMadkRCKbX0yb7JHzf87oo0JX8b8UbWNKeWq7rbn56l1Nl91TOI3HBwZPyCEgCPXD3A7ClyDFZ2aPGiPOH6sv7lCCNVAvUcGkrpiARtmFip2H1Gash8Ws0Zson6OOiW8JeAN6bK2A1rhfA=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB5039.eurprd06.prod.outlook.com (2603:10a6:803:b1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Thu, 14 May
 2020 10:29:55 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 10:29:55 +0000
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Subject: [PATCH 2/3] net: uapi: Add HWTSTAMP_FLAGS_ADJ_FINE/ADJ_COARSE
Date:   Thu, 14 May 2020 12:28:07 +0200
Message-Id: <20200514102808.31163-3-olivier.dautricourt@orolia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:101:16::34) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR2PR09CA0022.eurprd09.prod.outlook.com (2603:10a6:101:16::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 10:29:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9f36048-e7df-4586-333a-08d7f7f1be4a
X-MS-TrafficTypeDiagnostic: VI1PR06MB5039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB503904D90DFC4AE55F72D8918FBC0@VI1PR06MB5039.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /EZ1HsUiwS7bKSLAa9JJYwAddn75+Y73XArqcm97cQ+t4wgrbINLwYrbG78LewF7RzMjKbCFYbGRIo1zNUqn33geqQzyNMUsBmKX4R0bWk7lguWbBfeA58GeHHURYnVd/2t9msNVOZFwxkky8HooVMGJkH1mdiDEA5ic1H0pEyGYu8/mClEM4Bhkup0gQarcl81ItyaHPuvdFg2cRVms0QWR3rnpXwAuDx6Z4Jl6SUZkLsKrQSyMk7V3awhBF1JbOaEp8O8LhYr02n6D8q0FeJLuaZ8Y0c1EsaZL0uTG5aw/fyp+loIIG+J8Ykvx5Ye2GFYoIqtiMGiKvr4H7TXQrutMQf8ocekFvt29aZh0sEBl094loOtT5D92Vj4Yr4Vx9GYS26PWaPCxD+3yOrbmpTSdri6AWE9O1Uk0YaexQpyAZbiKEuD+hoOU2pTd/6OPPdos4T2p1byMGlgouYdy2RYJ3/u6FjBVq8QJnP2fzIZsxIuKnznxNptM/AQcNkCs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39850400004)(376002)(136003)(396003)(346002)(4326008)(2616005)(6512007)(2906002)(54906003)(316002)(44832011)(36756003)(110136005)(66946007)(6486002)(66556008)(66476007)(5660300002)(6666004)(16526019)(186003)(6506007)(69590400007)(86362001)(52116002)(1076003)(478600001)(107886003)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PaO5DVuhvh/k3B/60TpJzYQOvU9GdizrFYef3oaTFOU/Zd0ZhDEvG07JTOSTA82qLCrN2YoLTyvGLCUgsnp0Cchc6J1dIPmI3N4WXes1x0uChMQ+CX69XJgr0FY2uSQDgrPDfrWKkJN8jpHxGtglnp9ye7nPy8RAqtuGv3KEU6CUDNnkNbv+SwficIvgyi5esuduIwodFCYD6iG1LZf3x4XBASOzw7Sreobq6YKwnrXrHK0NdNsfLcq4GTGftVxh3XbZ8XT0S16v0KE0GXap0gG+pdz2Mcqm8U7aS7QWsas3hAx93JVra0emT+r5I5FWoJEUXW/22jre0HLL93JVgMMi+4uymwXjF0TGYtQwTtyjjvOY8nfTC6ynvvSZEkRTdcqEV/J2fkj75kXQm1gYIhU5tznLzOyeGxAtPhZOIdcw4PvEj9HCIvp2JkmnUyhWPqRKZbkOBFZjmYrurByYl24ooHWTfAVmU3oDs7A7+kLBdtDliB+rxf0eyOQve6l93F+XQRPOP6td2mneWR42TpOpIl3Ul6eEQzik536RzPg=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f36048-e7df-4586-333a-08d7f7f1be4a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 10:29:54.9946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +H2buffH/p16ZmK7J1i5F2oz2fpidMS1lb3ooc9aA3O42I9SHjaiQfo0JgtKcKCo7C37C1I7GIXyvQDulH0qhSmThEBW9d4WFYmcpMsEroM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB5039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows a user to specify a flag value for configuring
timestamping through hwtsamp_config structure.

New flags introduced:

HWTSTAMP_FLAGS_NONE = 0
	No flag specified: as it is of value 0, this will selects the
	default behavior for all the existing drivers and should not
	break existing userland programs.

HWTSTAMP_FLAGS_ADJ_FINE = 1
	Use the fine adjustment mode.
	Fine adjustment mode is usually used for precise frequency adjustments.

HWTSTAMP_FLAGS_ADJ_COARSE = 2
	Use the coarse adjustment mode
	Coarse adjustment mode is usually used for direct phase correction.

Signed-off-by: Olivier Dautricourt <olivier.dautricourt@orolia.com>
---
 include/uapi/linux/net_tstamp.h | 12 ++++++++++++
 net/core/dev_ioctl.c            |  3 ---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 7ed0b3d1c00a..0cfcd490228f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -65,6 +65,18 @@ struct hwtstamp_config {
 	int rx_filter;
 };
 
+/* possible values for hwtstamp_config->flags */
+enum hwtsamp_flags {
+	/* No special flag specified */
+	HWTSTAMP_FLAGS_NONE,
+
+	/* Enable fine adjustment mode if the driver supports it */
+	HWTSTAMP_FLAGS_ADJ_FINE,
+
+	/* Enable coarse adjustment mode if the driver supports it */
+	HWTSTAMP_FLAGS_ADJ_COARSE,
+};
+
 /* possible values for hwtstamp_config->tx_type */
 enum hwtstamp_tx_types {
 	/*
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 547b587c1950..017671545d45 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -177,9 +177,6 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
-	if (cfg.flags) /* reserved for future extensions */
-		return -EINVAL;
-
 	tx_type = cfg.tx_type;
 	rx_filter = cfg.rx_filter;
 
-- 
2.17.1

