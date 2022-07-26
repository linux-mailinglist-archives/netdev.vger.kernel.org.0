Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF346581B8A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbiGZVDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239222AbiGZVD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:03:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B302CE34
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l23so28311258ejr.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OqbFbN5WONXbXcraJR8YQy0FCGLdvzQc4+bJ+5uxeJs=;
        b=AJArippnnVJrNNxwpF9RaBN43OT3PN+mHEjLLObIgaepbCEBvdxMJY2KrqohbHA/RT
         rd2r/ZSqWHgd8Dke+ek273q6Onfu1aCFOXPQPO+2ut7akHvr8NVQRIQgrKceqE7slxL9
         c3Jfy3tV5rVFPQe5jU5zM0qRLukKXP44YsTso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OqbFbN5WONXbXcraJR8YQy0FCGLdvzQc4+bJ+5uxeJs=;
        b=lsJQHnQdwsmL/AliBFV1JlLWhe1J6uU9gChw3+3lPIPSGZnSuf87Vn/fyFh6j/NPQ5
         KMKcMjEAg3u5qWqWnvGw3nyXCmlUkNSAhTun27b3XT+OomdH0DZ+QSiuScRVwtNkfVQ5
         XFBEvT5qI3EHQXk4fRC0/3vhS1LHgX69fBOz9DPhVb/0mULb9cMCOCUW+IOeORBftMFP
         73AvEUtc0yU6W+Wj/Tg03aJfEmaCPrC/gnAwnkepEoUGYeWm2hPS6lDXLbspOJ5hp65K
         FpJuLkNoNcqxJIrrAjl60fLUNIOJrJwnmxPkv17XLTtcqfqVW5Wb/+KyQJpt7dmkGaVD
         sgIw==
X-Gm-Message-State: AJIora89EzCqfSSVN6V9NbFjrE1GqpI47C81/1qDBjTKJENGXo0EuJy6
        qB0ArSK5nWGwaFRWvqY5V7KL/Q==
X-Google-Smtp-Source: AGRyM1uy1q7I3r4J2g2pa1PWt8OWZXDqFWlZmqoSzL0nmUf8z+mbe7/4D0zGVZT/tQPP86frqwslmw==
X-Received: by 2002:a17:907:1dde:b0:72b:11ae:700b with SMTP id og30-20020a1709071dde00b0072b11ae700bmr15003401ejc.520.1658869406249;
        Tue, 26 Jul 2022 14:03:26 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id y19-20020aa7d513000000b0043a7293a03dsm9092849edq.7.2022.07.26.14.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 14:03:25 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [RFC PATCH v3 2/9] can: slcan: remove useless header inclusions
Date:   Tue, 26 Jul 2022 23:02:10 +0200
Message-Id: <20220726210217.3368497-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
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

