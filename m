Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07E6B4DE9
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCJRDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCJRCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:02:37 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82BF74DF1;
        Fri, 10 Mar 2023 09:00:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLAm42iBomwJYfdwrReG9V9CfbNMxC3x6wtkhFoa1tU4SfwJjtoKVZLwPrpiWuRO1/YIFtQimvWQ0tC3WRVseNC3/fu2C7yy8ueuvd9w6UwLrG837h2TUlY/g4XZtPWJzGiT6zg5tFtmtzSg8tPgTrz2xtbxFB21h0ErBKS5G5mPmNnKt01a+K6Je83hXrJFfBWsVwr67fOK6sefOyXzG27Ux5/QOYst/m3pCepbU1HIU7795mIfgUkDZ7ey/a3NUqoYTnpZ32nBrRy8+v6/hFQWVwYlu4Nw/zZ12YY2byR1q+/hJaiHX1WhUfJtmhlCr/kLjRppRPJq64+hGTen+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdlGZkMRPNoVnTmOdWDP6rWo7x6dipoNOzIkEhAeL38=;
 b=T4WJ4l4/vkFrpK8nfdq8k9N4lGXMBnClWWv8orywQMjtlH82P+q6yzRrE6zVPpyoWIZMlC0Oz3c1xr048qdhVvDukeFPHHyzAsLc4Dk+AYNawGivaGpAQ315UT+O+3pH7XdHvTNtkt8YZKYVbr1+giZ5s3aVCdEZxG3ipOLUZlhl54CvqlStoebJ30AzRX0UULBciblOkABzoeQYUPmKPkoo/oUyPY57RivHLj1Qo+7jTje7H31DMQqCWiHbZzpszsH1Uo05FhuuFATZ56e8bfZGFQj/dlGJyP85ogr//L4CRE5Yr6nEnqvZ8WeIQnnXqWBtwhWsY0MFxk+s7u9Fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdlGZkMRPNoVnTmOdWDP6rWo7x6dipoNOzIkEhAeL38=;
 b=1f3PVEJa3vJ1FDU0RZLCF1Hm7RqOhvhpweon9KxSYTECxZUOhmz+YLtv4OGYIl15mTMysASYsS4IW7mdnxwiLW4jg+dy/9o8KLxoa8Y+N+o/yycquI3FREpVAk/lQnaAwdBPouaH+xzOonTtxoRAZlekbQEcv6xFP+2Pvb/aAAg=
Received: from BLAPR03CA0054.namprd03.prod.outlook.com (2603:10b6:208:32d::29)
 by DS0PR12MB7629.namprd12.prod.outlook.com (2603:10b6:8:13e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 17:00:13 +0000
Received: from BL02EPF00010207.namprd05.prod.outlook.com
 (2603:10b6:208:32d:cafe::79) by BLAPR03CA0054.outlook.office365.com
 (2603:10b6:208:32d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 17:00:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010207.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Fri, 10 Mar 2023 17:00:13 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:00:11 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Anson Tsao <anson.tsao@amd.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: mt76: mt7921e: Set memory space enable in PCI_COMMAND if unset
Date:   Fri, 10 Mar 2023 11:00:02 -0600
Message-ID: <20230310170002.200-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010207:EE_|DS0PR12MB7629:EE_
X-MS-Office365-Filtering-Correlation-Id: e78a3a8c-93cd-4e33-2cc0-08db2188ea3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GM2HJFmz1qMUy4OU9gS5zEbg7uEHKCHzDPAQQjEX/HadNml37zMvj/ODtpkYXaJ7gEdVDC0NhMsPuMI26pU+FU/jFoe3NS037/0zLW6sVsinZO3bybLX/kZ53suIG5skoe+xrr2tyjx1us1zX52t263ak31Cr5w7tgPhGrON2CpOD+V8+9ENkoCvL6zkCkdBgCkj9TfB1MmSLskuY9Rmcwv3ny+7VQ5+EQRqm0ct5CcYAPYN3s7ZprrXNpvAhaC3kfUWnFT7SWB4tcgz7UoGUPjbBjcdlkRecdy6SI7FXRHhE7Ppgwt+Cw2eZJv6Z5n0+3QHG4scFS0Vhb8ZeXLiP6cyioK03Px2r4Icgb5srOjy8dh6lC7Lt9vyrGUd9WnSiAn39tzqcHkbc4gFmBbJCJcQd0DMWV1ST2ZB4w3oSKQ1X7GIeFSvRqr2hkycew3AEzqP8Ckp0WWNDTszm8R/HKZKUJwwPClC08QhKoq5Dj4LCNDIo4EgpdCSVSO2FpLMEalw/8O+eKQxbmSG5vR7roCGrOeMYySl8gso3Bj8L62bJNbe3uVesEkMZZ2gNLDZ1Ok+BqTclOYlJI4w1Z9myApcorBlQcGDnfCA3njX4N+mYOxn1BJ9Aq3coimoiEr0NywcqueGdKJK32lhgmiahPziK1ZbnEycsU7yIkFr0+xph9fuKusy0nfOzBdadbaLd18XYXb61QKAaAuNa0XPHd3z0wNjaGxeAoDhGAkA1xM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(2906002)(81166007)(82740400003)(83380400001)(36756003)(40460700003)(7416002)(5660300002)(44832011)(70206006)(70586007)(40480700001)(8936002)(356005)(8676002)(4326008)(6916009)(316002)(54906003)(41300700001)(86362001)(36860700001)(7696005)(478600001)(426003)(82310400005)(47076005)(2616005)(336012)(186003)(1076003)(16526019)(6666004)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:00:13.1734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e78a3a8c-93cd-4e33-2cc0-08db2188ea3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the BIOS has been configured for Fast Boot, systems with mt7921e
have non-functional wifi.  Turning on Fast boot caused both bus master
enable and memory space enable bits in PCI_COMMAND not to get configured.

The mt7921 driver already sets bus master enable, but explicitly check
and set memory access enable as well to fix this problem.

Tested-by: Anson Tsao <anson.tsao@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 8a53d8f286db..24a2aafa6e2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -256,6 +256,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	struct mt7921_dev *dev;
 	struct mt76_dev *mdev;
 	int ret;
+	u16 cmd;
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
@@ -265,6 +266,11 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if (!(cmd & PCI_COMMAND_MEMORY)) {
+		cmd |= PCI_COMMAND_MEMORY;
+		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	}
 	pci_set_master(pdev);
 
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
-- 
2.34.1

