Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF0C52FFF5
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 02:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348139AbiEVAcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347812AbiEVAcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 20:32:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A9B3DA69
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:31 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id o190so12113513iof.10
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 17:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uoOxtouvB2bKJ6UVCiMo5Cjkg2ZKrup85zpIf1aDzB0=;
        b=RUgedeWSHp2R2QZqA36Oc5g0B717zQVLlTrZprybbNiEo6pCuoRjUK69MdXJsRqz5W
         g3i5oqEZcyvmVMBbpfG7cA9xbr1W5l+12s5WirdcBymk3vZOiiZ+8OD1fT7PeiGDJMBr
         bRVvkEEIYmL50eIFCt+JDHlvcou5M0MamP408CTffNtX6kmYl9kSY6HnqTeUezwGGUT1
         U/NCySNTCqF+eeSBdbzUVO+m2drgeAdGt78Av172UHu7c/+HmlFuBfQK1qiBAvs5NMVo
         pB/lW9p3unnyu7qh95ZoY/DLrySGpbx5iWAXqGdFyVznxAlL70v60QVadS8EILVSGu1n
         BOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uoOxtouvB2bKJ6UVCiMo5Cjkg2ZKrup85zpIf1aDzB0=;
        b=1daApMiL5bjzJkOJM2k0C8uPUEaG/aeUXVCIyocIAb0MPSAmbLCvG7GuXTqwIUhQL2
         0+9mO0/JSSStfjsBI+KDsmz+57kyL6jZYT9ZMZ/tPRXuAakYUQWb6z9hnWlmUPYKjy48
         y1ZxPjLd+hSdpwX7y6/FAQd7LmOiTjtxit0Y3UKph43GcVRQ6qm2J7sXuo9G7wcpZTme
         xTetzPadvjbwymW8AzpuQGSmWOHoyZL27nMmrC4sVvR8b6lX8wAd/owdc3kB/RHoBE1W
         WnAdaqo3X+EDrtb7YmQ1cle/7M/gBqwBE/6fEx7wsCQBby+WU+31XX7Nxr0tndO7XuQq
         k78w==
X-Gm-Message-State: AOAM531IlF041dbdtFkax7WqJ+spBH9TF4Dcy2kL97KdiF+f3c5FeBj9
        XGEfvRmI39Iqd9kZGCKCcxGUDw==
X-Google-Smtp-Source: ABdhPJwPf7WoA9lMh9qECk3gFPkxZS8I36WMRezlgWGfoTK9FCm5VMPTx4o8qnCZLQhKQnQExwE4SA==
X-Received: by 2002:a05:6638:3792:b0:32b:5cd3:50cd with SMTP id w18-20020a056638379200b0032b5cd350cdmr8379821jal.118.1653179550935;
        Sat, 21 May 2022 17:32:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a02c548000000b0032b5e78bfcbsm1757115jaj.135.2022.05.21.17.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 17:32:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/9] net: ipa: kill gsi_trans_commit_wait_timeout()
Date:   Sat, 21 May 2022 19:32:18 -0500
Message-Id: <20220522003223.1123705-5-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220522003223.1123705-1-elder@linaro.org>
References: <20220522003223.1123705-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the beginning gsi_trans_commit_wait_timeout() has existed to
provide a way to allow waiting a limited time for a transaction
to complete.  But that function has never been used.

In fact, there is no use for this function, because a transaction
committed to hardware should *always* complete.  The only reason it
might not complete is if there were a hardware failure, or perhaps a
system configuration error.

Furthermore, if a timeout ever did occur, the IPA hardware would be
in an indeterminate state, from which there is no recovery.  It
would require some sort of complete IPA reset, and would require the
participation of the modem, and at this time there is no such
sequence defined.

So get rid of the definition of gsi_trans_commit_wait_timeout(), and
update a few comments accordingly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c    | 22 ----------------------
 drivers/net/ipa/gsi_trans.h    |  9 ---------
 drivers/net/ipa/ipa_cmd.c      | 15 +++++++--------
 drivers/net/ipa/ipa_endpoint.c |  1 -
 4 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 87e1d43c118c1..bf31ef3d56adc 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -637,28 +637,6 @@ void gsi_trans_commit_wait(struct gsi_trans *trans)
 	gsi_trans_free(trans);
 }
 
-/* Commit a GSI transaction and wait for it to complete, with timeout */
-int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
-				  unsigned long timeout)
-{
-	unsigned long timeout_jiffies = msecs_to_jiffies(timeout);
-	unsigned long remaining = 1;	/* In case of empty transaction */
-
-	if (!trans->used)
-		goto out_trans_free;
-
-	refcount_inc(&trans->refcount);
-
-	__gsi_trans_commit(trans, true);
-
-	remaining = wait_for_completion_timeout(&trans->completion,
-						timeout_jiffies);
-out_trans_free:
-	gsi_trans_free(trans);
-
-	return remaining ? 0 : -ETIMEDOUT;
-}
-
 /* Process the completion of a transaction; called while polling */
 void gsi_trans_complete(struct gsi_trans *trans)
 {
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index af379b49299ee..387ea50dd039e 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -205,15 +205,6 @@ void gsi_trans_commit(struct gsi_trans *trans, bool ring_db);
  */
 void gsi_trans_commit_wait(struct gsi_trans *trans);
 
-/**
- * gsi_trans_commit_wait_timeout() - Commit a GSI transaction and wait for
- *				     it to complete, with timeout
- * @trans:	Transaction to commit
- * @timeout:	Timeout period (in milliseconds)
- */
-int gsi_trans_commit_wait_timeout(struct gsi_trans *trans,
-				  unsigned long timeout);
-
 /**
  * gsi_trans_read_byte() - Issue a single byte read TRE on a channel
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d57472ea077f2..77b84cea6e68f 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -26,14 +26,13 @@
  * other than data transfer to another endpoint.
  *
  * Immediate commands are represented by GSI transactions just like other
- * transfer requests, represented by a single GSI TRE.  Each immediate
- * command has a well-defined format, having a payload of a known length.
- * This allows the transfer element's length field to be used to hold an
- * immediate command's opcode.  The payload for a command resides in DRAM
- * and is described by a single scatterlist entry in its transaction.
- * Commands do not require a transaction completion callback.  To commit
- * an immediate command transaction, either gsi_trans_commit_wait() or
- * gsi_trans_commit_wait_timeout() is used.
+ * transfer requests, and use a single GSI TRE.  Each immediate command
+ * has a well-defined format, having a payload of a known length.  This
+ * allows the transfer element's length field to be used to hold an
+ * immediate command's opcode.  The payload for a command resides in AP
+ * memory and is described by a single scatterlist entry in its transaction.
+ * Commands do not require a transaction completion callback, and are
+ * (currently) always issued using gsi_trans_commit_wait().
  */
 
 /* Some commands can wait until indicated pipeline stages are clear */
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 586529511cf6b..5ed5b8fd3ea36 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -478,7 +478,6 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 
 	ipa_cmd_pipeline_clear_add(trans);
 
-	/* XXX This should have a 1 second timeout */
 	gsi_trans_commit_wait(trans);
 
 	ipa_cmd_pipeline_clear_wait(ipa);
-- 
2.32.0

