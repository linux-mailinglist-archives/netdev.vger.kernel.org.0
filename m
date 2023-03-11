Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604CB6B5FA5
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCKSTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCKSTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:18 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4A85CED1;
        Sat, 11 Mar 2023 10:19:13 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id s12so9246179qtq.11;
        Sat, 11 Mar 2023 10:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrXQNAz/M0d4nuMmuJlrut/rzP8JqShoqKn8x6aNlzA=;
        b=NnijRSbdvTo7d6tV4qYy5FOhWXsYyAZm9Y3rHjAu2vPJXsxtb9+27Q/Rqp3p60lNEW
         l+i+TV57KqtmFFKiKdgnPERrtZ54W20VyjcZprqdBQ2bW7hVcX9m4nNTI7zWLYTw2exo
         QB0fAieWPWU3O4hsLwb/gawa40+huXOiefQ4idNuQZKIISSRMg9KiKBqYtygV+/87mNY
         stNqtFGx17QOcopdpBqheftCYG9uoBzGVh/f4wpuDt9b6g0AI0wZ62T88MCpB37BAmY8
         UbaAWGvxSlYVtGRwtoXWnDAw8dG0hAzOT7xlQu7YnypsXu0kaltJMAptvamazVK82ocU
         6COw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QrXQNAz/M0d4nuMmuJlrut/rzP8JqShoqKn8x6aNlzA=;
        b=n5qMMRacu6Nh+fXLR4CMP2skedqq88UrFQHfOFW33BBgkCNUSRmTEVTRE2/Tp2B916
         htV6FE2xbKUs7xvnKVR5nBsr3QQfyTk5Zy4CyAe1ZDH8JXDGCGG8z1qGABRzu3oaRx7z
         F/G70K/xop92D3U1UYIbm+xWKYwZnxwe/WCLDLmV6LSt3JiWXHTKbUMHEfey53VM/uLY
         wKK+yR1xcSzDzriRXegrDX6QjfpGcxgjaF+a9shP8APmXwRcxSJaMHG+eA6iNWBt+AeE
         CznHDSne1/mkPNLCzOp5hLJb3WLK4pOjFB3ttDs4HqWk5CpK6TJy/+3iqO9tNIBHvsv2
         SN4w==
X-Gm-Message-State: AO0yUKVXmd4fyR3CIita7JPIKAom4xO/KsEoX5bW2h1QTvUxn2lZLOl9
        RF1v6ToM3oijGuQJMfp4WgU=
X-Google-Smtp-Source: AK7set+GpGxDBEw+eRJ2l5UD01WPH39ouTrhgZUCLs+rtXZpkxjnnGngvZwwcuCiP5+KYRfXQrvE3w==
X-Received: by 2002:a05:622a:1391:b0:3bf:c575:3f42 with SMTP id o17-20020a05622a139100b003bfc5753f42mr29163594qtk.33.1678558752279;
        Sat, 11 Mar 2023 10:19:12 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id o5-20020ac80245000000b003b9b41a32b7sm2249819qtg.81.2023.03.11.10.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:11 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 4/9] net: sunhme: Alphabetize includes
Date:   Sat, 11 Mar 2023 13:19:00 -0500
Message-Id: <20230311181905.3593904-5-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
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

Changes in v2:
- Make some more includes common

 drivers/net/ethernet/sun/sunhme.c | 59 ++++++++++++++-----------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index cf13123b6ff6..a6c4cb4f99f3 100644
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

