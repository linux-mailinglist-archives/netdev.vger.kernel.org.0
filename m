Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F1C683606
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAaTFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjAaTFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:05:34 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F4E5529F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:26 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id d21-20020a056830005500b0068bd2e0b25bso1839381otp.1
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skMJ5WlKzJfF4SEoAR9i0wroFymN+iYxmoL0G/Rtb1g=;
        b=pQGD51pRfT+5Or1zQHUEBbBC/Tcm9BcdL/YPRcymXCsJs0eSurovrBltZq0pBBmrkS
         muuG8dlkr9Ug6MI9zjIMcOwM1AfTLnhGZ74tEJke/5PM75N2klyp5f9s8oWnONKzuxTq
         S61a6wxANUs0oRCoOisz+dAxuboxpw3NWsNTslE3P0taYllgLFPCp1eQKFavonKW6AtM
         Ddk0PMSwbXtWK9RJGHyw7NQ15m8ajgTtPeFDZCxvIr1AIAoQt4gmC+UttD2eBGlfBd6b
         k6g8x4ejiH45x9fdx1XysEA8VSmNxUD1yjtzDJ8NwaWqYt//RUx/SwYNY5qRjdHvVb5Y
         SyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skMJ5WlKzJfF4SEoAR9i0wroFymN+iYxmoL0G/Rtb1g=;
        b=1PDgirxrsxKzdRrZNpYIGc4OqN9WngsJhY4vz0nerGAvv2Jwl6ZH9I1WlR9l3OJf9W
         XS8lQ4E4bLnYrwFAdfeSrL0Ccc034wqVOVxEgdwzmKOJof6YhIE1W30ttM95wIPSkFLk
         gvBzm+HEhyqAv9Km9TkG80GUXq1CE14tXH6NwuoPEKYQsLxfIUsNVVnfDdnJGRj03uXT
         OLc/h8SJeKoyS2KX6LEUcEsZve/wGUeogFavG+wWlAaaFYghEf3VdYolchN7QiP0nFX8
         zKEZZ/fV55DRVBISD1c42DypPFGIkWH2dfP0J08ngXb008DxWqigBsOHzkGoRU6qnhfs
         o7QQ==
X-Gm-Message-State: AO0yUKVHnsIOkidkVTlwIJtwdKS/NQBbXY/iSvQ3eFa0KXUk4rYq5sni
        oqYbh2KqQ3n699Py5bHIMbLH0IKB7nbqnd3K
X-Google-Smtp-Source: AK7set9yUaQXTUgzhDhSTAX2WEz+T7ysoXaViBKn9+tJZpUCoxhyMGWt9szvSnVYTChdVfI16bbQfA==
X-Received: by 2002:a05:6830:1409:b0:66d:ddfe:4308 with SMTP id v9-20020a056830140900b0066dddfe4308mr6540707otp.24.1675191925218;
        Tue, 31 Jan 2023 11:05:25 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id i5-20020a9d6505000000b0068649039745sm6941450otl.6.2023.01.31.11.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 11:05:25 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v6 2/2] net/sched: simplify tcf_pedit_act
Date:   Tue, 31 Jan 2023 16:05:12 -0300
Message-Id: <20230131190512.3805897-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131190512.3805897-1-pctammela@mojatatu.com>
References: <20230131190512.3805897-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the check for a negative number of keys as
this cannot ever happen

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 137 +++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 70 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 991541094278..c42fcc47dd6d 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -346,8 +346,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 				    const struct tc_action *a,
 				    struct tcf_result *res)
 {
+	enum pedit_header_type htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_key_ex *tkey_ex;
 	struct tcf_pedit_parms *parms;
+	struct tc_pedit_key *tkey;
 	u32 max_offset;
 	int i;
 
@@ -363,88 +367,81 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 	tcf_lastuse_update(&p->tcf_tm);
 	tcf_action_update_bstats(&p->common, skb);
 
-	if (parms->tcfp_nkeys > 0) {
-		struct tc_pedit_key *tkey = parms->tcfp_keys;
-		struct tcf_pedit_key_ex *tkey_ex = parms->tcfp_keys_ex;
-		enum pedit_header_type htype =
-			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
-		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
-
-		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
-			u32 *ptr, hdata;
-			int offset = tkey->off;
-			int hoffset;
-			u32 val;
-			int rc;
-
-			if (tkey_ex) {
-				htype = tkey_ex->htype;
-				cmd = tkey_ex->cmd;
-
-				tkey_ex++;
-			}
+	tkey = parms->tcfp_keys;
+	tkey_ex = parms->tcfp_keys_ex;
 
-			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-			if (rc) {
-				pr_info("tc action pedit bad header type specified (0x%x)\n",
-					htype);
-				goto bad;
-			}
+	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
+		int offset = tkey->off;
+		u32 *ptr, hdata;
+		int hoffset;
+		u32 val;
+		int rc;
 
-			if (tkey->offmask) {
-				u8 *d, _d;
-
-				if (!offset_valid(skb, hoffset + tkey->at)) {
-					pr_info("tc action pedit 'at' offset %d out of bounds\n",
-						hoffset + tkey->at);
-					goto bad;
-				}
-				d = skb_header_pointer(skb, hoffset + tkey->at,
-						       sizeof(_d), &_d);
-				if (!d)
-					goto bad;
-				offset += (*d & tkey->offmask) >> tkey->shift;
-			}
+		if (tkey_ex) {
+			htype = tkey_ex->htype;
+			cmd = tkey_ex->cmd;
 
-			if (offset % 4) {
-				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-				goto bad;
-			}
+			tkey_ex++;
+		}
 
-			if (!offset_valid(skb, hoffset + offset)) {
-				pr_info("tc action pedit offset %d out of bounds\n",
-					hoffset + offset);
-				goto bad;
-			}
+		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
+		if (rc) {
+			pr_info("tc action pedit bad header type specified (0x%x)\n",
+				htype);
+			goto bad;
+		}
 
-			ptr = skb_header_pointer(skb, hoffset + offset,
-						 sizeof(hdata), &hdata);
-			if (!ptr)
-				goto bad;
-			/* just do it, baby */
-			switch (cmd) {
-			case TCA_PEDIT_KEY_EX_CMD_SET:
-				val = tkey->val;
-				break;
-			case TCA_PEDIT_KEY_EX_CMD_ADD:
-				val = (*ptr + tkey->val) & ~tkey->mask;
-				break;
-			default:
-				pr_info("tc action pedit bad command (%d)\n",
-					cmd);
+		if (tkey->offmask) {
+			u8 *d, _d;
+
+			if (!offset_valid(skb, hoffset + tkey->at)) {
+				pr_info("tc action pedit 'at' offset %d out of bounds\n",
+					hoffset + tkey->at);
 				goto bad;
 			}
+			d = skb_header_pointer(skb, hoffset + tkey->at,
+					       sizeof(_d), &_d);
+			if (!d)
+				goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+		}
 
-			*ptr = ((*ptr & tkey->mask) ^ val);
-			if (ptr == &hdata)
-				skb_store_bits(skb, hoffset + offset, ptr, 4);
+		if (offset % 4) {
+			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+			goto bad;
 		}
 
-		goto done;
-	} else {
-		WARN(1, "pedit BUG: index %d\n", p->tcf_index);
+		if (!offset_valid(skb, hoffset + offset)) {
+			pr_info("tc action pedit offset %d out of bounds\n",
+				hoffset + offset);
+			goto bad;
+		}
+
+		ptr = skb_header_pointer(skb, hoffset + offset,
+					 sizeof(hdata), &hdata);
+		if (!ptr)
+			goto bad;
+		/* just do it, baby */
+		switch (cmd) {
+		case TCA_PEDIT_KEY_EX_CMD_SET:
+			val = tkey->val;
+			break;
+		case TCA_PEDIT_KEY_EX_CMD_ADD:
+			val = (*ptr + tkey->val) & ~tkey->mask;
+			break;
+		default:
+			pr_info("tc action pedit bad command (%d)\n",
+				cmd);
+			goto bad;
+		}
+
+		*ptr = ((*ptr & tkey->mask) ^ val);
+		if (ptr == &hdata)
+			skb_store_bits(skb, hoffset + offset, ptr, 4);
 	}
 
+	goto done;
+
 bad:
 	spin_lock(&p->tcf_lock);
 	p->tcf_qstats.overlimits++;
-- 
2.34.1

