Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADD197574
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbgC3HRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:17:33 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:55440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729373AbgC3HRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:17:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQQ3KkvuCE2JhUlQS4BN332FgE/GcgWsbcgQetU2TfSk24LSh4vmPYN3Lvw5mVbfbLty1AUUV9I9gngRrzXTGim/C8BqnCXgKGsNJ9XkYI5lJhWOnmxgnATjfLRHQMg+ZDQbw68V/Rg+8c92MpTdJ1vAcwc7RIVK1M+uIGPF2S2mtzcsU77ST67cht439C755LCNTiTtRSNqtdSGJp7C6T6YFrcIXXGa2ceZ/CavlCbEbJ/mkCU7T2EnDJqywfBk8BDbBWMa3OCW/BflrVgkYVkgJ8cOo3gm2fQSvjcJTOlLBFOYrj282Kk3ut6ewni74h2f8SHVUyFvKZQD+CJJrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0bY7XfT6cNRmnTgHL4C1SbFzjkruvm+HA5noTr3plI=;
 b=NKuC03iYF8K1jdhy+WkpHa5jztV2BWUT11xIksI5ccqjqduC/nbFzJCZC2aUVvZx25GfC9YjloOj2V4X+NAdq2ev66UdDqdwO/lOcyHir1tjWvsGdWmpGXFlbwK7oq8Ms6KrwRzCpdPBQjltW6XE2fQwLvKixlc/82l51JI+PQ5Jcf9tvYBGydhR8nsjDzYPY24yFyaCWlA7wDDN6kb34QZkxF7IH0M57cgXOCjYwpGSyN33gcq+Sn9JZl9lDy08tmblICT/B/tWi2jd/MzeGAKMA3mF4b6Wg3n37bTy/Usuv5lDkR4i1UIjGIecvixYAW6kDCs7fqDljm6Ag+5qug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0bY7XfT6cNRmnTgHL4C1SbFzjkruvm+HA5noTr3plI=;
 b=nxAlmsV2VNGjXdh2FKRPTmiIIDbcJbH3+UrBXxpVaqYmZje2VQsfSTVln74hs8kHNALvKvRIegkt0PSS6yMtxGSKN8RzDqST2qEaKHcmIcsgeQT5xEwU5fmSul48a5kY8u1hfvRVFDA1kbM3RooY1lj95L6nonXPhOGnI4s1bWE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4989.eurprd05.prod.outlook.com (20.177.52.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:17:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:17:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/4] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
Date:   Mon, 30 Mar 2020 00:16:55 -0700
Message-Id: <20200330071655.169823-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330071655.169823-1-saeedm@mellanox.com>
References: <20200330071655.169823-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:17:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8648c18-a542-438f-086b-08d7d47a672f
X-MS-TrafficTypeDiagnostic: VI1PR05MB4989:|VI1PR05MB4989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4989139BCB1B5E4E31CFD700BECB0@VI1PR05MB4989.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(6512007)(8676002)(107886003)(478600001)(81156014)(66476007)(86362001)(66556008)(4326008)(6486002)(66946007)(6506007)(16526019)(6666004)(54906003)(52116002)(1076003)(8936002)(81166006)(186003)(26005)(2906002)(316002)(956004)(2616005)(36756003)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aYyWrpndg6w4zJscp77eyxwdjYRORROzDon5pYxTBUvYtyVT2LijIMY6F3TXHDZ/qi3EEz4A7m9jXEYaVMxbK4JFv/uqwAp+qN/6XYCNgG31Ha9OWW4scoMtofq1RFPbqgUbaLZmYHiaLuUiCRZAwvlYxSd8l3IN62fLx2UrbM+f6fqC41RHjH0HOYHuG1cCZ1NyDg286++c+VN6l6kcV315NUtR/l18/yazKjIERPHqq7Pn/DsAS9AyeQInpuUVTMgOCRiCdZhzB/K74ZrEOG0tDJ7zbyF6TbTRI32Z0b+fwOF7Q0xC3+M2IXFPTg6Ege7vr8IYTM39MHNBA9cCHQn/t7JfhU/plxeIkzJ1RFTQiDAC9uWxztU5SbUKZzgTPnxDt1zsb8v63PBbSoDPbYh3MP8Px9Rp0c7XqSOGCGT0GPGwuDGPiU+fm7qZ76Z7sQ6jzkI7PaNkWVJe3HGhglXbnkRyGYNFd8smv0LUP6VujUtP8HozH6OpDOEXRuo
X-MS-Exchange-AntiSpam-MessageData: fyT+5bCIgygAtUSZHLWkvNJRFk+RNG0ZIdgY5z6xS8XIYNhpjNYCsakN71x6U2YXVdZe2aY4jBG+vrwe/Cf40SVXBppN5XIubU+XaqcHuPXFAZFq1ONQeAc+pJ33MlPhme5YW2gDSMckd5HYxgcK2A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8648c18-a542-438f-086b-08d7d47a672f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:17:28.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0//iybdAQ6fxpLVVFrCWo2hsEm7MLjdnYIYD6kRCVRbkAWXfKVUpfosnAkz2EIstIGRjz9IchYVilIDOtUCQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
in FT mode.
Both tc rules and flow table rules are of the same format,
It can re-use tc parsing for that, and move the flow table rules
to their steering domain(the specific chain_index), the indr
block offload in FT also follow this scenario.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4c947b14b56d..2a0243e4af75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -732,6 +732,52 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
 	}
 }
 
+static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload tmp;
+	struct mlx5e_priv *mpriv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	mpriv = netdev_priv(priv->rpriv->netdev);
+	esw = mpriv->mdev->priv.eswitch;
+
+	flags = MLX5_TC_FLAG(EGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		memcpy(&tmp, f, sizeof(*f));
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 *
+		 * FT offload can use prio range [0, INT_MAX], so we normalize
+		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
+		 * as with tc, where prio 0 isn't supported.
+		 *
+		 * We only support chain 0 of FT offload.
+		 */
+		if (!mlx5_esw_chains_prios_supported(esw) ||
+		    tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw) ||
+		    tmp.common.chain_index)
+			return -EOPNOTSUPP;
+
+		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.prio++;
+		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
+		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
@@ -809,6 +855,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
 						  mlx5e_rep_indr_setup_tc_cb);
+	case TC_SETUP_FT:
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_ft_cb);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.25.1

