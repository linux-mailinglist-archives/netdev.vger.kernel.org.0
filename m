Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F380149E8C5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbiA0RVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:21:25 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:40513
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231688AbiA0RVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:21:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lg9v2XV2cL2/+qTqp5vWkCwmnRUhTtJf2jtndEaPNNchwcMhpw0jaKe4X18JO/ZvtMvFI+WmaqC/o4o8vTYpYqSom/uenIVaoZdCnOU3Upu8BtALC+8bR4Ti+FSXLQZbJWA5a/mzihyQjCw6l8xFnYVUTUuM7b7xotoNUw7OmLOQk2rpymmg7ej8plyYh47TFScL9MmFTCGODsQOJaEJ7MtcDzyxqJTVgcw4bl0SNHsVB0rE7p82Wvvs8ExZMP3wZ/PEVmf6a9oiYsvDr5AdA9zMVqnR5GRUw3iQhG/N3N9Yef0S/M+XtJ1Zf1ysZdVSjtwPAyJuybYnuS9CSFH/Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+1T9mrXPUTxkosF4h/i73QvkwWnpYZOoVIYJiGmpMQ=;
 b=jtFF4tHVQXYHwOiBVwzhtD2AYPdHSKBUNwRluUfhcGLzg9EcpnXarxri8kLAzZhcxReF1wxyNZHED5zVskcCv10qKlx/g8pqMLaAwcEAAfbtJo8eySKdCMy0ToHcuIZ/kqUDDrERExodsyGfVOxu8DwZyavDJAne1IdJDupfKeHUQU5x4+owAYSlWtdGPJVLmL+DQX7owmRjtI7tjCrRZOw3leDhDBg1sI0K0XxJibVjX74/FePIoFjPKp6iAlQo2JFeyArJfmWulwCVK5gkTnZUkyo4VU7A/XWD3tsYaC8AfycfgkQy0dwjjWT38Ag4JUza4FOkgL2rEqUvT9/sCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+1T9mrXPUTxkosF4h/i73QvkwWnpYZOoVIYJiGmpMQ=;
 b=sEdJA7Kf2Exzq1bQp5sMVcg8C4HY17tliw2+ZWRHtqJWOm/GqZQUmWU+Vury76FU9nk95FZps+opoWIceSpAvqZuWnbAOoSECWcuF2Hk9uv4XVjq2zxWzVB2YKbf0m/Uycd+dLQuU6zba8Khr4hxazkLK6PkJ7b6DFcw0tG6FOg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9017.eurprd04.prod.outlook.com (2603:10a6:10:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 17:21:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 17:21:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] Use sl28cpld driver for the LS1028A-QDS QIXIS FPGA
Date:   Thu, 27 Jan 2022 19:21:02 +0200
Message-Id: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1b07ca3-d965-461b-1ff3-08d9e1b97084
X-MS-TrafficTypeDiagnostic: DU2PR04MB9017:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB90171F8FBB2E35A389ADD8ADE0219@DU2PR04MB9017.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRc6/52eiS1i7JUWgNoFqpqV3WwrAkFS/xZRfDVsWeZXyD/GLyGsmSlFRsr52RTd0zyqC9OwANhXQQQZ4l9j0bXiie+9O6+Od4TcGCYUHb9FztYLZLEMPClxa0ZY3TFAQ/a4+7NKquQhxm9ABI4Q3aDFIqS5wPbIg/Gat3kqLuIYBNVVzPvCc3WnHLgeZFWYgYeId0oCpKcxna26AFzEiR6HE+t8Bdx91ZhJ+6xMhLiozWemrK/sDfgwae7YN2c0nRSW+5pXTC2fv8p2MzGmRbZpbzldYgatwPk74ZJq76CJNzraZSAwo5LdByCIhNpAarHrmSaIoRSwx2VPDAJ288POS3vsRK7rdRp5sJtAFjF/4RN9dyiEVxvh13fpz/10Lh7qIDXmWoWTQvNddHGr+omcgyTLSClzy8geLk2nkN5nd7eRyy2MJZh6mQW3E3UVrf6qWOMinkVQNhFkNQGTIsuhnudd4jtM2tt3EeTeZjqABcqRd7OryoaIfcYdCPuF2ETgLcicbLnvGoj4syWts850NXCGrh5PDnO8G12VJGAeWuFb77+TZyxKD882js5RA4vQ6RxTUcyl4hIiwuXz9mgFpdrcZfEL9lAzHVmtznvYkyskJooqAK314obenslCkAl0qTC0uZhblPuYrVhauKn5PoVkucNiKkH0eXADAB1ClBEal0zVjSsE/MqaRy7FYj7eAiexVreSK43wkytMZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4744005)(38100700002)(83380400001)(6512007)(38350700002)(52116002)(186003)(66556008)(66946007)(1076003)(2616005)(6666004)(6506007)(26005)(66476007)(54906003)(44832011)(7416002)(4326008)(8936002)(5660300002)(8676002)(316002)(6486002)(110136005)(36756003)(508600001)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LBvpZ8Y17+9JeMWhMc7w1fQxiaCbQsqLcyPB1bbzz+5XKr9Ot5Jlzy+aXGlS?=
 =?us-ascii?Q?R2iA3/PSheoHpnO9yb6G9Kbud1zr2m6nx8ZZ/lyIB/O2rii4ejJ1on8PWjxZ?=
 =?us-ascii?Q?gvZC8MDJIdLOmB/HuBYjncjRHOXF1cbGh+/DD9w/GUL7tkHgzzqNmYU6l3CS?=
 =?us-ascii?Q?EEqZiioQjBLs0cfxdSdBMjGBWO8yYmPBQIGBv77u+nbvynoV0KOWcocVncIx?=
 =?us-ascii?Q?1TcgY9yyhoUVejqImOoDRiVIX2saPhYeintKiTzSXzQC3s1MPo1JBqDh0iFv?=
 =?us-ascii?Q?LMQ0E/AnldP58c5sjO40w/C1U5w87w5TM7QtLhfc4NVmkDHKZ3w6QmPi0Ojr?=
 =?us-ascii?Q?ijSBH8LyIoQVSrAYsjFQIWdtbI+BJbE2/dizSCj+/m1+2UnIPPssx3qLIG8Q?=
 =?us-ascii?Q?oEX7mCmRLKESV0QmXWLG5mgfszeFJTDgjoAkdsCgtn7wAO0MHNuZiMDX0edb?=
 =?us-ascii?Q?vlrHQcb4u3es2CEX9ZM7IzGRQ/Dulo+wrJ5+OA2mEGjOjoK5xQF/d7UVaWxx?=
 =?us-ascii?Q?6v1nT7QU7eb5GiXP2VIKyq03vQGPDnQv2BXEbD39JhaYasX2ZEpohSYmsMiu?=
 =?us-ascii?Q?xsxDSSyII/Py5Hs1b8NjPa8GbEKOjw2Jsn5yF7aO2/dlVREfjGw6ETVOTF7b?=
 =?us-ascii?Q?2yaxP+F21FJSY0NUnE/+059YPVBhlzZ2+CqvGf62v7v8tsFcXFzEtYEkk8ww?=
 =?us-ascii?Q?lzuehTK+Lu51I8pGz4MOiSBYYpgnIi+we4qZLfTypksCXrHI+Cwj1S99iuTn?=
 =?us-ascii?Q?yEQBMwDrMUm1+z00d0LdfQNdlacXhhEDgAEmo02bhhzMOt0ME0mXyuRjc2JL?=
 =?us-ascii?Q?rY2bVsM/FKAyVuTLT+XVLI+oUjDgtnmewcd8jGEzAGF7DSoujgslclBhA9m6?=
 =?us-ascii?Q?Q3n/mTi8BGuYHvNzpIHJOyhXofaZiLWABo/KM8c+pZrkDKrCDtaBlTGh2iB7?=
 =?us-ascii?Q?Un2/pDE9N6WOfr+QnmnDA2GDgQXoJ0GdLMlIDAw0Q5xJImbBirJHO1HpyRPV?=
 =?us-ascii?Q?wxMQZO0VmnDtw/QnUwp6LVM59TTBXaDNNbXw77OTEDZFv6OZ8MgB8m4I3mOR?=
 =?us-ascii?Q?zcyuu4oMOXCISrRR7V3qoh5Sho5G6VE5JZPzRNw04/smRPL2GzEtw5iuoOlF?=
 =?us-ascii?Q?0ypnZAxjWOpNIRG1fpbn3PXB+KxBSsxegKSrwkRO6jl3osJQzwZIUhpfHyH9?=
 =?us-ascii?Q?+g+/FIw5lFjl20savsIVHZYUNVoztFcKFCXZZLu5pZ0zXRGQe2VcMXbYbPMB?=
 =?us-ascii?Q?xHG3gegkExSiSeoC9zSwIQuPvG6rMUBkQHhqZWOj/cxYDBlu8cOjAh1T2R3W?=
 =?us-ascii?Q?pIGYu+bRA8lFXmDz7q/VBoF2o/zvtJQyBvW/5lqT2TFT4iJ6K1ZEjNpUoApu?=
 =?us-ascii?Q?xBjLJLA944bV5/XfVkC1eF/NnygXXUxGULuOlnyEInq18/ov13MxShezWi3a?=
 =?us-ascii?Q?Z5xVokrpEDZcRd2t4gqvHqChtgjcNx54mWFBH/+b8vEg0KV+AJ5xmr2j1A/f?=
 =?us-ascii?Q?vnXGark8Mw3CXEZ1aX1fSniqLt/C/8ywqXaA9F0IpgtSVO0dGQi7H8XLppQw?=
 =?us-ascii?Q?j74bHu08ko8QskVhRXmU1+Oj8kPQ25ih3+cZP3mWvdPUXCY1Qsj1BfFa+2nv?=
 =?us-ascii?Q?yjWmc0Tanf8Pp56EVZeCXE0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b07ca3-d965-461b-1ff3-08d9e1b97084
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 17:21:22.5354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nB2K1jNVSviIXEc07XamZJtsPEPYAJblwFjoSm/FjpqjY81AVjcxn/yV4WZr65RD2ndkN56aMcPlq+ZAGprk8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1-2 are intended for Lee Jones (mfd) and patch 3 for Shawn Guo
(devicetree). Included all in the same patchset because they're small
and depend on each other.

With these changes, the mdio mux on the NXP LS1028A-QDS boards, which is
controlled through the QIXIS FPGA, works properly without the need for
any additional driver.

Vladimir Oltean (3):
  mfd: simple-mfd-i2c: add compatible string for LS1028A-QDS FPGA
  dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c" compatible to
    sl28cpld
  arm64: dts: ls1028a-qds: make the QIXIS CPLD use the simple-mfd-i2c.c
    driver

 .../devicetree/bindings/mfd/kontron,sl28cpld.yaml        | 4 +++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts        | 9 +++++----
 drivers/mfd/simple-mfd-i2c.c                             | 1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.25.1

