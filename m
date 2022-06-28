Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA72D55EAE8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiF1RU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiF1RU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:20:57 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6FE37A87;
        Tue, 28 Jun 2022 10:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIsjUp4UfZjaMu8vVMgLDJsFGD8jFE7LujtdEF1Zv44lcmlDaYXWnuBM8kFysBFu5XQ7bkkBCvxCV/uRnFwTFbgpSlLQ8PoYykjIzhRA+we+gN7L0W04CMFVAF06MGOP9aQtEx+FWeuliQ7eGW0ibDOR7p/kwou3SStpKACnG+3BHkHrd+3vAKqto00s0UXbagbVWq85fS7U7cYag4GG7iYYhdj/EuMMmQbey/LL8fidvR7+aOPaN/+hcO3s1cYiUQFyK+J11qHlKse2V4mVsEjf/gPLCSGTGRYoEOTqzZUhmH6VnFb1yGcOQteQTe2XME6F6amEdKyK38gShzM+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2tgRbEKNftejBo6bEHuhuE7boB4n0lKiMMWqvCR/cY=;
 b=WVCiOwPOgBVmldRD6X3R6iWiC8+53rA1PoRs7L1erpDkYoaSsQbMDOnpCHWYjpefKUmUWSu1EqoqOctzzGkogx1ePIGBdQX18sm60eRNqdhbbd0AgOMHs5LJLcV22QIhOzVEUehXGSi6rx6NR2RMuyhqaLWadavn2vH9HXVKOBUII0+ROLa0c+rbvu8oT4vKOZGq1IrRri2ozow8z0O4bX93O2jyhOlygI8EwMX5XLE4aAVqIL1JkbJPNV+2NBbSRpEprdQ35PuyfUptuJrPRqKdX2eqnsjchXSvlT9fwOzQL5/0w+nOcCsVbt4o314deedZ79gVfibM6ZRODi9dqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2tgRbEKNftejBo6bEHuhuE7boB4n0lKiMMWqvCR/cY=;
 b=S0wvxva4x8d9BfQTZo6yo5KyCzHor2+ZGiLeQH7Ce0BWR65TG8CzEuG11o/nuASsixw++apoPHi2QL9hVebNfKIRUhzfCwl0u/vqWoKixkp2GLCJU8Mn3jXK4NxRBqnVjGghvOse6FHBwMHsdBtE+eFLuWsEWkVMB40YkmaZUw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4337.eurprd04.prod.outlook.com (2603:10a6:208:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:20:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:20:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>, stable@kernel.org
Subject: [PATCH stable 5.10] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Tue, 28 Jun 2022 20:20:14 +0300
Message-Id: <20220628172016.3373243-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
References: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 108a4011-9c18-42c1-7977-08da592a8e88
X-MS-TrafficTypeDiagnostic: AM0PR04MB4337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PrDrSR5DZTf3+35YFMMSh5XC3hBHjhzg8ZXztje+SJ8Ofg/xmuXRDSGjTuMhI4EGbLqGl/7yAI+d2n7r+crJK32m43wU3/UKh+c6TntNnBGZCWBH4VqIiuuecN0ZHoGQaN1aH3fsaF9ElMZH2tmCWiPwpaaYqE5BFqCbo0DmB+DnSCGvAGfmn00B2rbEuWSQXPrLlsw3RBmkn5R750URGf8/oJVoZ1N/gM9xp7ei9AmXcq55FnoszII7IRlky69t9vd19BwO/ZWaZJ+tMCAL2SHGUFY9iH3gxMp7vnDhdeAv8YWfc0NB25KF8DPqKX2BwF0aMfjQL8PBhY+HC+yKfOnyFVGqckWpT4wdtoz1dirq5IRzqnoB5oFzTfHo1u8gMWMfy598+d31SjtbkyMkqTS2pRk86bTGrz7qUKJY+QOhF6pzsr8LtSZX/H8KRUBwyucKp4R63JBprobDFc2pFZ3RYyDQ0JVP2RRrK2XlES+3rM1rZV3yzy3l5s0uwxCvkAvEtzAKAgU0uJA/pdFfRZ2vFv8vbW6vp02Od0WnVawFrPpQNEd+QjOBs1j6ZLkQH/tl/5tUVy36K1DozPqosgc3FwenhpxMnG0U6DNVacnY4RB/r1j5LIrhP26j7GdNJR2ASQ2rb1sdCuqUQlB8UUcd3QVGLq/G0xa/+4w9LCAVJBXKJDoZ51qgVUS62jHI+O5DZ86jiCBOvBEdqeAbj9N0MEt+YBEJuO2gqxMgBLf5PcmcwrqzD7SIG5t5tT5s0JBHYzSs9g3LCerRY2ZXDjLxk926tGo5tZD2+DtUJtw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(2616005)(110136005)(38100700002)(36756003)(38350700002)(5660300002)(54906003)(2906002)(316002)(186003)(41300700001)(4326008)(8676002)(52116002)(6506007)(26005)(86362001)(6666004)(66946007)(6512007)(7416002)(478600001)(66556008)(44832011)(6486002)(83380400001)(8936002)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVz9NwUUK6JCvrXhdP7f1nm+iVW9+iIBjrmk4FHsZQZ0Kmm728F6Qsh+OJZb?=
 =?us-ascii?Q?p3lwLY33FoXtV9kuwBUaOASUl/s7a29XvXn086x1RbN+zHKMJ9mrPefyVYJ2?=
 =?us-ascii?Q?sNGAMQaruif/tvGOBLQaXeSHjiBFhcVzh9LaCK7hJ1TUbj/y3TRXwYnv0Sfc?=
 =?us-ascii?Q?3eMJMJHUSRG23BeYaRjq/VsiWmvAuchxeqtGvkp+rKElBravEFWSZeHPE41q?=
 =?us-ascii?Q?8kGvIFVV8x/iXf6KbzDu5zb4gxyVFBAvGS3ElNcCdkhHiHXl0PjUC4P/+bE6?=
 =?us-ascii?Q?l4ihGvZFOHYf/+qTmjOjJUdpTvsoTBX9277rl0DG2vpXfZgzzO67twIh6Gli?=
 =?us-ascii?Q?mmPASJypo5jC8jfobRMGRX+DyDNgKrBbTceuBZnAPuK8bNil+pqk3KgCzE52?=
 =?us-ascii?Q?PVyA4qazLwXFx0W9Egfs8tjzgNB7KfN/tdqPD7mkLC+E3RJMREkwk4eDcg6O?=
 =?us-ascii?Q?TFEpiCNSIQvqr98MoSYE0bXwiCc+9gtUPb6i7NPqaBXm3LxWJaxse6WtCMSt?=
 =?us-ascii?Q?okGNgm56SPAXSIVWrpsaFyavY2PrlpFY0bKLlhGTjKcomaSTx9cIh52DE2CR?=
 =?us-ascii?Q?IKnMKZb+zq5F1AEHfNX1WbNSpPV0qDKXBgBPZFkO3rS3gZ9VGBpjGP2B/e33?=
 =?us-ascii?Q?Klvue2RexGyMxqK+6NwYlpg7Ufvvoi1zkmhsR+SKeTkhigkqnwCmlxXK/uQ6?=
 =?us-ascii?Q?lYn+h+V3Njeag7S97iR5JnLFoYVSuIU4Vr42Udi2MgVvTAk+fI9hb06l7Rah?=
 =?us-ascii?Q?s/16xqbOyuZNhP/jQQRr9lzT6cQJhhQNzC0qluzlYBNtSxNtSQyjx0rH1VDV?=
 =?us-ascii?Q?ByphOME5slC6/8J+QoPh2r7imLPvNUUZNOVr7LDv35mTvgcKhN0qGiMelAUU?=
 =?us-ascii?Q?iXQogeqHRU/r4yx/wdFGYNzq0OQ6I7yAvVwVAKVz/CWaFlev4/D97PWxWs94?=
 =?us-ascii?Q?qLvXqVQfYvrVuK1vcVzeL5zy0FB2MSntEqX25660Gczd1+ygUmgJ243AS2D+?=
 =?us-ascii?Q?2xXtYbRYOWLbwYJ5T+MCr3HOvuQa5Sau4zAUkTXNLhaqkbcOtQiGX3Iare+6?=
 =?us-ascii?Q?cEb6mo9+PoBzCs0pJjx/hgAt3XTwCk9JHPTRnmshQkQm691TtoMeTXd7RCg9?=
 =?us-ascii?Q?TNr4QgMidwkdgzbI6rAaFIvsqmXYRgtVlYLOXJAbDpafJzsJad9xmgimB+fP?=
 =?us-ascii?Q?Ypl/JuznGFE/Z0uYBRo14f1Kl6Tqzzr8S6XvUUzCZGhsePGHHsMEuFeB9gEN?=
 =?us-ascii?Q?hCSUeylVrNsjrJta4F8GYvqB6VaFO4ghVMQex5PrDdAJ5U1yey2hX8g/f1o4?=
 =?us-ascii?Q?gAlcJKnOhUXCbDve6+UxAD1K8SjL41jgIqEXltCbJC3PG64V9GrA0d1cga7A?=
 =?us-ascii?Q?IGjAtYzgLG/Ij1IFHScax0pgM0z3UYzlyCz8tkjaPmOUTmvXqEBbs5mVXAX1?=
 =?us-ascii?Q?YhUDWKrRBLcCuBdTxuDgwWySwek8ieyFY6Xp1wu6RGhxDA3IfFHCJI+j0e5K?=
 =?us-ascii?Q?k7ESpdVXSScaCu2y+X04syPZxve4jgWwuuTR3Q0eITGMw2LifhdXmMtoc892?=
 =?us-ascii?Q?vT5YKMyzX6XWWXNpBTIiVC6Ao/BeOIztUr73uOSq86b9w2y6b2WXH+dhOnvf?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108a4011-9c18-42c1-7977-08da592a8e88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:20:54.2872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdF6tRlRmwXdsbrePGSaTOy+M87OyIUxgpSY3RoAfouiAWIxB1EO2MK2KZNCPm+8RXE86mbGNau6UijoojP/aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4337
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flooding of unregistered IP multicast has been broken (both to other
switch ports and to the CPU) since the ocelot driver introduction, and
up until commit 4cf35a2b627a ("net: mscc: ocelot: fix broken IP
multicast flooding"), a bug fix for commit 421741ea5672 ("net: mscc:
ocelot: offload bridge port flags to device") from v5.12.

The driver used to set PGID_MCIPV4 and PGID_MCIPV6 to the empty port
mask (0), which made unregistered IPv4/IPv6 multicast go nowhere, and
without ever modifying that port mask at runtime.

The expectation is that such packets are treated as broadcast, and
flooded according to the forwarding domain (to the CPU if the port is
standalone, or to the CPU and other bridged ports, if under a bridge).

Since the aforementioned commit, the limitation has been lifted by
responding to SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events emitted by the
bridge. As for host flooding, DSA synthesizes another call to
ocelot_port_bridge_flags() on the NPI port which ensures that the CPU
gets the unregistered multicast traffic it might need, for example for
smcroute to work between standalone ports.

But between v4.18 and v5.12, IP multicast flooding has remained unfixed.

Delete the inexplicable premature optimization of clearing PGID_MCIPV4
and PGID_MCIPV6 as part of the init sequence, and allow unregistered IP
multicast to be flooded freely according to the forwarding domain
established by PGID_SRC, by explicitly programming PGID_MCIPV4 and
PGID_MCIPV6 towards all physical ports plus the CPU port module.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Cc: stable@kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a06466ecca12..a55861ea4206 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1593,8 +1593,12 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_MC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.
-- 
2.25.1

