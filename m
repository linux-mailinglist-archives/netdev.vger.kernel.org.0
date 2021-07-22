Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1373D2270
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhGVKYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:44 -0400
Received: from mail-dm6nam10on2064.outbound.protection.outlook.com ([40.107.93.64]:19866
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231724AbhGVKY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH2obv2QdaLnrC4Y4W4Gpx1THhSXDWrky884BohjaWOYvXZq/DYJ0tc0EEXUPEBKpgyWZXFp61PKLAxN1teb2txmIzHwkD/kLMFbsZpd7eERpLSPWZhfjturKSR27oIQRDbRrJ+ZfyUO1iWUZscZBCut5BqZ5uLKe/AFPGbzs84Hx4Yw8TAMYHpL1RiumOsy66OotDtA3CyK59boYkbu4sezPd7eDVGvQM7D+QAS3oQaDO+1aBt0JDiHcjJnOwupPJprnHavwD2OEs/HoZ25QItkJjrZH71X3KGHXTZwEKQne8EQg8lRl9NG1qWV6z36y0p6pVgbkQUxm/M8Eh2Xrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TVpBQt+V6f6hp9z2D2qjnhFtrl+F5aIzj80UUbtCE8=;
 b=jREwO5MxuN3QolWJ5IdAOaMaicol0Zirn8wOPdxurzPdUoDdzYdHfE4XPObtUCKY9Leo0m/SAcrzaYOuLas6rsVVYBHQmA0AUEl2QRcWmZ5syIY5s3tWl+WunIfdw0a3vBfeSMgutTO7SNgyRDBv4aSwoMp6Tz3V4gZ7d1GbshjDTW10NIaH0vPg0n9JUj+3Yk/WBWqTB8xw7bJzcHFyMuHPs//oe0eCyeKs7zbBu+7AnzxUainmI7NijG3uy1jXjcFGD5qb6uYOQTyxJ9C7qsfQK5R9qYwOnwhpD2d12stZuLwzVqhdR0+fBuz5hlOf6op0/5gJ/FVfQIYnFP15Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TVpBQt+V6f6hp9z2D2qjnhFtrl+F5aIzj80UUbtCE8=;
 b=tTGvVRvNmG3p3JwsilM/ZfGLD0G7AIR+AEbh4gr/mLUQzMkXrMVD5zPGUYgveMMyFdJIZyCRuPOi+8CaCimN/FgsbUN+Vu5Q99QXTLXp3WZ/Ghn9DNoM1TnjA8POmQJ0G3jaBjaUX8wm5kQ2IK+RJ1WmMfax0JvGFUo3JfLKWgd4nvIc7XRmpldxtbFjvoQyyCSn9zKLCZeJgrxjCKndOhxhA/LCR2mawQNxMORiwdlSKlHVGHpIBS9FqxZen0Y6nFzlB82gj4+3Nk6rhLWxQokgt7KqlZ2H2d8U0eUZaleh43MOoGjQhxckJdvytZEcyRG6kPRQWqPOzZpyFJLHCw==
Received: from BN0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:408:ee::33)
 by CH0PR12MB5139.namprd12.prod.outlook.com (2603:10b6:610:be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 11:05:03 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::f8) by BN0PR04CA0028.outlook.office365.com
 (2603:10b6:408:ee::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:02 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:57 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 10/36] net/mlx5: Add 128B CQE for NVMEoTCP offload
Date:   Thu, 22 Jul 2021 14:02:59 +0300
Message-ID: <20210722110325.371-11-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c10297a-77ae-4b6d-2fb9-08d94d008ea5
X-MS-TrafficTypeDiagnostic: CH0PR12MB5139:
X-Microsoft-Antispam-PRVS: <CH0PR12MB513987865A0A6AE9494C2D60BDE49@CH0PR12MB5139.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1gTRRqd5+vqWY/zgqd7T4VfOyKJ0KCdxHCpNBFw8TOAZBoR1+PKgiuhF4DyYqFUwdpU5EsJ5aL9q5DMHfL+1uLmNSsqUAZ22gUXkt7cZ05wvtrMMwjoidyM8RJyrGy2r1Dkqypk9ULWMIs4k+raIlvn+QzOfDnYbQ8oYHZ15G8JiVP/DX87Ue+lnuoPG39tylODT8HrmDQX5Lp35FNha7/qTx6LjvwHwFq6Jyc3PwmQAv9ma/zvVsvlJ6tgxrPUnPU8qHsJadh+/H+d/lepkDdQuDzaBiPv2cA4KmszchNrnoRy+Q1RfNaL6SDj1WvXpGLFsTF5VaH+SHfVNnLqmpgiGEFWUENY1/OfG61w2BCsMx593SIQ+zNZg3kmG1fNGzNjlpom4DuFDftkfitgpFY50zRYpE01vdjR2ITfx58wF2mJoTcckz7sIzdq55GxHt++hgOjN6yEkvDnmf0OQRQgXuMLpQxS13X2L9eOdmaxAsTjXrfvqlp0dDHULLiU3fe47G4BXx/VOITzZFMsJNtCaJKIgyHYRYYVLevPd17/aaSoaEweoJ693ql0wll6zssbq++e1yNFdfg5GDZWTlqas29vc+40DjZA1XJFsoETZ0W3Z2ozBTFiscxfAF6R1gDN/sGWMq473/B6nWTqfdRj8dWWpn+zhYTbrjP90rBwkbt6sth7aXg57AaGtUC+sF4/hvFg1hvf55Fwo4zwQEPwqRBS1w/yfBLGWzvocls=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(46966006)(36840700001)(478600001)(8676002)(36860700001)(83380400001)(356005)(47076005)(921005)(36906005)(316002)(70206006)(86362001)(7416002)(110136005)(54906003)(5660300002)(70586007)(336012)(4326008)(1076003)(2906002)(186003)(8936002)(2616005)(107886003)(26005)(7696005)(426003)(36756003)(82310400003)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:03.6226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c10297a-77ae-4b6d-2fb9-08d94d008ea5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

Add the NVMEoTCP offload definition and access functions for 128B CQEs.

Signed-off-by: Ben Ben-ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/mlx5/device.h | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index a42e47f91327..412d0982ee46 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -794,7 +794,7 @@ struct mlx5_err_cqe {
 
 struct mlx5_cqe64 {
 	u8		tls_outer_l3_tunneled;
-	u8		rsvd0;
+	u8		nvmetcp;
 	__be16		wqe_id;
 	u8		lro_tcppsh_abort_dupack;
 	u8		lro_min_ttl;
@@ -827,6 +827,19 @@ struct mlx5_cqe64 {
 	u8		op_own;
 };
 
+struct mlx5e_cqe128 {
+	__be16		cclen;
+	__be16		hlen;
+	union {
+		__be32		resync_tcp_sn;
+		__be32		ccoff;
+	};
+	__be16		ccid;
+	__be16		rsvd8;
+	u8		rsvd12[52];
+	struct mlx5_cqe64 cqe64;
+};
+
 struct mlx5_mini_cqe8 {
 	union {
 		__be32 rx_hash_result;
@@ -857,6 +870,27 @@ enum {
 
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
+static inline bool cqe_is_nvmeotcp_resync(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 6) & 0x1);
+}
+
+static inline bool cqe_is_nvmeotcp_crcvalid(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 5) & 0x1);
+}
+
+static inline bool cqe_is_nvmeotcp_zc(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 4) & 0x1);
+}
+
+/* check if cqe is zc or crc or resync */
+static inline bool cqe_is_nvmeotcp(struct mlx5_cqe64 *cqe)
+{
+	return ((cqe->nvmetcp >> 4) & 0x7);
+}
+
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->op_own >> 2) & 0x3;
-- 
2.24.1

