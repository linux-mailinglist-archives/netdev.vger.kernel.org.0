Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2BD3E5B6C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbhHJNZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:13 -0400
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:47584
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241339AbhHJNZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtlyHD4OEbAtieImnflqsbswcaQyEFtGOfkvBswMa8zolIfWXwBQfe3g/ehRUPERmRToyyV3k74b9jD1ehHivWyCnM3O++OwzvX8MnKBLCsvBZgEUg3Fwuoz/D88DYWZ+TM5lOvOkP4FYphbys2KvAVM+jcBAQjZsuwGYz1aSDz3Pkfi8zvETwofclSI8nbkbGwvtOOhWvBdVrfpFwqFSNftyguw+7wvPH8Z0yAtjm/X2F/zOujtpURuONJXJSoxBMjOzD7pY6kCCHLW6l2JELIC1ti7VlGDLTYg1wUeIK+7VVgrpwiW59dn82l4QNR/oXumMYYmI+FeHxrPeKfCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4TP67xCYbvJGydxqx01Hd7b5IUy0HkbZU1Dxdmel6g=;
 b=d0JTDdzXBj3iHFi08U9wDpWgoZ+GDheSCvtyVva4YI08IQp2xCO/GC+WVZkLJoOJnlOHwOUL2YrKXfob6SSpvtDSDe9Po9VEh/Gmi1vqlgNGIYCeRPmNKwiemHLLiruBChnYGPzZ1zeqHsjbLRQyAcKLL9I0VvnaJqUx07nWI44Ct4DHJzEw3f3aOyyMrYfxvDZR3aJ5/t/RpbhKNl2MoGutQ/+8lC0lOnthFPZSc90eTk16h1/jKonKY2WN5su06wOWSWQpbAWSv1Rn16VvXDfy0sjNv+duchU3M8udPilWSXEjsD7vzMJ8+2p2G7xlsTbqFW0TC1KIT0hHgLSQbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4TP67xCYbvJGydxqx01Hd7b5IUy0HkbZU1Dxdmel6g=;
 b=evG7CajBgkbbQT4lnJ2mUP97NvAvVWNxulOOcd1fCDKwUfOgwfwSlyuTsZz8+nfx0fFQSN+7RjYTY/+yfjaHDazE4118F0grMHncoL6s7p+cTKyL96pa5gN/XOzvoRC45XGUOJ8iPo3SB7BlzcibACp4a1VHs8/BP4/9HxN7ZyCSIwP6ZfSgtqGk6SbO55AaSyXK2JphWBKtnODRy5RIq4eWyH1daER6S96qaMDcJjYgPNcPwN6AHA+MsgLuazCPwqp4t3Kw0qDlD+1YBxt/n7ojrExaTvkEOmR2t1JEOIIbgRC7Tyg62u78zxeUpVWguwoXRw7bdnb5NKtaahnDqQ==
Received: from MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30)
 by MW2PR12MB2393.namprd12.prod.outlook.com (2603:10b6:907:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 13:24:40 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::1c) by MW4PR03CA0025.outlook.office365.com
 (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:40 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:38 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 02/10] devlink: Add new "enable_rdma" generic device param
Date:   Tue, 10 Aug 2021 16:24:16 +0300
Message-ID: <20210810132424.9129-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
References: <20210810132424.9129-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ef2907-353d-4187-3181-08d95c02354d
X-MS-TrafficTypeDiagnostic: MW2PR12MB2393:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2393DE247874FFF96E984D3FDCF79@MW2PR12MB2393.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbRxrR5i0hSC+V3iFdGfsVlqX655xrZuPmL4quEy84Q8WeCUfCYhzAwcODmVB+684mv8hn9T7NC2KPuiYUpqlBossFHsWip2zMsxSQr1vfBJGPe0Hpe9PkbqU5pXf/+tZCNItCyObk6/Yq+NHQYD6kho/UkpJG4bjR5wVuksuw7JhhDRotybyFQx3uy2zpRfMV9Rly3w60LTxNRqn9tWlSlwpNwQSfKlTlYapsF1wNWNguWVv5R0S1bmC1/n+alOdTwDT0hKJwCXsm3Xi7nJx+fSpnBptvx1H9J2RUf1EyG81mwVN8PWXssW71E/B1FKLQgBwllY+ecfUHrNCMrh/sQGkMaqeCl6e+HPvIpKaPwq8UVaABgw1A05sVIzJ0repScidgg2tFhtUNUTe4VH1v8E/f/FuBCB94DKmAz0pVtMbAXj1DgmAEchuBUppfTZ+/8I3X7SEkttxVKuuPnt0JLn2wREYVR+0YHX/LShF1aKBQfzysxeDOJTzIVF7SdRw3MEZsLnH8dMdYIl2LZAH9NAtKDIn559eyobtHrplZ2AX+lKkVCRkmJue+/ssUTTqJ4wps/KUqes4Sa8UfpfmLviESPDCdqS7Ziw+XrCIZqQoeUOy0CbOEzKwBBnibnvyndh4pIsuPFrcLayd3FpA50kMyv40fFwMXRrLMT0O8uK5uVlXbkOTncMenVA71Uswe9lbUR/zTNhqe+hzu8T1AEKogcqTrqngS/xUoPTRZU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(4326008)(478600001)(70586007)(70206006)(36756003)(107886003)(82310400003)(47076005)(26005)(82740400003)(2906002)(110136005)(7636003)(54906003)(1076003)(2616005)(316002)(86362001)(356005)(16526019)(83380400001)(36860700001)(186003)(8676002)(6666004)(336012)(5660300002)(426003)(36906005)(8936002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:40.2407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ef2907-353d-4187-3181-08d95c02354d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2393
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

