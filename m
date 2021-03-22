Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A00344CF0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhCVRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:12:52 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:22617
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231830AbhCVRLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:11:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVx6pdBtXZ4XgQw/3kHKnxA8/T0fj4YIfZCM8Z/y3zXL1wfHpnJ9OXCtq8meaCrUGLG4DsVsY99+cPaorzdDgxo1cW42V8mMDS8yAFs70BS/0zvIv/TrtGaTU41IhNJ1hTMCiSWFFUTchCbFFgnTVZpJkG8suQ0OBZoXH0hxUCEacgNkc+mBW65H+DatOUrVHOKfA9GlD7W4ORRvZfyLUirX7MzUWW+YWmLm45K0kF6Wyra58hz7E+oSSl+3pCUBNqy4upMNKnDdPp+G98CVSF0hKWi2Q0uI+BDL41G/BXP1HNEON3ZkKhcKdqQKQ5CfrAIH/3NkYLlorwns710xPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOltKR3kuLkmV/CE+Rij80ACnRJVqW6yXjI0TUrLZjo=;
 b=e79hSPpVxHY7JQIOgS1ywfcyzoz0dcXkAXUbGjYpux1SRvIdWoq5BxBpdFFPLqzNL+pKfQGOLw74ltwbIzvkqFvTPwktxfy8iko7P0EyRNk1IltfjSiu8d/8eGtqBpIK2GBQzJ9hzGnytEgXNi8ptJ0HpXjMUZiGaoXQJX1PlhOzeuci7cNmqPdo07Hn+OWBMLxyiWF01F0nAtUeXWKN2vpFiV1Ks564ByoNyE7xa9TaRLVzYhn13EEIKqypZ5Ca1mviZ+XWpKP7dk0dWr2oLe6gERqVjl6038WTRKO/714D+cwvmXO6NYi4Myhpl7Jklm75g1xIlVewNIX5OkE/Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOltKR3kuLkmV/CE+Rij80ACnRJVqW6yXjI0TUrLZjo=;
 b=NEwe57XS+oXgIWchNbIt2pXoIu/yqtvDfhnpxcrVkWmmkjKe47/1sqgF6WYtfTOAhb0P1zlR+DgUR81MzPosrZvgmhuRLQvgs1gb0LvtxMmLQ1vu7a2n8cLtPWBX3xnVzct6u5armb9sHeJiMP8yaFRZ58vAsSwHV8Xky60AmwQl7MMKliQSm5FfAfd4Qw4hPcsWVHRUGTqPPe/pgTi/QEbBqBiB0l9lap182ERCoim2B4LW/sTRhCglyNAKgyxto4qfm0LUq95XMiiwroJJcpxSVWaVvwLb5D2oPrL4wFoL075TaoNpe42hCdqrmCqdqn+cpzMoRkSFHA3sQpoYxQ==
Received: from DM6PR05CA0053.namprd05.prod.outlook.com (2603:10b6:5:335::22)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:11:47 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::30) by DM6PR05CA0053.outlook.office365.com
 (2603:10b6:5:335::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.14 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:11:45 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 17:11:45 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 17:11:42 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V4 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Mon, 22 Mar 2021 19:11:15 +0200
Message-ID: <1616433075-27051-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ed03059-7db2-4c07-b7d4-08d8ed559262
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559434D101DA51809810436D4659@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AakluKyAAOHSOHnb1o3rADIiOYenxIj52kTvztRTE6+LeIKUwLu0smjP5ddbGalj7IcuRxiWkojLG9GGGbaJzDcHC/ZQW5DpMF3Trzcl3nUTD73TtSPwOCB6SMpDzdVcPTsDamekdEWo01RNulY9g9OYoIe5PCUqaUQC+5BIyNkg83Kp4cHD5CKQN2RwIExzDDDorHy8czSTdbcp2R+1Cb5hXxuYyVsY/NpXE5kqmKt8Xm1Z49GBcfs8mI+AVdGNi0SLDNjLkmUZpNEsyGwnHs3EKdcJwewllys8wkA9UWxMOzkuLeI6zfsKLT+3jktVKm7bmJKohLWT0khB0bfe8PThdBcYsQYtYQ/WFvbxHhHJsaVMoDIKNFVKQAJH14dALsQV5LOKY+cmfnc+6ECPWDX205z3VjbSVZqpWtaBEhcZ6hiG42qnGRojikeM+51MH0PKFAwl2A5qiicPoKZ3Os6N0pxlfcV15DICcpyaZVMaO768qfd+OlPtoAudVD/9IMIoHpSiCQeFQqXbFa06gweAjeDJwuVGgdVt/zLsZwC66lvvYU9Bxu1Doqpv1vQ1/evaf2Agugz5gCvPFORe41f4l6LY3HtwnlgA5T3jwXXw1eqo+liVJgPEslYG29qVhO+bY0C2rWjo1rDU1IG5E6xFRdPXXsgyWEOKab9yQzs=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(36756003)(7696005)(83380400001)(82740400003)(426003)(86362001)(82310400003)(8936002)(110136005)(316002)(5660300002)(4326008)(26005)(186003)(107886003)(36906005)(6666004)(336012)(54906003)(2616005)(7636003)(478600001)(356005)(36860700001)(70206006)(47076005)(70586007)(2906002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:11:45.5851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed03059-7db2-4c07-b7d4-08d8ed559262
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

In case netlink get_module_eeprom_by_page() callback is not implemented
by the driver, try to call old get_module_info() and get_module_eeprom()
pair. Recalculate parameters to get_module_eeprom() offset and len using
page number and their sizes. Return error if this can't be done.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
---
 net/ethtool/eeprom.c | 72 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 79d75e0e2391..060fe0610044 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -31,6 +31,76 @@ struct eeprom_reply_data {
 #define MODULE_EEPROM_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eeprom_reply_data, base)
 
+static int fallback_set_params(struct eeprom_req_info *request,
+			       struct ethtool_modinfo *modinfo,
+			       struct ethtool_eeprom *eeprom)
+{
+	u32 offset = request->offset;
+	u32 length = request->length;
+
+	if (!length)
+		length = modinfo->eeprom_len;
+
+	if (request->page)
+		offset = request->page * 128 + offset;
+
+	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	    request->i2c_address == 0x51)
+		offset += ETH_MODULE_EEPROM_PAGE_LEN;
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
+static int eeprom_fallback(struct eeprom_req_info *request,
+			   struct eeprom_reply_data *reply,
+			   struct genl_info *info)
+{
+	struct net_device *dev = reply->base.dev;
+	struct ethtool_modinfo modinfo = {0};
+	struct ethtool_eeprom eeprom = {0};
+	u8 *data;
+	int err;
+
+	if (!dev->ethtool_ops->get_module_info ||
+	    !dev->ethtool_ops->get_module_eeprom || request->bank) {
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
 static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 			       struct ethnl_reply_data *reply_base,
 			       struct genl_info *info)
@@ -42,7 +112,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	int ret;
 
 	if (!dev->ethtool_ops->get_module_eeprom_by_page)
-		return -EOPNOTSUPP;
+		return eeprom_fallback(request, reply, info);
 
 	/* Allow dumps either of low or high page without crossing half page boundary */
 	if ((request->offset < ETH_MODULE_EEPROM_PAGE_LEN / 2 &&
-- 
2.18.2

