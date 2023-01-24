Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3242F679F9F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjAXRGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbjAXRGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:02 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3963D097
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-50660e2d2ffso11487087b3.1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shP6fdrLVG4eVEYAov+j4yNTs/jzAWvl4mqFvVeVXP0=;
        b=BD6XM1KmXgVTGcmrlMcsAjzqySugI8JAT9tcK73m/gbvF8rtRxBQS7NYxkaaSsLFeP
         5kEO8hdVPiLDULkc6Kc1uLZRFcTlJSWYApAyou5djs5QYA+lpHGGzMLnqlJAk+qbjaW1
         BK/K04IE0LPOL48flciIEOTc/fXL1KSCDpMMrqPvWC6QbsjUifuW8WWyJuS0yV2PwSbc
         59ObjbqhGk8cp781/HW4dL2yfqERTKTdWKNjR0xTIH+fourHZuw1HkCdQpYQzTi1WNxD
         wPak4L23CYyrcvunyGDp9UHhbFt0P5+dS28XPenpEQjPRk52jOJvkHLpdfG3SFv2fjvw
         FgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=shP6fdrLVG4eVEYAov+j4yNTs/jzAWvl4mqFvVeVXP0=;
        b=tsdUGDH9wgQ/QxV+eKHxoV9344lQkXoGNiY5ZggF/iRCKmlTCDhgH7gpDOL3oXWjuV
         CMHa3R40EkEZVGk0i1Ms2lUH+BpzG1QfIk6cWPaqPr/c9Zlgx40qy+Tm5SjupHM2wofY
         +Z0PB2d+shyra8gif67cYy3BVdb8utGkg5tMfzC0K4Yb/tgV/yG3zybuK1HEx7lKQQeJ
         Haf/cGsKQGEQt3tzhI78Fnr0pMNchLtm3twbYj5HCsmLZzxoA/Dc8QTmnyT9r3M6LSRE
         65mCVQjcqeexXT+2zNACXonmTvuQfz/zU4X8KV6X/SpBNzRBRbGejBf4XkKICpifEu/E
         xZvg==
X-Gm-Message-State: AO0yUKUeWQQiVacgacnOM3BZAsYJOM0xoYvjnnNpsT6KksMlV2RELCAl
        CvbvtVk0qeQkaOzzZ7XBLcOQ7nEheWjjgwAb
X-Google-Smtp-Source: AK7set+fNMWbUwUCqaSTK/JK+py7ls7B1f61+rKwcEVXtmOkZ2H6uCUUDi/V8LtQzgQtI0kCCZk95g==
X-Received: by 2002:a05:7500:5245:b0:f3:95f4:c4f4 with SMTP id r5-20020a057500524500b000f395f4c4f4mr332011gab.33.1674579916492;
        Tue, 24 Jan 2023 09:05:16 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:16 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 05/20] net/sched: act_api: introduce tc_lookup_action_byid()
Date:   Tue, 24 Jan 2023 12:04:55 -0500
Message-Id: <20230124170510.316970-5-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
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

Introduce a lookup helper to retrieve the tc_action_ops
instance given its action id.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h |  1 +
 net/sched/act_api.c   | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 64dc75ba6..083557e51 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -204,6 +204,7 @@ int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
 int tcf_idr_release(struct tc_action *a, bool bind);
 
 int tcf_register_action(struct tc_action_ops *a, struct pernet_operations *ops);
+struct tc_action_ops *tc_lookup_action_byid(u32 act_id);
 int tcf_unregister_action(struct tc_action_ops *a,
 			  struct pernet_operations *ops);
 int tcf_action_destroy(struct tc_action *actions[], int bind);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 622b8d3c5..c5dca2085 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1020,6 +1020,26 @@ int tcf_unregister_action(struct tc_action_ops *act,
 }
 EXPORT_SYMBOL(tcf_unregister_action);
 
+/* lookup by ID */
+struct tc_action_ops *tc_lookup_action_byid(u32 act_id)
+{
+	struct tc_action_ops *a, *res = NULL;
+
+	if (!act_id)
+		return NULL;
+
+	read_lock(&act_mod_lock);
+
+	a = idr_find(&act_base, act_id);
+	if (a && try_module_get(a->owner))
+		res = a;
+
+	read_unlock(&act_mod_lock);
+
+	return res;
+}
+EXPORT_SYMBOL(tc_lookup_action_byid);
+
 /* lookup by name */
 static struct tc_action_ops *tc_lookup_action_n(char *kind)
 {
-- 
2.34.1

