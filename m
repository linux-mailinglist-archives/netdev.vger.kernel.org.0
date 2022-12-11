Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E183F64931D
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 08:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLKH4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 02:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKH4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 02:56:04 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799DDE01D
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 23:56:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko4H9y9ab805Bm5NqkCtzTu8sN3uhYaUlmCP27ryuLeeiFOq4//sViEuzmExHKYc2ZgkSU5N4lrsfhGZnMuDJzPeCuPkwOHfbWVQEIOBdGchNTGUaDS9WjhyMKwDdcihcw7+O1DpToimb0dnjWQfZQMiguYotYUk7N6+fFj6iUW2NtFo2Ri4a9WqpoGnK9UilO/oaJ/+UdeyuH0pWw5MzpD3hk6bFAJ51XKuC1/2qNafU6uOl3kZQ9jkcOXy9zadDgU0RocNYQXcdlrJ3AMPn3NyiuB6k2nW64vmxZcjoUgU8Sr6mpHER0m0wfo4aSKdPj0GXSFsudfoGiaYSSqiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDM/xKNvpK7hwZgnM75mGFlLB44SC4YVVOQRVh7u004=;
 b=Z4z393fw/r0uL7+IXt6hVm4ENXDR+btemGCDz3UO5JQmkCxOLEzn/qd9JuMtNS6Lv3wZD9+aqoy5w7wYZ+KW1WqLi+LzqR+GuMY0JLphGBERGdx9eFqmfwk8LxHDMrxlvPbcvEyN9GFfRm7mGtyUoSzGG6m6iql74UoYzi2JOwftKn/VT/KqfAhVrx+H8LPK51agY0ZOCXpq6GjHmWfBeYpmOlxUJNTxmOo7aIJO2rOGZoQWBejuqFiV6Cvpvoz/1XHDVId8CSC6ZcyZahevSA1sblMPwpD6N/xTe1N5mk+7h/txKrNVHyjrcG9exBIrOkiuKTmBgybt6w2TbR+VEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDM/xKNvpK7hwZgnM75mGFlLB44SC4YVVOQRVh7u004=;
 b=Y2psiLMkCE9ojvj2ivRPxVqR/eQ/Jf/yW9Oc0NIEszrIJzkRGZ8GCFdazyhdGIjFgr+G/2/5wctVHsBqEGcXiy6a/uUFDXG+urt4rD08y0IlbDYI9CDU/rFjVVyYWvFGp0bp5yhC+eUeB26UMRsz08UaNSKaeJRyHs5dD17k7b9OGncE21V33fd0u/LqU3eIk3ZxHWGGiObq1nhy9zNrIQ7BzbxPxOvpe9do2Gcy3e6SeEns3x3q3aEELZzfBB/0LFURbXg5TYAGz1BpHTy5H90+QSKwrKKCAKL7TAkjqnySOZChphnBCeT+yyA3jiMlzjXW/ebQZYMQpaQIIQEWhg==
Received: from BN8PR04CA0029.namprd04.prod.outlook.com (2603:10b6:408:70::42)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 07:55:59 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::d6) by BN8PR04CA0029.outlook.office365.com
 (2603:10b6:408:70::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 07:55:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.20 via Frontend Transport; Sun, 11 Dec 2022 07:55:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 10 Dec
 2022 23:55:45 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sat, 10 Dec 2022 23:55:45 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Sat, 10 Dec
 2022 23:55:42 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net] net: macsec: fix net device access prior to holding a lock
Date:   Sun, 11 Dec 2022 09:55:32 +0200
Message-ID: <20221211075532.28099-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: b1c7bfac-e81f-4b30-4e3a-08dadb4d2066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86i6cb8LNTmF/UKB9GeGR8plPK+q9D1zdjLpMJ8DF78tR1cQSkDxRVpog4xGzUcM8NMLCJ75QHzhS327p4ieEfcuuLg2gDGijpBiJP6a8EeO+0cDl9+RuxLzjpEJtpdOmO8vryup8vEV6v1XU3QBztvcHKf0C+49kcBY37CAlkO/OIvCTSVviCItdI6Zc9KxhHsTKYPqBdeY28Gj10Rg1UUSWp7Cnhkg2sfrZfw4NP5svfpn7OcX+I8mVv2DDqde5w8WwlgcZUw5khnsKVG5tiYBwUd+dfCSHyiIfyrj/81RSlqV2A8VG1r5mVImjWGawoqovrd1ENmdmJroYrPw2V0zViHjZ+IbO8t91iFvVoLOSmsj5uTYuaJjnkkm0IyJjmbnoKV+EOZ+CGnUreV9Gs2IJkvDMeaX+hPi4AgDg8LhIpN4ZAC7aqb1hu53EaX6rFQKIha9SP4+df7U15VsCnKOqYNfWaZp8MJZ4WFA3F4qBYket8BIlmtxfdKf75U9L3D+tfNHi0tvQg2CbQafy0Cw/a+Aww6Ymbii2usABAk+egWc9AzI23FTtDeUuCxnt/EO/93DrhxJfzAqeq0j5EGVHmCvQf7YQ+xM1SKH9x9xLmtJmKSOfmQ46K8D0b7ZsJRNxDIIvYnhhfILPvFi03Lb3xLz+KBJEExYZ/cbhdtz431JJuwkWqW5byw9s4A3vBFu1wmMw8kK7f8aRGDjYQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(356005)(7636003)(82740400003)(36860700001)(5660300002)(86362001)(2906002)(40460700003)(2876002)(40480700001)(41300700001)(107886003)(6666004)(478600001)(4326008)(8676002)(70586007)(70206006)(6916009)(54906003)(316002)(426003)(47076005)(82310400005)(8936002)(83380400001)(26005)(186003)(7696005)(2616005)(336012)(1076003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 07:55:52.6855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c7bfac-e81f-4b30-4e3a-08dadb4d2066
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently macsec offload selection update routine accesses
the net device prior to holding the relevant lock.
Fix by holding the lock prior to the device access.

Fixes: dcb780fb2795 ("net: macsec: add nla support for changing the offloading selection")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2fbac51b9b19..038a78794392 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2593,7 +2593,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	int ret;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -2606,28 +2606,36 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 					macsec_genl_offload_policy, NULL))
 		return -EINVAL;
 
+	rtnl_lock();
+
 	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto out;
+	}
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
-		return -EINVAL;
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
-		return 0;
+		goto out;
 
 	/* Check if the offloading mode is supported by the underlying layers */
 	if (offload != MACSEC_OFFLOAD_OFF &&
-	    !macsec_check_offload(offload, macsec))
-		return -EOPNOTSUPP;
+	    !macsec_check_offload(offload, macsec)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	/* Check if the net device is busy. */
-	if (netif_running(dev))
-		return -EBUSY;
-
-	rtnl_lock();
+	if (netif_running(dev)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	prev_offload = macsec->offload;
 	macsec->offload = offload;
@@ -2662,7 +2670,7 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 rollback:
 	macsec->offload = prev_offload;
-
+out:
 	rtnl_unlock();
 	return ret;
 }
-- 
2.21.3

