Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD857696C
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiGOWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiGOWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:02:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229CB8C768;
        Fri, 15 Jul 2022 15:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOauI4paQaBkrROT14tChkw98Iduf6nhWETHBu8Y0qV8S0MhG9NoY/Z3fcGswS3a2e1IvLeCknLa/OhuqTVqMUMh74ASSV4EqmehSJ7ZmyCR99s7Rj5N24u4o865C/seH9V9Akzx8Pb5Sx2xhqATsbKqm75/pPtaSJiRRyGTwstgJ0ybZHlDnj0FS7CT4Tu3GFK2vFRukl4B7UsBYeSlJB1lvAsg7UAssIzDUxolvMcIiSea57p/ceZwjx5l7iwnPlDBJgqf4t6nUSdfrRhgi/SzuHval08zbmr8aLOUgPdtZKCRfGJXX8QALrNN6B5FQwejhbKrtxtJNTS5gErYAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYexCKk2TM1BAW0Gp720sPM/RFhxakg/POT0BvAiBMQ=;
 b=KEvsSjrvbeagRjMkKmAVCAz6zFJII2vrzxHpSxVjqh/B6YryePln9FSuzZQB1jMyrjDO2fv1aZxwapE3OL6Log5DhK6iSQYPj2aQLpzu44fjKd6MFAgLGLqQF8a4T2WgfD9nAauLfTs1eJ01wzM63fbAVpAeWhT7xLUytqu0ox4kM1wE8iXnIMC5c31uGEFRV/bAE+05bmTObkrNJt1b2OR9K70YB2OM5Xk8A1IvyMJb4S1vMcZMDluKXdCG2fMAoObdJMq3uwzy409KApz/sQ2c4oFDMnhjPuS9UmArFn2sMsd9eV63bX3uqiT5BaZv/U5Q1CiSbbs6SMYQM+nRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYexCKk2TM1BAW0Gp720sPM/RFhxakg/POT0BvAiBMQ=;
 b=Nh3m0MxYlLfy24YkPZE4uWQnOcpQTGPuqlqQ47bPbyzxX4GFc95ewzKgKfitC7GH2+qEYVwS2BDpKtexvkOCyVk6Qx2TwoGzq5rkzUO8DvBJc17yloN5HWlFMmUCE6ksMhQ11kaHzibFPiUb7D8AJ4/wPUamgi8IPiNmAT89d68OwZK6gUJROT7Zzxk9H8W++5QWG1L0vaT7YK52pJ3GrV/ZkF8orZ/2lrS4njixx7hsgqXJlop1GGfz6khYqk9UETdXrZr9Ph7Th46GdLxHtwZVhufvvNS/nFh/Phc2xUY+6YXBpxPfrFDd+BVIUPdHVrIVRAy50Bv76LynNp8llQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:06 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 23/47] net: fman: Export/rename some common functions
Date:   Fri, 15 Jul 2022 17:59:30 -0400
Message-Id: <20220715215954.1449214-24-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 352a50f9-4d28-4ade-8f78-08da66ad841e
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OE9QntMVjzBlUOs0SqTRWGWva01hwkT0nLXYmr7jiBCgNxjg614QPtre1qMPA9eRW/KQxoqLktGKUkPGH6TS2piiNl5Lnb7zaQUFx3IP90kY1QLb69vnsxnXYowtEMW6TIgmhaC4jslBIZBrJpR3AnvgjyvDd6xVSRO7IOG6khVIh1mALodCJNqiz+VBi/kPQdw8SzAEUf3YgTXCAqFaBZngahD9BnzetlhJtw+qjTGfgxdXfIikMDsorRpEU1Qa9DxZVh2jt908UjJXNpJ7+vwVLqffGS7eH7h4JfqC6btSDWrYyJs6pkmej32qvX1770Ssr3ekAeiaZka1PySQzBAQlYn7+QCu2rq6+3BHkyRFCc2gWmuwWPKvlYphrFDrgInT7OOSj0Y3D0OLAGptkaA13SVvNkg2zi9rXnHusufmr6N61GBE2DfoLFfTvoJPZc6RDVuqsJhrRmx9zbTdvOMldFEGmdLx+HU5XzkTRBsKPt4uwkD4hCZ7zkQpsACXutJbAQ6k2h0gCSgqVjVDaaDKb9Xsm0NQ+5WVBlpqKHkuPNkfZWtf6TvgWisBCM7py6J4Q0yCgRiRdyfDOGsvqOR1YeqDnIkwb2nykA+GFwyWfGkmXdQqAX2Pov7+wWoVDgoYSgeTW4QKwwSTe2C/feUAPKrdl0J+EJotgGVh1qVuy3UZowuZ9FN2B+f3d/X/ejaLF2e3L968Gqg5dO4qNs0XXCa8uj7tyRkm6n1peM63jmC3SStDX9p1NleOJESWhpAorSbOjBxTP277lHC9bZw09ZuyxAlRSSBhXA/4f1YawPbp12i2DYr21oU9iQaC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?txmS0BLZp93OGIsaSrJbU2fdfqNaHNsT+vIbp9DTPPmw+uE0jrjWlpuIQg2o?=
 =?us-ascii?Q?QYG5llvrUcMrAEuPaUvCKomTALa/u9mRZG4JCweVINBpbizORGhIFSQzNJ45?=
 =?us-ascii?Q?4JKKLIAo/D9QVqBbMfK/ibOzV2eilYcTT/QQU+7FAgq5pFRUrrbJrnxLYSWQ?=
 =?us-ascii?Q?Sal3FNXOJ0YnDQ6pN/+qclY+vH0VDfNKvUy9aazqMLmJ7lOJt2hN49quvWrK?=
 =?us-ascii?Q?HbR42eLuDF4uGjT6ZEFZc5hMpMEqXPcMDEZIwt4Pj9rtI3IS4oHvnzgpxPuV?=
 =?us-ascii?Q?ZPeN6Z+0//t2R3QI91hs/ZWIUbW7bWiYjp4DHV5VRjnVR/qh7PPoD40CIS6J?=
 =?us-ascii?Q?NT5OtYDWOtnGWeONll59VtYr7zlaWvT9fjdUtQkUkFAXP4Do+sgNWxOEndsL?=
 =?us-ascii?Q?v9uMM+TElVZV2Q54XmiNTIfV9yylXCwbHFjRdGSNos87PDdRy5mHpUHY3VD2?=
 =?us-ascii?Q?+vlImY4ypmBss1CmEnZP1CjZ9fcLSnEjyJENZfR441ig97VQTJI3d8OZzxY5?=
 =?us-ascii?Q?crvyS8JsfynGgQwXR9aLKFHn9tuLh4SK+49RC4IRT4TcyGNqS5Py8L97qnum?=
 =?us-ascii?Q?dJqBwiL6kg6HJjM0DVuC57qRecRttTBpX0BbVa2vSz2nV19tZiTJVkCJWBnP?=
 =?us-ascii?Q?LfaGolEdn4xtpSWEHyn1fQJE3GF9rRInj8heWPfUEQj6Cq3KAAAdG0+bXSCi?=
 =?us-ascii?Q?/jD6AF1WXb/4q9dMNicEYyggiGVer//ZInGQlypmvEdvenXr7zPa6X0aOfsZ?=
 =?us-ascii?Q?XwFd/rYc8wkoN7Wmy7MaTTuNY4oNxu25z1mjy+zE6epOmF6wiuDk3+d7/+I2?=
 =?us-ascii?Q?jLZda8r58EYar6K2eUaJ8w3zF7wcOPq7QlE/NS//bL/64CGgg1vLaSWhKEz5?=
 =?us-ascii?Q?7/RGQtX1klQewlDKlXQ8OGrpi5TvZej8A3npQZSrlWNswUSRRTta3sUTtyWH?=
 =?us-ascii?Q?3GzWK9bR8kIzf5/66Y2gJr5p/UGX1uIx8/rDCw2YeDU50UgIRgCng599YbDD?=
 =?us-ascii?Q?Nr2oNvWenohhohYFMHFmateUJZQETpCLFApymI9IHdKwp01lMoYRuBGFMSFo?=
 =?us-ascii?Q?stxOc/G5LRaSdA3weedzYMRqO8GsiwAWwDXleYk1V0Xe9EzM3e2foILc9m7g?=
 =?us-ascii?Q?bcGvzxpcy4kIAfNUAyXnTg0Qg4PijSFAQx42RpXAnqRK7s0+AtFxUItlejhq?=
 =?us-ascii?Q?M/IrJdHRa7ka2M8Fodxt4YOmw+1C16nTkb4sGdNIjKd3Yb+cMI7Y3vHDifEp?=
 =?us-ascii?Q?CVQVJOen3aWrqUyyaNpmvYHHiFR9YuK6KIkpGnB7gSs31uPrrfiTStgVelBT?=
 =?us-ascii?Q?+FLwMHhFQ5PdSa+eyzElyQsOGOAUPcQNMs1ZXX9gizg2R1q6OoFnra5MioSD?=
 =?us-ascii?Q?RoLPJLX8rZFPwJq6S8CLhZstZjFapsHGSeAz7cS7LDsfqB9qm8FA/d/T1Cuu?=
 =?us-ascii?Q?+w6wZZGPJ1UzaPtyG/r4vowjuy1uJnkAQNMZwNvNyhk29tw6aPg7nXmMcT+l?=
 =?us-ascii?Q?pz4zjMDw4auxCAyW8vusqneLo3JHIttgSne7BlzwNSM/TGlAPCrABHvtpIG2?=
 =?us-ascii?Q?K9vXVC+WTkHoBDV9EQDzr+/+gjedQbmLNCLF4GNypm/sAvFh18ezsAEnQZOM?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 352a50f9-4d28-4ade-8f78-08da66ad841e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:05.9879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYfGCIbFgXRysPIR9hfio23fQnzitxPSixakRdFhrpqx5OuAAcVNlSZddtAoRQ8y66GTu9Q5qWabRCKhzJZ2kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
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

