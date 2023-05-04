Return-Path: <netdev+bounces-264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C467B6F68C8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7236D280CB5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC23363D9;
	Thu,  4 May 2023 10:03:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7AA186C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 10:03:05 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id C18D04234;
	Thu,  4 May 2023 03:03:00 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 48A3E18012BAF0;
	Thu,  4 May 2023 18:02:55 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: wuych <yunchuan@nfschina.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	irusskikh@marvell.com
Cc: netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	wuych <yunchuan@nfschina.com>
Subject: [PATCH] atlantic: Remove unnecessary (void*) conversions
Date: Thu,  4 May 2023 18:02:53 +0800
Message-Id: <20230504100253.74932-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pointer variables of void * type do not require type cast.

Signed-off-by: wuych <yunchuan@nfschina.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 5dfc751572ed..b0f527b04c97 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -93,7 +93,7 @@ static u32 hw_atl2_sem_act_rslvr_get(struct aq_hw_s *self)
 
 static int hw_atl2_hw_reset(struct aq_hw_s *self)
 {
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	int err;
 
 	err = hw_atl2_utils_soft_reset(self);
@@ -378,7 +378,7 @@ static int hw_atl2_hw_init_tx_path(struct aq_hw_s *self)
 
 static void hw_atl2_hw_init_new_rx_filters(struct aq_hw_s *self)
 {
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	u8 *prio_tc_map = self->aq_nic_cfg->prio_tc_map;
 	u16 action;
 	u8 index;
@@ -433,7 +433,7 @@ static void hw_atl2_hw_new_rx_filter_vlan_promisc(struct aq_hw_s *self,
 	u16 off_action = (!promisc &&
 			  !hw_atl_rpfl2promiscuous_mode_en_get(self)) ?
 				HW_ATL2_ACTION_DROP : HW_ATL2_ACTION_DISABLE;
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	u8 index;
 
 	index = priv->art_base_index + HW_ATL2_RPF_VLAN_PROMISC_OFF_INDEX;
@@ -445,7 +445,7 @@ static void hw_atl2_hw_new_rx_filter_vlan_promisc(struct aq_hw_s *self,
 static void hw_atl2_hw_new_rx_filter_promisc(struct aq_hw_s *self, bool promisc)
 {
 	u16 off_action = promisc ? HW_ATL2_ACTION_DISABLE : HW_ATL2_ACTION_DROP;
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	bool vlan_promisc_enable;
 	u8 index;
 
@@ -539,7 +539,7 @@ static int hw_atl2_hw_init(struct aq_hw_s *self, const u8 *mac_addr)
 		[AQ_HW_IRQ_MSIX]    = { 0x20000022U, 0x20000026U },
 	};
 
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	struct aq_nic_cfg_s *aq_nic_cfg = self->aq_nic_cfg;
 	u8 base_index, count;
 	int err;
@@ -770,7 +770,7 @@ static struct aq_stats_s *hw_atl2_utils_get_hw_stats(struct aq_hw_s *self)
 static int hw_atl2_hw_vlan_set(struct aq_hw_s *self,
 			       struct aq_rx_filter_vlan *aq_vlans)
 {
-	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
+	struct hw_atl2_priv *priv = self->priv;
 	u32 queue;
 	u8 index;
 	int i;
-- 
2.30.2


