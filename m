Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96A15E6DC8
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiIVVNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiIVVNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:13:24 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2083.outbound.protection.outlook.com [40.107.102.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B09DDD8F
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRfWTViz/ANoMSG7u7x2fCSqA+0ObZcDdHo8NKKWM3XJMmqpImveptr9DZ3f38RsRiJhKYNRYlkArWK1cd7V8JAfnmShDQv2slg9viO9aIggjAlvt7rMPvJQUM+1ddlEjhVbyGpfstpkevUEQ8AE4je4Xq3RKiPasHbE8Hj25gMA5Nv7IjAaYQSTQiQj/GFwt5HCjPl0Tg50o+Io5rRlq8J+0MTxJ7JAcBjSgGCz+q0sZq8dAw9DmTbdxH/8+AJvi6TkBf8OrvF1Fp2Fs/3imt0DDu8qYgAVm3d05Vb6fZfv9xx7WLRjo/hgW1dUDor6MgTvxbh6x4TZXh8kckiGkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzliOa1rOCTgpQwjE3Jg/bouPhVQ2W7xNHkv3VXREo0=;
 b=dUUyEcVYhfLHMlPwW4nyOtUtXzJndliLVgyoWZM9DvkTNVkSaBbhOd3aYDc25GqFNMwqnE5AC9yNnEKxGjg2EI9kRHGLW5tvQ8mlzHRVVc98sqSLvIp/nW6aAdYgu42VfIUAMFJtfEfHFMaUWmO7v2pPdgteizsbl5Tt3DXvCh30H6N4tFIXEehvnF62FKU9RxTo1OBSohYpwLSiTbtcIqQOhu9m5fpzYDxhdIHjGxMw+iLSEB746/gxp0L0Gl7B/DU+FyLo8QzdYbdYPOMs5QZn4CwzR3SL0DY3NUQbagwBV5IdKYGKiLEh8rSVnk++J1dzl2B931PLBD1NwHKWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzliOa1rOCTgpQwjE3Jg/bouPhVQ2W7xNHkv3VXREo0=;
 b=yEtloHbcYl60uzQAl2wz1x79My7c5aCW38TTbiAlfwBq9e/UyZMg5y6BD7AVqMhfrszJUaWxbrBz4Tx8KX5OtDeX+0jWlzZT4SyXtEMHBIUcMjP83UFKIOR70tdlnq7h7za61puUdvj7ER3AWeQW5lJz/DO8pPetiOV5vjgyoIrU6lCJiwLQeAdkm5nk5m/gy5v3XixfLQomETqvB1uCYyGQM280gmdSRmR28BBM6wpWjxMR8zbobXv+AvgYW+3TWw5uhYa/PWPNd8qP5vzQG6NLIJ/3+V985edDP82TXxGsaUeankPj3B0iVUV9TKC1YXR7CUPskkxNv+e5h1qV+g==
Received: from BN9PR03CA0177.namprd03.prod.outlook.com (2603:10b6:408:f4::32)
 by DS7PR12MB6141.namprd12.prod.outlook.com (2603:10b6:8:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 21:13:17 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::10) by BN9PR03CA0177.outlook.office365.com
 (2603:10b6:408:f4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17 via Frontend
 Transport; Thu, 22 Sep 2022 21:13:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Thu, 22 Sep 2022 21:13:17 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 22 Sep
 2022 16:13:16 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 22 Sep
 2022 14:13:16 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 22 Sep 2022 16:13:15 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Andy Moreton <andy.moreton@amd.com>
Subject: [PATCH net] sfc: correct filter_table_remove method for EF10 PFs
Date:   Thu, 22 Sep 2022 22:12:18 +0100
Message-ID: <20220922211218.814-1-ecree@xilinx.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT018:EE_|DS7PR12MB6141:EE_
X-MS-Office365-Filtering-Correlation-Id: 034c4bf0-7953-4cb4-5d7a-08da9cdf44f4
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02y3AZfdB0HmMZjroBA7PGi1roU+IJewhNoUFz7jnd6Om9l9v1Gz9vzL3+yZZjEGHsTEN0GQTQw8uViWEoOk6G2IrnJwC7DWzGQFx7RswJmJVBpa7Z6wRwAiLeC8QJe8daREyfxqL2h9T8r9iZaM6ksuyYG3ohq+SgowjKbj4bybAVxMZCCB98TPLDJKNzxcAwVb18xgMJKGAOg9pGxx6/8LORNst41MAdTn/m0TclA6xW4NQFvwEX6Fh/Ki7/1eAZI4kZ4xdfZUUpU/JwDhfd7eqPdv4CwQfOv76wONs00n0gltqjCYm3s4JhJ/G/GYUYl37ASn2Q8AG6BcNQbqHNUOhMNPy4doVjWtFIL2jrk5oEBvBTpT45Dz5Qw6hJ24R2mI96SRT/WOYncGoG61N0yfW01WY2cZpPhN7tHM4WD3Ui1YwW71GQEP5K0nKUgoQkD9lH3Z2douE0RWkTDjeM2v31Ox8X77FMepOx5eLAf9tx+chr+EN/btvU1/Bpygc+OSTx2O0MsY3TLYJFKawDcFWMkxr8yy1iJLf2QMmJfJB/Oh02whUkjZZ1AnACvvR8m29kveWywhbXAUh7FX//YxXaULDok/i0Agu0YDEgFSOp0f7F50wOHRlkroIjVVbpuGiJQjD6pm6W6rCNnkD2j/zKkmFJSmyWX0OOgre3SywhAznxJSnpuhjUKa+FPkPvOXsVjcizYUpNmg5LmoxmTaxFCvBU1vE6i9l4DuzdJ89s1eXt0R88JEh1KN1DKA6vfl+b+/6RR2q2u+DLpUihmdIfHFymAbh6q/2ZF0t1YbCJv25JhxMXQZyKaYDoxP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199015)(40470700004)(36840700001)(46966006)(2906002)(8676002)(26005)(478600001)(47076005)(40480700001)(316002)(83170400001)(36756003)(40460700003)(54906003)(82740400003)(110136005)(2616005)(7696005)(36860700001)(82310400005)(8936002)(70586007)(186003)(81166007)(336012)(4326008)(41300700001)(1076003)(2876002)(5660300002)(356005)(70206006)(83380400001)(42882007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 21:13:17.4070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 034c4bf0-7953-4cb4-5d7a-08da9cdf44f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6141
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Moreton <andy.moreton@amd.com>

A previous patch added a wrapper function to take a lock around
 efx_mcdi_filter_table_remove(), but only changed EF10 VFs' method table
 to call it.  Change it in the PF method table too.

Fixes: 77eb40749d73 ("sfc: move table locking into filter_table_{probe,remove} methods")
Signed-off-by: Andy Moreton <andy.moreton@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index ee734b69150f..d1e1aa19a68e 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4213,7 +4213,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.ev_test_generate = efx_ef10_ev_test_generate,
 	.filter_table_probe = efx_ef10_filter_table_probe,
 	.filter_table_restore = efx_mcdi_filter_table_restore,
-	.filter_table_remove = efx_mcdi_filter_table_remove,
+	.filter_table_remove = efx_ef10_filter_table_remove,
 	.filter_update_rx_scatter = efx_mcdi_update_rx_scatter,
 	.filter_insert = efx_mcdi_filter_insert,
 	.filter_remove_safe = efx_mcdi_filter_remove_safe,
