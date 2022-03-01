Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D50C4C82D4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiCAFGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A1775624
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrQaEbZLXc+Or49tAeh/2sS8EA37meiaN/Smo3uRd0aqboSLG2SIPySVBks007iDMGjEaEKTHIM3HUfcHaMf+wXCiiSDMCYvoSOeHk5WbiNswuYoywLayDNjVFqXXvWoRl2k6OWt4qFTMlD2cOh7gt3u2CJuVzuMviok2pyGYOag+k1uEx7U4nk9PMq84WYhrwEL5a4lnPvOkdxmzxsoW08lN78RcUeNsTvmX048SFBODzMI12Gm3CSN1wZSlWE/0CBI95tKJP30abu7fIkMJregFITpB2zVq/uISCBynUNAIb/8DNoZTPH06r/3mbvLP4kHKca7uP7qS2CHIKYCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0UcotvqnOF7rrGpgVPOWrOzyGiBTzwvcayRF3Ps7BY=;
 b=jJKd7B20+jPw4fBvhLpuy7UwZjvZmO1S673ebmqTXvyrhiLB8vo60HyjdmRKi1HkXspMahNxHfh/5gy5011HM2mMe1N3zpEA/H96yjjb4l9AkvCDKUijTDgoJyfG0DPi65HkWf+Y770n5Jovxw3aYfDqiE6WeGFFMfyzosRr2VDeH7TIiKqMFvuBlsQoWn+l5HGMsRIVnc15a1r9Rqg+o1+lJT7lb8F14BTeKU2ojH0dUizivi96J3gLCkeshftchGqZgVJLtUFB4msP+ehQBg60KZHtnheyQ/p5Tc39iZEnkmE2JNl8XwgpxoHQdSS4PyUiT3bBF5caIpz66XTpKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0UcotvqnOF7rrGpgVPOWrOzyGiBTzwvcayRF3Ps7BY=;
 b=J8KNAXs4UF7aH3xEqbPqQdYEgnK0L+JiB3V+ymaBRrzmYC0wGYE4Hp/N7C2FbS6qkDZUlmCOHLyv137bxy2I9sd6Fe3nDRA/LLBZo1G71pDj3nPJ6zwSe8tpH33nXgBhy34ukJYsb4tOOKgQi7GeiIMQGC1umIrbowtKG2BQILkbyBGqz/sZTtlVkF+NoHNjAPQ+U/2VXhh3sOVr/MqgnZNmL0zU64BuThvjaTHCcLivZsv4+vZubCzuXw5USvF0hfd2YzP+2AIZ3pTYgC7ib/3b6AjTbSGx1Prof0ytaQx6d2/syA0tSqdJty513G8+B1QigSHWNoahz+uqKNduuQ==
Received: from BN1PR12CA0025.namprd12.prod.outlook.com (2603:10b6:408:e1::30)
 by BN6PR12MB1761.namprd12.prod.outlook.com (2603:10b6:404:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 1 Mar
 2022 05:04:46 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::6d) by BN1PR12CA0025.outlook.office365.com
 (2603:10b6:408:e1::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:44 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:44 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 06/12] vxlan_core: add helper vxlan_vni_in_use
Date:   Tue, 1 Mar 2022 05:04:33 +0000
Message-ID: <20220301050439.31785-7-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bd475b3-6083-4cb0-a023-08d9fb41016c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1761:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB176197A2326198C08EC718D7CB029@BN6PR12MB1761.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvXTaIOMlBQ3D+Sh7HRGJgPkAvuII6ILtGPBldTJFf5pC5lhz+eID5hhQBXqqZFAXnDbH/diYq0eDsdALCRzqcj4Im6CARsceXDosc3rD8gDtfB6wCQP/+VAm+V1JQiZV6rCaxolG1k7ekqDyj76dW7ixthu9SLEwUkK/OXgocPXOWAaSGFLc6f33qaDsqTFwqcydZT+R6VYqvM+EnTcePsfGfqxjFgyOwRLRzJWq+dUl76/DeURWEl8YEYZ1Z/8EFaw6aVIjHqtMQz1t+P5SSnssDUFmQ/RWPgQ5d2o0d0v5nzNNTAIXhSx0TyKIzkfP30EU5M7/5TkiL7uCWQkNnfm2a7mIg0U64DX+bRVHs7L5z/Bxp/lMmCg+GQQKHs7VETPM4fZZXIy0iEcLz+Z4UVQUVVs2qplqatYKMGUaVxyKjcfzF888Jro2erVBT72kA8GEXdAflxM4WFiRRfe8qZ39IdHitUvkv0cGFKX76bku4BvgSZooIpkOKR/rCljkxllYi/SN5vH/U0KgMxFyvcG+1609kjJxNkg2i3dBoO6sc/pXTm7fdVjRxgzSFP0egKJ55PpamQ7e2sY4a/zDW20rB9E2k+WAWQFeYf8bcovm0rz0vz/3if4odVDnnKsFKDuatmIvC7du7oh7uCa0jBc3AzWzwYA4vYNeVFc4JgUUKG3Lx90aVlvW8L3INWumVF8Bl/J6BpH53e0LpxLBw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(2616005)(26005)(186003)(426003)(336012)(83380400001)(47076005)(107886003)(36860700001)(2906002)(5660300002)(8936002)(40460700003)(1076003)(508600001)(6666004)(70206006)(4326008)(8676002)(70586007)(54906003)(110136005)(316002)(86362001)(36756003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:46.3415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd475b3-6083-4cb0-a023-08d9fb41016c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1761
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index df8ef919216c..8c193d47c1e4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3554,13 +3554,38 @@ static int vxlan_sock_add(struct vxlan_dev *vxlan)
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
@@ -3693,22 +3718,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
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

