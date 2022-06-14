Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA4A54B102
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243267AbiFNM3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243889AbiFNM2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C8237DF
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:38 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y19so16841586ejq.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1QllzXGCUo8JTE+hOZVBSnNVj6x3XTlbwu5/oui3J8=;
        b=UeS+soY0woVEo83Ch9yUMn7BxrQO2Yv75mFq4TKV7j0bJ6wM6UVI092ssFHWDbXshb
         adHD3SMfqeSl+23u98d7JiRKp/d6bKikWqnFtSy/sff85hRQIIlNC/ZdZ8JOAN1Q2y60
         P6buwedBe9Y+h4tvFvXNqJ9Rt1TsUGRy2pKDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1QllzXGCUo8JTE+hOZVBSnNVj6x3XTlbwu5/oui3J8=;
        b=oWniJTJjujCChzlaUW6wQDMX9jvONv/g5aFlV7NcVhC5El6jVsKQ2V6qpWyPC+5HFw
         HmCDBd8S2LzNAKp0GPEmn1AjhwMCNNRG6+jbkdsVHx7y63hTg8/hqhPRcb9mzY0BSpSU
         mW5okVhT8jfVR0qk0Q8a0cmkEdjBh+ccX3JAuTeEIIjQKSfUMaai9a4HjkjCNZ2lKeAY
         sg263lsV70so3It7r5PberAzbcWEsWfQ5fy+P2m0f446yP9ezmOk5kEaDU5G+oirU7Ks
         mMRbaHAAGgARR4oUSrNRyOAs6n7fgVp1JxrGiFs45yMjZCg0Mky/FCZrZojxYklINJSO
         f9KA==
X-Gm-Message-State: AJIora/I0briSnXIKIHt6fRA+egw1K6l84Zy34Y6mk5y8+2oVfIwkliA
        c2UB6fhO6LQwW/92swA26WE7yQ==
X-Google-Smtp-Source: ABdhPJw58NGvARca3elMl/B/Osx1t/HjZIS+sU69SssrBevkCMylAPhKq1550+OfLU7slAzFBfgsEQ==
X-Received: by 2002:a17:906:74cc:b0:712:381:9c5a with SMTP id z12-20020a17090674cc00b0071203819c5amr4079949ejl.466.1655209718386;
        Tue, 14 Jun 2022 05:28:38 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:37 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
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
Subject: [PATCH v4 09/12] can: slcan: move driver into separate sub directory
Date:   Tue, 14 Jun 2022 14:28:18 +0200
Message-Id: <20220614122821.3646071-10-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
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

