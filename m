Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10AC617B228
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgCEXSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:08 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726650AbgCEXSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPAOQyDrxwNEZWCPPRvOtCchnugnGJbsUwxpIeWsHZd2lm0GGHJ2IIc5FCpgbaVo7RQJvu2UC5VyvGn17xxZnqMC+vvGrjaPb1CE74zL2Ot1DOr4MXDZIsQppYVv21LTuR64BEycE39zR0IjTmAYcG1UViT8Slh3LbKUQK7WnaRohsUaeoglntRqPWwq3fgSTyYudG1gjLvHS2t35Sr+Hil3WNRnyav+o1AbokH18aJxb01CH+xu+ucymPEDmsQdfc2JcBt7PsLvlYZMxeWtPHTTnWYLMTRJe/2mC3BfZCjUIDK1z7Cb7JXjKTDquVq28wfWgBeOkjAWrsFGIOsndQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wvu4y434UlEZm6D4Km4OEPpw6qLd2r30srcegSknqq8=;
 b=Pkuh7YEt+W/y3YrsD2AXFbpAOFaTTWxhz3FgHJ22w1GMbVINVM0i0wRTKSPIDOtDgykdxYyuojVOzZh2LPcsy7H0W08lrzP/iIj4oetU0ygholn+0g2PevCODhrOkPUgpLqiwyaIpUYIXliZs2B7RxdyWFnU+aSTc8Qp9k+LjXioQtsWdcj/eQ+a3hrAwrG3dB3Qx2eeU3gNC6tudrTvipGtgLSBSelm94LmOdyOOqpTGTA5ao2z8+kcklBpWwtj5GFg3qkt+M5/xnQuYJsQnY4sUMTbw6X0ETZvcK8CKhymtq11i0ra26esvjzVcHDACnenKhpEyvFV68pF8SZKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wvu4y434UlEZm6D4Km4OEPpw6qLd2r30srcegSknqq8=;
 b=tl5i3f4shRyzL4A3591FdlZAx8M3CoCXn0xvyaYtTHCMgt9gS293ehQDhVciBvSktcRlgEU8tUEnRLRqF/SJT66je/+xVT7M4LOCxe8nt/KX1zxjWPCxUv5A+klmRkh676WDvu83+BDLa/LgrFL2YF+TjQ/uPdSabt+uhBxONyo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:18:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:18:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/5] net/mlx5e: kTLS, Fix wrong value in record tracker enum
Date:   Thu,  5 Mar 2020 15:17:37 -0800
Message-Id: <20200305231739.227618-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:17:59 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: adcc1e75-822e-45a6-6e33-08d7c15b72b0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189D8E90F9A2DBA101A5558BEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(54906003)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GqhfZ1ziydbdhSsZZCe4jkeXp+zZEFPLSLksnT2+wwEf0MR3dizi7CQwTLSJmG+LhXS0u2bY8lj1SJBgdI/rDvnAFGxgVbZrtXiHvQUmLFzYd/K875r7tORwjbDZdwVOEsbVVLtM0rQEb0MQMFf+rU9lOisaU57m1Fog+jhXMeRs5PNhb2Ms3WZy8horPXWZEc4+Pmp/c8TqU+5Gw7JWydhuaFBjIJ1ClXBHbKih+pqM8eNHAfogR5hHwDwdwdyT8EYdZf8Bg2cAY8d2tTBfSX+QcWorswnC527gudufX8Gr9yczwGuk+euQPUmLMZXZaUmFPcy0wMi/qgWFkZDhTYbLAJxFOkQaKNMiy+6KbDJ8iL0XCeqBQsC/Ih+ydBMHGc2sVfs6DBMQ5IglvJu8vR5v0mme3ewmfm5Pk68s/RXuVAJdygbu+CclAEVRowGk2ibHoGeItykOHCb5XthdnjHmfJnpbMa5lMjYB1moVzrVjbapNbWxxHs6+EOhBSJNv47HPOcorKMTXsOXL2faLTufu4Bh2MSh4dUrX++6n2M=
X-MS-Exchange-AntiSpam-MessageData: F5tCfxZLCo4JjJmTdSil6QwOkfwl4FtcC+shQZArgoGDPbW+z6vPxWt4XfBezjwaf1T4CCs3HlxeZduZr84ozO26EWZ5BpUisHFieKmUSgKT1M5F/M6HSWbp0lTXr6eTaX7Nx2ubSvmR1hKCoJBLrw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adcc1e75-822e-45a6-6e33-08d7c15b72b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:18:00.9592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEu0V9rCwuncdtgf0NMbDrTQ3JRc01C1egvoNR3YJPPhzcXHs2/L63RChWxmDpb6gWMAiOjSGAqfLHNggdFS3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Fix to match the HW spec: TRACKING state is 1, SEARCHING is 2.
No real issue for now, as these values are not currently used.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index a3efa29a4629..63116be6b1d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -38,8 +38,8 @@ enum {
 
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 1,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 2,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 2,
 };
 
 struct mlx5e_ktls_offload_context_tx {
-- 
2.24.1

