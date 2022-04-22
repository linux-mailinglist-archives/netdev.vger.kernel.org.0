Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19C150B588
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446861AbiDVKvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446679AbiDVKvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:51:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBC855204
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:48:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 21so9947673edv.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VAsRRop2pV4ZTVr7B5XC8yRu2f0AvXYEM5JlYoO6X9I=;
        b=URZruV4HFT/3ZB49dataOpdWp/YjepectaxFEsx8rweDlxosoE4tVP+E+rUiVnMdGV
         i51YYXsxvl88T3vQqFVrxfEx7np289ASHG93+1q/tkkae9AA0GWtHSzh9rP2Ivu/4feq
         qtPTiHclnsOwxPNged/45qXsprx3VrGebUUfZOYCi2xnjVFsnSEtZXeym7Zzin0rbSz0
         bsX5z6zIKfOCZG5RydwoeRKdLaVs3r0Z1QeywnIrV7aIHSlAmRqGBx8ROfHMWWp+gJdv
         o/O5DSFFoCZxLv78xB7jLvOIHXnbQn3iRNgO8AuDN+emK0BwUoyZJiOckSLqNIZ1FmeE
         y4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VAsRRop2pV4ZTVr7B5XC8yRu2f0AvXYEM5JlYoO6X9I=;
        b=OTYTMNyApYXCVTAC2wIc4uvODldBWaMN1jmRTU9yEholoSAnB1KYPnNfeyu3S9SvqV
         QRcbjLrZe58aSIhTP/MomMFoDCE6E6LthUIRQJF5a3T5aD6J7v+ov523lSsQdiX3+zxg
         OSg/ocUzeWfqORDf7NbKJrdo72Vr/VaR258XWL36d4eBnRvpH5JHKUaE4RpDq8xq4Od2
         0f5pgE4ueN+gG7iDEYB2dasF8ZKxhSE1pR26TLxBxBQS0S+uvpd2HL0y84Asxp542LIF
         scQG3kOOKyM+CEW+zfFOC6IpcCOJ73SBwn1sxf+tBS4g/m0ao9vozlSehMRoMPTq4/oB
         daGA==
X-Gm-Message-State: AOAM533leHy/LcFKckhpn0uBR6+u1c7I58VM8XiKQHsumCYzy20KJeXX
        W54cMhxZR6T1NIqLDLikDlb6IQ==
X-Google-Smtp-Source: ABdhPJxsOyTkFpBIBoHx5hMe4weI1kgD/ah4F3MXOPXUb1oNT1HMAUOGq/zMWhbt6QFpoJexxkjJBQ==
X-Received: by 2002:a05:6402:7d3:b0:41d:9152:cad with SMTP id u19-20020a05640207d300b0041d91520cadmr4226041edy.370.1650624488537;
        Fri, 22 Apr 2022 03:48:08 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm615266ejn.204.2022.04.22.03.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:48:08 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vincent Cuissard <cuissard@marvell.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: nfcmrvl: spi: Fix irq_of_parse_and_map() return value
Date:   Fri, 22 Apr 2022 12:47:58 +0200
Message-Id: <20220422104758.64039-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
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

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

This is another issue to https://lore.kernel.org/all/20220422084605.2775542-1-lv.ruyi@zte.com.cn/
---
 drivers/nfc/nfcmrvl/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index a38e2fcdfd39..01f0a08a381c 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -115,7 +115,7 @@ static int nfcmrvl_spi_parse_dt(struct device_node *node,
 	}
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
+	if (!ret) {
 		pr_err("Unable to get irq, error: %d\n", ret);
 		return ret;
 	}
-- 
2.32.0

