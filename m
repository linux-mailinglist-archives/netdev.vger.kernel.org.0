Return-Path: <netdev+bounces-1282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD236FD2CD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D8D21C20C7B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B5A125DA;
	Tue,  9 May 2023 22:51:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B6019937
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:51:46 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E06D5FCD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:51:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f6bef3d4aso13039130276.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683672704; x=1686264704;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h/pLWm5vi+dYneji0UWy1vMvjrF5tnk8tbx7c3bULgc=;
        b=WP0EyyJ7HPOA8bTSOUB54e1G0oHCY4/sPYnazmRH4tCAaqyUkbEOe1f9J98/TpNK+I
         3UVW8YJDVMIGoR2ScRxlEigmlbqEtBgDke8JRwwBGlSo3ajOrm1HL7yovX3tmp7KQ8A1
         unQ7eLnnC/nndk8So3RDBBsJahajmUtZrLUG/zBWyttTvRJzXO4OuLG8a4yHW2BLO9+G
         udTKliV0wiVIPmwYpAw2tq1xCcw6kiXrnJR/TusPGa/bNASuX1eS0ed5C7MtuTy9F5rh
         NYfBa5z5WEfRN4+0N3oaRdZ2ls55+3z8q8t7Z/DnYevkrjIUuaqTTj94DpVkUQzzfrPh
         VuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683672704; x=1686264704;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h/pLWm5vi+dYneji0UWy1vMvjrF5tnk8tbx7c3bULgc=;
        b=KwUjxSbdE02UMHD21TCuJzxZulW/Dmp2hByxCIS6NuieFhW3x0fG22WxTVpu8+Ns+g
         v1pJm5NiaHk/1O+FkRg04NGfIz2R1Dn/siWujrKrI0Cv0v346Cni/2DhE3+pLuKz/e/X
         cb4WghJJfwi44ni7lBkMyfKOeeQdeIdjXANGdt3hzpp4+VyGzB6F3mGdD95nZ9PGNX4w
         4KPnzVKU/niUvDxFnuNHuyt95UJHvc21xjOwuWfGFfAFtX8vBF7RwmJtmSBPPZ6BNLrf
         HIboE5LlDvFmBy0eNlBbPDfS/maPblC9N6rMb9sk6PH4pp4D11NjitAWJjYK0tPtM/BM
         PjNA==
X-Gm-Message-State: AC+VfDzSnhZ/JsdJf4TWoBG5hSagY6GO/uAdqPCwDT3XYoquZDuVAZC2
	WZkRr5IBv/QP7zTl7CHgSIlG024zy3ic+hIH9/dXtYEo2eTTKLzBHVl/TaL1OjxOz3frDVRP7+U
	DD1fUMZXJrs2i3QXIRwGKSkS2hYCWjhymAQXNX6R5lscGdKOiZsrL9u6n/W7Cs63f33Q/1Q==
X-Google-Smtp-Source: ACHHUZ4zS9cbhGFC9P6ohWLC7mtMX4/MMyf9sBtYFD+PQyxC4FFPOXUzhbMdCBlWu2gtmqrqI2wNAXgdeZlg7Jw=
X-Received: from ziweixiao.sea.corp.google.com ([2620:15c:100:202:c5a5:63ba:eb57:ae22])
 (user=ziweixiao job=sendgmr) by 2002:a25:d484:0:b0:b9e:45e1:7dc with SMTP id
 m126-20020a25d484000000b00b9e45e107dcmr9563649ybf.7.1683672703730; Tue, 09
 May 2023 15:51:43 -0700 (PDT)
Date: Tue,  9 May 2023 15:51:23 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509225123.11401-1-ziweixiao@google.com>
Subject: [PATCH net] gve: Remove the code of clearing PBA bit
From: Ziwei Xiao <ziweixiao@google.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, kuba@kernel.org, Ziwei Xiao <ziweixiao@google.com>, 
	Bailey Forrest <bcf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Clearing the PBA bit from the driver is race prone and it may lead to
dropped interrupt events. This could potentially lead to the traffic
being completely halted.

Fixes: 5e8c5adf95f8 ("gve: DQO: Add core netdev features")
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Bailey Forrest <bcf@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 57ce74315eba..caa00c72aeeb 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -294,19 +294,6 @@ static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
 	bool reschedule = false;
 	int work_done = 0;
 
-	/* Clear PCI MSI-X Pending Bit Array (PBA)
-	 *
-	 * This bit is set if an interrupt event occurs while the vector is
-	 * masked. If this bit is set and we reenable the interrupt, it will
-	 * fire again. Since we're just about to poll the queue state, we don't
-	 * need it to fire again.
-	 *
-	 * Under high softirq load, it's possible that the interrupt condition
-	 * is triggered twice before we got the chance to process it.
-	 */
-	gve_write_irq_doorbell_dqo(priv, block,
-				   GVE_ITR_NO_UPDATE_DQO | GVE_ITR_CLEAR_PBA_BIT_DQO);
-
 	if (block->tx)
 		reschedule |= gve_tx_poll_dqo(block, /*do_clean=*/true);
 
-- 
2.40.1.521.gf1e218fcd8-goog


