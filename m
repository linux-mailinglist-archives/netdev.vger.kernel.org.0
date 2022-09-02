Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA65ABA65
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiIBV5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiIBV5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:57:22 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B170F54B8;
        Fri,  2 Sep 2022 14:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muBummFQeZiVOc3YmsQ1izfEWdG9WgCqmoFVWMv245YX9uOUw0ksUpBfObxiScUiX3gWpwuN3nCb8oHSxf+om/JokkoRRHn1d2H/83Juq8AchdDCqF+Cdl6l90ENR4pxevl58riPERTnOgHfKxGaPWvLvcub1PrXl7HAXNLgPeMg5zVDZW3ALKYKLmmrLRCqz8toxD8MpQIJKTc7NpfDTKnNBYMlE61tZ68H5rtMX3c1vlcjngSlzXp7t7LnT4fYMFtYvUisFjeD8zFXKxxkJrp1Souytp8FxIEhNfI4KiMHrLL8bsiqqRiJseI2qBB8FA0Mojwf5orHfpTv236hOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J3CB2Dy+VeKkavKXMISZQ4qABPzcOdUuqBzZ066lvTI=;
 b=Ywv3xrhOPBl9dnA5oqFmM4H39Xhzg7o5n9Yh3gYLPpIygWMXgA9D5zrddokfqzmo1buivcL44VizUi3JsfG5cF3JioAVNgal0mbCXNwpfy768saS03bKPXUHt6ze5MRZDEWgsSenKdYhWaIw4NXwdHNaOb5HCPZ2ZvqlLQd0ZAH7+OTO0Dpr2b2BJbu0cMcfHgAzf5KgDdr7N3emL7J9MzIiQmfwUUEwOWBPro/iYx+a36hDpsrKdP3YN4iehiwSThZDXCqUu+8avP+yR5Hj2tYskWFLPb+Nof/nVm2tdjFKjepMiIc0/LHPUCjawv+Hb+VVI5i2ITQfFzjhaSTQTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3CB2Dy+VeKkavKXMISZQ4qABPzcOdUuqBzZ066lvTI=;
 b=eKK+VObuR5TxYfeYb0Pmo5eLRv2R8mGLjYuoW5TNecWGf7k1C4/mZelhPi5UcT/Pjn3OuYrxueJZckHFRVz+t4bbv1rXjYKEtTwVto6W5JbPS2NNGdNTgZZB1dIhcmaulPazAAQTa3O4KjQk2PB5j7Dd/febCJZe4iVLIaANziw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4576.eurprd04.prod.outlook.com (2603:10a6:803:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 21:57:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 21:57:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] net: dsa: felix: allow small tc-taprio windows to send at least some packets
Date:   Sat,  3 Sep 2022 00:57:00 +0300
Message-Id: <20220902215702.3895073-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 960dbe92-d86e-4556-ba9b-08da8d2e1916
X-MS-TrafficTypeDiagnostic: VI1PR04MB4576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhrqjjhjMuOzj1XaXVebO7ljaEwc1kd+tBgWaqXI2cJZ2d4KXRH8asB03QjrdsrBquW9x3MXLqtyJkwUaW95q+pgPUmuckgkb9e2os3F+iawEhc9iqzgCVjmAjNoKJq6hrFhPHeW7iC6UOhlEwowQB2RcS+OlHnUoU1eYLuH8OMSRjlhhaaiC1uP5v2k3tifZeD2+fZ0+sU0xuQ9j4qkBWA1pDTzel9vjau5fjFPt7et26n8HDsexO1NX9X1+alQ0uZ1m58EnmT94fjJ9V2Dq3qPqVgC2ZbEdtpanWzCIQ8BN56O7HHziUqxG4fgE4kBxMXIF4+ptHONPcz++7Qx9e7TdZzz3kcb1X0r85dmW/F1neTB6vWDLGx1iSStgh+KDUp4rj4o9jWgPyWCZ40t/LO/esqcv0uePMBOv/dlTJDiJesU3wJvt65X3zPBOB9hdPRGa/jw4MQcScuKfQ9vDpjURCA2/wje7hGm+LRv6n0HyOZxowcopOJryClFj7UumIrcve+OxMvsdiuV+0k9LpHyc9mQevm5TGiwKwjC682szZh3FH8hD2bgX98XwkURDEpb6lDMKEjalkvOOyO8qoZsJd/PXH0GqwfHihsQ/bXkdT64Q0DOoyWqaCTQR3uEWm7m8y1P7bkkCcne94snjce2odzRmwwi1YRumemGJwPjPz/peE54L/toDOYl7XMuTHLfn3dEdiCAGvFLNfAiLd/t5gjUtpemNGF+WkNduzBrQr+aGf0YjT5/QR31WmhGlxmdqo+GXAjmrIk4SIjJbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(6916009)(36756003)(316002)(54906003)(38350700002)(186003)(38100700002)(1076003)(2616005)(86362001)(52116002)(2906002)(83380400001)(41300700001)(66556008)(66946007)(478600001)(4326008)(66476007)(6666004)(8676002)(6486002)(8936002)(7416002)(44832011)(6512007)(6506007)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XknUz/bHILFQNxIdDlJ5zoNeMBHRHPTQuHfYW2PYdD7uSMLkHbQtf+C4vsEZ?=
 =?us-ascii?Q?yJFyGSiyu7AdMUBC6ExxoyLmp9jreInemgNl16fphj6xk560hMtlgNrMKdyw?=
 =?us-ascii?Q?6W9ddXUNX+8ytHztAA854MhfAmwlmhGaaF3aRMZAjFDsdnxiZK76bKr2RH2c?=
 =?us-ascii?Q?FwHjxPLj3aHHTAZqWHHWqMGw5u1m8e0aWiYEFO4CLOHxYt3Ff+323WYPceCT?=
 =?us-ascii?Q?dIxSVOwStKPecQeqvAKEba/N2fCUr+DV/Y59nVBcj7hChx5bcHF5hhClvGKz?=
 =?us-ascii?Q?wdNG2SwHN8PWjEoyj1RLVTzqDg/T8wreWaGKpEwM5O/SYAxM+jxGOY75hDYy?=
 =?us-ascii?Q?tHXuWPP4gZ855Qj1/Uofu5Noeu/EiCiua1exK7o4ylChYS8puqgMu2HskgaW?=
 =?us-ascii?Q?mPOtrgakmjIYn3tb1n34y3mYBzKIEsimyW8v2hy9RuH4N7XMfwXhld71up6y?=
 =?us-ascii?Q?+722GUsyQLDdoZJbS8JpkG0kl4lIYPK3XEnNzYgVyLbubNxfA+95ysigvrcj?=
 =?us-ascii?Q?LqLxoBzoqAsxCeZeqK5xP5DnRopiMdn0ubRXUDfGgUUbePUKSKnTL43xjJYv?=
 =?us-ascii?Q?L/NlnKYvIuI0V/wuuXDuUckEqpNoNvfCZYFBm8LIMs5qn4G33zxKwrpPVC+0?=
 =?us-ascii?Q?VXZGh5Yx7qV9brLjNrUD5icp9Iej//HrB/FLrKwKgbO1/dIv1aZuKSKXIrl5?=
 =?us-ascii?Q?YCmbK74nW3CVB3hImyRT0iN6NiGkkgEjwmbHHUFjegvPrxcXaQkUxMxtYVal?=
 =?us-ascii?Q?qGAWdX8oaW/LSlFbIqTl+P/OkRsBPZZd8KqmkyX/KCECd6Z3Q544sMVZh9Iq?=
 =?us-ascii?Q?heB9+JwdsPheDta6TYH1dk0UyzoAhWbOcBkwB9XEhr4x2vmTDhM1E+UWYZUq?=
 =?us-ascii?Q?vWTTKQitWCb89N03TMtsP0Gsu5mefhnyEDFUUzYRg6SlXR/MroNhSyzgzTqa?=
 =?us-ascii?Q?iYkKAF2LDuDxmiturhCas4Re/8APEIsFT5/Hy+ML1olATYAZNlt2IAaJztg0?=
 =?us-ascii?Q?CBIstzgiTrdJS+9CU7cx9j27YIcELpeKYFx3HceSfWLgUB+o14VP7bWJeRIn?=
 =?us-ascii?Q?q6Ws+RdqLXDeuR/o9IBnzsh0JB8nxASJUNkHSj2WsirPjrLj5psgfPlX9dzw?=
 =?us-ascii?Q?caVGRFMvNZ7On3E6SG+brMM0Tdb2ZArNWLPUiQj6VlWCuM28pHAAs1yv5kvs?=
 =?us-ascii?Q?V5eT4tXVDWfCoP/2foCMxPtWlyGFn+0LKUvtTU82zi8PbuQKR56f6FHTdnFO?=
 =?us-ascii?Q?qsw7CdZOE9/+YaPYcktiRluLbL4XDFcGIwOiGI8SpNb8PI3jfIsCg56PwB2g?=
 =?us-ascii?Q?KbZydTOzKFKMJO9PrbLv7lZXlvPLhQdP5w3mLE2vW1UEOUh+T6Vmx2j3hA6Z?=
 =?us-ascii?Q?8u5rz5SRff45hjLYf4lEbMtHupHb9n1dFq2Ro3POxIXLdj24vUYhPHEKG8v8?=
 =?us-ascii?Q?Xi6cDko/YJdijLx4JUp7M6h85OpR1gT4a7AOKjpTKO3Vi6XAYs+dVrQ17rPV?=
 =?us-ascii?Q?L0zy9LP1qLsJoigWxWvi9Nqv9Q+bYXFO36rfx0cGh0rML06EqOjVUrnHBZP+?=
 =?us-ascii?Q?IA6sasjFZJVhGrpR2EgZtS+JtQUlBY28VMW85xFoLNPmwgpg+G/DYd2wodiQ?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960dbe92-d86e-4556-ba9b-08da8d2e1916
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:15.6840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+pA4Rrsxzm61tlPxU/zC9pbD6PGI4ONLpmzR/slRVj09pD7esq0Dv6Z432oFpf0CIirZOqOiVKiEgcIFI7isA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit broke tc-taprio schedules such as this one:

tc qdisc replace dev $swp1 root taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 \
	sched-entry S 0x7f 990000 \
	sched-entry S 0x80  10000 \
	flags 0x2

because the gate entry for TC 7 (S 0x80 10000 ns) now has a static guard
band added earlier than its 'gate close' event, such that packet
overruns won't occur in the worst case of the largest packet possible.

Since guard bands are statically determined based on the per-tc
QSYS_QMAXSDU_CFG_* with a fallback on the port-based QSYS_PORT_MAX_SDU,
we need to discuss depending on kernel version, since the driver, prior
to commit 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with
tc-taprio instead of hanging the port"), did not touch
QSYS_QMAXSDU_CFG_*, and therefore relied on QSYS_PORT_MAX_SDU.

1 (before vsc9959_tas_guard_bands_update): QSYS_PORT_MAX_SDU defaults to
  1518, and at gigabit this introduces a static guard band (independent
  of packet sizes) of 12144 ns. But this is larger than the time window
  itself, of 10000 ns. So, the queue system never considers a frame with
  TC 7 as eligible for transmission, since the gate practically never
  opens, and these frames are forever stuck in the TX queues and hang
  the port.

2 (after vsc9959_tas_guard_bands_update): We make an effort to set
  QSYS_QMAXSDU_CFG_7 to 1230 bytes, and this enables oversized frame
  dropping for everything larger than that. But QSYS_QMAXSDU_CFG_7 plays
  2 roles. One is oversized frame dropping, the other is the per-tc
  static guard band. When we calculated QSYS_QMAXSDU_CFG_7 to be 1230,
  we considered no guard band at all, and the entire time window
  available for transmission, which is not the case. The larger
  QSYS_QMAXSDU_CFG_7 is, the larger the static guard band for the tc is,
  too.

In both cases, frames with any size (even 60 bytes sans FCS) are stuck
on egress rather than being considered for scheduling on TC 7, even if
they fit. This is because the static guard band is way too large.
Considering the current situation, with vsc9959_tas_guard_bands_update(),
frames between 60 octets and 1230 octets in size are not eligible for
oversized dropping (because they are smaller than QSYS_QMAXSDU_CFG_7),
but won't be considered as eligible for scheduling either, because the
min_gate_len[7] (10000 ns) - the guard band determined by
QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per octet == 9840 ns) is smaller
than their transmit time.

A solution that is quite outrageous is to limit the minimum valid gate
interval acceptable through tc-taprio, such that intervals, when
transformed into L1 frame bit times, are never smaller than twice the
MTU of the interface. However, the tc-taprio UAPI operates in ns, and
the link speed can change at runtime (to 10 Mbps, where the transmission
time of 1 octet is 800 ns). And since the max MTU is around 9000, we'd
have to limit the tc-taprio intervals to be no smaller than 14.4 ms on
the premise that it is possible for the link to renegotiate to 10 Mbps,
which is astonishingly limiting for real use cases, where the entire
*cycle* (here we're talking about a single interval) must be 100 us or
lower.

The solution is to modify vsc9959_tas_guard_bands_update() to take into
account that the static per-tc guard bands consume time out of our time
window too, not just packet transmission. The unknown which needs to be
determined is the max admissible frame size. Both the useful bit time
and the guard band size will depend on this unknown variable, so
dividing the available 10000 ns into 2 halves sounds like the ideal
strategy. In this case, we will program QSYS_QMAXSDU_CFG_7 with a
maximum frame length (and guard band size) of 605 octets (this includes
FCS but not IPG and preamble/SFD). With this value, everything of L2
size 601 (sans FCS) and higher is considered as oversized, and the guard
band is low enough (605 + HSCH_MISC.FRM_ADJ, at 1Gbps => 5000 ns) in
order to not disturb the scheduling of any frame smaller than L2 size 601.

Fixes: 297c4de6f780 ("net: dsa: felix: re-enable TAS guard band mode")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1cdce8a98d1d..6fa4e0161b34 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1599,9 +1599,10 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		u32 max_sdu;
 
 		if (min_gate_len[tc] == U64_MAX /* Gate always open */ ||
-		    min_gate_len[tc] * PSEC_PER_NSEC > needed_bit_time_ps) {
+		    min_gate_len[tc] * PSEC_PER_NSEC > 2 * needed_bit_time_ps) {
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
-			 * dropping.
+			 * dropping and leaves just the port-based static
+			 * guard band.
 			 */
 			max_sdu = 0;
 			dev_dbg(ocelot->dev,
@@ -1612,9 +1613,17 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			/* If traffic class doesn't support a full MTU sized
 			 * frame, make sure to enable oversize frame dropping
 			 * for frames larger than the smallest that would fit.
+			 *
+			 * However, the exact same register, * QSYS_QMAXSDU_CFG_*,
+			 * controls not only oversized frame dropping, but also
+			 * per-tc static guard band lengths. Therefore, the max
+			 * SDU supported by this tc is determined by splitting
+			 * its time window into 2: one for the useful traffic
+			 * and one for the guard band. Both halves have the
+			 * length equal to one max sized packet.
 			 */
 			max_sdu = div_u64(min_gate_len[tc] * PSEC_PER_NSEC,
-					  picos_per_byte);
+					  2 * picos_per_byte);
 			/* A TC gate may be completely closed, which is a
 			 * special case where all packets are oversized.
 			 * Any limit smaller than 64 octets accomplishes this
-- 
2.34.1

