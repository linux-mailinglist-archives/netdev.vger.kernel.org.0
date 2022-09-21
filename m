Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E145BFF04
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiIUNgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiIUNg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:36:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BCA7675E;
        Wed, 21 Sep 2022 06:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEHSE+XmFnPux4YUYjacuT5Q0qI3p0cY+TnOxcgD0KTVuPmOVfoE90j3C4Lj14QXqKi1ZpDVL8HajedW0g7UVHJSfJqEHHpJiYJOkJV19E0tUHuHt9/AKi44S2TC/4bG3FCuZBxPeedD3VX04T2/hmBSwbepO5cz9A7HoF/3iny6ZDhwO3AlHPFL1ayPMpAJ3gzwwz4A3t+/L6GLNZYp4g4oGEcka0YsXW3muWeQGGHZj4+w47KuhLrrzOP3vf5B+7QWpXbxXKrluWocRZMnH+0ycB9jK51phb9JfVSNfTRMVS5Y03GOjsCil2HJzVGhZM/3tX4wtnYCfIrDdqxxyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NU4CuKkdpk1jiVSddf5kT1bGQMoUBT+mbBbS53oPc6g=;
 b=a+bxSmJh5POPY0ELCR+ZwfG2bGFFSCZ63SVWHwlwdxcmYD7VC+5xJWMq3ta++IqcwgmiQCoQ8lmE0Od0BiaxhsoZh21zkFWr4sSUOf/Te4VZ10PLrbz7DV9Tn/Q/O+VEV7kDD5c0xwlJBzdhIG+U9W4N1ZKQBUJbx9tIowEhFXVPYkoian99op8ZHu4wR79tObG1L33YEcFKNacgXDZNWW7EA2sVmSis9BQcKf9x6p2GzieaRT0mJs/Cm1+p6aeRkBiTuBzlNUn718Wr78bfIeBahmMokc/hlmv+oLtpblomSbXRBzh9wN4bG0ckYYRbYnnMoulhyQ4bWkKx/4y1sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU4CuKkdpk1jiVSddf5kT1bGQMoUBT+mbBbS53oPc6g=;
 b=F5mnRopJjfq7f0Nl7oEsKjwI+bUSOUPxFdeTuQ8VcebYW+RjvpR9p4mwYjvlHv0HtW+1+nHdYzyickWJuaMlfHGiH7cXM7wncZ9g3uo1S7vEMV33bIRkXbxpNiMtwv7GqsznyI4rNmKzFjDCpwpl5ubVWZC1Yz5AfF3DfczgJjA=
Received: from BN9PR03CA0627.namprd03.prod.outlook.com (2603:10b6:408:106::32)
 by SA0PR02MB7194.namprd02.prod.outlook.com (2603:10b6:806:d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Wed, 21 Sep
 2022 13:36:26 +0000
Received: from BN1NAM02FT005.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::9a) by BN9PR03CA0627.outlook.office365.com
 (2603:10b6:408:106::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Wed, 21 Sep 2022 13:36:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT005.mail.protection.outlook.com (10.13.2.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Wed, 21 Sep 2022 13:36:24 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 21 Sep 2022 06:36:24 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Wed, 21 Sep 2022 06:36:24 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 linux@armlinux.org.uk,
 robert.hancock@calian.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=52903 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oazto-0004Qi-1o; Wed, 21 Sep 2022 06:36:24 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 472311054C9; Wed, 21 Sep 2022 19:06:23 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <robert.hancock@calian.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@amd.com>, Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH net] net: macb: Fix ZynqMP SGMII non-wakeup source resume failure
Date:   Wed, 21 Sep 2022 19:06:10 +0530
Message-ID: <1663767370-11089-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1NAM02FT005:EE_|SA0PR02MB7194:EE_
X-MS-Office365-Filtering-Correlation-Id: 36075d79-4d80-4284-61f2-08da9bd64776
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GYdrmnp/853pFHzHKezTMW8urPd3O/dUCtPk/67ch2XDcAGJAk8aCQfxGf0mmUaX4+jpzKlJ588uFzP3YfQvkIjFzbN88hPC1UBgQWMsM/SczcMHw3hajX8AFwTWrHGQNPzgsBZ0hY66g7RFxvkiOcCUA8XcvjJio89CgFVakNHUiSU6Z24LpL4seeFX0HoewINgWz87j0EhPF3w/nPAZTVxcQNSSJssg7XEifzYL15sxfRu2/ex0NsbvsnUkzfSZjOCJWG4/IV9wz7ujjFyZuDZUQRiQgmn2ZzJ8VKsW4tgizlDY/zSVIOMvVZ07W1a+lwMuxI+p5C/qXOqClftwzXEhvjoCqjUiQ4TJHijH/RR0JptlufHz+RXR5Ki7nrSO6O0uisPaiA6bYu6VEELqvLnlRRRsgQJjw+Wk4teZ9sO8LcfYwBTSMTxbRzTQsUcmZgW2GGP3KnCZspGg+a/SIhqtQ3HgnJUK+KeI7FMOwW51pHW3mO7zP2L5rJDPzK40VHm5mfVkOpK/ZfFpCgRnUA230sxLmvyp9oYLnQ2YaEcrBvhmRnRRRRn1Y+HzJZ/zzj2VJBZ8IKo67TUkQaRRAhvajMEM6m5YmUn5l8ZRfWlVV9h4VwBZ153GDB5whvBJ2p23N9U2GTqHBrYVb2iaRPTKKYzRCXhLEOeywv5rKrvJE1kR1KbeybDcUDpcftFgZOhr9D6RQD+cw+5Z19xteOXxIqSimWh3vi4194dxHGpt2hP/1AU+HHc8kmIFO0Q/mRCcP2KZQMWDPELiY8eYqgv3QYJBXiDm4OcaRX78A=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(82740400003)(47076005)(83380400001)(36756003)(2906002)(356005)(63370400001)(54906003)(70206006)(70586007)(478600001)(6666004)(4326008)(8676002)(110136005)(82310400005)(186003)(8936002)(5660300002)(42186006)(83170400001)(2616005)(40460700003)(7416002)(336012)(42882007)(41300700001)(26005)(7636003)(6266002)(316002)(36860700001)(40480700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 13:36:24.9031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36075d79-4d80-4284-61f2-08da9bd64776
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT005.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7194
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When GEM is in SGMII mode and disabled as a wakeup source, the power
management controller can power down the entire full power domain(FPD)
if none of the FPD devices are in use.

Incase of FPD off, there are below ethernet link up issues on non-wakeup
suspend/resume. To fix it add phy_exit() in suspend and phy_init() in the
resume path which reinitializes PS GTR SGMII lanes.

$ echo +20 > /sys/class/rtc/rtc0/wakealarm
$ echo mem > /sys/power/state

After resume:

$ ifconfig eth0 up
xilinx-psgtr fd400000.phy: lane 0 (type 10, protocol 5): PLL lock timeout
phy phy-fd400000.phy.0: phy poweron failed --> -110
xilinx-psgtr fd400000.phy: lane 0 (type 10, protocol 5): PLL lock timeout
SIOCSIFFLAGS: Connection timed out
phy phy-fd400000.phy.0: phy poweron failed --> -110

Fixes: 8b73fa3ae02b ("net: macb: Added ZynqMP-specific initialization")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66c7d08d376a..a2897549f9c4 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5109,6 +5109,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	if (!(bp->wol & MACB_WOL_ENABLED)) {
 		rtnl_lock();
 		phylink_stop(bp->phylink);
+		phy_exit(bp->sgmii_phy);
 		rtnl_unlock();
 		spin_lock_irqsave(&bp->lock, flags);
 		macb_reset_hw(bp);
@@ -5198,6 +5199,9 @@ static int __maybe_unused macb_resume(struct device *dev)
 	macb_set_rx_mode(netdev);
 	macb_restore_features(bp);
 	rtnl_lock();
+	if (!device_may_wakeup(&bp->dev->dev))
+		phy_init(bp->sgmii_phy);
+
 	phylink_start(bp->phylink);
 	rtnl_unlock();
 
-- 
2.25.1

