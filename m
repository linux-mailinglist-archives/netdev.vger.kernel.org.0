Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6521B7F47
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgDXTqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:13 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729198AbgDXTqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZOEm145LLNWbKGS3/E5GZPV1s/dKcQi0n20ub8tRoI5/KPLqFTWonYnTEHwi/Vhd0aqDgTqFvogljeplOVIWM8utNvNkpKgkemve0NvEE131NToI9Cbuu8gBYK37K5GVJiSLTukyiKnV2Uf/FYJNTS4rQ9VTfDT67nZPFnVD5arJ1Bj6J4EUbt90Q/DGrSZb15ILBmJ7Sm2xvt+1bw3qylqMgEa1JeHJlQRyWmhJG1okntMRdH6s6bLM4/Z3YDYOk6e0PT7I+CHV+I+i9os8v/yLunlxrtf+Be34QNddxUdDMpfbNoeI55usl/Uei/LtAFayvwIG195gGfrdOdJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3g4qVwpZ6o5t7fM1e0WYB+dM1B1DYCfi0O8RDyY9DE=;
 b=XtJxICh6EM+HOKE037YjMAbTWFOKvgN3pzbuBG8Sb+5tHcwx3s8zomjusiG/LNqMNp9kBaouRZ2pyHxvdq2gPGuPG+Lyr+ecOBG5PRq3Ws3Ls/Kqu9yh/y0S1KScX2yAWc4IjDZozchKJN75G6/X9Er2sJJ4gAMKP6ybKPfI+F8Bqc7jrRvQJIPebomt1pwQp8Y9DNtBFYqavebGqKJk4/2CteXl2J4NQ1Zkgt4m8gvZupNrwFUDpPGhugNGs29dvpfsUOrpxEEnsjJ7o7NwgEYTVHW8LVOt4YutZaezL5NJig56btZOAPisiP3tE8MIVd07TXb2mOOvaDdOITeJ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3g4qVwpZ6o5t7fM1e0WYB+dM1B1DYCfi0O8RDyY9DE=;
 b=Mz6STkeBk73E4o4OKJTbMjXBewRDELfZVu9fKU0ur8J58Ak1DbXMs05vKEW5KlPK81aSbzw3G2XQCLC+BPRhCexKoThDqh/4XxLV8ldHQW79HNjF83XbaMyrrcmwdncHZhdbiuLyQEq8A1ZP2TGPSmnoCAzA54rjKGzku4XdP9g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 6/9] net/mlx5: Add structure and defines for pci sync for fw update event
Date:   Fri, 24 Apr 2020 12:45:07 -0700
Message-Id: <20200424194510.11221-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:47 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0314a83-0235-42d2-30fb-08d7e888165b
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50727C431B6F06C8E9D077F6BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:82;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(15650500001)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvPxjlSP9qdTxyUuilalENh1hXmzIac+7QQ/U6pHTFbxB6bW1TT/Q7qNPd+2kO65zT5pgW33Q9yh0U1qkWhfh8p1uyKpo2bdChQYzbyqAaMGaS1iatvHHFPF8wo/V6V023NR4QtnXhKLrZGfz0tOVOp1nPGJ/wPB7NXLGG8VJxMhopjEOUEeYGDZfy0MXkakGEO9qkBTEghW+H3A0kZHHotP4F+hLHm9eeJYzOFiNXYgCAKPy1Uu6UrrBdwqhWegHjUZU3c3r+ODf5856iEm6PhxXdz9nsacWFevKMTLD7oQY3OueduMMgPfPRlv3S/Bo73mp691ipowjMBnP3AsvX4SDIxNUMv13RwMsM6KUtvjat0quf9xqhfxNaeTUIU8OIcHVCmCKg/+fZ/8NMhqGK5T4jzaFxRlvTpAiMF63UPmT6BHaKHdV7kb6BHTfhkWqdNEN+27Gf+d8Fr8fS06E2neivSLUfMmvpseKGO+Rkv6FGYjrzTf7w7P2SLSjh+G
X-MS-Exchange-AntiSpam-MessageData: 3BjqWjuKYOvbAj11y/K9XRcu57JBxJBuvUTp2kJe15k0wwsgTIldAiJdUjcbVxE6GN6v2oytiYHnNpn/XqOvTjo8KUGAzljUQURq+hxhQOIcbfq0gUt0jmIEVex3SREB2Mccf7NO2oqkYY1i7ZjG2g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0314a83-0235-42d2-30fb-08d7e888165b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:49.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnODygRqw1BsG76Qjx3svacpZ4vwvAQgPuLP+FT1zr9Naa2aqtlhfiHnbdu/8KB+Ed+g+xV2W2gxMhMJ2ku85Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Add needed structure layouts and defines for pci sync for fw update
event. The downstream patches will include event handlers for this event
type.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   | 15 +++++++++++++++
 include/linux/mlx5/mlx5_ifc.h |  4 +++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 746e17473d72..de93f0b67973 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -364,6 +364,7 @@ enum {
 enum {
 	MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT = 0x1,
 	MLX5_GENERAL_SUBTYPE_PCI_POWER_CHANGE_EVENT = 0x5,
+	MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT = 0x8,
 };
 
 enum {
@@ -689,6 +690,19 @@ struct mlx5_eqe_temp_warning {
 	__be64 sensor_warning_lsb;
 } __packed;
 
+#define SYNC_RST_STATE_MASK    0xf
+
+enum sync_rst_state_type {
+	MLX5_SYNC_RST_STATE_RESET_REQUEST	= 0x0,
+	MLX5_SYNC_RST_STATE_RESET_NOW		= 0x1,
+	MLX5_SYNC_RST_STATE_RESET_ABORT		= 0x2,
+};
+
+struct mlx5_eqe_sync_fw_update {
+	u8 reserved_at_0[3];
+	u8 sync_rst_state;
+};
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -707,6 +721,7 @@ union ev_data {
 	struct mlx5_eqe_dct             dct;
 	struct mlx5_eqe_temp_warning	temp_warning;
 	struct mlx5_eqe_xrq_err		xrq_err;
+	struct mlx5_eqe_sync_fw_update	sync_fw_update;
 } __packed;
 
 struct mlx5_eqe {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9e6a3cec1e32..058ded202b65 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1317,7 +1317,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         wol_p[0x1];
 
 	u8         stat_rate_support[0x10];
-	u8         reserved_at_1f0[0xc];
+	u8         reserved_at_1f0[0x1];
+	u8         pci_sync_for_fw_update_event[0x1];
+	u8         reserved_at_1f2[0xa];
 	u8         cqe_version[0x4];
 
 	u8         compact_address_vector[0x1];
-- 
2.25.3

