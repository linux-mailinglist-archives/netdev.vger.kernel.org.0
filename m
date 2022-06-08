Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FD5542F0E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiFHLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbiFHLXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:23:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A194C3C2DF1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmEUBhF+Jaacar5/0iss/xX4OUZGqgnQIY0/tjmlfAFqaBZpdj7vo9stsrSRvckV6cgrAnP/AsAOtvN6VRfDTb+sUUcQPFFBDjSU7zBeVfhBR4u2vDP1/TD1AZQ7igKCUOWKQbq/Invca1wqteFSOqQspTnkxbH5pzQqwfNvuYv30RomprapxkEHeSXZlaLF/wBkBFj2UYLOXKbGi8qn0jrfsO7WZwr/RUD+Y7PbEDH4XzTWbLTgb1GmMFpjty+eXYouh/47nEzeas5Sovy4grYBekUI0A51ljcO97bnYwXKASUdPW+zx3a/ew7DtG+3gIbskKqBZowdDg3ezW1UaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUQqCaUgkJ2JYvQ5/se3lZ5le4cF+uvDEkLSnqV8cGM=;
 b=hQOw5ACd38REb8xocIe1IdDkBk5ogLkk7BRyE6sPoVFbQMp4bgRmQ53aeunJPqdwivzhztZZkQG7QxoyschvPt34pU0NQIkbpd7PfO3cpFRgMQXMfM3hi5tbX9nU7ebqnqsA1tTH3qdbEdjLLtZ50VMbxKX6zakKzWe/wRTO3wV5nIVqe1wMnEO+YQSq+vo8oxKF3wlB/T1tkqRDCOK5lFpR11z3ZCOpMgC20HsejPLw3Bla8yahoKUwrYse7qj2VGDxUUYsMxTHmtIbeMUXE+FYzJHoYBuHSKXcE1Kvo3Yl/YWE4W7XN/M1evgJhR9BK3qDmOo3E5oKPZt3dhOjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUQqCaUgkJ2JYvQ5/se3lZ5le4cF+uvDEkLSnqV8cGM=;
 b=KA6XFAJ5Xo8DByCdN9zbyc4h2bkCiQApOZ+jpfq7PibTyGd0vWVvkD5GpLbjtHB3iqTGOq4/zDrrv7qQPcXQoAfy0H3WZ0g6QLGjZwyqqkpZDtTa7tuOEDssTUypkniazurUWA6nBxX7SsIVEbgfuc22RLlDnJkGnFiG01y9EsaXVvNHML/YEr8GjdCsyTampFVmp/lMCf90myReoY8ddhU5nJM0At4oECJG1LIceQzzkr0NUHL8SDNQnu9B5Y7RAJ5soMLZSXyhSVYHzJMUaMt0i4JUgnjTFWtk3sNApsRbjXWmrywpalPbJQE+nJIg01q+E+o+FguNiYFk57SVsw==
Received: from BN6PR1101CA0016.namprd11.prod.outlook.com
 (2603:10b6:405:4a::26) by CY4PR1201MB2502.namprd12.prod.outlook.com
 (2603:10b6:903:da::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Wed, 8 Jun
 2022 11:22:59 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::3a) by BN6PR1101CA0016.outlook.office365.com
 (2603:10b6:405:4a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15 via Frontend
 Transport; Wed, 8 Jun 2022 11:22:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 11:22:58 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 8 Jun
 2022 11:22:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 8 Jun 2022
 04:22:56 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 8 Jun
 2022 04:22:53 -0700
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
Subject: [PATCH net] tls: Rename TLS_INFO_ZC_SENDFILE to TLS_INFO_ZC_TX
Date:   Wed, 8 Jun 2022 14:22:36 +0300
Message-ID: <20220608112236.3131958-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca69966b-ab89-41d9-4f2b-08da49413dd4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2502:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25026DB164CD0B90E780C717DCA49@CY4PR1201MB2502.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGduYTn4z1mp+4k838OW+TJBVVi1+f74APiXLWnAldJkEw/Q2eKVCjyl3j4lE1gdoj/SA3en7S1Bcucd7RrPsljL0+wJiJVzJ46Gi4J7Ajl60vOc49YEB71J12r4X3BuXeyZsgTOE0W9N5IoQ1X648HuZVqTTlaUkHmHSXQ9zrFtjPJUV1vaSlyqNvj7DV5uPPLj1HOFBpyk0sscFpIGE2e5+XjA+cAqU3u4dGT1Trpm62WcH6qHGNOngFLYDe6oJ6Wq2cGgZtEVYGxonUbIYjEN2XaGiPZQGTgVm849lDHXnFnXgNI+NED3+SMMFr60HQkaFOtDax9JMGrTH6iZ5rKZotO4v4K7m7r6/0OxlEmgyZZMV2mGdUyzoh/VUj5iIadAtznpw3Mhf14s7Yp2SFKON0BoC7ve9XNPfyJVWD8T711E/3rUL0+YnZp6nN3iJXY53MHXp+ukXjNvEGSlL5jC8JrucFM+8qe/IOR+GoijVs04qrGRWpiS2QJwbHyPJZ96AOVF6WOv+oAtDQKvCwjGJzwaQ4miZow5ajLRQBB9Gh6AAjuLcjz+/xOo/3UzztyROQ3PCWTg7hAvz/sJtncHftMOUgdo7oec9BWZsbDpnrb58GjmnUkW+/azaP6y7AgtZfyuG4HPIhBmZmLESKaJ4mDpKquNiJqYdtL2stPBbBuZ83z1URtv19jrdia84Alx//iPMWGUIO7ibxsm5w==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(36860700001)(82310400005)(83380400001)(36756003)(356005)(8936002)(81166007)(7696005)(6666004)(86362001)(4326008)(70206006)(70586007)(5660300002)(110136005)(2906002)(54906003)(26005)(47076005)(316002)(426003)(186003)(336012)(2616005)(107886003)(1076003)(508600001)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 11:22:58.3653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca69966b-ab89-41d9-4f2b-08da49413dd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2502
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

* setsockopt: TLS_TX_ZEROCOPY_SENDFILE- > TLS_TX_ZEROCOPY
* sock_diag: TLS_INFO_ZC_SENDFILE -> TLS_INFO_ZC_TX

Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/uapi/linux/tls.h | 4 ++--
 net/tls/tls_main.c       | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index ac39328eabe7..bdc90d117cf2 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,7 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
-#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
+#define TLS_TX_ZEROCOPY		3	/* TX zerocopy (only sendfile now) */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
@@ -161,7 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
-	TLS_INFO_ZC_SENDFILE,
+	TLS_INFO_ZC_TX,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index b91ddc110786..a0bf7cfd9381 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -544,7 +544,7 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
 					    optname == TLS_TX);
 		break;
-	case TLS_TX_ZEROCOPY_SENDFILE:
+	case TLS_TX_ZEROCOPY:
 		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
 		break;
 	default:
@@ -731,7 +731,7 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 					    optname == TLS_TX);
 		release_sock(sk);
 		break;
-	case TLS_TX_ZEROCOPY_SENDFILE:
+	case TLS_TX_ZEROCOPY:
 		lock_sock(sk);
 		rc = do_tls_setsockopt_tx_zc(sk, optval, optlen);
 		release_sock(sk);
@@ -970,7 +970,7 @@ static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
 		goto nla_failure;
 
 	if (ctx->tx_conf == TLS_HW && ctx->zerocopy_sendfile) {
-		err = nla_put_flag(skb, TLS_INFO_ZC_SENDFILE);
+		err = nla_put_flag(skb, TLS_INFO_ZC_TX);
 		if (err)
 			goto nla_failure;
 	}
@@ -994,7 +994,7 @@ static size_t tls_get_info_size(const struct sock *sk)
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_CIPHER */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_RXCONF */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_TXCONF */
-		nla_total_size(0) +		/* TLS_INFO_ZC_SENDFILE */
+		nla_total_size(0) +		/* TLS_INFO_ZC_TX */
 		0;
 
 	return size;
-- 
2.25.1

