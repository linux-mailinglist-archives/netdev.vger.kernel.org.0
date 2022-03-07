Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49C84CEF6C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiCGCNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbiCGCNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086BF13F37;
        Sun,  6 Mar 2022 18:12:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUP9f9pR6ap0C51j2Eld40ooy9TCoqm9taqJM6VscSW+F6mLaXlNHrqOj9xlj4Gcaf5sTQzi9VRESvEDhCcGHpXNrZQhG+h0gAfynTdKrCa33tLfNBPNAQn21Zd6Q9EpLnmWA1sW8DwiKSvcE2Bqzxu5SVgfML8m9ID5mu3f+LESJYFXyZUCtQkkUuKaPhOp3WZgg2zueRjbYmYgrRjXGrafe92PUdalSgI+3SRDvpKGa4YF2oKBZPFOmgrN/Xv5T7GFvCEhNVRc1qxULgNzEdNtnS7rrKLIGGuXJsJ9mRBkORHQdy1nEBmxIOi/R6d+zlpZbgMitt8dAPw78NIW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gtp5giZsJLLEurrbwgIkMmIU7GBUFZ4MDvd0NQv6cC4=;
 b=hjWZmz4gp6qpLgMxMJ+pwkezHDGnRYt80vld8sLQIR5LUMZvKkNcWtIFpehT+yR8Wfb/47FOLNjJF3cN6uRTd6UQxDY19jOedVgpndrrAkkKNXEOLmLRkfyJkLLtBUtIl5gGGcGPMqjiZNkIRO5gU+hrpI0UwaM0B5J0ox2mrLYO0oFfXxUklQ3g53pVKIm9zJfCEc1pI0kVszDijuEI8fer+lLArBqbMw7BTtTYKOZiN06ScD/v3PpWinc5WjAvB6K15e5lCen5ijazjmXR5bLbANIEUWD6H5BS9nlz3h/ejfadxvZox3PNHX07oGixMshSMmyI4ZFkbyAHb3RX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gtp5giZsJLLEurrbwgIkMmIU7GBUFZ4MDvd0NQv6cC4=;
 b=jVeJhyJNt04ot1bHodjEbws2AId7a+Uvz7+dy/U3b9CyDmdjC1Qx/umJA1TLVAcSdij6OjHy5SWeGU3uz44L+kNhHPB91czJkqPJoLHywNKK7aTJtxc89mYhZceb4ETBxFp6WyrJQLfJ99plFOZZbKtR1kSzLiYj1NielIfefhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:27 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 04/13] net: ocelot: add interface to get regmaps when exernally controlled
Date:   Sun,  6 Mar 2022 18:11:59 -0800
Message-Id: <20220307021208.2406741-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13a2956e-7c6e-475e-4c7b-08d9ffdfed33
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4553EE5FC061B224FD30A878A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RwRbLZFmRrlzuGYI2Z2sV8wLRiOKRe9KevN++41XMIEQlzy9XKclb5xVO/iy70l6qb2W8nWfWciEPAhyew66s3m4Q8NVNPo/zktqkNNL0Y2YIKOAHP3Mq9LaIED5/p5zb6sF3iYsaP0DW5inNZJ5cBblXO1NGnwR5hM5tNqt6ayjQhd85zSTLyZ+ISeZks6N5VgXXLT2gH69EPFS9WGNCxCyp0W4ullT+C7ZBJEB65Q1ekh+jptz8v6yoAjfKhtJmq7wMrBFix+Bp3HlRonw5zH4Bhb2N87V2aRG4HtDfjP1HM96Mj9cCRt9INojNmUGHNeXJgVP5sHNlBwyOPGWszVTXiSkxl1SxW859Wqu84OSr14w074Q3WOFelzGxPT9nFiOEbHz266okJW2UsMpDaDOtmHWsqAHy2XBZNeT7oXA8P/lLAl3RjJRhalgadDNl6L0I9QMww0BZsixknr5/E2yleH4fFKOFzLstEw1eCcBcpJB3ljprNzcqM8TVBYQ401U6ImpNz+ymDAJQu5enn7RjdwVXq3Uag71OE6sjjeb9/YEaO05gQ50vnqtkBpraDM2E/ht40OmhD9kPINO95eFHC75Zi+CkxnhG+2JWdpYPYBCdOTVNUbfGqabkKZKJBKjoZBGdBQvTl2y+pCIv2dWMUGseEJJAXb/j4HZjDf9uzpU9gsOQeqvczJoSyhLwYsJ66MLmPS2s1Sua5IXxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(39830400003)(136003)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(4744005)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x/0+5kv9r/B2TVNJEQy4tm6aKuVrEJWC7uKs5U7aWn4BrjFaQXaAwzzl1KXg?=
 =?us-ascii?Q?K9YIaEA2/DYuNDwe2naer9AsO8GY37wCAqEGgQyMrrE6efkcFApASvQcjmPk?=
 =?us-ascii?Q?5UJ1INqDpR9EQbYqqzR2ugIxK8CvrQzTzu8wwK250Ph+3OhduQPZRFxXcmO5?=
 =?us-ascii?Q?yT7GTE+JY95o/xQO1MJlsqyiLYD+qh2sKP8Hrpl9jpzwORrFFDOJBLMwoQiU?=
 =?us-ascii?Q?8CxKfdQjTdZ5hY7yhuWQ5tZduRs2A0HmC8qdF66PGGbbXQebQjAt2u5HEnqy?=
 =?us-ascii?Q?4sPxY8OppfPvsHKtMqkGQVBR/e95Y5TmbTrwNnetcCB93ozmViVnbibjvWqC?=
 =?us-ascii?Q?lWlKs5it/F6429tGSOZTU7CU19zRveim6w9wXkRiUqjr4mDN8Pomca6EWukW?=
 =?us-ascii?Q?SLTTrFGaJ1EcQEo6WW3mkNNEcV9NW7mWPIXtgmld+aXqwrTZddXEu8h+FqjV?=
 =?us-ascii?Q?wyhnwF+sWDnSWSYg7gFabMiVHYECRWi9IdSVi1/dMIGGBHwoHNoPO/w77l4Z?=
 =?us-ascii?Q?QaELzDZkMjIvEeiZZskgt6n+nFyAOL/Zgb/gQ11IAr+hL+5k8mFeAjgIuR7O?=
 =?us-ascii?Q?vyOJ7q+ZI8Z0+LK8P7RBfo8lf0PVZqPnrlyT8dinRgzl3/RJKee3sZl6cyBV?=
 =?us-ascii?Q?F97TD9CEC3UzTcAnQf49vt4W2wpIwg0nC3N9R6bcn/gErIXxpEJWkS+JoEBc?=
 =?us-ascii?Q?3gI055VNaFuo4TLqSA3JFBcGyG1L9h6s8yxEGmQeN8zydEi7kt+wceGg5V+y?=
 =?us-ascii?Q?fljkM/I9i7wn/wX62Ec/GyRO4pXL2YfuEzs8FzL2YpZL8FmC5IUrFpDGJ8kF?=
 =?us-ascii?Q?bxRNQ97YoBeB1kBLJpD6lsOpKa7TsEKFJAjRVIgadgbsAbFR0LhrNigcmJpm?=
 =?us-ascii?Q?hulBwWJOCXG6DD1BhWwply0S2AOtzOKsAURmBwNsI0Z8DDZqFgm8WyYF29L2?=
 =?us-ascii?Q?hIskfg6gfUgFXG4ow3kWCdCIjOtIUHBJUnprZXl2gEStFlLSyjHlKPQA/M/g?=
 =?us-ascii?Q?/xKhUQi6JF8XbCXHNYIHjshby4zXDYWE6TWEiR/5YoZDnfNaOcBnd0GOX2gx?=
 =?us-ascii?Q?7Q9yndThipQDRrVfo8t4NiIXPfpGhh5NYVkZ/WPC9HWAP7V/d7q2QkMeAhUC?=
 =?us-ascii?Q?pGcH//t+RmkwHW6BkCZGj1wxum+EnKSvnZ9i1OE3PEwCQozDahpc6LxJeOnI?=
 =?us-ascii?Q?ikVHw6Csb82erv2FNxSocLQJqwO4f8Q6u7MsGgPR+XkcalmocIi8nUlorUvn?=
 =?us-ascii?Q?5ytNsY9s8QHZnqwR2fsloEn1Vwx7Ue8e4+TnPXV4fzbGOUN2dmHm30hVkTBJ?=
 =?us-ascii?Q?h9tNY/+0n9l7VBR4TRS8/33fYav19Wu/RR0rdGRQvrurTiv59suo82Imv+Nj?=
 =?us-ascii?Q?WzAXutwhiQPknZLwRT2Aojjcc+1ltXFgFEhnADHw1Ef116/ftW1paA1nJsf8?=
 =?us-ascii?Q?m6mEwfGGf1kUoiFCBuJIpTtNBlp2WvEbZD/k7Y+6ldbkNAEDCxkB3nAkSGYS?=
 =?us-ascii?Q?kH09VIWrsxO7G3d6x9Kqi+I7WPNxdq1ffTxubTi190aJ9udA9OTsL2BFTTFt?=
 =?us-ascii?Q?UqEKgW7IJvWbBsIIo9eOl+6GfHtcLJwjb+ELtxoa3g/YM+uKdk1bDTwtxtoE?=
 =?us-ascii?Q?vVWsMmMtGzLOutNdViCslXKir8QDVzSy3d49jdrAAiwYIpEHfrn1xmWBU34x?=
 =?us-ascii?Q?JzTi6g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a2956e-7c6e-475e-4c7b-08d9ffdfed33
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:27.5112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aN/cSipD36UW0+AiocEI3cuSQdxpIrZTwL0MeklRme4qVp0BOekMki5uLSXJvksIlxbWvrVy7Y1GxCKf00SdFaiw8Hb1dvAKsEBlbxgHuDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot chips have several peripherals: pinctrl, sgpio, miim... If the chip
is in a configuration where it is being externally controlled via SPI, the
child device will need to request a resource from the parent.

Add the function call that will be used in those scenarios so that drivers
can be updated before the full functionality is added.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/ocelot.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ee3c59639d70..998616511ffb 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1018,4 +1018,11 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+static inline struct regmap *
+ocelot_get_regmap_from_resource(struct device *child,
+				const struct resource *res)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 #endif
-- 
2.25.1

