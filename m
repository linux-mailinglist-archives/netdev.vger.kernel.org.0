Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E1E679F9A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjAXRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjAXRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:05:38 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FC711C
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:14 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-4a2f8ad29d5so227194117b3.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xjid5R0qLT03DNXyh2RLPnthriJMJJMxKaS9MPlNtjQ=;
        b=QHJidW1aCX7yvDyWvk8OrKOXjc44yf+n58ubq2uPh1m+K5ixEE7VYUwFBhTp2l5d3X
         EnY6+PHfBdFngSJ/AiV5PhY7EJUeM6uQx3InwSdB8axrmUE/ePtU/OOb3Djp8fNXRwa+
         Y0o/Bb7C9EdgI/98b+KCJmjntg+bvg0BVW945xGJL/rpJLZ0ujwgPrcRs7CV9BSRRJqC
         d5HcJycQDhCdDOZIZoFt+3al8vbWyg4cb2BmS+weuzAvK+NySSWgftmsIutmpZ/PHu4h
         NskeEfSFWuDmDH6g8aHHzGI/sldwOKaPG+4B1Souj7J230LsRKuV90/IIlP2mTcNwM2a
         IVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xjid5R0qLT03DNXyh2RLPnthriJMJJMxKaS9MPlNtjQ=;
        b=o7U8kl6t6YhDHBWpSrjiTa1OSJxtQGXUXSZuHsbZ3eIDIEq6lan5WrlkW1mdZWPGyd
         bd0dOA4bzGOAY2HwX+19gG3fq9OawHSXwYwpdzQWc6sj4rr5aixvZ+JtQ8JxQJS0iKZ/
         8GRPTuYIODvPeaV4giPQKKpmiytXRfKpY3o1Uvmf0ET3BsYEIeovqgU2hncrbiHoLF8M
         7wKiedq1GjFgesRfggqSJoSIVa11t4PPCY71libGf4LjC8w23YOu+FYJhhWv59v5sqOT
         x6F97qHAYAoS/1JonK2lXk1AXjfLbM1AkM2j59R2rVTM4unXLyumD/l6Plv/zU0PRvlo
         utpw==
X-Gm-Message-State: AFqh2krX7bD6xNpJaV7JjTnQ9IKY1glSn98C1eJw0uGNA+sOXxIIwZdD
        nrYGoOrLAUWyvbLMagTDCwtvCTvsn6hSlWX2
X-Google-Smtp-Source: AMrXdXuojCMQ5BLOcPX5IjwYeTonIo2BHL7xtyG4GCd2IldQJ8V9zkPkrGGCZRaqxo2Cwq5YNsolmA==
X-Received: by 2002:a0d:edc7:0:b0:4c6:54a2:bf96 with SMTP id w190-20020a0dedc7000000b004c654a2bf96mr34911768ywe.22.1674579911694;
        Tue, 24 Jan 2023 09:05:11 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:11 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 01/20] net/sched: act_api: change act_base into an IDR
Date:   Tue, 24 Jan 2023 12:04:51 -0500
Message-Id: <20230124170510.316970-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
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

Convert act_base from a list to an IDR.

With the introduction of P4TC action templates, we introduce the concept of
dynamically creating actions on the fly. Dynamic action IDs are not statically
defined (as was the case previously) and are therefore harder to manage within
existing linked list approach. We convert to IDR because it has built in ID
management which we would have to re-invent with linked lists.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/uapi/linux/pkt_cls.h |  1 +
 net/sched/act_api.c          | 39 +++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 648a82f32..4d716841c 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -139,6 +139,7 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
+	TCA_ID_DYN,
 	/* other actions go here */
 	__TCA_ID_MAX = 255
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index cd09ef49d..811dddc3b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -890,7 +890,7 @@ void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
 }
 EXPORT_SYMBOL(tcf_idrinfo_destroy);
 
-static LIST_HEAD(act_base);
+static DEFINE_IDR(act_base);
 static DEFINE_RWLOCK(act_mod_lock);
 /* since act ops id is stored in pernet subsystem list,
  * then there is no way to walk through only all the action
@@ -949,7 +949,6 @@ static void tcf_pernet_del_id_list(unsigned int id)
 int tcf_register_action(struct tc_action_ops *act,
 			struct pernet_operations *ops)
 {
-	struct tc_action_ops *a;
 	int ret;
 
 	if (!act->act || !act->dump || !act->init)
@@ -970,13 +969,24 @@ int tcf_register_action(struct tc_action_ops *act,
 	}
 
 	write_lock(&act_mod_lock);
-	list_for_each_entry(a, &act_base, head) {
-		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
+	if (act->id) {
+		if (idr_find(&act_base, act->id)) {
 			ret = -EEXIST;
 			goto err_out;
 		}
+		ret = idr_alloc_u32(&act_base, act, &act->id, act->id,
+				    GFP_ATOMIC);
+		if (ret < 0)
+			goto err_out;
+	} else {
+		/* Only dynamic actions will require ID generation */
+		act->id = TCA_ID_DYN;
+
+		ret = idr_alloc_u32(&act_base, act, &act->id, TCA_ID_MAX,
+				    GFP_ATOMIC);
+		if (ret < 0)
+			goto err_out;
 	}
-	list_add_tail(&act->head, &act_base);
 	write_unlock(&act_mod_lock);
 
 	return 0;
@@ -994,17 +1004,12 @@ EXPORT_SYMBOL(tcf_register_action);
 int tcf_unregister_action(struct tc_action_ops *act,
 			  struct pernet_operations *ops)
 {
-	struct tc_action_ops *a;
-	int err = -ENOENT;
+	int err = 0;
 
 	write_lock(&act_mod_lock);
-	list_for_each_entry(a, &act_base, head) {
-		if (a == act) {
-			list_del(&act->head);
-			err = 0;
-			break;
-		}
-	}
+	if (!idr_remove(&act_base, act->id))
+		err = -EINVAL;
+
 	write_unlock(&act_mod_lock);
 	if (!err) {
 		unregister_pernet_subsys(ops);
@@ -1019,10 +1024,11 @@ EXPORT_SYMBOL(tcf_unregister_action);
 static struct tc_action_ops *tc_lookup_action_n(char *kind)
 {
 	struct tc_action_ops *a, *res = NULL;
+	unsigned long tmp, id;
 
 	if (kind) {
 		read_lock(&act_mod_lock);
-		list_for_each_entry(a, &act_base, head) {
+		idr_for_each_entry_ul(&act_base, a, tmp, id) {
 			if (strcmp(kind, a->kind) == 0) {
 				if (try_module_get(a->owner))
 					res = a;
@@ -1038,10 +1044,11 @@ static struct tc_action_ops *tc_lookup_action_n(char *kind)
 static struct tc_action_ops *tc_lookup_action(struct nlattr *kind)
 {
 	struct tc_action_ops *a, *res = NULL;
+	unsigned long tmp, id;
 
 	if (kind) {
 		read_lock(&act_mod_lock);
-		list_for_each_entry(a, &act_base, head) {
+		idr_for_each_entry_ul(&act_base, a, tmp, id) {
 			if (nla_strcmp(kind, a->kind) == 0) {
 				if (try_module_get(a->owner))
 					res = a;
-- 
2.34.1

