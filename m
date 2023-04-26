Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E056EFB1F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbjDZTcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbjDZTco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:32:44 -0400
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC7B2684
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:32:42 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id rksYpIGw9LshbrksYpobJM; Wed, 26 Apr 2023 21:32:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682537560;
        bh=wlSC+PaHzigWU6qH53gedUKBlVlTHJVVwjozTSCNOBU=;
        h=From:To:Cc:Subject:Date;
        b=AmxP+3a6mMIwJvFptDVDzWQUXhJN1unPFvehlRknwq+U7+g9MrFJXY3biuB21/HkZ
         bPdPKYNGuaSzqdjMYp8YY+PhGyvH08FHLhIy+F7acXdx3UEKGH6PEzac1PUpOovlv9
         w/tmurXhFpms5N+0huiLLvZ6qu5lnPav67elRlBRmaLBuvIYph3YGIga8H6oZN6H8x
         HYFgCdNNU/N2mbfaXWXh50NH85bu952Fs9OkTeEmRZH8Ikb0BQWZ/a69GrWjxmJXpP
         goJnEhGfJ99ae92lX5L+JtaHeVAYNAvG1gtrXmagknv78HmwK8Jg4Mo0ayg+9QYpad
         5gF5cTiCsbM8A==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 26 Apr 2023 21:32:40 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] wifi: mwifiex: Use list_count_nodes()
Date:   Wed, 26 Apr 2023 21:32:36 +0200
Message-Id: <e77ed7f719787cb8836a93b6a6972f4147e40bc6.1682537509.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mwifiex_wmm_list_len() is the same as list_count_nodes(), so use the latter
instead of hand writing it.

Turn 'ba_stream_num' and 'ba_stream_max' in size_t to keep the same type
as what is returned by list_count_nodes().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/marvell/mwifiex/11n.h |  4 ++--
 drivers/net/wireless/marvell/mwifiex/wmm.h | 15 ---------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.h b/drivers/net/wireless/marvell/mwifiex/11n.h
index 94b5e3e4ba08..7738ebe1fec1 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.h
+++ b/drivers/net/wireless/marvell/mwifiex/11n.h
@@ -102,14 +102,14 @@ static inline u8 mwifiex_space_avail_for_new_ba_stream(
 {
 	struct mwifiex_private *priv;
 	u8 i;
-	u32 ba_stream_num = 0, ba_stream_max;
+	size_t ba_stream_num = 0, ba_stream_max;
 
 	ba_stream_max = MWIFIEX_MAX_TX_BASTREAM_SUPPORTED;
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
 		if (priv)
-			ba_stream_num += mwifiex_wmm_list_len(
+			ba_stream_num += list_count_nodes(
 				&priv->tx_ba_stream_tbl_ptr);
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.h b/drivers/net/wireless/marvell/mwifiex/wmm.h
index 4f53a271dae0..d7659e688933 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.h
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.h
@@ -38,21 +38,6 @@ mwifiex_get_tid(struct mwifiex_ra_list_tbl *ptr)
 	return skb->priority;
 }
 
-/*
- * This function gets the length of a list.
- */
-static inline int
-mwifiex_wmm_list_len(struct list_head *head)
-{
-	struct list_head *pos;
-	int count = 0;
-
-	list_for_each(pos, head)
-		++count;
-
-	return count;
-}
-
 /*
  * This function checks if a RA list is empty or not.
  */
-- 
2.34.1

