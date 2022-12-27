Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251B1656863
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 09:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiL0I0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 03:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiL0I0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 03:26:09 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36BF2647
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 00:26:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/guCt4XrKcXjOFoYDkW1fU5R9T/StOwE5DGTJnbt8VUvIVg3a6KnYK8UiUdyoxr1Ije/q1tLUP/keBQqekxmabT5L/iREfwXKU3viN3G4tZML9FY6n+eV77jdYPnSrVogcVRk9+Nk6t/ITggc+yiYXrSK7o0xklFCFNXt+jO9iyslhDJ1ADd8YDX0L7p0Lo8TIOyTI20puKXeKa7zCEX+RqdzFeW8Z369LUycVgbMcJh++IIiAnDqAZzsB8FdSlLyfS2bF9NTJRd5Hfz5w3MuBdbeYMXfRgjdGhtY3xpncWaoxW9gweUSTTE0cMFHPVlyqD6ezqZyI8MFcZ/TOwaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOuEtyjZ+pqHDePK+LilzNj+v7zkd7Tjx3bTgbiplaw=;
 b=OY0EfgIGaa1Wf9wQVDus+/mrZ48v3BV3MoSw0Hvx8oAVP9JFYxo0PBmfRfWmq/+5mpEEncorGeZIVUQh3BByw4cJbv0thz8UCjuLUFCEPQeLAWIVQIAYgFhpAKF71bluiCV/vq1eiASnhfew5Rt5EAgHsoxyLAlEcgs2mN6vg97tUkCzu77DgYDwhuJxtyjxcDScKdZ7qgUaipQOi7VkrysMh/oneI+W/jg+3VV0Z/veRBzeRGa95HRWPK89+O8vUUksJQDH96pwIHB+xNtOU7Ep1+TeMvnuV4C0+KtbqekNotcQgaI8AU6/oV3yJTUZXBy1+KnHpMAEGkWIik9+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOuEtyjZ+pqHDePK+LilzNj+v7zkd7Tjx3bTgbiplaw=;
 b=dF3dGXRbUGEJLlB+qFgEPioBs3zGgIl11rHKYx/pI/1oobHuGxB0bZPNiA8swFfkb1o1JwBgkMLfu22QHAU4TDwAxnZMCZd0aQMhvQz9+dzHzFl+CaNOwrAD3ju54i/Y3gSBQW6hOf7GwPj2J7BBj6wFvV6LSpXr6knrfUUvlpunzZJbH2zuHUWd4QMSkqDyThD3NDVZyT1Qa7J77dbteLsTloJ4296vdmV0kNiXjxDGUdBqJeowlc+/gHS5Gwt9Dln/PwzjjYZpWzTmZBg/E9lIxgOMmJT8EF1Cf525lJLW87DLL853Wo8fvAH1wdVsdLhOzvljtzCFe07HuPJ6UQ==
Received: from BN0PR08CA0019.namprd08.prod.outlook.com (2603:10b6:408:142::12)
 by SJ2PR12MB7989.namprd12.prod.outlook.com (2603:10b6:a03:4c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Tue, 27 Dec
 2022 08:26:07 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::2b) by BN0PR08CA0019.outlook.office365.com
 (2603:10b6:408:142::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16 via Frontend
 Transport; Tue, 27 Dec 2022 08:26:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.17 via Frontend Transport; Tue, 27 Dec 2022 08:26:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 27 Dec
 2022 00:25:46 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 27 Dec
 2022 00:25:46 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 27 Dec
 2022 00:25:43 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 2/2] macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump
Date:   Tue, 27 Dec 2022 10:25:17 +0200
Message-ID: <20221227082517.8675-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20221227082517.8675-1-ehakim@nvidia.com>
References: <20221227082517.8675-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT038:EE_|SJ2PR12MB7989:EE_
X-MS-Office365-Filtering-Correlation-Id: e51dcbb6-cf99-48a5-e60e-08dae7e4003e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLIjFBO7K7FQaSMbJMpBOPeH/et3fWGf0FQiU+taqIEoJgmBil1KHs+fQjLGKwKsMTV4nzKEhIQBY8oBXpSV0WLrs2s8YMfei2iwhsYLEzfxOr1oNny1BbyUUq+NeDyhsNjvllEqBdzyUCtkGGoM0/aJjrrLGzCzb43tVNHaqPnaNwP+5fWfSFGrNLPkwmI0OsnI9n7I/MQe2e3pAS1sQ8MiOhjrs7itC7SuPma1r9m+mfPaFhzNIi70guHzINeEzI5t0h9VI/7HKpKcyVpHfJSkh3i2M3+cWwopWmNhNfNk1mQARUVPXS5JRlPDR+f86i4lmzO/LD7VEHYUeyu4Kbx7xDndUAUG9kE+uEg40X7PeZ5VbtDErQoBkJQW3hOT8tWoHfn4n3t4MK3isteczLXUJ//50rHLzkPnzec4g+01oPswiuHxA+mVhNUv1BHsk1Z8wj4rYCokNtsGlEVPunbVslKfmivV4bTYg3bmT+PmEYsMCo3tNaHpKVLrNbc26cUCC3DmVXG5fGnkrtzJBwEZwgyjYh2Trrb8DmKP7l4yTD8v2Q8pLtRbJ0HhNgBK1U10GlST0J1SRk0n3R7Lr1THELQ3JFDarztiiw/qbPuSPObm2GR8/kmVWPQj0/FBaoHXunXlcQi2u3l7uyoxq8X875kqgY1UlbtzFnZ3JF95Vz81voMKbcneolYOQ0/mCqCvbjM1cOoTq6eCrAmcuQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(86362001)(70586007)(4326008)(8676002)(70206006)(2906002)(2876002)(8936002)(41300700001)(5660300002)(40480700001)(26005)(83380400001)(47076005)(478600001)(1076003)(2616005)(6666004)(107886003)(186003)(426003)(40460700003)(336012)(7696005)(7636003)(316002)(356005)(54906003)(36860700001)(82740400003)(6916009)(82310400005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 08:26:06.6841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e51dcbb6-cf99-48a5-e60e-08dae7e4003e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7989
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

Support dumping offload netlink attribute in macsec's device
attributes dump.
Change macsec_get_size to consider the offload attribute in
the calculations of the required room for dumping the device
netlink attributes.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 1974c59977aa..0cff5083e661 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4238,16 +4238,22 @@ static size_t macsec_get_size(const struct net_device *dev)
 		nla_total_size(1) + /* IFLA_MACSEC_SCB */
 		nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
 		nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
+		nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
 		0;
 }
 
 static int macsec_fill_info(struct sk_buff *skb,
 			    const struct net_device *dev)
 {
-	struct macsec_secy *secy = &macsec_priv(dev)->secy;
-	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	struct macsec_tx_sc *tx_sc;
+	struct macsec_dev *macsec;
+	struct macsec_secy *secy;
 	u64 csid;
 
+	macsec = macsec_priv(dev);
+	secy = &macsec->secy;
+	tx_sc = &secy->tx_sc;
+
 	switch (secy->key_len) {
 	case MACSEC_GCM_AES_128_SAK_LEN:
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 : MACSEC_DEFAULT_CIPHER_ID;
@@ -4272,6 +4278,7 @@ static int macsec_fill_info(struct sk_buff *skb,
 	    nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
 	    nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
 	    nla_put_u8(skb, IFLA_MACSEC_VALIDATION, secy->validate_frames) ||
+	    nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
 	    0)
 		goto nla_put_failure;
 
-- 
2.21.3

