Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F40598542
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbiHROF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245673AbiHROFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:05:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917465823;
        Thu, 18 Aug 2022 07:05:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD47dzQ1bNdp5p6bHJbmtdoMaPwQ1EtGPeSmLb9s86aPlE/Q+96XhtSdDcsclR/4KK7frVLdqSIU2fWW59V+WY4D7lMWW0tfDUfVQU6PsG6+Twn1M71oGxMEBfSIqsH3NI3cPAN8UwB9kOKMKL9bDp/uahBsm/0GvmBER/K+bqGW+eadOqYWXQB6KSrkkZdsyBSkStyax/PJ0lPyEl/tFvyXRwFOOXxiKuepjnJrboKsiRS0m68tyEUC+56ku3Hu19E+asREg6qfa4pNUNQ2GXxkGs4+MZnddhyE97AtfExjSlZqlo0+CrcDuOaeTWnScGpsavTAvW3ORQsOPumHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S1sQqh7aVGxhRu+Xon140SackMTmmwu0lxm8zTTRpgI=;
 b=S5B9QtQUAzShKnTwAKNoj7RgXsdzIioC+zCD8naNO5rtv+YA76j3CZyksyU7cqd1/jOOFZIzJoyyScYM+nIkN8iCT5bPOfJcTJNeeNVKudb5eXdPLHR4HgWVKl7RVFZsbmoRJSnqizd3gfvoQJKvJyjF5uY7CvwopsIJoqg68GTJGdOLAd5Wl+twAiD67yChkbyqx/H/ud+5GsfwFoCy8dq/2Fy741zYO2OuK3b11zucbxit5BB/7ys4S3kZRZtdOxVYXC3KTfzNe5/s5qMUtbO8e0AXGNf7nnCm+jh+50F+ZrumHBlHwthumBtLqSsL79dFZ42HRc9F0W1EIpnVUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1sQqh7aVGxhRu+Xon140SackMTmmwu0lxm8zTTRpgI=;
 b=OOowQzThHR0KZSrz0ZX+o0rTUc5+IjNt1ZKjbRdzdYGDtm9oePJCsxKyAuDa6JJ1Sw7yOe1G4zuFv2p1YyTjNoz9SK50nLVbjo+7rdJ9dRE7uGEEie4uXF9RlRl9tAAM7jiqcuuUGhZQZnGiKwu4weOnLgcVFX5Xe5WwJZRgShE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3883.eurprd04.prod.outlook.com (2603:10a6:8:e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 14:05:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:05:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH devicetree 0/3] NXP LS1028A DT changes for multiple switch CPU ports
Date:   Thu, 18 Aug 2022 17:05:16 +0300
Message-Id: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb09f98-ea24-4133-cdb0-08da8122b9a5
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqhDFLCoJC17RuNNj81gnkTRgpsAYxf4dB1CEeHK+2tq/27OkDvpcmM/dwaHDgT/1vsc1EakmK3MWQFGOgSJvywQd8T8jCO6ansS79dWFrYWSaT7/YsQ7FUt9HASO2E/me/rN0mnUFMeaMcDmxZDe+H7Zl5MYAQndVyS+v0TtxPDM80KCVCbIztWiWkxKcqkWx4e+lv2EV9Pl+PV4svfHQ9WXLL5unEHjBU1TBRIOuFP1Qpvjf13e+BWpFEYuZQ2277O+cV3qatXYRRjbL6NTm03aJHN03p29kQmp6jQjlkFKNHXdunnki8HdQQfSEPNaJfsjhrm9/U0TbVtRYY/O9bUJSspLOAD6dsbggADwxKLvbPy1cXbIogKbQm4uBi8grMWTVzDmlD4QmCnb3tsUC3qcjE0LAESovTs+zImY3xAiLSc/GLjYDVvZgYuhLIo8/cIf2lKP9xSxT9pVji7N0YV5QupnPW68Sy2uVDCWomxjNPhoMUMSI2x3ANMY25SoX8kj3GWL6CbLr9K41TKUbbioeJsI/wngUDmoWwyh10ZWl/a56LsKmhtEMDFsVHO6Q4/QRRpfGLAEKMi15+UqxYcD0aQQt12PC+D10ekZyZ0vYhmRirymgADIBr+XhOhAQS4Pax7GaNxm5oBC8d5hRtHzJnkPa2Mmvb3Azz6R1qSlR3xeIxKyEocNy5MD4NPQRQH1ZAmDxBhjBrhxn8/6lAHxdbcFdsLRgEy5yEyqpjhQlJK/FeApgsX0GbpnfX/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(66476007)(66946007)(5660300002)(44832011)(8936002)(4326008)(8676002)(6916009)(54906003)(86362001)(316002)(38100700002)(38350700002)(66556008)(2906002)(36756003)(478600001)(6666004)(6486002)(41300700001)(83380400001)(26005)(52116002)(6512007)(6506007)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f+Xx9w2kwR3OJruhNctr3/fs+CoFcw8rX0GhMkOe+6e+8+3DEQeoIz5pQIj4?=
 =?us-ascii?Q?dZJsQDW0rbp9+TQIuEUkqu/paemWBHpZsrL9wG+gEB5z8SBFgUj+aKkxeWL5?=
 =?us-ascii?Q?eAW5vNKunQsOElbYhviEkvN3D7lszYbIIpFRKGsOnNYqvy5Ased50+KrRwSH?=
 =?us-ascii?Q?fknsOgx3C274pu6M5BDE1vEworQhOVIR5mdSzSbj+46q0sm+yYhJTWlyTA5u?=
 =?us-ascii?Q?dZZbdaYg/wQIlTNhblYmBI6o5BX9W0x0ams0twxg1O2xi7fzpB6dlIpPSjuo?=
 =?us-ascii?Q?8xI9HGvFPfn1C/CFa+sYMXVH0L1PfdufeiHhr4Gfc9wzMSPtckRg2olN8dEF?=
 =?us-ascii?Q?ZB9ybqVc55c1LmPcsKac2LJNQUd2R5l52ltFrj2FVJK6hR/d0hLP4RlB3fnE?=
 =?us-ascii?Q?b5XtbkYg/ZolLL+c5aeguuCevRqx+t0Xn1f7NyJvogL7bA/+htI0i00as5Ki?=
 =?us-ascii?Q?rxopEWJIdfLv5jmoaERf+esgSzbhH1Z8Gq/j81W0ka+nuEAzjZ7IWfLSkuyT?=
 =?us-ascii?Q?pfZ62Lp2UAgc5UfDuN1Li5bU6FBONi9VDVsZdn5mKgLKv1zTDoXKIpk7ZDbg?=
 =?us-ascii?Q?/E1RVJZ2sVXei3DTp0ghRdN55yq52gME8Uhr3GpYOX7Gw6zKmBx37uL8xT6k?=
 =?us-ascii?Q?EbP5jL7Gr0GgjCe3AGnPnCGmncdBDjX00kfSeybF7/X+CKmfBnJAloBs47OJ?=
 =?us-ascii?Q?tsJxovUrNJorzymZdgPXSCfJ8LmEnoPIRGgPDmco1SLi1Y+797He/8XuegPI?=
 =?us-ascii?Q?2vHuTXmCkoZawj4FJKqi7S7VrckHav+4ji/WmKzSOBg4HCVr9ywmFypnd/e3?=
 =?us-ascii?Q?UQ7L/+buXu7w3YADkemwA3TLnhz+PjEB/4dyFliizcQbaDWwoo0+aSLv9h0I?=
 =?us-ascii?Q?Ez7B5LfFDhZ1hMZtogugY3Z98msEp6iNIgoRAgz2Pqm9qQRjuLr3h/RiYyfZ?=
 =?us-ascii?Q?4zikwikxgvuzWnQuuYsoEfgoz12tNahwnQGt5Ab7FAA+jpG3yuKBZeZ3CP1a?=
 =?us-ascii?Q?pEISZtjX9reVvDdHIu22b5D3A7OdmaxJUOtotPkGwCemC6eSqkDtWVBSAzRI?=
 =?us-ascii?Q?ahMyuA9bkAlAI63FaeUFpjRoUjCvruetxXZ59narfWLnj6km0gOdms/ZN5Va?=
 =?us-ascii?Q?Mx5U5WQiZldCGZ9i7A7SNd9NewRenUG4NtRbC1HHeNzvA5F1C+pZw7DKRXap?=
 =?us-ascii?Q?5q0xrkzSCHFc3JjYmgH830ZNCilCrw8dsQ0t1/fhDeH5x18IbBmtCOgqB2Yx?=
 =?us-ascii?Q?DoCi9GDnY43qPN+lurCOv5wm3zvEkQ0g0nEjKkkg1PKXVESzk8AwwL5VO6zU?=
 =?us-ascii?Q?8DcfokYd5mDSdtBkdY+l2H8rHORtewAwd1uufruc99mRLLXLWxjf2PhBVesE?=
 =?us-ascii?Q?nkr0KvAYywvOs4BKJpbChkOKzIdNAhBwh27LfMrXQxpAm/VCOwF8o53i0tAv?=
 =?us-ascii?Q?wbV0KKWIPQ8VlNzgWmfyLc2xcRdFIbXEes1+aJ/HkG/Mlm96ybCELfWlzh5F?=
 =?us-ascii?Q?5FdzNAv/8H4wtMYSerX9v2k7/VqNNFZ8bDPakSZaqiCUS0JH1cVEOStJRBB9?=
 =?us-ascii?Q?CnxCn7qAdurEwOBVK4UHUH0JnWq9/UsoH2J3Ybz4UsrqRv8+X0LD9oGughzC?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb09f98-ea24-4133-cdb0-08da8122b9a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:05:37.1743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91mk0gqz3UK1zZAbPg01ukK6XVpuZ7TVZxdydPGkPQEysbWcwgGpjWJ/7YZaqxi0mWxTaIzUUteSGNUAp2jYWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet switch embedded within the NXP LS1028A has 2 Ethernet ports
towards the host, for local packet termination. In current device trees,
only the first port is enabled. Enabling the second port allows having a
higher termination throughput.

Care has been taken that this change does not produce regressions when
using updated device trees with old kernels that do not support multiple
DSA CPU ports. The only difference for old kernels will be the
appearance of a new net device (for &enetc_port3) which will not be very
useful for much of anything.

Vladimir Oltean (3):
  arm64: dts: ls1028a: move DSA CPU port property to the common SoC dtsi
  arm64: dts: ls1028a: mark enetc port 3 as a DSA master too
  arm64: dts: ls1028a: enable swp5 and eno3 for all boards

 .../dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts  | 9 ++++++++-
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts | 9 ++++++++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts        | 9 ++++++++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi           | 2 ++
 4 files changed, 26 insertions(+), 3 deletions(-)

-- 
2.34.1

