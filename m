Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076EE3D0D89
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbhGUKni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:43:38 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:64741
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237812AbhGUJbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:31:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWuf0J+E5DydnRqDeppUZ3+Wlry5sxKRKbA/4bBYYNIs7DotBb+i4Pf6RlZU8gO0USz1kZHNfa5nR2v06TYdg9QMTMfVBq2uWwnd7CfQkLgFRciDJca1/giDJpMpEOGjUJXBvojEviCDAgwjlfDGInaSoPlSzZSsqMJIXYiW5ujTSPj0YLRyIvjPDYqpal2U1yPCic9nN/gOiqp0tLRD13s3BTq+O9Iga+6uSPMjWWmey7DpapfpWFGUOEdk1sviMFv/a/+j+ppu1YPJPXk3MbbYnPqj+9pFdo4y1IiWvKMvk7mty39eQrGleau9hj3a0XhqPsz2MCLWEw2aI0w5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUTYTVZYXS6uAjjbMDPbDb6XKTqtrHPodnTJrWeOqrs=;
 b=WadHg4vPVkMEqcTMFgMr4qS0b1D4H23CMUIYisTSVmu5CaMhvnsEgM7c6PdWDdxS4JzB4mhRXvg+T4FwK1/G2D0bALjFibYIbsRHmeDTaRpNLYH6Umruz6a/UatFpv9zSIOrlwl/BQy09TL5cpYIo4VK8GDSPYx+IWqCIJaKBu56CX86iJMQ9tMy8cGl0fX+71GsfYrLSvsL35UaLFW/cYQSD5tPrs3mQdY4w7AjqOKAMIbSVWEzsHXHDmV1e+OvEG/GOt+2lU5ZGj+0u3VNYGDFR9ECkrfzwRA9v9u3lxf27roaeI2HzXjRglDN+qUsbJ+UNysVuR8JoltyNZT/ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUTYTVZYXS6uAjjbMDPbDb6XKTqtrHPodnTJrWeOqrs=;
 b=U2dKEShMMwplXJuUMiB/xIuqZxTkpbMCWSmZZ+G+gAzGHSked0Ico9FDesLUHOMSGiP/GM+t7PkTIyWOv3q+6SX10bZMhmkD4TfliQpiv06KGitzbc8OCzKOWQg0r/8DZ0UYpnjOJyCcgi79QbfCOSsC6AXmc/pigXbYIEsMqYY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 10:11:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:11:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 0/2] dt-bindings: net: improve fec binding
Date:   Wed, 21 Jul 2021 18:12:18 +0800
Message-Id: <20210721101220.22781-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0195.apcprd04.prod.outlook.com (2603:1096:4:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 10:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64da49a3-254f-411c-5b4d-08d94c2ff93c
X-MS-TrafficTypeDiagnostic: DBAPR04MB7480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7480BCAE151E675D8E26B73BE6E39@DBAPR04MB7480.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mLCKc8DDiSjyd+XdHoE2KanW9TFu0mUVZWSevhmKfT06YWMt2RejN8KkvK1kJvRQFxpqDnNhhcgRttpRRlMAsbmfdO2qk512/afDexaqibQ3YKT2bDDNgCydsBT/2pB3FkWzMjeAON+zWQrDqW8Fdoya11zftF/oJ81NYn5aLhlEOwcDazXoYIedwy0sCmnZVpQYc8X0TbnglOAzdSQXptxHTLA9Ct27MBRAjCV+YOFqA+wsQyMnkJTap7mvB/UsRwOfWfMGao4rDNvh0APXlO/5kQ6Ze2ceKmNOhbrTmuhHc7uTju5zpgq7Zt3VVc7xCAt/xz73u74UfdG/dScj3YHwLJcTc0leV+N4tTkxCMmVTItFMHeSDd958yGx0AhG4epv49QJczB3knv9rFmbSf2Vp2cX/4A04W9vxTqoYQS4DRyyRSxcK/SePcwCsAicuXz8PlgUyf2v6pYpRzymWedwC+/beDPCQ9tNRNuDAtjBD86iTVCYMcia1tI9ing74bCa3CVj+9fC0nE+1SxbTCqR5t3MSNlW1zqaU0/QJiXAksqPdiRnwhRKsPBK6i3EUFaIU3nI6doL1PSfX6bL0rrbQzBs4MtV4WASKzQ5Z/5z+x1A72iksWnRXMFOJwy8Glv7Q6b4KecGxtaJMMLbUZXjZNMzm8I7tSdVbRGzzPPNkxQO0CN2tEF0rQK1VStCg0WzlvHXF1eo4qG0vTLkqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(1076003)(4326008)(186003)(4744005)(66476007)(66946007)(5660300002)(6486002)(8676002)(478600001)(7416002)(2906002)(26005)(52116002)(83380400001)(6506007)(86362001)(38350700002)(6666004)(8936002)(38100700002)(2616005)(6512007)(36756003)(956004)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TR5nYPooTPJdkM9xEFAwSBGpyJ2I5e18/C+H1RgZdcuJM/aeOyU24pavYF9v?=
 =?us-ascii?Q?kESiFbqBgxWx2wWGjhMfUHRfJzXZ8WmDjU+lQeLjWSsFva3RPUZH11Qfi8W0?=
 =?us-ascii?Q?q543nv5G5yJho6LZ3WpvPDwKwIZJG0xhR53SSqXGEicchiglp2qAOpgw3uH0?=
 =?us-ascii?Q?rhHzx6qk+FECyJU8NBeIvHeM0Jm0RyDAwSuswi6qOV2IfOpBBH3W97+gdavU?=
 =?us-ascii?Q?VIYVpTdqGJ14kfFuktzCBAye0IAVplTj77WgEGrPa0XMXl9H+kC3fgVlY2a3?=
 =?us-ascii?Q?4D7ICXCmNI+QMJBvQXwFDVo638SBBiQZcvMd0DT1X8aybXnEPW3tgVzHPip/?=
 =?us-ascii?Q?gMBw0cCauIyv1Ni2HJnI8EN0i3wB1/G+wa7DIYJFS2MzX6zDeVc9UC8zpd9V?=
 =?us-ascii?Q?dvyqBik+XPCgRzti4J8WRD2uEDrM5NTghZRbAHvopEI5Y+17m5mY3PVlbXHT?=
 =?us-ascii?Q?MsBMvOQWcSySHvgDdkQm0vgFOdcaOgmw6PEi2pSWK7dvz9lJVVJYqeh45Rgi?=
 =?us-ascii?Q?Yfgp2D0mQs52MCszp4AwJCJZy/uJFDvd1wa3eoqtXpmlHemTF2EV2Pxs+z7H?=
 =?us-ascii?Q?M3vBRdfk3T4OaFK7eH3u6lJEbOpvGjWSbZ6R8Nf6BTZXqf2BAwMSgNaQnZMB?=
 =?us-ascii?Q?xqZoe9VicXS5rQwMpsXzc9bUzACGehrlEla1XMpCUyHcxDC8RiSbqCw1hWi/?=
 =?us-ascii?Q?BwFTKYmR7lWh2qHbhyiIWdKMubo7+GGoRzgBbq0OuMkNrtYFnWb9DfDlWxrd?=
 =?us-ascii?Q?u8z+aRASbD86z2+QqcOpyOov0oPr6/65QiqKEvD+njbGsXdYBlrwS4ZJSf9x?=
 =?us-ascii?Q?XDLFZoLmQkKNQrfhAqy7Jc2HQg72roQMBfzygP1KpBuag0CoXj1Tb6ts8u8S?=
 =?us-ascii?Q?bTV/+dmX/buSKxi3BGG3iN17vkVgd3GFuGemg7VNRMQwTRW8etDlkRGWDeaf?=
 =?us-ascii?Q?lxeC0neIsvdWTggc5B+kIVWM4GkrVrRFQzvi5dFgpGOa6Rce5g2XCG92EnOu?=
 =?us-ascii?Q?ydO/U5XJdGy+QLy41wey7+EUtQtG+wIuCSobjmKnNqnoIYHvtXX9gCrIXm9N?=
 =?us-ascii?Q?k5ZPIVm4R31nb0SkMZfmhdrSGTCOvzvgHYYXUXKn9DSiKK8Ob9kq69j7J2Xe?=
 =?us-ascii?Q?MsAxo6DmKVIY/N7pb04OfBbE+Y/4yD4sFKcz6FT82wJbQXSaPK1RY2MqmvP9?=
 =?us-ascii?Q?SvauBIcUqC0ZvLN63Qsf/d3uzXN87kIln68eBWtoBEMvbB35U6l4HFsREK2D?=
 =?us-ascii?Q?pZBV2M9GyhafsaJfaG0NeWxIpFGzVHcr+kouXOTK3+ag8sfcbImXPu96VT9o?=
 =?us-ascii?Q?FL0a1E9qQdbgvGvFBeEFJgvm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64da49a3-254f-411c-5b4d-08d94c2ff93c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 10:11:58.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBmErUHmf0mf6evlJPHZ9d0hThr1leDWAioGnPm96DWiaWIeN6kQT+BMNzxIDFw00o1foOmUdHGAsNs6RFlYSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to improve fec binding.

Joakim Zhang (2):
  dt-bindings: net: fsl,fec: improve the binding a bit
  ARM: dts: imx6qdl: move phy properties into phy device node

 .../devicetree/bindings/net/fsl,fec.yaml      | 34 +++++++++++--------
 arch/arm/boot/dts/imx6q-novena.dts            | 34 ++++++++++++-------
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi  | 18 +++++++---
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi      | 34 ++++++++++++-------
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi  | 34 ++++++++++++-------
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi     | 34 ++++++++++++-------
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi      | 34 ++++++++++++-------
 7 files changed, 143 insertions(+), 79 deletions(-)

-- 
2.17.1

