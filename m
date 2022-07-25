Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696ED58012F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbiGYPLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiGYPLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:01 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A819FF5;
        Mon, 25 Jul 2022 08:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZ3vg6y5e1RXn3GIEUlZmLzy3/69Agq4QTAf75a1E1M5umFuo1lZoT16vF0993hJf6jxzGzlULqu8QOnlj720bxNir3OivgeF1C4FXP6wB00Td5e4Yaj1mnK1VaGpg1lsNjQYCMh8NATfBD9GzyvZ3TFC8m5GnnVKpAI6EWftY8fv9BFO/4QEqT5xR93Ii7RYPbkmgilzCw45eiWlTnb1HTrLL8lM+dfY2FqSPFK03iHV4XIVXjwHG369wVcVEphu5RM4kCnOY9AoFs42HPo79eC6+4l7EQHu8FPAhn2ATL1OcE5kKdEhRc3scDGqlIiIFDIcg8stCxKwwQelowh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO8ROTcaT90018JtrQ0xpZyawquVtsOjOiokopmXpXU=;
 b=AwAcK3CLManywtGNsSyXxAi3gSwTySPRbW1dqJ9EOink2XTr8UimgKy6cepSZgHiePEd/hsnlYTpXsDOnTtdRuPrVSDNAJfrXwfTiwton8l00BzEpRiz1kFGHJxkjG4PviSqnnVNfGvMkvEvcxGNwwQplsLafTfh5L1FKfJ6Gq3VquFG0fmYMwk7+lWTBh4D+lqZDEO6ETjtLff5gKSwGI6D6G64rswhqyDFsJCLID2DmuP+VHbZbehIRjoAFZ794ZOJmPCDSU4DU8fZ2cEVxltyp4QOHee+pwcrzL0bp5lFjCGfFydJTLFq6uFIKwHSgmuOMUxlVZGo7qbnT0unNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iO8ROTcaT90018JtrQ0xpZyawquVtsOjOiokopmXpXU=;
 b=OeWFqG5FuAJnfxYuW3aD55YZkRlyiOxRbo0SJtBcOcV0n5CPMBgxKRGP0LQhiUUocJpiKtjvZJyLQExXldqoCnH7bvSmum21P+e5ATC4feskcWMNTBgaQP3TgGrWiKmKPH3XtJNZ0vCNWe9mRXjfkVlFnelONbO4vVFrtrXNE8LV9f1Z5KDGH7bZb65M+TyTNUFGRRuOsoXZgGptm786CbbOS+i72BExcsfyQ8pSFsSYJIPusMuvdLRcWOUX1pqK8PhFt4iwriWR6QspiY8zfchyFERofwMYnHFTN6l44TBIL6yZTLpHEHFPuQ/bT9gO/mhvt/+UC/zQRa6DOTUtcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:10:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:10:57 +0000
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
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 00/25] net: dpaa: Cleanups in preparation for phylink conversion
Date:   Mon, 25 Jul 2022 11:10:14 -0400
Message-Id: <20220725151039.2581576-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a05e8b60-d2b6-43d8-8a71-08da6e4fe022
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zH0OB7Ox0cRDGGRKxFMJ+1lkqBMArlhoi2Msg/GHBiD2V1BSjwfpu6+Oy4HurtdczbwXvbCFNTJ7TDgpk46e6Mmk6ryCfv2h0km6uJJx+yIBUZwFFElPNbBkQawBB4ejrRQG3flsxitsDtnzcO7bQWcq7OsWO83mla6IJEKwWuadbYPmhSlPc3+aBOb0C0OFUbWndNtgf/b+SM28pDPWrLmnXfNI1sYTbs+fKpl9C94nbCj9yjJOC3+GPL/bYpHCYBdebAFI/HOq6EZ4I1tj0KRbF8ZA4ulJVeXCN7b3vPc3QcQ/vGln1UB9FQiEgTa2W9NvXr/OV6cPRpzYJ++8z62ew5nJTqovaWe2K9vC8AodpvVl/mYZRhd/PTSnmmSN1Nuq7/ZRHUUQiYok8l6X2h1dAFnzVlKOQpt2xbtXY0tI97ele1FawmFtOasWFjUPCJRZdJlJ+5NbIEPzAlhiNjCaBReIMhzzhVjhHQmpC9XvybYMdpT6UCOHfSdpjWMoJPoMWXWEttCkwQRp7JEMukOY5rWUSnAkVKy98Ih919lfSjMoGydeqe01rkar8qwuRd+o+v8NXyjBqkXRBBzpsP4llZ/wNQddU3ioNCpvwd0QGMT0oxMaUIrF8LKfpLxXXmwNnXfDXiWz58dOFlr5ezmfA6XQD/7rqoyGD5Uv7y4dOl9MgCrRrR0c5ZK+neVlv2o2u033HZ92oJhDo3cJPqJyRCQHFhvZJtxJvXGg8+LLFTzzyV0/90Daz71OUfZBzA6Y7n7awl++bjMndhFubNTPhiear4iMIHJpBggi0qOR2580nGFXGGZRJxLMB4Wtoing/Rl9d6Yk9wF4Jpu8GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(966005)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nlHho3iVAttAEkzoGaIlYUQ4oE8GR4AsVid/+Df+1AVolIyZdbsdRRt6YNuF?=
 =?us-ascii?Q?Nw8K+k0S5pRYC73RQFdOnoL9/RPYDNoCIKbYGz3iNoBsZu6lAMPudMJmP0XO?=
 =?us-ascii?Q?0REHfPPGM/e95t8WgFbqHHj20y2/L6RSygERqsJWi832ap3945siQFuyJ/AH?=
 =?us-ascii?Q?bgaaIJbwbdMNfUDpul6KoLlY9L8yGgm7Fp3VnTPWlTA3sPx8hL4JpVrl1rER?=
 =?us-ascii?Q?fCa9R5ekgebBX5UaYCkC0HkXLZA5Ew9+WehdN40sghUsEiAzRsYroUmf++Vl?=
 =?us-ascii?Q?iTs2nu6sOaE+biwsyXlilscCocLzGmvC6+OtwfFKMRJSpBsYNyU0ttVu1qoY?=
 =?us-ascii?Q?bcwgh9zHeVbp5lvtuKOAHqdtltca3w8g9mhAl6kVgw+sfRqSwOApdyk7HUN6?=
 =?us-ascii?Q?7YK/Wx9S2z6Oc8EsRr/gYeDa5JzaJ9MjdRTcwRCOWJLIPtGWFpINJIaVnG8Z?=
 =?us-ascii?Q?W9nHSei1bvkdnBAXk88C/gtHNi8qNSyZcd2j7Z09J4SqPbx0pNbYXIX2Sjta?=
 =?us-ascii?Q?sVnVMoHhl8kjqgrEeI0sOciTQJA97kZMIC1eZa/6AyMiPBkpvNnEvOtxhyYU?=
 =?us-ascii?Q?kXFenaVzWy+7vzXioQboKpie3DbRYLgooXhDs4rAmEjGcVFiCcWJ0Z7BkDc4?=
 =?us-ascii?Q?ECk3e5aUBpQJtEIC7gJhfi44ufOxTuCM2bUWmLFawRDq/R8mvxr2zguJgTYT?=
 =?us-ascii?Q?+sT3MskOU8SyyezUDDAb/+w/bd5Ar9z6+zvZzivL7hYzkQCDUTwyje4L1bro?=
 =?us-ascii?Q?uHbGr1qPTuwBLeANmwmEa/8/c90ShtrNPJoWGON+Nqna0zHoQa5qT1G+ltsT?=
 =?us-ascii?Q?yyPNOaVez+ABC7Z/m/j+z7PRyJgFapNH9vO/T0Q0WGbh6RpwKkxbaabqabTi?=
 =?us-ascii?Q?/ewx/RtgjUxG5Irvf8a6Wtx0JWhLBkFd/fgcw92Mg3DFnikMsZQryDg/HnyZ?=
 =?us-ascii?Q?maaDB88QnzTtaqoBA02T5sb1L+9adMDvomydRTy7oG+2sEnWeMvnpPvwamqm?=
 =?us-ascii?Q?FZfNpkrN0g5uXTPT++mnlcWVYZON3M/ysWu3HY2NyK74UrHf1ce2eJBKdyWg?=
 =?us-ascii?Q?ELxEcxjQ3kiD1ZKn8Sz1d0bjzj8VoQlou/RodBrPYdPUt50BMPyESwM5jA+B?=
 =?us-ascii?Q?KW0/y5uf72IQCuI+OSdDo74YPdnSrqd3H0UgxbiAWnxcYZAF3rIi4WZFBu1S?=
 =?us-ascii?Q?F2LWPB4tH2jMmRB2bKOr7KPRzbNz12UvV3pzAA70Uzjr0bKe24NgYiw1Vwzx?=
 =?us-ascii?Q?60MIe/cXAQUzEK54P+JSdzGpMx3j/4cK4DRbTVVb0BZW4GWDfvwEZrrmDlPN?=
 =?us-ascii?Q?M8WQXDirf7Nmn54SqnkmmkB2YOdInViRMgA2RXmTuONdIQzzCM43cO7kX/nN?=
 =?us-ascii?Q?DTodPbsYOQPIObDyJYRwAPudVdgHLoUrXDMC26HgFFYzrI5DdWsEfDXs/0sG?=
 =?us-ascii?Q?g1SqH9plinvgbS+IZPRgbEg5GuxGR2bYQqAyH+eJ9LLBU0PlWVfKocR0MbK5?=
 =?us-ascii?Q?EjzG6AKTpPPn/S5u9gk6Kd8tcYGERW7PdCaA52mcol4iUxJba9v5zbISWumN?=
 =?us-ascii?Q?+MkrIpUtsl1R043bmFg7tNy1xQ0m4E1makvVnvwi/kBh0aSwNC5P/8cRgMMK?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05e8b60-d2b6-43d8-8a71-08da6e4fe022
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:10:57.0365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HL06Kivjum387nkqWsmfV6zcckEmZVX7WNdQJrI57YkjlJ4AYx3aP9xkd2GVoow65R4vqIMGs+AnWdK8IPlNyg==
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

This series contains several cleanup patches for dpaa/fman. While they
are intended to prepare for a phylink conversion, they stand on their
own. This series was originally submitted as part of [1].

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com

Changes in v4:
- Clarify commit message
- weer -> were
- tricy -> tricky
- Use mac_dev for calling change_addr
- qman_cgr_create -> qman_create_cgr

Changes in v3:
- Incorperate some minor changes into the first FMan binding commit

Changes in v2:
- Convert FMan MAC bindings to yaml
- Remove some unused variables
- Fix prototype for dtsec_initialization
- Fix warning if sizeof(void *) != sizeof(resource_size_t)
- Specify type of mac_dev for exception_cb
- Add helper for sanity checking cgr ops
- Add CGR update function
- Adjust queue depth on rate change

Sean Anderson (25):
  dt-bindings: net: Convert FMan MAC bindings to yaml
  net: fman: Convert to SPDX identifiers
  net: fman: Don't pass comm_mode to enable/disable
  net: fman: Store en/disable in mac_device instead of mac_priv_s
  net: fman: dtsec: Always gracefully stop/start
  net: fman: Get PCS node in per-mac init
  net: fman: Store initialization function in match data
  net: fman: Move struct dev to mac_device
  net: fman: Configure fixed link in memac_initialization
  net: fman: Export/rename some common functions
  net: fman: memac: Use params instead of priv for max_speed
  net: fman: Move initialization to mac-specific files
  net: fman: Mark mac methods static
  net: fman: Inline several functions into initialization
  net: fman: Remove internal_phy_node from params
  net: fman: Map the base address once
  net: fman: Pass params directly to mac init
  net: fman: Use mac_dev for some params
  net: fman: Specify type of mac_dev for exception_cb
  net: fman: Clean up error handling
  net: fman: Change return type of disable to void
  net: dpaa: Use mac_dev variable in dpaa_netdev_init
  soc: fsl: qbman: Add helper for sanity checking cgr ops
  soc: fsl: qbman: Add CGR update function
  net: dpaa: Adjust queue depth on rate change

 .../bindings/net/fsl,fman-dtsec.yaml          | 145 +++++
 .../devicetree/bindings/net/fsl-fman.txt      | 128 +----
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  59 ++-
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |   2 +-
 drivers/net/ethernet/freescale/fman/fman.c    |  31 +-
 drivers/net/ethernet/freescale/fman/fman.h    |  31 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 325 ++++++------
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  58 +-
 .../net/ethernet/freescale/fman/fman_keygen.c |  29 +-
 .../net/ethernet/freescale/fman/fman_keygen.h |  29 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |  24 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 240 +++++----
 .../net/ethernet/freescale/fman/fman_memac.h  |  57 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |  31 +-
 .../net/ethernet/freescale/fman/fman_muram.h  |  32 +-
 .../net/ethernet/freescale/fman/fman_port.c   |  29 +-
 .../net/ethernet/freescale/fman/fman_port.h   |  29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.c |  29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.h |  28 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 163 +++---
 .../net/ethernet/freescale/fman/fman_tgec.h   |  54 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 497 ++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  45 +-
 drivers/soc/fsl/qbman/qman.c                  |  76 ++-
 include/soc/fsl/qman.h                        |   9 +
 25 files changed, 739 insertions(+), 1441 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml

-- 
2.35.1.1320.gc452695387.dirty

