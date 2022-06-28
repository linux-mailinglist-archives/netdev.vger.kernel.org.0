Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D055E9F7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiF1Qf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbiF1Qe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3853735272
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e2so18399002edv.3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1QllzXGCUo8JTE+hOZVBSnNVj6x3XTlbwu5/oui3J8=;
        b=DV/JgG9StAMjN5vbyosSc+Tz1ANvXg+nXIb8iIu03TwzUf+XAWtjO/GFjAG6hEeJMG
         nJ9r5+2xCIoIBz0v0nVkWT5ZJWFl0tABcnXp0o4PGc4ZPc2KnyBQdjS2Pg+9jVP6N1OI
         4U2kwYJbqS2eQPi3lDsI154EmbPK3VQz0tOiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1QllzXGCUo8JTE+hOZVBSnNVj6x3XTlbwu5/oui3J8=;
        b=RXokaM1O0a2K8bm7hGFApcPYTLXj1oIYjGmxwAHNSd4MGiaWqeEVEKz3FZ1T+aYmBA
         46ONB8gg4FfidMPAU1MK0KVpLNmFeyoXK0Gdt5YKsktxuVHbckO5mlYvOI+J8bPrwH8l
         hkv6C0WKrA7gKT/tdPlulc2Phjcd25lsuHE1MT1IgVHFrGvJrnJaTGZ1R/gpUwqztU2u
         YVR7a0kme5j6KzO92hKxdx8G8n2j8qH5E2gjMsOXpEwJp6ipoSQAmXGlLqfd8cbKql1E
         3Ir/8AuECEe4f0LOJ4OZkvlxZ80XW7ISDE8FcLyH9SgCILNsvVdCDx5c85i7UaiMAscD
         3Wcg==
X-Gm-Message-State: AJIora+JDrGn+3iv6piV/5gHDTW60fhduGJ9KWK9FglB2ou7WANq2RJQ
        Jphccd4VUNVIX0Odqjyg23Mzxw==
X-Google-Smtp-Source: AGRyM1s6gLZPSYO2oaziV5t5Vt0umQTthq84byZbwpX3hmbv/j6UzlpWvhzkgMgRnMCARNB87ghK4g==
X-Received: by 2002:a05:6402:43c5:b0:435:89ee:578f with SMTP id p5-20020a05640243c500b0043589ee578fmr25080462edc.225.1656433921691;
        Tue, 28 Jun 2022 09:32:01 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:32:01 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 09/12] can: slcan: move driver into separate sub directory
Date:   Tue, 28 Jun 2022 18:31:33 +0200
Message-Id: <20220628163137.413025-10-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the slcan driver into a separate directory, a later
patch will add more files.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/Makefile                        | 2 +-
 drivers/net/can/slcan/Makefile                  | 6 ++++++
 drivers/net/can/{slcan.c => slcan/slcan-core.c} | 0
 3 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (100%)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 0af85983634c..210354df273c 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_CAN_VCAN)		+= vcan.o
 obj-$(CONFIG_CAN_VXCAN)		+= vxcan.o
-obj-$(CONFIG_CAN_SLCAN)		+= slcan.o
+obj-$(CONFIG_CAN_SLCAN)		+= slcan/
 
 obj-y				+= dev/
 obj-y				+= rcar/
diff --git a/drivers/net/can/slcan/Makefile b/drivers/net/can/slcan/Makefile
new file mode 100644
index 000000000000..2e84f7bf7617
--- /dev/null
+++ b/drivers/net/can/slcan/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CAN_SLCAN) += slcan.o
+
+slcan-objs :=
+slcan-objs += slcan-core.o
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan/slcan-core.c
similarity index 100%
rename from drivers/net/can/slcan.c
rename to drivers/net/can/slcan/slcan-core.c
-- 
2.32.0

