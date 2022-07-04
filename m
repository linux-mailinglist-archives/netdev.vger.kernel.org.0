Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D3564B85
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiGDCPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGDCPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:15:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9055E5F85;
        Sun,  3 Jul 2022 19:15:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aa0wrB7Cd4m/oYpAFFs6cP96j1LoBvkmsGrKBBjOGg07oQQPxHbp5mo4zHCaTxFTDfksYufdKlnH5AHHHe7ZS1Lse+2TYAqUb20kgVaw62t7cxB0n1wm4sIDHlcb8THh3Rw5qe0ivFEDYGb60MGzOvtu/+N5NJ+444fO78qQ/L8GuIPXwrrWrG8SAPv1fxCxHFSUAKmu9/1FCrKZjKAz5sE+7dmV51ajWFHjdOUrZ5J0x+VYXtIUQv9onP2U6iwxyyMTgQHpPPK9OGwkEL1MQ6ZdsZa/i0Iz0GS/ya0ISrK/NwA9myXxe5SRRNUqa5QSVLn71GWzAx8IaPjcsb7T7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03mpCBQJXOd8F7iypvv+sgb5cexTGsPpCHRnp0FZMZw=;
 b=BkOFSadrcuzVjCYQtc+sTlPV8N9VAnIqq448QYDmejUa/IrU2rQ4fyfJXIcaawkjhI76tIqisCAmo+mxM2o0zSw2QMM9jJGbwAgITelQ1CITHJGVCiD+AabiQm2UUeLL0kDBPtLpPmZ3DQ0olHhENF/uKcyEW0rqy7KgRdJKgjSM877PTuHBaLZP7ISGztr35xIEbcsm18ZWN6AgBXiFsSQwO5EMac5X9w1RGtHazN3fhHtt3ILZzTXYK1oX0ZMyAhL32b04kpthQDjs/1LA0DT+2lLZo1lHMXR+ffQUjpjYkL4QQppQaBw9epi1hbN/MAbY5FSjuvjR1yV6BzdbaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03mpCBQJXOd8F7iypvv+sgb5cexTGsPpCHRnp0FZMZw=;
 b=Dud4WkOXWnQWw64GkNXSydlcckE8DCikvICpU8ssi4F366H/mcsTZjRy6Q1yDwLxVCHbONmdPvKebNfANaH1vNznblcq6INcRhUUq6mCQgw960/8SnJu0VzrIiS3YLLp4AA61qTPQ6CUQSL/Yt+8Sd59TBiclMcpC7XOAJtaJjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 02:15:39 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 02:15:39 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH 0/3] Add the fec node on i.MX8ULP platform
Date:   Mon,  4 Jul 2022 20:10:53 +1000
Message-Id: <20220704101056.24821-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1f77631-03fb-4528-47e5-08da5d6316a3
X-MS-TrafficTypeDiagnostic: AM0PR04MB6819:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zl8OF0OnmAT5X5Iau733Hc6sgWz8+2O3VBZjlbEvb9rqKG4fozdJdB9Kmy5tDZA5EGCZ4N8V2+YNFOVv2XoEFkwGAfv8MSaxeJQYSf3jQgZaktnseEThcNzJm7G/Z7aMAFfdDpy71MvzrSsef+uy3GS+OTcUNlcKdY86X98hvSUm5V0LjJPvOH7gfB9xDM5Ra/0TAvdmsb1nVR8FZWY23NiL/bJUFvdQJbRzyybuZHZJ6LC8pXOvtsohUsF/ZovgZDrXXfZIgcukqxF6uxNGbnqMljI31wbApQWX11v+6jUmsQX3QAkQ0v3/iJrRp6xehbNDCI6eAI+O7f67dAhqH0wF/+v3v8io/6nX2tQRMzSHpKYzoCfEeDH1kd1G2jxnao/oTpsPVCr8dYlLRNcAN+tTEYyVBATY7lWoI5pWwIskLUHA1qkUjtY9CXvzHHVa1MRJ62vMotvc048OOyY1JN5ezGXTWOnglCaopESgeiavL4mTAtH4UNPfmTBRBVq05vn0kvlEdFF6qzqqkPOtzH3JMSItNPnLFm0XmZHpdR+EFIsmDpZ1NqFgRMPHI5yrOqrVvlcUKIgeBEwkNzifrp4hiAZXBzicDYTnKsaeSPQd7igOyyeoM9AOaPPs6eohBKbTKSWu88JWtgC/ixgxMOneeh9H+Y+nPhdWCffG4ka5HZcWuGkI3dZ69XwCsQc2412Uul30gHkeetbRuvEG+BfPGbY4N3NLJZPT2G5K5XJGQ9oaGp2hv8tZ0KmTCVa4O6YJCLSt4K8Thj9Mv9T/KqYl5yx1qIdO+iC8r5rb80yIe9t0VxI0jP95IckZ/naR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(6486002)(478600001)(6512007)(44832011)(2906002)(4744005)(66476007)(52116002)(26005)(66946007)(316002)(6506007)(5660300002)(66556008)(7416002)(36756003)(86362001)(8936002)(2616005)(8676002)(4326008)(1076003)(186003)(83380400001)(6666004)(38350700002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YkJzigFk5DzOLDehT/mYwzwdbioLZOkmwP1KcAIgDPCTOzOe2wtS44CeLj7P?=
 =?us-ascii?Q?ypnCgUNg+DnO8XQFB7nA948ikwg6FeWlacvPuPHPTTAgVoZZHsiUnGFlG14Q?=
 =?us-ascii?Q?aJNln0Z7yIs2lngItPRQwGLuqWYJhsLBupV7CVPgTAA0odw9QPy4CnjN+qRX?=
 =?us-ascii?Q?KqXbMb2wL3i2ZAVEGj/Zgvgv0zvjPVkXj9RAHDlgfR2YYKSpPnqFArAooXfx?=
 =?us-ascii?Q?+cs68VLugEyvYeAeCA2hADUL8eIITE/yXRI031a0ErRj3wFKmcP02DyrIVXr?=
 =?us-ascii?Q?AjhCx9dCohuH5sIg4XkGyaAXZje6sBteC4cPe+1yVZ1/rTH2hXrQKUhr7Onq?=
 =?us-ascii?Q?6ZGWJ8Mn5qKRxtromtG4Uw4Fkds4BstRzPKEqr53QZhmHBbWeJAY7M4ER8cU?=
 =?us-ascii?Q?RXqL62oHszQUX5D9Q3bgjGvbAJ2PwjtmYhhkNGZgfSxYlvYAgTLJ5FnmClwE?=
 =?us-ascii?Q?5xvZm7BsAh3REHdHrfov9XmStlgIAS1u/8x0j6AxmyqkNKFxEorM6Cpf09so?=
 =?us-ascii?Q?2aPzevb6U8p8pHf9NFZZb117xs+uLJzAiD9XC9qU610G4uncFVm+qvAMYIP6?=
 =?us-ascii?Q?fzkA9LaRYfo5YkBFzm0vEGheq7lQ7f31UjI4uizl4zHs1y9rq/mOQmkBKw/6?=
 =?us-ascii?Q?TT9LrhRx1miUW8hj8kxYOZpYtbmQTdtLNCyU6Eq5CDx4QmZwsreeU/3RjXqv?=
 =?us-ascii?Q?I8C7EtkOyRVVAqFxKOoRIVNJNGbyzxbpQME1E7YCb9kvbUP0u2lVbZC9uj+U?=
 =?us-ascii?Q?+3RqK8IlAVapyN01jfa5FgGhmByAlAJFBkmLYHev2qgGF7HU5oUaqitY83nJ?=
 =?us-ascii?Q?SylolZMpdioo1SRPgJDeE5oXtZdXP6A9Tdw+1HJ31Z4zL6cv1U2N6W+MnTVK?=
 =?us-ascii?Q?cWaBagbL2/AnvKNT9SDO9XLbNt0E9TZlLURGLS9pZCpXGGdXKMxbtzI6MdXy?=
 =?us-ascii?Q?uCkaarpnRWcfftQ+NQczaC4ZOuqza+1Sgpuqi5IqqPiyBNFQ3bciV+3y1bnI?=
 =?us-ascii?Q?UCimyr8FKxHZG/l0NN0Edin9FGjZMtF2CMmpiGvDoKCNfLuwTgBFJjKfZi/r?=
 =?us-ascii?Q?WUMaqjfqIf94c8MmAr7GfJq3/waMtSeepLlDzpMNf+E6SiCJfIDYr2v1f1ag?=
 =?us-ascii?Q?O7SohzQkdEZ2MHhsdcRbhG7/4m8laV7T2e/2FaYHFXgYjKdfzBAWszQYR1l/?=
 =?us-ascii?Q?D8H5zMlM/OJ4or95D9wz1rERb93MgLm/knjCvy+/lzD8n93MWGrZqk42353m?=
 =?us-ascii?Q?F+wogbgqejNmkVIpsE53svlXLUbMiGfp9EmK0twjjqAtM4fJsbECHHFzxppi?=
 =?us-ascii?Q?uuHe9IGPHdGKl1nbgGXkLmGAwP1+nl9JqYnQHUEEg/RM32a9x1UupBCqlm91?=
 =?us-ascii?Q?XkvuSNr0TAlTsDTDh0cTnB4IgBLlbfkOaq/s8i1YM/XNwDVX2qz+YQ6HEK5c?=
 =?us-ascii?Q?zOe0r+CLn22ywAbRc93itZUcu4woaCg5pl99tYuxtnEER/bGP9OKNlz5sCRM?=
 =?us-ascii?Q?uu7r73Rk8pEZOhL1EgHxdTRtdlCQnKaY9QZvHk4WOQOOKiNaKqfv6FZNihgr?=
 =?us-ascii?Q?NKm+VpHOhHZFlYGPuGhXZvmRvsn5TRsvClmSsxHC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f77631-03fb-4528-47e5-08da5d6316a3
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 02:15:39.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kj3s9CMiAb3/2FtWO2JxmTCWuowy6qaK3k/HC5C6E9Fp5Gtq3pH3kjjQNndsl6OOvqd24qawbciz/JLm7iD4ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the fec node for i.MX8ULP  platform.
And enable the fec support on i.MX8ULP EVK board.

Wei Fang (3):
  dt-bings: net: fsl,fec: update compatible item
  arm64: dts: imx8ulp: Add the fec support
  arm64: dts: imx8ulp-evk: Add the fec support

 .../devicetree/bindings/net/fsl,fec.yaml      |  4 ++
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 42 +++++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi    | 29 +++++++++++++
 3 files changed, 75 insertions(+)

-- 
2.25.1

