Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E00260F722
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiJ0M0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiJ0M0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:39 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDCA1382E3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:38 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b79so1267547iof.5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjjSjVxz43dPoj+rB5pDgaOIlILrA2m91ybZAXvDhDE=;
        b=LFbhw/vDugO3V+guejpZp9r55Py7iMGG6jyjnu9kESgzHZbFfP+VFBMim552nitqST
         Q8p7/ZL3JQTGEFe2PDO7eWH8E69a6ayRvfK2N4xY2CIm6EToqdRKuRV0kQPX1UC9A9XK
         L2+6sNH0CvZ0+rFiZRuJ4E69Vbbz/17nG8QEkMBlqUpTiACt75Wgnjl4SS6+XAL0S8Yj
         JI8xZl+RxmcjpHDJk8uIOrrZ0DLKxNAhs4yxWScvT20VSb3SkOoJWBvU9Q+77eo4u1dd
         tvQ8m+AaFCszslPrcET1X+Lkclnc+l2rhhll3YGJc2dTtjrnWBrqEi9Tg2+f3qXdFMT2
         r6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MjjSjVxz43dPoj+rB5pDgaOIlILrA2m91ybZAXvDhDE=;
        b=vsBjMxujQmjeea99VvfcY+ZBCsrHv8Xul8EO+WC+JZztgMy4Q1VL0lYoOWq9LLgYq+
         6hEHPY0x6seHfAzHBGJwiFmtwrWopfwykYoM4phh9KSAGdI5xaWylo8wvuJwpZ7dCojW
         I2oFx++DqcKhkvRYb0wwA7uxadELCw8FkHflao3G2CZFs4TS4dj99hBFt6EPalWh2xb3
         xk4LV5vU36T/19g/zGll+7Pg0L0IQgqVd5Ye6jeiXAJHQRwex/FMmXrn04TMConuh2yS
         TITh0Qd0vArBqdFEffy7Sb5hHVjK5Lb2lBWl+gmzp5mTlU2tNiS1y8iw/4XIkzMhUd9m
         Ec6A==
X-Gm-Message-State: ACrzQf3/CtghksdFSBU16fi68NUAXBZXN3TVWwdZWpfZjbOr/+PSIsqL
        FpSEl2qAcChc2CeTi/LtDbrs5A==
X-Google-Smtp-Source: AMsMyM5PqnJLBdgCpX7QF9OkT4hEG1qV5vjb5X57TKMbdWNxjkzbv1GT9SwXPTNQqrN0pn3aoVAy2g==
X-Received: by 2002:a5d:9ac1:0:b0:6a3:1938:e6b0 with SMTP id x1-20020a5d9ac1000000b006a31938e6b0mr28385734ion.186.1666873598126;
        Thu, 27 Oct 2022 05:26:38 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: ipa: define IPA v5.0
Date:   Thu, 27 Oct 2022 07:26:26 -0500
Message-Id: <20221027122632.488694-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
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

In preparation for adding support for IPA v5.0, define it as an
understood version.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_version.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 7870e0cc3d7c9..7889c310e943d 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -19,6 +19,7 @@
  * @IPA_VERSION_4_7:	IPA version 4.7/GSI version 2.7
  * @IPA_VERSION_4_9:	IPA version 4.9/GSI version 2.9
  * @IPA_VERSION_4_11:	IPA version 4.11/GSI version 2.11 (2.1.1)
+ * @IPA_VERSION_5_0:	IPA version 5.0/GSI version 3.0
  * @IPA_VERSION_COUNT:	Number of defined IPA versions
  *
  * Defines the version of IPA (and GSI) hardware present on the platform.
@@ -36,6 +37,7 @@ enum ipa_version {
 	IPA_VERSION_4_7,
 	IPA_VERSION_4_9,
 	IPA_VERSION_4_11,
+	IPA_VERSION_5_0,
 	IPA_VERSION_COUNT,			/* Last; not a version */
 };
 
@@ -48,6 +50,7 @@ static inline bool ipa_version_supported(enum ipa_version version)
 	case IPA_VERSION_4_5:
 	case IPA_VERSION_4_9:
 	case IPA_VERSION_4_11:
+	case IPA_VERSION_5_0:
 		return true;
 	default:
 		return false;
-- 
2.34.1

