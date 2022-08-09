Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3DB58D76A
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbiHIK3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiHIK3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:29:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B7722B2F;
        Tue,  9 Aug 2022 03:29:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUAGSavamofBz7+FIwn05tVs+4VGhvGqz3OirpeMVLJSuPgOnQgG3TG3Vuw9yDbwFQsAJoTQUGWYt/yTWrRH0iC+WwqanADiQOuOQULhgaVDBe4T8ytlfsl5bz+rCvbzqYXTTNu5iIt9Iyzxo51bLsYs1l188BOR4/qzIMFUcQ+Zs5ygM0yoSwGq70v5GPh43s0ZYewdDlzh7RV19WPEYhB/d+dAQJ6FK9Q8/ICWmHCoS+hYWxENGwPHynjqZtwSrmbNbInB/MsJ+Kts4A9PNpW4gmUdeC6FSI/2fbQE1Q6YG/5GDaHdOaE7QaheuOg8C4NzqGBapnM0b6XGRx9e1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40xtkbwNEFmf/1PDUzZxYA16TzPXFpfmDkEBzTf/2Ck=;
 b=oIfgjLUfGTjRMGMyGCiXTDj2QWAPXVTbgCsTLWT8ZwTmU4CDYvS6Y3e9ECPsLDvkzKO/jVLfILF3KmZoZlcMX3Z8zBRM3vXCvgEYg/rOUWfCyTai1pbzw9KIegg1lSegbZFIjIz2n4bxCDVpLkPJ0dgv/y6j2iNZ3na8GtLuwuKr7N6bobp2W9eUOO9GaPxNXREoDObXbGJonlIzuOcQmnbPiyuUT4QTh5aK0LqLcFW4xJdoiEUQxGrlX4Blcs7Kf/bctArrQ2D2xklRNg3WEipMoCGYHY4BseLV7XIG1I2gJ1NW4BwgsePC2EJ8udi4vpXeHJZ+xqqNpUYkgCAsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40xtkbwNEFmf/1PDUzZxYA16TzPXFpfmDkEBzTf/2Ck=;
 b=FVV5zzUJOj/X3WAPBnPlhpdtiptF9Zbdy6oxwkWfv6lTysFe4UQnxU70G5ex48LhoPtNE3X246WAIGmRbO0Pk0szKg/lQvlAUiyMA9oNTZj+f7Y2XSCU1+mOBp0GRGKsNSaqDesCIOaU4u2M/Wx79nRFLgRof7Zm3zg89nsGfwkb291QjUJtB6PGFihkh8bRfQrbY9nafKTj69PuDYRIKPFOsk25C26I899jbCZR+VmMwuDqkqeJzUVEVZ4i+aXL2wqad39524KRW0+oFxzjd6nBuejup0uhOc8PBOnRVSJCYf/fGJ8Y5SEWejFd3H4L5wyUj8ThuvYQ/aLPMvOF5w==
Received: from DS7PR03CA0157.namprd03.prod.outlook.com (2603:10b6:5:3b2::12)
 by BL1PR12MB5237.namprd12.prod.outlook.com (2603:10b6:208:30b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 10:29:49 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::76) by DS7PR03CA0157.outlook.office365.com
 (2603:10b6:5:3b2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16 via Frontend
 Transport; Tue, 9 Aug 2022 10:29:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5504.14 via Frontend Transport; Tue, 9 Aug 2022 10:29:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 9 Aug
 2022 10:29:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 9 Aug 2022
 03:29:34 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 9 Aug
 2022 03:29:32 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <edumazet@google.com>, <mayflowerera@gmail.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net 1/1] net: macsec: Fix XPN properties passing to macsec offload
Date:   Tue, 9 Aug 2022 13:29:05 +0300
Message-ID: <20220809102905.31826-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67ceb8e2-eeb0-4816-1d8e-08da79f216ca
X-MS-TrafficTypeDiagnostic: BL1PR12MB5237:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W70RldG8h5ezc9ivcEsciN8LEQ3/giKVYB/h2iIEDcxQbJ2s/bnY59Y0pbopyo0aDw/ULqkwnmyV5TFtDw0QSPlcRmvpnRI4dzfgh2ss9vKaoVmop7lyVernJYbg1KEdMDibfbuFvhVsckT4dNE/ItMHvz+ep9VhfZWRlJf2BOcG8/mSVlcG+7izXo4bAU4BaudixIauSZW0O4HwWlM8nK80ZtxHhy/1CMKsIbnvDIOoGmlEZl53SK/0Drug9jjhlzOh5ICsIzQKIAyL+oD7HjGB9BJgpqhsTMd43yB5K4kvHNx2aeGfMAHW0WsOqLouXYO1LQhsZaWUZSbcxEV7qQYr1+8UOHPe+C8HwcR79MltWVAL375Qak4jm6qFal2xMQIs/Ntki7YxChUASR20bACzT85CF2OVuAvZ5hBLQMckTscS42UNx/deIpSlmtey45ZEE5sJsZoCqsnfh0S9kC92Wal74hhugDwTllOQRI+MQXrGibZQR9urusChh2XpOsgHfsRl3e7F6U/BzCGUEjgAd4mxueM96e9fRy4WX7Jpz2ybdFjRX0EveAKXYVRXRHGn0XRm9GW8RCOKsuqNOJ10/Ap6uwwHy+gIbpWOViYQfl3paImBuonCStXdrNtCnGlgoVTKj3JNdxwbBzSTtt9+QZ7c1WBo+1io1ok9TLn9FwUSbk6cCa+wjQbzwI/dCOd7LKnsP0YrWh6NkFnvJwUwCvfJcmHNR+VBVfRCUVeOhb3Sy9okxB+x1edxtiTZH5Ge9y45h/CwvEvc9NOqIC/RkL1DuqTlMngZ6HJIK2UigZeITuwxXF2GMt2DuZ+r1L88mQgv4dbagbzGiy/tbg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(40470700004)(36840700001)(46966006)(5660300002)(2906002)(70586007)(82310400005)(36756003)(478600001)(316002)(110136005)(40480700001)(70206006)(54906003)(8936002)(40460700003)(41300700001)(81166007)(2616005)(7696005)(26005)(6666004)(86362001)(36860700001)(4326008)(8676002)(356005)(336012)(107886003)(82740400003)(426003)(47076005)(186003)(83380400001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 10:29:49.6643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ceb8e2-eeb0-4816-1d8e-08da79f216ca
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5237
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently macsec invokes HW offload path before reading extended
packet number (XPN) related user properties i.e. salt and short
secure channel identifier (ssci), hence preventing macsec XPN HW
offload.

Fix by moving macsec XPN properties reading prior to HW offload path.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f1683ce6b561..e0da161d94c8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1808,6 +1808,12 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	rx_sa->sc = rx_sc;
 
+	if (secy->xpn) {
+		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -1830,12 +1836,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
 	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
@@ -2050,6 +2050,12 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	if (assoc_num == tx_sc->encoding_sa && tx_sa->active)
 		secy->operational = true;
 
+	if (secy->xpn) {
+		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -2072,12 +2078,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
 	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
-- 
2.21.3

