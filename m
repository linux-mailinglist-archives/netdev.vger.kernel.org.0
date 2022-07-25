Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA03C5801FC
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbiGYPh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiGYPhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:37:51 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDD1DED9;
        Mon, 25 Jul 2022 08:37:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqQKgJJKlvyDlyCi9SZnCZ/3aoMuXtYWccghvmaXdTDvJg7V63s3V5j00QnrW+Kj+KN8NiFIZ1B8P9Et5KriqU3Nya1v7qVKF1xQk1vCbVEWmZ9maJXb6uxrG9/Su71IsDzhzzmpQyJx3WxbwNQmwEq42G5o9rDo7JkDAcyUn4mDmSSBChR1sZokJkt9ZW/YrQZWTBmQncH7+QVMaS8h5s7u1p0KrYpAaChZznbha4EgA3Yn3YkmuOy06ySo9HSTuKknLZmCDSQce4Q3YriFf+Z6ZsQHyDGfcIZvGZLzijF0vQpHH+9vSgVSL5A3CwLwoN6vAJQWecq4RmfIB7l0mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0XZi1b4JjHhfpkH4Wem4t92cp9V4sUhYANs9NYOBrM=;
 b=GX/x4hhzwTZsNEaThv5FQVvUQih/QUZxqB9c3yfPUYNYcyjqO0I5NdZt1vbVB+4VzxkHeHKHMjcSMRzBzcreSWVFNrmPTRypffZx7TDmD7CPrRA18/4rg4dju8jW8ZO+YX2NbKtgwMANMLy0uCo2OuVsHFgF6cYFWlr8XMrvo5VOObsqF6JVRHCJwIYDWPy44jv9kP+ccaUmC9w/EXOvKSOGFBKAsgqiidUUjn7Fa/1NB3iyC9+Qb8oNBbmglFpHbvkJejcR9pY4WKs/tcFHg9qZtsmnvY/V6FXBYLj/VpYxtR2Kd//7MhRrP4Xm2c5JWqZeQHK0LN7D/AegtdqgAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0XZi1b4JjHhfpkH4Wem4t92cp9V4sUhYANs9NYOBrM=;
 b=eGbq+s1qDCNHRXmluSQuof+TgkBAD7AVZUyX+g/5w8Dx1gDxOJaYiECofQs0EX8x2ES+oH5VCZNZ8YFj3TomgqnMkKMwdkNz1SRmqsBhxO3og9TFiXxvW/tpqOLju2Oki3mIxjbvmCkWjAlBfBENga5k0MZ0fJo0+hSD0LfNw/rp9xOLZRB7xlEg+78ABFtVwqxLd1Pv14MJbgPobqeq1QtbEsthyli/I5kBIYyAPG8QaBvfs9JtL/1VkhXGt6oDyqUy87nMZzPg5EaT+ql2hWgROY5+hHEiSOm6qWl2qqyrOS8T+DBVNo2gz8/STJxHaKh2NLvkZCQzQhnpxPNAvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:37:48 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v3 03/11] net: phylink: Document MAC_(A)SYM_PAUSE
Date:   Mon, 25 Jul 2022 11:37:21 -0400
Message-Id: <20220725153730.2604096-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde730ab-4a0c-4458-8094-08da6e53a065
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fZCSNy0xqOdTvMm0IEtBmaXs3zWwQPEol5lfoRMYThEJGG021Au2q0BSvlJYKvfdCyzRNJXzV1R9x81lS20lansY7np+FJRfmKwLBHBhjJbnNerzWYq4a35mEgYSpqngYJYkIF2vRwNBu77lFZfZDdcN/2JKDDJ8UQwde81hJKotdJvlcG38M3xUhCNlG7WTeo2F8ksk+AQOlnhhTiEZ5cVBIMbqJps/6wES9L1zxuKvHqTi0N4r7ilAqSGVuwlccJ1db9tl4djmlHf/3iC4lDMLV404LQkDNUwNIeraTwtzBrUbYE/qt7POaL7LKlpSPnpxH5yBf8st0Cy+3iygv8airS+I6ha6wOK10/sX3rA6gkLzsPCuXDbLVth1pjoQMGqA7HuxB9KZjc3/uCXjBPk1RqJQ15ZcYkaPAKxK05BhpBjMrvMoKYuAgE/VJln73hfLw3LAnd716ZWi4bM865OyVFInYpwUaZOPjz3kT9WsLuExDRSkFI9InPQDh8Q69ecbxFR04V2+4ndfD1+G5WpzeERcx5diFO0pocx0hEaax7t58yEnxR803Q5hOiqh0CqGwQFJWtE6ZTfNWyex4d+RiTzOpObfgN6l6iD1+DPCq5LsF6v5FRUAnmbMcVXd7NpBYA3F88WiZ0Pg9FMt3eVsObyVz4Y9RipaV2TTtrjsrkRYhKNkEC6ZjC4sO9ueDBnHnoRvK7GYrBKqY+Y2sXoAnkHNjQzgb6ed+YCDKtOcf/udcmWCY/PHRhFQ0qliQWOFzlWFET2hi0JZA2jQwxTB4a/ozgIL0B1uBFu2Is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(110136005)(6486002)(4326008)(6506007)(83380400001)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(38350700002)(26005)(2616005)(38100700002)(6512007)(66946007)(1076003)(66476007)(8936002)(44832011)(5660300002)(107886003)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?doDhgC7YAykw1FMbPtTmvbrMiYpk1lyd/TcJDPuFyyDLfi8iX1L8AJHvc0u6?=
 =?us-ascii?Q?bfnS4J+UP3ry2arFR3nLtnN+CVRfZgQ7LSOOrX3QA3S1wOvnn4SIR5SG/wb/?=
 =?us-ascii?Q?SLg0m8xMwOSHnbHN49boE4LLXTrlz9HhLozqaY1s+TGYhrbqoztDJPJp5Bvz?=
 =?us-ascii?Q?8GpiXyIhtTVmIN10LfiDROCfgbs4144t0PMl8WVKj4nXATa8z09sdG9BL0/O?=
 =?us-ascii?Q?XmqfQzP5+GfvKPqwZKlyo6dQcGvTbAoO2AHDAE3vUERIBlo3QOqSyzcqUCRm?=
 =?us-ascii?Q?09tj1C79094ekUJBYh/wc9vTQxpGH5crbvOQ+/2VakzA7g/CC1v0hWck4CFH?=
 =?us-ascii?Q?mGNqZy2FHQgKF2QEHGs5InlDk5hNUIvV+UG56RdCsW8uuL/K6qP9CE28My8j?=
 =?us-ascii?Q?Zds7E2GKItJiNDY+r3QnqBVEdw10/42iKzyrk4ztdFCz0AZA4qns8O3q2sBX?=
 =?us-ascii?Q?Fkx9NMSNuEuEG4mkjwG3UCx9rEapTeghBpU68FNlZwwNoduQy8nghUGE89Ia?=
 =?us-ascii?Q?LSXpglBwgSaDncU9sXQDknAEgntshGus1zfd+DxMMNUYlMNAmGrvkAlu5UXc?=
 =?us-ascii?Q?yqu/3QVCZNcmtb5LnIGdig6wCjGOdUjVViBM/7RwI047fWZorGp4onuSBcIL?=
 =?us-ascii?Q?zqzmXuNEaPNonmCJ2pJi6AM6ZJtrsOLpFbOpKWuCkqXmkan0dagVtkYyMSaE?=
 =?us-ascii?Q?zSNBPTMrmVSt/puxsBp9hQjRIuqdrUtJ4PmBxYvaZ6sgSWgkkhx09RA0lYLu?=
 =?us-ascii?Q?8ekLtwtntGk2eS2YZRYOB1OlRlqoRBv4zNwZ77iNQ4OhmrT04R4hQpf2RugP?=
 =?us-ascii?Q?PzqELZ7n1tA4QYQ8KIXAcABVRaCyvZgoLpNVqNlwnfrGk9w2FzTItH70NR0P?=
 =?us-ascii?Q?MBS+6SGGr50h5n4eMU1M9Ub3UDkZvWoF0AdxEg/6E9cGxeuUFoRdappHPtyO?=
 =?us-ascii?Q?TlyVV449FY828r+ObjrBEYnl558d7wuEjuFwJRRYxQ/VhWsWYxDRauas/V93?=
 =?us-ascii?Q?0peMdDsu4RNrZQZmnnMK0g5hig2yG8spK0//J9rZm09GiwbZh9eTJk1lB6l1?=
 =?us-ascii?Q?za2NxJ90U8cm8L3gTu6UmmIYRh1dYW2RZbCmZEh2aPbVu9LE4Bmz+kiZzJD4?=
 =?us-ascii?Q?lCluEuFTKAqYL9QJaUzSPqEnPanXPlpd4N/BNlbve4Df0xoHpRIr/1LJv0Ua?=
 =?us-ascii?Q?CeWGl9+pozv0zyfbQ5JmiKKr4Yh2ttBaIYvfZ2eoikDlMt/WSEjK6eijFs9P?=
 =?us-ascii?Q?qpHWX2jafjQCz4IcNAwg2WSBpy/sJqmTfyjscpyOtQYx9TrFI7w6d/qvDFee?=
 =?us-ascii?Q?5h2MMY5RV/OQFZWXq3wgjyIE7wn6fHZ9gwGzVJQgehP1MC+eJD7KmI3doG4z?=
 =?us-ascii?Q?iIsyLlOcQ0MQnQvxzmww/5VceuVnvAk/kY/vw4UgLKqXM7jDx6wJHb7MDgwu?=
 =?us-ascii?Q?z3ETFpE6xb3aGrziL0seFUFERzNkNSMFUPjBQSxe4wEUc0Es19i91Ntezm0H?=
 =?us-ascii?Q?B18C5pGzGzIwIgkctfNTwOgifncquLvLyZjEkZMoQ9D6gOj23Rpz0MAgwOfR?=
 =?us-ascii?Q?7e93LVWo1pDhWtUJYLqUNHwhni+eOM6NXXmLJpQ1D5LmTc5t0O77ahG8VqF7?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde730ab-4a0c-4458-8094-08da6e53a065
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:47.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+ma3rvrekcsD6SqYSxk7qIdA+QN95HoCDgijjIh1TLZaQog5FmV8HExl0yzFaxCocWYF19+sEaUQkbTW457mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This documents the possible MLO_PAUSE_* settings which can result from
different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
direct consequence of Table 28B-2.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 include/linux/phylink.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..9629bcd594b1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -21,6 +21,22 @@ enum {
 	MLO_AN_FIXED,	/* Fixed-link mode */
 	MLO_AN_INBAND,	/* In-band protocol */
 
+	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
+	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE802.3
+	 * Annex 28B for more information.
+	 *
+	 * The following table lists the values of MLO_PAUSE_* (aside from
+	 * MLO_PAUSE_AN) which might be requested depending on the results of
+	 * autonegotiation or user configuration:
+	 *
+	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
+	 * ============= ============== ==============================
+	 *             0              0 MLO_PAUSE_NONE
+	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
+	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
+	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
+	 *                              MLO_PAUSE_RX
+	 */
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
 	MAC_10HD	= BIT(2),
-- 
2.35.1.1320.gc452695387.dirty

