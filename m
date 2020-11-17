Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054F72B5ED9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgKQMIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:08:46 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:4576
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgKQMIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 07:08:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MR3OksGE+iS13BRwIddkuWQOPl6cBNCGFCTYpbT+CAPR1m2CrLeAiuh7SexTqpyTvLa6RfApVuOGhTr3wXazwNVTamuA1ppKaF0O7bCf9dhKkkf8MUsjZnJI6PCXuBj+Cy/g2EmFCdLrfDonsw96MPTr5nK1JN4dKPBdA7b4jWWYRsV7xuj7kQ3GlxZhjnv+qSxWvtL16YK7eCDvNGCBy1SCC3pxMQdBoJ0foBGi5QOOvKXhANTNAZ5eGq/sUnJctuYad5Qp86dyjX0CYI+y4Y0wE+vZdM4dWS8fzmEUOaGey4x65n4erN7pNS5Et6N3s54pC2VUJR/gFNhLoheaXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPlJUK4TPJkN6hQ3N92zr++dT/2zCXtL72BxYRNjg3I=;
 b=hpiMpW1RSZwFcnsay3uTTwuk6FPeVBJXuwEgqqBWASxEznW+EPwx8+wr+THwWyFx2NOnTDqXEjP9QocM9e3PcnPN+IAwX1uRD1pXimtxBg+sr6uHp0wzEJrUTIyGfkieFyilIkWyvF67Dg3w/A/PRCOJpfk8cykksXA8BHIRwPbmcVI7BwkcOHb5C7PdmJcjuxlAp3uyadx4SR5qZk3qG3a/fep0Tgb76akhd8kXwU/UcftB1+G9nvh0FnYV1uErMeOuOLuC6NaTL47f0IApTYRM4etCx6QoiXPJMWN/PH40PHI2fIARr2O48h5AHjaZpbg5NVwev5IwjW0WASZNwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPlJUK4TPJkN6hQ3N92zr++dT/2zCXtL72BxYRNjg3I=;
 b=T/caYAeuKCmsmLhm5fWLOXOWf9T5uTIBYMKwZSF/PR851CRQOMwQPtQGsKpjRNAqbyfBo/DHu6yKxNeFAMXZ9EFwH50yMK6J8MYX6egwxppYISt5OEVrG3nyCOHomwZGfs7LaK2zqPD8u68fKrr0z1rzShtALuL7AN2L2S2CZj8=
Received: from DM6PR06CA0023.namprd06.prod.outlook.com (2603:10b6:5:120::36)
 by DM6PR02MB6329.namprd02.prod.outlook.com (2603:10b6:5:1d4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 17 Nov
 2020 12:08:37 +0000
Received: from CY1NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::14) by DM6PR06CA0023.outlook.office365.com
 (2603:10b6:5:120::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend
 Transport; Tue, 17 Nov 2020 12:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 CY1NAM02FT054.mail.protection.outlook.com (10.152.74.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3564.22 via Frontend Transport; Tue, 17 Nov 2020 12:08:36 +0000
Received: from xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 17 Nov 2020 04:08:02 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Tue, 17 Nov 2020 04:08:02 -0800
Envelope-to: git@xilinx.com,
 michal.simek@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 mchehab+samsung@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 nicolas.ferre@microchip.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=41946 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1kezmC-0003wG-Un; Tue, 17 Nov 2020 04:08:01 -0800
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 1E6CF121216; Tue, 17 Nov 2020 17:38:00 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <michal.simek@xilinx.com>,
        <mchehab+samsung@kernel.org>, <gregkh@linuxfoundation.org>,
        <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2] net: emaclite: Add error handling for of_address_ and _mdio_setup functions
Date:   Tue, 17 Nov 2020 17:37:57 +0530
Message-ID: <1605614877-5670-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a492b3-74a0-4a22-0f28-08d88af182ee
X-MS-TrafficTypeDiagnostic: DM6PR02MB6329:
X-Microsoft-Antispam-PRVS: <DM6PR02MB63296D6C2A0293675C20CAACC7E20@DM6PR02MB6329.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vUv/YrfE37l5MWEhEcL7jSe5tkvNaQcvn3D8cS/VtHAdyMW+l4courUmF7bkiaLcRrvI/PbQMJWTIVrkALY+lmWiwNDFskRVp0uJj0mgq9eIqkA+ZO2JLDk6NGZXIcstMtUcDjKzVrzBPhPvLzNhfw/WZIasnMUJNlLCSaxVm+3UUq6TaA47qCh5ag/VumtsS5pyuGaLKgumRxjBdwJJ15wwBTzXS0BoCvMagGBOknxzOwBaDFZanQkT07uWCObpFF0AZEeAISHHUs9wlqZfyBQKUn5YZcL3QJqRSvStPhmt6xgjxkrcY7g7yL0CWHcCBFLNSn7zOeE4aZON2jgzIrINBibTmbYAeLeT/2BXIeivYHYmhMjgDfxAbPubX/nyQfsHsVs54tJb1BTik8edcC3aLdPRC0ELi5IeJ4wc0o=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(46966005)(82740400003)(47076004)(7636003)(6266002)(54906003)(110136005)(356005)(478600001)(70586007)(70206006)(82310400003)(2616005)(426003)(26005)(336012)(36756003)(2906002)(6666004)(42186006)(4326008)(83380400001)(316002)(36906005)(8936002)(8676002)(5660300002)(107886003)(186003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 12:08:36.0016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a492b3-74a0-4a22-0f28-08d88af182ee
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: CY1NAM02FT054.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

Add ret variable, condition to check the return value and error
path for the of_address_to_resource() function. It also adds error
handling for mdio setup and decrement refcount of phy node.

Addresses-Coverity: Event check_return value.
Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Changes for v2:

- Change subject_prefix to target net tree.
- Add error handling for mdio_setup and remove phy_read changes.
  Error checking of phy_read will be added along with phy_write
  in a followup patch. Document the changes in commit description.
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5bcc523..4e0005164785 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -820,7 +820,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 {
 	struct mii_bus *bus;
-	int rc;
+	int rc, ret;
 	struct resource res;
 	struct device_node *np = of_get_parent(lp->phy_node);
 	struct device_node *npp;
@@ -834,7 +834,12 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	}
 	npp = of_get_parent(np);
 
-	of_address_to_resource(npp, 0, &res);
+	ret = of_address_to_resource(npp, 0, &res);
+	if (ret) {
+		dev_err(dev, "%s resource error!\n",
+			dev->of_node->full_name);
+		return ret;
+	}
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
 		phydev = of_phy_find_device(lp->phy_node);
@@ -1173,7 +1178,11 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	xemaclite_update_address(lp, ndev->dev_addr);
 
 	lp->phy_node = of_parse_phandle(ofdev->dev.of_node, "phy-handle", 0);
-	xemaclite_mdio_setup(lp, &ofdev->dev);
+	rc = xemaclite_mdio_setup(lp, &ofdev->dev);
+	if (rc) {
+		dev_warn(dev, "error registering MDIO bus: %d\n", rc);
+		goto error;
+	}
 
 	dev_info(dev, "MAC address is now %pM\n", ndev->dev_addr);
 
@@ -1197,6 +1206,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	return 0;
 
 error:
+	of_node_put(lp->phy_node);
 	free_netdev(ndev);
 	return rc;
 }
-- 
2.7.4

