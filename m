Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA58051B3F0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiEEADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352602AbiEDX7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:59:34 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F45449F8D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtutH2CgseSt6Y3ymCgZ96jWWdpvXDp8qXHXT9f8Emi99n7pxaykMlDNkGLMV51jQr9nGxLw4zrIlj17LLu+HNlOCAQOJEXx0r1+DiSeaGWKEbFq2exWbWDAbRHbdwF7UnorVObDhpjRWCPlp72svdmbbgiS8mXDDB2p31vYFlhD1rTKU5q7Bhyu63MXpJfOjas9Xw2+aA96Jbf5+QIwBEb2xrsAiBhhtobIIXnLnvWKg9YyjBIl6jR1pbjRLFY9DKrnY6ROSALNw56ZHm7tLWPiZpipQmclvsKQEU3e2gNVHYV+XDIWHgHBHxFxqSjMs/JQ6Oo0K8RaqRKt3E3kfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PsQSz0CpUXzpgZH2DWNmMlZUGTlZ7FB9GUbNUjQi6c=;
 b=jghTPa2Kf98e9Y+sARs0oNjw7a1IJISN+saRhQbDhauLMg61tKBtSOH0aWOaHZl6FlfUIClgg0gGkE5JRS65KouwG2Kg713CrZHSghkkcfe28naVCMDJ7YyOiNpM0Zrw8LmkIu4XfuQsZIzunY2iFWsAktz8m3dGAlkSvyw8yE73M/6Pecvp5lziIya1OEY5gLWruaZLpmreMsQ8bIYZR2fjaU6O3MTNCziJ7HsAWk1ywRsb/yRmlNn6C2QbvXAIo8HCw/mMKfltOrCDnlkFFnHSyngbRqkU0tpwRQGciTy47suNzzsqykhaHTiS8Ex65yZ38WdtSebmA7nLrvIfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PsQSz0CpUXzpgZH2DWNmMlZUGTlZ7FB9GUbNUjQi6c=;
 b=scw1QlYDWFd55DhFURp39hY0evTtvcK6UPEDJMJ05mD3qUsvxWNbTTHCqDrs43BLmUFEQmTnWNiCnSDvUFDVfa5lNyeceXEfznk1wG/Z4CSJe025t84CXLuuv8mdCXIiO8oU19c2QaMLUE4nvB6by0OwcxYYwIlecKO2rhGkoGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4683.eurprd04.prod.outlook.com (2603:10a6:5:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 23:55:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 23:55:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH v2 net 0/5] Ocelot VCAP fixes
Date:   Thu,  5 May 2022 02:54:58 +0300
Message-Id: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0227.eurprd06.prod.outlook.com
 (2603:10a6:20b:45e::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 538f73ec-a188-4808-d7c4-08da2e299d5e
X-MS-TrafficTypeDiagnostic: DB7PR04MB4683:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4683B72518DC75816B852D09E0C39@DB7PR04MB4683.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1+BRIsmN70v6WFp7J9ywd61aUdNTtkB9hK6wPo0u1mt7uo4KB7dQKvqD9NMeNNTDQUz/Px6x76gTYS4d2YE4VhJOrUfoiCtHoSIwb59/za15v4SH2l8jIKM54eqr7GIefJUxe6CRJluI536Gb4aHv8ZUvITENs4o5bczqPw4GCe0SrW2HPBfseNZ50izTOxWeotLROpvjLpAbtpyoVD4hav563keSbdtRJI3IsI65YyIX/ki5BGPXLH50YZ9zzHeoOO8g5p6syUzMx29/7hfAQtGL0x3B1upvc7iLMFVR9KXOC1iYHyNLbpUVP1G3OnCYOttwqnBVtJZSdwMT/hsizjCl4rpQj7NhedESMshGs91YtUkcPdeKsZGUu6OTNqZ0YFV4aXkoSHwATssD9GT+8nwvpnuBei20umTig8YOYg5L6cw7pzMHkjVcBqA5CJvNWqJCVeeCBsL2j5MwfO4lSnBzWkX5vZkOF6in66SYV2poWFHOgHZwOC/hibYoalIXBjbg8jFOAy9hosj+D1hrUmSrqlqXgnypZc4eaqNkipJwj8WpEux+Sge9mOGiaa9fQmkVVy7x64gj4mHe49WjfeCpMw/spYAtKbux60k9VuDfuQTKpEpK4V4k6c+m9IU2GYCge4H/nlzJgCG3MnOmdSqYAyNS9zlaDrBt+5yxkt0tEQnq8gMD6OGH8gK7Oot
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(7416002)(6666004)(52116002)(6486002)(8936002)(508600001)(6506007)(86362001)(5660300002)(6512007)(26005)(44832011)(83380400001)(186003)(8676002)(66946007)(4326008)(36756003)(38350700002)(2616005)(66556008)(66476007)(6916009)(38100700002)(54906003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKMOmCXQYGJKv6i8bJjAF82V92ZoyUuI2rIevHSZUv7+wrUO54SR9/QCt890?=
 =?us-ascii?Q?2KLeJd43AeDuDj55RjBFNuIFub1n6VTvzd4N2yjztqqkxDZrDDlHOZRqPQ3F?=
 =?us-ascii?Q?sm7JkWbibvNWXnGJejnEBir4JXkh6zg/XS6SbHPFj5i2OQtXykMaOipZTDib?=
 =?us-ascii?Q?U6XUK905LeudmV66EDirTXGhTxTx5mPZawGn08KAhRSRQjhpAM9sZzjrnZbm?=
 =?us-ascii?Q?DyMs5fIbVXStQQGKPuc7K5OeGhvxj/Ze0oPWrB/ZAN0jHuNBPbt7bvcaVQrz?=
 =?us-ascii?Q?bbH86DeRa4nQOPL2pX7II5Km9zyLNTst0NAY/eM0v03TTsIeoMjTFviMjZem?=
 =?us-ascii?Q?iWFDSa5d8dKqkJJFGEnEYLIB9mgaeOs5o/rE2o2wSHzQSbY9JFqVZUGI57rQ?=
 =?us-ascii?Q?098Ik3j78kEsUilcsYBZsZ855Q1b2wI6vDuaXCX6TM9ValAFQEuuMVRtGC2I?=
 =?us-ascii?Q?h5rTUsdvAbZhJkhPeHzwiXYw6ZzGj0CN1NWqeuMDRHo+hDZ2yoCY9OwtltrG?=
 =?us-ascii?Q?WxIzZ4jMJeTDyadwUaqobnkE5l+lUv37X/qhKOQmi7EIKkPDU+MAWqhq+skL?=
 =?us-ascii?Q?8/g7ObpVnQ9rGuZ1QIESthSCTpMa87Q5iybmvLvZaHgwpPd3sKio8u57l/j4?=
 =?us-ascii?Q?O/fwfoxEF1MP4bbHDcc0hEcQdbFmGyq8Q259tN+bdgcvMq8agjgrpT1uPGJX?=
 =?us-ascii?Q?ja/cLdEHMbF7Ug6bVDZ8P5I7QmhMaT6X8Bo1THaBV/hDxfU4jP+xdnriHtVm?=
 =?us-ascii?Q?4wSO3WNGcbq6qzJ+1ynDk+qLF9Ya+HSAEz8BT60GuDF1Tu4njPLLb3Byh99R?=
 =?us-ascii?Q?Qq/nLUTdCvZVDhNxj/pMK+CjUoNPJ0NLIlYau0/igzgNWpWsKVuOq5+JHpu/?=
 =?us-ascii?Q?NLCb4ywv2n4RGr79yi0xCrlrGIvwldaCnCVePatJcD5lL+Lyq4pnQMV2mwO1?=
 =?us-ascii?Q?m4Pm8EkpEW+djXoO8O2NK/jtZ+eonvNXwGX6xnx3glft0PqteC/SvHtK0mbc?=
 =?us-ascii?Q?cdK03usYLRJtRsigIvGSD1r1p0u8qnq+qJDAUleRPoeD2/zj2vdKAcFxDHBh?=
 =?us-ascii?Q?2KnHrphXsmZKO2pBlevkKO1p5xZ+IXOhIEArqpU4FjBkJ7u6Jvu/m++pmQka?=
 =?us-ascii?Q?vYcfNdcs1HQFlbYLrX75tZWL/nxqrTs4kNJjOj2GHx4Bx8Afw0JptpP1a6hK?=
 =?us-ascii?Q?G5/dhu5Ev4SciYu2YJMy0fdSJ/NAUIGU/osX8SSKDcTZocoNAnd6J7gPYTok?=
 =?us-ascii?Q?DThO6yxMn3a72Mt1s4HxNp1OtHdU1Kp5f5I4+WaYZZC0zwiS1GRplAW0we8q?=
 =?us-ascii?Q?ywVjD9uaP13hHUdium28C+sXhbMJYNWjep++j2dvZbBYc42AUu3oU/2wZc8s?=
 =?us-ascii?Q?xPNdWBp5l+2xzhtpVILulWtzl58Dd2oRZ3SkV/3IB71OcYAzlnvMVMrvdDkp?=
 =?us-ascii?Q?zK7cimMTBDbFu1cRupsigRtHnTdTD4CIXhEJXW69Uzq67RLVXAAVOHN7ofx0?=
 =?us-ascii?Q?EcAisVawop5cCdsbH/P8zwWLM2ot8yX/0FSwDJhXWQJjCaktlPa/Ln9w6m8O?=
 =?us-ascii?Q?Sj5TbZykeO2mOxQF6LY0VJby3KB2mbg0J/+MJbACTYQdjIsZromVwSkh3Xtd?=
 =?us-ascii?Q?7lyyn5xaa6cCi565hb1hSIoIZP+MkN4bsvsFbXEjbbAbS6czDE7wqnP9c2Tj?=
 =?us-ascii?Q?aGkG0Xu8pwizq/eao6IWU6P95lX2/IWHpzuNn/2Za98ArjlF1rf0QOsXvAdg?=
 =?us-ascii?Q?ZrXSwlXr/9/ueMskRaYPR4r2B/OUQNc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538f73ec-a188-4808-d7c4-08da2e299d5e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 23:55:49.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yi3FDj4e78GpqMqDXObdIDC+vLCMriVjMvHtuu0FsRLrfBJ3rXU0X1sNTn0zqFSGCS2AK4inHCjeqvbGGQzQAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
fix the NPDs and UAFs caused by filter->trap_list in a more robust way
that actually does not introduce bugs of its own (1/5)

This series fixes issues found while running
tools/testing/selftests/net/forwarding/tc_actions.sh on the ocelot
switch:

- NULL pointer dereference when failing to offload a filter
- NULL pointer dereference after deleting a trap
- filters still having effect after being deleted
- dropped packets still being seen by software
- statistics counters showing double the amount of hits
- statistics counters showing inexistent hits
- invalid configurations not rejected

Vladimir Oltean (5):
  net: mscc: ocelot: mark traps with a bool instead of keeping them in a
    list
  net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware
    when deleted
  net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
  net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
  net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP
    filters

 drivers/net/dsa/ocelot/felix.c            |  7 ++++++-
 drivers/net/ethernet/mscc/ocelot.c        | 11 +++--------
 drivers/net/ethernet/mscc/ocelot_flower.c |  9 ++++-----
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  9 ++++++++-
 include/soc/mscc/ocelot_vcap.h            |  2 +-
 5 files changed, 22 insertions(+), 16 deletions(-)

-- 
2.25.1

