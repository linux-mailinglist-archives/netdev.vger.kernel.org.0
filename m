Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62A58014A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiGYPMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiGYPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:30 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8BE13EB3;
        Mon, 25 Jul 2022 08:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnpNSleJdSCUoie0I+iXtrbCmKS0xTQMBrEvn/mio7OJHD7pllFG8P6pFN0jRdmc6tLerSa3ZWGTpXj0nN1YUgrQoD+MlKDzWptGYo7F1PfhKzxSm7ZTxH7hWkBAQQ9bOcW7Y6Or0qLR3uJz9DB8cQaDeg2yHZdtvo31yE1YOFZhOm7zbuj6hkfasuMshmHRlNoa7/z+injWQZwTBmjdwuDv4NCslT9wLonV5uPwTX/9mjt5CVi/CqeKqVx6HD05XBw1zDorTih2j8aV1q3ylwnl/n1tTmC4Zbs8OYHlVeZL39a4pL/BBiAbHJncRlKHpyU87U+c6lLPkc7jnckigA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzEMv80+yImB4Wmb71Po/tzw2y5X2yRQVMwQIIkbHMU=;
 b=beNOGhD5sQ1VqB48LFKEZfWm3NhcQj+jUhGGtS+GXr7KpeWaXOIifUOHebV9NElXqb65bnwH8EX9GE99gDdYGQUQoTj8m8UtzvYnK1JAP7Jv8LTvDd0qdCk3ebQqAuqF7Hk6fxiZ5eLXK5zQU4qYZGgKM55VGlC481CzsJ9/tl+RCTnCoLDrBulHbhkTKAwj68HEKG1xZh3PBG09jmqk/+LRCopIIbhheeEMHDAPxi4Wx3x/LPHsgj5TBT381x1SelteTKf1/9V60XxPnN6u6C5hyk8kAQ4r/5AxtsJgLLCi268etFAld9U0TeV3WbsV9NosYopdlY3CnCN+2cq9GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzEMv80+yImB4Wmb71Po/tzw2y5X2yRQVMwQIIkbHMU=;
 b=xLOz3181AUypI2ysGsEPxvMK8Jpot7GI3S1PSnYWDBYLGjVWJkTBKKSrkU4hLqWjI7HjcxOUOW+0wMXXftm8zlSMmNK6D/Sil6JOdJvvUpSjFDUwAX8Dh6ut84sjMRQeW2EvhW1I7VW9p6ou6y/XgMofZxvq9iD1gfBDfS6Kho5FrzTeF3Ykmvu1+c6IF2jIx3b93a3IyT4Zw8o/XNkNtJK57MTV51iodQansMC3ZHl5gbHds5ESMeiaTKB2S8Me+1jbLEq4FfPS2qIyLeXwZdCwuGqtYi5tjNNCScDQBY9v6g21O9G4XgPJAubb/fgKh6GF29yxAsrweBiwYzqFbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:16 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 10/25] net: fman: Export/rename some common functions
Date:   Mon, 25 Jul 2022 11:10:24 -0400
Message-Id: <20220725151039.2581576-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105b6ea4-b07a-43c9-84d5-08da6e4feb94
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5nK4aSutn8YMtZWQLyipnYdwj06zBpl/JO4D/nm4L0Ahju37VKxaWFPBxr0nOxq5VEAL9znFEwVFpGl7RdXFtA/iHQIk1Uck6wtz0oWFMhAgBLevFaC6VQveTmMQI2qhqHE6kiBD39LK8SG4L66sMOB+iww+2NS0KM7/mMKJNjqRshVFf/VNJFij2phSvhtIirVBEAc4iz2r2tnnuEetjJlBtWwJ16jE9Qqac/uoVvjQ5MyjxpjhrMd+MzMvJzRFgF7buzxybNGSi2s5DM7ilzj9l4vbzJmWym4V0Qf8Yk68dhelj+jcSc3+anc7JXxWQTBLKcgRgCZxj3VJ0Ab7w3bTp/ktt2yny05S6sfSVGGQDfmT58TCAKQydMKiZZudp1sCLXX3snEnTKKmH/dXB32AzdxZh+TEWw80BKLVnQuFSjQ2unuoFG+wCwL2xjlhM7tV8ijruouJjwgEZJVSCww6NMmhTra18o7Zfm+7GaprnP0wyeF64a0gqC7fnuWRFpllwH/UPZvb+PjJbuGK8tsQoOTxjeH7CLxzn1QJd2HpFpmmKae4etwAjEFpxsizJTtzBwZw1Sb/B+Nl5DMXUlSdnpruQs8KnpzvJQHK6fQC9iv1mb3E6nZwBnHLjbj0McMsKrUBAwBNQpiq3HJoaK3govbNKTOTCgJ3a/kFz8V25uv9FaUbLfFdRRsqx/s8ryxe+v6zcaCfnYOcNYPQXlXzR6T52weV+FFTjO6IQ91ylYRQDX3PVrm2ATtqwr89gmkJl00pDDZCSKlebBki7Wyh5n92o/21oXNHlQVqzwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gB5JaBIbm+S1ZbQSkW/HMw66FgI0dyhzRmfSq0ZXDMrafqCFiykYA1C+a7eB?=
 =?us-ascii?Q?E53vO0G+NSkdR0S1ndGDGPdwxejIr9ioTIwIebHUvp0Rzlkhy44kHV4/2BFE?=
 =?us-ascii?Q?il4y1kGFEhNs1yN6QRTQDQ9xbztKFZK5Qg5/RVD5dDWuUuqDGYclsa8dIUrc?=
 =?us-ascii?Q?OwNGXT3puHb0Muz3XYekxchzZiV1tPev2fNnYyrlKx9qskTp0Mk6KTbrN7xv?=
 =?us-ascii?Q?vDb3Y+XQ6jroncKefEjBrWS8vs0yl0WbYma+DocSnNfbava40zDdFJgZ7khv?=
 =?us-ascii?Q?ICALbWASxdYsEzCKSqipS1qBz8JJbGhXqJ6OQHg8oLyKt5/0fGH58Ewge309?=
 =?us-ascii?Q?Ewnis2QC73xCmCVQYI6QkrKqiDExEw2ovWnpQeSG+pZaFhX2iUJT70MZxElZ?=
 =?us-ascii?Q?RjSF8OXWgIX9POtxuRibb0Cekc2IiyI1P2w9Ce1e31r4w36+zgCnGPhCXUyq?=
 =?us-ascii?Q?9deuafys2q3SB+UuBIJbUpXJv58rvY+y+bUCpUnR+zX1g9N7VPVjJNQV5Uzw?=
 =?us-ascii?Q?ojKPUtq7ljo4CptYhqwHe0smYDWYnVYPocSo22QiDOVCF1qQZx8OFBJbDaW+?=
 =?us-ascii?Q?zMbJsWemtcGTcq4WwglNPVxaF+Hn8i48U7pHfMYVLGMa2CLcvTPcqhIxcVeO?=
 =?us-ascii?Q?jtLpntMNBeXcGMfRT2E0BneohBS6bKd6Sn7T7EJbVeShH4jWLA9ILi1jF0Po?=
 =?us-ascii?Q?/nKeQabLpgdQ00AvPShUa82z39n4GNCtzoqyseIGWJMxOReL+/39HvpArwr5?=
 =?us-ascii?Q?yPFJEz1Qxf+Md/f9n0URGs6M18uvnjii6KZHuYTkqlkK+5TYSVzKAszpBjAQ?=
 =?us-ascii?Q?g+EdnNwrcp1xp/75XuAaTqgeZmjZ1uCiG9nxRBQRaohoKAxydOV7vrpucNaF?=
 =?us-ascii?Q?A8gmXuYf1amoZKqdSQTHyYvnl96924nR7tLB7qffYpyNGPW7QGJ0CsxxFkcR?=
 =?us-ascii?Q?iAwTxnxOA8LQEa47LvPksXvFWQTTQ0guMB15UMf/FkgLV9RS8nfickEKs1cN?=
 =?us-ascii?Q?/6Umykjmtv3EWkzMHsE1fqtLX71EFgjQgWqSWXkiNJ4pB9apLDS+pWFPpK6u?=
 =?us-ascii?Q?NaP+gyGj6DfbnYjFv8rxftoTVGjFnmOEc22fYw8LF7ZwFwSVlDJmlMgyUlpM?=
 =?us-ascii?Q?aQCmOrZ2Lu855PK/5puD+JWcq9EXy/RPn147JuIth0MYLA+f+UhKFJzNM/vK?=
 =?us-ascii?Q?dbkGNnLjCl/o7ryKwTUXOVRFWGvLdvQqQlRbh1kwgHbRXm20FwLW8SJz12ZS?=
 =?us-ascii?Q?oaHLemWBtET8DkUf/uTti9bAfoNzQpIitZsn/TDEzqtZRlEJzokl1pAVCWrd?=
 =?us-ascii?Q?xS1WoBkgVZYcUW+tllhJh2HiGEcNClnlhPZAmXvV/u0W007kPuQ3BaCe6Amz?=
 =?us-ascii?Q?zUop9KjCSdyuYPkPCGE+UxTxApsBkr4EDFMT9eGiqTJDdYeE/thmAEkRTfDX?=
 =?us-ascii?Q?fXvmT+ylEpBHWKoMbsc9Mji06ODh0NoGxYVrCr4Q78YhbJe1QMKnqlDObiYY?=
 =?us-ascii?Q?uzCglM5F56Qrsaz/6th6oDxm9chT+/j0f/JqhbglsLige8CfJ5s5F8wdV/Ss?=
 =?us-ascii?Q?izu7aTLmDLd/aMjBLhBERMksjVcWpehirPMyFQJP+tuXgfIDkYykXhrRLLU+?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105b6ea4-b07a-43c9-84d5-08da6e4feb94
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:16.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sA3k8i4RnMt6+beHxJsxR/XY6J2mrzeKm50IKZZcwNxXQv/qzkJlT2XM2MYXpQaZFVHYSBKQ7pyVhQLdMO09lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for moving each of the initialization functions to their
own file, export some common functions so they can be re-used. This adds
an fman prefix to set_multi to make it a bit less genericly-named.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
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

