Return-Path: <netdev+bounces-10454-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC10872E90D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 612212811DC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E7E2DBDD;
	Tue, 13 Jun 2023 17:09:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6E333E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:09:24 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2079.outbound.protection.outlook.com [40.107.105.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3E41709;
	Tue, 13 Jun 2023 10:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+/iqaCzkFChAwqpt9fQNuYAEbF72TS7JQUwT8BUwoS0PiD/7pAg7AjXjLoR90m5LojLYLSqSR6PjlmppmREj6aZSfFnQrd06ar/9ASQ+7wltM1Mh4t1ortaqERtDkJSe2Q88LKJ4kw+frB+zK0W4n9z6X+jLFC7Sr53kr2YQBln5ZPvaT9DZIn1OHyrpIwnWeCtQ/A4sUHvLJZm/fngaO0NVj/fxfxccRAiYbYLo+74F8MObZDmaFGylbN1C1QbqhKwlbObyWhVSli3xRP+psHlP0Cd1jWk7ZoJ594pGOIIYLQKG4m+nsZu76YsDeMIfLeFTusqXvQIXJAmLujBmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Et2EL1rvz1tImEnOBsXTR28LSiAMYNdMQ7JSBIEhjzw=;
 b=kFIA+4nPXopsP1hVAbrAOoXIrlbxXaEqGa+m0et0XCJ2ruK+RZn0R72E5TL567Yeq5Q7NsfmZxgsWdWHcFIFPQPCHRzgIfJOdPNb3p3yzR4ZNyDhMKJ5MG2u1M8IV3GWJGIIpm8LRs+byFQ0F3X/yZBXU5y6ZRyzeScWsRoDgo7tCu3aFyL4RjsNrFmhnrSxiNCUUBeKuyxcO2CqZTyAnV80/mrWVwsGtiP/1MNHuZSkQdcVSSarHQt5XYTc2xlYh5RFUUgqlYZyOooxIBhMnmQVmaJTwJ5qFbBe/JT4Wa3MJlaF2FVYuSn/oegnBTSriJXwG+gPyKBSBSB/8RS+mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et2EL1rvz1tImEnOBsXTR28LSiAMYNdMQ7JSBIEhjzw=;
 b=qommHrb7Pln94uJBdDPc9li3X02TmmbKvv+qVwTiiNOYjJyoxJlayakVE6wQW512A5SR7GmmaeUrv6AmJwhX1J+TbPPKbrqPX+Wl80MX0w0GX2MVUICL7tZ/WUKFL5Nm1scWv67ULxe5D82Dha/SHltZQz+ItefbLjCsCK/9mLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7548.eurprd04.prod.outlook.com (2603:10a6:10:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Tue, 13 Jun
 2023 17:09:20 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 17:09:19 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: felix: fix taprio guard band overflow at 10Mbps with jumbo frames
Date: Tue, 13 Jun 2023 20:09:07 +0300
Message-Id: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:208::36)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d88fd25-618d-4e24-e5fc-08db6c30ed02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mKklGwW6FCoV2jMYdu1S9ir1gA+ZnHdNEp6UlxaLHPAc+vrsdYLTmSWxhMSTPYuGt6SUpqwS/AyrxnJfbm8rYVds6/Jl55g05r2FKlq/d4xKdU3C4FlHPKGIRS2X4aALypNNBKToMJPt2undSBCOp/bvbZoeoMXcxKy/K9K86bmEvjo4yDHbv07eqsmd1XfzpgwZwjvOkuSvOcXuTttNnyLDbSIWO/sHPhiiu7ROVUX710OH9JSjyLRzr59/zwey595am3aOOyyxWrXQwbpobNfV0Zot/q4aOzP3HJ3l0l1NZ1CfR9wWF91zUJsanVXmz8ERUOKFtHbWVhYdLW8gXaKp4tZS9fDpRqyl4697l5Kdnm2bE4pyy0kgZgygFlHCS9TVqtFWS/8kQ9u7sPx8Ab9Cu/WrSEDEIz+Cw73O5a1CPczPzUxhVRJ0MiaVxxyZNYYOnLbSmVY5po5zkwUtCISF1/tOmgi/B52HmbgM5FOxmpOiyJcZO92WwvVdIv0AtW7OWlS5hmiMUbFR4l0egR4BGCzmkfrOs+oesIyHefQL1wnEs52IjLG54Bx0eNNss7Vg5jaYzlpUhR2vPndPUVirkZEuPob4TK6SQW+CfCR7WId1VUgDf70Ds7cpXCgF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(7416002)(83380400001)(36756003)(6666004)(54906003)(478600001)(38350700002)(8936002)(5660300002)(316002)(41300700001)(66556008)(66476007)(66946007)(86362001)(6916009)(4326008)(8676002)(38100700002)(6486002)(52116002)(2906002)(44832011)(1076003)(186003)(26005)(6506007)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vuDA0wiVh3+AVIp6E4OIYTpK6bs01/CiwkUCpwmAn3bclDieEsTRCCK0Cp4T?=
 =?us-ascii?Q?s2tJl7CgGacHFkLrsY/5687OdXyHrd0H/xy2yjxKAtyeYlRor2ORUoXfdKb7?=
 =?us-ascii?Q?USDIUaAMJu6cRtpfJ9PLT5ojEd3aJGtooVpUejHl3jJQw1d2aWZ/uLMDO2rI?=
 =?us-ascii?Q?/P5nQ3P8rJHxBtYebzr66JUnwwpVu5TcC80Ynn1c1vDaz5MCkLL9untw4Hgx?=
 =?us-ascii?Q?o+v/GE9xHFPLNzr9XHnV91w/V0lowoCHWkJrS4LVbKDIPHo7SRvqc+ahpDV3?=
 =?us-ascii?Q?GUNxHLDSeLPjBJDW//SpksN0H4IRplHGYA2L3tV89T14Oz5XlVlyM7exJFH2?=
 =?us-ascii?Q?f/RPJPO6wpkt0D1//Xvj6K5HC5r2pIafKt93jRmVpWHjstXUleMDH6gArY0b?=
 =?us-ascii?Q?oQomMyJlkctCBwjCz1JNlu3Uv0df87vPOf5jNzTYkiOoyv2Ifujmeas15Pxd?=
 =?us-ascii?Q?f5XGl/tKFnuRYkdFCYx13hiVl2jc6tTgWQ+yVGGE/gDmS204wsRSkeHLEkk5?=
 =?us-ascii?Q?RoCoWP5UJrEzK9YnfjlQUe8Kumv2nB26HU5BPRcN6QD3MgnBFwnqI4nFREw/?=
 =?us-ascii?Q?gxHDw+BxB5OZ1uvIRFNsoQ45Q/AOYCjiq+4yxmGtvifHF9d4tvxt6M9VDJHZ?=
 =?us-ascii?Q?GoSDjtHXzeruz/KJA6IoH4ntUsvOP/65fX9sRRIZFavkwNZ7637MnBxyxEXN?=
 =?us-ascii?Q?wqkGv8dRofs3T1UBh0rlPItEsrfrrSjumb1qRWCaakdn0GZjbqWs2fxIp0yV?=
 =?us-ascii?Q?CjcPgcvcGj7k48Rk0w4UAeV7dsV130t3LxPQilpQTLZO7d3LMXhrzmimoW6Q?=
 =?us-ascii?Q?MWAO+Iucz022W+HPEPjnhwJE0qkYZyc7wT2RU6euPcAKo5V8oEMnCpxp2E19?=
 =?us-ascii?Q?sQ0zjpEMSfctYQOw7P4q4OFLup5FLRWK4VfYbuDsoMk+jWfF1gaERN9IQUL9?=
 =?us-ascii?Q?xjYGEgIeaDhOfQ1mynvOvL986kQm7dkM/6xZSjXlBhIiTChq4UCjnz+pYqCx?=
 =?us-ascii?Q?xt4FSjRpb+/0mcfCPlyU2JwdO2aTb+2Y3yQANfP/GGMi6qyEHbP4WFs8PKsh?=
 =?us-ascii?Q?c9mRaQuYeHL/boBU/atDuOCFSG8uTWF/5EL1Q28hcCly1otuq6fU/PqnMyeJ?=
 =?us-ascii?Q?Xmfi1MMTVb6PLrYLNZNHJyRwB8Lxeqf/uttFieAt5Sj273dhVjy7E+aOOZoJ?=
 =?us-ascii?Q?SoQmRcsyUH759bvJd410pjxYR5vQHU1bg2nqeWh7QmTmWFlxym61XezVXO/D?=
 =?us-ascii?Q?H7qq0CSWpCG7dT44b6FarIx+D7jx3payC1jrghm4R+iCOQGBZ38zRXtzb6cd?=
 =?us-ascii?Q?q/0ClVSKSMOUBz6VWBYtP/oUQD/rnStnDs+wrz2KF9WpHNJRzbXN3SUqjQRI?=
 =?us-ascii?Q?nxpMa90p+JrmCu/8x5UcKX8RjoaAiW+5zXPRDt1YW9r18eZx9waFIdozSVie?=
 =?us-ascii?Q?DvXFXt6i3XFFmvemN6L+cUwiEe1s97R0YObm4cHwbNP4+f12Bjmyh/Q91UcG?=
 =?us-ascii?Q?c2coCq0/gsjyNpQtx9j2h1ZLNc463+9u9kriQEvD+mXur07Zh9BT0Oz38eW9?=
 =?us-ascii?Q?IeOaB0QO3Q37LX7e70UPJ3TdbGGzsxejLcDpIfT0PBaZgbYC68ht2/Z3Pb76?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d88fd25-618d-4e24-e5fc-08db6c30ed02
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:09:19.5660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxGuWj92NxWVmP0nC3IkXGgLoH30Vta6RNs5R26OY+RuinQLDeyBcfJDNt0BMTH0xYpsMvAPVF0OGQv5uwssnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7548
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The DEV_MAC_MAXLEN_CFG register contains a 16-bit value - up to 65535.
Plus 2 * VLAN_HLEN (4), that is up to 65543.

The picos_per_byte variable is the largest when "speed" is lowest -
SPEED_10 = 10. In that case it is (1000000L * 8) / 10 = 800000.

Their product - 52434400000 - exceeds 32 bits, which is a problem,
because apparently, a multiplication between two 32-bit factors is
evaluated as 32-bit before being assigned to a 64-bit variable.
In fact it's a problem for any MTU value larger than 5368.

Cast one of the factors of the multiplication to u64 to force the
multiplication to take place on 64 bits.

Issue found by Coverity.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 903532ea9fa4..bb39fedd46c7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1251,7 +1251,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 	/* Consider the standard Ethernet overhead of 8 octets preamble+SFD,
 	 * 4 octets FCS, 12 octets IFG.
 	 */
-	needed_bit_time_ps = (maxlen + 24) * picos_per_byte;
+	needed_bit_time_ps = (u64)(maxlen + 24) * picos_per_byte;
 
 	dev_dbg(ocelot->dev,
 		"port %d: max frame size %d needs %llu ps at speed %d\n",
-- 
2.34.1


