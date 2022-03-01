Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327E64C85BF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiCAIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiCAIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:00:13 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E021C80202;
        Mon, 28 Feb 2022 23:59:25 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o26so13114111pgb.8;
        Mon, 28 Feb 2022 23:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ekN4siAZvBFYd9yFklz7czO7Ig0JL/XxTSkd0vY2Yt8=;
        b=Kz+4lJxpn6ZgNlG3qZPKUsrxvOx+u6q7ExG1ZalqIm2eoUgzkmKQ18EPS8Y2gJ91ws
         ok2nLgOjheo5Q+JkSgWrbzHDQpQa5YOuFW3unn1k1/7oZ0HgwPOrZIe2pesso6MHMbRP
         bZzU3Cz9/18EGeHCFtChKtNwLPgdwcTb5joSEyWFCDalPn4pWeVOSJaVpa2UJWelNXo7
         nW275yP5KtdIIFFzENZdI2cq35OKDfDJ47rPXJa5QgRa8MoylJN0zGyv7syuj6ACJMJU
         wP71gwseBBGoxOdHN/stX4Rz3Pzt08bTEZ5h4DDmVo+SpG06gBNUEOGFabRPha8U2EyC
         LGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ekN4siAZvBFYd9yFklz7czO7Ig0JL/XxTSkd0vY2Yt8=;
        b=qjakPSBE9JzxrT/Wt7xgbpSFdVCq3DWqKHh+soM2CqqjwsN528xtqS1zVt/pzEY5ZF
         zOUXDtLVBT/E662Ttourc/d+4QoJR51nZhJVtzFk4ov1szJbI323p+5muKpVrOPiZcq9
         g1rA1vP17QapX2v32VMYx1wYGS/kEdMERMJaQ3WHoaCOxA+tWkTzwtEcnmKug/rrbYVw
         kp282tBJ0YGxDKZYO2xX4WgP95EP6QpSTpTqYdPPSrNqbi3P2z711RS+olGyvbkieCkd
         iU6YZOxzkNf6+kKmVhatTnugWQTWhfyfbwrr4aWuyQm6VUf1saibeXJTbwawLj4bjkSo
         c+Zw==
X-Gm-Message-State: AOAM532T6+jKK574QLvSFtJrCKFFe0pKNp/5Egha+31q2/6Nz5PaFJ8L
        akv+8wMsq03fo9MiwF57kJtJMdgdZ2pylg==
X-Google-Smtp-Source: ABdhPJwXvPb7Q40+8gxqteNpuZwp+PE+h/n6nJyCxWSbGjj0S4pZaxg41DZenCjeRXk3a7weBaal7A==
X-Received: by 2002:a65:680a:0:b0:34d:efd6:7a5f with SMTP id l10-20020a65680a000000b0034defd67a5fmr20435429pgt.213.1646121565470;
        Mon, 28 Feb 2022 23:59:25 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:59:25 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 6/6] drivers/dma: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 15:58:39 +0800
Message-Id: <20220301075839.4156-7-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrations for:
 - list_for_each_entry_from_inside
 - list_for_each_entry_safe_from_inside

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/dma/iop-adma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 310b899d5..2f326fb37 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -159,7 +159,6 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
 		/* all the members of a group are complete */
 		if (slots_per_op != 0 && slot_cnt == 0) {
-			struct iop_adma_desc_slot *grp_iter, *_grp_iter;
 			int end_of_chain = 0;
 			pr_debug("\tgroup end\n");
 
@@ -167,9 +166,8 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 			if (grp_start->xor_check_result) {
 				u32 zero_sum_result = 0;
 				slot_cnt = grp_start->slot_cnt;
-				grp_iter = grp_start;
 
-				list_for_each_entry_from(grp_iter,
+				list_for_each_entry_from_inside(grp_iter, grp_start,
 					&iop_chan->chain, chain_node) {
 					zero_sum_result |=
 					    iop_desc_get_zero_result(grp_iter);
@@ -186,9 +184,8 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 
 			/* clean up the group */
 			slot_cnt = grp_start->slot_cnt;
-			grp_iter = grp_start;
-			list_for_each_entry_safe_from(grp_iter, _grp_iter,
-				&iop_chan->chain, chain_node) {
+			list_for_each_entry_safe_from_inside(grp_iter, _grp_iter,
+				grp_start, &iop_chan->chain, chain_node) {
 				cookie = iop_adma_run_tx_complete_actions(
 					grp_iter, iop_chan, cookie);
 
-- 
2.17.1

