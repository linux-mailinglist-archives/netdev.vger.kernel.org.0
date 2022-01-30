Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EF44A35E9
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 12:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354630AbiA3L3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 06:29:14 -0500
Received: from mail-sn1anam02on2053.outbound.protection.outlook.com ([40.107.96.53]:56258
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354627AbiA3L3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 06:29:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrGWY6dtOTcMh+Sf0RhCdKt9Z2jSQbYCoKAXKa3dqZxGGgqVxS1vPQKULb+jVJTua5RQMw3YTQj5uQahl4GDDjB3cQeO+kICMLXbxa5r6MJuBuAT4tz5wLV63QdxKxPrZwJ6/NYKkKt+fawmQdUklxpDMkyJeVDiP0WECiNo7rwzAnpA3H1qaC4SizhiuS7AelnBWXOn4mwqz99RFFfK0z6VYM77QCXWVsWCMjIcEdigwIkWsc/Qa/j8TxMjk7OQoEUDGgIVGr3xCznNtqiebC311/I71GDcswpaWo30Fu1jzVTWcgvJPKVs8eX0yx2i36AEDO4zWeo+YxCXZhAdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7b9injSzOtY1ScD1cmPDHuqEynYQ+sZbjMwzBAnS2s=;
 b=B8XXAATIIKvwrXO8ybmz9tIJr/8WVcp6Z3SAcGAYiTwT2aF2ptAZJjTqiR9Nk3tyORo/0tJY0MpE50+dkTfVFDQXPfSyjWduocaJddUe4lIkww/S1bs4Q9jCr53oDLhbU7kin83SuANgzmQpRRLcYAKU4O4i2zop2bUy/uApK8KTiqAp8TLqzS7AVfGC6xMVpzKmXHX3CHh3cHyfzLcDeMbQdzZ07F8/GMgEk8JPUBWAQ1DC2PHBUp5LZw+cn5hdw1DCxy3gz4K9cEe68xq8vGxISTKvdpU9jPZ5MyUftshnqJRsGB2Bll1vwc7Mh1IiV/wugzhHAqI/jevQmxnuTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7b9injSzOtY1ScD1cmPDHuqEynYQ+sZbjMwzBAnS2s=;
 b=skmILIj7AuDKKuJ+mywD3xkt5rq+B+dkcpxmHL4fC2e+flDGBK3Wi6DtRzOoWDQvAkK1OX5HljhPFw4uuoTRPw54pLjT3SdmKW4nQK/OoHzsofjy8Yxc+foh54CT2unsPpfq2GdvvFbM/RWW8NWPWAIGy73cl9q3zSc8t8QjneK9n6SxAZmkKVLyAfldn+wUn1FnG9qBDPtqecvuKM9D4mQgXP+uU9N2c9qSFYKbyMt+EZc+CDOkNKnviz5mFKeWeXWdsDGK4gxMkS8/kZoxNmVayV1zCvZ/MQM4fklg+9Ggf56pB6kuKtd5BLNuKzM6OWSoNhz/Jv8cR6RcyRjjcA==
Received: from BN6PR16CA0038.namprd16.prod.outlook.com (2603:10b6:405:14::24)
 by CH2PR12MB4807.namprd12.prod.outlook.com (2603:10b6:610:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 11:29:09 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::56) by BN6PR16CA0038.outlook.office365.com
 (2603:10b6:405:14::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Sun, 30 Jan 2022 11:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 11:29:09 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 11:29:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 03:29:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 03:29:05 -0800
From:   Raed Salem <raeds@nvidia.com>
To:     <atenart@kernel.org>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Lior Nahmanson <liorna@nvidia.com>,
        "Raed Salem" <raeds@nvidia.com>
Subject: [PATCH net] net: macsec: Fix offload support for NETDEV_UNREGISTER event
Date:   Sun, 30 Jan 2022 13:29:01 +0200
Message-ID: <1643542141-28956-1-git-send-email-raeds@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1125ac0a-4f00-4a56-14dd-08d9e3e3bb86
X-MS-TrafficTypeDiagnostic: CH2PR12MB4807:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4807050A409254E482DC4C02C9249@CH2PR12MB4807.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+zHrfoEIhv7bGbyh6JzRnZkVDfH01dtYKUymAqC8bKZQxPcMv4nZjE4dT7UPBZq3ajPwJ6fpyAtI4UqHvfrmzG7ZnzMEl15+QaQmU222/FWlxOCiL4SRKL81oQ17QPMuMsDhm3jnxTn5wCM3jdvqSNhcGpMUafIjZnXSYouj8tG7pnulgJW3yt9gYQ+/SNfkvajsKq+/Zjb5HSkut3QxUkD2KhSAGshxhceut8xehhKSHvTUCpGxjH3AMa8qnT7W2rlsg01GpXe78u6k8ZWl7VH7MCAfwMzfUphB7d/ZoQOUzkWzzY0KIF8yedWfCrdxz86Zkb8d2qboJQCWs60MfgmczIDmMLG4EwG7Tgwy9CUjwUPc3+7dcDLenG75ZrmAXqjgQQfnDBXUB5pmDxVeZUzb1A2nMGN6BSPi7qVspzl4id0Pfj9/YcCchgkUYbJTMfpRKC4gO4rimXCYuOvMGzZkqNfxTafUxBg1yLHVh3JKaamQKy4g5IF5JgWe1uQMmp6eu0wph7jT+Ej4Okk0l6A4eaJlSOpk6F9DvLWl6GhvfOdC5sQEHOnUlgg/5o5I3vpLyaABnXyHgOaFgwl3jFyNdCpMKTlFngzc8ctfkIgSMCyBMlJXOhv6fauWdMYuWFAMgb50is4a68+C1pWaBX2P+yP6YMFh5UFwGyAKBNQKA0GLCr34hDSwCV6ODQqM0/nf0ijUV68g1fWnaBUFw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(7696005)(86362001)(6666004)(2616005)(107886003)(336012)(508600001)(426003)(186003)(81166007)(82310400004)(83380400001)(356005)(36860700001)(47076005)(5660300002)(8676002)(70586007)(316002)(70206006)(4326008)(40460700003)(36756003)(2906002)(110136005)(54906003)(8936002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 11:29:09.1125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1125ac0a-4f00-4a56-14dd-08d9e3e3bb86
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4807
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

Current macsec netdev notify handler handles NETDEV_UNREGISTER event by
releasing relevant SW resources only, this causes resources leak in case
of macsec HW offload, as the underlay driver was not notified to clean
it's macsec offload resources.

Fix by calling the underlay driver to clean it's relevant resources
by moving offload handling from macsec_dellink() to macsec_common_dellink()
when handling NETDEV_UNREGISTER event.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
---
 drivers/net/macsec.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 16aa3a4..33ff33c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3870,6 +3870,18 @@ static void macsec_common_dellink(struct net_device *dev, struct list_head *head
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			macsec_offload(ops->mdo_del_secy, &ctx);
+		}
+	}
+
 	unregister_netdevice_queue(dev, head);
 	list_del_rcu(&macsec->secys);
 	macsec_del_dev(macsec);
@@ -3884,18 +3896,6 @@ static void macsec_dellink(struct net_device *dev, struct list_head *head)
 	struct net_device *real_dev = macsec->real_dev;
 	struct macsec_rxh_data *rxd = macsec_data_rtnl(real_dev);
 
-	/* If h/w offloading is available, propagate to the device */
-	if (macsec_is_offloaded(macsec)) {
-		const struct macsec_ops *ops;
-		struct macsec_context ctx;
-
-		ops = macsec_get_ops(netdev_priv(dev), &ctx);
-		if (ops) {
-			ctx.secy = &macsec->secy;
-			macsec_offload(ops->mdo_del_secy, &ctx);
-		}
-	}
-
 	macsec_common_dellink(dev, head);
 
 	if (list_empty(&rxd->secys)) {
-- 
1.8.3.1

