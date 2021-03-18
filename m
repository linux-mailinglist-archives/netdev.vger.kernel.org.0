Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E799A33FEE3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhCRF3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 01:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCRF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 01:29:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B29C06174A;
        Wed, 17 Mar 2021 22:29:43 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso4369782pji.3;
        Wed, 17 Mar 2021 22:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RbuwDgXpSXFGfqetRu81GRdpbG0OTNFIJz0GZHrmSGw=;
        b=Mb+erzr3mDsJoiEDqGRBuhAMASUIk8TIRlGmf4UCuET4daMCtws4nCptan6OC/XjaI
         WidhWYgI/goZezuKeyNVsGvZepz6EdJzI/RLJB+ul7w6Mu7yOMbKkgfOZanEArfIsbzD
         kZ9QYwval+UDlTj2uPMZn6JFumUp1z8G2YXi1wABGQA14XP/ZVvHNPqJYO5cCiuLcKjT
         Adejrb7L0cl4PWjkcC309fkBMQWpaPlwSh45o4AU4I+4StO9grokQ/rvCc0poR7Zrc/r
         cnnKyQxkyZcI+qNdXgcEY7y3L9sdy9vMGKsmIbJixDFu9XHtSFx6+K/McJ50iM4nJ480
         OgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RbuwDgXpSXFGfqetRu81GRdpbG0OTNFIJz0GZHrmSGw=;
        b=j907BmvMSqSytuB8hw3DxA4r/iCKA5FjFUVLBvumn5AcEkdEizSKr0+M57Q1HQX3bE
         1fCt7gNP3licYhlOFs/6gjAPONZ4ZtxKWXwKP60wrOV91HZ90eyI/b08nUEVyVLOJNMV
         GJKkv0ULO+0vEqrWjLyZwEnV2+7mRhF4bBGwc1sI0OJbeexfMBRp0526ZhG3+4EJPFWo
         gVVfFqcrNbSOpEri3aNSf+KFH4mbsA0oVWqalmNNKiXGR8bmr2c0nlvD691BvOeClVqB
         aqobc4+00bpiz+hdLSR9qy3UMgVsf8mCGYFV0VvpxKWkah5LM8HFwag2/ugZ8szf7zCT
         z+Uw==
X-Gm-Message-State: AOAM531IgdzxQPaHHfmP7ebjSHcqn96R3ghHW+UBLdaU6ukSAMDE0WpW
        9ykt0HqqDqiLO5DkCfHw3Isg7NY4wzFqfw==
X-Google-Smtp-Source: ABdhPJy/oGjLH3QqDQF3hC68GzFdHDtqRbd3EHV59mXA71r6afGizcu/ZGS93qnXm8cWGoUOQgkm4A==
X-Received: by 2002:a17:90a:db01:: with SMTP id g1mr2464766pjv.127.1616045382067;
        Wed, 17 Mar 2021 22:29:42 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id o13sm814428pgv.40.2021.03.17.22.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 22:29:41 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, Ilario Gelmetti <iochesonome@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH stable 5.4.y, 4.19.y] net: dsa: tag_mtk: fix 802.1ad VLAN egress
Date:   Thu, 18 Mar 2021 13:29:35 +0800
Message-Id: <20210318052935.1434546-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 9200f515c41f4cbaeffd8fdd1d8b6373a18b1b67 ]

A different TPID bit is used for 802.1ad VLAN frames.

Reported-by: Ilario Gelmetti <iochesonome@gmail.com>
Fixes: f0af34317f4b ("net: dsa: mediatek: combine MediaTek tag with VLAN tag")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dsa/tag_mtk.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index d6619edd53e5..edc505e07125 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -13,6 +13,7 @@
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
+#define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 #define MTK_HDR_XMIT_SA_DIS		BIT(6)
@@ -21,8 +22,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 xmit_tpid;
 	u8 *mtk_tag;
-	bool is_vlan_skb = true;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
@@ -33,13 +34,20 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	if (!skb_vlan_tagged(skb)) {
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
+		break;
+	case htons(ETH_P_8021AD):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
+		break;
+	default:
 		if (skb_cow_head(skb, MTK_HDR_LEN) < 0)
 			return NULL;
 
+		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
-		is_vlan_skb = false;
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
@@ -47,8 +55,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
-	mtk_tag[0] = is_vlan_skb ? MTK_HDR_XMIT_TAGGED_TPID_8100 :
-		     MTK_HDR_XMIT_UNTAGGED;
+	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
 	/* Disable SA learning for multicast frames */
@@ -56,7 +63,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
 
 	/* Tag control information is kept for 802.1Q */
-	if (!is_vlan_skb) {
+	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
 		mtk_tag[3] = 0;
 	}
-- 
2.25.1

