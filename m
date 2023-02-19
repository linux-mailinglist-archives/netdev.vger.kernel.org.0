Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFDB69C135
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 16:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjBSPXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 10:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBSPXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 10:23:04 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAC57DBB;
        Sun, 19 Feb 2023 07:23:02 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id be16so1010830lfb.9;
        Sun, 19 Feb 2023 07:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FcOM6cXhM0TQxn7f1e5bkETMl7oG+G75JRDm4X4TtcE=;
        b=FsqXCtrNZ8seRhzWnVi3WWD7TD7GYRRqx6LV7izcyfuXpuTV/SkAKnZnxxPvuTVqU2
         GdeY4x4phxkUP92214YoYKZDqdJEr4lkNu1jorttf8s9h1mVmmNMwD3K39K80xH7x/nz
         DyVsE1XfxvBO4IyW8DdG1AjJamqS8rwLC+PRB306PXhYie8aBZOGXccpd6gz8v8zXmoI
         93KqKh5yoV41GFOI7z2WQq8gFWw990NcCcASEbXoW8AfdiB4ebSqHnqj55FmtP6g7pL/
         3xTUFJrevWIhP1WE8njOVMVmx3G8+01wyPuyVUp1FsqnL+zE6Z/q2RLjBFtgQX/CMo87
         TWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcOM6cXhM0TQxn7f1e5bkETMl7oG+G75JRDm4X4TtcE=;
        b=iEIyb+WEmA+HyluIWrxJo60isepPJLRc5IBWj+JjZxT2Qwh5bK6m9SlwWYbti1tXW8
         GSNAOzCGmEIOG7uo5ZNO32hG+VEAhdRQQF3sJcVc6R3mIAY1isT3xeH8RMcl+nHMHqSP
         PM2pTM2+6VYqXwhVAZc89MBjDwVOBT20AArB60K0pH/mhgY9SAIT0YOPYU5n6YlqV4OD
         0pujRtAn0arCCMsUobNQYCsZf6/R5ZYX0dOMmHJklfJzEVf5PMseCm3TB+t1333P8kAm
         FZeCl/M69INggN0MSQvTgD0ztZ7ddhAszl/vDMBCBt/RH7+SugiwWPunkoh8EH5asTPI
         XNgg==
X-Gm-Message-State: AO0yUKXGK0vxb47RkVijp1G7njJBOfYhki/gUtuM6OMEcp2gippBdLok
        Cth48FPAecMd6K1noKRvBtI=
X-Google-Smtp-Source: AK7set97Z1+jPF+/tC8pKYu3tBfJ4k/jQ0NrQc6qJF45c3f1OMSpofg1qJs4Ofq8+UaKty3XpaSmxQ==
X-Received: by 2002:a19:700b:0:b0:4dc:7ff4:83f9 with SMTP id h11-20020a19700b000000b004dc7ff483f9mr87991lfc.16.1676820180888;
        Sun, 19 Feb 2023 07:23:00 -0800 (PST)
Received: from mkor.. (89-109-49-189.dynamic.mts-nn.ru. [89.109.49.189])
        by smtp.gmail.com with ESMTPSA id f25-20020ac25339000000b004d865c781eesm58959lfh.24.2023.02.19.07.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 07:23:00 -0800 (PST)
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
Subject: [PATCH v2] bnx2: remove deadcode in bnx2_init_cpus()
Date:   Sun, 19 Feb 2023 18:22:25 +0300
Message-Id: <20230219152225.3339-1-korotkov.maxim.s@gmail.com>
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

Fixes: 57579f7629a3 ("bnx2: Use request_firmware()")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
---
changes v2:
- bnx2_init_cpu_fw() and bnx2_init_cpus() are void
- delete casts to void
- remove check of bnx2_init_cpus() in bnx2_init_chip()

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

