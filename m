Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A426519720
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344788AbiEDGGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiEDGGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:32 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79911AD9F
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:02:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGjece50fswNKpBE5kLBXwnBFwqykBLGlgklxS0IAUmNgDmI4p1R3almeikRE29sz5da6QObIKTBZdKVYPFVNbkiwreFVASZWZTowxAjlo/4Q98l3+WpbvtX/NXKKTgCPBmzFRot5pCS0jVocKaSLz27Y8i2w1yzT6kojntAsbiJeohrPWk24o/wejiQhZhT0BCExmah5JZAIoBYpENDIgKpz1USnFt7HYYemgLTKQEelva1dYwGAfJ1MEdqPkc0byCMn+piNloqUNa0ysvQNZkJySgfzGBc10avomZ7HlNBAjBJgHA2SL7lh+mUkoTiz2XndG6fwSK0vNCZesHUJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+9jmTAw/6a/klmUbw5xt52ZTjLcKu4UtZ8HILzOu4c=;
 b=BEer5xYVBMJLWyQ9XYS9YEYUTYwM85sw6/wGPfFdr9QGJRJqVE+bAmlGeheZ3sf9pMofyy81EvyPHZ2w4EM2Ysr2axfBA6kcpJ5grvpFw6qnGaqHDEI3aSIeZHLpDT9MCeRVA8+yML+Th9Z1JUfJ3/3bjGuwFoIhwbI+pNmHOX9o+TEpPDaWT7jnqkllniOjLFq41NqpMf7x8kxsWeTpAypoP4kuBIYHZiHLWqtaIi8PnLbV5E1rNBa5HFj9hik1E/yMGpeaMmVKWWV7xfwkEZ9ZL78/CJflGQ+vM1TEFvIm9B6XDxIGk++6yaVCgWnkt9vx/zCAIgnEkua23Hb+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+9jmTAw/6a/klmUbw5xt52ZTjLcKu4UtZ8HILzOu4c=;
 b=nz+W4U5lVmC/+ioSAFPIdeMUppecn1ztBx7OiZPk/D1cWjJE41SVWDYeLwOYMktBNoRI82NUWGdjifxmvpc6760AX17WzXXGG2RUAc6Fp0CXGSvt209kjJ/b3JHi3/EOlfypeb2Gn0pPuR1wM0+S/MP1rM0YZy5jEp6pcrFJkue1o9NlX9x6/RBhmblPBjdk58osCFgLNsPNapO65Z0xh5nVGggxVL1xwg+6DRyIUtSRbj6J1Ip2tf4R67mD4SCWwDiPc9w/uNCvb0VT2HfFfGdzKSGmjhA/KU2RYfOHNYTkuYoXjW9cyq8Gty4Bmq8cgt+rhvO0FDVeMgnsfIBn8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:02:56 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:02:56 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/17] net/mlx5: Simplify IPsec flow steering init/cleanup functions
Date:   Tue,  3 May 2022 23:02:15 -0700
Message-Id: <20220504060231.668674-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::28) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03d1264f-4e4a-4ff4-76a5-08da2d93bbc1
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00066F03D4713CCD1AFC2801B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oag62+34GPysyD6bItoEq5/UxKESeXC3sBLOW8rZZshEYFwGdxV2yYuIYur48BnC+gPmklLPwLhxd4mG1uWknDbzMhi93cb0gqFO3zyLJZhiVUf23599/twcU3R7EpdOW0j3FCQ5omOKleKndRcjyaremBJedrcBSVr+44+xLPF7kxnYkj8hUUDbhyOlDsFqG2T6C5eQb0FAgU60tMVHGYWM8sP863SS/2gLIbpMF/BZoFScyRe6Bf/JEcQr6PFZnkPX7+oDmLuIbUOkqQcL4VVqQs+5IIDjRvIXJIKcgv+s0QlhFGbnhTs7u0MZszrykSL7yKyPb3R3bGdjX1eIiCHE0rOwy63NkKtMSTjWKWCBt2pC4HH7rTlfjOeVyCayYa0fuiSjfGpDytGn9yRuqZiIYEu+NOH6n3jqfy/BAU+sDxajA0BZyB52aZD15tztk0YRJnXtpwoFRRukASymixiefgrcN106WECAibMPbitwv8KsjMJQigNijRre8ayLK7vGE9SoGFq1hEOVHTX8PWrFa5C0eJtYnBDplN6iHgm5u0t0pEharBgLkjqY6HJxrnu+OtFP7DluiNmPyki7PvYOebrxNlVcBO0QS2chhvWLY2mTVaAvhwQtef5Vvxd6vtMlgWdJvG94vSDVpHLUcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sANyIYQxRc+FKpJLRWXL49u879xiDrHW5n76mwU+ilB3+TyaIjFD7nDTcRZt?=
 =?us-ascii?Q?8vpCmihjGokJoQmlK7KEVTDmOr4Vy1nQfFtF2eVNOiUCrwFPgQ60cd+ommn8?=
 =?us-ascii?Q?c3PN0JyS9a0tf9Npebls1aEALpD6wbgjyjtECNsFS9Why8wHCL/Wzlifot0k?=
 =?us-ascii?Q?lPl2PRMJwGVbNx3CnHbTTFTA/taWtZnId2NsDpx3VcK4GcdUAjb599Z3N06O?=
 =?us-ascii?Q?TChVLmH+K31QxRTCVrc9wRuGHn7YxU4EOPzppRR9gYV3/0IP5FhlcaS1MF58?=
 =?us-ascii?Q?ddExE6iOSWi8b7loUrzbpQduWNUGiNql5KYNOaJIyNXOYyNwLvwpQ5B4oIMb?=
 =?us-ascii?Q?c5AJsKl4CoThOHwGfuq03ULMwmNMDnvNWsoRhcnGEDMKok5aJ70cr1Uzijab?=
 =?us-ascii?Q?mrGzgP0nZIZQLSQQ0IJuLizdbPdrqm3u0ku73p/JL3TWuPumrW5KniO8vNRA?=
 =?us-ascii?Q?yItx+BmSGO1x9J5pQ2roF8R/fn6OvzRYGjlAoXnupOI3ViQrIP3/uPlegy4a?=
 =?us-ascii?Q?Obv6WM9bJJrJB2oyd5DNoFev5Ql2qYvUvOtin8dpFbYq9OoG2N0Q6dcPzyUN?=
 =?us-ascii?Q?BAcsJA/hlaqboAdr14L6iFyutY0+mDiArtoOBNRy351OGUSJwB8VgsWXng5L?=
 =?us-ascii?Q?7W2WS0rbXyIFL2L+7gEeRQBN5eoea4TKGzdmaevRWzFe3tG4KzhRFhfPO4Oa?=
 =?us-ascii?Q?vhX4Mb+8TA4dBLRM8wrBHjv/bbJWCbUbNQf7yer/Cdg/p3acIKFPKV9AMUtu?=
 =?us-ascii?Q?9XtSUV6YHCjWzxx1VnBJwWdRQe0v7AR1AreCl9XpCAc7zhXTH3TmUb6UDhu9?=
 =?us-ascii?Q?or1advVfxKqJFQX61pNiOFlv5FhD4ZMmgbhUpYeUgvISOyt63iisx9wPn9WW?=
 =?us-ascii?Q?2HzJSG9R9AnZ2/wxDbeJrCAe+R2NOq9IDpK986mmmLQDsvG/FvemTJiij8XE?=
 =?us-ascii?Q?q/FvA73WowTcZEIo640meIwXYULyFhmU1h5reBlkZnGmiF6LRBEewJ6VYReH?=
 =?us-ascii?Q?KnjxmxkkaG8PNcE0KyjpzWz4vcRcGGzRMnLHdHNnu3NYBB/CT7kAyGMfhOmh?=
 =?us-ascii?Q?3PhGlw2QN/M2XzQuPTZYzwdUVjYbWDpc1GtJPi35A6m/MZObgjUcJPEd9nlW?=
 =?us-ascii?Q?Seg9379jd5EfJxDEOzkTGnuhnb8ehkQojTRmkE5t8d0ArG3C64On6xixnFua?=
 =?us-ascii?Q?PnvezY7fBKxm/fbWuGXwfsLI/1CmOHi6y98HcwkdCWDRjkoaEAZLH1wEDTQn?=
 =?us-ascii?Q?iEbWoti9VS+pfwHnGGuNI6/mQRsIueRbfKYPn6FsbyTOUInQn98EmPXsf+NR?=
 =?us-ascii?Q?d0fARBna67+/8zfj8ndZWnGvBnM9nna2nK2Wfczw3EnFpWuj2ZdWc0UACljL?=
 =?us-ascii?Q?hcY9vEtIp68SoOiYXYd2JORAhmkAEaSYV7tm3E9fxsA+jPrggqcCyxm165O+?=
 =?us-ascii?Q?E0VPC1Uotd4ZM8SYOj5avsXchD1FhuEZpat7MsUjoBr934uonSdgrok/Y/6/?=
 =?us-ascii?Q?soPGdQsT5uPWo7Qomu1Wb62XOzVUYx2HDd/ZNG1k+X/7K99oPKMspLeK/lUe?=
 =?us-ascii?Q?jSdk1ALvsbzwpXNe+1s3EoEodQDKN+v5FEO5QGhxzz1UkOuJoqacMmpXDbMg?=
 =?us-ascii?Q?iJQ3V0YcvPWJoS5sAxUNehmppcWe3+uwOpu9Mk2Rp8SUtnA0ErTPt4lpsEo3?=
 =?us-ascii?Q?nwQKP98/DDROGnERnZNxBl31RhEVScqJdmu2cpxvvmBAr0cDwDukHHyVCFFG?=
 =?us-ascii?Q?ZTVE0Y0RCbF5lJxQ8zyYbADxp2EKImE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d1264f-4e4a-4ff4-76a5-08da2d93bbc1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:02:56.1681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rmwvDe97letgouYRJ7xwTpseOtZeaCmQaBQRy8rL2IGUy4aH0GcRZ2YnmrLbEppTtyNqRiwbINCkK8sP1L+Lyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove multiple function wrappers to make sure that IPsec FS initialization
and cleanup functions present in one place to help with code readability.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 73 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  4 +-
 3 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c280a18ff002..b6e430d53fae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -424,7 +424,7 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	}
 
 	priv->ipsec = ipsec;
-	mlx5e_accel_ipsec_fs_init(priv);
+	mlx5e_accel_ipsec_fs_init(ipsec);
 	netdev_dbg(priv->netdev, "IPSec attached to netdevice\n");
 	return 0;
 }
@@ -436,7 +436,7 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	mlx5e_accel_ipsec_fs_cleanup(priv);
+	mlx5e_accel_ipsec_fs_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
 
 	kfree(ipsec);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 66b529e36ea1..029a9a70ba0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -632,81 +632,54 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 		tx_del_rule(priv, ipsec_rule);
 }
 
-static void fs_cleanup_tx(struct mlx5e_priv *priv)
-{
-	mutex_destroy(&priv->ipsec->tx_fs->mutex);
-	WARN_ON(priv->ipsec->tx_fs->refcnt);
-	kfree(priv->ipsec->tx_fs);
-	priv->ipsec->tx_fs = NULL;
-}
-
-static void fs_cleanup_rx(struct mlx5e_priv *priv)
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
 	enum accel_fs_esp_type i;
 
-	accel_esp = priv->ipsec->rx_fs;
+	if (!ipsec->rx_fs)
+		return;
+
+	mutex_destroy(&ipsec->tx_fs->mutex);
+	WARN_ON(ipsec->tx_fs->refcnt);
+	kfree(ipsec->tx_fs);
+
+	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
 		fs_prot = &accel_esp->fs_prot[i];
 		mutex_destroy(&fs_prot->prot_mutex);
 		WARN_ON(fs_prot->refcnt);
 	}
-	kfree(priv->ipsec->rx_fs);
-	priv->ipsec->rx_fs = NULL;
-}
-
-static int fs_init_tx(struct mlx5e_priv *priv)
-{
-	priv->ipsec->tx_fs =
-		kzalloc(sizeof(struct mlx5e_ipsec_tx), GFP_KERNEL);
-	if (!priv->ipsec->tx_fs)
-		return -ENOMEM;
-
-	mutex_init(&priv->ipsec->tx_fs->mutex);
-	return 0;
+	kfree(ipsec->rx_fs);
 }
 
-static int fs_init_rx(struct mlx5e_priv *priv)
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
 	enum accel_fs_esp_type i;
+	int err = -ENOMEM;
 
-	priv->ipsec->rx_fs =
-		kzalloc(sizeof(struct mlx5e_accel_fs_esp), GFP_KERNEL);
-	if (!priv->ipsec->rx_fs)
+	ipsec->tx_fs = kzalloc(sizeof(*ipsec->tx_fs), GFP_KERNEL);
+	if (!ipsec->tx_fs)
 		return -ENOMEM;
 
-	accel_esp = priv->ipsec->rx_fs;
+	ipsec->rx_fs = kzalloc(sizeof(*ipsec->rx_fs), GFP_KERNEL);
+	if (!ipsec->rx_fs)
+		goto err_rx;
+
+	mutex_init(&ipsec->tx_fs->mutex);
+
+	accel_esp = ipsec->rx_fs;
 	for (i = 0; i < ACCEL_FS_ESP_NUM_TYPES; i++) {
 		fs_prot = &accel_esp->fs_prot[i];
 		mutex_init(&fs_prot->prot_mutex);
 	}
 
 	return 0;
-}
-
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv)
-{
-	if (!priv->ipsec->rx_fs)
-		return;
-
-	fs_cleanup_tx(priv);
-	fs_cleanup_rx(priv);
-}
-
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
-{
-	int err;
-
-	err = fs_init_tx(priv);
-	if (err)
-		return err;
-
-	err = fs_init_rx(priv);
-	if (err)
-		fs_cleanup_tx(priv);
 
+err_rx:
+	kfree(ipsec->tx_fs);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
index b70953979709..e4eeb2ba21c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
@@ -9,8 +9,8 @@
 #include "ipsec_offload.h"
 #include "en/fs.h"
 
-void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *priv);
-int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv);
+void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
+int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
 				  u32 ipsec_obj_id,
-- 
2.35.1

