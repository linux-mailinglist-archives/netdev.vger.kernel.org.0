Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67495BE69A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiITNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiITNCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:02:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98863A14F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:02:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiGWxEaM1U3Xe7iWr4i0wDtiwVASa8gmsQds6+acb9BgWLP/tk67GmQtElSdODSR9+5pPfRXLIrOztVTB+uQDCKRlIWpqcPsJW16IMprc8htiPN1tMG9UNcW6rrA5D/U74SCDMzpzLrdrMhg5bN4RBv9X1eSxC+w8VPyItLC2qgwXgR9IY4OAlyfbrPdx+5q5aJ8PZlxaiWm/GnZP1PwkbMaqzGkl3ZInHAykuoTlofaDP562MV3kq8oTFstmzE48pDZzpbNuXXv8SKXEjXp01NI1VDP0D4hBeY8lj69nsuNv2Tue8U+KL62SQqckl07GAaw94zZ1mbw07BDm+QnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOKzWCGZuEB39Qs5bhy3t4N2Ms6++jOwPiD8Ylsdr+M=;
 b=AxaLIAGFraPxUqkP7qx/ix7nSfxkqwDdmx+PJxMaCAloi9IQVmM4tyPmnPwebT1M3BbRjvZA5tVTDbFjxuBi2c/OeifRuPMXP0PsImcovWP4Law819EJBlI5q9+v0I0+qr+0iju27Waum+4g5tg7ZQZnnAqebed+U1Li7cetYtKPi5PEH2jkpi9mnMhhadAd0+puunmGF77c6jIDVfGR5huUyGNDZXnRlRvbabvAYAfNGs6HrFRWV+i4he1TlpBG5Q0J9zp5xXMEaXx68YHZKEEDL4vbfl8OIG7H/HrE997mDNlJENghHnbUtVCdied+brazfYXTMeJOzFlJs1YiQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOKzWCGZuEB39Qs5bhy3t4N2Ms6++jOwPiD8Ylsdr+M=;
 b=WKDc+xfX+ny3qXwQlX0GOs7EDflr62u+GIsAbTXs6FECNYtdm5GdD2valYfCMkkktYg0rUOHXZFkc0fMyvUAFOu1zw5Nu7ZAF+d75uvsQLLCw87TpASvH/Je4gRcBtUOBOGdSCNsPvzscIJ1kKwgkKDTDcp9oqgDFN6w20Lp7mNUwsjI1KCgGJ67T6ti1pK833GGnhasG5JrdD8BY6/6o5pBSLtuyxC0i58OnXKqJtIWX/DUZkzhtbLZjN7Z8lfUjpDA86U8YD7utKkaaTjej0mZHvqpDjPv4CuHLq6dG2RpQ2NM+r5HrHX9pMmDEl/y9DNbkxinnRzKCIQxfn5vvg==
Received: from BN9PR03CA0277.namprd03.prod.outlook.com (2603:10b6:408:f5::12)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Tue, 20 Sep
 2022 13:02:32 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::21) by BN9PR03CA0277.outlook.office365.com
 (2603:10b6:408:f5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Tue, 20 Sep 2022 13:02:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 13:02:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 20 Sep
 2022 06:02:07 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 20 Sep
 2022 06:02:06 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Tue, 20 Sep
 2022 06:02:04 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Boris Pismenny" <borisp@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next v2 3/4] net/tls: Support 256 bit keys with TX device offload
Date:   Tue, 20 Sep 2022 16:01:49 +0300
Message-ID: <20220920130150.3546-4-gal@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220920130150.3546-1-gal@nvidia.com>
References: <20220920130150.3546-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 95996e7c-bff1-4d97-04ad-08da9b08612e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fZ+TtL3pFllpeE+52l1hlzOx3vghB3TCXcq4Uj3G31xEFTYifoOI85rD9wbMGuq8s/1Eq16+yInACiUs1omjPlsIW92giqMgb65M1iif9oTVJ9DRtce6p1Y/dqcqNFUO08GBlCFOMuwkspIBaNz9/Xm/eleNdEWWxkELC8qgc+F0crjpLqTU9iNcF6HEnV1dYe8rMWSnHRGQrqoddkMYC2EQVzH/ckwyp75Ea9pBTJskVx20dXeNHbo2ae/FB1ISwS2TGVuzxCcEghylnj+FMFOWC1BKyqG5MXSpEvevo8hdk8j3XEBqiR+EnRjWCSBE5IDZhcoPM10XgTYFG3kfPbWYw9PpBfaeOYxac/dQNZkLbUdu0rh3vNyH5ZgeyZMsPt9UWvdtCcqijg5e+J/Hnow1QNaJ+FE0DK5ID9RgHc1Wt2qcGuTyDl/0U1BaFm2929mAV8Xz7ImNBSfzsTHOAeSFmiC1DrH8r3TeRFdcVgTnqg0J1gaPdFYL6DSXrnQhIdfZg2NOjYjq39GSy6WeVjcXVeUuay2jpdya9UkQuyhsZ7WpiGiF2ent3UKRHOdIJY8R5NV9MI7znG+8mn1vx7+khQL97oFpPcQ04bJF6iX4KcR6w8OM1UrTXwoU/w5jh4wR6RAlPrOv/wn9kcCRF9rGEtjT7fQ0xiUNRuS9xoScRcOE1LkNQeNnMWU9L1Fyyj2KNTEV4ApdpDPzn7/qlp2pLLIBkLTrdqGZAPjfEjRHSWg07yQ/EpD/tNoRdB4NGv+3uPS4sowM/hvQyOyAA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(107886003)(7696005)(6666004)(26005)(40460700003)(41300700001)(82740400003)(316002)(82310400005)(70206006)(4326008)(110136005)(70586007)(54906003)(40480700001)(36860700001)(7636003)(8676002)(86362001)(83380400001)(47076005)(426003)(186003)(478600001)(2616005)(356005)(2906002)(336012)(1076003)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 13:02:31.6764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95996e7c-bff1-4d97-04ad-08da9b08612e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing clause for 256 bit keys in tls_set_device_offload(), and
the needed adjustments in tls_device_fallback.c.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_device.c          | 6 ++++++
 net/tls/tls_device_fallback.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 3f8121b8125c..a03d66046ca3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -914,6 +914,7 @@ tls_device_reencrypt(struct sock *sk, struct tls_context *tls_ctx)
 
 	switch (tls_ctx->crypto_recv.info.cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
+	case TLS_CIPHER_AES_GCM_256:
 		break;
 	default:
 		return -EINVAL;
@@ -1111,6 +1112,11 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		rec_seq =
 		 ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->rec_seq;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		iv = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->iv;
+		rec_seq =
+		 ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->rec_seq;
+		break;
 	default:
 		rc = -EINVAL;
 		goto release_netdev;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 0d2b6518b877..cdb391a8754b 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -64,6 +64,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 	switch (prot->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
+	case TLS_CIPHER_AES_GCM_256:
 		break;
 	default:
 		return -EINVAL;
@@ -341,6 +342,9 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 	case TLS_CIPHER_AES_GCM_128:
 		salt = tls_ctx->crypto_send.aes_gcm_128.salt;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		salt = tls_ctx->crypto_send.aes_gcm_256.salt;
+		break;
 	default:
 		return NULL;
 	}
@@ -484,6 +488,9 @@ int tls_sw_fallback_init(struct sock *sk,
 	case TLS_CIPHER_AES_GCM_128:
 		key = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->key;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		key = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->key;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

