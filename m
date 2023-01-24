Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA33679F9B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjAXRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjAXRFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:05:39 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC4E233D1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:14 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4fda31c3351so198403917b3.11
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5piEUutojf6lyadXobK442hJbhHg2dN8P7p9kl2Gx2A=;
        b=YXGBZwZADZPgcQAYSUdeMRI1LOuu4QWv+jyTcysg9aVKPawxsCN1eYTTzKG4+FGrdL
         Q1/xHJOycw3J3YzyWI51GyuJLGZ+Gs2HxPnjiMxLXWx00Kpw2AeVxVqNPc9tLWOa5PVJ
         pzUGLo6pvC2vOlxUruzUnJxV05+jef4YQ7QB2QCvoLIV27V0xZyn/8uub4xNcX40Ksco
         sbRSMe0p2wEaqanIVZLgOQi1Hl7r6bfZzB2GIGMJkXzBjZIV4pX0deAiUtILSgJgqJw7
         cVjBxB4N1DeKD7zrQ4mo7pn/971jQBJmzq8cxs/DHPKN9U9/3iIa+PHXmYSsB+jea1zo
         yx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5piEUutojf6lyadXobK442hJbhHg2dN8P7p9kl2Gx2A=;
        b=hLs6qJh4GKREq4eW5J6biABA6DyBwuPeu6EcFpTo0b95GclBZ2Q0URHjOxhMoodBSH
         vaMilkG1fEBLgEyZFShqHAWIT6RFOubR6v66RyHj0OOv2jD1+AjZbA001prVAYYPRbVQ
         nkJvs2HpfghRRYoHP3egvtJg4OzrM00N+7pduT7vKMG2pywVPxScMTwuxgtw1LSsFWlk
         dGENVxqBXiY5ay/STc5vuYvcdzbASfjXPH/94zr74xtK6GsNT/unMssAKXn2MUsR1oT1
         pYmn7UEx++VHQZjynUKxABlMF/pR3KZml5bjyzHdgr4tkovH2vGD/BZXnQrqfck6Lgua
         hawA==
X-Gm-Message-State: AFqh2koVbNYDhvM9iW6i/TUNn4/XGZFUHDxV/MDQKkd+ST9Ii/pt+cn2
        EryRm3RwrsxR/x+Uc1wI0SJmezCGbmUfO1aC
X-Google-Smtp-Source: AMrXdXsXjXU6yq5XDTheRMzW1jqTCOQUMUg9io59B6+v6VtNxO68N/eKOpykXL/FEzYsATVJExHE8Q==
X-Received: by 2002:a05:7500:191e:b0:f0:6268:17ee with SMTP id cz30-20020a057500191e00b000f0626817eemr1412274gab.27.1674579912765;
        Tue, 24 Jan 2023 09:05:12 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:12 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 02/20] net/sched: act_api: increase action kind string length
Date:   Tue, 24 Jan 2023 12:04:52 -0500
Message-Id: <20230124170510.316970-2-jhs@mojatatu.com>
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

Increase action kind string length from IFNAMSIZ to 64

The new P4TC dynamic actions, created via templates, will have longer names
of format: "pipeline_name/act_name". IFNAMSIZ is currently 16 and is most of
the times undersized for the above format.
So, to conform to this new format, we increase the maximum name length
to account for this extra string (pipeline name) and the '/' character.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h        | 2 +-
 include/uapi/linux/pkt_cls.h | 1 +
 net/sched/act_api.c          | 6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2a6f443f0..5557c55d5 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -105,7 +105,7 @@ typedef void (*tc_action_priv_destructor)(void *priv);
 
 struct tc_action_ops {
 	struct list_head head;
-	char    kind[IFNAMSIZ];
+	char    kind[ACTNAMSIZ];
 	enum tca_id  id; /* identifier should match kind */
 	unsigned int	net_id;
 	size_t	size;
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 4d716841c..5b66df3ec 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -6,6 +6,7 @@
 #include <linux/pkt_sched.h>
 
 #define TC_COOKIE_MAX_SIZE 16
+#define ACTNAMSIZ 64
 
 /* Action attributes */
 enum {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 811dddc3b..2e5a6ebb1 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -449,7 +449,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 	rcu_read_unlock();
 
 	return  nla_total_size(0) /* action number nested */
-		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
+		+ nla_total_size(ACTNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
@@ -1312,7 +1312,7 @@ struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 {
 	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct tc_action_ops *a_o;
-	char act_name[IFNAMSIZ];
+	char act_name[ACTNAMSIZ];
 	struct nlattr *kind;
 	int err;
 
@@ -1327,7 +1327,7 @@ struct tc_action_ops *tc_action_load_ops(struct nlattr *nla, bool police,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			return ERR_PTR(err);
 		}
-		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
+		if (nla_strscpy(act_name, kind, ACTNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
 			return ERR_PTR(err);
 		}
-- 
2.34.1

