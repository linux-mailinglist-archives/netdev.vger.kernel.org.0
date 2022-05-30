Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BEC537F4F
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiE3NoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiE3NmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:42:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E772E9A9A2;
        Mon, 30 May 2022 06:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB8C60F47;
        Mon, 30 May 2022 13:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6940CC36AE9;
        Mon, 30 May 2022 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917524;
        bh=gam7VJRU5tQrQ47mhnmERO7Bdx+TDXwHG5e3vtQwqLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z81S6mTkK/cZFYhkdJuRtxeVLN2cJSQz1HmGgsYwyW32t8QNtAkWy1ZiiIsfPPILq
         ylrVXC/nIfA8GTopZq995ecdiPWAtzdyTZqCynKmdc8qhCNIRBoXXKHVJTCK4df4nr
         lPBUqfCHOhKSp7SvEkp/k0M3sOLJp/Wxt+d2WcSaDpbmazqYRLllPlyuUqzWq317bK
         5WjVw7x9jLe1Gq2NEuO75pxreAn0+3u1aY09wViqg3+42N+fEYs1iUq6/G5QgUs3QW
         ei1wopOLbQtJYB9tA9pdkaRaWJGjM79DBPwxTf5XzPBN8OKFp9Fjw6UkzXQJ7Xx48j
         sEMDK/K7qYOwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stas.yakovlev@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 011/135] ipw2x00: Fix potential NULL dereference in libipw_xmit()
Date:   Mon, 30 May 2022 09:29:29 -0400
Message-Id: <20220530133133.1931716-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit e8366bbabe1d207cf7c5b11ae50e223ae6fc278b ]

crypt and crypt->ops could be null, so we need to checking null
before dereference

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1648797055-25730-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index 36d1e6b2568d..4aec1fce1ae2 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -383,7 +383,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
-		if (host_encrypt)
+		if (host_encrypt && crypt && crypt->ops)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
 			    crypt->ops->extra_mpdu_postfix_len;
 
-- 
2.35.1

