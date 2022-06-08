Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDE5543783
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiFHPfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244122AbiFHPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:35:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20C34B1CB
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:34:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlQQyzaQvn2KmYLSNXxKiZjsYZB9rjzTUrHZ4Dmg8cBUikYL0/ZKrUGad61oF6wkPAkNPliGt/O+Du4ysq5UBVzquO8MvoOwdXpYzc8SmFx/1QLp2jj+B79efcEtY6PWNatBBgX2m3g1x6YG2N5087LJhtg6v6pFL9r7q5WXOscgNA7iyG7HRaYJtLyn3UfPcVNvIjPfbOBvALV3eATpGCcrGwkrvZh/IanWzosqDRYGE6/lAJ+/WyB5q8vPPLNhIzTIAKmUr/n8YJjxvHa738GSnai439+6MeaYxH+k6USBwJSF3USuH8IwaSWi18ESNkgGkz4TKy6Ycx9Babm+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hH+2cladFnApgD5l+SUW5GhI+ONccsfxairmg2RWAE=;
 b=eIMZqE2iToJdOP0UVsUkmGIraE6JdykVV10YaPJOpr+5cXnClLduev3o5wK83Dk+uASck7wGZfJhE7X2D+jMx2NWFDMrxc7C0ZRJsCO7NabySH19+T1wixC+dm5jVuEc2Ehv7XajtKzVEabpqcqtJhGWR8/0SIAP+bTeGkORItQNlhhrpzygJ2Xlb8fv2bOfEAoSpclAZT1M2+cXNzV700krT156Sl5T/sryb3FSw/6qVqQt0rQshZQAxPvGOPKtiGg8YD/bsYl9YPC2ymj0IOfjiY2N2SphjalRA/mbSH0SnqRCxxJKDK4ZSzzoZuEmnXZTlOTCh4f6GMVQVxcvrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hH+2cladFnApgD5l+SUW5GhI+ONccsfxairmg2RWAE=;
 b=QRTJ+PtrfKY6tHBtvOqdJ6QAecXjIFxmWHSquIBVoJ60SBCY/BX80p76i3rMq61fMQiVZ6+swikScpqfLxA5nCrNebwhP5QU1wwEHy5SAsJrZp3dQdjRyMpD66S0mbj8M6JZVyROYhqAX5P4XbrjL0QdCSudtExi/8TQ2kIhMOGTJODl+I7uYEiyNaWAfaA/VvgxaSabj9A6b1BsgJVGnRitPVizo0XQGrZv32TBRqYmL9syny92sEg9CG5J2MrNmJpSvBBMXhz7hbKLXktUZKevy0Mms2Qr+eIWpxEmpq2Jn3AXvmohCQjuG5mpZHW4MCcMvvDHzmMjdmlk3vixlw==
Received: from DS7PR03CA0096.namprd03.prod.outlook.com (2603:10b6:5:3b7::11)
 by BN6PR1201MB0227.namprd12.prod.outlook.com (2603:10b6:405:4e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 15:34:34 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::1f) by DS7PR03CA0096.outlook.office365.com
 (2603:10b6:5:3b7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17 via Frontend
 Transport; Wed, 8 Jun 2022 15:34:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 15:34:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 8 Jun
 2022 15:34:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 8 Jun 2022
 08:34:32 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 8 Jun
 2022 08:34:29 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net v2] tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX
Date:   Wed, 8 Jun 2022 18:34:25 +0300
Message-ID: <20220608153425.3151146-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 924622dc-a47d-41dd-f3db-08da4964635f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0227:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0227CAD9CE639946AED86375DCA49@BN6PR1201MB0227.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+Cplx1rUxicPIiJk5Yj8VZKz27iH7HQmWe50MngbaD/roRWbl7T1RuBnJ2UF/QtUwxSQGUde5XsKrml4Q5DZ1LdLeoHLp70wiSSuR9oY5SV5RYLMjNo9VIU62dOOIu5MvvHsGgOFONqhCE3i3lAAqPPT2pOxVSUs47hGKu2CAe2l43bSiaJCGODRt/LLqrzwFWmxhi+vmz53bnAQeRXnKaZKo3o0a+V5WKFLu3cxs44+Oacs0Z6f1W1XOX1+i25cpMU4bCwAyrgy19K92pSr6wdFOT5e3fMsjC/Qr+UkUz9K5S1pvobFxvJGqri01I+I2bMwI2vFE4x74gSINOwsD2tELIDmRAZFza4aCp2W+mVi7VdaFiPtQW/QN0orVJqfGEQ3Onr4eWVYUGxTJgEW2bySCuW62o6OOpFP9vCe0CslnbGw2BwJJFBgk4BvsLo14eKNPdWcB3x/TxAGCdqbgwA7sPBCGbNQ6TmbPYKx4ovP+ux6LFHPphNp7IYFQxIKVArbJOXR8rNIX4tE7ylKfXWtd7eCV5VAffZUD2EmGEGOtPgPYzkhI+cyo8nxG3s+0KG5te2IMvQDHNNCqaGXaTFNaNRVqMLcTWCeO/NGKUkcoIR29YyyB37sSEgs5FGWPfsJ8hGohRTLJGd5CPYDL7tv0wb9YfhSyklrVSs92WM2edRQtoQ6qySe7aThcUn/zJ2rk1uqjUemSF5jBzAFA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(83380400001)(356005)(81166007)(40460700003)(86362001)(8676002)(36756003)(4326008)(70586007)(70206006)(316002)(8936002)(508600001)(54906003)(5660300002)(110136005)(2906002)(82310400005)(26005)(6666004)(7696005)(47076005)(426003)(336012)(2616005)(107886003)(1076003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 15:34:33.8042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 924622dc-a47d-41dd-f3db-08da4964635f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0227
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To embrace possible future optimizations of TLS, rename zerocopy
sendfile definitions to more generic ones:

* setsockopt: TLS_TX_ZEROCOPY_SENDFILE- > TLS_TX_ZEROCOPY_RO
* sock_diag: TLS_INFO_ZC_SENDFILE -> TLS_INFO_ZC_RO_TX

RO stands for readonly and emphasizes that the application shouldn't
modify the data being transmitted with zerocopy to avoid potential
disconnection.

Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/uapi/linux/tls.h | 4 ++--
 net/tls/tls_main.c       | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index ac39328eabe7..bb8f80812b0b 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,7 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
-#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
+#define TLS_TX_ZEROCOPY_RO	3	/* TX zerocopy (only sendfile now) */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
@@ -161,7 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
-	TLS_INFO_ZC_SENDFILE,
+	TLS_INFO_ZC_RO_TX,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index b91ddc110786..da176411c1b5 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -544,7 +544,7 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
 					    optname == TLS_TX);
 		break;
-	case TLS_TX_ZEROCOPY_SENDFILE:
+	case TLS_TX_ZEROCOPY_RO:
 		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
 		break;
 	default:
@@ -731,7 +731,7 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 					    optname == TLS_TX);
 		release_sock(sk);
 		break;
-	case TLS_TX_ZEROCOPY_SENDFILE:
+	case TLS_TX_ZEROCOPY_RO:
 		lock_sock(sk);
 		rc = do_tls_setsockopt_tx_zc(sk, optval, optlen);
 		release_sock(sk);
@@ -970,7 +970,7 @@ static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
 		goto nla_failure;
 
 	if (ctx->tx_conf == TLS_HW && ctx->zerocopy_sendfile) {
-		err = nla_put_flag(skb, TLS_INFO_ZC_SENDFILE);
+		err = nla_put_flag(skb, TLS_INFO_ZC_RO_TX);
 		if (err)
 			goto nla_failure;
 	}
@@ -994,7 +994,7 @@ static size_t tls_get_info_size(const struct sock *sk)
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_CIPHER */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_RXCONF */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_TXCONF */
-		nla_total_size(0) +		/* TLS_INFO_ZC_SENDFILE */
+		nla_total_size(0) +		/* TLS_INFO_ZC_RO_TX */
 		0;
 
 	return size;
-- 
2.25.1

