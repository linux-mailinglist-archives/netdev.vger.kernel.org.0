Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E1D6B2C36
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCIRm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCIRmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:42:55 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB12CFAF88;
        Thu,  9 Mar 2023 09:42:52 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f16so2650948ljq.10;
        Thu, 09 Mar 2023 09:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678383771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BApv3ZzPrK0APTfuigbevMtO/Zv45SBgwPL4CrgdF+c=;
        b=ZiPNaYQQKEWtTKT7N27HEeTJmKfqE5QeplwlpgL45nt119pQObLctiw0GW9ELUTDwD
         SzIf8bhoukIt7kJX8vvkO6LlDjYrC0hQ/Uu/CFNH14cmfTjvBO/ZiiMA35nP1dlqnssg
         95agUZ/5Nar3v5LxjFuOVUOCRbq76acOuwKNAuCNfBgWdjE6m6BDcAmJNvPoSsROCiSR
         zyY3NnjrMMGYSVL6SzDfMfBzV+dwd554aj6bVskSA8nkDjQ8HjLwA1QRK0fdtcKRw0oF
         kJ9hprEiDItj1LZddZwfOXpStQKXjmGYhHPf7/E3Qi/4UHBhnEhnG8wz2cmZHcdA9AEi
         m3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678383771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BApv3ZzPrK0APTfuigbevMtO/Zv45SBgwPL4CrgdF+c=;
        b=qfUAKxeraI8rwc0hoYVApgU9sB+iLb/nh1m74eEuiIC6av7+jDJomRsLGLa7eM4eMh
         nG/YRx1DrJ/gyHsom2kb/SNOc+TgOo0yxWLY1YmPzQ81PQzaCRfZ8et30Q9ltdR/2ozS
         4kPHCdH249gpPZpwLl/uNIjvGFbA5UQXekspNVP7H4AdSlofIFAHDOHepjUHfhpRSkUX
         dk2x9iLCJdvxZh1mhplBRGnxhzdiANFnMeSq98G2I0byDq0fwnhzY3z0d1wItDUJOzTe
         6zcz1CRqKfoEUW423UP/mZIVZrtKJUO8xQKQ1DNnSN06cZeQEjwgj7RRB2x2voiFQWi9
         a/Ig==
X-Gm-Message-State: AO0yUKX1tDUzyawwkDrbKydyDV16PUGUJ54ma48pKVtOVa32rIslIqs1
        a8uIeR3iKcUt2g/eT3NwVm8=
X-Google-Smtp-Source: AK7set/F1PDinzCX0lSO84iKcXpmdu4dzIFcs8+a3fXdZxgzcVcvrgVeWJR9tlJ4QgZVAckVZYaxYw==
X-Received: by 2002:a2e:99c4:0:b0:293:3424:9d21 with SMTP id l4-20020a2e99c4000000b0029334249d21mr6932799ljj.45.1678383770747;
        Thu, 09 Mar 2023 09:42:50 -0800 (PST)
Received: from mkor.. (89-109-45-204.dynamic.mts-nn.ru. [89.109.45.204])
        by smtp.gmail.com with ESMTPSA id v21-20020a2e7a15000000b002945b04e1ebsm3036402ljc.94.2023.03.09.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 09:42:50 -0800 (PST)
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
        lvc-project@linuxtesting.org
Subject: [PATCH net-next] bnx2: remove deadcode in bnx2_init_cpus()
Date:   Thu,  9 Mar 2023 20:42:31 +0300
Message-Id: <20230309174231.3135-1-korotkov.maxim.s@gmail.com>
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
As a result, bnx2_init_cpus() will also return only zero
Therefore, it will be safe to change the type of functions
to void and remove checking

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
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

