Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9C6A1C8D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjBXM7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBXM7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:59:22 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DFF16AE6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:59:20 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id r27so15688090lfe.10
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677243558;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wPG+Qu6q3RgNUlyYFOzyQce/Gn7mCKiLFXWosGD/Kpw=;
        b=Qd1lGW9KedyZEyAKTe4qdwitU0RlltalSkvez+gCBlMtrH6GE0qvZ6N9degexwDUt5
         dNdu/oVOBfqfI/0nPxjkhgVxa7sXKwkS5f+FHxoKEOvRzW4q2klU98/or9Jw9EWhKccG
         YlvGp9/Q0lrEj0twzDQzqEMGDA64qhLB9g1sGJUN7fftCaDxxGZOQaLxvZrTeJfJN1Oa
         pg9hzsnoBOOHk6xywdhAXFvF705SK4k8DYMm5UWruhN0PuRAptn9DiRNmibfihWd+gcq
         Yc+2ZJ32i9cjW4mg1vJlTH7u5AFJlh9UQkZnMgjptUaUqJYLI7BbP6+tDP7E6gslVGpr
         789A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677243558;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wPG+Qu6q3RgNUlyYFOzyQce/Gn7mCKiLFXWosGD/Kpw=;
        b=fjsd2oUMllAlDSo6aapEr5NIZDELKk83iLiKiHA2B2XfKw3v3CLWY6N3uG/l3taluM
         NM7ob+aMJ/MUaiVOKUdTxOeN3eAmVzQUpkzLuy/vdvqOX4EIK1d+5o7VB8a83AvNjO8P
         ABHG2/Jn2yHs2RJaZeLN/932V8S6A4pDDQCPF2QmWyDyJxifsCGJO2S/8kfTk9ZVV5GV
         dtlT/MRq8s2gT2+7RLn7vLVmcs4gChU355sRfhOSt1Pki9u9ColoDrSrJQygtL4bxsen
         XFjkVrXZop8ge3uPqtLuY+PH6VhDyPXgg27PZVp4gske3sqpby8eD+q72g6tBMSfy2Tz
         Ti3w==
X-Gm-Message-State: AO0yUKVYJs9rNxnhtOGtTgQYdQPJxcF4RzLJNQMNHAhnM+vkHWPM2DVb
        UqetGdM7VriVUXC7ntIh91so01T6EaArYO/L
X-Google-Smtp-Source: AK7set8n74zszsjnxxtFsyIXECuG5SuVuGozOMkL0pV5tL1ZnT+NrhMVipNk0UIgPRZ9uO5w+srZGQ==
X-Received: by 2002:a19:f514:0:b0:4d5:ae35:b220 with SMTP id j20-20020a19f514000000b004d5ae35b220mr5224038lfb.8.1677243558481;
        Fri, 24 Feb 2023 04:59:18 -0800 (PST)
Received: from [192.168.1.101] (abym99.neoplus.adsl.tpnet.pl. [83.9.32.99])
        by smtp.gmail.com with ESMTPSA id m28-20020a056512015c00b004d7d13387b5sm1705890lfo.116.2023.02.24.04.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 04:59:18 -0800 (PST)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
Date:   Fri, 24 Feb 2023 13:59:17 +0100
Subject: [PATCH] brcmfmac: pcie: Add 4359C0 firmware definition
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230224-topic-brcm_tone-v1-1-333b0ac67934@linaro.org>
X-B4-Tracking: v=1; b=H4sIAKS0+GMC/x2N0QqDMAxFf0XybCGrQtl+ZQyJNWrApdK6IYj/b
 vDxnMvhHlA4Cxd4VQdk/kuRpAaPuoI4k07sZDAGj75B71u3pVWi63P8dltSdhjaJ2IIhNSAVT0
 Vtpk0ztbpb1lMrplH2e+b9+c8L/hAKNZ2AAAA
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1677243557; l=2308;
 i=konrad.dybcio@linaro.org; s=20230215; h=from:subject:message-id;
 bh=7y7YEc5odYv03bixlDUyCS4eYv4iVkxtgs1PEzbckmE=;
 b=CMqJrDCCa6ffqZ9RJPFUNUfgU6DD7V/B3DBJHMVo81dr4UONMpGMvOsRpqcd3UGBlYKd+Y70fi3M
 nT9QnkaNCmr1xVBXfVXJSSLLIXuPlcmd9TesLNVc1B238uTl32Pz
X-Developer-Key: i=konrad.dybcio@linaro.org; a=ed25519;
 pk=iclgkYvtl2w05SSXO5EjjSYlhFKsJ+5OSZBjOkQuEms=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some phones from around 2016, as well as other random devices have
this chip called 43956 or 4359C0 or 43596A0, which is more or less
just a rev bump (v9) of the already-supported 4359. Add a corresponding
firmware definition to allow for choosing the correct blob.

Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
Follow up on https://lore.kernel.org/netdev/20220921001630.56765-1-konrad.dybcio@somainline.org/

Other changes were dropped, as it turned out in the mailing thread
that the chipid was 4359, which is already taken care of.

Also, I'm sorry that my "soon" turned into months..
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a9b9b2dc62d4..96c059377a2a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -57,6 +57,7 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
 BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
 BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
 BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
+BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
 BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
 BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
 BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
@@ -88,7 +89,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
-	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
+	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0x000001FF, 4359),
+	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFE00, 4359C),
 	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0x0000000F, 4364B2), /* 3 */
 	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFF0, 4364B3), /* 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),

---
base-commit: aaf70d5ad5e2b06a8050c51e278b0c3a14fabef5
change-id: 20230224-topic-brcm_tone-07490077a0a3

Best regards,
-- 
Konrad Dybcio <konrad.dybcio@linaro.org>

