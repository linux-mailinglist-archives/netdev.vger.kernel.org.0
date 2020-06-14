Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035091F8777
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgFNHTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:19:24 -0400
Received: from mail-eopbgr60115.outbound.protection.outlook.com ([40.107.6.115]:40615
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725265AbgFNHTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:19:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmCpI9vm6IW22dDmBRSGd6qCOoEA/18/VDwfgm36lvI9z8L1laZkBM6oANT2vFqtIsdayjhJ32Bdf343WapR5U4NwEW30htSq1kv1y5LSZi9a4ybtscdlutaNwe/2MGwYX/qant+H/n0PfooedRtWkrrxYTaKniQnkboIM7cRMRGGvW1FfCAeM0MIozEiIzjH0kSd3K6OOop6yHNZtAbLV/vJXCM61K1umL7RjeAVIwHaiu81aZKg8Y8M7c45VgW1vs99JREbmveExnboDF9+awvRXav2FKU47aYW9LIhmsU9pG8CbA9MqWn1Ktw4injB5VlA1XfUXm3bmBByYm6Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luhKaR0Rr6Q91px8TryCXCMKM9Ic4djJkTq5oYpRMHI=;
 b=hWq3tkL29sFRYtqktISc9zE4jJAwjxoxC7f9YvvtZ7B2RV5WB22isUSaIZVboUXwL45lqMsw17z93u55QTMd7vXHwLeHGAjD4ktRhANjBalWbNjDCydstv9sEPMNwsVSF6SNYEP3MUU3XRjeWFJuajHPqqernLEU5FhcciTQNR7chf9Lu6PAdnD6zQAKqh8vvvgl4q4Ev9n2RuEbH83nwW0ZAlzGkGsRXRLnuw0lBcxoTGEovivZ2t3bHMbEvs4KXwtP/AoqJStAu5pZMPUHnghjQy49aYr0w/dr2c98F8l/YdXiujkfC97k2e4JWAeqcHvLwnrKhatQ/92eay5twg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luhKaR0Rr6Q91px8TryCXCMKM9Ic4djJkTq5oYpRMHI=;
 b=T4tn83yVtcLmejxKqLe4gEaIP5X6dXXLfViPiIQRAo1ZUPj22TrnDDtlEyIUnuyxOFUvP1jSIk5oTu3LF3XZUS9FDjvSJ371HLd6/SmQCxd8wa++5SHCGIjgVeQsof9g4le2pakz+5ovLxyEwYBOCIbg9Q2qhPIVdtqBnNfuGpI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13) by VI1PR0501MB2608.eurprd05.prod.outlook.com
 (2603:10a6:800:65::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Sun, 14 Jun
 2020 07:19:19 +0000
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5]) by VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5%6]) with mapi id 15.20.3088.025; Sun, 14 Jun 2020
 07:19:19 +0000
Date:   Sun, 14 Jun 2020 09:19:17 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, gregory.clement@bootlin.com,
        maxime.chevallier@bootlin.com, thomas.petazzoni@bootlin.com,
        miquel.raynal@bootlin.com, mw@semihalf.com, lorenzo@kernel.org,
        technoboy85@gmail.com
Subject: [PATCH 1/1] mvpp2: ethtool rxtx stats fix
Message-ID: <20200614071917.k46e3wvumqp6bj3x@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR07CA0145.eurprd07.prod.outlook.com
 (2603:10a6:207:8::31) To VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (149.172.153.214) by AM3PR07CA0145.eurprd07.prod.outlook.com (2603:10a6:207:8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.9 via Frontend Transport; Sun, 14 Jun 2020 07:19:18 +0000
X-Originating-IP: [149.172.153.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3833d51-7caa-4c45-ccb7-08d81033411b
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2608:
X-Microsoft-Antispam-PRVS: <VI1PR0501MB26084517A59BA19E70A4BE33EF9F0@VI1PR0501MB2608.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04347F8039
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNL/fTDrJVSz0FY07gZHuTeMznMAGdUOGSh3oVwRxK85rgHh3JfdXmkSTPTrLoT2dkd+xgnz8k2a4pZhrNQsAnRrjTNucju9KR9lfFz22Z5UOAVEj5dgO7k0YOJ0WY3IuwlIuFbwrlrlt1qpe9ZMVG3ZGo910Fn8arB8Nm0ZgBSfD1M5REHMYnwFTxVnH2WeP0FhANsE2/ZO0cL9ZOAjn5WSwMq7tqx8yp7c+ztjOxKbkk/hC96VbvA3+Yv+Qrjw1m4SnCsT1PG0OYW5BRcdgd9Mlm3rD/ixJzOShTZm2qKZcnM6r91/mdpV+yp/ZLLAhFvJLQ2hV7YP27dNrERfMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2800.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39830400003)(396003)(136003)(346002)(55016002)(6916009)(83380400001)(9686003)(66556008)(86362001)(66946007)(66476007)(2906002)(4326008)(5660300002)(956004)(52116002)(7696005)(316002)(44832011)(16526019)(508600001)(26005)(186003)(8936002)(8676002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GXcpjI7tIA/tLvvVrp9izXc5ds1FNQrPX1s8A5qrbE9tLeyRMIPjI6Jpmpt+dZZ7LALJ+yqd5KWMXzigmBLDoxngvL+u5TLUC3pTA18p70sUZuTsDP7X77/j7j0l5L/yY2qPfkpz/drlUHXpanNWaytiMzMdHQi21LrGkMT0mje9RW74DtJWGYIThamLdN+IhUngvSSFevviA+SyIK9/aqaKd2qxElWmxvzRd2IR8xo6uXRumPjSUBmYqiole3u0cSgt8zbmUpb5PZW7fxQULWqCwy0VHQ1miIb6IiZgpROvaUtLE2PnICPKQhjOUWWVeJO4AL6labZMNYmGWZ6wvHdh1Ochc7X5iaUL3OMHfb4es6i+gP9L487zPUU1UmqwRLB1ypQ37GelqcDEqODzxVgvqlXeorbd5NsQmsXDWhcyWTwWiZBvpt0mBYdATVY1TDURgk/CcMz9idadQuGsvoDFqmooVXUkt75xLh5vQIItd+yz/AsLTFLYHJTTVseX
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d3833d51-7caa-4c45-ccb7-08d81033411b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2020 07:19:19.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zhmnRQF+Uw0N0usJGimwPcY7lMfcUwRKvUN+/EY+jUgdXjSvt9DlkQsH7B284BwmrIxh/3U5rLL2MLje24k8wn1kvVBt68eyK1MQwho/AI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool rx and tx queue statistics are reporting wrong values.
Fix reading out the correct ones.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b5dad2ec650..5d4ec95be869 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1544,7 +1544,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->ntxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_txq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      MVPP22_CTRS_TX_CTR(port->id, i),
+						      MVPP22_CTRS_TX_CTR(port->id, q),
 						      mvpp2_ethtool_txq_regs[i].offset);
 
 	/* Rxqs are numbered from 0 from the user standpoint, but not from the
@@ -1553,7 +1553,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->nrxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_rxq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      port->first_rxq + i,
+						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
 }
 
-- 
2.20.1

