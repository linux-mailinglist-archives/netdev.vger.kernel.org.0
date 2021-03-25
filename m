Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF773494C4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhCYO5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:57:42 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:32225
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230525AbhCYO50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 10:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHXqdTisroVHmuZ2u9iVbDo2FKIy+SWssUz65BUZgSjLvIA/yv0j5L6g+aeRw3ch1x2Hml8n0BTMZVhpDjoFEuvlW8uMXxTSwlGC/1adwhI7sj7B7KFIG6ZyAM+x8b5mcFceenur4wetTCH4030ynYzJ28JiUhVv0MvK9kmymoJhM3FuBkaOyPbzut/+7iQNwaOl7GDIJLp9j4lfAImyVXvysYdBR+KLFMDCA1Qjv4Qq05qCNQQDV9ALJ4MwhfApJBrMxzZWugj0QcN52h3zil7c7sOLe1XXHm84xchRtjT877Xru9ZLsXDjQ2C2HPDa90ENsB28C704ujQdCyHb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj54hgh5dJjkXB5IthWn4MrJ0cV0c0xOqIr7JyUhJow=;
 b=hS1bXYiIWbnYMRTqQq6i6hyLlCJYf4Px/PY/kXdWCBhGwZ6h20zp0zlGtyE4054XnD1hdNc4RleAqiNMdiFNc76vyaglA/EErW3RTT3pAVbXoxHY4eYVaEKbrLZkTX4SuuOZTYdOs2sV6A82v8Nk317DlrcJq/vF1ALwxyXTjw2tUWHe02rp0ac1n+rYve9zf+kXTT44HH2/ERqtbWgucimE7O6B3itmi+gAL1OR/UWu+ggExqGcaq3wtoQ+XjxxJbgjphTvwNNWv2t3I8bnwvlTBb7Pw/nkngL/cWfipUSIP5KV2Fck+qpeDb3DgvQ4UTpH1P+eD1EME2glu3/gZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj54hgh5dJjkXB5IthWn4MrJ0cV0c0xOqIr7JyUhJow=;
 b=oOUnMv+fao/YLHsRbeQryKkm1jFvoBTSfU6/Y7ez8Qssfn2GQc/l/Y2fYOFXf93DiiCdi/s3Yoiv4dOs24ClP2akUUqRdD1GlvSaL4bh/fUQD7F4DxPioaNzI8UgeU/o+fv2rcxSBxCQ7j7anfZAaG6/J6bjG4mN1nWKGCszHQKBhpvHWbUUE3avfIco15BGacYce25p49hXVA9wGduLdAUHoDdCn/6LM3txYDGNxxN7SQGgIthEwlcFt8L3yGFu1+XtgYiXvP085Evua8SUMroOduV9EZjxJ7HFT2pwGbv9Y5FGv71L/W2VNs5OyqJSA017hbmKl1KIvPM3zdTipw==
Received: from MWHPR12CA0061.namprd12.prod.outlook.com (2603:10b6:300:103::23)
 by DM6PR12MB2889.namprd12.prod.outlook.com (2603:10b6:5:18a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 14:57:24 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::ec) by MWHPR12CA0061.outlook.office365.com
 (2603:10b6:300:103::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend
 Transport; Thu, 25 Mar 2021 14:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 14:57:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:23 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 14:57:23 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Mar 2021 07:57:20 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [RFC PATCH V5 net-next 5/5] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Thu, 25 Mar 2021 16:56:55 +0200
Message-ID: <1616684215-4701-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08e57918-6241-470a-72d3-08d8ef9e4c99
X-MS-TrafficTypeDiagnostic: DM6PR12MB2889:
X-Microsoft-Antispam-PRVS: <DM6PR12MB288909631E80488F99EE7050D4629@DM6PR12MB2889.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZob/1uEo6tpsuLfSWbreTsMk1DRXnrwfVzM1Xm0h8+MdBwq9CXss3mNcFN2D+eGTeNXNllpd0DcnnEGzrt4sk33mYIfnIipAanNrbJALK6V6vFfvYw66CEV+x1hB9yNgvibueP5c6fFnY9UuziDOw807EvuWV6jCs2G6n4QHvjMSYkH0ELlP8/Mjf7NtxmNqEXIciXXIk0mHPtUbiZNYvm8X108aL5dnkUh8idjpQJLmWkgw6dHJXjvrvcmjBYJ2WXhF5Qh0O/rCjJEHkxbmU1xEtUjjUozcn/K9W1R4tpX9nPoZZbgG6ONqfubC89EO1T7N9yzeVes1s5LxK45Qkrqcdv0dsTjfotFHgvcP7klBzkU/VfMwlCGum7Z/yF5LAqe6d/oHaC5pFLc9eZCx6wbMU62e2XzBl+v35FQ84VQVbiTS6ZnR4yJv+RrPF/riDQTZl+TTJ0fnWIk8n8tSSCZVOrwkHL+wroy1fgC+HHatQmeAVBy6sjuWzdbCMoYkXfED9dzck2gFfHM4n7h2361//8NF00bQvnQUZvDqgymNRro9ffct7dzyU1EVoJoF192YKh/4GdZmBNvF38iw3ApLcRRga2OwtCtsEEk9y9s9uN1aahZaKuADYTUVvk1Wofq7/hwc+KOd6iamtxOkoqKbkOXTY7huWHMwfPX924=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(8936002)(110136005)(426003)(2616005)(478600001)(356005)(82310400003)(70586007)(70206006)(7696005)(186003)(2906002)(4326008)(36756003)(336012)(36906005)(8676002)(82740400003)(107886003)(83380400001)(316002)(86362001)(6666004)(47076005)(36860700001)(5660300002)(54906003)(26005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 14:57:24.0771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e57918-6241-470a-72d3-08d8ef9e4c99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2889
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
 net/ethtool/eeprom.c | 66 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 10d5f6b34f2f..9f773b778bbe 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -25,6 +25,70 @@ struct eeprom_reply_data {
 #define MODULE_EEPROM_REPDATA(__reply_base) \
 	container_of(__reply_base, struct eeprom_reply_data, base)
 
+static int fallback_set_params(struct eeprom_req_info *request,
+			       struct ethtool_modinfo *modinfo,
+			       struct ethtool_eeprom *eeprom)
+{
+	u32 offset = request->offset;
+	u32 length = request->length;
+
+	if (request->page)
+		offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
+
+	if (modinfo->type == ETH_MODULE_SFF_8079 &&
+	    request->i2c_address == 0x51)
+		offset += ETH_MODULE_EEPROM_PAGE_LEN;
+
+	if (offset >= modinfo->eeprom_len)
+		return -EINVAL;
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
@@ -36,7 +100,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	int ret;
 
 	if (!dev->ethtool_ops->get_module_eeprom_by_page)
-		return -EOPNOTSUPP;
+		return eeprom_fallback(request, reply, info);
 
 	page_data.offset = request->offset;
 	page_data.length = request->length;
-- 
2.18.2

