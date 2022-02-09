Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A994AE8CE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiBIFGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356241AbiBIEdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:33:52 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68990C061577
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 20:33:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icOAuGnxqu6Nx29pMHWJ0ongajtSAu1DeCY9dBRqF+A95HAcwhobNfupGcFnUEg62zacmaYU76szMis3FutXaD2EIjYqh3HQCiG3mljf+SzHxOgxo6lAEr6PFPGuYoyYjqyXUo5MSxFAF49AXAPHXu8x6YSG580Lg6zbyLiU0Dinr5Pp5IqDvxYsfzIWcU28qlCsRtw+o/wsIq+lPj0I7ewwD2HixmuPJk4cX8vo92mpnNWuquaFJKU0OE1IXZuCYNmX0zoWEhpTKd/eGz1211r8qbzKtYq+JQM5pFTkenRUbtt2HsDEAsq2veao3bhl2rm+OypgRbElHp7uUXEDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woy3w/K6cH0ICn6bQfkwMgzqxFGqs9aRBmMq9FXi2zg=;
 b=FV0rF6QTe36wfIEQhQktOaavXMbNUwHYbnULkT11IdAgBy/iF6Y9JiLlhLxi9SoakRqTf3We1Ir+TJfMzhQlP1PDXEzN+3W0XHWI8AvfRA1k5gITLXndlo0t+/HqU5amEqYh0b+OBxeDqgxjPzVuP2T7SBiiYuPz1cGUj7j6Mrfybv6HtZ+0X/hAxHSAem7BXCxf7q+lgFY4ws+6FuaO31fFfARTDmE4OmwX9r97v72kMGlL2qOXXBW4Jr47W7hJyc6j7zyplVA5XTV+P/jILYn+AVkec1leaSDJ4HyaQDSN6BX+CRo0WEkvofZGlI8T2Za25DwQqfHD7NHVNoUjrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woy3w/K6cH0ICn6bQfkwMgzqxFGqs9aRBmMq9FXi2zg=;
 b=oBjWLnGrKXgzPZa+SxvDK1euXlVyOqI6k1aaXHZP5ei0MVByhle+6z3Nm8zJTujjbYcfyesYR7PB/AQR04ukFWs+8sd5KacLWQtXvSrdH9CK7g6X4K0m95tFIps8c8JQhzfGx2o2cLVHmbUCKxm0DzSOEDRtV/O7hnIRACyyeow=
Received: from DS7PR03CA0338.namprd03.prod.outlook.com (2603:10b6:8:55::31) by
 BYAPR12MB3493.namprd12.prod.outlook.com (2603:10b6:a03:dd::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Wed, 9 Feb 2022 04:33:48 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::6b) by DS7PR03CA0338.outlook.office365.com
 (2603:10b6:8:55::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 9 Feb 2022 04:33:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 04:33:48 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Feb
 2022 22:33:45 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Raju.Rangoju@amd.com>, Selwin Sebastian <Selwin.Sebastian@amd.com>
Subject: [PATCH net] net: amd-xgbe: disable interrupts during pci removal
Date:   Wed, 9 Feb 2022 10:02:01 +0530
Message-ID: <20220209043201.1365811-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16f5efac-7f80-47a9-e0a9-08d9eb855d93
X-MS-TrafficTypeDiagnostic: BYAPR12MB3493:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB34931287B2BCB23295FFBF8E952E9@BYAPR12MB3493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U1gcDMp2wkPHNQCYAminGdW8lMwE2zFS/pQPvZW+udM6xAQJUPTEZMuIfo2dxTQX4GR4Ex3r9bMhXFXTs82WWaA+QStIBC43vX4qUv4++4luuKf1GPeeij7r566VnWhYjfg+Z86EzTaFPpn1TZsZdNu4Xf5x6Yacb53scdYYTha48LyIkYioT2d4jYv3D3pPgFgsaqAKRsDnK9koY7Msb1O0/ku+jHO0O1VZl4N0F3kAoQf2ESJQ9ay7WC7zcscU8OxP1HcJVxDUb2SR48zwea4Ev/RGc5C3NwNf5TIcSMTfKNpcDtw83HczDdxPIkx7uovRcrpBzhaWwX96/a4o9D76aoItMutWOFbcCC8pyvfukXbjmKSID+pRc5VTMOkh7U1HHrgdRldRP4vbK7iz5aEswka97RVTSOZrjPl5ly1586+tl1qT11MOqyQCQcoOmEYihtiv8+gF5woaOtmTfzdPM2LlaVQFJim5wG0+lrHS5b06SjMSFbcxFhHS3lod7Slyk30P7OoFO//NfcQa0CHg3th4h5HOorxd/NnPNBmtJz4G+LE/qEoIo72K9mEa99yfBwD2XVzT6ksKJZbsHepnJ3MImczHrIqdmF5N+C0SVw01+Y920F1VY0sna6xWTKcMz8B6oHFsGQsoBOnu2MIYUfeL3M0R3u0nkbL7B5MeftNEwd8pKtlFwwq6z7XDkISuW0p98TgaN9NGTw4D9g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(2906002)(36860700001)(508600001)(86362001)(6666004)(356005)(7696005)(47076005)(4326008)(8936002)(82310400004)(316002)(5660300002)(36756003)(2616005)(70586007)(70206006)(8676002)(81166007)(336012)(4744005)(83380400001)(186003)(1076003)(426003)(110136005)(54906003)(16526019)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 04:33:48.1848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f5efac-7f80-47a9-e0a9-08d9eb855d93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware interrupts are enabled during the pci probe, however,
they are not disabled during pci removal.

Disable all hardware interrupts during pci removal to avoid any
issues.

Fixes: e75377404726 ("amd-xgbe: Update PCI support to use new IRQ functions")
Suggested-by: Selwin Sebastian <Selwin.Sebastian@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index efdcf484a510..2af3da4b2d05 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -425,6 +425,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdata->pcidev);
 
+	/* Disable all interrupts in the hardware */
+	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
+
 	xgbe_free_pdata(pdata);
 }
 
-- 
2.25.1

