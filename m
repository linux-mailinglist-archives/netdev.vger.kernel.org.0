Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A509D3E595A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbhHJLrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:17 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:27960
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240121AbhHJLrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKweNDGESlngWO97LYSRuLmPUUrg4WnjPrmip6eNCuX81AOjbi+Mh/EnDcNW+NAHMlgNgay09vq6o3vVDV4jZDisFZX/jSiPL2KiWZROozIitpf2P4MM8fC2fwY3rHfFbPZvnJM/BFSrzK5gEagQ9uUyyXLk7/5ma5HFOLyenqH6RQqn3C48ACY0ehvNsENezfx8EO3CfyjxBZixRHgwE+sJxD5mzYjwQKuy/YA0yxcymp6QBKiF5viksz9htMWQbAHM5490wjfHVtxBs7SAON8mV/YXFCyCnj1QMknU5c3rCdWfcKv8yFLy5o3+GOnPEyyirCfEHwjyWqAa4uR0pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOWPJ9JIrwjGsqY/KrjRI8m9WzSl5Cf6VcnQWxLM6SE=;
 b=Qv+VqWVzROh5lUDn/bzyN0UrzoQhX3ZNlGnNah2xIuMM//OTypcdCL3AlMxKdpitQNYn0EMRL9vvPc5pgTSzWVZInJjizFUPqwfGFydjOZwxj6dbvueRjPAFZ6DcV2Ev4RvdzWDxvyrbnZWdtTNgO3hX7IEH105ZwaxzeJsj84EemMdba4gZxPSWjUWnd0RBjYWpEPR7d5cQPJAfVBhnlOFZGrsoCCoOvdjvrE9/14Wh3IWlrrtUdhRNWA9BayJL6pE1vqMLitUIe5iwWO5mqqhPlVwZ6i3DbCH9bfxk0K/Fnp8wNW0awYOJovnG2ISs3EXfNqt/Hl6pmsn3Q1eJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOWPJ9JIrwjGsqY/KrjRI8m9WzSl5Cf6VcnQWxLM6SE=;
 b=rvRoHxdrGMKf3Unu4u2499mD29OvDU8c7R/51rQf3tVT+jmYUT4FdD1I4G56Wto7wQuk4Xp4d2c7MS5oT/Ntiijh4ppQQ9Up56Pta5zYOk/uHF0R4gJrUp1q5vE4qe3PQbbc1VwSCjs23HcSrLvSKkIhOqrSvK+NZi7wBgQfcuSEFx4j5jH0KjZFy6WFb84ib+VygGLcPcK/rE5MTo00de3Y0P3aqjWGKMykk46p/WsaiHvVRXGe5Sv4SO/0FgJXroOA8OPgeDIh2lHGYwJ/EG5F+W64s/nlm+W1S2YYny6j5hDu+XfkkPV8uLgdaM0Pw2jpCHPCHX1wyY1Okor3ag==
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by CY4PR12MB1381.namprd12.prod.outlook.com (2603:10b6:903:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:46:43 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::52) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:43 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:41 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 06/10] devlink: Add APIs to publish, unpublish individual parameter
Date:   Tue, 10 Aug 2021 14:46:16 +0300
Message-ID: <20210810114620.8397-7-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66a006e9-3d14-413c-0c2f-08d95bf4868e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1381:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1381603596BE3FEF0E891378DCF79@CY4PR12MB1381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBQ6ecANqAYeirnOIKkAoFALGj+mxF+Kw3Wg9BqwwAtXC2QdhNT9as3r/3rYZzxgQdfrTC1uk28B75bJe2JwNoXV18fHJOVkzgcoYpqId9i88EO2GaJsW4P2onzKMp/kLTTRV2MdEbD2fAHQmq99YsKq9Uj+I15OGjRJwELejFMGd+xaf63vFIE3TvzQfSXNYHkIrzAOwnPthCnofAmrk+kqahtrQ+Pdk8F/gahZFQ1tCFg0jqkqtI+KBiEdahZnosvS0Zp1OisBQXmw63M3tLxaqNqJ1M2Thb+T2n0cl5mYOPaO7dZWmopIcozYm9bbhuv0fg85c6HUuSe8RP7Yi7eMRqpmAEXLk/3PvY2cMyrVGhPvp49Ktg/Y6xwtDrRiDAGn6cJUEGNQ4SDWPmwZSbyYSbM6LojcODJbedcrjvCcu/+TsohPbWu9UNRDNkRbfLGzhSPUK+oDZ0sOi9/b2s6Wgz12VBt5e7aJXPLLLZRw09/0H3ixtzfF/LdXXOl7kGHrgH0q4n6I5jJM2AkzccAB88H0DRp3RxaoVcBSEZkCCSROb28zyh51S+ezYD/1OqfPl3fFfwFSq0QVsAWupdYhxrXxSuAO+mjaYWl+oIMDBqcx6lV1Rkyv5DaM1+k2jw9rkZFZaxzmYeEy12ulqUcKU1LJkYZviMPxfLcvinp8DxoO6x9JSTHl6a/pBljPGKXWkeCVD3tnRulshWRC2A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(70586007)(1076003)(16526019)(5660300002)(70206006)(186003)(36860700001)(110136005)(107886003)(54906003)(47076005)(4326008)(316002)(36906005)(508600001)(356005)(426003)(2906002)(336012)(86362001)(2616005)(8936002)(8676002)(6666004)(36756003)(7636003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:43.5630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a006e9-3d14-413c-0c2f-08d95bf4868e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1381
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable drivers to publish/unpublish individual parameter.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  4 ++++
 net/core/devlink.c    | 48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f6459ee77114..1151497c0ec5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1651,6 +1651,10 @@ void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param);
 void devlink_params_publish(struct devlink *devlink);
 void devlink_params_unpublish(struct devlink *devlink);
+void devlink_param_publish(struct devlink *devlink,
+			   const struct devlink_param *param);
+void devlink_param_unpublish(struct devlink *devlink,
+			     const struct devlink_param *param);
 int devlink_port_params_register(struct devlink_port *devlink_port,
 				 const struct devlink_param *params,
 				 size_t params_count);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 629291175af3..ee9787314cff 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9982,6 +9982,54 @@ void devlink_params_unpublish(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_params_unpublish);
 
+/**
+ * devlink_param_publish - publish one configuration parameter
+ *
+ * @devlink: devlink
+ * @param: one configuration parameter
+ *
+ * Publish previously registered configuration parameter.
+ */
+void devlink_param_publish(struct devlink *devlink,
+			   const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink->param_list, list) {
+		if (param_item->param != param || param_item->published)
+			continue;
+		param_item->published = true;
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_NEW);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_param_publish);
+
+/**
+ * devlink_param_unpublish - unpublish one configuration parameter
+ *
+ * @devlink: devlink
+ * @param: one configuration parameter
+ *
+ * Unpublish previously registered configuration parameter.
+ */
+void devlink_param_unpublish(struct devlink *devlink,
+			     const struct devlink_param *param)
+{
+	struct devlink_param_item *param_item;
+
+	list_for_each_entry(param_item, &devlink->param_list, list) {
+		if (param_item->param != param || !param_item->published)
+			continue;
+		param_item->published = false;
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_DEL);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(devlink_param_unpublish);
+
 /**
  *	devlink_port_params_register - register port configuration parameters
  *
-- 
2.26.2

