Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1346E4FF3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjDQSLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDQSLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:11:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3663510D;
        Mon, 17 Apr 2023 11:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2ZAyJa9MqgQ8jtWD9QQbsCDGQBtJNW/bL5akaYDVGFPP/xBW8Gj4cndTtVLuMWYR7VL9jn5Ad5+4g8W0TX+vJR/Xbrvd0mgAIPxuCX93at+Uu3UWp8peXviTnpAm8jud120a0pVZptIOwuq5ucvyHm1mOkCUm+5+VHrvPsK1aqCPtn1MfDPSl9pW6vJdaYB20mzLmZkLR2pCfnzdD48/bUAQYUsqNt7eaQFd20XfvdpJ1l++W09eQI+RC1Cv/nkZafBK8u/RQrCtI7Vov+dcfUcg8MQEIGvzo0VRoKZjFczloj8BGJOyp6R9qKsYHeJfI+S6GvSgQXJf0uy8Q7vOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVPFlkCWGbx2AUI+Aq7ZHWQcyKexNy/PYpt15ANVKgY=;
 b=YZyjcUdVaU1lO35LxbLVmgDGHt02STwOem/74Erlr3APqQ1SkawtP0OxDEa5O1yhnoaa4OEAA+QrFW8BoyXlQlBPWoNOtABJV84zR7Sl0SdDv4Fs2QhB4szXb72z1FDZO+WP9uzfVR8VGIn/OGjodSeR+1AQYwpeeGlJlrdQv8mqGAA8RX38GXTQ6MOEbu1UGGUiSLUhASVDI0ie9pBd1rkg/viBlROgWhv7prNjoVhhJ136IWxbYq0w66oa2Vd1Uz2MQyYMhslHQn330r5jpVEXrHh7juqdqAiz+7iPCJIHU2jbLNBbGZb3+xL+LNCOe+XCE6bTw3QIscsyQmKO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nbd.name smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVPFlkCWGbx2AUI+Aq7ZHWQcyKexNy/PYpt15ANVKgY=;
 b=CauRnS297/MsSbyUdYfLz1GKKNJ7jfb3USuXTKTuMje08elu6ERoJx54HVaHoGnDcDhiUCKeCPyZ3eI9Vcl5CXqIOGoNAxqesJkLFg8eB0p/x9EHbSx8aTmA7VHjU5Zy8EHMKJCKAwIFZ24vOKZT+7yzQW8WZHJ5EGT64qUBeLs=
Received: from MW4PR03CA0322.namprd03.prod.outlook.com (2603:10b6:303:dd::27)
 by MW3PR12MB4489.namprd12.prod.outlook.com (2603:10b6:303:5e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 18:11:45 +0000
Received: from CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::82) by MW4PR03CA0322.outlook.office365.com
 (2603:10b6:303:dd::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 18:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT083.mail.protection.outlook.com (10.13.174.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Mon, 17 Apr 2023 18:11:44 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 13:11:42 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
CC:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Anson Tsao <anson.tsao@amd.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH v2] wifi: mt76: mt7921e: Set memory space enable in PCI_COMMAND if unset
Date:   Mon, 17 Apr 2023 13:11:29 -0500
Message-ID: <20230417181130.4445-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT083:EE_|MW3PR12MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: da242e3e-5fea-4985-a135-08db3f6f33f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hy+lxpGBwatzEc7B96xE2tY976FX0sSfLaIYkYvGqVayNTLZVMsqbLW0ruYBw8UWPod9bTlYUUFdUVdCRJIiG3Qrq7c6axwhBSvthyWGNf8mzr5JrsPS1xVljk2vzYDaBCU/Yr/TvqZPmCaGGJCy6afweVlWGxyQBDrheMVgIr/cNF9s+EXmzsab2fbaVFCcZUh9QaGIZWcmRzVRn7Sjkr3dXgq3YpieC9L0DnzoQE72rT3h7eb6VpFwzJEHmPby1Jww2OuIHX2VSMa1l5jmIAeV4BnR93ax6EqoW0XR+FI1jgxADLC0Dliundw/M83qD5vwAS/CdBgmMdCQBm9n1WxZyVKFMo0+OtFtMExZvy64RE6G1zkAX+Rt0aIdymR7SpU51xBwsH+5k0VGTsk8h6/2dwqDT5jyQrUHVn3tzV8J1rW5VTRwN/Y7y2RZx+k6Vyb+/mlipWOAzZSWvQNk3jpMcaAndaUcvWBMkQJGqqduDfxE9zwHjVn6vNoJRrSrIj1XAEB8zXV2CHtgMvWftE5vWPOXMfWoCRRhmBjoa4BbQ2ZEMrDuEOtdf5iQhKYWNzp+7EXLKHF1Dx+R2szm+toQ8OR0WEJkNsROJYlTEpxq12bfgb+/x7YH7Drg7KsAw+bXssbZUe6HwZJQlnXgG+bWxXhQFDGmdIAbzr/QqBiI9PJlVaOtL6dO20uoLwV8SOVvHgotQXekq/XG7Zuy1Y4AFCVoi3CSEfoWZvIpRPA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(46966006)(36840700001)(54906003)(110136005)(40480700001)(6666004)(478600001)(7696005)(356005)(81166007)(316002)(83380400001)(41300700001)(82740400003)(426003)(336012)(47076005)(4326008)(2616005)(36860700001)(186003)(16526019)(26005)(1076003)(70586007)(70206006)(5660300002)(44832011)(7416002)(2906002)(8936002)(8676002)(40460700003)(86362001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 18:11:44.6887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da242e3e-5fea-4985-a135-08db3f6f33f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4489
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Acked-by: Sean Wang <sean.wang@mediatek.com>
---
v1->v2:
 * Pick up tag from Sean
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 5c23c827abe47..41be108e1d5a1 100644
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
2.25.1

