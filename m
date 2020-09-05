Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DAC25E65F
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgIEIXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:23:11 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:9778 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726372AbgIEIXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:23:09 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0858DDjE003218;
        Sat, 5 Sep 2020 01:23:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=RI252GdXCHoZpeEq5wOJ/Gwi/YLUDGZftGt/yBIhVAg=;
 b=TQ5f2bI31AIu1vy3bOiyjcMUHBJ3eSGrttT1QhvM1yurIP3paKBEiErkqDK4nmFUwYq9
 EBZcNo+KxVAxIkQyZmOnD3fVM2ILV4u7AAtzHHKw5FN0t5CEntg5KpMUEIgObIaiqNd8
 QxC69pYBlzZ2kSbcwipHWS+KG/OlRILxl4Z004PqYaDV7+1PacB8UuTagYMlgT6HdSqd
 dlY6azUUXuGDu5SDG0BcJLQCzfbF230+C4lHN7rHcJ3HaRGxqpGIRJEcIRC9ITqSVc+3
 65VjnfMedqiLbLFxCAQvuh4u376ROKZPZqbmrSxrylDaKRgdTbHFQtn2DbThv7GGwCsM ug== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-0014ca01.pphosted.com with ESMTP id 337kjy3p87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 05 Sep 2020 01:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bg/KCcrR09zxox/eg6/n5hm+jEODolB1AV2Kc2WNXPRkKrJR5TgQnyMPedgOp3hUHsLo3vSxapdbIYbDmxpHFbG0CmZ82sEjLCV4L6QJXe/CAU1xrK6K1cqVtrOJMWUJ31K1QRIFuahsT4qf7XFKHoXCTRkFKUZ6rFVaubGtqbIbv7nGrbb9kpN8mK/TSsNg2Efyy/zMow8T9tsk2OgnfgiD+kIY1gdqOdMVHWmiWUx+M9cmBEeMXmkTeWKu3CdDtxPP7qeVpfBEus8j0uDrsx+vd7RzJJHVqb85voZ5KcTyiGuknjjfd9ppejes64CNOmcGlDOrIsQrUUgr4WDU9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RI252GdXCHoZpeEq5wOJ/Gwi/YLUDGZftGt/yBIhVAg=;
 b=awQ/ctwEMR3FIEme+8kP+IUVaDUaEt/vfIp/egMIM2Rj9N+idKMr9ufYw+j+f+KZJ9axgiKBauzF3kUr/Qd/mix8jRtvIe32Kz3afXPXyAkj3eohdwTw4V8oSnft39Bg64UMiLJtuxlK801uRKEHjy1rwyMezWlW8JPjYsOch4mAPwi5lvKLHrO4l5TFo2FQBosieHNkuVnYgacBAeADrikXCof9hgk32uXQcq/+0VbnXTS7FfRlAPmywLnPpZLl6rq9l1dtBQ8xuN/AO7ZPMs90Wd2dbXu7MGoh9V3J33Li6oslGu2WyaF/0Bm2v2NUx0YSeGPBlaxCfaef184E0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=microchip.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RI252GdXCHoZpeEq5wOJ/Gwi/YLUDGZftGt/yBIhVAg=;
 b=1A0QD3woyWlXPVY0g6epUv7r4yPLdwxCvyRv2y9koN/pIADopakIQuA5OignVjRor4Z6dJ5RSO9bnsV668O+PioWmu+w7ZAfDiIsB2b938KeZIwkDqe9AOW+9BNMfiJPiZbW6Vzzypmjg3voA2Kha/Vv6c91lourw+ai/D/EoZM=
Received: from BN8PR16CA0021.namprd16.prod.outlook.com (2603:10b6:408:4c::34)
 by MN2PR07MB6911.namprd07.prod.outlook.com (2603:10b6:208:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Sat, 5 Sep
 2020 08:22:57 +0000
Received: from BN8NAM12FT026.eop-nam12.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::bd) by BN8PR16CA0021.outlook.office365.com
 (2603:10b6:408:4c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Sat, 5 Sep 2020 08:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 BN8NAM12FT026.mail.protection.outlook.com (10.13.182.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.8 via Frontend Transport; Sat, 5 Sep 2020 08:22:56 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 0858MJBi079722
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Sat, 5 Sep 2020 01:22:21 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sat, 5 Sep 2020 10:21:36 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 5 Sep 2020 10:21:36 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 0858LbGr030797;
        Sat, 5 Sep 2020 10:21:37 +0200
Received: (from pthombar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 0858LZDj030796;
        Sat, 5 Sep 2020 10:21:35 +0200
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <claudiu.beznea@microchip.com>, <antoine.tenart@bootlin.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>, Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH net] net: macb: fix for pause frame receive enable bit
Date:   Sat, 5 Sep 2020 10:21:33 +0200
Message-ID: <1599294093-30758-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9873739a-2066-4fd2-3bec-08d85174e49c
X-MS-TrafficTypeDiagnostic: MN2PR07MB6911:
X-Microsoft-Antispam-PRVS: <MN2PR07MB6911CC079A00B1B21DC0CA75C12A0@MN2PR07MB6911.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5V4NtTUtX+IchA8VspEt+1G7dNDd8DIuDmL0CrpZUNpXHD5vOFeYk7WuPw3mQltgTI1H/8h0FWDKJ4EtvsN/WLuw/YknsSQEQmdgcwOYQNhvDF5/2h8ijgbiWcKQnMDCxBBHLSCwNPJJLKgZseGptSUnkAUY3MZZCkmE/GuduZqo4N8JpDue2oXWRlQI9/gk+NOH4BfBtUJdE2L7iVcPa7KeO9F+S0cyw0fn2o8fPL1EcgCu10trrWFNelUlmPF2+qhZsx9wWw84057rdGc2LKVshqIXftzc6jzwY+Eht9l5xiXT3Iur7QnrdMUhIgeL56E9pFAQv0xm6dH0MRCPVy/0Mtl7Itf6Wf7r/GF8Ei6q3pfJozxX0K2i1/InQeMzr/A5HLQIye7hxLtMMp7H3e+PTI4xPPcbpHYMHcZsSYI=
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(36092001)(46966005)(4744005)(86362001)(4326008)(83380400001)(36756003)(478600001)(2906002)(356005)(2616005)(82740400003)(70206006)(26005)(70586007)(5660300002)(8676002)(81166007)(426003)(110136005)(82310400003)(186003)(47076004)(316002)(8936002)(42186006)(54906003)(107886003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2020 08:22:56.4936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9873739a-2066-4fd2-3bec-08d85174e49c
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT026.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6911
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-05_03:2020-09-04,2020-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1011 mlxlogscore=684 bulkscore=0
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009050079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PAE bit of NCFGR register, when set, pauses transmission
if a non-zero 802.3 classic pause frame is received.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6761f40..9179f7b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -647,8 +647,7 @@ static void macb_mac_link_up(struct phylink_config *config,
 				ctrl |= GEM_BIT(GBE);
 		}
 
-		/* We do not support MLO_PAUSE_RX yet */
-		if (tx_pause)
+		if (rx_pause)
 			ctrl |= MACB_BIT(PAE);
 
 		macb_set_tx_clk(bp->tx_clk, speed, ndev);
-- 
1.7.1

