Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D017EE17
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgCJBnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:20 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbgCJBnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFpiZtL2kzS6STVCxExdcQE5qyiFStG84S4tRAuOfBi2PIXsjHwphGzfueuPT6gYcJev56o9fbC/fZsOuHEyHskms6q8XcdedzuAGX7vUFNSzxd+mNNlbcMzs2O3lb9PmsrG/cwmOXouUW2kho9+KTTYBzgppmVWIbuAQ/osxK9IPQGfTa43IkO070FP0yG7HyBw2MgjqhxEXj2KaZigBfoR0eTotNwGCkPkol5BT8gRRcGVzAtErA4c0WbiuxNemRmloLC1lAwvvjqVwhDztzN8aoArAjvdsX1RwRA1WrbJ8U4cLIRXpzUndkfJvMrdHNX7SZz7N3kulqaQbV0oHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jIDVpBYRdHajtKUasT+63QmgmX184tx2zkg1MURp2k=;
 b=A6ECy9e+76NQtFLjlUm5URO2QJOlxaKNK/kNEje1G23xbOirCuLzQOTf00WqAp+uFie04cigOGtBMFQkB//M8m9LYlFsyyaQnKtiLHOJm3w+z1COjlY2KvptrFxadMeD9SRoE+j+3WenkcgdqzEh7eMeG8lQfnfQJPQmTA5Q9hPbwYqdSBTVfo5VR4edN/obcA+AoAd2wKJRDWROo8+rDwEoxaE9sRC15OQPxUvAtrIIvgOqelQIcr+78rkBGwrWc/kbPhg4XqvaZUrOVY5CMKd+abgDowMGPK0J9/JJdBNFrWsUDVINIZT16vePrD6e3LALaH4AUV6NQ/fGR96eqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jIDVpBYRdHajtKUasT+63QmgmX184tx2zkg1MURp2k=;
 b=HKbIfDSOWqDwE3kmo3QEqhEzYNI4allkx3dbVJ3h8425oiVjBL3x+Coh13HijeGLT2UJ32Hi6kSTdft2iCpG3vt0kuP2bn7hIKJX5mvYbFODiEJBMpvmGoaZuJpellW4SS4wBJSrvXsnhlrv/9ROSpXMWXRZ7dm4FywfIqUtrgc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/11] net/mlx5: Tidy up and fix reverse christmas ordring
Date:   Mon,  9 Mar 2020 18:42:37 -0700
Message-Id: <20200310014246.30830-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:06 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6a1afdc-6b6a-4e05-2eeb-08d7c494622f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55330CE166B345F9971DE348BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+c6QeWl80A9v9SNnXhGfrq1DAOb2vGDJ9lwm9bGSUrOSl+UcXSfwRNZDatZeb+5Jm+5cmu29UGfV+SMEVegPqlJS8/0oEzsSc4ji4wyYFN/I34lnFQ4OQYV7qNZgxWTYtDYUMzxwPeePzzYfEQESj4+lFHz7rPdACigepRQuR36o8hGWNxnFGWMIgrpbLmVCvSzkj6YGz0Pz9OIt1Zsgay51RICR8IV2AGeRqvX3acx5q/+qrcr92bVF++Jl12F6O8SHpi62cTA+PkaSAGDwvsnk/VuDO39fhSMvmqzEJpHEa5vo0QS6V11OtLlf2fg3qL8glfqcb4RSR1YQbZOHC3Tku+OzjFPEgEdpX/WNiHUYgK0OmNuVinDkNgLgUyLBAlod5jW/cJyYnW3rALo0xLgDG16k+S1noMdbEYidMsJrOOgaucld1rdSpGmIk99Y2KOsV672WDGL0Pb4azquhUpCickvO89hGGeNFunm4QSGkoQgyhRp2iG0owVwMU1NfOeAC/F2MbfPnRcGQCPrV8T1hlUGQiszIgJ2OjJd6o=
X-MS-Exchange-AntiSpam-MessageData: hHsJDO44iFBn5RW4IqjzH0Tj9roDj5Ye6y9kgAHXi/mF5MrHHxX8gGBqRhaYhY8svncH7JFI8ITYXdPYNJcgLc0fAnF7lb1t3D9xVk8N38x3YGlCYj7DKBkMPtefOdgHpjkzNQnXNVsh/+oPg3TozQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a1afdc-6b6a-4e05-2eeb-08d7c494622f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:08.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2gU4t0QGVQ+HUphchbGi6jJ9sKhqteMpbLU/yvJO82P9yBtQyejQA4Adu6kKwx/slZ/aCPQIbvbbC85bb+9xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Use reverse chirstmas tree inside mlx5e_ethtool_get_link_ksettings.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f4491fba14a0..4e667608bffd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -877,18 +877,18 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 				     struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {0};
+	u32 out[MLX5_ST_SZ_DW(ptys_reg)] = {};
+	u32 eth_proto_admin;
+	u8 an_disable_admin;
 	u16 data_rate_oper;
+	u32 eth_proto_oper;
+	u32 eth_proto_cap;
+	u8 connector_type;
 	u32 rx_pause = 0;
 	u32 tx_pause = 0;
-	u32 eth_proto_cap;
-	u32 eth_proto_admin;
 	u32 eth_proto_lp;
-	u32 eth_proto_oper;
-	u8 an_disable_admin;
-	u8 an_status;
-	u8 connector_type;
 	bool admin_ext;
+	u8 an_status;
 	bool ext;
 	int err;
 
-- 
2.24.1

