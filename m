Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B62955E2
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894535AbgJVBAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894527AbgJVBAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:00:34 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3561C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 18:00:34 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id g7so128323ilr.12
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 18:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZ6q8pKR50F9MEnOUTdX/Eg51eSiLWJ2V+wMmENHTSo=;
        b=fbyROQHeg6nZdM4OhBq/piSTcMlExLr0535xmYuxRK0dQn9BwtA9JbxCpVnOZIeB1O
         UcWoo0yJKlmbm73Xb9eCSKg/lJ3FRXv2r8AzD1BOqwsSrC1mhD90OQUH67DDwbqQjoWe
         qQ3siN1hzx+h98cqVJ/Wak8IAFMNOJQDG6cFFRWARHDJ5znAq+VogowTZMBKt3QtUD7q
         lXQcwgiYTsYPcF5Ra6GR/TAYAyA4bZ//OpbuTkC1FDTqDFldVVDKnlLlqo4YtUVps6zf
         L/cNewkD2oEtGWY9xuMulipqmHE/5QajbGhvaH13Up6pZEHRL1IB1Da3IJjhFjjeGY2+
         3LxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZ6q8pKR50F9MEnOUTdX/Eg51eSiLWJ2V+wMmENHTSo=;
        b=kh6iYk+TOdQFPwxHQoUQn35ylYzcwZEUUon/i3FRbDH6zv6blxpv/Yw9dQTmVdXIKX
         NT3UEIBp5a8Fqwqmz3AzKvEx7iGnuk2T01PLjB8s75qceF5xZS3MzDca+EhN2UTzTBq9
         FbX5g30WWbR+ASeh5qGlkVCe7rzjoS+P1qP2R0kyJmfvs+6gSRxTQQ4pVopO46l04JeD
         oTDIbEHQ5DjrX7X6nez1kTkyWfSI3YciOAcqummhbncdoaLtbam45kTBMm/8xLDHfSOg
         xifAci7fF7tx+m24WM+WPLInj6zqMLNR+03hD0eyOOJH6MtJruIxc6CS5xk98l1Xj5rU
         +RZA==
X-Gm-Message-State: AOAM530XPGHvQaTtjy0J+hyyF/KmWHKocFgXwAQg156iq+eTxWoJkJDk
        u5BDEThtblaF+yAviKl01vBYCw==
X-Google-Smtp-Source: ABdhPJzE3IHz2+d8b4GC9jK+641bTL45WNCf6kcC/CQ1GqJZ5D40CX8AMVw3axAFUNv+9ugDYNVw4g==
X-Received: by 2002:a05:6e02:df0:: with SMTP id m16mr146718ilj.220.1603328433864;
        Wed, 21 Oct 2020 18:00:33 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f5sm40801ioq.5.2020.10.21.18.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 18:00:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        swboyd@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: command payloads already mapped
Date:   Wed, 21 Oct 2020 20:00:29 -0500
Message-Id: <20201022010029.11877-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA transactions describe actions to be performed by the IPA
hardware.  Three cases use IPA transactions:  transmitting a socket
buffer; providing a page to receive packet data; and issuing an IPA
immediate command.  An IPA transaction contains a scatter/gather
list (SGL) to hold the set of actions to be performed.

We map buffers in the SGL for DMA at the time they are added to the
transaction.  For skb TX transactions, we fill the SGL with a call
to skb_to_sgvec().  Page RX transactions involve a single page
pointer, and that is recorded in the SGL with sg_set_page().  In
both of these cases we then map the SGL for DMA with a call to
dma_map_sg().

Immediate commands are different.  The payload for an immediate
command comes from a region of coherent DMA memory, which must
*not* be mapped for DMA.  For that reason, gsi_trans_cmd_add()
sort of hand-crafts each SGL entry added to a command transaction.

This patch fixes a problem with the code that crafts the SGL entry
for an immediate command.  Previously a portion of the SGL entry was
updated using sg_set_buf().  However this is not valid because it
includes a call to virt_to_page() on the buffer, but the command
buffer pointer is not a linear address.

Since we never actually map the SGL for command transactions, there
are very few fields in the SGL we need to fill.  Specifically, we
only need to record the DMA address and the length, so they can be
used by __gsi_trans_commit() to fill a TRE.  We additionally need to
preserve the SGL flags so for_each_sg() still works.  For that we
can simply assign a null page pointer for command SGL entries.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 43f5f5d93cb06..92642030e7356 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -397,15 +397,24 @@ void gsi_trans_cmd_add(struct gsi_trans *trans, void *buf, u32 size,
 
 	/* assert(which < trans->tre_count); */
 
-	/* Set the page information for the buffer.  We also need to fill in
-	 * the DMA address and length for the buffer (something dma_map_sg()
-	 * normally does).
+	/* Commands are quite different from data transfer requests.
+	 * Their payloads come from a pool whose memory is allocated
+	 * using dma_alloc_coherent().  We therefore do *not* map them
+	 * for DMA (unlike what we do for pages and skbs).
+	 *
+	 * When a transaction completes, the SGL is normally unmapped.
+	 * A command transaction has direction DMA_NONE, which tells
+	 * gsi_trans_complete() to skip the unmapping step.
+	 *
+	 * The only things we use directly in a command scatter/gather
+	 * entry are the DMA address and length.  We still need the SG
+	 * table flags to be maintained though, so assign a NULL page
+	 * pointer for that purpose.
 	 */
 	sg = &trans->sgl[which];
-
-	sg_set_buf(sg, buf, size);
+	sg_assign_page(sg, NULL);
 	sg_dma_address(sg) = addr;
-	sg_dma_len(sg) = sg->length;
+	sg_dma_len(sg) = size;
 
 	info = &trans->info[which];
 	info->opcode = opcode;
-- 
2.20.1

