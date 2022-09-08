Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7185B27B3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIHU3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIHU3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:29:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2042.outbound.protection.outlook.com [40.107.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC9CED99C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3pi+7fmgujfXafO90uoEPHENCv4o5Uoh5mVDGuaWHrVUH/7rkHXvoEki90n2EfNogk/yknkW+FeRozev747U90pj+DaZe1IBUrkXuCoaEbSyqEtUY97ylRD1aBqy4wS5g4B0C/kA7lCsy/lvtKoI18wTc/XlrxIalFZmIg3Xu1LmcDFPNRUHyEGW//ufbxjpm71JxuXDoYqhz0/YUdtTpTNOPtp8fsKgLz3tRjGVpOGlAjyH3y2KPa0Dn2FEhYs4ndTxS0bVS/ynjPPk7xdSVSO9Q8NLAYrLtqv+zTbCG5NvcSD+0Ph2b9TbyAu5M3xZ9+EW1H8kjQXTA9E4K7Qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsUX/+/E9Lk2PMiLqQTqIyvZaMtNmum1lXlnGrUdf8A=;
 b=kgqknRdN/WlpklLNSWP2ZSGNzlu8OhTX3XKHPKlYg3VW3IhgWZTNYsEWf2hDtaxYelESW16l6ZbZCAMvlXwF9Ptp+yBmzwA87C2CPBG7WkvLTkLeL9pNHB5lnuuMmfp0NoY+D5lJn8F8sMVDAn0fxWEFrH1aig0oh6k6Tv/Jl9WHS0SdTXGJT2IdTLvDd6vtVtuN43AL7wNxgVK+VTKfcFciFAEun//lnX1gRX+l+TZuocaxuTvwoGZq1M9vJ01SzDDHZ5mlWl9NZpHA27Cz49jVRkwsAhFm2f8L7bLx2Dawy0kd/Y36LSJzDaC1IZ/iihgvXwXptF6UFDlN+CMN2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsUX/+/E9Lk2PMiLqQTqIyvZaMtNmum1lXlnGrUdf8A=;
 b=TjRbzyCxpz5Ls1JH/QDJnVyKTdB/p0qq+iSBmqPg/2wyLQlbNPaYja2MVnjP3vDpTejvNpPM7HRq6SEttrT95zY8r9xwIZgYsgdYpzD+Z6k5r70KQiJqs0Jh7mKedpL3/b4YMQhjxC0A03ps/PvDJcgkr46++ryByH5ugbbpXEPh8Xqbvtlj/xcrnbL8HCR+MMYr33Mc1g6wqfV98uQBvqmUNebsS7YzL+Gwsce+yrNklkvxFAtuFOIQZsDqEXWjN5BaRrNy90YqfycQossCV3a1pvzOtOrIy8p0WZ+3LrGiArdn+1ApSdx9I4C0HmqxvJNygeFUV5dJ2KZUeu7uAA==
Received: from BN9P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::34)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 20:28:59 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::61) by BN9P222CA0029.outlook.office365.com
 (2603:10b6:408:10c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Thu, 8 Sep 2022 20:28:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 20:28:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 20:28:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 13:28:57 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 13:28:56 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <cai.huoqing@linux.dev>, <brgl@bgdev.pl>,
        <limings@nvidia.com>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net v1] mlxbf_gige: fix receive packet race condition
Date:   Thu, 8 Sep 2022 16:28:53 -0400
Message-ID: <20220908202853.21725-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: cc4a51e5-7ccb-4f14-4710-08da91d8c2cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9D06oZfFXt+SFVbgOiZU6wtrzqsTx78anJbyg7xyoBt0iO/uM0704hnOaS4IF51+qQldt5BbJCZRysf0LqNxue/caJyiEL5zf7eapD9QmoHvZyc5iGsTsjUEDS25IE73qq+ATZvhij4pA4HPPgJdPoxbB5pSaBHtSqd+cm2DaRTnXcx84nHRoqgSPCKtYWXCegYmYWHs4Inzv7wN+bcH/pLUGFtwdoNotXXpGtmJh/5+NOg5uvGVKCbTcQK47tk1Up5fm069giWEnyIcLJ16t3Q4zsQwsgJ+Mo4aLhTFRQ5UhuTgPqCITK8neoS/r/0WOOg13o3f/BaIpeDsDKDAT3JqM5J3BjcBg1vnr6k1W2V1PSpGFx8aFqd0eKUWh3yTY91vSSzjldFE3vM5vzQ7Erw5iamgr7Xmft/Z5nSnVE3zf+8PqP/ZdZ9W0JI9LTuTHUVdtsLYloJ+guCHV/icxOlR5FevuNoPt/TZvzVrDoHHb20RmgGgszH3wsGdK+4O2IRNuRRjUoIBC0QiQiP3/mKCmDuA0DN2ZDZCXqWDJD2NoVjDYqB+i0d9cds2v4hpNASX0L8tf8sqYuobXI9dKv5qqU0hyP+tixWePNCpeIwqE5/4INN0RQhp1Hs0CLwWMfiUWqJn59kE/1OL7elyOl4IblIUGJBXL2XpT/mNR8ONi8EJPA3sdMLJrlWSmNBAy5MZ8p8RRI72gBBk8AgVjw/DdoaP0VEcAYx/y4rKPbLyMKTk+T9YiS+Baq4pOB2G6W3ROkBsmjvDInWuGt4FfHj8QLVKL9FP28Yu4fSVbE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(40470700004)(47076005)(336012)(1076003)(426003)(5660300002)(6666004)(4326008)(8676002)(2906002)(7696005)(70206006)(8936002)(2616005)(70586007)(82310400005)(36756003)(26005)(86362001)(41300700001)(40480700001)(478600001)(186003)(107886003)(83380400001)(356005)(40460700003)(36860700001)(81166007)(82740400003)(54906003)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 20:28:59.1693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4a51e5-7ccb-4f14-4710-08da91d8c2cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under heavy traffic, the BF2 Gigabit interface can
become unresponsive for periods of time (several minutes)
before eventually recovering.  This is due to a possible
race condition in the mlxbf_gige_rx_packet function, where
the function exits with producer and consumer indices equal
but there are remaining packet(s) to be processed. In order
to prevent this situation, disable receive DMA during the
processing of received packets.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index afa3b92a6905..1490fbc74169 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -299,6 +299,10 @@ int mlxbf_gige_poll(struct napi_struct *napi, int budget)
 
 	mlxbf_gige_handle_tx_complete(priv);
 
+	data = readq(priv->base + MLXBF_GIGE_RX_DMA);
+	data &= ~MLXBF_GIGE_RX_DMA_EN;
+	writeq(data, priv->base + MLXBF_GIGE_RX_DMA);
+
 	do {
 		remaining_pkts = mlxbf_gige_rx_packet(priv, &work_done);
 	} while (remaining_pkts && work_done < budget);
@@ -314,6 +318,10 @@ int mlxbf_gige_poll(struct napi_struct *napi, int budget)
 		data = readq(priv->base + MLXBF_GIGE_INT_MASK);
 		data &= ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
 		writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
+
+		data = readq(priv->base + MLXBF_GIGE_RX_DMA);
+		data |= MLXBF_GIGE_RX_DMA_EN;
+		writeq(data, priv->base + MLXBF_GIGE_RX_DMA);
 	}
 
 	return work_done;
-- 
2.30.1

