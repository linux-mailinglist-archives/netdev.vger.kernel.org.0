Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A125B4388
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiIJBLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiIJBLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:11:39 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956F1FA69F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:11:37 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e195so2810244iof.1
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 18:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=SHFl6KO75iKGkWejKRJG8HcvSJaB7k9qfTgN7OqLqC0=;
        b=p67bUUCSC7zw0pfb11OG9tf3eoGDpUD8Pkdq1Hf0i1EdAdtLEZeUZdaXss+qmiFmmG
         ux9WZ/mpIipwRzPRpwlidu2dhBWGIL37UyUSbJVRPuczufASTUuxXW4mpv39uihHSf+h
         jINf2sjdE46X7adT2YY8F+S91l6pYI74nzfwOac61yLxI2tRcQ5d13dZBUJYLVcsmm7y
         D9Z1oXKbn+3vsK7m+4vUdG4aObW1J9Y1Q5xxnHVnZM4/hSOM8i5Xf9XHr77+boNhZ8D5
         tbKLA23qIAKG0wDt4D1Zfvuz7YSvlHj+7YSvzEhUjko3quejhFoSKpi0/ooR+ls9qm5w
         AG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SHFl6KO75iKGkWejKRJG8HcvSJaB7k9qfTgN7OqLqC0=;
        b=Vzi1yl3cq+MgHfq571K1zvjRGpqQ62DnuU4APF0oduEStQLGazw1zUgo/ESQdyLwMY
         fY/+oUgCRqGcqQwKO7u7LyDU8bTnR4myih8MrydgKiVaS3tZECgMte8SjP24KP1TyBKd
         OMpHBG+YhdxLNlXZMZ19doe+8WjQTNDGkrart/TPfkig06Mt0DA/rTTxVZIy724rxPei
         FjL/Utj1iEHbgorXSiJCMg9Srp93PBB64MR5hvuac2tZ/IgI/oATPuFt04EfXXgnqyWc
         Xl1t293P3Kdk1zGM/j7fqE0XrUHiwWm+ed3OMfkLUSMwUPB5l7KaQ7AoV3K0/tgvfZkQ
         GJng==
X-Gm-Message-State: ACgBeo2Zrbtc1q9qMDFqjMZXDFwBNsbyPH4wEDxZ0Ee8JAlLvJYQUimV
        xgJYU6N0l4WxEiS1PCSKBqr33MNfmR4cQA==
X-Google-Smtp-Source: AA6agR7GhsdPTsrnXxtcRP1YW1UtM00gkhoM/t8vk4rS7kpxc7eOA3qHRzjiXhXeK2Ni7RBOByJQOA==
X-Received: by 2002:a6b:2ac4:0:b0:6a0:dc94:f9f4 with SMTP id q187-20020a6b2ac4000000b006a0dc94f9f4mr915748ioq.150.1662772296951;
        Fri, 09 Sep 2022 18:11:36 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u133-20020a02238b000000b00348e1a6491asm733064jau.137.2022.09.09.18.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:11:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: move the definition of gsi_ee_id
Date:   Fri,  9 Sep 2022 20:11:27 -0500
Message-Id: <20220910011131.1431934-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910011131.1431934-1-elder@linaro.org>
References: <20220910011131.1431934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the definition of the gsi_ee_id enumerated type out of "gsi.h"
and into "ipa_version.h".  That latter header file isolates the
definition of the ipa_version enumerated type, allowing it to be
included in both IPA and GSI code.  We have the same requirement for
gsi_ee_id, and moving it here makes it easier to get only that
definition without everything else defined in "gsi.h".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h         | 8 --------
 drivers/net/ipa/ipa_version.h | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 84d178a1a7d22..0fc25a6ae006c 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -31,14 +31,6 @@ struct gsi_trans;
 struct gsi_channel_data;
 struct ipa_gsi_endpoint_data;
 
-/* Execution environment IDs */
-enum gsi_ee_id {
-	GSI_EE_AP				= 0x0,
-	GSI_EE_MODEM				= 0x1,
-	GSI_EE_UC				= 0x2,
-	GSI_EE_TZ				= 0x3,
-};
-
 struct gsi_ring {
 	void *virt;			/* ring array base address */
 	dma_addr_t addr;		/* primarily low 32 bits used */
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 6c16c895d8429..852d6cbc87758 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -38,4 +38,12 @@ enum ipa_version {
 	IPA_VERSION_4_11,
 };
 
+/* Execution environment IDs */
+enum gsi_ee_id {
+	GSI_EE_AP		= 0x0,
+	GSI_EE_MODEM		= 0x1,
+	GSI_EE_UC		= 0x2,
+	GSI_EE_TZ		= 0x3,
+};
+
 #endif /* _IPA_VERSION_H_ */
-- 
2.34.1

