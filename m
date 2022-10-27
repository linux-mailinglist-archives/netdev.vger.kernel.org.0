Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0E360F735
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiJ0M1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiJ0M0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:50 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105DF148FDC
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:47 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id l127so1247188iof.12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s//CwYJkDKmQmM0SN+cOE1kh8GQDyqEkHeEiZBjgvdk=;
        b=eHDHrj6rkYZwRXHJl18s80X76ciclOcO7haBrN4mR7H7ksv9knqE44zAEEDoWwvb3J
         Yiy0SYRuE/xQY7sMwFGvrfKegl6t9wX7NaT8ZuwRRHVJxae75Lazwdn61uKXOQRa/jgm
         CdoWjIHJw4EZMnIwtu9e47+VFZyrNXmK9LtECrFIWtDan6D7v5X4/2MoMygc4e9pcMh1
         66FfStTzqJlx6u1Cs1a29z+X4N9sN0n4E6vzIj1+sVKnUYZUyPxNTQKKHa0jJcZfv/vb
         x0g/GqMNsShZGx640igZMY5hvVAEBblAuD9c98ZnlcrczUiqDwmodGXUdsMmXRrH1mfm
         +URA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s//CwYJkDKmQmM0SN+cOE1kh8GQDyqEkHeEiZBjgvdk=;
        b=qef51OIVUf1BZw3SWek2dAVC5LfNkl1IZFBzbCbiaZDlYPWLY5tXeOpnTfZJw+m2+u
         FtCy8tjpZFAplZwbeOUaovzNGE4hHbZf9FagmCAmt43rDEV1I5Jb3ZKr0HoWCQc0t0Jr
         UGRL4me4evZieGu6FsCs3vOcW2OCA4qGBat2cuTAPyqQIgRHvvNuFn9qlBbS0wqqPvIZ
         zqbI0iUXHntNa1RypEl0Zkl2i8FxGDL/OKzr9dXy+F7MnVAFAJKtoEMWMadOv5TYYbz2
         NsC/8UuWw85eV4eu9q4C6P/MX02uOc+1eJDM908PFqCjrpBB4MLi6/AQpenjqgBfkJox
         uvmw==
X-Gm-Message-State: ACrzQf1IoYpiOa3QSYjE/VLt6X65zYRzR5AiS6HlEXqoorP84fPPluNQ
        Xwguep9BAr6G0BkLhLiYxqYXSQ==
X-Google-Smtp-Source: AMsMyM7zyLreCWigjz7BlESkxMCNzJ30WUCWZB4iTQ65X/QUaRYil72JOYdB5LABJDY0+5acBg1pxw==
X-Received: by 2002:a05:6638:300e:b0:35a:ab7a:4509 with SMTP id r14-20020a056638300e00b0035aab7a4509mr32112847jak.82.1666873607157;
        Thu, 27 Oct 2022 05:26:47 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: record and use the number of defined endpoint IDs
Date:   Thu, 27 Oct 2022 07:26:32 -0500
Message-Id: <20221027122632.488694-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a new field in the IPA structure that records the maximum
number of entries that will be used in the IPA endpoint array.  Use
that value rather than IPA_ENDPOINT_MAX to determine the end
condition for two loops that iterate over all endpoints.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          | 2 ++
 drivers/net/ipa/ipa_endpoint.c | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index e975f63271c96..a44595575d066 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -61,6 +61,7 @@ struct ipa_interrupt;
  * @zero_addr:		DMA address of preallocated zero-filled memory
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
+ * @endpoint_count:	Number of endpoints represented by bit masks below
  * @defined:		Bit mask indicating endpoints defined in config data
  * @available:		Bit mask indicating endpoints hardware supports
  * @filter_map:		Bit mask indicating endpoints that support filtering
@@ -117,6 +118,7 @@ struct ipa {
 	size_t zero_size;
 
 	/* Bit masks indicating endpoint state */
+	u32 endpoint_count;
 	u32 defined;			/* Defined in configuration data */
 	u32 available;			/* Supported by hardware */
 	u32 filter_map;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9fd72ba149afa..2a6184ea8f5ca 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -433,7 +433,7 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 {
 	u32 endpoint_id = 0;
 
-	while (endpoint_id < IPA_ENDPOINT_MAX) {
+	while (endpoint_id < ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint = &ipa->endpoint[endpoint_id++];
 
 		if (endpoint->ee_id != GSI_EE_MODEM)
@@ -1015,7 +1015,7 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 {
 	u32 endpoint_id = 0;
 
-	while (endpoint_id < IPA_ENDPOINT_MAX) {
+	while (endpoint_id < ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint = &ipa->endpoint[endpoint_id++];
 
 		if (endpoint->toward_ipa || endpoint->ee_id != GSI_EE_MODEM)
@@ -1982,7 +1982,9 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 
 	BUILD_BUG_ON(!IPA_REPLENISH_BATCH);
 
-	if (!ipa_endpoint_max(ipa, count, data))
+	/* Number of endpoints is one more than the maximum ID */
+	ipa->endpoint_count = ipa_endpoint_max(ipa, count, data) + 1;
+	if (!ipa->endpoint_count)
 		return 0;	/* Error */
 
 	ipa->defined = 0;
-- 
2.34.1

