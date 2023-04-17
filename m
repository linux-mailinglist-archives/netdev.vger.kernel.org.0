Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31C6E5215
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjDQUvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQUvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087E34C10;
        Mon, 17 Apr 2023 13:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1EDE62291;
        Mon, 17 Apr 2023 20:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDD3C433D2;
        Mon, 17 Apr 2023 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681764669;
        bh=MBmo3piKzaGs2Sd0Iais388RQM8I9qBDu1JQ4VMZ4RM=;
        h=From:To:Cc:Subject:Date:From;
        b=DJOcuxDJRlSp9n8VELxPwHVkyL2vxkjJploeXShXLbbyG+vCq51Ppdx1gSJ+h1S2N
         bhQ8+d57gsKChjEsXC5DempMe71463LOOxCUSLezmlGkuyqTVxvxjnzyMLYjCqIDcW
         2ULg6uj8Ng62cRzLJCKxgjTldaNsKRDdCjEPvloiJn4eiWcR9AnAXO+mZWIX7ZZOYl
         bJ8poyuskxolgUsbJZMifPHjE01hEUJ4EPSrzxd5lXWwB49rnoqeKc/S0hAugO3xag
         vh+Yap1Zf+5JcwFIcOLH+dmF8fjIO6D+x9Fb7+AVjCg5EgNPJW7HjSBuZ6OWbQjaIy
         Izy0uei17cL2w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hamradio: drop ISA_DMA_API dependency
Date:   Mon, 17 Apr 2023 22:50:55 +0200
Message-Id: <20230417205103.1526375-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

It looks like the dependency got added accidentally in commit a553260618d8
("[PATCH] ISA DMA Kconfig fixes - part 3"). Unlike the previously removed
dmascc driver, the scc driver never used DMA.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hamradio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index a9c44f08199d..a94c7bd5db2e 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -47,7 +47,7 @@ config BPQETHER
 
 config SCC
 	tristate "Z8530 SCC driver"
-	depends on ISA && AX25 && ISA_DMA_API
+	depends on ISA && AX25
 	help
 	  These cards are used to connect your Linux box to an amateur radio
 	  in order to communicate with other computers. If you want to use
-- 
2.39.2

