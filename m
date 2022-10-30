Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007D5612696
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJ3ASl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiJ3ASj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:39 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9AE24BC9
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:37 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id p141so7378691iod.6
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4nuwgGkQOaib3BwT5hOD0oPhyITqBv+siRpxH4LVLA=;
        b=mFRjU8VyCMQFZRCnmc4mwYxK+EmqfjHKvJdfbxtCfqCmyc+cIS3KWFHcrPH9Gr4zK0
         DQDAVd2KM4lAPKzPybAPi5GZSKCtvMUo6o58yZNMtZG4puUEOEH+JgBPlkmXk4F9jDCE
         EMt1/tsIpvz8pma7RpR3XB3zCKSFUxSO5lAaFaFmpk7WvjBzzfr1TfXflvLlX7UZ5Uv6
         /IMjXQyjDlVFjJaagS28/wvIbhFgYjEvaMDKqGJqCWolf8oNCR+WeLPRHPwgIZvnjKNj
         ++L4cmYnzIJpm1i7Tf2P0a7QqO7ErkomGkoBqCRjTt9dZn4R+nYFMzE0/sMBwQ+HVedp
         PSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4nuwgGkQOaib3BwT5hOD0oPhyITqBv+siRpxH4LVLA=;
        b=usWRzb8nIoOJtq2LCD3RdZnFhwVVJyykzNxKMz8A4tvhUcO2oPRg9JW22y0Ak6KKl7
         XuCB4QAawhFJlAbzJN7SwSv1J22I6van14/Tgjedga6MOk3ANwG0oue0Mfc2zOrHV+a8
         O430yJ6HFtKQt4mRWkCucvB+eciIX9+EUX07LMUrMXlMddEJbqg8Ws9crnlV2LG6PAnt
         yLGV47WOOCCDmmB5anYfJrFmqbTjhfbD5M6MTr2WpQcPa1caO/jYN8gN/YpWdRImS/es
         emM2vQMV1fp6JPiS7XZhwcyPz7UPM/IJm2ztda2q9D5RG7IEASbyXcLmKfd71ENvVArg
         vWFA==
X-Gm-Message-State: ACrzQf1lqUuaOj8CcS54tfjduwwaPtG7EHjMYleYeJ1l+UV3ljz21pYr
        MKfCeA3sY4N1lYW+FnJfSSycEA==
X-Google-Smtp-Source: AMsMyM5S/nbsZUSy7eMf0sZ7+EEJ+0+Lf3ABKup2ZKFrr7kGQCUIRDCfEiD7BXS6y0o7YcFUMzCROw==
X-Received: by 2002:a6b:3ec5:0:b0:6ce:16bf:2e8e with SMTP id l188-20020a6b3ec5000000b006ce16bf2e8emr777958ioa.160.1667089116799;
        Sat, 29 Oct 2022 17:18:36 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] net: ipa: reduce arguments to ipa_table_init_add()
Date:   Sat, 29 Oct 2022 19:18:20 -0500
Message-Id: <20221030001828.754010-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently ipa_table_mem() was added as a way to look up one of 8
possible memory regions by indicating whether it was a filter or
route table, hashed or not, and IPv6 or not.

We can simplify the interface to ipa_table_init_add() by passing two
flags to it instead of the opcode and both hashed and non-hashed
memory region IDs.  The "filter" and "ipv6" flags are sufficient to
determine the opcode to use, and with ipa_table_mem() can look up
the correct memory region as well.

It's possible to not have hashed tables, but we already verify the
number of entries in a filter or routing table is nonzero.  Stop
assuming a hashed table entry exists in ipa_table_init_add().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index cf3a3de239dc3..94bb7611e574b 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -376,14 +376,12 @@ int ipa_table_hash_flush(struct ipa *ipa)
 	return 0;
 }
 
-static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
-			       enum ipa_cmd_opcode opcode,
-			       enum ipa_mem_id mem_id,
-			       enum ipa_mem_id hash_mem_id)
+static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	const struct ipa_mem *hash_mem = ipa_mem_find(ipa, hash_mem_id);
-	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
+	const struct ipa_mem *hash_mem;
+	enum ipa_cmd_opcode opcode;
+	const struct ipa_mem *mem;
 	dma_addr_t hash_addr;
 	dma_addr_t addr;
 	u32 zero_offset;
@@ -393,6 +391,14 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 	u16 count;
 	u16 size;
 
+	opcode = filter ? ipv6 ? IPA_CMD_IP_V6_FILTER_INIT
+			       : IPA_CMD_IP_V4_FILTER_INIT
+			: ipv6 ? IPA_CMD_IP_V6_ROUTING_INIT
+			       : IPA_CMD_IP_V4_ROUTING_INIT;
+
+	mem = ipa_table_mem(ipa, filter, false, ipv6);
+	hash_mem = ipa_table_mem(ipa, filter, true, ipv6);
+
 	/* Compute the number of table entries to initialize */
 	if (filter) {
 		/* The number of filtering endpoints determines number of
@@ -401,13 +407,13 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 		 * table is either the same as the non-hashed one, or zero.
 		 */
 		count = 1 + hweight32(ipa->filter_map);
-		hash_count = hash_mem->size ? count : 0;
+		hash_count = hash_mem && hash_mem->size ? count : 0;
 	} else {
 		/* The size of a route table region determines the number
 		 * of entries it has.
 		 */
 		count = mem->size / sizeof(__le64);
-		hash_count = hash_mem->size / sizeof(__le64);
+		hash_count = hash_mem && hash_mem->size / sizeof(__le64);
 	}
 	size = count * sizeof(__le64);
 	hash_size = hash_count * sizeof(__le64);
@@ -458,17 +464,10 @@ int ipa_table_setup(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	ipa_table_init_add(trans, false, IPA_CMD_IP_V4_ROUTING_INIT,
-			   IPA_MEM_V4_ROUTE, IPA_MEM_V4_ROUTE_HASHED);
-
-	ipa_table_init_add(trans, false, IPA_CMD_IP_V6_ROUTING_INIT,
-			   IPA_MEM_V6_ROUTE, IPA_MEM_V6_ROUTE_HASHED);
-
-	ipa_table_init_add(trans, true, IPA_CMD_IP_V4_FILTER_INIT,
-			   IPA_MEM_V4_FILTER, IPA_MEM_V4_FILTER_HASHED);
-
-	ipa_table_init_add(trans, true, IPA_CMD_IP_V6_FILTER_INIT,
-			   IPA_MEM_V6_FILTER, IPA_MEM_V6_FILTER_HASHED);
+	ipa_table_init_add(trans, false, false);
+	ipa_table_init_add(trans, false, true);
+	ipa_table_init_add(trans, true, false);
+	ipa_table_init_add(trans, true, true);
 
 	gsi_trans_commit_wait(trans);
 
-- 
2.34.1

