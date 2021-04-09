Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A39359728
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhDIIHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:34 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:44896
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232631AbhDIIHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2pTniRqAMoqfUHzYyD3VgSYsMz887zUZPk+fH5/BcVPF32GNxRtuGKxlWef2QlHgq3pbXcFgl+ywXCaYXmpyXan7UaSq8kr2l9Y1K6ttjeRy2smpxnoiawg26KiwIdlVyZ53m6mKye25uexDISvxRfO0Kx9kjXNS94VNN8y/dg/syjGlS9Vo1fBfUK05NlrcnGeVFuLy2jAr3BoiS8b27CNKHLdUYD0xVmpMj6NFS52PYOxmXjvIRRwKJeTYqnh+wX6UPrMFeN+qfBM/yJfTtQ4soGYm1AC5apghlVNMFYyVDqZkKNNVpnctb8y2+JXVisHqmvtrXl9y8S2LgriPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i66V+Wg2N7P6mO2v7VM+Q6/VZ15MMbVj5QOceB4ef9w=;
 b=noYpUWmid8GEHlT/1ppT0ADuC7DtLuZXbUkXHUVqPf8gpFuugADwjHlu5G2EbNp9u+YBiAzJEY4UtkKzuRgL0nOSAyd1PW9P414Z/47arRmepCsHzxGId4/Jn9luLeOF0KwnnwTtfD6K2cG89l5IZUwvlR5Qa/MkBjPYYV0T0fBEMF7kOU9Sc9iDC7lJNdAcVCE6TSCC6eBQ7LhuyVyf+ZNcucVejCblg/rosEQB1rKArMCBBAqewn9j1SwyS6c2OA7nwGO5o/QgZRWRy40vjo+smUc5+SiODaRrOgsnQfbfIEe5JPxz3lL0kNAAs5krbTfmHN+NUWIO6mDJWdC9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i66V+Wg2N7P6mO2v7VM+Q6/VZ15MMbVj5QOceB4ef9w=;
 b=oV4niLU06btupL3cqxRKVyNQZPFXVoOD8D6xRx8wiIPIBL6bvNNfRKOgJvLlHWkoFJQof9hMc3ePsdKEe/t3DwaV43czvdUSFD3MZAhT30ge6ne38O9ogEbavin8WyDUASBlEIrBCOapNf2IWQo8+TPslhXfH8foTrtKTq2utAxvDRHXUm+GWW+HBKB48SLeyioi59yKiVsUfla1UsAWFmz1UfwMFZSaHgrGcVCBIJW72/FVVBoJax6ATrSE8zlqOq097tDfxvQv9JisHUge9t+n0q4bDV5Ym/z0fH2VhBCAcKliS5hSmfezrrwNcWID/uE35KrA0sgtuoKIPvG9Nw==
Received: from BN9PR03CA0064.namprd03.prod.outlook.com (2603:10b6:408:fc::9)
 by BL0PR12MB4708.namprd12.prod.outlook.com (2603:10b6:208:8d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 08:07:16 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::2) by BN9PR03CA0064.outlook.office365.com
 (2603:10b6:408:fc::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 01:07:14 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:12 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 8/8] ethtool: wire in generic SFP module access
Date:   Fri, 9 Apr 2021 11:06:41 +0300
Message-ID: <1617955601-21055-9-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f953365d-f544-46c2-defc-08d8fb2e7d8d
X-MS-TrafficTypeDiagnostic: BL0PR12MB4708:
X-Microsoft-Antispam-PRVS: <BL0PR12MB47080AEFC791151686D5621BD4739@BL0PR12MB4708.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDOco7Q4/JRlSFi7bsyC6al/4V9QQdwglL5CWFHonSd3IcXQAla4qdmylfproxzun64IIYTyroDif7gbgaPk+uWpXT8IeA8EMA78mSZJmrKg7QlufEXER8Htm8veQSD+legCCFFdwqiq011GsfeF8EbsBsp6Hq3dVIKpLMEN2Dd/bvF6O4jhbp7TMqEI20ECKXKpczUYjkXlMPUKp5oy0EsfpkKHFhp4jBsxxfirOg8AsUZtqMw3GkYlrpX6spX3cTyCV0ohiD65nsFuNkDSOYhsfpW9UJJ8mqJIEkxlneCXAAEZ1BB8ZZfUz3zbgoU7W5xCDLMgG7rGB+SKuX8dyrWGfhFqT72ml5FNwT4j3hz3bvv/TgH7XXCemATC7l0pty9sG8Vc3ZM7HnXjIqLGNjSUQG9vptVdKPueegq0HeAmR59ryQsJmYx5NN0NJnOvSSIE2i+yeWJDYAU3ojdfO6sTK19ccME6KFgkhfclw9Cra3pnTQc9sGgFinguhyvQufac8JrDEtRg5AacnrqYxwalucDeJ+3f8z19IxkgfhVdA33YMviXU0nGLz5MX8KC/ibJIkIrq8HAG5GeBtZ4bkT38SwRyWb/EP8MClPf/9bx4voi0vjvwFPKP/nePNBP+7DLj9RZ5BZJ3tOeI/MH8AyFwHpT2/BIa1FINMSd5AXisSdHIKrT6l3Rrzj+ToWN
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(36840700001)(46966006)(336012)(7636003)(426003)(356005)(8936002)(316002)(82740400003)(26005)(107886003)(82310400003)(110136005)(86362001)(7696005)(2906002)(186003)(478600001)(2616005)(36756003)(83380400001)(4326008)(47076005)(36860700001)(70586007)(8676002)(6666004)(5660300002)(70206006)(54906003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:16.4763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f953365d-f544-46c2-defc-08d8fb2e7d8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4708
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

If the device has a sfp bus attached, call its
sfp_get_module_eeprom_by_page() function, otherwise use the ethtool op
for the device. This follows how the IOCTL works.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/eeprom.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1a49c133d401..2a6733a6449a 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/ethtool.h>
+#include <linux/sfp.h>
 #include "netlink.h"
 #include "common.h"
 
@@ -85,6 +86,21 @@ static int eeprom_fallback(struct eeprom_req_info *request,
 	return err;
 }
 
+static int get_module_eeprom_by_page(struct net_device *dev,
+				     struct ethtool_module_eeprom *page_data,
+				     struct netlink_ext_ack *extack)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+
+	if (dev->sfp_bus)
+		return sfp_get_module_eeprom_by_page(dev->sfp_bus, page_data, extack);
+
+	if (ops->get_module_info)
+		return ops->get_module_eeprom_by_page(dev, page_data, extack);
+
+	return -EOPNOTSUPP;
+}
+
 static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 			       struct ethnl_reply_data *reply_base,
 			       struct genl_info *info)
@@ -95,9 +111,6 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
-	if (!dev->ethtool_ops->get_module_eeprom_by_page)
-		return eeprom_fallback(request, reply, info);
-
 	page_data.offset = request->offset;
 	page_data.length = request->length;
 	page_data.i2c_address = request->i2c_address;
@@ -111,8 +124,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret)
 		goto err_free;
 
-	ret = dev->ethtool_ops->get_module_eeprom_by_page(dev, &page_data,
-							  info->extack);
+	ret = get_module_eeprom_by_page(dev, &page_data, info->extack);
 	if (ret < 0)
 		goto err_ops;
 
@@ -126,6 +138,9 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	ethnl_ops_complete(dev);
 err_free:
 	kfree(page_data.data);
+
+	if (ret == -EOPNOTSUPP)
+		return eeprom_fallback(request, reply, info);
 	return ret;
 }
 
-- 
2.26.2

