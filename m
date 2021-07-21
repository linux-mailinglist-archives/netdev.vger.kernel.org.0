Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF403D0D8E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbhGUKnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:43:43 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:45696
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237566AbhGUJcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:32:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EW96/CIiSPC+DUVbvh6QnlTTnev48vgQZA1BNdGEv0JluNd7jfyhgo4EaXC9XkSFMEML4GQ4N7U9HTc20pF9MdTTPuDl6qbHOGr4Ta0739/fNbF0gqxBfbv2iByy0P41DoDmok0mZYFcLfwMYmImL4k+os2s9PW28j56djUDvlnwO4GsxxPGK9awPnb/vwQCkXyqMCfwiKlj4ZQ15BHV2JJFzcYcTaASM2f4gGUOVHor5DopZrO8lUxHeXzDa6hVxHzgc376srNCXxtRvsXF5dKmNkkFskE0RWcpIkVcSAOc4P3/VCVZFj/5jLjjbu1D4A/mYcMQkWcEh0b705ultw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eUnslCw/qHp+T0wyI5XAUkzUatwF5S7M7N5Ysi0R4Q=;
 b=dmgV9lUfMn+OoGTMZkqVrDNrjulDertBDZt8GWpiMT3lnqvTCSyKkgR9mIUHpV0582NZwCBIS7zCMG35XzpzDy0rxdpsz1tKvBe5upYU8eC5fouDV/nBGnQuS/hKgjrpolFLuIsP/9VQYc0dYCLrTCvy3g8HwzADtkfU6chcvFdgHvcAw4yLnsml/srrdElFsjYO2K6BxY4O1i9cGGObIl2Fnq2Fh//9+99eY6zXjAos+1StSKEJ5r+PgAI1YX1PX3rjTezuxq4PH20yjRMoaOFgSrcdJGOemEbBK0r05btc9iW1y1RDop77ZCEdjAyQnOpmPZx3hFmBazWjSjoGJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eUnslCw/qHp+T0wyI5XAUkzUatwF5S7M7N5Ysi0R4Q=;
 b=XraNbnIwLzOXbt74jXm4sAJHzlvilc9ihirEEQBNXV8aQbiI2FSjbO40yajFZEfjsBRSUY+p0pTmhMoYeeBQFoy7JdlARkHRdHsQxq+62k0biUTVm9xiyx0mcNWlp23gLgsfEvBDo5XojB9V7Kp2d+EQtU8wY/e8bM6+JzUQ7X4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 10:12:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:12:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 1/2] dt-bindings: net: fsl,fec: improve the binding a bit
Date:   Wed, 21 Jul 2021 18:12:19 +0800
Message-Id: <20210721101220.22781-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210721101220.22781-1-qiangqing.zhang@nxp.com>
References: <20210721101220.22781-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0195.apcprd04.prod.outlook.com (2603:1096:4:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 10:11:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856bddb7-abe2-4b80-a7ba-08d94c2ffb89
X-MS-TrafficTypeDiagnostic: DBAPR04MB7480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7480C8603266AF86704963B3E6E39@DBAPR04MB7480.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xc7rkrWK6dL3b+E05GqcLFumZ/UFd5M81CxQKO9WO8eBEHaVhXOGdPmTgJC5HFz3F7G9jkF+Oy+0rFRrL/ulU/Mv0UG7limRWRmujSq0IowJ/4UtgtzeJS1JPGNYyWLjtupAevL3AgGhVC3BegDQ4a0qOvZhfgfygl/J3ZGhVbWh/uKTEY6DbG8O9pRCa6AtyL6dg5PcGA2aMLEFe+cLMRQ/344GGLfICn29G/F4EKAVPgjK/oFJcZTKod5aiLg0tOe5R+wsZABqQWPR3X3xdkQQpY4NfELIcc5Xu1rEg4wpBvWpGaE9cfJOI2mAa3mvhqnfiCCAHggaq/DwA4pFpWChtO9QHrEZZ4b5DzrVqa31KYF7cFpQP3enuQA0ylhydZo1f9eDFYWvFWSL92gjeq/tRTfDstTT8mAy5szYbAoZ/h9QilZiiB5+3q0MWBdQmNKJV1fOeNFEA+bTgITEcsYCQYuOl0Ipoz2p3Jvjg7TWF5idsxM79CWoCumgwAWO/C2SuGop8Dn1GVTTHEtlVeqkA8kZXEVbnuwCpNV7ZKpeB/Tza4MN+u2b4MTZ9oEBnWpkE2KSbRmgZjz8B6E9NzVUyVkWnImywzwMGacOHN14xnn4AtJTE4qsXd7ESevim+1tBaqYpOKZf9xSAqc30hGV8zn8tiNdup5N+DVZKQzTbyZHzFeNuyIS5cd/YI+r43l+ioEHiNFBGRGlOpWS8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(1076003)(4326008)(186003)(66476007)(66946007)(5660300002)(6486002)(8676002)(478600001)(7416002)(2906002)(26005)(52116002)(83380400001)(6506007)(86362001)(38350700002)(6666004)(8936002)(38100700002)(2616005)(6512007)(36756003)(956004)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lyu8FaDcNqBW0XBSRrUSKmHpQxFBLaXgpd1G0eYYbJ+DZVto3C0W4VFjU/Au?=
 =?us-ascii?Q?pGwmxCB5PMEREMRlsoIj/qcr6YEsLLCFrWxrgIQ1d0XPO7sZSkQirarVIuB1?=
 =?us-ascii?Q?r7RuvjY1bRw2F1RiXk5JdQXJay+qNwoNrLri/fsKo4JBthlknQybkUf92Ps4?=
 =?us-ascii?Q?YE5w3B39UonveK65QEqKpeNRkF5xtVnX+zxJkPJwGOllbX977Eg8uNLYQd0D?=
 =?us-ascii?Q?TYVdwlvg8QF618GsrFa4KZdMG2irnzWYIwXj0CPxPlzCy/Jm9KRMQ5on5svt?=
 =?us-ascii?Q?DN0w7s8mfezI8UTv9vTYyMvuFYQB+KlQXZgVYoxP9dykntqc4IeqcBKlx/1j?=
 =?us-ascii?Q?HpZlBE3ax3dSyTlFmpKM495tlDrIWasOz+TO+oCdDpvpFutPLQ7Gd3aqQlZa?=
 =?us-ascii?Q?KOgCXSQZPL8hkPv/FAsKQNi3rriyNhYSEHPVmmTzDVWSMuiVW2+pGiRxWL0j?=
 =?us-ascii?Q?+MA40ZJMKyTQOuv/4I/8f4y5D/YFZV8OtcMuCk162c8vmmyRpBbX1yiEx734?=
 =?us-ascii?Q?+wUm+9GccELhFerShILL5iBZ6kouTPUeoHt0Viusef2WNzyYxfYPfWSUNEcP?=
 =?us-ascii?Q?jieSlUGDOm8nv1gpZj68yM4jf2vQ1dlv/lJlaoQEv6F7NN2i6N/vfTSNuvfl?=
 =?us-ascii?Q?rHfxrwCvpNhh0WpEk5XZIcMeavbWnlxcmugetT2K6RIWsvUhag2upNCPvw8x?=
 =?us-ascii?Q?a/X2DzXpRIMbOXsNqfmVy0iDFw+UInOEmxgj/f5NohuMtM/wM/tszCry+W2X?=
 =?us-ascii?Q?8ycVkScAoh3lEDQuwHc3m6VoWn38xUh396g3k3Qda0fCW/snXOJgd+E53Lb/?=
 =?us-ascii?Q?t+N9sz5BzN144nKlMJgmvdKckagfK3BJ7sF9Y2R1Iix72oTESylRlONK5C70?=
 =?us-ascii?Q?lJVMONB5Fp+6e8zWUE5WV0xus4A8SViSfxnhzcu5cmpXUZaQTwjHd8DY0XmC?=
 =?us-ascii?Q?Aazt9ZHYSMRdKeDSQ/bhFOfq3lzfc3qK7dtJCzA0GCTVluy9n1SMt7yG+LpQ?=
 =?us-ascii?Q?2nNgHk6oyRdmilJNRw68woDgqdDvKcHsg3USPjxi52IgCqhjrv4NqkgLzAR5?=
 =?us-ascii?Q?Z6yOU0HBEbQb1BLXZj0I0g6k6XDWS3a7dvnvhskY8yUhXm/RcJ5o0jqMpKDk?=
 =?us-ascii?Q?5c+U2ZfjqoZGRmSxATxskSqoW5lXqEEBFgcKJNVyybES0q6abG91qFDianYN?=
 =?us-ascii?Q?H25Kxa/gxeGeDPNXJtqURZuBVDwWBd5pYfXRZgmUm+J78/mh5lfwqjZOGJjC?=
 =?us-ascii?Q?OB/8oOTta/clw5CdlOpB/KOQ2Ct118QCb3Axzx3wt+lUbB4N7NlFT78gvMY0?=
 =?us-ascii?Q?ecO+RdGyt3LQVKWolL8Tnxaz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856bddb7-abe2-4b80-a7ba-08d94c2ffb89
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 10:12:01.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25hhv9O+KA8IKZLqPmT6XM+p9WbFBMQQWool3ZmJXOECrbtj7YhepYDMX8JeVN9iW2CzSDaP1bSgeT8tgQEovA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves the yaml a bit according to Rob Herring comments:
1) normalize interrupt-names property, there is no reason to support
random order.
2) validate each string in clock-names property.
3) add constraints for fsl,num-tx-queues/fsl,num-rx-queues property.
4) change additionalProperties to false in order to do strict checking.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../devicetree/bindings/net/fsl,fec.yaml      | 34 +++++++++++--------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index 0f8ca4e574c6..dbcbec95fc9e 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -49,19 +49,21 @@ properties:
     maxItems: 4
 
   interrupt-names:
-    description:
-      Names of the interrupts listed in interrupts property in the same order.
-      The defaults if not specified are
-      __Number of interrupts__   __Default__
-            1                       "int0"
-            2                       "int0", "pps"
-            3                       "int0", "int1", "int2"
-            4                       "int0", "int1", "int2", "pps"
-      The order may be changed as long as they correspond to the interrupts
-      property. Currently, only i.mx7 uses "int1" and "int2". They correspond to
-      tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET_MII interrupts.
-      For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is for the pulse
-      per second interrupt associated with 1588 precision time protocol(PTP).
+    oneOf:
+      - items:
+          - const: int0
+      - items:
+          - const: int0
+          - const: pps
+      - items:
+          - const: int0
+          - const: int1
+          - const: int2
+      - items:
+          - const: int0
+          - const: int1
+          - const: int2
+          - const: pps
 
   clocks:
     minItems: 2
@@ -80,7 +82,7 @@ properties:
   clock-names:
     minItems: 2
     maxItems: 5
-    contains:
+    items:
       enum:
         - ipg
         - ahb
@@ -107,12 +109,14 @@ properties:
     description:
       The property is valid for enet-avb IP, which supports hw multi queues.
       Should specify the tx queue number, otherwise set tx queue number to 1.
+    enum: [1, 2, 3]
 
   fsl,num-rx-queues:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
       The property is valid for enet-avb IP, which supports hw multi queues.
       Should specify the rx queue number, otherwise set rx queue number to 1.
+    enum: [1, 2, 3]
 
   fsl,magic-packet:
     $ref: /schemas/types.yaml#/definitions/flag
@@ -179,7 +183,7 @@ required:
 # least undocumented properties. However, PHY may have a deprecated option to
 # place PHY OF properties in the MAC node, such as Micrel PHY, and we can find
 # these boards which is based on i.MX6QDL.
-additionalProperties: true
+additionalProperties: false
 
 examples:
   - |
-- 
2.17.1

