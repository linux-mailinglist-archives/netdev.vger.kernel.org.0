Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7267F58392A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiG1HDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiG1HDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645A85C369
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:07 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id z23so1562027eju.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OqbFbN5WONXbXcraJR8YQy0FCGLdvzQc4+bJ+5uxeJs=;
        b=H6c+CwG85VDVmBQqbdkary0D07YA5Gn8UWubgl2cgK/GZ1TbiJwzpzjxkPiFzQJP+R
         yFfgAHHIZIUs2Pt6u8Dp9oAkDSW239sdBm8h0Wu4UmCVcVUg6yhN1RTbZJBpSGTMxQTL
         H0IiLIatBo86jVNNC6jZEuKm2xELL6a6ftRso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OqbFbN5WONXbXcraJR8YQy0FCGLdvzQc4+bJ+5uxeJs=;
        b=RekiAEuXGekD11lRJJvjvz3lL93vZjNanUKkj5MKtQQEBLN7DuM6XYaTHNuZBKn8jk
         wp3CivX164CW18/0SNsP765eaVg1BrPzsJ971GTk4stKthISt97iHhCL6j8Dm2QEfk8Y
         1lR//svgKqAE8Qu2ZJucCvaMAImbvVLNeyfAC4n6Dc8MYsUwX37/ozGz3nAFDFwMZLme
         VC/+7L4oAUR1JarnufTsGIbWOwgn/hvey/y4NHIIUvAMdmRTUHPAj2gHlubNqG+DGa7u
         lVIvSR0uZZHJHJ8ax3dxl8yRTjZeJmP+9Tw3FucITkT2bAiP74iZ4Gw3/awWRh3tb36w
         sZTQ==
X-Gm-Message-State: AJIora9B2lym1a2+nGNs/Q3by4a+mjUfRUX6Ss/dgWtJ0HACKuIfvAta
        PRgZ2Nft0EGVMSimLckjXlztbA==
X-Google-Smtp-Source: AGRyM1tyxt5AZFv5KBrqS+15cqhzJre9JnuQgSgSQc3BlE4vTZdPfRYjKTI2goAu9xV/PLIRvFLcOA==
X-Received: by 2002:a17:906:5d16:b0:72f:248d:525a with SMTP id g22-20020a1709065d1600b0072f248d525amr21052749ejt.441.1658991785810;
        Thu, 28 Jul 2022 00:03:05 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:05 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 2/7] can: slcan: remove useless header inclusions
Date:   Thu, 28 Jul 2022 09:02:49 +0200
Message-Id: <20220728070254.267974-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include only the necessary headers.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v2)

Changes in v2:
- Re-add headers that export at least one symbol used by the module.

 drivers/net/can/slcan/slcan-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 2c9d9fc19ea9..ca383c43167d 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -48,9 +48,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
-#include <linux/if_arp.h>
-#include <linux/if_ether.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-- 
2.32.0

