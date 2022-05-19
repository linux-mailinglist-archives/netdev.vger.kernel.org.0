Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4839252D719
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240537AbiESPM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240473AbiESPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:12:24 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D95C3D04
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:23 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p74so2455126iod.8
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u9qaIWyA9uNywpEUw7kTE6d95X5zg1e5QyGsV1unQNs=;
        b=okV+OY5euXuUWRW1si2pG28tdFBUY7vhVb7WYWnyrGBhrNVAfcSFvDfG0qlYQIEhGD
         K7nXTFzPiRehg7ZsJRAKzE1jJYVJA+5b4TAqntjRrez/WEp2OUHPdKvrzCu1LIqa0/RQ
         GBfDLdLf/Ah+UqEKu2q1WVB7NXr63FvFbWOthjXzPxFYOyeBjGfRLLXdfrJP2Y/7ETvk
         SKx6CdZnHBaHOrXKl5IZih/VnQIny+PHcYfbZM1N473MMpmbbmpBrRauCcQWCPQCyYPr
         ArOtrFR7VNavyBLKQpeslg0qNDK1Waw41/LAQcV6QY0+vJr+zrkLiPhW+iVN+qLhlH2m
         dvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u9qaIWyA9uNywpEUw7kTE6d95X5zg1e5QyGsV1unQNs=;
        b=uUeMIf0gBOYRlaA6ZFCq48YZ7/EZw44awdVUR7WLKMZ3ZEbWot0w3En/jKbpWhXVdF
         A8S77jDCG0mjO/wkOQdlYc9M0N0V5zkTZoGVeADa5IZvuobDP/b/oDB0eK05FwJGZUQA
         Kw9VpQKxyZ3STB1ZC1beCCqSmJx5Z8WY4V0MiuJs6zPKRXkbs+f7tDQsI2kPGfuyb7W/
         uJ1KQr2FhWY7eGkCYb3qTM4YpthtupKBPplk1M8jAJ4xPbnRKyZfb4UWqgQSGZES+sJo
         PUmlVBk+XsuyZhk3aLEq/DGj29eAzdGyyzsNNqvskdhfk45QauIjpaZYVGofiD5amY70
         +Ylg==
X-Gm-Message-State: AOAM532M5BTEFHyjjDXmiw5l/1mttgpqJpPZtOwOvjKN3EkOezVnJ/C+
        0n0LzPoF1HApAh77/6H74JVW2g==
X-Google-Smtp-Source: ABdhPJyl/3ypaRK71Jb3RHvfLfN5sSszW8m9VQgGjTht5UuB8uGREUs/faTrM+Qt+UxtZOZhzTCiiQ==
X-Received: by 2002:a05:6602:2c4b:b0:65a:c92a:d3eb with SMTP id x11-20020a0566022c4b00b0065ac92ad3ebmr2688164iov.138.1652973143233;
        Thu, 19 May 2022 08:12:23 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g6-20020a025b06000000b0032e271a558csm683887jab.168.2022.05.19.08.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:12:22 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: rename a GSI error code
Date:   Thu, 19 May 2022 10:12:12 -0500
Message-Id: <20220519151217.654890-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220519151217.654890-1-elder@linaro.org>
References: <20220519151217.654890-1-elder@linaro.org>
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

The CHANNEL_NOT_RUNNING error condition has been generalized, so
rename it to be INCORRECT_CHANNEL_STATE.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 6 +++---
 drivers/net/ipa/gsi_reg.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5eb30113974cd..d47ba16465d29 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1179,15 +1179,15 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	 * Similarly, we could get an error back when updating flow control
 	 * on a channel because it's not in the proper state.
 	 *
-	 * In either case, we silently ignore a CHANNEL_NOT_RUNNING error
-	 * if we receive it.
+	 * In either case, we silently ignore a INCORRECT_CHANNEL_STATE
+	 * error if we receive it.
 	 */
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
 	result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
 
 	switch (result) {
 	case GENERIC_EE_SUCCESS:
-	case GENERIC_EE_CHANNEL_NOT_RUNNING:
+	case GENERIC_EE_INCORRECT_CHANNEL_STATE:
 		gsi->result = 0;
 		break;
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 8906f4381032e..5bd8b31656d30 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -515,7 +515,7 @@ enum gsi_err_type {
 /** enum gsi_generic_ee_result - GENERIC_EE_RESULT field values in SCRATCH_0 */
 enum gsi_generic_ee_result {
 	GENERIC_EE_SUCCESS			= 0x1,
-	GENERIC_EE_CHANNEL_NOT_RUNNING		= 0x2,
+	GENERIC_EE_INCORRECT_CHANNEL_STATE	= 0x2,
 	GENERIC_EE_INCORRECT_DIRECTION		= 0x3,
 	GENERIC_EE_INCORRECT_CHANNEL_TYPE	= 0x4,
 	GENERIC_EE_INCORRECT_CHANNEL		= 0x5,
-- 
2.32.0

