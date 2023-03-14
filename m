Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B256B8701
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCNAgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCNAgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:37 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2F0856AD;
        Mon, 13 Mar 2023 17:36:21 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c1so1246346qtw.1;
        Mon, 13 Mar 2023 17:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQ2E6fONpVmwnalpjCD7FfF7Bo09AwDHDCdSmBwilYo=;
        b=bCzrUYHA9KSn5xjDlX5q+zvFdZ4zkN6ZwN9H/trCXQ+/NCkUjV2x9jtCx/u56A1G1z
         TaANRTTQj6XyUGola/eJKrn+4M1FTOeYE46Je7UuTWp95Ml5o85mhTQL6GbXhENmUXjb
         eFgyBYpU83sF8kPaduXtqgNCF/tYi9QYnFkCWuk8Wgn0W3E3sA6IwBhVr4VLdCMDJJKT
         BkCx7adX58p6ImLMIsh+V7gcVGFxmq0eB9WvGm9FWUq0UlFXZr3HDnTw9zy43hNEr/X2
         X0Tu78sC6JXWCv6tAWRYKuODSQ8fOm97uILZZQmw577Y9ntkHt24k++1KeqvKD2yokJm
         F/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQ2E6fONpVmwnalpjCD7FfF7Bo09AwDHDCdSmBwilYo=;
        b=Ps+kbtAVNE6hJXdSLZ3Hn0tQDLkMUiIvy98WJScxSfSYDu2WCv7R9p1Jv7E/ZNSveI
         watPy2B73LWSM6036IZJRBze7t7KK67d/XUYUgYfFdWN7F+2sq7rtXe/HFckTboBRRyk
         RJH/tK2NaJjRbdNmtdU2Alb+XV/c1m0SU8P7tAMVQhQ9oAOFc3QHByDMNRG6wzWdPqOv
         v93vp4xdk8A/sv9wEALi7ZGln1h8p3GgrBtBfrdZuFKcv2z14AncHIdsbYjR6WD0Le/R
         3QXgBSFeemmQ3G0VCEssqxgTyNjyAtgCFi2u0ajSDLNykaVP04VZVjaFY+5olJmTbBV3
         lkEQ==
X-Gm-Message-State: AO0yUKV3gLM+X26TqRBYHoBqLPHHMlVWa0AT+mlj43bw/FEC6s4q3Qlq
        wOJUfPF1VzLyrJkJyxlgkWc=
X-Google-Smtp-Source: AK7set+UnEUT/H341lXDrviuCGtM2d+N+KLrxdEch/LIOQpTx1n5qnLiekpa2fy90O42UBABsLflig==
X-Received: by 2002:ac8:7d95:0:b0:3bf:b0c6:4993 with SMTP id c21-20020ac87d95000000b003bfb0c64993mr63869759qtd.44.1678754180154;
        Mon, 13 Mar 2023 17:36:20 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id j15-20020ac8404f000000b003b323387c1asm571161qtl.18.2023.03.13.17.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:19 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v3 4/9] net: sunhme: Alphabetize includes
Date:   Mon, 13 Mar 2023 20:36:08 -0400
Message-Id: <20230314003613.3874089-5-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230314003613.3874089-1-seanga2@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alphabetize includes to make it clearer where to add new ones.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v2)

Changes in v2:
- Make some more includes common

 drivers/net/ethernet/sun/sunhme.c | 59 ++++++++++++++-----------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 5e17b1cdf016..acdcae2cb49a 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -14,48 +14,43 @@
  *     argument : macaddr=0x00,0x10,0x20,0x30,0x40,0x50
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/dma.h>
+#include <asm/irq.h>
+#include <linux/bitops.h>
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/fcntl.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
 #include <linux/in.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/delay.h>
 #include <linux/init.h>
-#include <linux/ethtool.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
 #include <linux/mii.h>
-#include <linux/crc32.h>
-#include <linux/random.h>
-#include <linux/errno.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
 #include <linux/mm.h>
-#include <linux/bitops.h>
-#include <linux/dma-mapping.h>
-
-#include <asm/io.h>
-#include <asm/dma.h>
-#include <asm/byteorder.h>
-
-#ifdef CONFIG_SPARC
-#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/pci.h>
+#include <linux/random.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#ifdef CONFIG_SPARC
+#include <asm/auxio.h>
 #include <asm/idprom.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
-#include <asm/auxio.h>
-#endif
-#include <linux/uaccess.h>
-
-#include <asm/irq.h>
-
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
 #endif
 
 #include "sunhme.h"
-- 
2.37.1

