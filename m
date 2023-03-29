Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04306CF3DA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjC2T6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjC2T63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:58:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D917A2D4D;
        Wed, 29 Mar 2023 12:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEY0imW0BQHs0nz4woiTz3Y9GevJechg44GBRlAyei++RUhz/pFb8hlnJp3kkQrJlnghZJ17j+xPUXsT/solzCnYyAeEZtjAnI4M6ZxnlPy81Q/Ulw2ysxdvcwT1cyqPvqmpI0yH4LB796bXiYrl56Pi0pQqD1MFLDrC0sGYOMlJ1Bp2AodivSswcs8/XHRtRNtNSKX06aG4O0W+jogYyyLXr84s+xDbQZO9gEHJLSsKrgsXso+wClf0PAvvYJr8CKuUIp2CbxYz79iDSHYxE74SGhuYvS030kSuK6D2FVlxVCMtimmpyiKuQmYF6cyCS4ozacL4WZbR/Q1lt9mcWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNFGl7TALMtvWy3apPkbvlgPa76IuL44/SWQbOr3jtU=;
 b=jxRcWPCiEHVihAvMVbPHMa6A9v7DwTRm578VHkiUHxAfaLugQGQ/bfLm7Q18dT6iFSFxtNu7++seNFxDbx0UBcc754/Km/A2cFaefCC1Te5oQ6P2clI6isLVb9gabpXUa8oeoiP4/ywvALQS1e/EuVhj/iJgE0b9Ka/Y4earOj93v+dd0IQ0iZNraaRfmhs6VA9kt5nL8T5QjBFT7RujKKTbRPhca8qlYsSg9QZBDlRRGMD9l2edG5sBDDNfuJbtSwke1xcZNoRqU2mGNivPafEKhRKs5itg+7gk62uFX2fp7441vxNL1i7jl1p+IqsaDQBGfIqGcc31U36gTg/htw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nbd.name smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNFGl7TALMtvWy3apPkbvlgPa76IuL44/SWQbOr3jtU=;
 b=p6pB9pIOqhDV+XyLqtyzWNt8JeAFoskMlnN5XJvOG30fk0KLtTCy6dSNgK24qvGonONX/iFpPlgi0SzDtn3CkFArfViUTgR/Dd+RoczEI8fNbWnQshlx+ReHGYZCtoDrgnvIYcc8pm91/hBOLFpzuS55yjZdN/mzCwPbytajsDI=
Received: from BN9PR03CA0254.namprd03.prod.outlook.com (2603:10b6:408:ff::19)
 by CY8PR12MB7415.namprd12.prod.outlook.com (2603:10b6:930:5d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Wed, 29 Mar
 2023 19:58:19 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::2a) by BN9PR03CA0254.outlook.office365.com
 (2603:10b6:408:ff::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Wed, 29 Mar 2023 19:58:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Wed, 29 Mar 2023 19:58:16 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 29 Mar
 2023 14:58:14 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <nbd@nbd.name>, <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Anson Tsao <anson.tsao@amd.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] wifi: mt76: mt7921e: Set memory space enable in PCI_COMMAND if unset
Date:   Wed, 29 Mar 2023 14:57:58 -0500
Message-ID: <20230329195758.7384-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|CY8PR12MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 410c2fd0-d708-465c-1a83-08db308ff000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ELgMX/NcJQIZfKFBrNswTUnIyYmZfxwDwwizQozyGDOdC4Gd+Mdq7RrByjbahnyK6ngVPt71gC+Y8jhODZnlawliwU6OmwCMUpAshRDFaZA70pgfY6CFQMZtUCfOHb6Gy32Jxy608+wzi0sfnWIAtljNCh6Rz63FHtybzaL5TLc166Z0XRITzLuROJUD3e9q1tzicYW9cRJ0Up4zvZMe4R5Acc0wBMZvpQzMnKqOsECacnBCHcPEkGJdlyMMEt9fbpkZdld79prY9kvA/bP4xyFs3R2cxCWZCzJFZhac1nVTqGBLU/75UbJ0JY+9Wvbztx4/k6Shwn7AUuQV1RlklguMi/Vg5DnLtIQkHgYMEs17D4QraKOJuIfXUblEd4QLYQFqBi7/RK9SPZnmGr/S2jMJk6J/MUA023vr3/Q0XE3sDMcBWhpvoVldPsjq/nI041FrSBzlysyxKTZZ0Qv3OLGDf8g3qbyjLJSKjA6vROix4joG4qOlF6qdBTRoVjhdBIQ/wuC+Ecg+eEIB5lTzUCN8DUrINvWZvrG2Xg/1bb3j3ZCoTTWDw4fqKnLyRqV9CnV4Hgu7aV/HYM3A3TarMZuLZuQzdhErfUHITZA/2zrOH8NbwOfUjj6jnFGvPtXr49QkfLLCx0ETZa7b/SO0yW5Bp1fDNp/9Rv2bZXEc6mTKjFw6KKf3XcsByjXeTT+d9BqQnbjcfTy+ZZyz8NXM7E9/De1GnlG8H/PVK4c0WJ8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(8936002)(47076005)(2906002)(336012)(83380400001)(426003)(2616005)(41300700001)(86362001)(36860700001)(36756003)(40460700003)(82740400003)(5660300002)(81166007)(356005)(40480700001)(966005)(478600001)(7696005)(8676002)(54906003)(70206006)(70586007)(4326008)(7416002)(16526019)(44832011)(6666004)(186003)(82310400005)(1076003)(26005)(316002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 19:58:16.7583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 410c2fd0-d708-465c-1a83-08db308ff000
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7415
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Original patch was submitted ~3 weeks ago with no comments.
Link: https://lore.kernel.org/all/20230310170002.200-1-mario.limonciello@amd.com/
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index cb72ded37256..aa1a427b16c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -263,6 +263,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	struct mt76_dev *mdev;
 	u8 features;
 	int ret;
+	u16 cmd;
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
@@ -272,6 +273,11 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
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

