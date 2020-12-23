Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1A2E1D92
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgLWOrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:47:13 -0500
Received: from mail-eopbgr00123.outbound.protection.outlook.com ([40.107.0.123]:53315
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbgLWOrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:47:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nn6+AVRNUHTNe2fjebfg1uQAEbu7nGNNYdeQUg2P20UzyT2iFDmejA1MNOlyf0gk64cZKHE270eXnjSh9MkyjEUF2Q9hwv3f6dDjXMNF3PB1anMT9FcDFbd7Ws5WGCeqtlDc0TDnga57ab5kNiNyYrJI2VE4Cew01wORSJP1a24nJ40GondE4KEL+EZ+mzs8SGg+SoZYg0Z7weqxQOwXjKBJs23aHO+PFC2MCbkjUwpoPiOFKdRL8Y/YkPrDV4prvwxDFS0sPpFqf8hSb9Fz09AKcoTTCSzqm0W3DHdndAYSlqigIX6N97F/yRVz/KKj7xfUkSjh1HEIuq/BnoaBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u6NHXWZ9zjKXMRd6L0LMxvEChU5Pzhl5HVbsvRjgwA=;
 b=hGsYAlF5E5X84cyyHrTuvOY5EOV5iaIksqEtRk9vN68ilvq1nspCXDUpPWYQw56w8vJzKqILbvpu+kktmY7QEXgSo7J9hIEEV+zLASSujELS2n+kGPR3+wgICNdrF5+efVkJ9nBGNhIlQ3/6HfnaPjRvmJJuiYoWXHzT9SIYkiO3xNpfRutXEIQulGJYP6qUFYJqmrLRyMvChLQ8fz4Dpk3f6y5XiQd0kPHWyS0a/XTSF3yshvimz3B9HLa1hwoiCYtzBUPGDqB5zlw1Iy8T9Hu+duH2Dgk7wabBKouUKjrx9DzVaYGBS4CYzFdcLOLaMp/9oMhH84L24Uj4lDXMLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u6NHXWZ9zjKXMRd6L0LMxvEChU5Pzhl5HVbsvRjgwA=;
 b=aBEzWC855dqv5kwXdNX6irK+gqtxa4njb1tBk6oEa3oOf2ye8p1StVemTJ0xEDxUdZ9aDcZ65RHV6fpCv21kOYMtZL/E+EdUxo3In76yAULJutr5vR0HOiUNvMQ1f1wfo4HxcqEiVXT/1oJ6G5y/gNe7guQZaHXSAUgAHHLfnKU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:162::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Wed, 23 Dec
 2020 14:45:44 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3676.033; Wed, 23 Dec 2020
 14:45:44 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Date:   Wed, 23 Dec 2020 15:45:32 +0100
Message-Id: <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0142.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::27) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AS8PR04CA0142.eurprd04.prod.outlook.com (2603:10a6:20b:127::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 14:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385178f8-f60d-4934-007c-08d8a7516d6e
X-MS-TrafficTypeDiagnostic: AM0PR10MB3057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB305744D551AE68AC0EA0508593DE0@AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uxx4LpjiWiLsmBTCFv6Kw6qnCX9RvD53UFIYNbO9wL3mh6bAaOhMtYKmiangYuo9eW52QQKN5tWu2kxr+CjFveBHZDKd6egLU61n0sXaDqrdVCaWl+J0EBVeGzzqo8k/atE4W2MQkQp92bn3S/nklBsknVDrK5SeKCGttOE26EQP0qPpGfd3Rv1rp5rJxbAXsRiV69az3fZ6mB1s0NVthTaSdmoOp55rSyAr3VdMdAYCFBK08j4i/lHRZK5zDzAUcIDD5dNdB6oYr4IowOfQXyyFqxWOmoWfi90AtdlvwDs2KcJvlvKAua1odFmydmNvCQsU2gii5mKVKhFejxiGjcSqPo1XMTsQdBX+l54J4dk6xdFci9KCEwgB8AtuTr3nOvABnn2p18nK496SDoYmFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39840400004)(376002)(346002)(54906003)(4326008)(6512007)(6486002)(107886003)(316002)(16526019)(5660300002)(26005)(66476007)(8676002)(66556008)(6506007)(83380400001)(66946007)(186003)(52116002)(2616005)(6916009)(6666004)(44832011)(1076003)(86362001)(8976002)(36756003)(2906002)(8936002)(956004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u6QzcvLGCsdzHKKu2Z1sK81tGQm6dCiKv8sdAIGnoVn2YMzUNte47JUhwGQo?=
 =?us-ascii?Q?OHEbz0u3vrpTWudNSVtwJ7xKUL9iO6rRLGnC/aBBLYGDfMjKS2m1KVvKlze+?=
 =?us-ascii?Q?8YZTu5n8lJHpqC4qbgLBQSkLb7UMiF2CHpnJiwgBc4fIuxzojMwduSQF/IVt?=
 =?us-ascii?Q?41s7JGzttuA/qeob1YQKL1qzD0MsiMIqnbmYjhHZPAHchHVXxJUeWO859r46?=
 =?us-ascii?Q?AV1RJmA9vu3grAHtUmNd4itRShUyBm0yZhSuTUQhoyUSLtTyWreDHEHOXCVn?=
 =?us-ascii?Q?wJQOSXGUmoLhdC3SkgrlpQqzIQ4CHyCgrFhtwLBxdA7lTzMve8rYMnGs84GX?=
 =?us-ascii?Q?adKAv/EELIz1jNDA6YpqfdYyVDa5JuNRoPjObHniez6On2jfH1yk/IScmH0C?=
 =?us-ascii?Q?uLhMAmGRJG5SicAfORSs3MDza0Mq2IjmY33yd5bexDzUQWncyMroDsQnqN+l?=
 =?us-ascii?Q?jsvqknxteyVYS6zoMhragm7r3F0nmn7598L+F0cxXbLTSg+rxMcvOrci7cFC?=
 =?us-ascii?Q?TCQxmXuL7mh5oeA8Khz9zcRUI+E6rT/HRPBDMr19lzwpVSytX/ew7jecYqGz?=
 =?us-ascii?Q?yPnT4kY6MUynEKrkk7sYXGV6YX/A5ZzbyyhuoYTwC7kzlfvq9w2pv9vrjRkz?=
 =?us-ascii?Q?QMmaZ0rM1cJ/O15MA9uwT6WId+TWqMzpcLyfDQ7q7rY5pOWUDNIGhcaTG3vr?=
 =?us-ascii?Q?tXUB7q5CzFSpllltKj4Xpi6/XXayuQ5m/c/kuMQ0a36L4WwYwVBiKYmM0RXI?=
 =?us-ascii?Q?RbWhf/ezaLZAGQy/dPwgflD40U+KUccdL+thtW9HfH0p879jnatLzUCE1V3G?=
 =?us-ascii?Q?kVB1N1KRTSboex/IWP7MeqX26KLk343GlqKy36jAMm6vB0OFLGUvCWybiSI6?=
 =?us-ascii?Q?42NFZpxLuk//XCj9gGWyAOmgVUDpaAW7UFLdVWzyoTnyW2sRMVmP1jB8cO5b?=
 =?us-ascii?Q?/uJMxACgt8b62jk3h88CGJwP6JjiVuS9Xg2ByarhWM54RZzNDT9SRtxiUzXI?=
 =?us-ascii?Q?zyUx?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 14:45:44.0022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 385178f8-f60d-4934-007c-08d8a7516d6e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+Pld56rplTeqpYkQ0d28M7qwJb5QJx5bTwmahBkpdUc9LHTxa3J5H4ZM3yPoABlg22fCgcRolJRypy06qAkssuwDENoHFHG7wlwx7KGp48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3057
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

While my copy of the MRP standard is still under way [*], I cannot
imagine the standard specifying a two-byte hole here, and whoever
wrote the Wireshark decoding code seems to agree with that.

The struct definitions live under include/uapi/, but they are not
really part of any kernel<->userspace API/ABI, so fixing the
definitions by adding the packed attribute should not cause any
compatibility issues.

The remaining on-the-wire packet formats likely also don't contain
holes, but pahole and manual inspection says the current definitions
suffice. So adding the packed attribute to those is not strictly
needed, but might be done for good measure.

[*] I will never understand how something hidden behind a +1000$
paywall can be called a standard.

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

