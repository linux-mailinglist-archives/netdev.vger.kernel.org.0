Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D312D6A1DE9
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBXPBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBXPBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:01:41 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55555474C5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:39 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-172afa7bee2so1314514fac.6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOa5xnOOd9PjALfabLcWeCVK0bEhID3EBTcw31yNd4Q=;
        b=WNVL6Y+NTJepshggfOYJfYQo4vbAt/Ee3/HQHtCKbjs7LUCyIrDTn4r1IT0p81QK4Y
         POYxrSKdPyxmn8P4MU/zQafVnQazEJ1h2jtv1hjone3DjqN2IyJlNSI9dn/dk+uuhUpn
         C275I5FUt80WC7+oWhONUrle+m1RmNPlEcYWbZ9QgE3XS0Lg9WMxwl4m5QD/z0Dxt1Ks
         ANUdKPjyUYTm2O8GRs3ab689rsLtFSg9j2obkbnk4TjrG4lRGvNlmEPzqzGIlNSJwSu3
         9cfH//K2kzweImdHPVCx+CWqngepOKx5JUdMvSPTaVL7H+aofIfK76NPHC0marcSCsw7
         KZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOa5xnOOd9PjALfabLcWeCVK0bEhID3EBTcw31yNd4Q=;
        b=KHl2mcb548Vuzv1OjFbWacYgbfq36vpkfORgnIBuw3MjucVkpz62jsSYPsLAcHTYMh
         QUjBnrrt+Sb7BQizc256NEOZAkp/ruLuvq+1CwAhEmnzmYEZIONVeaTszRk5oBrAquTK
         9rXhWm6McyxgXr9vIVfrxHLRHgHav5vpJr6SMmqtzixZ7XozvOD20n99O7VjA4WuGjEg
         0atQXvkt5qcs+HbiRgTOI5xMtm6nAh9hlvQp/UJ23DGShKEhi1rZ0O65KbuXtchoviZd
         l0Yfy0rnM0DVqO2Rn9a01Q+SXqcqcTUZB/t/6Q5urCmJZehkAcqx3vhrJf+CQtAMlDFm
         fr5Q==
X-Gm-Message-State: AO0yUKXVGPd0li29AF3VQmjj+3v58B90O2NROfJ2rDlXfSa0+rk8nn1/
        b0Eo6yR8YH4ei5uqt6xqgGxRu2lR2e5SpBEZ
X-Google-Smtp-Source: AK7set+f7lgehYa8h+1+i1UGNiCpfxLo2yByNw9+LCR9OY9aK+E0NpFGR206GUMNdRcn/+thFmLPoQ==
X-Received: by 2002:a05:6870:f717:b0:172:36bf:e281 with SMTP id ej23-20020a056870f71700b0017236bfe281mr5844930oab.23.1677250898421;
        Fri, 24 Feb 2023 07:01:38 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id r28-20020a05683002fc00b00686a19ffef1sm3237636ote.80.2023.02.24.07.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 07:01:38 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, yotamg@mellanox.com, ozsh@nvidia.com,
        paulb@nvidia.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net 2/3] net/sched: act_mpls: fix action bind logic
Date:   Fri, 24 Feb 2023 12:00:57 -0300
Message-Id: <20230224150058.149505-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224150058.149505-1-pctammela@mojatatu.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
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

The TC architecture allows filters and actions to be created independently.
In filters the user can reference action objects using:
tc action add action mpls ... index 1
tc filter add ... action mpls index 1

In the current code for act_mpls this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..53
ok 1 a933 - Add MPLS dec_ttl action with pipe opcode
ok 2 08d1 - Add mpls dec_ttl action with pass opcode
ok 3 d786 - Add mpls dec_ttl action with drop opcode
ok 4 f334 - Add mpls dec_ttl action with reclassify opcode
ok 5 29bd - Add mpls dec_ttl action with continue opcode
ok 6 48df - Add mpls dec_ttl action with jump opcode
ok 7 62eb - Add mpls dec_ttl action with trap opcode
ok 8 09d2 - Add mpls dec_ttl action with opcode and cookie
ok 9 c170 - Add mpls dec_ttl action with opcode and cookie of max length
ok 10 9118 - Add mpls dec_ttl action with invalid opcode
ok 11 6ce1 - Add mpls dec_ttl action with label (invalid)
ok 12 352f - Add mpls dec_ttl action with tc (invalid)
ok 13 fa1c - Add mpls dec_ttl action with ttl (invalid)
ok 14 6b79 - Add mpls dec_ttl action with bos (invalid)
ok 15 d4c4 - Add mpls pop action with ip proto
ok 16 91fb - Add mpls pop action with ip proto and cookie
ok 17 92fe - Add mpls pop action with mpls proto
ok 18 7e23 - Add mpls pop action with no protocol (invalid)
ok 19 6182 - Add mpls pop action with label (invalid)
ok 20 6475 - Add mpls pop action with tc (invalid)
ok 21 067b - Add mpls pop action with ttl (invalid)
ok 22 7316 - Add mpls pop action with bos (invalid)
ok 23 38cc - Add mpls push action with label
ok 24 c281 - Add mpls push action with mpls_mc protocol
ok 25 5db4 - Add mpls push action with label, tc and ttl
ok 26 7c34 - Add mpls push action with label, tc ttl and cookie of max length
ok 27 16eb - Add mpls push action with label and bos
ok 28 d69d - Add mpls push action with no label (invalid)
ok 29 e8e4 - Add mpls push action with ipv4 protocol (invalid)
ok 30 ecd0 - Add mpls push action with out of range label (invalid)
ok 31 d303 - Add mpls push action with out of range tc (invalid)
ok 32 fd6e - Add mpls push action with ttl of 0 (invalid)
ok 33 19e9 - Add mpls mod action with mpls label
ok 34 1fde - Add mpls mod action with max mpls label
ok 35 0c50 - Add mpls mod action with mpls label exceeding max (invalid)
ok 36 10b6 - Add mpls mod action with mpls label of MPLS_LABEL_IMPLNULL (invalid)
ok 37 57c9 - Add mpls mod action with mpls min tc
ok 38 6872 - Add mpls mod action with mpls max tc
ok 39 a70a - Add mpls mod action with mpls tc exceeding max (invalid)
ok 40 6ed5 - Add mpls mod action with mpls ttl
ok 41 77c1 - Add mpls mod action with mpls ttl and cookie
ok 42 b80f - Add mpls mod action with mpls max ttl
ok 43 8864 - Add mpls mod action with mpls min ttl
ok 44 6c06 - Add mpls mod action with mpls ttl of 0 (invalid)
ok 45 b5d8 - Add mpls mod action with mpls ttl exceeding max (invalid)
ok 46 451f - Add mpls mod action with mpls max bos
ok 47 a1ed - Add mpls mod action with mpls min bos
ok 48 3dcf - Add mpls mod action with mpls bos exceeding max (invalid)
ok 49 db7c - Add mpls mod action with protocol (invalid)
ok 50 b070 - Replace existing mpls push action with new ID
ok 51 95a9 - Replace existing mpls push action with new label, tc, ttl and cookie
ok 52 6cce - Delete mpls pop action
ok 53 d138 - Flush mpls actions

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_mpls.c | 66 +++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 6b26bdb999d7..809f7928a1be 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -190,40 +190,67 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	parm = nla_data(tb[TCA_MPLS_PARMS]);
 	index = parm->index;
 
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return 0;
+
+	if (!exists) {
+		ret = tcf_idr_create(tn, index, est, a, &act_mpls_ops, bind,
+				     true, flags);
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+
+		ret = ACT_P_CREATED;
+	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
 	/* Verify parameters against action type. */
 	switch (parm->m_action) {
 	case TCA_MPLS_ACT_POP:
 		if (!tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be set for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (!eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] ||
 		    tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC or BOS cannot be used with MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_DEC_TTL:
 		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
 		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] || tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC, BOS or protocol cannot be used with MPLS dec_ttl");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_PUSH:
 	case TCA_MPLS_ACT_MAC_PUSH:
 		if (!tb[TCA_MPLS_LABEL]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_PROTO] &&
 		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be an MPLS type for MPLS push");
-			return -EPROTONOSUPPORT;
+			err = -EPROTONOSUPPORT;
+			goto release_idr;
 		}
 		/* Push needs a TTL - if not specified, set a default value. */
 		if (!tb[TCA_MPLS_TTL]) {
@@ -238,33 +265,14 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	case TCA_MPLS_ACT_MODIFY:
 		if (tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be used with MPLS modify");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unknown MPLS action");
-		return -EINVAL;
-	}
-
-	err = tcf_idr_check_alloc(tn, &index, a, bind);
-	if (err < 0)
-		return err;
-	exists = err;
-	if (exists && bind)
-		return 0;
-
-	if (!exists) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, flags);
-		if (ret) {
-			tcf_idr_cleanup(tn, index);
-			return ret;
-		}
-
-		ret = ACT_P_CREATED;
-	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-		tcf_idr_release(*a, bind);
-		return -EEXIST;
+		err = -EINVAL;
+		goto release_idr;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
-- 
2.34.1

