Return-Path: <netdev+bounces-11453-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4EC73328E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE23D1C20F97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D92F18C11;
	Fri, 16 Jun 2023 13:53:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670AB107A0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:53:58 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C045230DE;
	Fri, 16 Jun 2023 06:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvrB7msLUnRYnETm+1tiE6NfMbThP2k+PIzL4iG2S7y8kE78eIYzA+klCPczq33NcRMHN1X030mKv073B8L6XU4bH59z6U6LEBrXjH8AiDQU9ggsvqbHCnPkJLoJuU12v7c6vituwYsz0nY+pL+HTji/m1qfCblWUjvOjqCkTfOjuBdvgUi8PzufrRX78QntLG8Km3KnLqOTbs7W/zYhCvHK4VmpoxDKj+Xpgvma+bkuRIP8QIGXYTgF+kFFoX+vyYkm7PwllIXGNmjq74g2f26Z/PPffe/Co1ue+W1NL/sfQUxdWkd308ynd9hl7B3Vwkk0BDMxJx+dnA9Wo5xeMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+MOs6zbLfUMkPBfiHhPYEl/fLg9qyap9exI1T8JwHI=;
 b=JIWxgkPXGqGF5UQNXJyTaeZf/tXvE2zStM7KQmRPpWO07k78q+MLX/5nmjOzVVRtoRX7SdLrx3MY6PtaNV3O6VLAk6JlYllJUQquVtOLNDBKwZIOqEppoggsBL8lAAOYRnoVW67SINlkCu+kBLGkHdqUzUZkSnbho7pclXrncrBJqKAYA62m5qH/Y6fXWoTMwAbAWSRJSHMF2hVE0ryvVoll0xEJE7vM/bdz8xVN6V46HrAUJ99AjJ+IFsaZxpP/ClFBLqX04x96xU6jDpZkTTShK3/gMiaw6ocKhqdKfEwC19Cj/Y9+Nyia8NjaJVbNM7GG+mOAYgzHWlSoWeSEjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+MOs6zbLfUMkPBfiHhPYEl/fLg9qyap9exI1T8JwHI=;
 b=JjVgZc+fGZ+MF0agXlmhgIwuo5zbERzxlAOCVmWdMkyAgLagq9zVchw3iL1xO5d6gjr2cTwmf1HBQi8NwgrM9r21ghQEGF5HFP2brmBxTZBw+kKEmqtYJMoTgaug0sKWyTjr0EXH1f69/H6L7Yj6ZBkoJ3iLeD6BmuOOQc6NewQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:53:53 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:53:53 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 00/14] Add TJA1120 support
Date: Fri, 16 Jun 2023 16:53:09 +0300
Message-Id: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: bd063f19-6720-4391-01e2-08db6e711f0b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eDa3XuFFNdBSs6AO9yIfT6rCpu2BGkl+jg77rKfgulMLEq9zoEM8KdpBfiLY58F6gP1F72lwuBCr6zvmxiPlRLvdxsLIhvN5zLQU5J82QC73FHVQ7qVrwSk38/RmEm/AZ/6K54Pl+8o4s+bQ/l9tOiA8zbks/T665KnLA+Pn4hM6+vdBb0FWLbCDjfp3+p+sE+GrBHQ1xWo1Fyzkx2oUhctF2rmZycHTJsDR5O1L1cgnT3zHXmZ81Pf2Xm/4/GBhfrqbseRd7VRDipMqqOEN0A/Bk7xD8rZt0fcxNGDsqW+iB4Z3YX1b8JVg32TkqKF2WqCx0s4wbXFM6HD6l5OY8S5RyiZUzaO7P9AgCHlCChB1GIofV4qz8gGxGwlGuwPThrFmxUrUgNnxTrs20BAQQs/gy9yoCOQLCQkWZK/tcndIwv8qmrZE10fBnUjUGGeR9LQUVMIbkZQ2U0B+oid4pDhKeiPaseR4Ckx9BWwabFp3OUCOB0a9rVxRx588Ts1XGBanVNihAX8S1yYI8il8onE27kMZ7fBcRHRM4lDUSSpIsAXnwELTddVYX+jssBJeTkk4qlgdVqstvMlhUHeK/U7mmV2bZmRSlwUrDM+ZcZBt3jbGdaLcgXt4fOrk1wIV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(66574015)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zhYcLpek6GOpiidNtLmJiDmCC4I+Qxz5+ojrsjXMDxxjlgSUaJ3rwgVGhDld?=
 =?us-ascii?Q?S1gC+X40Gq2z5B0RHB9GnneHuTknJ7sThr52jwq3o0TFHgRnIGRwj1jOeqeM?=
 =?us-ascii?Q?BgyPasQXHk2tnvVA9J1d0Y/poH/8efCClONsCHVsdZuJYHsxWq5t1jGJEPzw?=
 =?us-ascii?Q?U0zubz8pmqYVKTUbYBAMM4Lsnrdz1Tdei+pcAuCt4vpotlOoO1iLffUjATb6?=
 =?us-ascii?Q?bCdNH9NfD+kdr/FcAWmGgxfUNoIcJwuPnHcgJfUo2f/KGs8KYezbTfRWPnjV?=
 =?us-ascii?Q?ojctCAm0XkLd/AM96swvXxtyq7f6L/DSqrfLWjm0l9OsyZ3X7/X0zPCu9/1/?=
 =?us-ascii?Q?qZC9tYklEn70S8zb3aTvIZPJIpaICBnP0akXYF1tN8AskmFwGbC1Kx6KScVI?=
 =?us-ascii?Q?/GO8Uf2qpd03bRc0W1+mWg28KztyVmI4J5J7ggIBwVgw0v9Wik4SLvT+R58L?=
 =?us-ascii?Q?M95pv6ylrLVe39V/fwwpvSNOpFYJcOQwwGxCbYHb7rAZE/4ZTt6JxFJR2qc8?=
 =?us-ascii?Q?TKU5i30iTNVr8DafJSpjtm+Sa/3xSurQ8Vd1wChKyKMkM2MI3aUEZUrsqZvB?=
 =?us-ascii?Q?ezErgAdkPOgSXjjnVx+ylg6g/iUUltwvD4fuxQpnyj40/Byosc/46RzK7nBl?=
 =?us-ascii?Q?0wcDqYnU0jpUrQTlUk0kTiGlHNaww+ue8BBwnZvOW9X/boRI7Z67YPVTyhAp?=
 =?us-ascii?Q?5Atfi2JLHQia4mHgIP1OAb3Y77tv3uaIGxPvTVES8WK0coc0LbqF1Uoiw8iL?=
 =?us-ascii?Q?pYR0bLpltB9+4kd+VMUglmdpmWfGvd5si1vab7ZS6SiAF2mogxqik4jJAZ7E?=
 =?us-ascii?Q?9nZpPlj1t7ho1hyAB+J3P1ftCNntMmeAr37we1SYrlx+y70n0nhLDOuEgXRu?=
 =?us-ascii?Q?1h6JYfw2etOOBRKGS+bJ7ySQW2uK0KEoxAZJrc/qD4osoaf7SDPsmFbfAthW?=
 =?us-ascii?Q?/fMM9p2SC4JlJv48W8YOkJ067a6euj+GmfGEeNUhhXH8EA74iNECstTbtRAy?=
 =?us-ascii?Q?tK152e+ikdh1nYivInt8WwBYY8jFoFW0F9PcK1YoHlAuj6ba8WEyx84u7w7H?=
 =?us-ascii?Q?lo7C4C2I4RXC4y4EGku9H5v8TY1tn/aBr4wLDCb4b7YX3ZzVO5aNigqPhOav?=
 =?us-ascii?Q?lJkpZ6h6SOUJjGh+yvV6eNHRcUKHXjuYy1/8Ax/CAZHMyPg9BgZ2Uq9FWyo/?=
 =?us-ascii?Q?TUMa36Cr9CtDLoPXGiXoH4C45gpS+3CIodSnzQO/IVuEjk2ZE/ARV0VYcSpd?=
 =?us-ascii?Q?eUibiK3CQUfncKShVB75iNwQYaitw8CEr+6Wla3rkB7yC5bHideg7esTV3Ao?=
 =?us-ascii?Q?Oz6o42jmx50aM4L3vSP5JktP9D5Y+lHwyQWebGBhPxSD+KMn0LeFPczWBt86?=
 =?us-ascii?Q?dGgMIOoiFVrYButYOcwPe7GTitVlDGiEmn3B/82yo15qnR6t8hkEoowsv4On?=
 =?us-ascii?Q?wjZcTItd2GSPTU+XeMdAr52hEXIbDH0pIVCnZR4F/nf8aCxebos1JI245s4G?=
 =?us-ascii?Q?5J4FufFxDky0rk5Ib75MT2rDRyfriZwjSGpn3G1vyjN90vd753zZky9OKnOl?=
 =?us-ascii?Q?xDVyKplcAHZ7g7ca62clH1pE02ZMSAEIgkozLysZWuVEqhZl3AoOPxcqL8pY?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd063f19-6720-4391-01e2-08db6e711f0b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:53:53.6827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuxtPdERSMEYW6RVmcwYGKtiam7DNngNWLPmDxWnV89N6O7fQuCjidzRzXcyqvTCaEXhbGghbLngXvd3xLqBFJ7ej3TvwWWvcUtqmUo4/Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello everyone,

This patch series got bigger than I expected. It cleans up the
next-c45-tja11xx driver and adds support for the TJA1120(1000BaseT1
automotive phy).

Master/slave custom implementation was replaced with the generic
implementation (genphy_c45_config_aneg/genphy_c45_read_status).

The TJA1120 and TJA1103 are a bit different when it comes to the PTP
interface. The timestamp read procedure was changed, some addresses were
changed and some bits were moved from one register to another. Adding
TJA1120 support was tricky, and I tried not to duplicate the code. If
something looks too hacky to you, I am open to suggestions.

Cheers,
Radu P

Radu Pirea (NXP OSS) (14):
  net: phy: nxp-c45-tja11xx: fix the PTP interrupt enablig/disabling
  net: phy: nxp-c45-tja11xx: use phylib master/slave implementation
  net: phy: nxp-c45-tja11xx: remove RX BIST frame counters
  net: phy: nxp-c45-tja11xx: add *_reg_field functions
  net: phy: nxp-c45-tja11xx: prepare the ground for TJA1120
  net: phy: add 1000baseT1 to phy_basic_t1_features
  net: phy: nxp-c45-tja11xx: add TJA1120 support
  net: phy: nxp-c45-tja11xx: enable LTC sampling on both ext_ts edges
  net: phy: nxp-c45-tja11xx: read egress ts on TJA1120
  net: phy: nxp-c45-tja11xx: handle FUSA irq
  net: phy: nxp-c45-tja11xx: run cable test with the PHY in test mode
  net: phy: nxp-c45-tja11xx: read ext trig ts TJA1120
  net: phy: nxp-c45-tja11xx: reset PCS if the link goes down
  net: phy: nxp-c45-tja11xx: timestamp reading workaround for TJA1120

 drivers/net/phy/Kconfig           |    2 +-
 drivers/net/phy/nxp-c45-tja11xx.c | 1113 ++++++++++++++++++++++-------
 drivers/net/phy/phy_device.c      |    3 +-
 include/linux/phy.h               |    2 +-
 4 files changed, 846 insertions(+), 274 deletions(-)

-- 
2.34.1


