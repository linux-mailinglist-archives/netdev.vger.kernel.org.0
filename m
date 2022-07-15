Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE3575B07
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiGOFeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiGOFeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:34:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961C6357FD;
        Thu, 14 Jul 2022 22:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657863245; x=1689399245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CvNvujJBORl3tcnve2CJMhHc6+JmB5rOIHaaoKSpvxM=;
  b=LwYKxcQ6QaY1uvQisH/uuBmpJ+iyRXoxDXVVVwyWIIWJLmT0UcDIR0/m
   AfhB8TEmAvslcKmkUvk0tFenAhgkHI4u1j7b9YLyHee5sSpVYWUT6QLOp
   fagzDlXi+AVJCJ6IwEgXvZjf1klRtfwrAOjoJGLQUjmB1xKXnKjCazBL9
   ENhuS7QTqDUuqZqHNeZFeJ1Xh27Gsjl1rUNDrx4hg6wgFH/Kke4OPASuc
   7NfLLM8oNvulLE0Zi6SnI/PmD3SvSJ/5U6kCyYqfkPvcU8NLHfJ05hATE
   2Nf/zOYcgFx5r1nJn0WFbXxxaEjGA7K7JdWD3jgwyg+PwjlZQX+WUxKxH
   A==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="172235119"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 22:34:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 22:34:03 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 22:33:56 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <llvm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Arnd Bergmann <arnd@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [Patch net-next] net: dsa: microchip: fix Clang -Wunused-const-variable warning on 'ksz_dt_ids'
Date:   Fri, 15 Jul 2022 11:03:34 +0530
Message-ID: <20220715053334.5986-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the of_match_ptr() pointer when dereferencing the
ksz_dt_ids which produce the unused variable warning.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 4844830dca72..05bd089795f8 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -215,7 +215,7 @@ static struct spi_driver ksz_spi_driver = {
 	.driver = {
 		.name	= "ksz-switch",
 		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(ksz_dt_ids),
+		.of_match_table = ksz_dt_ids,
 	},
 	.id_table = ksz_spi_ids,
 	.probe	= ksz_spi_probe,

base-commit: 6e6fbb72e48ba3da229ff2158cf0d26aa50a218a
-- 
2.36.1

