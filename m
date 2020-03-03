Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02315176935
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCCAP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:15:59 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:56068
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgCCAP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 19:15:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8C+0qFeIqCm2ReuWXtWXCdpUKgSlPSpieRoyuePKqg2errKDItrwqBVImaLHWikm3AWDaYwYQ8OTzGXPwKn0xH6uG4mDEqnk0dVcu8XITPtIPRmSh9/WdQe4CJ7te43TtSi6tUmnteSChTMd+aUaJG+TfCJNcOAO+E8sSaqTgfVduLOaAP+QY8q5GDSZTqWa2wLYQwwPdHDXCb3avvQxdP+1aEfgA3kIauWK93Amo6owti6INRQ1L+mvkxO5VRBHGWCL/MyfcYqBLTFF1r5P8ADPJaElmiCnNokYmFRk7yPM4i9sSJXLHYU8xoJDnuO7dZo/hq9Fuv80DvU/C9uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBH5F4fnMNQu5toZdQVdSzqDfl0rPlaIZ0Ys6DME2gI=;
 b=dVLfxRrTiTpIraVgb8mi9WxFIY3Sy6fj3v4mWyolmXRfHJebYoEZn6SXIEb38lg6aT8vBaAdIRqGsmORT+Vza/zg3jfpYMLPLTI5wJgO5rVPjd3Ma4sM7SrM83qvS33Gx3oDjbunzJCwrKKf0hYzk2Ull2uRoQegrhjMYRIlsWkSiE23vW45XQcVGieBFvvBftOzBTkusPjXgp468nTPgZ21kUbIi5ENZF3B2vRHlgCkmpQRIKodCQdYkLyCsxcKRSjA1FW3EMwRTPs1Qv59mh/4beRC+YIwz5eUn0omXXJcG9BY1/KIdsHHAxE9IniqPaZCp1DOJqvMy9vsuVh2Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBH5F4fnMNQu5toZdQVdSzqDfl0rPlaIZ0Ys6DME2gI=;
 b=Fzf4rrzs4jSQsQmuUc0NseeAuQfF1EWCpYnJGwbTw5ffAoX/NoiKwo7xTABzsCmVdOtSOTAGhcyOR28Lt85w5YEPMkQwiMaubS1ow6ujSKeNa2K4BoaBpuKIV4gCTw3IMdbKzapWTUaKec+30GlQWChPiuVFeb9Fq6TLc5XKABw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 00:15:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:15:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH mlx5-next 4/4] net/mlx5: HW bit for goto chain offload support
Date:   Mon,  2 Mar 2020 16:15:22 -0800
Message-Id: <20200303001522.54067-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303001522.54067-1-saeedm@mellanox.com>
References: <20200303001522.54067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 00:15:48 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e745fc9a-767d-4246-bfbe-08d7bf08072b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB31669B72C7F553904022FD07BEE40@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(54906003)(110136005)(316002)(52116002)(6512007)(6506007)(8936002)(6666004)(6486002)(36756003)(86362001)(81156014)(81166006)(8676002)(1076003)(2616005)(16526019)(4326008)(450100002)(5660300002)(4744005)(107886003)(2906002)(186003)(956004)(478600001)(26005)(66476007)(66946007)(66556008)(7049001)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FH/U57OGsGPlSyB3AljlIvLjTVJnUrixsRkFswJQ8jfmsc2zL2ITGzlGDeZx+GXwTJai8FFXeeFZsXs2dzlXigYA7hmF/fzgmcXTX1V6F3iz3dQ4pC3h7noMnIVWRLKLyxBLDYzqFYigajxWdBnjJWReJ5vPgMsyerjZzUx8sjgkvZ/7dYYLjLKSeZQ+D9BpvEUkcP3fGcFzpW6JA1oTamFopbLZN1iP1zaqoZAw6KiqXZxsgBEEWVEteOj0jnMNkTiR8/2GosVPQqqxqwBe2q7RC/Iq5oRhmFAqS6/qEvb5i7XzYmj7oCCWijfZ8HXt11KtsiX9modrcSske1g/HGdBe+wGUXA06rACoUl1APlJkQTAyuioZluAuSkGA0K1pcWbKWYYoy8CEMRcYawUDLaKOSrwu3TIk6rAb2ESGnrUUqGpG3Mb2cpDlhUPo8p7pbGs5vw/RnX6dYN5gW18GLeDTgbjRxsv9TSyeiUeoUAVZPgVMgSKCSWbb3sK/iV64D8rG4oEHFDUK9t7dKaW5/a+j9LD+g3IAq5RMHmE44=
X-MS-Exchange-AntiSpam-MessageData: QZpO6A0sKiK0pw6Q7mk584+o+TERwejz/opKZGGU31Za16zAOtqPEwyTiSRL7I6XEQlDeYmzjwjM9zgLCVhf1MldK5cMURAV1pXdce4jJI+t3WbOPS1rFm92+T/6HpLJg7a+5q2EaUBdYJj6O5qlMA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e745fc9a-767d-4246-bfbe-08d7bf08072b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 00:15:50.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA7Y1S1Uii4FhhwYnvg1KuBAzUn6xRMR5lDEo5HE76NZdzhcoG/Ncl9s0rAQkTopv/YMli1LMkAeJEsL5TXwEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Add the HW bit definition indecating goto chain offload support.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c764a65e5754..01e7f3c8bd10 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -414,7 +414,8 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_16[0x1];
 	u8	   table_miss_action_domain[0x1];
 	u8         termination_table[0x1];
-	u8         reserved_at_19[0x7];
+	u8         reformat_and_fwd_to_table[0x1];
+	u8         reserved_at_1a[0x6];
 	u8         reserved_at_20[0x2];
 	u8         log_max_ft_size[0x6];
 	u8         log_max_modify_header_context[0x8];
-- 
2.24.1

