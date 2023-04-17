Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8686E521B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjDQUvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjDQUvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:51:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA34B55BF;
        Mon, 17 Apr 2023 13:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB5B629E0;
        Mon, 17 Apr 2023 20:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA26C433EF;
        Mon, 17 Apr 2023 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681764696;
        bh=7oMkRCDaFg+wfH6ptTE6Sp7O08C4+TxSN4TX54d3UA8=;
        h=From:To:Cc:Subject:Date:From;
        b=RW4beKM7zkF9W6LbmXtpRpLh+/LU7+cwo0UTwsnNd6rzLgbun5mIGHT8saIbrONGO
         joX7z40OnA2PeXWuCyZ7J+6kAjW+g6PPOx/xbRPgRTh0ZvII2Mw9IXANcnn4mewIUv
         l5OtmrPsCvIFZDP+4gX5nPU+oSX7ZHWRYbdz+SlhnEfN1zNAeOIjsqESSLEs/x8bWH
         GVS3LpVt1jBLkw7V9yOXmQEBlfqxfDzNiqDVdxdENP13kbKLln59qp+Y69AnRGztbo
         DN5t9e7rAD6ZgiagjbE6NwCwRvHi9JrrIzE5XLdL5SmGcohtVUcgwkgqomrzf6fnue
         nRJzKykIzRGZA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: airo: remove ISA_DMA_API dependency
Date:   Mon, 17 Apr 2023 22:51:24 +0200
Message-Id: <20230417205131.1560074-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver does not actually use the ISA DMA API, it is purely
PIO based, so remove the dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/cisco/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/Kconfig b/drivers/net/wireless/cisco/Kconfig
index 681bfc2d740a..b40ee25aca99 100644
--- a/drivers/net/wireless/cisco/Kconfig
+++ b/drivers/net/wireless/cisco/Kconfig
@@ -14,7 +14,7 @@ if WLAN_VENDOR_CISCO
 
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
-	depends on CFG80211 && ISA_DMA_API && (PCI || BROKEN)
+	depends on CFG80211 && (PCI || BROKEN)
 	select WIRELESS_EXT
 	select CRYPTO
 	select CRYPTO_SKCIPHER
-- 
2.39.2

