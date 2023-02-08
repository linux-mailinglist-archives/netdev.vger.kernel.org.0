Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB04E68F927
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBHU5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjBHU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:14 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC92D159
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:09 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w13so35868ilv.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPfsCQfg7xuEhCC2eccAscY4Hh6knFHrvMv/YaXzBQI=;
        b=hVNjiwzkqjLOD7wHeIJbnnvO/+VO0Xn8814lLg0ZVkD9RhoH2Fxve/+2G8t+krA583
         xl0f0qLWCrrUnVVVKgZUQ3J0p4L46apoG6mjUnzFAmEcsEZeelZx7ibW03M6VWBv1BAM
         VgYzNijjZnajlbC60VINfGPRFDTViepbGA1mfl7924jaLjzsmd22VPssHEhnxykx8mIF
         0j8J97qa+8u3cp1ELosZHlG+GCUv1BNVoo/wKh55CXvEAYw9gydnHk9B+msQzMuosD+7
         NwHoomUyXSgu18tjF9v1PD7Aa2t5rw46qW5fT7en+2tiFlfP/0xV1sQH0pWUEMKYGROv
         BYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPfsCQfg7xuEhCC2eccAscY4Hh6knFHrvMv/YaXzBQI=;
        b=0KA/Xtkqn0XO/bXNA88nxNW4lN8t12QB4/iDjgm3xVwKlD4JteKaNByrDyif4JBCcb
         K/lT9I86s82CDNYne8IXxR+WmgRnHjlO6ozb0HTWPgdgixoZeRCOeFQDHx3/fvjjr9K6
         9lJ6gZnGmW0NA5ZCjLEBAtQSJyiLcapOwJWJLy3U2TaafSsRQBiVYn76ezwXHmuobHPb
         ntcKIUG29nLaVARfLnBbT3SwdljImYVFyb/7/mexkpolPAO2rlsGD61lwM53EFPGINwC
         ncY//UlEApXcrTUPHn9xFbKrPqAcpaRo+KE5bGSY1Q6gn0eM5wCB2QP1LWK59zGiT94h
         7QSw==
X-Gm-Message-State: AO0yUKVHpTnw55v4ojjFHYIySZLw0fibGl7XT61jijWb8CCkfhTY39hN
        aq0C4dTKrSFiK99mAF3hz6GVPw==
X-Google-Smtp-Source: AK7set/OZmKV0Oc2zwR8ZgvKIFuLbOgd5A5Ee48HH4+3uI5L38z/Xw4Q7ua2v+i3b43vBSPvxTNmPg==
X-Received: by 2002:a05:6e02:1b09:b0:310:f912:5a68 with SMTP id i9-20020a056e021b0900b00310f9125a68mr2926016ilv.3.1675889829551;
        Wed, 08 Feb 2023 12:57:09 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:57:06 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] net: ipa: generic command param fix
Date:   Wed,  8 Feb 2023 14:56:45 -0600
Message-Id: <20230208205653.177700-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208205653.177700-1-elder@linaro.org>
References: <20230208205653.177700-1-elder@linaro.org>
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

Starting at IPA v4.11, the GSI_GENERIC_COMMAND GSI register got a
new PARAMS field.  The code that encodes a value into that field
sets it unconditionally, which is wrong.

We currently only provide 0 as the field's value, so this error has
no real effect.  Still, it's a bug, so let's fix it.

Fix an (unrelated) incorrect comment as well.  Fields in the
ERROR_LOG GSI register actually *are* defined for IPA versions
prior to v3.5.1.

Fixes: fe68c43ce388 ("net: ipa: support enhanced channel flow control")
Signed-off-by: Alex Elder <elder@linaro.org>
---
Note:  This is sort of a non-bug, so I submitted it to net-next.

 drivers/net/ipa/gsi.c     | 3 ++-
 drivers/net/ipa/gsi_reg.h | 1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index bea2da1c4c51d..f1a3938294866 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1666,7 +1666,8 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
-	val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
+	if (gsi->version >= IPA_VERSION_4_11)
+		val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
 
 	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 3763359f208f7..e65f2f055cfff 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -372,7 +372,6 @@ enum gsi_general_id {
 #define GSI_ERROR_LOG_OFFSET \
 			(0x0001f200 + 0x4000 * GSI_EE_AP)
 
-/* Fields below are present for IPA v3.5.1 and above */
 #define ERR_ARG3_FMASK			GENMASK(3, 0)
 #define ERR_ARG2_FMASK			GENMASK(7, 4)
 #define ERR_ARG1_FMASK			GENMASK(11, 8)
-- 
2.34.1

