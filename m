Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69745265B4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356258AbiEMPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345226AbiEMPMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:12:34 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9F453709
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 08:12:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2E03920694;
        Fri, 13 May 2022 17:12:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mNB_soqx4bPn; Fri, 13 May 2022 17:12:28 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6374120689;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 545D180004A;
        Fri, 13 May 2022 17:12:27 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 17:12:27 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 17:12:26 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4AE5A3182D4A; Fri, 13 May 2022 17:12:26 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/8] ixgbe: propagate XFRM offload state direction instead of flags
Date:   Fri, 13 May 2022 17:12:15 +0200
Message-ID: <20220513151218.4010119-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513151218.4010119-1-steffen.klassert@secunet.com>
References: <20220513151218.4010119-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Convert the ixgbe driver to rely on XFRM offload state direction instead
of flags bits that were not checked at all.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 9 ++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h | 2 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 6 +++---
 drivers/net/ethernet/intel/ixgbevf/ipsec.h     | 2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 69d11ff7677d..774de63dd93a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -585,7 +585,7 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		struct rx_sa rsa;
 
 		if (xs->calg) {
@@ -757,7 +757,7 @@ static void ixgbe_ipsec_del_sa(struct xfrm_state *xs)
 	u32 zerobuf[4] = {0, 0, 0, 0};
 	u16 sa_idx;
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		struct rx_sa *rsa;
 		u8 ipi;
 
@@ -903,8 +903,7 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	/* Tx IPsec offload doesn't seem to work on this
 	 * device, so block these requests for now.
 	 */
-	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
-	if (sam->flags != XFRM_OFFLOAD_INBOUND) {
+	if (sam->dir != XFRM_DEV_OFFLOAD_IN) {
 		err = -EOPNOTSUPP;
 		goto err_out;
 	}
@@ -915,7 +914,7 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 		goto err_out;
 	}
 
-	xs->xso.flags = sam->flags;
+	xs->xso.dir = sam->dir;
 	xs->id.spi = sam->spi;
 	xs->id.proto = sam->proto;
 	xs->props.family = sam->family;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h
index d2b64ff8eb4e..809ab51a7842 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.h
@@ -74,7 +74,7 @@ struct ixgbe_ipsec {
 
 struct sa_mbx_msg {
 	__be32 spi;
-	u8 flags;
+	u8 dir;
 	u8 proto;
 	u16 family;
 	__be32 addr[4];
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index e763cee0695e..9984ebc62d78 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -25,7 +25,7 @@ static int ixgbevf_ipsec_set_pf_sa(struct ixgbevf_adapter *adapter,
 
 	/* send the important bits to the PF */
 	sam = (struct sa_mbx_msg *)(&msgbuf[1]);
-	sam->flags = xs->xso.flags;
+	sam->dir = xs->xso.dir;
 	sam->spi = xs->id.spi;
 	sam->proto = xs->id.proto;
 	sam->family = xs->props.family;
@@ -280,7 +280,7 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		struct rx_sa rsa;
 
 		if (xs->calg) {
@@ -394,7 +394,7 @@ static void ixgbevf_ipsec_del_sa(struct xfrm_state *xs)
 	adapter = netdev_priv(dev);
 	ipsec = adapter->ipsec;
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		sa_idx = xs->xso.offload_handle - IXGBE_IPSEC_BASE_RX_INDEX;
 
 		if (!ipsec->rx_tbl[sa_idx].used) {
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.h b/drivers/net/ethernet/intel/ixgbevf/ipsec.h
index 3740725041c3..d22990165353 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.h
@@ -57,7 +57,7 @@ struct ixgbevf_ipsec {
 
 struct sa_mbx_msg {
 	__be32 spi;
-	u8 flags;
+	u8 dir;
 	u8 proto;
 	u16 family;
 	__be32 addr[4];
-- 
2.25.1

