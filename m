Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D0D6E7C4A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjDSOWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbjDSOWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:22:06 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EECF9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:22:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWmVY9oinwW1r+KWkEfpE1e+ASWQ9Y2tZ0rsd1DRCJhd8+oqxHa2yPUpov++4QOOghQ2j4UnVqx34Qo9MGgEmRHKGUhIUnrVyO1b+mu033gqS2DYpFwEl0vQOPBzQJ0PhGTRzJTuF1dDdPlZRwEB4lg1m/MNARyIAW/EfPKSTXEdXWhPPsx83kefvpfQKrh+84jgK0ULZ8FIwng1MoKuYzXSTaQIBAqctQAeQHqByezneVvmyJ0qCDltkuqMwFSHcRfETN3aiUVldDQLdyVja6oajlDkakD36EnNvNXzgXoft4uSN4E1/cfxdwJOIMM722heb6jEBIBm6vto5tOljw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=G9XufGTjTqnabni4h4YT68rsz9cG/3umFtvFKm7h7a5Tj0VV5kilWlOwJ9av4zsgpAmIMRmB86QmWl5trVufP7D3o2F1q3Ep0zQDEp5dMNMi/Z+Whf6Of0iZN2MsE4SavXiLJkrt+qtzfO9hhbNiAVRpmstmcVQZQdT4m53Cwuu//OKW1gXqj1m0NV5/ag8zTAiuCWccPWWhILTTV5I8I9O/vQ3JCp4v8TSAtiaPPOHKH8dlOY1j/tqJJXaBm1BWewXXOc/6fFfyEzMkrFYCp9AmIa4B+sEc07dUDCUabUvXrldoEcDPBDnpAAYs2c7ChXvN5Mdus6J4gaoOjEcg4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=D2sbmpfwyvX35l0E1YLolm+l6axu9DJZ8mC2wRt1uSm0OdRLfXfAOdDsaZcVb6oUty306LJUpCz65I2izNzu42xEQaeZycZpcRaOgC2/S1hXjkW7OJAwN1/QiW0plCTnG2bqRkvHZKTAwhrYQwxpgxAH0yg5dFHBHwC9oGg0unNpLINEEJi01PBnBk+BiWJJMy4866qq5AJPV541XEWiEmHXZK+VjZAkOor0cYVI8VFIUUpl/D0DZO0WO3wRXHuDb/xTcAu+16BIpZvyJRiNzqwHGquKrPj0JPUEyOFcoY3eWtcMRd1cHn1f/TRi1cg0CIPhhWT3Lct2CtlK8Rvwvw==
Received: from DM6PR06CA0012.namprd06.prod.outlook.com (2603:10b6:5:120::25)
 by CY5PR12MB6600.namprd12.prod.outlook.com (2603:10b6:930:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:22:00 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::a4) by DM6PR06CA0012.outlook.office365.com
 (2603:10b6:5:120::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.23 via Frontend
 Transport; Wed, 19 Apr 2023 14:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22 via Frontend Transport; Wed, 19 Apr 2023 14:21:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:48 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:47 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:45 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 4/5] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Wed, 19 Apr 2023 17:21:25 +0300
Message-ID: <20230419142126.9788-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
References: <20230419142126.9788-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|CY5PR12MB6600:EE_
X-MS-Office365-Filtering-Correlation-Id: fb15126e-7228-4dd8-494b-08db40e1704d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qapXTxQnwjHIoIDD8Cyy9+glokGaorjrN52YgixJJVAxFdI6te/Hm6sjMBRb1fDG9ytuaumcDzkYgWEyssFeHtB7EQhJjeCgYPqKCz4PFykSNWStzX60CcU0nRKNWp3Uc2BuXoD+uIJH8lYXbSZCQHG27Z4QNKKDOe+rDTlIz/1T7Ie3np/LST/bht9Tb7ixiMRwe64k3DupsVp36Q3CcRKLwA2awXIJcJXBFa/5u4PmK2UuwIZ2GWm1Wmw9qn/QOoVqV7emAdqXw7I01+oJBFUJDeBKejLkoPDw9XY83LS5p7ZPixk4BObKuD5hv7UxTqMCCpW4E3yZHDsbcQunmjVIIazWBtN6IKqNoflVH4YAyBjVXSktF+1Of/nghRJ6J3zU3ijZsrEpBGvNW04vCirN5i04+vCOuxgBjnZDTfTZ3QTgCeAwYnQWYcpTzY7l5C3usVOqLKB3PgqUlZSr2116p4Hdx1pIBJfG+D56IW+T6enAbsGurF5DzKuLtyL6a5ZY15pYrbB+hOtAf3VbYNcqr5x+gIZs/1WdaVslceU0s2vyScXbWeRYGO3bCcFDLvAExGpCWX+DVWgGGuoppbLoymKeURkUW1n0WmrU6rYmIcp3UDM7zOKMgZCRcgP0hookfRFV+2G4opScqdPFHaAMF1e7duYmCMvsmP+Cso6DYDWhzAxwod2LYCdHVnCU2o5YIjJBjzUsMGIjexZvN6RxkyUFgHNW/iPMto/0bJrmzbU4wDa6bNFWZ0zZ34uRdpWSLEk+w/sMiG3L5aWJKxGl24g6vt3XMQ2SP0p3ZYU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(34070700002)(8676002)(316002)(82740400003)(41300700001)(4326008)(70586007)(70206006)(40480700001)(54906003)(7636003)(110136005)(356005)(186003)(40460700003)(107886003)(2906002)(36756003)(1076003)(26005)(83380400001)(426003)(86362001)(336012)(47076005)(82310400005)(2616005)(5660300002)(36860700001)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:21:59.7583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb15126e-7228-4dd8-494b-08db40e1704d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6600
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading MACsec when its configured over VLAN with current MACsec
TX steering rules will wrongly insert MACsec sec tag after inserting
the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
ETHERNET | VLAN | SECTAG is configured.

The above issue is due to adding the SECTAG by HW which is a later
stage compared to the VLAN header insertion stage.

Detect such a case and adjust TX steering rules to insert the
SECTAG in the correct place by using reformat_param_0 field in
the packet reformat to indicate the offset of SECTAG from end of
the MAC header to account for VLANs in granularity of 4Bytes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 9173b67becef..7fc901a6ec5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -4,6 +4,7 @@
 #include <net/macsec.h>
 #include <linux/netdevice.h>
 #include <linux/mlx5/qp.h>
+#include <linux/if_vlan.h>
 #include "fs_core.h"
 #include "en/fs.h"
 #include "en_accel/macsec_fs.h"
@@ -508,6 +509,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -553,6 +556,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
 	reformat_params.size = reformat_size;
 	reformat_params.data = reformatbf;
+
+	if (is_vlan_dev(macsec_ctx->netdev))
+		reformat_params.param_0 = MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES;
+
 	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
 							   &reformat_params,
 							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
-- 
2.21.3

