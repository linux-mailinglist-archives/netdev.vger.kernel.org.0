Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8786CC786
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjC1QIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjC1QIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:08:41 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401E9DBD4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:08:39 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n28so1154043ioz.11
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680019718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeYDQrGbPRqt70DYrQNatAGDz+G9B8QI11p/DnsQkr0=;
        b=AM3iLxks4PZF2oOZ8SG+noafJkJHYtZKMOP8cbso20aH5Hax3P8HbwYP32gWXHyB0x
         MTGDNV5lpCFBdrFoEof7cxqC9WytuGTQUvKsAvpYqoTsPaTdE3oWpIMjp/5EZRdPFiU1
         WZXBN1F8F71BwnI8FGXxra8ArbQPXdG9lLOEFAYJBaG+TKgDp+oMdtnaUEjbTbfKrj1J
         s4c94fjGXcNYyhwFpWgcGEraIcgiL+SsxDZSLTTlfLu/GAgfLTYxtStl7ZKJsAqLLIsi
         kmTwX3UYgGJVPrkEiz8f1i+MxGlgEsq1QronfYqtlESJQ4wX1f2dO8lYpvrQdjcZ1dXJ
         7EmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZeYDQrGbPRqt70DYrQNatAGDz+G9B8QI11p/DnsQkr0=;
        b=XkEz2e2egwM1rb5Sgp4sEfZ6YkhRf8K0qeUIItoQ5oUQYX4fhk3hPzcs/IX1aYashz
         edY0Ah+HidEsGvPITtV/rn+9XdndrX351Rp8YGLLSwJUiO6Td52kpm6nes9nWu0mnKTP
         EVMCzo9fZC9kLXy/pC7JZk9OLu6xrJXh0bLtT3ASr9w/m4rlR7eMq5gMSqWAvnV4X9cR
         86m9s2L2SmjSacBySUL+Q5SbIGA+xLaOAwV61zpWGuTbDawCVbtjX387lFkZsc8ceo6H
         W78YMUIlVbnirqwJfWyKGKkGp98ZiETQxQeqsM0+xdlaZyTfM43Knz0SxEsy5a5J3MpR
         JhSQ==
X-Gm-Message-State: AO0yUKUGPNxifg5BP7aVNy7/mnWZtw3MT8h+sRe18FfTGHJ3k8RgONU+
        dXAApooSXpAUm+OP6FF6R25qQA==
X-Google-Smtp-Source: AK7set9NnweZPwKGZ6Qvn3oSo/IYtPZC5W8x3ZJAzYNTMogy6llDtemEQaN3sv8W4f+JSdL/5cHAog==
X-Received: by 2002:a5e:9901:0:b0:752:6338:3d8 with SMTP id t1-20020a5e9901000000b00752633803d8mr12636325ioj.6.1680019718488;
        Tue, 28 Mar 2023 09:08:38 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g8-20020a5edf48000000b00758917bc309sm4956724ioq.31.2023.03.28.09.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:08:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     quic_bjorande@quicinc.com, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: compute DMA pool size properly
Date:   Tue, 28 Mar 2023 11:08:33 -0500
Message-Id: <20230328160833.2861095-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_trans_pool_init_dma(), the total size of a pool of memory
used for DMA transactions is calculated.  However the calculation is
done incorrectly.

For 4KB pages, this total size is currently always more than one
page, and as a result, the calculation produces a positive (though
incorrect) total size.  The code still works in this case; we just
end up with fewer DMA pool entries than we intended.

Bjorn Andersson tested booting a kernel with 16KB pages, and hit a
null pointer derereference in sg_alloc_append_table_from_pages(),
descending from gsi_trans_pool_init_dma().  The cause of this was
that a 16KB total size was going to be allocated, and with 16KB
pages the order of that allocation is 0.  The total_size calculation
yielded 0, which eventually led to the crash.

Correcting the total_size calculation fixes the problem.

Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Tested-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Fixes: 9dd441e4ed57 ("soc: qcom: ipa: GSI transactions")
Signed-off-by: Alex Elder <elder@linaro.org>
---
Note: This was reported via private communication.
v2: - Added Bjorn's actual name to tags.  

 drivers/net/ipa/gsi_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 0f52c068c46d6..ee6fb00b71eb6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -156,7 +156,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
-	total_size = get_order(total_size) << PAGE_SHIFT;
+	total_size = PAGE_SIZE << get_order(total_size);
 
 	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
 	if (!virt)
-- 
2.34.1

