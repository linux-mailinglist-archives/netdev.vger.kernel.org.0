Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7F6029A4
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJRKsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJRKsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:48:42 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80125.outbound.protection.outlook.com [40.107.8.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37FBB517A;
        Tue, 18 Oct 2022 03:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlWXPTOutsdxFoKxHllIVHaLJTOAtoL+/0CPnovvaWPX4V/BJMyroIUBHiTHLcQVp/39y1YRg946WQEqYnF9TtqWFY7/LuP1XoMjy+PLiEwin/uyemTMCh+Z/9Yz68Fo+toYxex2h0lkHTd+PKJZLSLJm4xfmOjHWadcR0wx6YokXGFYnHWw60lK4IYdUMWQefGzBAaZCaI5RMN0p2G8PcNYX7l/TmKnLAJzkmSdeIck5/0Z/by+ZB/PLh2ycxr+GE0jUmb3KCFeySgrPz8BNK8F/1zHAwWuk7hzZMu2lhp6zCJEZCwZ9gLK2cLx0WSc/6vvts9qwEVMe0sgP3FTQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM9NW8YDOtEH6qz2offnGR10i1FqUyP+UCtHIgRBsLk=;
 b=elXcIFzi7zliwiEkZg/WQjmF+02G0cSSwi1753w7CLx2Xxl29VI7xHWZWlD9jkQDgxZSeoz5Mio7w7aHHRtVXejNHT5Ra79Of/67UpJiwI89DyeT4itQQp+qeJPSYd62b20mSoZf4B5OKEifvjA2LsgsnwVict1hDLOdqrSbBR0LJrtkfHwJy5qUP9mB+8DYzD+6ps1ewsGySiVmeqwPAzZckv3WAgnW7R1vdRmk9nJvCvYF87Kr94FZuPnlB5p1d8WMbAZuTNy4BbHT1oFMSNdK1UP8LKyaM8w5Hi3Ot0lViPfhpFw+QxtWWoKoAO3+94l/Qxn/cUbY2wMHPyDcuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=permerror (sender ip
 is 52.137.61.15) smtp.rcpttodomain=lunn.ch smtp.mailfrom=sma.de; dmarc=fail
 (p=quarantine sp=quarantine pct=100) action=quarantine header.from=sma.de;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM9NW8YDOtEH6qz2offnGR10i1FqUyP+UCtHIgRBsLk=;
 b=dUxIoIZLNEmd1lmKOPPMZGkHG+mMRHlsKE3GClPQnMpY/043rmrc5K0jxn8SGrK6rsbOVYhTMDSQKFfTpMQH2dPjgTp91RLwlw/QZBcf4aCUGxWnSLtreC6A/AiJ8EEzPIIIvpmKpWhKkIGovePRorHLVtHNRfRzziJdw8dcedI=
Received: from AM6PR04CA0002.eurprd04.prod.outlook.com (2603:10a6:20b:92::15)
 by DB9PR04MB8377.eurprd04.prod.outlook.com (2603:10a6:10:25c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 10:48:32 +0000
Received: from AM0EUR02FT021.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:92:cafe::96) by AM6PR04CA0002.outlook.office365.com
 (2603:10a6:20b:92::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29 via Frontend
 Transport; Tue, 18 Oct 2022 10:48:32 +0000
X-MS-Exchange-Authentication-Results: spf=permerror (sender IP is
 52.137.61.15) smtp.mailfrom=sma.de; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=sma.de;
Received-SPF: PermError (protection.outlook.com: domain of sma.de used an
 invalid SPF mechanism)
Received: from mailrelay01.sma.de (52.137.61.15) by
 AM0EUR02FT021.mail.protection.outlook.com (10.13.54.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 10:48:31 +0000
Received: from pc6687.sma.de (10.9.11.72) by azwewpexc-2.sma.de (172.26.34.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Oct 2022
 12:48:25 +0200
From:   Felix Riemann <svc.sw.rte.linux@sma.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Felix Riemann <felix.riemann@sma.de>
Subject: [PATCH net] net: phy: dp83822: disable MDI crossover status change interrupt
Date:   Tue, 18 Oct 2022 12:47:54 +0200
Message-ID: <20221018104755.30025-1-svc.sw.rte.linux@sma.de>
X-Mailer: git-send-email 2.35.3
Reply-To: Felix Riemann <felix.riemann@sma.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.9.11.72]
X-ClientProxiedBy: azwewpexc-1.sma.de (172.26.34.8) To azwewpexc-2.sma.de
 (172.26.34.10)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT021:EE_|DB9PR04MB8377:EE_
X-MS-Office365-Filtering-Correlation-Id: cc3951e3-fb96-441e-46c2-08dab0f64c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0tWn+07v5M8AwrVHe60JoP6R4oZiCIBb5n48eTMXKQ1px+rX+kEx+Rfh2CPhd71yFxsJYANIR/2Yo25fx5PtdHhuYf7NQ25rZ86IdZyhHpsUw2ase2p/D3W2r+He1ECWBk4Nrgf2pTgwonqMs+eLZaokygHY9z6YPgJOvmZ0T4ppE0wj2SSVYhnyliL1Cu/pO8zOyZS0MNGsZVEnqS/4cNdYqVC6YwVf/ZGlIOCwWS18WuTAk+n91GajKFpiFwl+dM0CZGie+yDDgAPe/M1FoCT5xKZPh7SFyWViRINrRDHWjAO2fC+gBHrm+ya+49xbxmXePm+ovDTKe84X66lt+DhaD38REVolxSfRQGOeV8P4GTqSdzRqGronHXLekfx0yAfVl1b9d+y61p5AGOsMG3rwxgI7zUKcntTwUEUBLGNxnPluqoV30KNWWbsAcx8lBItE1lESewCP2JT6NzcA6laHejjivVQQkrCTUKWmGOE+Xxd79+JHPP1RShbhYqZj4CNrZ98ot417z6abbcsBTH9E7p+/QFrgjK6l2yv7x6QtLDByNLtb4CaxAtNfgsHl4zbsGUzaE3RQEe9pxlvNnFVmS48s89BdHSMs8GJhnYxCnz9GcZRXz9gyPokNrxG/7enX8B5q6TmaqFGB1imt/jlTVtMYc7rNBkrNoSBMkzqxDHalDSjptQBwiDZQB967HszNPHJDxE/y6d3+IN/Rw8NP1fsRmnQ2aPmE6geE7zLqjPiarHsiFGAHVQYuoloGXHrSjYHhNykBXg7AsOJ3w==
X-Forefront-Antispam-Report: CIP:52.137.61.15;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay01.sma.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(36840700001)(46966006)(478600001)(70586007)(7696005)(6666004)(8676002)(4326008)(70206006)(103116003)(316002)(110136005)(36860700001)(54906003)(356005)(81166007)(82740400003)(186003)(2616005)(1076003)(16526019)(40480700001)(26005)(86362001)(83380400001)(82310400005)(336012)(426003)(36756003)(41300700001)(47076005)(8936002)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 10:48:31.4635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3951e3-fb96-441e-46c2-08dab0f64c4b
X-MS-Exchange-CrossTenant-Id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a059b96c-2829-4d11-8837-4cc1ff84735d;Ip=[52.137.61.15];Helo=[mailrelay01.sma.de]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT021.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8377
X-Spam-Status: No, score=1.7 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Riemann <felix.riemann@sma.de>

If the cable is disconnected the PHY seems to toggle between MDI and
MDI-X modes. With the MDI crossover status interrupt active this causes
roughly 10 interrupts per second.

As the crossover status isn't checked by the driver, the interrupt can
be disabled to reduce the interrupt load.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Felix Riemann <felix.riemann@sma.de>
---
 drivers/net/phy/dp83822.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 8549e0e356c9..b60db8b6f477 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -254,8 +254,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
 		if (!dp83822->fx_enabled)
-			misr_status |= DP83822_MDI_XOVER_INT_EN |
-				       DP83822_ANEG_ERR_INT_EN |
+			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
 		err = phy_write(phydev, MII_DP83822_MISR2, misr_status);
-- 
2.35.3

