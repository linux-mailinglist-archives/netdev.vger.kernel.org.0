Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE83E262476
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIIB23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:29 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5202 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgIIB2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:18 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582f7f0000>; Tue, 08 Sep 2020 18:27:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 08 Sep 2020 18:28:17 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/12] net/mlx5e: Use struct assignment to initialize mlx5e_tx_wqe_info
Date:   Tue, 8 Sep 2020 18:27:47 -0700
Message-ID: <20200909012757.32677-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909012757.32677-1-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599614847; bh=DnzRCo60NZN0LT1CrK2LVLn1etYn7HpDMI5OUJkmdk0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=LtRUYA2sRSNlwuiF9tcONjXVQwiCGPkOWylpwDuyEGOWBFEx30YRTpFFJaPh/CRU5
         Ax/xdbYDLvLAgRjhOYhIt8sOSlznu3s1LJ01dCZmrkcOM4XgvrS84BzOPFCu+Qnufy
         /EryGuVI4dYu9zxp3PfSLgEbh1pBH+KdXBox74pMfx9zS8/TGwT6IceipaQf5veVG7
         oVmrKZWDP3JvgS8eMKVIwC/MyoCefkwWE2j4LmpBEwLJUxpQvEQWRHHmWrh3xEek0s
         6YcvsohMdXjA3HUt6+64l+aVer/iOkl7atFqNBW5AvRRJqkCk9Q4wN4y9Fty0funjx
         9ukNvZuS8CdwQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Struct assignment guarantees that all fields of the structure are
initialized (those that are not mentioned are zeroed). It makes code
mode robust and reduces chances for unpredictable behavior when one
forgets to reset some field and it holds an old value from previous
iterations of using the structure.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index e15aa53ff83e..c064657dde13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -241,10 +241,12 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct s=
k_buff *skb,
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	bool send_doorbell;
=20
-	wi->num_bytes =3D num_bytes;
-	wi->num_dma =3D num_dma;
-	wi->num_wqebbs =3D num_wqebbs;
-	wi->skb =3D skb;
+	*wi =3D (struct mlx5e_tx_wqe_info) {
+		.skb =3D skb,
+		.num_bytes =3D num_bytes,
+		.num_dma =3D num_dma,
+		.num_wqebbs =3D num_wqebbs,
+	};
=20
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | opcode);
 	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
--=20
2.26.2

