Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DCA55F142
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiF1WPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiF1WO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D7A3916B;
        Tue, 28 Jun 2022 15:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5oBmtRvmyIkvf1GcPAY9EYnw/pTO96g4K1EpqsMEW6DvsQoQWI43QlLpE+qXH6NQdUHoXlmOpzlah8x32DReCzXL31rMjDQHJShGT4AE9w5S+1tUdf0zu3sGhIDoIYqeK2WNgiU8yKM7KZPb5jOCxFq7zLzkLON8QJkT5KayyH146WgfSc0IliwPb98AnzHEYLznmnUHovTwvNIIa8L9JDYKSiJhS9pYWJP7NybGtWscVfQbsA32Er35mqhSh2MpTs75RdEu8JuvkxBB9Ah7ovddzY6F6ZEP7ckXsRcSbEbWzolb19/BFUc6gA8Vnrhrr9udDfpRs76UQ0DajnmUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYexCKk2TM1BAW0Gp720sPM/RFhxakg/POT0BvAiBMQ=;
 b=HHapLHBNbQ1Bab8NAdNi/R3zEC7PKXkOq3iDvXF+3G2sx2XAdJlWIZtvw0AI4HHhpHQWqOwJSXCeIyp0ftormBpHsrkxxy2XnRC5F5doRrlJhkcLUOAdv3cEZvMaBoPt8LKpC191w5aIyXhpOedxph98LQ/DGuTurf7waqXPavWMSQ07nNNfaSlfbqYP8pRixi+JJg3yHMm34ShEpUzyy+V12pofcYHDXyCHirS1W9kIeJS5OW9WO3lAZ+woi9H34M4FsEowG2UExIxry4kXfoKw2Vy+/ENdQXrxpFjxAZyGG7n18FjjMRObnMN1p9cZOIqw8w7OsqGEz9DCvSvlCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYexCKk2TM1BAW0Gp720sPM/RFhxakg/POT0BvAiBMQ=;
 b=SdWfirly7k0IOUzAUcIV32AvS3QXzoFkc1WgnhHebY885ljTtC1KW6xC8fmD/2/ayDAKeyOhwp5OZR1T2TQHq2aYsCVqCgqg66xPRsm3wj46qP00fr9lB1hEjpovSLtlDQ8ifaMPGbCoutTReRnF/Sfp99Ytvu341kFynKkQH80WkM4lLDPl0NhIxHhGuDQSDjJ7ur5Pw/7abvNqhL74gZfPx/pudczuPjN1kn7HJdkZPIjQx8zvZPRn4HdGNBcKpHvm2au+YKqe55ASaqe/eJIOfCDW787wtANKCEkEmq7QLI1HWzDWwanbWrQsz8vkV4Yyfx69hWuJ61v3P3nwHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:40 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 13/35] net: fman: Export/rename some common functions
Date:   Tue, 28 Jun 2022 18:13:42 -0400
Message-Id: <20220628221404.1444200-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 723d0471-bbb8-4168-62ca-08da5953985c
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0YO9nxxTdOZu+pYjD8LJnjzxmw1wVykExkyoUdDmpm5jCebT1kJ68wTr1nBqqk+qcVoJ//7uVUj9H3wIWD2hE1umNBio37s2lzB2lcQUZ8E88bj3q0+Wm+C7PeSQiSMFmv0Nk/rQO+9NnYendBmoTA2GugizJg1h7hAKQaajfme/P2nDY+QhRAcBdbVDghVOvYQZjU+5nnYsTe+UqfcpqTk8Y4T0mi7LjgM6bv1x8vhFhlYdp/BQAru8T5mwpD6ccPIH8wZrzDZrFVF+/QMHrl2LaSpZeR/YsL/3ELbyhh2nEBJcBkbeLWP6/ALdTgHAbh2P7ZIheOMpZVdQKzOKh6fxQB6U803ZthBvFQl/X3mLcLdjeRXhIAj71V72iSUDWbqJwMuAEJJJIlmGEnss5vvjlSKYMpx/Kv/CTJ94PqwIfcsYon4/LAQqwBxblF8ZbleRzgU1EtPR/XOboPo2ohEJTELIVbCrrXRNUcGfIoWe7fcOylvJrZutrFbRAOaoXKagMSIlTZmh1L/7qP/+hxIfYf9I1jgZTq6KchxmkGD9vCKe19FBvEotTy06BKNo5sEIh9Ph63iacHuAXpmhoE8Jjpr8IR5PZxe3lTP1VBP8V33F50UQzUKQwYlB1Iki252wL44AJOZ2b6AWocqSxgbTkB9QUBv2OVfhFCsWnJWK4voWm00rKTIV/4su8zdoSUsSG5TP/oZiAcqeY6djiwl93+E6VkyarCIrqMawSy3icu2DDvPIKEiCtDuEl++nUrZ+FeOBQ1u3YOCY10QOqAcFHuON1pVZE5BLYR2p3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OUNNrxT5hbVrDq5sB1/i6s7b46njyK20GFntEh3fzxVVAddQod6sYkFZpzpj?=
 =?us-ascii?Q?IcIXP2fU8PNQpaFjFgQjSpwfdawZyDU9PZ+/Cc2mw7bpQHa85UmLvvgjePom?=
 =?us-ascii?Q?zSzIwLltNN+rW6Nr/zM+dPFazYVKV8rAxA9WQsrugGgLexvkj9QkCo1zMkjv?=
 =?us-ascii?Q?c4qQWXY5rZpxbw3SG0z54jXxcVJIpbdEXtACnQlI4U6w8R/xc5MAF6xudjlS?=
 =?us-ascii?Q?wHpLBB2cQ6cFnpskVDa9H8lW7gu0w6vx8NA1ATxaWgkwkmv3lyusz35Wa4El?=
 =?us-ascii?Q?d8zGBtQQgoYdb4Y5WmzVIqSIH9K57RCXo5DFPwWzVmO7eQZi43BLBRHJ+yUf?=
 =?us-ascii?Q?dHf0G5P5dBf1r6ySdWNTQxX52R9AVN5uVdHrsEZ6sJUNuwbhTlUgT4qNkAJP?=
 =?us-ascii?Q?H5yHPeA0PljHJW2//bdYBED058rLhE+so43G37h6vOK2vox9hLSS5nImmeAu?=
 =?us-ascii?Q?zBba2VHtl2KW9eT+/B0vKBFhMDFkKy9z+W7w3s/1BrIo5EcY2TuVjMYbgJiT?=
 =?us-ascii?Q?MxpHCXipG8fHHV0P+QbsCFQvXa81eo0U/98cxiE5t6D37aEJXfYnhR+U3WIO?=
 =?us-ascii?Q?BSsDcsg8nmHUBS/HomLSNxD6/44x/XSsb9VYZCDQDSbQJf2H3J7oQ8piX0Ze?=
 =?us-ascii?Q?cE4uGqijD2TK/LoyqIfTv/rEoLtS+hbDiB4OlgmCMkQdR9KGBtWD+J8CYLbI?=
 =?us-ascii?Q?iGKZhIasx2eKdIokK3JSRiY3x3c56FEZ4u5b6vbsJAo4hvN+zbhCR7K4yqkQ?=
 =?us-ascii?Q?0m8UkHIsX9KRk7dgKryNHchLPoYWwgN19x9qIDOkSBhx+A/1TJbTiiKPZQzs?=
 =?us-ascii?Q?4aBLknvJzMg3C/jr58b9FpiK0NqOoGhE5RIgRQHPVQxZw5bfCeNVMTkusRKc?=
 =?us-ascii?Q?k5575pGb3gk4g7HvgoTpv28mTrOcvEtfRsZaiMkqygsW9JZGxtVRbv6GRKO9?=
 =?us-ascii?Q?BaVEKMWqPM7u40RC0NOmEgdkxQyaEUBUe4C6EXP5gNdIVD8cMLF8AG4JEoM5?=
 =?us-ascii?Q?ZiZ4rxe2j7tTsdza6A5Ps2cmE4MVQCnKRRW1gya5q2NkreN6Ym0PydxdmqjP?=
 =?us-ascii?Q?U5Qury1vYaqI2CP3stpvSMNmN0hG++PItdeBoY5MJOnM+CDrf88ExcJ7t2gl?=
 =?us-ascii?Q?rulgj8RlIezbAjed7oMxvl0ZkTzZXC3rinXJX97Wr9kbFs/R/qEmF1CyMBI/?=
 =?us-ascii?Q?aPgtLhBsko0ORIpPP9j/vVsk2ttlWD/+Y7c9+r9YnKa0/55Xy4TshMClZG/J?=
 =?us-ascii?Q?rEGQCeLKYDc9/J+//T4aRbP918kjM8KZGDUgG6HnQsXeFxBi4XAORaD07iZt?=
 =?us-ascii?Q?F/AW2s1RyuUxNmND6tm4s6QC1li3OZQ285a7kLrMwp2XQY3Z15QLQ5EF2ESU?=
 =?us-ascii?Q?MpshKQaezuCCDRAm15eFiJ4JNQ/eZmQ+6iOqHOY2MbogKD34K7IdgvufFzdf?=
 =?us-ascii?Q?qM7gZYiqtwY3R6UXMrEW6Wn5rLCwb3tZHMrBkin0lPY4d1RqSCBbfbcn+Xsl?=
 =?us-ascii?Q?byt3Gq41U1ZcZ/29iZ1Z+hUXyvIG8y31a2xmZWbqz/69q6YT6ZMBlLDDEjNA?=
 =?us-ascii?Q?y8h7fB6z2Aspag9+MltlSy7TMWmW3+REqu6L2gETs9tOa3sje2rW8IMTKR2g?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723d0471-bbb8-4168-62ca-08da5953985c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:40.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLHP459nKouV1fP/dAwO3+YhFcxj8kvi+Mqs4OPwfhRPUN/qCMHqTCX+SWW9/btH/eQJvHEBaYZFpS1RGuPOew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving each of the initialization functions to their
own file, export some common functions so they can be re-used. This adds
an fman prefix to set_multi to make it a bit less genericly-named.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 12 ++++++------
 drivers/net/ethernet/freescale/fman/mac.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index af5e5d98e23e..0ac8df87308a 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -58,8 +58,8 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static int set_fman_mac_params(struct mac_device *mac_dev,
-			       struct fman_mac_params *params)
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
@@ -82,7 +82,7 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	return 0;
 }
 
-static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
 	struct mac_address	*old_addr, *tmp;
@@ -275,7 +275,7 @@ static int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= tgec_set_exception;
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_void;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
@@ -335,7 +335,7 @@ static int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= dtsec_set_exception;
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_dtsec;
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
@@ -402,7 +402,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->set_exception		= memac_set_exception;
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
-	mac_dev->set_multi		= set_multi;
+	mac_dev->set_multi		= fman_set_multi;
 	mac_dev->adjust_link            = adjust_link_memac;
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 05dbb8b5a704..da410a7d00c9 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -71,5 +71,8 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
+int set_fman_mac_params(struct mac_device *mac_dev,
+			struct fman_mac_params *params);
+int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

