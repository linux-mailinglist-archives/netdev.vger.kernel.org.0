Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DA0659CEB
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 23:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbiL3WdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 17:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbiL3WdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 17:33:11 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0171900C
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 14:33:09 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id v2so11764006ioe.4
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 14:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VopeNteg8qTfq7SnHIn61T/3OkDE4RtaebULuCvY+/I=;
        b=PriBcqBUPdb+qVozoBjNUwxgXonhwruGyDKU3JkS9eAI5UkdJ8Fc0mWlxMhg3pCT5b
         fRFHhGikYFTealH91qzl3EeX2n+QgLmFNIP7ykLLma+AWephk3mmGktXHAVyEoRQWCyj
         XsD7TvbIRx/mUAVEIALc/1U8BsuQos0gPfqsa2s/+6G5qmPAjO6nffVhAGNqeMCi9r3f
         9bhJ2TqLmFZo3LML57XI97HeBdtuCQz+Cm3WJQtfK+w/y20rB4cPFbioA7d6n7orvdlu
         5PECM5sUmZU1FnaX53WTbwWvm5TiWSmZGM1l5mIPWwdUX2NW/YceCUCX/FzyFlxF5Rru
         bO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VopeNteg8qTfq7SnHIn61T/3OkDE4RtaebULuCvY+/I=;
        b=Ctf2N8TmDm9X5TejWAWBCIJHHHIX6Hyvm4dFtTI/aKAMHGvl1jhxJ1Y+jWcRU5Z4Rv
         ZSBGN5xk2gLwOb7GZml0uA/V3vpwTJ1ZqXDp2LABnSI47s61jUpYFUcI4K3vrd5gD5qu
         odkFnYk4ojrOinQCGKuk4DLZPvW21yQRyNrCwYveM/vHmAdQpkTWybP+1+38HFkmKkhe
         Rig07n864ohmXO79zs2KWtQcBmLIg/XNOyV/3bua/7t8lybqvOi10TqTTe7yfwCAoVyH
         V9e99Fi8vIhprOd6pUsp5sOz1+X97uEEVVa4pMu9V8U20PI9KN0NpbvldkVkNVsIOQww
         FzYA==
X-Gm-Message-State: AFqh2kql2kxwiwOL5si5KmDg52wPmEl+dUJJLu8c3VxEldVPRIGbxDVs
        Rhsjl4fK2NXUxAsXuxl6SBfl2g==
X-Google-Smtp-Source: AMrXdXtgcBNmHjgIGJqtfF0s5UCY0VKKpQfiu8K1qA4fIm76Ej3VBVtySDwOWxgdId+GEfMtA0JpnA==
X-Received: by 2002:a6b:8f82:0:b0:6eb:da60:be0b with SMTP id r124-20020a6b8f82000000b006ebda60be0bmr22779039iod.4.1672439588657;
        Fri, 30 Dec 2022 14:33:08 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id k130-20020a6bba88000000b006e0577610e2sm8269658iof.45.2022.12.30.14.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 14:33:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: use proper endpoint mask for suspend
Date:   Fri, 30 Dec 2022 16:33:04 -0600
Message-Id: <20221230223304.2137471-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
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

It is now possible for a system to have more than 32 endpoints.  As
a result, registers related to endpoint suspend are parameterized,
with 32 endpoints represented in one more registers.

In ipa_interrupt_suspend_control(), the IPA_SUSPEND_EN register
offset is determined properly, but the bit mask used still assumes
the number of enpoints won't exceed 32.  This is a bug.  Fix it.

Fixes: f298ba785e2d ("net: ipa: add a parameter to suspend registers")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_interrupt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index a49f66efacb87..d458a35839cce 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -132,10 +132,10 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
 {
 	struct ipa *ipa = interrupt->ipa;
+	u32 mask = BIT(endpoint_id % 32);
 	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 	u32 offset;
-	u32 mask;
 	u32 val;
 
 	WARN_ON(!test_bit(endpoint_id, ipa->available));
@@ -148,7 +148,6 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	offset = ipa_reg_n_offset(reg, unit);
 	val = ioread32(ipa->reg_virt + offset);
 
-	mask = BIT(endpoint_id);
 	if (enable)
 		val |= mask;
 	else
-- 
2.34.1

