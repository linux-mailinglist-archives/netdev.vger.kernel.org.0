Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF6765DB93
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbjADRwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbjADRwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:52:44 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2DA39FA1
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 09:52:39 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id o13so19834292ilc.7
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 09:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh2pdQ8Qz1jZcFQ0f9txmSCzOLVZiWWbqoSXvGeFz+g=;
        b=pUy9/yLcTSPL3IuDyGbacdjkCGV31SZWZXUcFAvvR5SuvUSK9t8Ql7NYsCklIYZQYu
         J1SB9h06cnJXtaX8CHbdgXVSwh6wRc8rYlNGPNLPOFnSeY2cjK0o6K9LUeq2IhuRacCB
         uZWEb+gRXm3c8uEgmCqg3MbOpnxDCO5JXVqdTDnSvFoQxXbr5SQibLFbWpcI8pxZeSce
         ykTTiX+O8btx+tXQCpX7SgtGJHD/GBo3XrlX1kJNryu7m4U3Lc0cCoEeC2DRj0Cu5au+
         z41K1/eSknnnxN45DKYEAj+nEi05h4+ZyanQJ6SFFO0VeZFbFZuRQs837KU/gLduUz7K
         K1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gh2pdQ8Qz1jZcFQ0f9txmSCzOLVZiWWbqoSXvGeFz+g=;
        b=yVcfm5Qvn+i2q69lkRSTRvL3tPPoPsL1IVD0uVo/uCaanj7iKl8AF4kUkf/oImSmNC
         jVczFhJ5DWQKpvNrC7msEypEmjtXjuCPAs6xKJF6nGH36zSM2nLougCJManxJw3wJWXx
         yzonNijDiqBQm8VP4gxovcUrWnDbQbVAWrMq2yTzFKBpzwBLgixtSFCOW2qhVGeh0LJx
         Y3iMTJbn+ceLmqFu/vo7g0N3Qh9lGvH5dh0XoiTU9XuZQ/YvqK8WQDngnyApo5tB7Rlr
         zvnazqWTmr13qhZ3b65rW00dFj/5kydfYKaRapwBN05cOwJrsahhOSyJCKpKz3G8KOHD
         dNoA==
X-Gm-Message-State: AFqh2kpRDi9JEcaO5Z9CaZmlGOoGMAGlFuwAtD8GodZ/rpgH3U4N+qa4
        9kqDiYxEDHAjhqm1HWDRlMoMJg==
X-Google-Smtp-Source: AMrXdXuBYKsXs21FOuxGcpBwjdjmaud5vNrg5WsAeiFM8g+64zRwfA88pdkG1gpE6H0G2kgCCQz17A==
X-Received: by 2002:a92:c748:0:b0:30b:f2a7:92c2 with SMTP id y8-20020a92c748000000b0030bf2a792c2mr25965907ilp.7.1672854758677;
        Wed, 04 Jan 2023 09:52:38 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b00375783003fcsm10872304jaq.136.2023.01.04.09.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:52:38 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/6] net: ipa: introduce a common microcontroller interrupt handler
Date:   Wed,  4 Jan 2023 11:52:28 -0600
Message-Id: <20230104175233.2862874-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104175233.2862874-1-elder@linaro.org>
References: <20230104175233.2862874-1-elder@linaro.org>
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

The prototype for an IPA interrupt handler supplies the IPA
interrupt ID, so it's possible to use a single function to handle
any type of microcontroller interrupt.

Introduce ipa_uc_interrupt_handler(), which calls the event or the
response handler depending on the IRQ ID provided.  Register the new
function as the handler for both microcontroller IPA interrupt types.

The called functions don't use their "irq_id" arguments, so remove
them.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_uc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index f0ee472810153..0a890b44c09e1 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -124,7 +124,7 @@ static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
 }
 
 /* Microcontroller event IPA interrupt handler */
-static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+static void ipa_uc_event_handler(struct ipa *ipa)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
 	struct device *dev = &ipa->pdev->dev;
@@ -138,7 +138,7 @@ static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 }
 
 /* Microcontroller response IPA interrupt handler */
-static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
+static void ipa_uc_response_hdlr(struct ipa *ipa)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
 	struct device *dev = &ipa->pdev->dev;
@@ -170,13 +170,24 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	}
 }
 
+static void ipa_uc_interrupt_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
+{
+	/* Silently ignore anything unrecognized */
+	if (irq_id == IPA_IRQ_UC_0)
+		ipa_uc_event_handler(ipa);
+	else if (irq_id == IPA_IRQ_UC_1)
+		ipa_uc_response_hdlr(ipa);
+}
+
 /* Configure the IPA microcontroller subsystem */
 void ipa_uc_config(struct ipa *ipa)
 {
+	struct ipa_interrupt *interrupt = ipa->interrupt;
+
 	ipa->uc_powered = false;
 	ipa->uc_loaded = false;
-	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_0, ipa_uc_event_handler);
-	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_1, ipa_uc_response_hdlr);
+	ipa_interrupt_add(interrupt, IPA_IRQ_UC_0, ipa_uc_interrupt_handler);
+	ipa_interrupt_add(interrupt, IPA_IRQ_UC_1, ipa_uc_interrupt_handler);
 }
 
 /* Inverse of ipa_uc_config() */
-- 
2.34.1

