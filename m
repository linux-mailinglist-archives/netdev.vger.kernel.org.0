Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B093E5956
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbhHJLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:06 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:27233
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240121AbhHJLrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUWtkk7HTzpBeOX48syeC4mEW6OJ1qBD4ZCNPniz6y/a2Co+5h9CSK7aDl6hGqN1mV09PLL6LxxVYid+QuFimp6LMjdyQA8it8hn0kW6X/LD4qc6xUL6Lxiw7hEkYiAQSM6UqLIoJ3DLAKu3mL01KD90hMVTzumTbRRXg+dHeC7KeRyCgFyBaswSE5wtkLds157eoFi5FHB1Ix7SBKwZb0zwvw+G6S1BNeR0Gru7a5Cnorv/6QpYQyKNEc+VYe5Z4VIN3u1lF1+HKItNoQFFvWmJG8QlR938AH7/oZ3XT2YxKEmMqqGsMSp7zIeHB+ywI2Tu6kW4SosFgMVr0U88cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4TP67xCYbvJGydxqx01Hd7b5IUy0HkbZU1Dxdmel6g=;
 b=Z3KWhDxvFrTFq+wxPAVWKAdA9/tPCgVarg3n0X8pMgUecHKkiUfObmBYsREDnasE3tsl3XRfWPMv6qAGLiV8Cq6WFgIXhY4PzaQh4Lowsaczl6CfAR5jwtskA7VzgRIuQGPknBfZctma7tU0ShewZZMc10GeLOehJLXpH0sh5h9rR6WAIv8QufapQ9FE//75PR1uXB8GcJHDo/n40znGoCxeRzR0g5rR/xRjPMIsDOnDW4oABsvqNJvqzMXwJU5j/j8pXx0SEsacGLO0jMigMhok5pzcWk6PgsyKbsrJk9xVBYBRCh3nrx94jChhwklgSmTj8+UyOrnPleRb7dBQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4TP67xCYbvJGydxqx01Hd7b5IUy0HkbZU1Dxdmel6g=;
 b=rOdQEr6zAr6AydMZhUqi2ctMtY+qj0zg1R5CkIJnfhuxGPCkofx1tUTJF/cdzEJC1PxTyiR0OXuK4bf5af36v0lSuHMHpdv4PZtDZkONFGPLlhtAc0GzAEonDyHyaD0ZWlBXssh9ByaufUQFxVVRhD2eXaPkOFjxiqcPU27OUvSd/IY3MWfLFqWiHpYqjX2XnCSYckW1Bgbxb6jiNaedf3PYeZP9kITbzhH0zudFQ2ooahPiQjsCWcnHEUiXReoTu8iAmcMfK8HGK5MC00ajWu8ip4Pa9kENNAwjuEoGWqEYNL9XdsQD96UdMBfao5hXMpBHJpil4Q4A5ixfyib1hg==
Received: from BN9P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::9)
 by BL1PR12MB5046.namprd12.prod.outlook.com (2603:10b6:208:313::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 11:46:40 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::39) by BN9P222CA0004.outlook.office365.com
 (2603:10b6:408:10c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:39 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:38 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 02/10] devlink: Add new "enable_rdma" generic device param
Date:   Tue, 10 Aug 2021 14:46:12 +0300
Message-ID: <20210810114620.8397-3-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 263b60d5-d122-43ca-a42c-08d95bf48462
X-MS-TrafficTypeDiagnostic: BL1PR12MB5046:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5046D6BCC6EB72F6023DCA98DCF79@BL1PR12MB5046.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsWHGpzq6deRYBYDhiswpMDDz/Y1uyQ9Dif978BjJDMYeJgRJA+KX2hAqwEtE0b/PMmciDrrpEZXNMlTUF9eNKlivrhdjPKmb8/RnOrsupkrCN6/dNUaURbBTlU5TDj/Ix9H2zZtVXGma0LamO5H8G3enREMZWHS5KAZCAcnd6mHAT3+fnvS7L+Pxfg5qWgMwKxguas103xq+AcLSu26xyojTS2xq6R0BPDnIfiWxX9vU218z1B4hQ/1FxB/mC9QgS7Upnly9DMowEmlTyrW86kSrfQNxuaIj7uvjozoLXES+P6vqKqFIH7hIyNcnaATPsZWYb0S5kwWvw6Rsjg7X90YdQpei7jisroDwCkB5d8pOmJAYv2JsfnzWemecA8uTFi21PLwHARgzpyp/NhWlfuV+NNgHW63fbhlWFocy8vPjI1CkutUcMii7tn2WKYexVKmneZ5yt5UX3vMd+yMxavmw3Zj6qw9SOAytWplrU86LpNbFjNptXxMqZSAAw5kOM2aWVaj8Zbo47566eZ+YOedgox3BavFiNxzQgx/WPoOdVJK4ke8rVuKmnhFxOqnSkD6fo/bhOocNcfteKZbEA11MChsVKRYDj/atg4JWff9BcX8XiSLWn+rmfr94ZAOEyoedS1w7Osd9XlAixN1xTRzluSOqG9dYXAjktD+3qlBZWhkmUmQHMHohx6OUAS0L0DgZeNpCKB+UNUuQwknOBfJixGsZzP3naMhJnYVOis=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(46966006)(36840700001)(107886003)(2906002)(36906005)(7636003)(82740400003)(16526019)(6666004)(8676002)(316002)(186003)(36756003)(110136005)(4326008)(83380400001)(356005)(82310400003)(70206006)(70586007)(26005)(426003)(54906003)(478600001)(86362001)(36860700001)(336012)(2616005)(47076005)(1076003)(8936002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:39.9311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 263b60d5-d122-43ca-a42c-08d95bf48462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to enable/disable creation of
RDMA auxiliary device and associated device functionality
in the devlink instance.

User who prefers to disable such functionality can disable it using below
example.

$ devlink dev param set pci/0000:06:00.0 \
              name enable_rdma value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create auxiliary device for the
RDMA functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 219c1272f2d6..a49da0b049b6 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -101,6 +101,10 @@ own name.
      - Boolean
      - When enabled, the device driver will instantiate Ethernet specific
        auxiliary device of the devlink device.
+   * - ``enable_rdma``
+     - Boolean
+     - When enabled, the device driver will instantiate RDMA specific
+       auxiliary device of the devlink device.
    * - ``internal_err_reset``
      - Boolean
      - When enabled, the device driver will reset the device on internal
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1e3e183bb2c2..6f4f0416e598 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -520,6 +520,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -563,6 +564,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_ETH_NAME "enable_eth"
 #define DEVLINK_PARAM_GENERIC_ENABLE_ETH_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_RDMA_NAME "enable_rdma"
+#define DEVLINK_PARAM_GENERIC_ENABLE_RDMA_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9a59f45c8bf9..b68d6921d34f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4282,6 +4282,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ETH_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ETH_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_RDMA_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_RDMA_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.26.2

