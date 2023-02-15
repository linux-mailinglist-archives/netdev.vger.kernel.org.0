Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC51F698510
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBOTzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjBOTyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:54:13 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7807410B2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:03 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q3so1022389iow.11
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnQVuU/Ffb7XPwxK0/WH5HNHpB1TwhXFIR6r6WJiun4=;
        b=x+Q0WBgev0z4PqEyJQ3bCk7BlTMK7Ki8p3sxaZmBftko/MoaOJg8JSabbd5vSSUtT/
         ZYW6N1GMAXDZfRbg+DTpK0LL36G8/VaosDPr4R2YCJ2zyVdBP54gko0Q91KtH+GkNbrs
         AI5GUENdZLj6Fc8tNzBt+9Vh8uNY2lvLqXyKPFjL4sU3RvawBf6Se0sojbWPjlWIDrlt
         bifZXCMH9HrL3OklY0cKnMY8xLtT05K6N1Hw9OYKsWgoAWI0KpIuJ6fuoVIUxMFQTq4X
         MZKiY9Oq/ZyH1BrPn3IT9HcrRfgTEgR4lOZjeZPHDkXEOVkMhTAzXJYdcm5X35af887/
         8BCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnQVuU/Ffb7XPwxK0/WH5HNHpB1TwhXFIR6r6WJiun4=;
        b=ex6Aj+oHM35hsD/UOaYN6GgNk07zQgIIX9rYjyzUoyoHrfp6wjEmXhAZZQd8OJqh7Q
         VHR9yhAtMlwwfKx0QuKn4EjlBrvm/PfEB+G7p5JwqUnutullnWlQQjH+8xCI0ryJHWFX
         4JxmTghn7BkqM9q6Ko0p6xdI22rALYatTWrJVLFWblvN5bx5LqWVku7I+EiLAVgBnVo4
         jCwKfWij1lUhFGWA0TQUeko0/gsbEZUezeTAy56uH2gf6cFWbGkrszVr4v05JI4DIBWa
         YurlyxLir0ziXo8WBTc6VYN01G2v1bAdy/a8BSanjJSTWRHe6uJy+97wTSdgoY+uVfdJ
         h8Rw==
X-Gm-Message-State: AO0yUKXTMSkw4VwBDeqlJHwY958MOK7uCIGhx/DCpZoZkrOupecX/8AO
        +wIRGLqBn5IxdpgQZthNHal4Gg==
X-Google-Smtp-Source: AK7set8WIZc3ACpPQBhxeJQ5Gpuvyw0OTYHuYjJ/L9+UaDtUaM741BR7R5+D6Afq0mQFYuOBnuZGwQ==
X-Received: by 2002:a05:6602:27c8:b0:73c:eadf:c6fb with SMTP id l8-20020a05660227c800b0073ceadfc6fbmr444018ios.6.1676490843263;
        Wed, 15 Feb 2023 11:54:03 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm6291847iop.36.2023.02.15.11.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:54:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: add HW_PARAM_4 GSI register
Date:   Wed, 15 Feb 2023 13:53:52 -0600
Message-Id: <20230215195352.755744-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215195352.755744-1-elder@linaro.org>
References: <20230215195352.755744-1-elder@linaro.org>
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

Starting at IPA v5.0, the number of event rings per EE is defined
in a field in a new HW_PARAM_4 GSI register rather than HW_PARAM_2.
Define this new register and its fields, and update the code that
checks the number of rings supported by hardware to use the proper
field based on IPA version.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 7 ++++++-
 drivers/net/ipa/gsi_reg.h | 9 ++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f128d5bd6956e..9a0b1fe4a93a8 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -2042,7 +2042,12 @@ static int gsi_ring_setup(struct gsi *gsi)
 	}
 	gsi->channel_count = count;
 
-	count = reg_decode(reg, NUM_EV_PER_EE, val);
+	if (gsi->version < IPA_VERSION_5_0) {
+		count = reg_decode(reg, NUM_EV_PER_EE, val);
+	} else {
+		reg = gsi_reg(gsi, HW_PARAM_4);
+		count = reg_decode(reg, EV_PER_EE, val);
+	}
 	if (!count) {
 		dev_err(dev, "GSI reports zero event rings supported\n");
 		return -EINVAL;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 2a19d9e34a10a..f62f0a5c653d1 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -71,6 +71,7 @@ enum gsi_reg_id {
 	EV_CH_CMD,
 	GENERIC_CMD,
 	HW_PARAM_2,					/* IPA v3.5.1+ */
+	HW_PARAM_4,					/* IPA v5.0+ */
 	CNTXT_TYPE_IRQ,
 	CNTXT_TYPE_IRQ_MSK,
 	CNTXT_SRC_CH_IRQ,
@@ -224,7 +225,7 @@ enum gsi_generic_cmd_opcode {
 enum gsi_hw_param_2_field_id {
 	IRAM_SIZE,
 	NUM_CH_PER_EE,
-	NUM_EV_PER_EE,
+	NUM_EV_PER_EE,					/* Not IPA v5.0+ */
 	GSI_CH_PEND_TRANSLATE,
 	GSI_CH_FULL_LOGIC,
 	GSI_USE_SDMA,					/* IPA v4.0+ */
@@ -247,6 +248,12 @@ enum gsi_iram_size {
 	IRAM_SIZE_FOUR_KB			= 0x5,
 };
 
+/* HW_PARAM_4 register */				/* IPA v5.0+ */
+enum gsi_hw_param_4_field_id {
+	EV_PER_EE,
+	IRAM_PROTOCOL_COUNT,
+};
+
 /**
  * enum gsi_irq_type_id: GSI IRQ types
  * @GSI_CH_CTRL:		Channel allocation, deallocation, etc.
-- 
2.34.1

