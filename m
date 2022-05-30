Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D9537ED2
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiE3ODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbiE3OBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:01:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F7CBDA2E;
        Mon, 30 May 2022 06:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D75F460E01;
        Mon, 30 May 2022 13:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED51EC3411E;
        Mon, 30 May 2022 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917963;
        bh=UY9S+VuGqXcFpdEttQ2qEq4LET/6/O6BZwZargR5xLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDI462l+bJoUnZlSIGJ8iwMJC59iUy6GCsXx0x7vhNgvj3kCaZzRldSh53uwGgM+8
         7wQ91xzyoeKGRJj0VKbBFOxbQ4E0P98zTIqS5VBSzwN5MiN4ZfOJIcV7p+8So/Bn+x
         yfjgsEzBmZZ2Q97YlYiz00DqYq87bp5cN7ROQdW+w9YfGES3hywJcsZoGf1RTJ9gNd
         S9sLTjIT6SthGld92Ggme1d3AERRtQikVBIHWkMcdc/SJW3Hj5zUv1dCdrEqp49nG3
         92/pjXJei7ROlHgtovororo1w7VWngtkHnK9TfyBcoBGH9d2FOwzSaSGNClT0Fa9PY
         0XMvyCXbmty5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haowen Bai <baihaowen@meizu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 019/109] sfc: ef10: Fix assigning negative value to unsigned variable
Date:   Mon, 30 May 2022 09:36:55 -0400
Message-Id: <20220530133825.1933431-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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

[ Upstream commit b8ff3395fbdf3b79a99d0ef410fc34c51044121e ]

fix warning reported by smatch:
251 drivers/net/ethernet/sfc/ef10.c:2259 efx_ef10_tx_tso_desc()
warn: assigning (-208) to unsigned variable 'ip_tot_len'

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/1649640757-30041-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index f5a4d8f4fd11..c1cd1c97f09d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2256,7 +2256,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	 * guaranteed to satisfy the second as we only attempt TSO if
 	 * inner_network_header <= 208.
 	 */
-	ip_tot_len = -EFX_TSO2_MAX_HDRLEN;
+	ip_tot_len = 0x10000 - EFX_TSO2_MAX_HDRLEN;
 	EFX_WARN_ON_ONCE_PARANOID(mss + EFX_TSO2_MAX_HDRLEN +
 				  (tcp->doff << 2u) > ip_tot_len);
 
-- 
2.35.1

