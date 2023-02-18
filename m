Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FEF69BA1E
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBRNEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBRNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 08:04:05 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9985C13D7A;
        Sat, 18 Feb 2023 05:04:04 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id bx37so491374ljb.12;
        Sat, 18 Feb 2023 05:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BDd4Z6+6MlW0i6nLuKIJnVb+Uvg1qlIV7+KCkuqlt2g=;
        b=U+4AB2pPZXTlmR9Yron8JLy2SjLoCq3Ez6KbCFTn4J5LwbxC9eR/tlmFV2/xX4fTId
         glMMXjTaLQF4PF4676dVrzKZj/is1hdiS1KeEYaark9fFiQLxFGYKi3JUPqRQyh4poJL
         opekiF5jpAuTcU8EnV0GE54N/9y0gf3BSrzkLGdWt7exWDqoSKdNyKX8C/eM2DK0JwTy
         lNFjJsGpFwhdzIygJZKmcUbouQ7VWa6Zl9qLrRTK/iq+PEGtacsGbP1DfIK8Bfm78GIX
         B0FkvnHFFh4+2HCu7Z01PCmFNp4t8CwzuCCZnq6thZWXw4sToh+9iBeBCskkb7vknlV1
         XCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDd4Z6+6MlW0i6nLuKIJnVb+Uvg1qlIV7+KCkuqlt2g=;
        b=L6OnMtTiSN3zF347uvm1RWiRSZv6L1HjX8r0xoJknC4vnlzlECkZxJHnNTU7kmW5ow
         EuDbAfeen6Bvi2qwBphEiPg/H2U6hG9YN3ho7BwnRNWnzHzL877lut7wlyr2NHKtfFN1
         LKSL1g28vsX+j/9JIxQuexP+DAhJpbw7dlAHZwoFpQsEHPCax07LY/qY/xbiT8vd/Tje
         UKkzJnhkGKcy5WvP6KNm7OJ3tpxELKDuBdaujRZjWNm3rTRb/O4pxSHE5jBbUYfD0l/a
         Th768x0iF+pY9SyRMDpsu9tkB5LsGfXekVgOSUAc/hZrFvgEC1uxGfIQWqT1/tbe0iUF
         Hckg==
X-Gm-Message-State: AO0yUKU4oYlgotOuD4+MZRl82f5GBNkwp4a7RCVTYKnvmDpPr9G3eEUE
        Jgsw8d1XHovrEc0sC1z9WjU=
X-Google-Smtp-Source: AK7set9mpZAzsOwz9uUXITmAKafi8n3PNMZ9kXP1/RnXc1wUQV6Fp4g2Zqwb0yykWZoZ64TLvn4iHA==
X-Received: by 2002:a2e:a271:0:b0:293:5354:7161 with SMTP id k17-20020a2ea271000000b0029353547161mr1212297ljm.17.1676725442526;
        Sat, 18 Feb 2023 05:04:02 -0800 (PST)
Received: from mkor.. (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id a14-20020a2e980e000000b00295733a3390sm174062ljj.101.2023.02.18.05.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 05:04:02 -0800 (PST)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Rasesh Mody <rmody@marvell.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] bnx2: remove deadcode in bnx2_init_cpus()
Date:   Sat, 18 Feb 2023 16:00:16 +0300
Message-Id: <20230218130016.42856-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The load_cpu_fw function has no error return code
and always returns zero. Checking the value returned by
this function does not make sense.
As a result, bnx2_init_cpus will also return only zero

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE

Fixes: 57579f7629a3 ("bnx2: Use request_firmware()")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 9f473854b0f4..4dacb65a7348 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3908,37 +3908,27 @@ bnx2_init_cpus(struct bnx2 *bp)
 		(const struct bnx2_mips_fw_file *) bp->mips_firmware->data;
 	const struct bnx2_rv2p_fw_file *rv2p_fw =
 		(const struct bnx2_rv2p_fw_file *) bp->rv2p_firmware->data;
-	int rc;
 
 	/* Initialize the RV2P processor. */
 	load_rv2p_fw(bp, RV2P_PROC1, &rv2p_fw->proc1);
 	load_rv2p_fw(bp, RV2P_PROC2, &rv2p_fw->proc2);
 
 	/* Initialize the RX Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_rxp, &mips_fw->rxp);
-	if (rc)
-		goto init_cpu_err;
+	(void)load_cpu_fw(bp, &cpu_reg_rxp, &mips_fw->rxp);
 
 	/* Initialize the TX Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_txp, &mips_fw->txp);
-	if (rc)
-		goto init_cpu_err;
+	(void)load_cpu_fw(bp, &cpu_reg_txp, &mips_fw->txp);
 
 	/* Initialize the TX Patch-up Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_tpat, &mips_fw->tpat);
-	if (rc)
-		goto init_cpu_err;
+	(void)load_cpu_fw(bp, &cpu_reg_tpat, &mips_fw->tpat);
 
 	/* Initialize the Completion Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_com, &mips_fw->com);
-	if (rc)
-		goto init_cpu_err;
+	(void)load_cpu_fw(bp, &cpu_reg_com, &mips_fw->com);
 
 	/* Initialize the Command Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_cp, &mips_fw->cp);
+	(void)load_cpu_fw(bp, &cpu_reg_cp, &mips_fw->cp);
 
-init_cpu_err:
-	return rc;
+	return 0;
 }
 
 static void
-- 
2.37.2

