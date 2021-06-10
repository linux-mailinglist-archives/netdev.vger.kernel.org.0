Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBF3A33F8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhFJT0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:26:34 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:38617 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhFJT00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:26:26 -0400
Received: by mail-io1-f42.google.com with SMTP id b25so28242922iot.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LSNscCRP7JfsjOWiGj3ECcyfzJq/+6gwkjgojdezt6g=;
        b=DDFz+TgsEfq8Q9Kx50srPZd+fk4kD9yQBXU2gcl3I1G0prMIdeRMgv1HKbUJyETaFz
         uYD0UUeZcTZyach78CSN1FySvlydoeUikv+Rk7dEX6jItSvMX40wEUY+DFaCelW1Ywsx
         My1aG94zsXXfktL1BSa9BLHw2F0nk8fpBnTNtwrlWsMhOvpBzbtBDstbpQszudxcuMAQ
         G6hadkwdufYzwFLyN/5T8oP/YSSx+Ah3FXoPumjvlIogRtk4d/puiTCxzKABZ48ThEnx
         ZIlOA4KoA3vWOrDiSSn7FaceSVv3KKanUnwLrnqQX1a0Z6LzkdyD2xOk37uOVcKn+QPn
         IPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LSNscCRP7JfsjOWiGj3ECcyfzJq/+6gwkjgojdezt6g=;
        b=TkeBU24mdvx0td1md5yk5Qz9L5KUPmjsV1aIDVFbKgnV102e2vTBEZZ151SG7PjxVV
         EgVtudVEhbdXcjejSzotqxbLR7Mn5DlZ+HyOfo4sQmhJAICKTxAiGMwYX+jKNm3S7quv
         1bFDcKfbJLjCkytqpycDaxZ0P2WiV5Hd0iOxyEtgJKY33umPl9doOn98c8gEdzprqsD3
         miPTQ4TfjhluEeVlCgGtEb/1aSn+3uK7szFVrmUyEBmdCTC6CgCZWD3eKvLNJSDsJemr
         Nu7+vT1phyISifCrbSoFjTpBL4fE4pfaMVB6ZqvEm20R0KbtLwaP9CdBvcFHzccmGcql
         n4iw==
X-Gm-Message-State: AOAM530rirwIm8CKmSKzigF3zyX6gxGKLfxkWtyv3tPQc5SOBmaQ3Djb
        pN7ofFyOwH6P4TlxQZPTiyvDMg==
X-Google-Smtp-Source: ABdhPJxHI3Cif3aOFpJOe1jclO5muO0uhEiTRSiUKoVU3KxL/xBpD85DU02qhe7focn+I+U9rqF3lw==
X-Received: by 2002:a05:6638:3393:: with SMTP id h19mr222269jav.0.1623352996717;
        Thu, 10 Jun 2021 12:23:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:16 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: ipa: pass mem ID to ipa_mem_zero_region_add()
Date:   Thu, 10 Jun 2021 14:23:04 -0500
Message-Id: <20210610192308.2739540-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a memory region ID rather than the address of a memory region
descriptor to ipa_mem_zero_region_add() to simplify callers.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 9e504ec278179..7df5496bdc2e4 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -28,9 +28,10 @@
 
 /* Add an immediate command to a transaction that zeroes a memory region */
 static void
-ipa_mem_zero_region_add(struct gsi_trans *trans, const struct ipa_mem *mem)
+ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	const struct ipa_mem *mem = &ipa->mem[mem_id];
 	dma_addr_t addr = ipa->zero_addr;
 
 	if (!mem->size)
@@ -83,11 +84,9 @@ int ipa_mem_setup(struct ipa *ipa)
 
 	ipa_cmd_hdr_init_local_add(trans, offset, size, addr);
 
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_PROC_CTX]);
-
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_AP_PROC_CTX]);
-
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM]);
+	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM_PROC_CTX);
+	ipa_mem_zero_region_add(trans, IPA_MEM_AP_PROC_CTX);
+	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
 
 	gsi_trans_commit_wait(trans);
 
@@ -411,11 +410,9 @@ int ipa_mem_zero_modem(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_HEADER]);
-
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM_PROC_CTX]);
-
-	ipa_mem_zero_region_add(trans, &ipa->mem[IPA_MEM_MODEM]);
+	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM_HEADER);
+	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM_PROC_CTX);
+	ipa_mem_zero_region_add(trans, IPA_MEM_MODEM);
 
 	gsi_trans_commit_wait(trans);
 
-- 
2.27.0

