Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7665F6C50C3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCVQbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCVQbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:31:15 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8C55D8B5;
        Wed, 22 Mar 2023 09:31:06 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x20so1234928ljq.9;
        Wed, 22 Mar 2023 09:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679502664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WDN2v4fnawtl/fLdmkgQCgD7YXJFfAmgBrNHK+rBdtA=;
        b=lL3O3FgFC+ZslbtYUnj26o9Gal6uSf00mdtOPSf80Ary5bWVMrE/UAyNycan5WZ+u2
         UC7ginCNUimTNZC/NINPl9EhNaSn00rvCL9uOqnXL1Qv7EZl6kxlQnO0w+ZHS9QYahpj
         JZ3zUx7fhPSo43XDqupk1XfAlEPE39kbJ8g5ED5bzLzmTtQN439i3XsqzMhyBpTAFsRO
         rzKkuh6OB2XsGnBpSqzQWK/juzBXkM8mYaVS9w7uVNGSP2tghWQA3USKXCuFAxkgKx2O
         ELF7yRX+b0pj+BKWEwyxuZmwHMLuDfH8uBlLjGXQm10o4s8PgBvvojT+2ZREZBhVvM9t
         Oqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679502664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDN2v4fnawtl/fLdmkgQCgD7YXJFfAmgBrNHK+rBdtA=;
        b=co9yVo8p+xvUFDJXQ4KsM5nFast0WYk11Dag/K18XBzjXaWwRDx5kWj8Zuh5ID5E7O
         kD9OvkEi97lDi9J1NbG6ogtjJQEw6d0rg8dEX+hPV/S9bIMcf6TjnvTxQ4gmJYTY3b5n
         bny1MitHJFIqZKJnFyoKC2R84fAFNc+YEB4dxqf/dQHvy5eafPxcDEV0uSZxhPE29I/q
         69oNzjsiaDU9PU+B5Da+BEDH/+9/Cjw66U2a6zXrn4BDE7qvGVC5uMkH5X7a9wZQDbgo
         RxYrYbUKJ8cegCZNfy5CwRRKkKHR/j2auAjZlW9aAHxfY9R0ne6v/viRHw+X7VBrd1md
         HXVQ==
X-Gm-Message-State: AO0yUKXdLsFRAwk1EOBzjy+15/6skEZ9M2K8e8MgyLBMGKxu36FlDAAI
        YCePJW6nZCykGNSYPwJDqhg=
X-Google-Smtp-Source: AK7set/w2xdEtvezo8G2g3U7hpDd2Kz2VHnLxxKk7BXNMvuKR+JJfHQmJP5dPuftGOdc7Zafwhl+mw==
X-Received: by 2002:a2e:918e:0:b0:293:45dc:8b0f with SMTP id f14-20020a2e918e000000b0029345dc8b0fmr2447083ljg.26.1679502663991;
        Wed, 22 Mar 2023 09:31:03 -0700 (PDT)
Received: from mkor.. (89-109-44-234.dynamic.mts-nn.ru. [89.109.44.234])
        by smtp.gmail.com with ESMTPSA id s24-20020a2e98d8000000b002996e0e6461sm2670494ljj.29.2023.03.22.09.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 09:31:03 -0700 (PDT)
From:   Maxim Korotkov <korotkov.maxim.s@gmail.com>
To:     Rasesh Mody <rmody@marvell.com>
Cc:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v2] bnx2: remove deadcode in bnx2_init_cpus()
Date:   Wed, 22 Mar 2023 19:28:43 +0300
Message-Id: <20230322162843.3452-1-korotkov.maxim.s@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The load_cpu_fw function has no error return code
and always returns zero. Checking the value returned by
this function does not make sense.
Now checking the value of the return value is misleading when reading
the code. Path with error handling was deleted in 57579f7629a3 
("bnx2: Use request_firmware()"). 
As a result, bnx2_init_cpus() will also return only zero
Therefore, it will be safe to change the type of functions
to void and remove checking to improving readability.

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
 changes:
 - added mark about review
 - changed description of patch
 drivers/net/ethernet/broadcom/bnx2.c | 31 +++++++---------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 9f473854b0f4..19b053c879b0 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3829,7 +3829,7 @@ load_rv2p_fw(struct bnx2 *bp, u32 rv2p_proc,
 	return 0;
 }
 
-static int
+static void
 load_cpu_fw(struct bnx2 *bp, const struct cpu_reg *cpu_reg,
 	    const struct bnx2_mips_fw_file_entry *fw_entry)
 {
@@ -3897,48 +3897,34 @@ load_cpu_fw(struct bnx2 *bp, const struct cpu_reg *cpu_reg,
 	val &= ~cpu_reg->mode_value_halt;
 	bnx2_reg_wr_ind(bp, cpu_reg->state, cpu_reg->state_value_clear);
 	bnx2_reg_wr_ind(bp, cpu_reg->mode, val);
-
-	return 0;
 }
 
-static int
+static void
 bnx2_init_cpus(struct bnx2 *bp)
 {
 	const struct bnx2_mips_fw_file *mips_fw =
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
+	load_cpu_fw(bp, &cpu_reg_rxp, &mips_fw->rxp);
 
 	/* Initialize the TX Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_txp, &mips_fw->txp);
-	if (rc)
-		goto init_cpu_err;
+	load_cpu_fw(bp, &cpu_reg_txp, &mips_fw->txp);
 
 	/* Initialize the TX Patch-up Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_tpat, &mips_fw->tpat);
-	if (rc)
-		goto init_cpu_err;
+	load_cpu_fw(bp, &cpu_reg_tpat, &mips_fw->tpat);
 
 	/* Initialize the Completion Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_com, &mips_fw->com);
-	if (rc)
-		goto init_cpu_err;
+	load_cpu_fw(bp, &cpu_reg_com, &mips_fw->com);
 
 	/* Initialize the Command Processor. */
-	rc = load_cpu_fw(bp, &cpu_reg_cp, &mips_fw->cp);
-
-init_cpu_err:
-	return rc;
+	load_cpu_fw(bp, &cpu_reg_cp, &mips_fw->cp);
 }
 
 static void
@@ -4951,8 +4937,7 @@ bnx2_init_chip(struct bnx2 *bp)
 	} else
 		bnx2_init_context(bp);
 
-	if ((rc = bnx2_init_cpus(bp)) != 0)
-		return rc;
+	bnx2_init_cpus(bp);
 
 	bnx2_init_nvram(bp);
 
-- 
2.37.2

