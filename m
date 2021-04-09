Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B231359723
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhDIIH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:07:28 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:62816
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232087AbhDIIHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:07:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znvyb1AgTZiJYClfsJYUN0KqfRpQahbV8R9ZbIy4OauR7V0KeCkMXq2l0koc5nKctrjv/WiUUcntXEc/yDoHsZ6lQR8gpqhux4U5D1XgHy0FbRsbTXuOh36g2njObFerdZji6CP+ooj/f12kH8Y1v3fSyTVM4q1hzNLTYX00DerxjMCw7E8w1uSOaQJmbPgUG/eFcEMTyaImn/DHJpEWNO9PwVjkZAEK4ueA6SPp9qJ5Nzamz1YLSr2jroXXRR+Jq/nQQmNF8+Ed7a5qsZxauxJS9ooK0AzQ7t4XrUQYJBNUuFWUOoKqnsGH2a9byk44aDZ7n2yCs8dM9HMQKTCT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRjDAJ8OUpkf4M2DTeycMtAZ3N1WoRIJrhaWSnjaQlo=;
 b=gTcs3LFPPyRgafL/ggNhtJyzYGMMZHNFPnRXVAc3wOKUzr3PmxQezbILhLefEbOdy555XelnYJwhLzv+KXgU0HSYkfI7MUJ2/rKgZnnqiQ4nA7MM2+h2K/Uu9N5ObrFqcyM5jnU5JHnnfwKhcfwXzFGci7omTNgwmc61E9R7tUq1Ci7q88esabKY01HPyNjUsgA8ZQiIsuO+2ZPatxCgLcL+MU8Gz0wRY5X80XgYViXqiPho/WwokRb/vaYEwyaSrUS/VikZIOqX2tAOA4o68ZxQXhMxtKXwili+/NCGin0H6G5nMh8dpywo8RglEWZ8H6T5GoSaGzNP9oleh5Rqlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRjDAJ8OUpkf4M2DTeycMtAZ3N1WoRIJrhaWSnjaQlo=;
 b=lir+KDJE0edXQbN/OeUavxvEzR0C0cmKVc5eQQFv+P2kcZXWaLXbKhzwgpPHzWjHhjqn/4EzyTqMa4WZDuvOpiWEc/Ro33M5YVj28ZMonpSbRSySf4uRRSPywZ5IFAbFtSnGS+sYhjDVInieYPTues6wMBmtHKZpS+YthCEMUfoVXaKs5Z6eEFEmuFDBpgqo18bpmEEODn5d8wjIpJEElrc0j34Oi6BD6IBS25C07KO1dYn5MJQeaguw/7Ugvt29lplrjMYKk6mFHNTf8I5DOBM/EIvhwZqVo99tx1R0kbqBEVupvJRmYxxXMI2UoJZScjB/3ReL3246NrTR+kO0VQ==
Received: from BN9PR03CA0613.namprd03.prod.outlook.com (2603:10b6:408:106::18)
 by DM5PR1201MB0058.namprd12.prod.outlook.com (2603:10b6:4:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 08:07:11 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::c5) by BN9PR03CA0613.outlook.office365.com
 (2603:10b6:408:106::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 08:07:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 08:07:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr
 2021 08:07:10 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Apr 2021 01:07:08 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        "Michal Kubecek" <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: [PATCH net-next 6/8] ethtool: Add fallback to get_module_eeprom from netlink command
Date:   Fri, 9 Apr 2021 11:06:39 +0300
Message-ID: <1617955601-21055-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
References: <1617955601-21055-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67f694cf-f7b8-4543-fcfd-08d8fb2e7a8e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0058:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB005820818738B0FA66B0D583D4739@DM5PR1201MB0058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dkXDD8kd/rLUBkt2I2KwQw0CWGvHgd/AhDH/g3iUJQIuOZ+r1r95BbMm53iejG0nsIDaN+6e+oPbWoKGrXkhLeKJ1+lfogm842POLepo+TUUobpwyjCR3lwqGCkRq32MWqDTeuJoyac+VTDUk954uWGmKDouCv6APAYbV6XnBzED3gfL9J+tct1JlnG6zpaoMY1V7BgzTrWZnxQzpcTvuzgYMKkfSeWjdz01Pe8hUOHMUs2pKzL9aYp6Od+NtTQfavBfClH6aFvie1V55vKeZUcX8p1mEbDbgMAWEPqzR3AjFKns1Psujm90Ds6VduVOWhN6UEIAlJ4LGxERaPwHd4rCmf4uI6n4sn+JIcy0B23Z/iERcCSMNx1Kg26sNZIUmh1BuZ14hnVflmSgd6FChyPGVmFy2uJaKcmVEjGk69YIVIzUKHYRbtaAF7MV94fGzQPOPB+j4zGAp+ofmYV84zLmArIqOpaEGhtqK6AVH3z5qFyja3AfWLLDLY7rx+kDTlixOS/zrBkYDslKAFl2hbT34pkDq3lZ9isDneAz8sL3wybRZovnG9JvQS67NnW8aQLr25n6+GV+OWeFabnRy42zPKv/y6b6jm9lgsMPSq1L+53w5K06n0H1FZPQcrJhpiLTHc/Z/NPw1OKlFezyw7G7oKxFoTVVSEjSZrkF+LI=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(36840700001)(46966006)(86362001)(26005)(36860700001)(70586007)(107886003)(47076005)(336012)(356005)(83380400001)(2616005)(426003)(186003)(70206006)(8676002)(4326008)(478600001)(8936002)(82310400003)(36906005)(82740400003)(316002)(6666004)(110136005)(7696005)(54906003)(7636003)(2906002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:07:11.4514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67f694cf-f7b8-4543-fcfd-08d8fb2e7a8e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

In case netlink get_module_eeprom_by_page() callback is not implemented
by the driver, try to call old get_module_info() and get_module_eeprom()
pair. Recalculate parameters to get_module_eeprom() offset and len using
page number and their sizes. Return error if this can't be done.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/eeprom.c | 62 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 8536dd905da5..1a49c133d401 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -25,6 +25,66 @@ struct eeprom_reply_data {
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
+		offset += ETH_MODULE_EEPROM_PAGE_LEN * 2;
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
+	modinfo.cmd = ETHTOOL_GMODULEINFO;
+	err = ethtool_get_module_info_call(dev, &modinfo);
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
+	err = ethtool_get_module_eeprom_call(dev, &eeprom, data);
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
@@ -36,7 +96,7 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	int ret;
 
 	if (!dev->ethtool_ops->get_module_eeprom_by_page)
-		return -EOPNOTSUPP;
+		return eeprom_fallback(request, reply, info);
 
 	page_data.offset = request->offset;
 	page_data.length = request->length;
-- 
2.26.2

