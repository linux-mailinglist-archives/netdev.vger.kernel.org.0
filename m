Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092CE6C83C1
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjCXRwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjCXRwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:04 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3941A65C;
        Fri, 24 Mar 2023 10:51:45 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id w25so2195928qtc.5;
        Fri, 24 Mar 2023 10:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7ZD9kn2BY11SCfWQ4DwMeiI3/L1tegSbDSWDWtewTQ=;
        b=eWjkFDzrfnaPTsfw6HTF4lwhNdII6o59YHBnEGPTVbMY8W1r/ltw81OLAPLvqbLN8O
         RcRLnS4JtJtS7K4ECm6qWSxofiS+jRebewG8GZp4bz72XCrD+rV4PrxJP/96AIbnK6iD
         TUGas643K0pQZNLvXQsLYOb06rWLdICEgzsBTt/Tlc4pnsam+wN5Py8LsY3gKBd5D6RT
         CZTSAXAco1Ly0J5iImHqr8RkVCB/WWMhnohVZw+QBhBdniryuVUTtu5kiZWGAY8gTT9q
         UJXCbAnEQ5VaPgYwSuXVcVmxQkFkB17ECtjxOsjNM9PK3rLNvXk6PklYFEF06T4pek5N
         190w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U7ZD9kn2BY11SCfWQ4DwMeiI3/L1tegSbDSWDWtewTQ=;
        b=i7ZzcUOnIlqtiYFXi+hA9pARyxCsBLP3eWXznNYuaKHEE3XD4p7HGjWyvfangpTEib
         xYpi4/RZ9XzN/W9P5HeI5BRt8RszzX1HQV7OlnldOU1MMP30vhLaW2jlXD7mmg8QWhKk
         Kfop05Uo9DLisrUkjO5kP1EaaRIWehRFajrU9aITfQj6PyJv6nXZCfnOp6w6zmXyjz8P
         6mCC65dogwhr8meMLwOl3+fYnOCy02Lux/azI+wheK0ilS4MOgqSQnzIHqOW7DrakoSy
         QfkwmvFuy/0aqs/IUW7vgDAGJexfwAyTLGkrEJRxPMcYonb6DOyOkvf8OdpEyxvEwuOR
         Ulmg==
X-Gm-Message-State: AO0yUKVhjNfKDnADXoqG07oi9ULMbHsLi1L0niGKot0fyoK+WBGaaLTV
        +ysUqJh//qL4mXqYk8kGL7E=
X-Google-Smtp-Source: AKy350YMPRbmn0ZnCDPO3d8qnkow4YQXIcJKWtJZVMWGP0ORTOOKvSJzhUFXE7kwpPljqNMh5NsenQ==
X-Received: by 2002:ac8:7d8d:0:b0:3bf:d4c3:365d with SMTP id c13-20020ac87d8d000000b003bfd4c3365dmr6425182qtd.14.1679680303959;
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id w9-20020ac843c9000000b003d8f78b82besm5338730qtn.70.2023.03.24.10.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 05/10] net: sunhme: Alphabetize includes
Date:   Fri, 24 Mar 2023 13:51:31 -0400
Message-Id: <20230324175136.321588-6-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alphabetize includes to make it clearer where to add new ones.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v2)

Changes in v2:
- Make some more includes common

 drivers/net/ethernet/sun/sunhme.c | 59 ++++++++++++++-----------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 4efcf60644aa..e9613db3bdee 100644
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

