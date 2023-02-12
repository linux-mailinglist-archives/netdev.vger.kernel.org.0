Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF16936C1
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 10:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjBLJy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 04:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLJyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 04:54:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8F0F756;
        Sun, 12 Feb 2023 01:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A20EB80AB3;
        Sun, 12 Feb 2023 09:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A21FC433EF;
        Sun, 12 Feb 2023 09:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676195690;
        bh=Pl95hny0N1LaEq1IUJ5GhIMpvVflfoAbha+CTkK4Sb0=;
        h=From:To:Cc:Subject:Date:From;
        b=PwodZaP0v0RjJ7/ZDvoaYegrPFGzBz0NBCnLR3tj02Ac+/gKnS9Cfo1qn93T6NbVZ
         Klwr8KHp5XmO3m0QhziJbgh0/3fQyw1Y9snzXGePUoKHCHCvu/ViD8eq2QEMnTgMsi
         VFUOCc3XYye+GdYC5BqN9FUHC9w+c3kxaOvD+sfDdHJh1WYedI73zC1W4Y0Umi3TdJ
         97bAn8zar3ts2zoP91718AkCfwD8aIOchhKZRDDPk3RndSJmpN1m6bx/ZKUlYsw6Az
         Ctp+K+R+nxvPrgsP07qQ6kgfsioG9JlCFjTxNtcpjvM+9hrlWm8hNrxTJdjAAoV/Ho
         Cg0jsjF1iPCkQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, lorenzo.bianconi@redhat.com,
        bpf@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: add missing NETDEV_XDP_ACT_XSK_ZEROCOPY bit to xdp_features
Date:   Sun, 12 Feb 2023 10:54:43 +0100
Message-Id: <c8949baafdf617188dcedb9033ce5a9ca6e9e5ff.1676195440.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing xsk zero-copy bit to xdp_features capability flag.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 868f59ec8439..c05f16140320 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7154,6 +7154,7 @@ int stmmac_dvr_probe(struct device *device,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_RXCSUM;
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
+			     NETDEV_XDP_ACT_XSK_ZEROCOPY |
 			     NETDEV_XDP_ACT_NDO_XMIT;
 
 	ret = stmmac_tc_init(priv, priv);
-- 
2.39.1

