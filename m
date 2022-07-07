Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53D569E5F
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiGGJPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiGGJPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:15:10 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A02F2B193;
        Thu,  7 Jul 2022 02:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhHoOAO+tytVu3ONiuYxFH4jUo7FWkQfNCWirj9qsoEpBqK90/6Y0X+fVCe4356lVRk4j3ErvqIoZ5aGWdk25Dwnl2j8wltgsysccqYWXe54wOK6qh1bTt9cGEtt05ccpGjXxvFMxo6MGY6jOVXsVNLGb0hMNU3ktbCbGRXkcJAjND6a4ZTUQjrNALykfbhI2N4xg/88v+9ax3x1jZ1hYaQu4YHJPnrjx1YhMecMCMZrG/Q6iEdPoMljrsiHd2/0qWLeU6ipM8HcJIMpZ8XET3yrSZxLGJjKGFC9MjyFHaY5SpgS75hIok+lTF5dgwSUBvHzaTILDsWVP/+7ijXw4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T3LCyGRMaWj+uOOLPtWNv6SEb7P+dvjJe1tupl0RAU=;
 b=JquViuJAmJ8DYJxY9N5pNpeOPq8uYySXQSIIEk2dVQN4asirIYpdHm7Dg/jDuyDfrPb3ZpfYHkE5pZPMAWthy9BtNAfcBHQOytnlBPe6d/gE1s39HnXAOtCdITGrtyL3Tvxy4mj1/9Zd/nbv3nYrx/QvWHNG1RrGUsSDwYe/gDursGh6GHmX9ukO2WdP/pMHh7b1pISoM3Rm7zbbh5dbfYm61wzrKQgqolXRz4MGKupiZL7g1OQLRV6F8Ex6h3Rs9kpgrlFHYY1nR/fTv3/IB6WXfnUfXuu1hOQKBeD9/ekOKG7i42PNAfJ+UgOXIbUxxdBOqW/a0aARkAUgRHEpCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T3LCyGRMaWj+uOOLPtWNv6SEb7P+dvjJe1tupl0RAU=;
 b=SJqMRQvQ3iO5BVUS9mZ1yW4EYNcB8GIK++GkohEZGG0nH7AOAiEc8nEBlu6FX4ICz6S+N7Xh2eOGo50TuzixlMh5AuC3l8cIS5Pd8Jo8A9b6j2vTCuv0ZBxVytGBptljxlUsAuHTpL4kvyUpxj3nznsoBWUiDnFJWgiakX5AK2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 09:15:05 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 09:15:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 0/4] dt-bindings: net: convert sff,sfp to dtschema
Date:   Thu,  7 Jul 2022 12:14:33 +0300
Message-Id: <20220707091437.446458-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75b032e1-31aa-4918-f6d0-08da5ff92e04
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h7iZysavBnpCK3HSRlgDuoqpPOiD69bwcJkRmzDpmL8aRLfIZXoUnqmW05z14AKKkf+zQwRNV0ctRqVpmA+e5PRraqHrI+zbmb9b3bDkuxXOxi32JTMzQjAmYofg3dED3aH+q35HleabQQydSowRNj98GsDvln85W4e9GfhQANkbSfdSjypwcVdRjn561OQT8YSsgvJVi3tbvgGayiXclAxp9xhQtbFaiKAmi5EvxPuqJqibb32njbrXZUpmNP8QTYfuMUC8tc46LWfxK83MDRk105p0MbbtdYviAvAqlJQm8GIvsmGgt6cSzFtKlwAwSMEMan2xFn6FC47HA13G8H1CDDI16BuCfQmH5KavDLgA3OVXX7EJ0J7Uv+agxPWRvqwI9NoqSVRrS8+6Y1kWnq3TrKbsbsSSJEBV5xlqfV+gOcrxKAAYvThPRael+i6KeBC2NhSmKnWYHjaoPga1EJJe5qk8m5khuZb2pMup7K5AZd5ODpAqkbJQYip88qgdrDVEI1CQaLYjKzwh7+o525rg3AyatGrbJ3SEwOlHd4cTaOwsc5Ofcv03kpxQry+bj6bNlxsAtCrHsGEB6w5wQoxOGC4n6rD54bZxsOd//cK1AFfcqDQTmsjVfHqR0k42Ar1iwoWYUIAbndXsv1ykkuKDbxJ5yvpu8mIZ5SLygZy2XaOrtYFVEyllA1IeFJv0lPjcp+RLG2WR2F8YW5Cy8gvwhEuBlyFbyhlnz+RfxjwYXum/vOQH6eGlar0ulmmwOAVWy/tZxPDSAmrMoad9/pqkGwf+xgL7B55YhAfyx/0c9/5pJZ3mCj07h+p0Yxdk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(83380400001)(186003)(26005)(36756003)(6512007)(66556008)(66476007)(6506007)(5660300002)(86362001)(2906002)(8676002)(4326008)(66946007)(1076003)(38350700002)(38100700002)(478600001)(6666004)(6486002)(44832011)(41300700001)(2616005)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SzpcpudLIGWQY4nNx6LmY+TDVQ0MRYZNBeDfk/1zC1vxpF8x9EkGjgsLK2Fx?=
 =?us-ascii?Q?nqmtKZQW3e2jVciWpmJboo6N78AP+F6563P/yx5USB+AVXQuuLj5TdCveeGW?=
 =?us-ascii?Q?IimyZEESIoe+wgyG/zGiGmpcCqLN/Z9RMI18lF3orz8lAWfK4QaTdC6XNy9g?=
 =?us-ascii?Q?aBeVK17wotXRsnneZhFu7hA/u4LDvbJ5kA6oz6PYJUdXvSaWdvQOT6JWXsJb?=
 =?us-ascii?Q?gTaEBpKg4D9HglC0H32VYlyM8Lu5tDTzstkZiX94gtZYFYJdnGljKX073YMB?=
 =?us-ascii?Q?74IP3Mk6KeoGTcj3ZwF5QyDYRgwl1lo1ENDF9YlQ664qMoKSdxdgACAW/+k8?=
 =?us-ascii?Q?RByOFJuOtYSjzVCLZsWmas1DTIndaLu5lcR04XAfx/+6iKGZbdtDKpPgWLfg?=
 =?us-ascii?Q?riter6oIzimMMOyYZWZOjPcD/hqXCL9CURPszWd/OkWdv6u5mcryyofzPVi7?=
 =?us-ascii?Q?7XUShN9nOJbdLYLymR4Me96uNDM1agJERtqa2EOyorMUfRqLM+xuV/qe7mal?=
 =?us-ascii?Q?rxLxbMf4qZ8fzearur2aSxO/1B+bKN9F50aCD9xXg4SV208Wpkqq3KHQHSbC?=
 =?us-ascii?Q?9D9WRpTx6Z51Ezx7ugw0oO5Uelxyv6Xl0ebaDpUxubewabr6I2Gex8Rms9Bg?=
 =?us-ascii?Q?10t15LiP2+MlfIFY8QtgYWWjc/mehtGc6J4cEei0ZHeaacUZvT23MAanL+LA?=
 =?us-ascii?Q?VJHhP29YKTMgVzVDwQomNvXQMgqenFQNGD1MWt/1Yo4TMXVq39iKTCf5Yz4U?=
 =?us-ascii?Q?eX9NhhZOHJcFOM29Yf522RelU0loUwodkpL29vuv25NgekKk/JxsOEamQuvG?=
 =?us-ascii?Q?UDqbEnZ06dMr5fcFjg82zMRIVq9zwKPZC58qRtG1G2cRhdPbaOklk7SzGwfa?=
 =?us-ascii?Q?BzR+P+4A6Rhs2tdHaMshfPliFmHjTdH4m3P07gXvXdmSfdqYKgLnVSanNu2F?=
 =?us-ascii?Q?QQDAIVWUPu68/L2K4Yb3iF/81L6d/5TfxaPdGYO6YYH1N1T9FF2dLQQDmodL?=
 =?us-ascii?Q?twQYSh07zF+eeVxsdps0rGpZu8WO7YWDe+UL1Na8wWozIPx1Wv3QfRcuOe8U?=
 =?us-ascii?Q?vYgFT2XGgzMhVfxbtO5ArMFm0eEhwnqfS908IYnfWONKMNxK5pAsUPNotUK5?=
 =?us-ascii?Q?I5Ymb4XQXh04Nd0xKs31oVyhl+LLUf6kI9m79mgy/x2AWYr3is5Qf4tNK3tI?=
 =?us-ascii?Q?ULDLzxioM1k870IH08tvAmwGpz5WgnKsosu1pdwsKPWjJ5RImGVbxn2wVt0K?=
 =?us-ascii?Q?G41r3r81AChqsLfREPzmNYRRgERRuna80e2BAD5jyRO1xhcejnVmzdX4H9oZ?=
 =?us-ascii?Q?7504Pu5I91bs5z4lGIoN1028/FD8hltPfmE5NoqdLPeFc75NTXx0u7PjrWGz?=
 =?us-ascii?Q?U+6+yRI7iyajKsFlON81y6z73TaRKb/P/0aF4gxySc9Y+c8nkK3fPWmjG+eN?=
 =?us-ascii?Q?KlIuhZr1L0CoG31xNQWYpUTUw4rfpJymFVxfKJDtfyI3IkX8zVVwGYhrDtN+?=
 =?us-ascii?Q?wuD7KrDJieQrP4SG0U7NAFgNdXwznq+ElJNRSoKidGaaI8lL8PI0RJVvYnrE?=
 =?us-ascii?Q?lXZd70BJTR/ZS7UBnK497XTTDpJGx0MoXnOho7OT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b032e1-31aa-4918-f6d0-08da5ff92e04
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:15:05.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InxngG9Ezln/rCY34OMx7Lc7IAbsVkMZFlZnl5zjAFNe51Ejd+lGyZWicBZTpBGwhvxHgzb92NvTCw76RtFvPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set converts the sff,sfp to dtschema.

The first patch does a somewhat mechanical conversion without changing
anything else beside the format in which the dt binding is presented.

In the second patch we rename some dt nodes to be generic. The last two
patches change the GPIO related properties so that they uses the -gpios
preferred suffix. This way, all the DTBs are passing the validation
against the sff,sfp.yaml binding.

Changes in v2:
 - 1/4: used the -gpios suffix
 - 1/4: restricted the use of some gpios if the compatible is sff,sff
 - 2: new patch, renamed some example dt nodes to be generic
 - 3,4: new patches, changed to the preffered -gpios suffix all impacted
   DT files

Changes in v3:
 - 1/4: moved the -gpios properties to be under properties and not
   pattern properties.

Ioana Ciornei (4):
  dt-bindings: net: convert sff,sfp to dtschema
  dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
  arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
  arch: arm64: dts: marvell: rename the sfp GPIO properties

 .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
 .../devicetree/bindings/net/sff,sfp.yaml      | 142 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   8 +-
 .../dts/marvell/armada-3720-turris-mox.dts    |  10 +-
 .../boot/dts/marvell/armada-3720-uDPU.dts     |  16 +-
 .../boot/dts/marvell/armada-7040-mochabin.dts |  16 +-
 .../marvell/armada-8040-clearfog-gt-8k.dts    |   4 +-
 .../boot/dts/marvell/armada-8040-mcbin.dtsi   |  24 +--
 .../dts/marvell/armada-8040-puzzle-m801.dts   |  16 +-
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi   |   6 +-
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi    |   8 +-
 arch/arm64/boot/dts/marvell/cn9131-db.dtsi    |   8 +-
 arch/arm64/boot/dts/marvell/cn9132-db.dtsi    |   8 +-
 14 files changed, 205 insertions(+), 147 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
 create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml

-- 
2.34.1

