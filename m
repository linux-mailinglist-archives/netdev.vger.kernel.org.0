Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1F359721
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhDIIH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:26 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:38400
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232354AbhDIIHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6z6oa7Gfj8TBogVn8f2pRgCn6FQTACWDpbHMlXPbcq06pCxxMElghBV0t1oaGFH+HuMJV/ZgiP6KglSZ3YV3arUGyAJucHmpUG5eRPr4SCoe6ZVVxwmneOFlx240ydNoLDE2ZXAMVfAz7n70fDRpjJTesptTBs8RXFSXru8YUyTnmRHw3hOCqtIsaGiOlElPAnCR8MILVo4atEm0Mgbyj0j0HA2nvvLnitIR16kkPYXrHYCQqbJHtGNkQbUwG7hKqApPngAMnyOXFR3lqN8JUGJujI28gXFFPlcUTXCMC9XkjeFaeTR+fQY2vlYeHP+hpg1avcPBb7EngkripW9mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6edmMsgQ9e8pPqXPNeaBNpO6k9utqturmvl4/R/bi8=;
 b=NUM0mik9rmddiZ/KEuEivq7HlJYBnaXi8A0cqL8M6NJBO9nXYo01BqsS0DH7WjHIpthVnemwLt8ST9b9j1qk2gRJAATLtQbIIMo9Z38XkCaNiOlKtaOTukLmYqQQ7lk6kwBMkJm6A12kpPy+J5TifdO2kkVSrg5BwzTKZNpTaf5R3vJTGd7tg69uYeZ6LhXSqUidMPEEm9uakzgTzarfMjEOiUUiKYaIr+c1VwQM+05nyMvTfbc+yUuJwkBP+TtVkTZ60YxtoXGNEtdJnUnpYbeh3avErr8Y2czlJAuU+TRYY5RU8ojFi5IvYdA+ZhqPa5hmCZ/TJuzWYbF17HAZoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6edmMsgQ9e8pPqXPNeaBNpO6k9utqturmvl4/R/bi8=;
 b=PUJzrytCIwuIYjVgoOgB1ngM3+pKWfhqTEu4W61IuBfkT+3b7bGMtcBk3AEc4dyqc9OepAn3fnG3rbU3MwmRkNHymJX/hC6Ef075/OihazYY1nOZPV+nEkphORT6Qv7SwqpKIO8zzKg2dWnUznkscKRm92I/Gvt16ZIK7LhgL6OgqIwjH20Bt4Hj3TJJrGKNVRmNbWtWJ3TmUWnzihkxbcBll8Dsl6u+Cr+MbAAPtPbZ54OjONRAbaTzFvdD3Uv/q+Hajdpx3dkzmH6P+qHMaH5aAOPxTnJCkQi9Q6iY3bLlR9Mj2R+PL8jvf3O/lr3DXifNeoVI5/zpyyicK/NBQQ==
Received: from MWHPR13CA0046.namprd13.prod.outlook.com (2603:10b6:300:95::32)
 by BY5PR12MB4855.namprd12.prod.outlook.com (2603:10b6:a03:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Fri, 9 Apr
 2021 08:07:09 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::17) by MWHPR13CA0046.outlook.office365.com
 (2603:10b6:300:95::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:08 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:08 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:06 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 5/8] net: ethtool: Export helpers for getting EEPROM info
Date:   Fri, 9 Apr 2021 11:06:38 +0300
Message-ID: <1617955601-21055-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 408272a0-1f0e-4f45-62c0-08d8fb2e78e7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4855:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4855905FC4A2C32CD2EBC18DD4739@BY5PR12MB4855.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pa3YI6RfqHzB8sgNEnGPITIXjHzYH34gdgxa9LnDM3z3TXqa4fVFJqTEMgXRYYSlZqra7PlOcJJphIP+XeukVNvgwHS1LgRuTXiUDEdaFBuUtT4Yb0ZaeTWHAkdRNINfRbxHsASfcIM2ASSMNMoH3KZlViZOkz+nqAFzuoIMLW8FdWOlq2jtrA+NhgDR1y5SC3k2e1D9E1e9TuT3L3NmYUb6ci1VzNozC5sGbA6Btt2aNMXZg+v/6RkOGX0NIY2R2yOv3iXXHFQrpY6zwufwSdZcfNmKfPkFFY7qoePjKK0rROBwc2v8aGiTmV9qnRn74eFIVXDnLZcxghOYSaJxKV0XvmpE6IIkrVsgus+wjzAP0yHTFzs/MdSAkKuP6rAKCquphRiLM8qTUkKwLxfh2avbi92MNllTrTP4H2CjgC4YD47kS8NKcGGZTrRqzhK6kU5I9N69q7ZO5ifn2reYzLz5suQNrzqVvSZqMGNVnKnqw+BD8ZJrQkLPQKhgMpL70qd/TvAGgrHBAHtZ8Rsifg1xi5cFi6b0Wr9y6jZyUO+iGM3SnLRo1eRlyolH70ayOVyeauZHEcJpdbwus4wABMrk6Kt7CaohQmYe4QWMmaUn8GsfWHGloJrAoELUrQu5B7/u8xVc6NwHc2/xsOBfT5dr0/vcWDmrlEei/emSEs=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(47076005)(5660300002)(82740400003)(7696005)(86362001)(70206006)(83380400001)(70586007)(8936002)(8676002)(110136005)(54906003)(2906002)(356005)(316002)(36906005)(107886003)(26005)(36860700001)(186003)(426003)(6666004)(82310400003)(4326008)(2616005)(7636003)(36756003)(478600001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:08.7303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 408272a0-1f0e-4f45-62c0-08d8fb2e78e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

There are two ways to retrieve information from SFP EEPROMs.  Many
devices make use of the common code, and assign the sfp_bus pointer in
the netdev to point to the bus holding the SFP device. Some MAC
drivers directly implement ops in there ethool structure.

Export within net/ethtool the two helpers used to call these methods,
so that they can also be used in the new netlink code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/common.h |  5 +++++
 net/ethtool/ioctl.c  | 14 +++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index a9d071248698..2dc2b80aea5f 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -47,4 +47,9 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info);
 
 extern const struct ethtool_phy_ops *ethtool_phy_ops;
 
+int ethtool_get_module_info_call(struct net_device *dev,
+				 struct ethtool_modinfo *modinfo);
+int ethtool_get_module_eeprom_call(struct net_device *dev,
+				   struct ethtool_eeprom *ee, u8 *data);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 26b3e7086075..eec8e588894b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2204,8 +2204,8 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	return 0;
 }
 
-static int __ethtool_get_module_info(struct net_device *dev,
-				     struct ethtool_modinfo *modinfo)
+int ethtool_get_module_info_call(struct net_device *dev,
+				 struct ethtool_modinfo *modinfo)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	struct phy_device *phydev = dev->phydev;
@@ -2231,7 +2231,7 @@ static int ethtool_get_module_info(struct net_device *dev,
 	if (copy_from_user(&modinfo, useraddr, sizeof(modinfo)))
 		return -EFAULT;
 
-	ret = __ethtool_get_module_info(dev, &modinfo);
+	ret = ethtool_get_module_info_call(dev, &modinfo);
 	if (ret)
 		return ret;
 
@@ -2241,8 +2241,8 @@ static int ethtool_get_module_info(struct net_device *dev,
 	return 0;
 }
 
-static int __ethtool_get_module_eeprom(struct net_device *dev,
-				       struct ethtool_eeprom *ee, u8 *data)
+int ethtool_get_module_eeprom_call(struct net_device *dev,
+				   struct ethtool_eeprom *ee, u8 *data)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	struct phy_device *phydev = dev->phydev;
@@ -2265,12 +2265,12 @@ static int ethtool_get_module_eeprom(struct net_device *dev,
 	int ret;
 	struct ethtool_modinfo modinfo;
 
-	ret = __ethtool_get_module_info(dev, &modinfo);
+	ret = ethtool_get_module_info_call(dev, &modinfo);
 	if (ret)
 		return ret;
 
 	return ethtool_get_any_eeprom(dev, useraddr,
-				      __ethtool_get_module_eeprom,
+				      ethtool_get_module_eeprom_call,
 				      modinfo.eeprom_len);
 }
 
-- 
2.26.2

