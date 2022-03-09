Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D194D3613
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiCIR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiCIR3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:11 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C955685677;
        Wed,  9 Mar 2022 09:28:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmJGL3pMOLJKSQ3CTTKcvEvO5rYVO574q/TA/uP1Xt5YMbe8FM44h+YQwqcWbHGEPKJCK0ck8UIHVP8dR34OdqVoyi8j1rX9REJog6/DQMIdtiiujRMci5foQwmqajENIT5jAU1wB7y+rQutSaeQOLluFRQBhsb3l1XzhtyGqJGaQvZ2AweqNiYvpMspqZ/py6GndA/b93I0CfbeaKWmUwJ5xdu7Jh9jM9oby6so/qL8iDcRqZ8RO7XEJ0wuOHmjujZYBHTSpfP4uSZlzS8oDVYMzEkEyOP3Q63iHYlU+16f1fh+/Cw91XiT/mJp+uoCPYomPoauoNgdOa5kPpG89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbaUQ4UeGwIzxSlJ93t2dg/i7gd6+yq57SpD+a55Uwo=;
 b=EWxolFcanBS2e84JCNdCeP4KVHXa55G0cfa/obeVCTZH0BXsk9EMq6UaUbnLtVf6CYGUHysvy6O0Ey+21XYeuS9KcTsrwxrEsI8f6lVhID7x8IkWyapgQkb9njHsHHYx+/iRXZ0lt4BMIispkQhbUdlw/VhNk4QsUcTIbGj5LbnBfLvESwVusEjpQm27AuYwz+FTT1E1VhqCeoosr/6mnAZRjHF6+M/7k3hin8VgKos346o7pRWXtHfCYrjA65qLKWXpAD/lOqquo2b6KHJSu94+mWno3nfhhWusjtXDWBHk1j77R338cdd+nIDqFNjDVSrrP9QZlsZPPwS4OG0e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbaUQ4UeGwIzxSlJ93t2dg/i7gd6+yq57SpD+a55Uwo=;
 b=RPk+t/OBrnhNr1QzS5MDg1/Gyi4jnD3pf1rllzQMSGXrhJG7ymcnvH+hMNLi+hp5HnJhFOC0tZcg5JTS+FIkHhNntRtQroFMM1qcU4k/I6RNLR53bTK3A60Yta0e4EproLoA3A/L5RDwHiRWbP5IxPwd1hI55utp0Rrc5W1mN1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:06 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/8] dpaa2-mac: add support for changing the protocol at runtime
Date:   Wed,  9 Mar 2022 19:27:40 +0200
Message-Id: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3567f28c-bef2-49e7-9b83-08da01f22be9
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB94223249BB36281E029393D9E00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Q8Gd76bmnPPuJN2/w9fBp85E6gHkuCCwtz7shwaMTXetfzuNlTa+CM8rnkHEhGnMnqAaJPzFiFuaPOEIHAal/1E1lQm7cFywdyi5c7JO8OZjtlscE953J5vWmtieULvZYfOkO2yFTFl3OePR7fzTntoPOQ3ECzizxPfV0WuVsE3raHBFvZmf7a+6o5AKfemZsR46UmE+wKcpFp2xGXGTOuvKU36JMWPetxLN5jDjkSZ/LFQ7cioI1Yo7WEWhWMcM1ekQlyFAvkq2C3wMM87b+9exod0/S9DVa/mpYAxl9vSQ51YHZBusQN2XCDexndsFiBhDNBtGhPk5tOvOf6AOdaM7u1zr67ihjPMatIDhKGuxKx/i1n6teiR78Z2oGj31lGDPyantbFA7lKNjABHMATOFtqpZCEParonbFP6D5BPEkcqRTk/Jnkc1nbqJH6jdOzhw2OjOmi7HdtbEdHsWBg7555DiEKnzwkGjgrYcqxZ9acLBpgJO2/mRD8m8YAHximzwtSrFn7OmiCvyfRP4Uea5fepFaQXLtZvv5G98s3o/ACMr+DiZBu09Zz4r1/IUob9JgkfuMi5lIk4N437fxhtx0QO3DE0tQXJRfpRIo0vNKTn6R29RZHhiMHdtPWFftR4p/j54VI1tIYfug/dW3i6XknooMxzuonW90Nl4GrLco8ZNngkq2BjKwTVvb9bUbYwTtNQLjwaPDp0gCYl0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RSFCrQLEXqt7+ShUQegzvaOY+EYoGQgm7XNagUGjA02Mbe1I3P72QsXypnLr?=
 =?us-ascii?Q?eNsa15wi9lW6IbAeDyenWtL9hH+7XyhOAqc7XSL1s2d7TG1175k3XYfcvZi8?=
 =?us-ascii?Q?FAB0uuYku2uv6pCjBOMYfCOLuVOKx+X/8KwN+35yZh2lbX/BER65+cBpotnj?=
 =?us-ascii?Q?R7MgiUXehcd57xTkaABvmZucSeTV9e0jNn5Eaw6bhQKSyfsRNbK8NS2fr68M?=
 =?us-ascii?Q?MXJXw8xzzJqAeGdNzNIWlhs0DzXj4T2BzUhKFbTgunDmJkx8NUFyUIl9Wepb?=
 =?us-ascii?Q?WEjcDSLKgyXbhlz6ctq8NmuFkJBW62DCeyJPdrcPPZLPcpJ11KIJEzVdD7Vk?=
 =?us-ascii?Q?iMfkthssZcrzF394AknW1Wuc6S5YxPLaDEK0lHSlRCWGfdFmn8anppB75Ynk?=
 =?us-ascii?Q?XGV/UrK51ktpWZdGGwvvRMwwpoXtDrkWTKpJv1pv7o073ZgW5Uhy7ofmhh4R?=
 =?us-ascii?Q?+vkwefoqUc3Xb40vENv/4kAPcWhl8FZy0x0b+3ZwLPVT42yqf2skfKj4VEsF?=
 =?us-ascii?Q?NbH1I9xZrhgfpTMWUOUDWR106SrD0SzGu3LRbGvjdBtZdL6+Li3qVDsutyop?=
 =?us-ascii?Q?DtOKKkTETC1Z4B53v3fIji85G9WlZwwHkAF7krTDp0E00C/RC8K61Lvh2JlU?=
 =?us-ascii?Q?aD3+Nvzs9NxfqsHCqtk8Q94VIftvIxyqZvGhrxGytIa9MYOxcHVrlw36jq7k?=
 =?us-ascii?Q?pso4TMco37o6Rgu0f3XVLx7F56h+UNYEc4cqrtar0KLACufC1r/ZPMpvd8AD?=
 =?us-ascii?Q?BQU9JOLKFG4/5I7MLEOt2GfRjHQwImB0SxUhz1gNJ4BvLdz+cNejZ5UB2OiH?=
 =?us-ascii?Q?1zH1Qta3rBqlEWYPmFJ3zcczu8ufuNNnYPOQCQvDdPFAnbcyLMCmODS2RQ2Q?=
 =?us-ascii?Q?/xMA1Z5wB5tSnd97b+L4mMGTxEo7haasVoxQYaoikj2qgGMeUNBlh26cjxG/?=
 =?us-ascii?Q?H92Vi/+mitDxewQ95v/LKLuk/Shvug1VCj7WgXWc/W7pZkuA5u8XZeTPrnzQ?=
 =?us-ascii?Q?V54l1PzJS+ZGciIEJ7GDci0MFxkbm7rQfMNobIwzMyKY2XgwSlthEtErdcNC?=
 =?us-ascii?Q?DgQgVaVQl+Rf67KXjU6MQFdH3mTmcHYMapH0PAsCKHfducJiBZ/ga3vck048?=
 =?us-ascii?Q?WODZmfBuDTvsJkz2uOqsbtMJEK/5Y21k0QEq5YiRVa6I273XsWmUIiwfdTZJ?=
 =?us-ascii?Q?hsH4lpliK/69wxsSPTnGGg1lAqQ3/xbhhMIrhhh+LJVsBv3cnUqi9OuJnajf?=
 =?us-ascii?Q?dqW/AT5OE8fNFjVIBIvdRsOsq5nWkar6JY1mDNoHIezpZUX1JdYmc1cZ9ktC?=
 =?us-ascii?Q?Ie34t12WfpiqdRpz7mSV3b7e3iOiL9wlU9Xst0+V2zYOc1kwJQiYNQgTrOLV?=
 =?us-ascii?Q?R7Eb4odV6PYLaSka5BmcZk0FBOc4wyGe+J4YWRZlU3UC7iQevbLOzHS4t4rT?=
 =?us-ascii?Q?jgWsTjXufvV8ChqintW1bhIcoaSgEpSGpiYCRgHjMP7ecJ56aJAeKhlnVmj1?=
 =?us-ascii?Q?YCWeTKMDwtUQXPJJQn3vMoUVmhVjWO0fF9T16t6KTc2TrrhBlroES+B8vgQZ?=
 =?us-ascii?Q?LiyE8zBsjwBTsHV0wEpYBkCZiWMSb+c63WP0505QQ+usBf9PVxlujvXj0Kqp?=
 =?us-ascii?Q?TJXcyTf1TqiMgc+6Cwl9Q2I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3567f28c-bef2-49e7-9b83-08da01f22be9
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:05.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGDIF48Wwmr1wKGESRdGzs4WaDtEUzcn3++sMjiJHKQzKzAJGCI58UVFY72Jx7UGHxrGA5/aBwzfwJrouJ1XjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for changing the Ethernet protocol at
runtime on Layerscape SoCs which have the Lynx 28G SerDes block.

The first two patches add a new generic PHY driver for the Lynx 28G and
the bindings file associated. The driver reads the PLL configuration at
probe time (the frequency provided to the lanes) and determines what
protocols can be supported.
Based on this the driver can deny or approve a request from the
dpaa2-mac to setup a new protocol.

The next 2 patches add some MC APIs for inquiring what is the running
version of firmware and setting up a new protocol on the MAC.

Moving along, we extract the code for setting up the supported
interfaces on a MAC on a different function since in the next patches
will update the logic.

In the next patch, the dpaa2-mac is updated so that it retrieves the
SerDes PHY based on the OF node and in case of a major reconfig, call
the PHY driver to set up the new protocol on the associated lane and the
MC firmware to reconfigure the MAC side of things.

Finally, the LX2160A dtsi is annotated with the SerDes PHY nodes for the
1st SerDes block. Beside this, the LX2160A Clearfog dtsi is annotated
with the 'phys' property for the exposed SFP cages.

Changes in v2:
	- 1/8: add MODULE_LICENSE

Ioana Ciornei (8):
  phy: add support for the Layerscape SerDes 28G
  dt-bindings: phy: add the "fsl,lynx-28g" compatible
  dpaa2-mac: add the MC API for retrieving the version
  dpaa2-mac: add the MC API for reconfiguring the protocol
  dpaa2-mac: retrieve API version and detect features
  dpaa2-mac: move setting up supported_interfaces into a function
  dpaa2-mac: configure the SerDes phy on a protocol change
  arch: arm64: dts: lx2160a: describe the SerDes block #1

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml |  71 ++
 MAINTAINERS                                   |   7 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   4 +
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |  41 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 164 ++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   8 +
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   5 +-
 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  12 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  |  54 ++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |   5 +
 drivers/phy/freescale/Kconfig                 |  10 +
 drivers/phy/freescale/Makefile                |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c      | 630 ++++++++++++++++++
 14 files changed, 996 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

-- 
2.33.1

