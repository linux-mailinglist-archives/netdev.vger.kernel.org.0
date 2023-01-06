Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2E66012C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbjAFNZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbjAFNZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:25:08 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CE57683B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:25:05 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e129so710104iof.3
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vfTJ3c+9fxJ1NOftUlf5eAcEnHlaOW7AestwesRDhhc=;
        b=TkH3WGHNMZcs1BI37yseipc329HqFYaJ4GVDQB+/wdTKpAEjO7d3EJ+vH8ZwTuYUpx
         SYwrToyQRbvYU/GGm5z0JqgYc8QYc2H1bsGK7zQVnwyuDaBViSP+v5hyjjyNXdzFGRFw
         iG6vCXVuUiJW1TJ2LU5KkDqeFkzyLDGt3LXuM/5ETZpGxy9vb9sdiCPsYvMZwalWujG5
         iSpTNvtTsWXiShbNtwRC7rrchOngvkacnYEUpV0aVT7OlLUqa+QsU5orZuBwnbMYPbuh
         YrseKr8DPVFFl+3YwimIzOTIjmJGBzZDoPRSVKMlELbT75RplPJhth54k59igkERsNz5
         Utmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vfTJ3c+9fxJ1NOftUlf5eAcEnHlaOW7AestwesRDhhc=;
        b=oVPj6TQEgXnFGfVerTiMmh/gQGDgfBzcRPgNMVyYuYIYoYgGOCcBAsPvey57Ox+SHk
         vDX0vxqV5acJUW6fL59yxSFBtSVVckK/MmPkcRktLOnvlI1J/tjFdkHNGkrL6AsHOR3K
         MDwP7rV0tM07mReYmb1IkzINOhB1S6XaazcqSxA6EVTS/dVhLGs7pLGkH5ytJJC9G1dq
         gKtQyuLg/gB1aXVv/oOjO+Go8SEQK8/qBTjC6BzMcTHbCWmAxdPsLUlZFGhaVGSl9JjK
         6QlKZAXYI96soZXL73sl9ZCwS0+ZvWFngmbpZ+k1WhPA7trDLf/M3ZVOyRuHpJaeW9yr
         LUtg==
X-Gm-Message-State: AFqh2koigk+8HAABHrws2d5AuRFusDKqDyFuV/IH7wUJIyIlz0/WZ5Et
        ZP8nQ9/iE/up2VinN2qInrdEzw==
X-Google-Smtp-Source: AMrXdXtzSjW6xpjttl/b7MIb6PGGuiMfWDaSmoEds9vUt/DtAvdt6YBba8McM3DgiPH/QDYEY+Wr5g==
X-Received: by 2002:a5d:894c:0:b0:6e0:1ae:8d07 with SMTP id b12-20020a5d894c000000b006e001ae8d07mr47726693iot.8.1673011505124;
        Fri, 06 Jan 2023 05:25:05 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id o63-20020a022242000000b0034c12270863sm332911jao.80.2023.01.06.05.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 05:25:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     luca.weiss@fairphone.com, konrad.dybcio@linaro.org,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: correct IPA v4.7 IMEM offset
Date:   Fri,  6 Jan 2023 07:25:01 -0600
Message-Id: <20230106132502.3307220-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Commit b310de784bacd ("net: ipa: add IPA v4.7 support") was merged
despite an unresolved comment made by Konrad Dybcio.  Konrad
observed that the IMEM region specified for IPA v4.7 did not match
that used downstream for the SM7225 SoC.  In "lagoon.dtsi" present
in a Sony Xperia source tree, a ipa_smmu_ap node was defined with a
"qcom,additional-mapping" property that defined the IPA IMEM area
starting at offset 0x146a8000 (not 0x146a9000 that was committed).

The IPA v4.7 target system used for testing uses the SM7225 SoC, so
we'll adhere what the downstream code specifies is the address of
the IMEM region used for IPA.

Link: https://lore.kernel.org/linux-arm-msm/20221208211529.757669-1-elder@linaro.org
Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Based on net/master this time...

 drivers/net/ipa/data/ipa_data-v4.7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index 7552c400961eb..b83390c486158 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -357,7 +357,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 static const struct ipa_mem_data ipa_mem_data = {
 	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
 	.local		= ipa_mem_local_data,
-	.imem_addr	= 0x146a9000,
+	.imem_addr	= 0x146a8000,
 	.imem_size	= 0x00002000,
 	.smem_id	= 497,
 	.smem_size	= 0x00009000,
-- 
2.34.1

