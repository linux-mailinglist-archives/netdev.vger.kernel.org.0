Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D6857A2A6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbiGSPIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbiGSPIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:08:35 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A9F50710
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:08:33 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id v185so12010864ioe.11
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 08:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kIFU1jp09kvp9pOU+lISTQVP4Oocjv9byOfY/PaGMKs=;
        b=yVDFOGATfBJpUQ5E/YX0mDcDVwCeWfh2CX5INmPzI2fuUguRi54j5Qf03k26iYHTgk
         KYxxxyYqUnG7ehlDUeDIyP+m9bNBcfqWH+RkOMbVK4ZomWDJcK5BllyrzvTMiAZuwlVF
         oToeevdtDUkpZDLHSVS75CKTB9F8ZZXKk2YnmiMqm0SpJthoKIxOtfaUFuSXnZzAd5gv
         zzr1+BJ59UsEaJuhAHgsSyUjn4UD9SywbCQr1GDxAhjq5hR7pUM9c3JDgrycJUJTF17a
         TbcLP9XwP607YtJImiRuNlLD2NnbhOwca96q3aXWIaffMmRU53FkI8lMpsIPELOD9FU1
         /Q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kIFU1jp09kvp9pOU+lISTQVP4Oocjv9byOfY/PaGMKs=;
        b=mpYEBkXwOS4L9PdKtOa8XhzOL5Sv9P+wPFPPLAPMIePaxJI+hf6+juW0CW4tDsBTtf
         YKLOMeIs/EMqr2Qj0DacDWxDIiLG3BtuJZWNv3ShiRfbKckzcw9L+gM5/jIuN/wg7gkM
         4eI6n5ekCeeKU8YyvCbA+1RFRLVGGrYUAOCUZaQA+VOAN+zwBFQJ1NImP81NFFskfPZM
         zKAz+vb9E2NXAGVlJP6pWZe4Nn9wHuvMjiQQVGn10rutvs+VANcPbMFd1g9S6RQmACeC
         vOAXysXLlQPQmlm3JWUgFCVXIHCLht5URk3qvRDYlrMy5SXQg8wVwebD5hHli3q3OLCK
         s9tQ==
X-Gm-Message-State: AJIora/XSHpMTywnauS5ufOb4c9EIBfH7CxcD1z2UxdkdTYlaTch8uEc
        +TqMZlcCLlRrb2WhxbmQ7S8f7Q==
X-Google-Smtp-Source: AGRyM1tW3mLbXV5FhKtay1jJRdQnpHA1GeRZ+FTAJyparomRP5e/TeMEkXnNX3HnxGDvD7tS41WSXQ==
X-Received: by 2002:a05:6638:268a:b0:341:529a:5133 with SMTP id o10-20020a056638268a00b00341529a5133mr10022628jat.18.1658243313053;
        Tue, 19 Jul 2022 08:08:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f6-20020a056e020b4600b002dae42fa5f2sm5944899ilu.56.2022.07.19.08.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:08:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: list supported IPA versions in the Makefile
Date:   Tue, 19 Jul 2022 10:08:26 -0500
Message-Id: <20220719150827.295248-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719150827.295248-1-elder@linaro.org>
References: <20220719150827.295248-1-elder@linaro.org>
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

Create a variable in the Makefile listing the IPA versions supported
by the driver.  Use that to create the list of configuration data
object files used (rather than listing them all individually).

Add a SPDX license comment.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index bdfb2430ab2c7..14b313fefa3a3 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -1,3 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Qualcomm IPA driver.
+
+IPA_VERSIONS		:=	3.1 3.5.1 4.2 4.5 4.9 4.11
+
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
 ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
@@ -7,6 +13,4 @@ ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
 				ipa_sysfs.o
 
-ipa-y			+=	ipa_data-v3.1.o ipa_data-v3.5.1.o \
-				ipa_data-v4.2.o ipa_data-v4.5.o \
-				ipa_data-v4.9.o ipa_data-v4.11.o
+ipa-y			+=	$(IPA_VERSIONS:%=ipa_data-v%.o)
-- 
2.34.1

