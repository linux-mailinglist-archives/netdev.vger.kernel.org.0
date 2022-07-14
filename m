Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541C857457D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiGNHI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiGNHI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:08:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF82CDDA
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:08:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3zu1wg1Ujy7XXJoUIbfkO52qNbdDAfRe5bVSS+5oGX9nw1O9EGoBlH9vJPcF8mAbdJOdMq/5Id0kbiDABIH+Wz1an+LuBTHE8KQNx2hP+OOIUVfZTJVg/Cx92qd5OFzsR3sqSP/y2qeZ/22Ud4e0mJAq/E2CjL4rqzzIO8BFPgtAnftRHy6fiOGWN2o5amCWkce4OrDYwJ0q68NqRcahoyaXnwjp6ap+KYDeMVmsoJjsnD0P7Lw0VIG7IVht/xHmL1wLy8hpFi8gvZC8sBY0BreIQD02IlEA/jqmCVQd9QqyAlZRQoBo7hiHg+nyyalCiLd1/IM02HXrYp2NzdU9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d23BjZKSfjIKPQWiFmbbZya2Pkz6XsP0wuY6XWDHg0w=;
 b=WSKJjK92dGx/ibqoNr/+ObmQXlFUz1k1iA0MVfFB2h/XpGzrThWYj360sDPNpseXvsHxLxYVAWJhvETmYhGMV141tBSW7wQFws1O+Mm7A2fMUVmUAuK4aqr9xaS8+2nFTmI6wnnIw9PBYwtnx6Xa8BqZXs4vf4pV20PTwyaqSQbyhFUMr/E3MoM6SuhQBakHq+HN1a5Zn08U1lnhs9UQYKz9cSutNcrzPdK/Jw0w3iNWSVBilSfuKa9BezSRMvD0FXCLkKhMCvn/LxFG1g72IjnatQiKgxzCndyiLMIltD/0sU2lanEbXX2Sv1fBmq9O8qiDH5LuT8UqljpG3JiCSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d23BjZKSfjIKPQWiFmbbZya2Pkz6XsP0wuY6XWDHg0w=;
 b=atlZLpWcxXS3CpCX76P2j4eLbvq/HYZEiq1u5SQixFA1iw+zz06FL9q7N5zROjb9d7vN6pkybRcnwrfNSaBSYJJE88YdxSW7Rg17oks0r2yyxRiaiVRRfV2bCHBovJSSv+kFSljXkN95+1dI697/CfHa3gSnPoYz+A4YiQIISDXXNI4jJy0O38r4BBrUVpQDRl/RU60/Ldx2quASNw+Uai7ZJQzmpqUowR1LEFlcMFv0lsQ962mhps/8bSQ6rPtyqoaI5AbuprVrsqawBtX8hZRio1oQBYLNi8xW0Ysew60sFWA/g1z4WjKPXZxcpSR8EdspsbDLqWojk0lBc8S4jw==
Received: from BN0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:408:e6::31)
 by PH7PR12MB6000.namprd12.prod.outlook.com (2603:10b6:510:1dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 07:08:25 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::5d) by BN0PR03CA0026.outlook.office365.com
 (2603:10b6:408:e6::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Thu, 14 Jul 2022 07:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 07:08:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 14 Jul
 2022 07:08:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 14 Jul
 2022 00:08:23 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Thu, 14 Jul
 2022 00:08:21 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] net/tls: Check for errors in tls_device_init
Date:   Thu, 14 Jul 2022 10:07:54 +0300
Message-ID: <20220714070754.1428-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 359aa46d-fdf7-4128-544d-08da6567a54a
X-MS-TrafficTypeDiagnostic: PH7PR12MB6000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z5lvrCW6pl7Ya29tlGBCRVI2K8GQdBaHht7eW1gyvhymSXWVGRNI0ZixQPwgvamGZGcQdjIW/GghYA+UHrVdz9/ipSSewx5X555hGMM6B+OEo7YYPSUwb2TKCb54KGmYIUdFM8Ybmffyh8/0QAmKXzw2TXyitXSC/g6qvVqnh5m2nGU0451ASr1Q9SlZ8lo5/aRiKmbcLhx7F4PsYTrjQo0k0Wk1s6tOD6sa738Tlo7TQ0vrhY8BY9CmaIdCvor8xl2FY4sIgcKjcXaYBmv8l0GNp0mZtRvDC0HKlLtK0hFSfBrJ1l+P6nUkb7wvUNTj3wg9jAnzBM9qP+pKHKTX0fYbZOllCx5uS9DIYW1zrxBCgUiIRebqfYzIeK1Jdtpdnl2c2oO3X+BCDhiFEnGt+kR6syJlKqYyEeb9J9N5RPtVDIE0bpfC/zn9qnJuhIGx3NbVkkJNMTI1siYNVwgQy+wp7Bp+ekPtC55eqgfzq/2FetfpAqtgtTGfshX1dNA/blaFSrJSKkZkumosUAm3IGlgRfzdAdJ+0Z8h/K2x4xaPheioRfKS9qT7EB3ytvrk6Sdfeo3jTpfUiCQE9I0X+L+j4656b1C6Duj6Lqc87mr2CfiZpIMTsHboQ99uaQ3/KRU1agShrtrN5wGieO68vLitDoWv2kgGhQY57oFdCLcvau7w+TDoeJLXs5fB9sOZFm9E9RzCNu6W6JgatouTJK8h+kfRqX4kqgghg1VcW+u2TYA89Owgz+Sl2kXVEvgYXRSBljAgztcg3pRjzSuRjXDFlB0o/HEsXEyfd+X835o6zVJVZ+Rv8h4iwGiDcyxlySWBkS18t2j8Pz8YOfm+e3P2y8X3TeWJsQ0eWEMdl6M=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(40470700004)(46966006)(36840700001)(40460700003)(316002)(186003)(47076005)(426003)(336012)(1076003)(86362001)(2616005)(107886003)(70586007)(4326008)(70206006)(8676002)(36756003)(36860700001)(54906003)(110136005)(478600001)(41300700001)(2906002)(8936002)(356005)(82740400003)(26005)(7696005)(5660300002)(6666004)(83380400001)(40480700001)(81166007)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 07:08:25.3776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 359aa46d-fdf7-4128-544d-08da6567a54a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6000
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing error checks in tls_device_init.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/tls.h    | 4 ++--
 net/tls/tls_device.c | 4 ++--
 net/tls/tls_main.c   | 7 ++++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

Patch conflicts with header movements done in net-next:
587903142308 tls: create an internal header

Resolution is trivial.

Thanks,
Tariq

diff --git a/include/net/tls.h b/include/net/tls.h
index 8017f1703447..8bd938f98bdd 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -704,7 +704,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_crypto_info *crypto_info);
 
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
+int tls_device_init(void);
 void tls_device_cleanup(void);
 void tls_device_sk_destruct(struct sock *sk);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
@@ -724,7 +724,7 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #else
-static inline void tls_device_init(void) {}
+static inline int tls_device_init(void) { return 0; }
 static inline void tls_device_cleanup(void) {}
 
 static inline int
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ec6f4b699a2b..ce827e79c66a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1419,9 +1419,9 @@ static struct notifier_block tls_dev_notifier = {
 	.notifier_call	= tls_dev_event,
 };
 
-void __init tls_device_init(void)
+int __init tls_device_init(void)
 {
-	register_netdevice_notifier(&tls_dev_notifier);
+	return register_netdevice_notifier(&tls_dev_notifier);
 }
 
 void __exit tls_device_cleanup(void)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 2ffede463e4a..d80ab3d1764e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -1048,7 +1048,12 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_device_init();
+	err = tls_device_init();
+	if (err) {
+		unregister_pernet_subsys(&tls_proc_ops);
+		return err;
+	}
+
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
 	return 0;
-- 
2.21.0

