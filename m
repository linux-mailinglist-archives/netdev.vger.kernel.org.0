Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C087F59887B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344424AbiHRQRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245699AbiHRQRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:12 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD85274CF8;
        Thu, 18 Aug 2022 09:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGrkML5O0MdJ2J2A9a1ZZzAxSx2iwnr6MSEnBd+pe8LZ77IT54qSwTe00EGkS6ZbxoQtzA0gawcimKU/d6N8adGRnSs07n6JEc8mLcSoq+u0ug/c33367le9WWRDu+QsUW5cpCE37YUVT7vNBdtnZjTb095JxwCAmYVPMq0WawDGOWKIdJee6ldxNIK1n521++e8btOIsfwvF6lDlpJmQ2pVr+PEAhJya0DDgL/u/EkZC/iip0jjraX55xNd9tVGcAe/Af7VOfbIKuWa/bmev1sS0/Q1bG8HWLypQtcfQ1OVNp5+lynR8ePqlwh0nvkpG40WyhcsFH2A3aplmLJUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO8ROTcaT90018JtrQ0xpZyawquVtsOjOiokopmXpXU=;
 b=b5z/Ih8Y+VdAb2sYDV/QaM0ynF7zfJXBfCiGOfBM0r7J7keJDyROllR7OP9WpDdKAFtXN8H47+dQGI4XcSDZqdeupFXJTP6IRedjoye9zd8EozB0TNbvi74rCUVSMWt3EO9pjnko87Ry+egTU02NL0n93UrYHDCsGz40A1YUyERPJcZxVtnX3O/6Oei8BiKuECCAe6wgjcrb9qCmyOn0e0Nqb1nfhkXgsl8MQmIchoHhYf8qV+9FuFuBXi/k7wnkHVPbFr4HPwpZtI4v9yHVMIgrZjQ/UhFz8kBcB4hWUpuSDQT9LL4HSLFRwmZNP/soiDiA530Y215vRV9PYt+4iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iO8ROTcaT90018JtrQ0xpZyawquVtsOjOiokopmXpXU=;
 b=W0KMMswBEi5vphC4esG1i2zziejktNl5ItGzWMpkQtHm7wCagAOsj2tnOcDdZTdfHcup6Oab+hgg6Z5SbvMBdlU6HUqgwoX1IgsBmDyVv+7OBVOs33HeLTX8DZ7nmVl5sFmWqIuGXr83JNyxjNRuOn7xvtFVeS/As0+VLeNuUxEHm4RvTpx5qRrrmAhfhwC45avjGM3NltA6f6Tz4Q42kqHgDH/kiir2+hEJlzLR01VoNF6aojKzPe0JXQ0nSiUZavKV7Ii4Ar1wyFBq6MxF4cqOr2XJ9UN+7YI5hSPwDa8AA766Xt5AaU5s03AY8KAwSE3neUcZ0lWsNaDeTjL8iA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:06 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in preparation for phylink conversion
Date:   Thu, 18 Aug 2022 12:16:24 -0400
Message-Id: <20220818161649.2058728-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a516a29e-8c4f-410f-2e4e-08da81351819
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDtHwWUyvlvFwnG3K5mSlosJa8/49WDwO+80PiMYTqnjLdFxto9hsBBIBPnDRfjAda+UuyX/TxnFKfM2Zoqwz5w5KsC8Iwoy/YLExjl83f4MkvqXSVGTwl90QL3qCQB+kDMsaIAfDHMGXYr7ffH9g6DRdDAJxRQoZInSggIJbzzji8MQBYvAelHdGcPkSXRvIW+JOgIC0PVYnisZ1D9gWZMdCk7trg0C9yrHeRQIc3yrOJbvPVx3wPGPnDlU66Uitd78KdfOb5nAfhW8HIRIGtV6tfYZzkuO1qO7HQa84JCZR1F6AbkZ1WjIIC/gmAcX0s/rce3gE+35IGVUBIgMBpLUCOC6L455CrBGbG3xpb0eS8EfhK7IRrptG+rwFe3sf3q6NGs4SBoKrUXo4Z9RJl+QNq3cMoknTcmX3Yc6PUB55EejHEMKrrpRy1TEWYKPeZ5oIad1Vwv44WysZtCNidszHJr1pJ7AeGaO79Oy5gPhEKuctI5S6rMNtsinTV/WRclxmF4Kv0ultmgBu+dH7Epn3JTQFNcRBublZpKPHMd0gIzJoO5H+YPcRJHdgYun/6W1ZcSjJc5Ij9NWKQcMNlJZtQj87dl2pI4WTDAHHKWJo6TLGHD6H+f78aW4s2EFKlCBT/G7P3ejQvusPO/9m0fVdi8f6hPw0I8kMjFF6IZ4oiTpw2ZF/s6OgnJX4aX+UqOKkcvQm8fDW/UlX4Tt3a645JvxhnRb6ryGRz55AvpDyvBolyx/38T61QbGs6vft3ZyWfvCQ5BcuiZAf7d52+tXCQf+Ca0aXfHasfxa224=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(966005)(86362001)(41300700001)(6486002)(316002)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rombbdYzXqscTaTVhPxh2Ah9AAh/APIurTESDVC0pY9UBTuuoArGtlOYWQCR?=
 =?us-ascii?Q?3OShKJ0rSU8OyFvsbSEkwuvmQw9JNFwE96lA83okoHZmIWnW/8rXJF699XvP?=
 =?us-ascii?Q?qOG5j9dEqBmvzQa26V9C4YsQ8OV4Aqhuz8nx8o9ZMRZl1+nCiTbZVwB6cXac?=
 =?us-ascii?Q?WpSlDbBL3TxWtE6pvzQdgucDZHjWtWD9xzVWg9dPtDvs2FKRzV2xb3mCEe08?=
 =?us-ascii?Q?v+UpiY39h4Gzve70YvVx79CbSyBKdLvOZN8MRDQNAFnEmDkYwoRAuCvk56It?=
 =?us-ascii?Q?2Q4E5u/HIRed5UmpxRcc4u/7qLsUnwsb1h3U9v87wBW7hemyclc3RGpgsMLr?=
 =?us-ascii?Q?7+SXrN18MMN0odRbYajgG/NE6euyMd+cjazVEMKIo7DUbVI1lfJUqp73tpUL?=
 =?us-ascii?Q?EmB3rSLnBSby7ZjOM7hdoyPbl7StsoE5KU+51HDnDaW0BCWx/4lKfkY1VQ71?=
 =?us-ascii?Q?XXac2SF5tpP8sKGi6LhWXDsMQcw4Pdbc80pNKF7lNfQc2jDqB/OKUQRTF3O9?=
 =?us-ascii?Q?58fakiBGRZKtzxSjtnFlLFnxQbS55Q9P3iv9LB1iq6HNLOK6ynsZVVgnZDul?=
 =?us-ascii?Q?zY/2dm3Iu9+oRNblerhFSzCpPxkbd/8PMKQdC6mRg4ex39HWqidVLtsF/rcr?=
 =?us-ascii?Q?lTYPn8PL/JqcT/E8SBQtZ1mqsm1T0VjWNG8595dF5/s6GPMumbCLxishOC8g?=
 =?us-ascii?Q?uAce2ZCnO/4rZRnrEKWHoDth9I/AN5DE35edBHC4mwy78YwyBQwN1EwNW3zS?=
 =?us-ascii?Q?LNoy7f1qZx0Ep0w5IybphmZdTectoUPJ3GlwDcKhNjXuvjtQBGfFpll1zSlN?=
 =?us-ascii?Q?jwO8/ZdDzhueVVYMMCv3Sw5YiYkolHe4hKAvrXJtF0YVzRbdTMeu15oNY7K8?=
 =?us-ascii?Q?mEZQo4qyWDrs5JWsopyKypj9opvZ/85Dh2E2pjW65DhMs6ZMnZnPse6OmLqI?=
 =?us-ascii?Q?5wLwJr8RuzP3PyEPFX9C2+LkMEfQ5G26Y7goKYcRqoKE8CmSmukKcTIUDZcl?=
 =?us-ascii?Q?7NmZvB7nHGaPR278RNWO+LqaXkuzArFrNmlAj6jwEO1GV8dFE9Pv84wA9bF5?=
 =?us-ascii?Q?tOBMJRx5v5eBMvUQr1SU5HLPVcZMUxJU09qLuTMWiKpB7QdM834uWk4fzpMR?=
 =?us-ascii?Q?43EYqt3QLkbA/BUF+SjOyIb8WOHOAxbRSpKb2G+Et6D+4TY+CcFjryqNfwH4?=
 =?us-ascii?Q?JLtBM8MzHaFEd1Pc7RQKJsALc33uJc+WgdG6wQg5G6B0pwmXp1p7qeQdHnY3?=
 =?us-ascii?Q?qO2UvfL61DrGF60wORrGg5ckQ9fQBdTRpYdEL8sf1WWSNBWxqL+FCkadhUhZ?=
 =?us-ascii?Q?k9xpLEEOnqxOHKgxjlUDCCfsedKfrlsZmNYrVHl+w8vyvkUybkCAYLDaPotK?=
 =?us-ascii?Q?C/APbYt4T8Tgyp3ncnbPxLilICVyPf9xFBRDiWEoP7wi4rQm2kUU7uNv+mOj?=
 =?us-ascii?Q?pPafPPRlsjdgPA7FBHGGnrhSfmNacviD5kosxe68PqQ3gzj/6BFR2RPRk7bh?=
 =?us-ascii?Q?ZNaBu5gtX1pvYeQR4UNa6ezx3ED9z8vGYWoqg2E3u6h8iPZQGtarmMontey7?=
 =?us-ascii?Q?1aRYtbcK1t5VF/H5KcLAjFYW8w7/kmdUEbReEBFqPeJGVJmj7AdijJBrFn60?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a516a29e-8c4f-410f-2e4e-08da81351819
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:06.9211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCSdHq64wrRutXKzG5wJuKxHyZYmL5Izd+A4geoMYMchaD/gUAaHL8yMPAeSTL96EALmtU61tvl1sVM6V/Pmag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

