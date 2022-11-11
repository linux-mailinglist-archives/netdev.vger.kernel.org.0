Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC17626295
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiKKUK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiKKUKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:10:22 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2103.outbound.protection.outlook.com [40.107.114.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB8C5BD77;
        Fri, 11 Nov 2022 12:10:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqI1zaQ9OsdkNySIPOxzY6F0swBjpdqe/uIOHbPdCCqHdsUvkFJzKIuID3oIYU7pRkZXkLt/SpS/3VVKjIrspkrUntMUdiaw822of4F6jyhV7cPrPO7w6gE7Ft3TLJhaJWLVYzBwbNGnL6E2o1XgGQFYjSF5/B9twa8gT6ZA7pk4l9L8a9/GPVNWP7Pl0U6Ve0dzgClAJ6wHYkkrYQePZtOS3RFeBaPo12ekg+yNhR1r6qAn14oWxiQKRMA4PiNpnJM8450jxADu/W34qU0wyDD9MqU1xUUrhjw/mLEuN1795sJC3POhXmcB2j6yyQXpCR15UqsMrQZlJtWKw8KC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n62yOt8jk9z0OvlBlHRPhB/CP0NiYVxenSoBAR6T7kY=;
 b=A81uEChPPnl6Etha7vZcu9sgFdUdxxLF8CCwtp/9YDDPhNXZYDDN4Ik46kv8qNbAkvbDqcIIcjyws1RazJA72yw6i32/qO/tkxhzuAtctLMkngamrIwV8BbrMNFGTE1uroOPbaizrmuQxJGQx6FTdQ0OlXpSVbNqC8Z4+/JpEKFSkn85W/SYr2MyKJjDJ5Xagyc2Zs8G+YUxfbBt0TgbJ9CmsRug4nfj2Dg2qOIHPwCgpbK5THFV2onxan3Lp2RIlNQb6V9RzQBBVVs8YxXPYow4ZWY9cAD3bNOV/e4v/WMOcslmzN2+4H9J4NSV5iH73eE8sEjCTJWdbwEjp9ybmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n62yOt8jk9z0OvlBlHRPhB/CP0NiYVxenSoBAR6T7kY=;
 b=pNhr1SS6Q4L3Z4/Uh0e0dq+H8KgD9M9cFqXULBWJkyo9KmDhwLTPfhRTSZUiHexk7KJ9vgopHO3wnx8mxD7UBt6iSETNT/SHBjqL76BcTqUy9Lw79JOoyfT4NRtSh/2HdJiuEG1nPCbxVneU5qSLeAHqn5iMOchCHGo5pafs89Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYWPR01MB9708.jpnprd01.prod.outlook.com (2603:1096:400:232::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 20:10:15 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3%3]) with mapi id 15.20.5813.015; Fri, 11 Nov 2022
 20:10:15 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 2/2] mfd: rsmu: call regmap_exit() on exit
Date:   Fri, 11 Nov 2022 15:09:11 -0500
Message-Id: <20221111200911.6505-2-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221111200911.6505-1-min.li.xe@renesas.com>
References: <20221111200911.6505-1-min.li.xe@renesas.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:408:e7::34) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB6593:EE_|TYWPR01MB9708:EE_
X-MS-Office365-Filtering-Correlation-Id: 5445739d-28eb-4f45-fa8a-08dac420bf44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvEh0SdDeVje95J+rC8LPHcqTSfdKFkV8V8tXHQ8vuFoQrs2lk/EDtjx7mtpUs3SCYefCq719omW0lbYrYkseF+LRGVbPqCtUvKu7QhPVXLV5kA1MUpcboN7bbJ36LU4sA1/CKGabK96d+8DdPp//kRlgURC764JkkFIlDj6j+Z+bzfUust/KW+IC3cG9KImf5jKGS3j/iMNCSXnYGSib8uIVoCxy6uTPbsckp65ZmcdDhy+DNgeEL1HP/ucgSxyVIkT1/5MiSfEKI/CDnL1g9s4m+L9fkmPo45zFS7fKj5xCDmfaqqSR9bVUuNgeaQM4Y81bvANauJKZ/NP8YBp0CHPIEd9r371LcmBSuhJRdUsIFR0uZFUWCXCeJACIMtE6r3SMSR4TnjuA+fEDklVtMyv00Gh0zmVFKZEC41oUk2OuWblArgjyCOGjc/bvwbzB/pizfOMn4UrTrRcQ5V97HZoVBwh9/SWwbCQMzTz9dslwl9Fcdl2OQ+eMG+lVlA+qM7iQc+0WHdCBClegOdGhKdDTz2D/YlASwpy+g5geh3/50CG7RDzyBI/xAfl9La01snsaQ4n5d5ve0YsglBRnkbyc8CFhW3HB3XgdcqECmr5vsyZOioGJUh0LlEvABC3IyRzZC6L9GGd+q0thqFc5m+SpSY4H9sGex1fC+m4UbtOnwC457mJmnVikoU1bMrHPCI77zgo2un4F75+IPS5j9KmELHwjbmsF/2hWBRyCqQT0jYxKGsCbUJXoB+tMkCHEueaE6DT6/n3DdrYbIZI3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199015)(83380400001)(103116003)(38350700002)(38100700002)(5660300002)(86362001)(8936002)(66946007)(4744005)(2906002)(66476007)(4326008)(8676002)(66556008)(41300700001)(6512007)(2616005)(6506007)(26005)(1076003)(52116002)(186003)(316002)(107886003)(6666004)(478600001)(36756003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v1TXnG2TrtbnyFtiQSh5e+tnJ9luMdcJAVPh+r5ZFLtyRDDNCjvemrUf4eh5?=
 =?us-ascii?Q?PDhYyYNqDkNSyFum5Oi9VvKU2tB4UOLQljjYnDx4IBQwTpNNj/zPLB4v2+ch?=
 =?us-ascii?Q?DZHpX8ze2JYlnMCZFz56zflEs/jT51sZCUM/b2Q8aCFmF1yrV4NCZeTpeR6w?=
 =?us-ascii?Q?EDaOcX5iAFgcW587+z/XigYvCyh3NJnYuZTBing6ubIFBfPJikGO1yYL8Teh?=
 =?us-ascii?Q?TbviDuNc/saseTTzT0A0MEqYHjmhyubVCkHkwizmbxDqbRZs12iXABbVeLYY?=
 =?us-ascii?Q?bBFXJ2K6MEWGtQRZdua1cycAnr8tuUPesZesR6Iu+gE9bmtYh7l58XxMvp8B?=
 =?us-ascii?Q?7fxXCNF/Jy3dLP2gMu2Yp7AM7K8yu9xNOMcOm8aqRa6BGnbEdPio6GNGjI/x?=
 =?us-ascii?Q?v/hrMZV47W+qPHHHDUrLpboyYTo5zmlme9qe8dzq6XihcCmOt7cLopvLDjfg?=
 =?us-ascii?Q?H/mp+FHrrpRGjr8vgC+D98wrQrKCy9FyWzwXegXYDD0xe6oenBvNg5/Ao3zD?=
 =?us-ascii?Q?+Jy3YvyWrEETLa7vex1ouLSbzh/mRLrgMVIurvOiPkGBSFEkLBZOwWYXCikH?=
 =?us-ascii?Q?0AuKZTEIhJ70rBOJ1V8sDE+yOjvazTRHZryoje/sKsgu/GUA61xHmi3Gp96Z?=
 =?us-ascii?Q?Um9jqmttnQ7CbedvsXsSYzDkhyAn1FI/r9WsEOOMQqM4TnTRlXQfolLf3YvZ?=
 =?us-ascii?Q?L5DZ1Y9Q5Z2EvIfvoBR1nOV1uRGFzrFN8nMx5E0gOP034bmH6Mua252rdXOe?=
 =?us-ascii?Q?rmVUIK9b8T14fwVHGv3ph7keJKKQXWzCPeKPimYEhmM3uPFn1VhPr6gxVoeZ?=
 =?us-ascii?Q?EVLWSuX0Sweazay3eYDga/iJmBIURvaBoCnG/yez9FMVBHU9mbkwrsqekIas?=
 =?us-ascii?Q?n+FyzRgwsk1+kWfjAMptsQp8lM2f8GQWm/1+i3N5qqnvYCQ5wn/ASeE/gTHf?=
 =?us-ascii?Q?/PxstEnfe2kc6qc7l+NLn7M9t+/gclyQjBvAnTZ9unOUd7fSoMZZDcVRGZUX?=
 =?us-ascii?Q?a7P1Ov1Dt62vBhyqBmbGSvPzGlkHBXWNJDApCKeBRYU/rw3TlJ/l+hjrFqXA?=
 =?us-ascii?Q?G04EEyUXzrfVuJ9N6BWE+5F4EefB+aMIO44pfWplkkmTjy1Xqdqf6gad8lsq?=
 =?us-ascii?Q?qzHnkn4iZIRgIJW6zj2fLQ+NZyGX8Uy3js7+vxqjanp/9KiB9C/x2ZN5PBT1?=
 =?us-ascii?Q?hQBElLMBwmWjyc6PdUJ0eCvTncTgirPffqeaHH/nnU610YVM/YNFqx1uppEC?=
 =?us-ascii?Q?I7xeaIoSVHXzp8rekrLxvWuILxHmuKUL5GehiGUtWTnCYdfQID70iqd9KOvq?=
 =?us-ascii?Q?qSXoISXkqyNOwYJz+P8sO11y6tgZSFeFCfPnWHtDWqaaxJnit9r418kJrtZl?=
 =?us-ascii?Q?0gpwQBAXbtSCqhTqAdlT4Bi20mm8p4oF3mqypF3uhXwCzXGr644DSf64Jbb+?=
 =?us-ascii?Q?dnq/p0ZY1rg1WzAkrtUp0aL6S96pz94aaWUXP5bsXOQraWDUy2wMvNLJvBeJ?=
 =?us-ascii?Q?3AKvn4TrzbVoFv7fC1Gkwsht6mtxfDm5n6nPq3fipPqqfZ8twGmlE5Mg5Z8j?=
 =?us-ascii?Q?c5s0deDuzrfKa9n188f9RrIq5D/D2R34Dqq1Cus6?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5445739d-28eb-4f45-fa8a-08dac420bf44
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:10:15.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnBaPRXPlwlXvwfK0X73pKgsL0Zc7McbT0Omxj2yki0TBWo40oK20O3jkH6UZddy32qGuAyDcksyLad9ODSPZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9708
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/mfd/rsmu_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/rsmu_core.c b/drivers/mfd/rsmu_core.c
index 29437fd0bd5b..b278ce9ec235 100644
--- a/drivers/mfd/rsmu_core.c
+++ b/drivers/mfd/rsmu_core.c
@@ -82,6 +82,7 @@ int rsmu_core_init(struct rsmu_ddata *rsmu)
 void rsmu_core_exit(struct rsmu_ddata *rsmu)
 {
 	mutex_destroy(&rsmu->lock);
+	regmap_exit(rsmu->regmap);
 }
 
 MODULE_DESCRIPTION("Renesas SMU core driver");
-- 
2.37.3

