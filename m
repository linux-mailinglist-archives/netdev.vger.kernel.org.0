Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2AB4BCEE8
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbiBTOGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbiBTOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639A435855
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBKv10SrqiW4S6FKI80L8tbq4g+ffBHjELIf1j+wdgGPtxorFEkcCWjQb0jEvMV1HBL3JksIA8LCYQCHm73Di3VkP6ZHdAcVvHB9WuaLO0l+w6KCpWXYnJOj15/iMxiuvyONqmyrFnSwQQk2iQ4I8lu4HkX+pKCvm61CPqqs6g5CkcKYVnyxmRjpb93CLCTSJu6baYWBR3zVX5QULdEGRqBmUFHmwGTReqmbrBCRQ+lA3xFtlRmW2bI8TKdinMSGNvuK2l7auCM5fc8dGSEuwwr54lbmVjb4JKGoXXeb6RjduNNmdubRrmiLsgEvqCKRMf44LpFN4aSkf2czU/juPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5WdV078k84LEE3H6bt+luJwjUAdVA8JEy4XZ6xWCWo=;
 b=Wr6LRxxctJ3wB0xk94A8lsJ2KJnY4yXhalj512vuB+epmluoMfzSwDBvuVm5wgf8FU/AbwBzQ/QsZ7NA6Y5+dtJJay19iRMZyv9iv9PJgkTEXKa7JpmlTUqW5jBeQyI1/aT3RetwBtBUYR+PXWB1HiBM773WZucNRWitF1wZPFiQIOTssWOmvQ4wz0nSTLsQAnGUvj0JOnxz2qYT86p/Ye2qw3jjyXXiOVwPg4PU4dTmYUfu5av3sVNObeJTHcy82aWdUbcDwpi5Wa2tsHEWVrBhIKBeZdQ0RG+J6xXfJIUExacAaXP2ETzUMsrAxuwHoFKjn3O6HLTRn35ohv8/cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5WdV078k84LEE3H6bt+luJwjUAdVA8JEy4XZ6xWCWo=;
 b=L4R2amxK/bfUy4fPOZcsD2ZcUs8tP/QXqK/RKF99rJMlveaPucrR1DEl2nAOdtq8UBNuRC2UVhSylh3I6Hp35KrpKBfDWhPhJJ9QBG/QJ+cFfpbYvZngXJIirsjj0p6U3NexGuSYI01GyCSQ3XgCUl2od22kWSAc7ahv8CAoRVomjb4QT7i3Ns/Z/3gsIqJQcL7/H1J1PiFJf6+x/YNxZ3JonudCOUPaRuvmVJ+rI0DfI5TPz213mUM1xFL2H+EzZZdCSpDFKL3pF3kkTWXApsVnyX6expJzTeMqE9Aj+WjKCwyU22YxQU13b/FhoSftb3RZUO8VKo3QXaurAhzRIA==
Received: from DM5PR07CA0115.namprd07.prod.outlook.com (2603:10b6:4:ae::44) by
 BY5PR12MB5541.namprd12.prod.outlook.com (2603:10b6:a03:1c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.18; Sun, 20 Feb
 2022 14:05:38 +0000
Received: from DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::25) by DM5PR07CA0115.outlook.office365.com
 (2603:10b6:4:ae::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT065.mail.protection.outlook.com (10.13.172.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:35 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:34 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 05/12] vxlan_core: add helper vxlan_vni_in_use
Date:   Sun, 20 Feb 2022 14:03:58 +0000
Message-ID: <20220220140405.1646839-6-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e41cb037-4bcb-447b-318d-08d9f47a128c
X-MS-TrafficTypeDiagnostic: BY5PR12MB5541:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB55414184B81A47E7D38A3F07CB399@BY5PR12MB5541.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N7EsasroRn0lTudXzA5wsAHdG/DREkJ7oFb8+BQfMM1zDeLKeB0PlZvW+MLi16chjgyJ1/oZUUnXWfotV7abDrcMYSwQBo0wtLg3AzfBvtNvYkJj/lbPgHSrofquEAmzLuZJ/HtnCXcaPqJg3rihq+zKIeGVYmUH1cs1bQ0TKZVRvIjMzT7H0xJybMPsRVajM5Woz59BJxe738b5g698X5zBBav6BiftQ8/zmZ28kAV8Xdow/wOr1jirvkGWSzz0a//HnpMQ/I+BnkO/cLMHLvgwYhLFJrZWonrY1BZYJtc+SBLiCWJIghXBwuWEQNdMCJBVbYeMLZRULXqUODdiZmnrPhovrTIzmz2IUij4RwcJNLR0UnQv0gEiduYXanEp2x600Pph0ZYf6c78ZQv4K6l+pWBiRcneyOBGO6X3rQvBTaSqh89YJU9qmk28/GjA6M12ZgCg947cuJNjxsRr5WAYLEBwOvMtC9q5DX8wLqUM8iFAzTeCep4/e2TDiRVj7a3zvZNl4iMPmjR3xGY+LxfrYBKWsbDWvAbCPWWEuCeE7ejbOshJssOGoFSb5rPIFR68OznjJ8LTHtJiKCJeVRIMksmthkd2xj3mccTO/NxuRW2GDdnqT0Gdte9XQJiLN6ySHzyBPAscLQyJ/TKK8LrI60xJ40YG7OprWcZemHYs3T4o38u/yI9YHtYYDCLWpmkpojYFjgp2P8iOt3tInw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(6666004)(8676002)(70206006)(4326008)(70586007)(54906003)(110136005)(82310400004)(508600001)(316002)(86362001)(83380400001)(36860700001)(2906002)(1076003)(2616005)(356005)(81166007)(47076005)(336012)(186003)(26005)(426003)(5660300002)(40460700003)(8936002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:38.2751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e41cb037-4bcb-447b-318d-08d9f47a128c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5541
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

more users in follow up patches

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 46 +++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 3f3e606c3c7d..d17d450f2058 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3546,13 +3546,38 @@ static int vxlan_sock_add(struct vxlan_dev *vxlan)
 	return ret;
 }
 
+static int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
+			    struct vxlan_config *conf, __be32 vni)
+{
+	struct vxlan_net *vn = net_generic(src_net, vxlan_net_id);
+	struct vxlan_dev *tmp;
+
+	list_for_each_entry(tmp, &vn->vxlan_list, next) {
+		if (tmp == vxlan)
+			continue;
+		if (tmp->cfg.vni != vni)
+			continue;
+		if (tmp->cfg.dst_port != conf->dst_port)
+			continue;
+		if ((tmp->cfg.flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)) !=
+		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
+			continue;
+
+		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
+		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
+			continue;
+
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
 static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 				 struct net_device **lower,
 				 struct vxlan_dev *old,
 				 struct netlink_ext_ack *extack)
 {
-	struct vxlan_net *vn = net_generic(src_net, vxlan_net_id);
-	struct vxlan_dev *tmp;
 	bool use_ipv6 = false;
 
 	if (conf->flags & VXLAN_F_GPE) {
@@ -3685,22 +3710,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 	if (!conf->age_interval)
 		conf->age_interval = FDB_AGE_DEFAULT;
 
-	list_for_each_entry(tmp, &vn->vxlan_list, next) {
-		if (tmp == old)
-			continue;
-
-		if (tmp->cfg.vni != conf->vni)
-			continue;
-		if (tmp->cfg.dst_port != conf->dst_port)
-			continue;
-		if ((tmp->cfg.flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)) !=
-		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
-			continue;
-
-		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
-		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
-			continue;
-
+	if (vxlan_vni_in_use(src_net, old, conf, conf->vni)) {
 		NL_SET_ERR_MSG(extack,
 			       "A VXLAN device with the specified VNI already exists");
 		return -EEXIST;
-- 
2.25.1

