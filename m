Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38691359725
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbhDIIHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:30 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:6432
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232452AbhDIIH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=np8xV2BNdshHvFqr5i4nLon1yZVEYoX9fvP6Yga9Ndz6PLrqS9dyg/5WBKOamBrbS2oEH1U5b3AMYttFY47TeAB0doOdyOwV+gRT+yO7+Erd24ADS/Fz/P1ryzldZZ5qKDjuXoHcNGvKz8foSMOGlg0IhmF1czzVWucRQQy9mkS0J9OO+Lkxvzcyxp5ey0zxppWsZ35WmJCeVBBPRYvb9x0oYixk+Mf0N16cjYNYoZ1p1tHDp9PhHOi3iV4tfARToqw4j9Ya36quSW/890mJDRL2sVFsAkv7+csK95jCu54i8kQhhhUT+gAFReZ2n5tjUkdX+ua3jFMDdUzdGo9nBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HHmgDlVK9ldPQmcHYFuRM6C5HFjcsNN9HVQmjzSAxE=;
 b=LA/EKYUvPlX8jBssVx4xCaFuw9bTVOBvZ50il+hz2ZO+ErmstkfmfprFMlJVlwY2NJcP3lse+PLB5izMYqFYKBD+INljG5YX8ZqFRBCZmJOa9QlYnzL433mB583kSZPSZgplUt7ovHaZiRqNGtgiEMtDTbleGnPr3lyBUBbgl0UZ4n/LUMDQVhkACuhNdPU0+hCVcWgxN4P/M6/mVUkwKxHnHjzwmfELB2busfUzCsJ4OhltT7E0svswL7vOtElBdv70QtvkUJPLsZF6Ge2aqc2/5L9r9eejddeXnK+gyetEuGdC5ndOmvijy1JW/cJ5pXmmxSdSsq6g/0FUrZ4ILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HHmgDlVK9ldPQmcHYFuRM6C5HFjcsNN9HVQmjzSAxE=;
 b=QQvPa5og/U997Hn2fklWgYlNseQpy4hUWutn95Rh2fgRiy28Sl9p56dsvDk5+U11WBEQfR3Km8CY1lmwp4JNRm3lKm1oBTDi0AkQur9He3qW0+PCmzpJYyK5oi7OIYORI459ieII8FfdeBxw3WvW5+QOy21ABRhGZsB6uZsPhv21q3kFPvyd96ABfXtxXlOjLaM3WRDYmWdCPZgzHA3M6xZvkOWS4TsXL1Lenekhvy69LOuawc12y4cU48zmq7u46hFKxgFEyOQvr/Q6/w+mTrlSDUoKB9Mip8VaQSZC0eAHgweDAM0MNaPiTCteCiDNXuqeCkV/sriUc5Dw6EmVWQ==
Received: from BN9PR03CA0471.namprd03.prod.outlook.com (2603:10b6:408:139::26)
 by DM6PR12MB4928.namprd12.prod.outlook.com (2603:10b6:5:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 9 Apr
 2021 08:07:13 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::b7) by BN9PR03CA0471.outlook.office365.com
 (2603:10b6:408:139::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:12 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:10 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 7/8] phy: sfp: add netlink SFP support to generic SFP code
Date:   Fri, 9 Apr 2021 11:06:40 +0300
Message-ID: <1617955601-21055-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76507215-16d2-41f3-d345-08d8fb2e7b95
X-MS-TrafficTypeDiagnostic: DM6PR12MB4928:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4928BA8AB2CBC4D0205840C5D4739@DM6PR12MB4928.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tVXm5T9G3O1NVdFrvQyR5W6OVFQj2lQVWKv7zHNVpPzblXUzlyC79VQUle5nvS3lBzJPYTxX4AKGE4IGwrlE9+mDnowed3C/gqZ5ISg0iBRu1iINHN+3ofG6xRwbXW8M1OYfF2r0ZBtUt4nKBV+Nht+Se/BIe++4urHE6vFW91R/Q+/gG9sGc8LmgQRyF6x9WJ4kSmu5+8WatmIyA5DWKSRglsiFeI6RqT83If6MEPCDsDl2nhjiJWOHkVywKpvGRnzQ5ebEX67qN0SqxIB5hFCtzgKsqV6skl5eHiBiKvXizXnEeLgkt4eWkv90RkIaPmezKMAMrqNsYSoqnTUcnsU1amHRLySwoklL596L8mS0mAPafMltLer1hfvSv9CgvtwZFjPfm8AQCZVxM8ayP3h6G2r8BDTlK1tCAYLKfoC7cfUL2jGiMTrSY64GrMWfiGVuvyz6a513bllBdwqLzMRmi6gAxGOrCU4h6s4IFSGVJUJ12hq3Vm44nMpOYyIyRbcJwMKs4k+lfDI1dmIbH86W/BP0iyIRo5AfGBKqz9Az7ltIK/paNBK7AW8JX93A5Cgc2wO7aBZVdlQA/KmLXo9q5ddzB0xisVcBBApee+h1UopDBx5EqjceVeLXVV++QlTryiuzHQv+nNpLky75QWiV4CX/JAONCkysJ2j+kkpMaXn/o8TaD1O0XmEWkQpa
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(46966006)(36840700001)(36756003)(26005)(82310400003)(186003)(86362001)(8676002)(478600001)(83380400001)(4326008)(54906003)(36860700001)(110136005)(8936002)(70206006)(6666004)(82740400003)(356005)(5660300002)(336012)(426003)(2906002)(7636003)(36906005)(7696005)(47076005)(107886003)(2616005)(70586007)(316002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:13.1680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76507215-16d2-41f3-d345-08d8fb2e7b95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4928
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The new netlink API for reading SFP data requires a new op to be
implemented. The idea of the new netlink SFP code is that userspace is
responsible to parsing the EEPROM data and requesting pages, rather
than have the kernel decide what pages are interesting and returning
them. This allows greater flexibility for newer formats.

Currently the generic SFP code only supports simple SFPs. Allow i2c
address 0x50 and 0x51 to be accessed with page and bank must always be
0. This interface will later be extended when for example QSFP support
is added.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
 drivers/net/phy/sfp.c     | 25 +++++++++++++++++++++++++
 drivers/net/phy/sfp.h     |  3 +++
 include/linux/sfp.h       | 10 ++++++++++
 4 files changed, 58 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 2e11176c6b94..e61de66e973b 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -555,6 +555,26 @@ int sfp_get_module_eeprom(struct sfp_bus *bus, struct ethtool_eeprom *ee,
 }
 EXPORT_SYMBOL_GPL(sfp_get_module_eeprom);
 
+/**
+ * sfp_get_module_eeprom_by_page() - Read a page from the SFP module EEPROM
+ * @bus: a pointer to the &struct sfp_bus structure for the sfp module
+ * @page: a &struct ethtool_module_eeprom
+ * @extack: extack for reporting problems
+ *
+ * Read an EEPROM page as specified by the supplied @page. See the
+ * documentation for &struct ethtool_module_eeprom for the page to be read.
+ *
+ * Returns 0 on success or a negative errno number. More error
+ * information might be provided via extack
+ */
+int sfp_get_module_eeprom_by_page(struct sfp_bus *bus,
+				  const struct ethtool_module_eeprom *page,
+				  struct netlink_ext_ack *extack)
+{
+	return bus->socket_ops->module_eeprom_by_page(bus->sfp, page, extack);
+}
+EXPORT_SYMBOL_GPL(sfp_get_module_eeprom_by_page);
+
 /**
  * sfp_upstream_start() - Inform the SFP that the network device is up
  * @bus: a pointer to the &struct sfp_bus structure for the sfp module
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7998acc689b7..37f722c763d7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2330,6 +2330,30 @@ static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
 	return 0;
 }
 
+static int sfp_module_eeprom_by_page(struct sfp *sfp,
+				     const struct ethtool_module_eeprom *page,
+				     struct netlink_ext_ack *extack)
+{
+	if (page->bank) {
+		NL_SET_ERR_MSG(extack, "Banks not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (page->page) {
+		NL_SET_ERR_MSG(extack, "Only page 0 supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (page->i2c_address != 0x50 &&
+	    page->i2c_address != 0x51) {
+		NL_SET_ERR_MSG(extack, "Only address 0x50 and 0x51 supported");
+		return -EOPNOTSUPP;
+	}
+
+	return sfp_read(sfp, page->i2c_address == 0x51, page->offset,
+			page->data, page->length);
+};
+
 static const struct sfp_socket_ops sfp_module_ops = {
 	.attach = sfp_attach,
 	.detach = sfp_detach,
@@ -2337,6 +2361,7 @@ static const struct sfp_socket_ops sfp_module_ops = {
 	.stop = sfp_stop,
 	.module_info = sfp_module_info,
 	.module_eeprom = sfp_module_eeprom,
+	.module_eeprom_by_page = sfp_module_eeprom_by_page,
 };
 
 static void sfp_timeout(struct work_struct *work)
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index b83f70526270..27226535c72b 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -14,6 +14,9 @@ struct sfp_socket_ops {
 	int (*module_info)(struct sfp *sfp, struct ethtool_modinfo *modinfo);
 	int (*module_eeprom)(struct sfp *sfp, struct ethtool_eeprom *ee,
 			     u8 *data);
+	int (*module_eeprom_by_page)(struct sfp *sfp,
+				     const struct ethtool_module_eeprom *page,
+				     struct netlink_ext_ack *extack);
 };
 
 int sfp_add_phy(struct sfp_bus *bus, struct phy_device *phydev);
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 38893e4dd0f0..302094b855fb 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -542,6 +542,9 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 int sfp_get_module_info(struct sfp_bus *bus, struct ethtool_modinfo *modinfo);
 int sfp_get_module_eeprom(struct sfp_bus *bus, struct ethtool_eeprom *ee,
 			  u8 *data);
+int sfp_get_module_eeprom_by_page(struct sfp_bus *bus,
+				  const struct ethtool_module_eeprom *page,
+				  struct netlink_ext_ack *extack);
 void sfp_upstream_start(struct sfp_bus *bus);
 void sfp_upstream_stop(struct sfp_bus *bus);
 void sfp_bus_put(struct sfp_bus *bus);
@@ -587,6 +590,13 @@ static inline int sfp_get_module_eeprom(struct sfp_bus *bus,
 	return -EOPNOTSUPP;
 }
 
+static inline int sfp_get_module_eeprom_by_page(struct sfp_bus *bus,
+						const struct ethtool_module_eeprom *page,
+						struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void sfp_upstream_start(struct sfp_bus *bus)
 {
 }
-- 
2.26.2

