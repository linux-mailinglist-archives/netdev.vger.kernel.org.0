Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0672FF621
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbhAUUli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:41:38 -0500
Received: from mail-eopbgr80094.outbound.protection.outlook.com ([40.107.8.94]:39028
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbhAUUlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:41:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2olWdshACjiz6+goxYeNDGFlXD+kT5dpJm9RLKpy2T1VyNLwJciGomxDswM2qqfiZ4uecPNPUYgUzP7Ldyiq/EW3nO0g83qvvxX109F24iX3hbQX+gwG1TGM3K0kouusRKcIMHPMaIYxO6lZR8ooqHafB1raPTXmMqq79rBKVhGCBB0IOqgYoCZZqu0D4WyXCWdRjLUJVZSWPYAjw/vqhSAdhF2WnJwnDpUji+ADgN2PnX9UeLogW9bCld1gP3AAX2xPOaCc4k7Z6I3MkkS5STlWbgg72XWgxy43vnaGBuR6vtBmhVm8lxaq+dvoLLp8EUv96yG7VF9kugeX43Dpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFZ0HHuleuUIgP28zu2sJ1XgRIpq7ow4D856zIIdynM=;
 b=FgISAlSZW1gRtZFKx5yMtnsN9kZIPaG/JnmDQk8i2nFp91z9HmbTm9y0kKIuj7zVL+c1hfvJxEkomxpIp4XrSyjtb/IEOGmsf4zI7FqBvoRRpc3FGYY6j6hTyoF+hmWSTFsZ4w13HXwbS6MHwEr5FYQcA8WsB6XavgZ/JUD67ndWgoz1utpyl9nd17KJwd6EOCM64n70CxkGCspE9WwazbMT5u4r4/YnMXWTRlIzWVupUgtYIwBRCKX/VuJVjHE6OPDly/H1lAap4K11M+LCJY1oegc6GI3QNPhgy3DCKDKg0UCrOfqXZx23oHTKvqaWoMXRnkvbkPL/rD8fgEENTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFZ0HHuleuUIgP28zu2sJ1XgRIpq7ow4D856zIIdynM=;
 b=D6/NNOPOqPMDzlLFyyYO4yrXpMmuHq9vR3c7c7duztgEUXcjr7lGvlIYoqRGP0HSN6iU3dWzwZ8kMXMAQtn6YWgMRF1WgIuk9GuLG2N9cNCaI9MklsgkEl1dML0lkmFD6yO0Fmn12Tjr/4B8RSC705jFI1y86LxgUcinP/ZZiXo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Thu, 21 Jan
 2021 20:40:48 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 20:40:48 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 1/2] net: mrp: fix definitions of MRP test packets
Date:   Thu, 21 Jan 2021 21:40:36 +0100
Message-Id: <20210121204037.61390-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
References: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::24) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P195CA0047.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 20:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f336f4d3-3d3b-4efa-18e0-08d8be4cd548
X-MS-TrafficTypeDiagnostic: AM0PR10MB3011:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB30119D79F797980A17638DF293A10@AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQDbmyu3weGnyXkMq8RtzaaDM2SnCAaBzscHDyl6BIy+OpC6WP1Mg/6m4AjsWc867VHPXp1jg03aTGGwKSuc9rRyXCI66tN+746uJYdMXkn30go3xi0gepJ/t7XdFdhOog4SmwWIUMm2TRC1eQXkKBrMhJP4Px6Z0jQGMLHVNoU9UysQosH/B6atAlidYv+htSygDB/FxBpc71KZc6LeMyBjjA4nziXdbkfyGBWpWdCB6QVVJ0NR1eYh4GdGT5Qg+x9QLndywqDT0iss8BclPE81zC4hsc4tg3bhdyESn7FrfiLY3X3PVF+wxvAfmX9P/3ITLtWrX6nUR0rADW1ZzeAE1UT8VP4U8zp/EDsYb+EkEPClfF3SnQFwRpS7McobjsB+Zlsiwq9jYoMB2a736w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39830400003)(346002)(478600001)(2616005)(52116002)(107886003)(6506007)(5660300002)(6486002)(6666004)(44832011)(26005)(1076003)(86362001)(83380400001)(4326008)(186003)(316002)(66556008)(8936002)(6916009)(8676002)(66476007)(956004)(8976002)(6512007)(36756003)(66946007)(16526019)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A9/OdzmOazoJVFXFdmmUw+o9V3OY8jIfAlfmXnuIIU2N8j7+0iPgIrdzWcrh?=
 =?us-ascii?Q?WGNTYAis7SshBWQxknsSMJpWYAjxk+890XoMDsm7RiUQhaq9BP1x7fC0GR0j?=
 =?us-ascii?Q?gQbhmGVQNM+xTbUYZfrwxANouUZ3NGjfRdnMf3Z+scyC8Uw5wrrHE8X/R+OT?=
 =?us-ascii?Q?itZ2yEXq55QdGfC08m4RBCyx5Sv8iX0VeKSgtRH1IISsgeo0Ooocru5tf4ar?=
 =?us-ascii?Q?rSDN0xo4pB0YMFQ/R9RqTm5sjoDLqorGlHfdXT/nXaaKl+kprmUlWW2vRRP4?=
 =?us-ascii?Q?2v4Jyj0Q0Ha+uo7s8mAGc6x/9PlfSjKdMji6iZjLc9StGPxq7bwsYaPQtFi3?=
 =?us-ascii?Q?0EqNcjI80Cx53lIzTgAyG8yNnAsvCn043oXab6bK5d0hohBIhp2QjcjpmBep?=
 =?us-ascii?Q?FqzMw6Sl9x0T4CKTWA4mXxJv/p1lB7204FvSaabRo0QEQpfR7/vQmg00s68D?=
 =?us-ascii?Q?yGD/lgxQrItY9gKlsn7cJQ2jR+bBrKgdqqdtV9VslZM6w/eH1wvsorKG0du/?=
 =?us-ascii?Q?0B9bwS/NBlStusWPlucW7C9a2bMz/vL6Klm3OpuJMAOGoaYKeDgNRos38PO5?=
 =?us-ascii?Q?iNhDHkO7CsVHOkNClEpEOAwccDLcDh6DpmJww1XCO4dMWHJFZmoQs38nudqN?=
 =?us-ascii?Q?ZDX0JGJT0QegFwxmfkQ9D/kAxKzBbjrTWq5b86m2sjmpUnAOHVDeAvpKVGdZ?=
 =?us-ascii?Q?sP98pEbwIMhXkad4c2IuiFF9i7b768NuL9unHOx4W/qSCZR2po3SGthfEtf5?=
 =?us-ascii?Q?oSXlUTx5kMTinvt+AN5VEBgjAWGbuTe9K8IUXPrU2ouYk7CI/beNUpiP4yDc?=
 =?us-ascii?Q?gt6/YjxJxM+0hZckXNRbUVXl7fS9msNTIQzK+HIlGSqKb6NLVKeOsdBHdrxy?=
 =?us-ascii?Q?WCqL9ev8GYJhn2qGbaMJAJzklsKIzztzsC33Ox2Sesf+dLvSNSeZUOmGLYYC?=
 =?us-ascii?Q?9NHmy6Cz3JUyrPfU5qv/0KEEeXXtCcElxs/b5spMhwx0fp0PbDJRvVYcDEm+?=
 =?us-ascii?Q?Hc9G?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f336f4d3-3d3b-4efa-18e0-08d8be4cd548
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 20:40:48.1117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TTUB4nXm7w+aZO5i7WfFOa87sAZX0zQCOCvPjBw8IIqC1Jdgx7AnYsD9Op4OyPEYhE7RiCPe+6EWIzlVCF4ky2nndXIIdtT3tC8LXgSQELI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wireshark says that the MRP test packets cannot be decoded - and the
reason for that is that there's a two-byte hole filled with garbage
between the "transitions" and "timestamp" members.

So Wireshark decodes the two garbage bytes and the top two bytes of
the timestamp written by the kernel as the timestamp value (which thus
fluctuates wildly), and interprets the lower two bytes of the
timestamp as a new (type, length) pair, which is of course broken.

Even though this makes the timestamp field in the struct unaligned, it
actually makes it end up on a 32 bit boundary in the frame as mandated
by the standard, since it is preceded by a two byte TLV header.

The struct definitions live under include/uapi/, but they are not
really part of any kernel<->userspace API/ABI, so fixing the
definitions by adding the packed attribute should not cause any
compatibility issues.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 include/uapi/linux/mrp_bridge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
index 6aeb13ef0b1e..d1d0cf65916d 100644
--- a/include/uapi/linux/mrp_bridge.h
+++ b/include/uapi/linux/mrp_bridge.h
@@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
 	__be16 state;
 	__be16 transitions;
 	__be32 timestamp;
-};
+} __attribute__((__packed__));
 
 struct br_mrp_ring_topo_hdr {
 	__be16 prio;
@@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
 	__be16 state;
 	__be16 transitions;
 	__be32 timestamp;
-};
+} __attribute__((__packed__));
 
 struct br_mrp_in_topo_hdr {
 	__u8 sa[ETH_ALEN];
-- 
2.23.0

