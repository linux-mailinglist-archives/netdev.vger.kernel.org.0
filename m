Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3434D585001
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 14:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiG2MON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 08:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiG2MOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 08:14:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3117A87F7D
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFc7fn2ZGLKrsF8FO8epoCjt3lVa/4kxYaUHcBYuV1QqonlNW5DbGSz4OO7DN22XNN3/7cjVo3oUlKx1t8cZerhGG9a4hbrHExQ62QdN7cSHt0VE1ePGG3Mw3ln4o+ntaRUWFFlx3LXox+QdqYyB/zU7ZLyP25xhVwjZonhbROi1hU1AvqCVfD2ry8I3tEhyY6HWdZTWSo2knzqfQvVToIbX2eOIBJ2Pau1dFh9XZKVzshTubtWADSFECuIIKK9k2f0AmdPHZC1slVI8yBZdoeQQrNy83Frevk9L9lC8UTkZGe+y+blP+aZgMDBPMd74BZmVtRqPAdN9elRK5b7XCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NLaD+NnQZ292mBZg8BmdcV2ZbtwXTTejK0u+2zQVxw=;
 b=Whbq5IaCcMmYMcW+rQkFTIzpZHW02tgVHs5WJDns1q68eKCFKTTttilS+fFSOuuLfUgCk+Xx+WQ3Ua40hEBnrO7Rx3pAc6DSYX7LVzxUnaGnS318p8z2MCvZmi7Xue+1tKT9+SB8aAZEywgtslO+4onOZ1cXGdtEQeMQkQwJprgijwd5KrZDCophSQqdvNWt+lv4djDRESkn9bk8TxEPrkfb6Lc0CTG1CRSe+ZzHtZJ6Pz759jNT0uo2e6Ji+waQwkNtlta4/nNLkn1J1dYmiy/pHb3NrbOrFGk6v750mpjFebdum/cGo5h6hVRoMcpZzINl79bGdgWFwL9ucaUxqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NLaD+NnQZ292mBZg8BmdcV2ZbtwXTTejK0u+2zQVxw=;
 b=uXbCMs2O8kCVfFU2qH5aSmbBmgTZg0IAwL8D6mIfPOwWhF1wcRj1oFxqUUuzcuoYmkv7NCrX0Py1XB4PvDdVjNlrZMC00iHgVSsFRh8GwUJC9XMFfFn2Rc0slcRjMEQYT9tG4V9yxpEXwiEDQgYGmjkQtrBKCkYTZ/Zn72YvKlOoaUDvtJ0lr9jkivZ+Yf9JA8PC9p5xjycy7EduBWhLLzFCOp8JtH3KwpEupNbxJa2AZQedRHg/BTX61DdUgay0v7r0EMMslT0ir7hrxZ+GoyCtLXitqzr0YJVN7vGka3ENIC3hxy9wuaH5Kg2ouu6015LXZWSS4lcc5poxU+2egQ==
Received: from MW4P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::27)
 by MN2PR12MB3807.namprd12.prod.outlook.com (2603:10b6:208:16c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 12:14:09 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::d7) by MW4P220CA0022.outlook.office365.com
 (2603:10b6:303:115::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Fri, 29 Jul 2022 12:14:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Fri, 29 Jul 2022 12:14:08 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 29 Jul 2022 12:14:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Fri, 29 Jul 2022 05:14:06 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 29 Jul 2022 05:14:02 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ
Date:   Fri, 29 Jul 2022 15:13:56 +0300
Message-ID: <20220729121356.3990867-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de24ff1f-e81b-429f-89d8-08da715bd6b5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3807:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LK+Yl3GG3xU6uE40K8iRNHKGAqhclzI01je8DtbSXFSLIkn+AWkPl+2eVhtgxrxAxeZazAXwi2IaGpmE3au7VnWz/CQtbXzWuDdxWM1Qk+A1W5aFyMqzgv/ifpQ0FW3GEF25Bluywxx1crqyDd7HaZKsr/GQSfEHLaNt+qRe42DsczdbnSEIf4Gyi7QHisefknyxYPVBT7EYV82tB5sMDsBq3ENwsnkgYl39Tmr3B0ymfPO+TXZQBHiWJwoKrFzTOJ5sNjoo7gPStb9XhkDTR1nZRsTII54I9WurekPXXbdSG/ENTLYToLzSsGco8wmcIPZjQ6tFYOs5E0FVZtE7ytzsFlTkt2A+5VPeQNPJVzEMnaBJtwGNs44HvfRAr5t99SH04g62zTkj2+4+qKnRSd/9CUpJqrxVWfTSn1IMCr1s5PE3fsFDUD/5DzxK2ynCF/pQa6/JRtzExpjjH4WXLVaITvF8n5YAdIsv13BdE4+Yswp0L89bmzm5232BBbAeej9feH7imCJsNwYPeY1Ir2+eAM0XydUZU53iEj3ThZXvLvobhG+UbVVORu/nZQjMFkBYnv9c2/3+kFQxuFLg5ItexdzwfNCYkbOp6i9EVBygHU4fe8+WgVMLzm0xrKHQpUh4ctSovP0SghR85xk+ZTF4vKs8Zk0OxBWAy4jiXS05nPs0m0a0+1z/xPS14fW6Kgu7E7EUGLRlrBwmYmeLnsqpsoZXpUQbmLaDEiH+qmHLjFX1THSTIZDLlLsPCjyNK159pxbDXU5r0LJBWmtXwECd3MBQFc/KioTHZ4gYRXhuXgI4uIQWxTlX8/+jxVkFiXLrAdRMd6kVByh6hPW0VQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(376002)(40470700004)(46966006)(36840700001)(8936002)(40480700001)(36756003)(82310400005)(8676002)(2906002)(4326008)(70206006)(70586007)(110136005)(5660300002)(40460700003)(7416002)(316002)(54906003)(86362001)(2616005)(7696005)(26005)(478600001)(6666004)(107886003)(1076003)(336012)(47076005)(41300700001)(426003)(356005)(81166007)(186003)(36860700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 12:14:08.3436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de24ff1f-e81b-429f-89d8-08da715bd6b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3807
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Striding RQ uses MTT page mapping, where each page corresponds to an XSK
frame. MTT pages have alignment requirements, and XSK frames don't have
any alignment guarantees in the unaligned mode. Frames with improper
alignment must be discarded, otherwise the packet data will be written
at a wrong address.

Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    | 14 ++++++++++++++
 include/net/xdp_sock_drv.h                         | 11 +++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index a8cfab4a393c..cc18d97d8ee0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -7,6 +7,8 @@
 #include "en.h"
 #include <net/xdp_sock_drv.h>
 
+#define MLX5E_MTT_PTAG_MASK 0xfffffffffffffff8ULL
+
 /* RX data path */
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
@@ -21,6 +23,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
+retry:
 	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
 	if (!dma_info->xsk)
 		return -ENOMEM;
@@ -32,6 +35,17 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 	 */
 	dma_info->addr = xsk_buff_xdp_get_frame_dma(dma_info->xsk);
 
+	/* MTT page mapping has alignment requirements. If they are not
+	 * satisfied, leak the descriptor so that it won't come again, and try
+	 * to allocate a new one.
+	 */
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
+		if (unlikely(dma_info->addr & ~MLX5E_MTT_PTAG_MASK)) {
+			xsk_buff_discard(dma_info->xsk);
+			goto retry;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4aa031849668..0774ce97c2f1 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -95,6 +95,13 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 	xp_free(xskb);
 }
 
+static inline void xsk_buff_discard(struct xdp_buff *xdp)
+{
+	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
+
+	xp_release(xskb);
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
@@ -238,6 +245,10 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 {
 }
 
+static inline void xsk_buff_discard(struct xdp_buff *xdp)
+{
+}
+
 static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
 {
 }
-- 
2.25.1

