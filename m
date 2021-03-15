Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DB33C3D2
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbhCORNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:13:49 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:23969
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235598AbhCORNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NG+6SFkIawg9D5THn4JBLAXJs/RI7Q8w9PSm8GPZP0NHEqMXUykWoBYbI/neXFXQJ3pgymatheeHzZ5A63crSQMbgJR4W747NjoJqf096a+t6MTP/7b3FAec/PL22FAcZv3qE0YR59zImLCwaXB5oj0sq0iDiJsOccl092k1suCn1H8Xe5Gtdaws+WR+Qp2ekv+pjqu2pJWiLVRwlj+oqTkzNGr0ZvvEZvR+8L32tJEm88nAuO6bBCaThpIrMdOBuxqrNmAm47Phzr8hz4/uo2cRYAPtJJX+KSs/8UlKcnvUZczEH85BjEA92K+kkyxjosy9qumTzry2tkozHagbtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvI0JQDyxIcoltvSXL2aV2GqXQ/S12HykhRkQwkWtDg=;
 b=SGzvuf5INtKVrCuhsYgR/BZol/QfeSpq5AX8jdPKID9ZPnBL8MARxPVSt8ghR+0dKOuSthy9/iTUU+dtXSq/h21+cOSuVM9GH81XtXaPs5wyJi4VkEwLNMSOa09aUw+i9jY21dcmCheaXpzqatluWMGZFl5FDBVL7Yi+M8DBaIFmrK3TDEDAjVSgXiidgHWjbHD6zAewMSvQMuG7P89g2M3CME192UG9RxF5mmU7wQE/a9vTk1sd3ZNDkzMctPyrSH10wT7X+FfugBJghFIi1YQxcdF4u5CoB3u+twbDLAdBWsCurmQRtBHtikAHwwYDk+jYh5536zTsR6gealf00w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvI0JQDyxIcoltvSXL2aV2GqXQ/S12HykhRkQwkWtDg=;
 b=eftbXRMceEH1lXKFUIG9qK6TcQ/A97iCOXg7qCPV3ZE8Jpvh+80G56rsKSkfH1sWdgOxKODv1aOCbgC5R2FyHCNVT/ycU0aQeiqnVDJHDx/qCu6ubblYzZyX4rRc9adJ57Se47ZHrypUk6WphQHgX9Um1oYIiKzlhjHBOw/ornzvLqHoHUJ6uCODQhgvqh2Z0eegHqWIvu+KdnpXnZihSIXFu+AV/iMoRxxbbscMfiZjnvxVvfEKfeLbb24GDqP++0Sw2W562tdbWOuOKukH2wpcIhVX2rPL7KJjtFjq+ptkeJxTSq7m9yEogxxoxnwKX40FWvdh3sElJ2AD9vrffQ==
Received: from DM6PR03CA0080.namprd03.prod.outlook.com (2603:10b6:5:333::13)
 by MN2PR12MB3262.namprd12.prod.outlook.com (2603:10b6:208:102::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 17:13:10 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::b6) by DM6PR03CA0080.outlook.office365.com
 (2603:10b6:5:333::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 17:13:10 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 17:13:09 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Mar 2021 17:13:07 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V3 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Mon, 15 Mar 2021 19:12:43 +0200
Message-ID: <1615828363-464-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1615828363-464-1-git-send-email-moshe@nvidia.com>
References: <1615828363-464-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3019e9c-68b0-44af-22cb-08d8e7d59bd6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3262:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3262460F8A590668378C863BD46C9@MN2PR12MB3262.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gKA3hvTHHngIEHXAmYcTsRVDjNpfp5FcWFCRZEzhzjYGBq7gN2kvZsoqGmGiLFKXxCCTobhhNDWbIWGMVSnD3bQl7fJkFfBYyeuCdljwIwHjlTm+Pnwu/eFA7CgmzqZPBUo90rktP/SgI4UBS2nvxRDevZEERDWITbndsoEf5BxhBWlbRvYZVis2uyQ4FWFKnswMoMAjfrP29OIhK4hIPDUwwYPSxjfdpkeE3IyWIPd8nIq/G8DZ0uwUKIUuc/d06hV/d5ijDxXj1cxQwW5QZKK52xP+asYEiGbnZ0KnCwfak0hQk8t8grKORHKbEZWfzKPwAo96Ygz+ddtUxOircIi7OdbqmFMlXzBFVujze73YjrzYyZOXwCERiaok0e45fFLgA+kcMc2FISxBVC9X+HcYlLQbfGNyGxyTlfaUFb+yJ+OYBkY//VGS6Y2wZxxfcm6vQn7eW58U75iftMjDBHUB5Ue8XSJDPBh5ogSz5IYdZAmu5WieeQ+/wQoVUaOYgCcKCVqB2k+Td6Y+DJaZEMuWe4GrnmbWblRWDWNjtlE6ukApjhvca89FsJ5fk2E9upnLqptqE04XXBU8zBtySnQEAJfB8NRlh2d6Q6IfPOiFGUUDMrI8i25EK5U5CDDTywWfIqi154nacRSEDub5iSEo1pb1pARFnGEDFivYpys3BFCEmvX9E7rIdxu3QlJB
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(2906002)(4326008)(478600001)(6666004)(36756003)(86362001)(186003)(426003)(107886003)(82310400003)(34020700004)(2616005)(356005)(83380400001)(7696005)(7636003)(47076005)(8936002)(5660300002)(70586007)(70206006)(36906005)(8676002)(336012)(316002)(36860700001)(110136005)(54906003)(82740400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 17:13:10.0298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3019e9c-68b0-44af-22cb-08d8e7d59bd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

In case netlink get_module_eeprom_data_by_page() callback is not
implemented by the driver, try to call old get_module_info() and
get_module_eeprom() pair. Recalculate parameters to get_module_eeprom()
offset and len using page number and their sizes. Return error if
this can't be done.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 net/ethtool/eeprom.c | 75 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index e110336dc231..33ba9ecc36cb 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -25,6 +25,79 @@ struct eeprom_data_reply_data {
 #define EEPROM_DATA_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eeprom_data_reply_data, base)
 
+static int fallback_set_params(struct eeprom_data_req_info *request,
+			       struct ethtool_modinfo *modinfo,
+			       struct ethtool_eeprom *eeprom)
+{
+	u32 offset = request->offset;
+	u32 length = request->length;
+
+	if (request->page) {
+		if (offset < 128 || offset + length > ETH_MODULE_EEPROM_PAGE_LEN)
+			return -EINVAL;
+		offset = request->page * 128 + offset;
+	}
+
+	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	    request->i2c_address == 0x51)
+		offset += ETH_MODULE_EEPROM_PAGE_LEN;
+
+	if (!length)
+		length = modinfo->eeprom_len;
+
+	if (offset >= modinfo->eeprom_len)
+		return -EINVAL;
+
+	if (modinfo->eeprom_len < offset + length)
+		length = modinfo->eeprom_len - offset;
+
+	eeprom->cmd = ETHTOOL_GMODULEEEPROM;
+	eeprom->len = length;
+	eeprom->offset = offset;
+
+	return 0;
+}
+
+static int eeprom_data_fallback(struct eeprom_data_req_info *request,
+				struct eeprom_data_reply_data *reply,
+				struct genl_info *info)
+{
+	struct net_device *dev = reply->base.dev;
+	struct ethtool_modinfo modinfo = {0};
+	struct ethtool_eeprom eeprom = {0};
+	u8 *data;
+	int err;
+
+	if ((!dev->ethtool_ops->get_module_info &&
+	     !dev->ethtool_ops->get_module_eeprom) || request->bank) {
+		return -EOPNOTSUPP;
+	}
+	modinfo.cmd = ETHTOOL_GMODULEINFO;
+	err = dev->ethtool_ops->get_module_info(dev, &modinfo);
+	if (err < 0)
+		return err;
+
+	err = fallback_set_params(request, &modinfo, &eeprom);
+	if (err < 0)
+		return err;
+
+	data = kmalloc(eeprom.len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	err = dev->ethtool_ops->get_module_eeprom(dev, &eeprom, data);
+	if (err < 0)
+		goto err_out;
+
+	reply->data = data;
+	reply->length = eeprom.len;
+
+	return 0;
+
+err_out:
+	kfree(data);
+	return err;
+}
+
 static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
 				    struct ethnl_reply_data *reply_base,
 				    struct genl_info *info)
@@ -36,7 +109,7 @@ static int eeprom_data_prepare_data(const struct ethnl_req_info *req_base,
 	int ret;
 
 	if (!dev->ethtool_ops->get_module_eeprom_data_by_page)
-		return -EOPNOTSUPP;
+		return eeprom_data_fallback(request, reply, info);
 
 	page_data.offset = request->offset;
 	page_data.length = request->length;
-- 
2.26.2

