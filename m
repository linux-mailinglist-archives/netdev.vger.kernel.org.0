Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2996A499B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjB0SXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjB0SXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:23:43 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258DE11E89
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:33 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id bm20so5922123oib.7
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yHdhLpBrl0T5hmsNwUQNzk/fjlD5DMUoTBsf3O841w=;
        b=edL5dqAUkXf6tY/EuISKxsV4Vp3/7TtVe5Wd5wvl4YaVSp7o6wkbWgGxCAgWEOlLWA
         I60ZH8oaNUwn358Uan4UiMNeBQmxjRGpDGLqLwfjWMOw2Iroq5PZp50CW8fqyefYwE32
         j9qGhGyIq87P1LwvRblnQ23iAyoYU/ft0NGloVW6tSerD0ny1OH5+bOhjbUdXCcWGjJ+
         9alhvx18QXtaPnnB1rnWVCclQ9MJi8QXMX42rh6EWjgdC3tVbQ7hqFgjSERTGT5bjRDO
         2cP5aqYG0vipeoWi54SmFzDZx5bsej34zZNPcVb4MoFfRr4T7Dg9BYF0dtMIYUipB5zj
         3iAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yHdhLpBrl0T5hmsNwUQNzk/fjlD5DMUoTBsf3O841w=;
        b=XGFnpn+EjKDHNptsC8V7n/G8Vk9dNfWJ90wecG5uDpuQVmu6P7YULmKA7QRiIK1yu+
         1Re0HtI7vwSWQ0qDUCSI4i5S/OkaLbtizVU5BTXRXFt9UnhiLNDidTDpBYqJnB+fueym
         moR9ITgaAAyWco4RhD+yjtuADS/OxiOMBdu4qJuWplyJTk9n5C8EikEEh7scRJOgEVEf
         7BmCgrrPh6Nq7O7L9PNo2lVkgFyG16gvnMQ6qRTJmgF+d39lV4wDigSZMh2XLOjgKn+9
         vGS3viireAtkVI7XBnSsuYeREnR9wsxU98HG1Q9EhZlPuUXU7nREzwbR75j6j9oQrjDl
         W8jQ==
X-Gm-Message-State: AO0yUKUU1OGR3Pomz6TltvbfiXCTxkfm/onBvQChygV0A5z4sLetKFkM
        R7ws96yzOCaIV5e1i4uF02UgGiAUxg5PBXLC
X-Google-Smtp-Source: AK7set+IzmGFXV6DaiGt2QEr8j9nsP5VMxLD5gDVyhmjN+Y/LJjZRYAdCSbthsgZQ5kAxJ3tBRux5w==
X-Received: by 2002:aca:190a:0:b0:37f:acd5:20fb with SMTP id l10-20020aca190a000000b0037facd520fbmr28030oii.35.1677522212276;
        Mon, 27 Feb 2023 10:23:32 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:4174:ef7a:c9ab:ab62])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b0037d59e90a07sm3403381oil.55.2023.02.27.10.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:23:31 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, amir@vadai.me, dcaratti@redhat.com,
        willemb@google.com, ozsh@nvidia.com, paulb@nvidia.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net v2 1/3] net/sched: act_pedit: fix action bind logic
Date:   Mon, 27 Feb 2023 15:22:55 -0300
Message-Id: <20230227182256.275816-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227182256.275816-1-pctammela@mojatatu.com>
References: <20230227182256.275816-1-pctammela@mojatatu.com>
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
tc action add action pedit ... index 1
tc filter add ... action pedit index 1

In the current code for act_pedit this is broken as it checks netlink
attributes for create/update before actually checking if we are binding to an
existing action.

tdc results:
1..69
ok 1 319a - Add pedit action that mangles IP TTL
ok 2 7e67 - Replace pedit action with invalid goto chain
ok 3 377e - Add pedit action with RAW_OP offset u32
ok 4 a0ca - Add pedit action with RAW_OP offset u32 (INVALID)
ok 5 dd8a - Add pedit action with RAW_OP offset u16 u16
ok 6 53db - Add pedit action with RAW_OP offset u16 (INVALID)
ok 7 5c7e - Add pedit action with RAW_OP offset u8 add value
ok 8 2893 - Add pedit action with RAW_OP offset u8 quad
ok 9 3a07 - Add pedit action with RAW_OP offset u8-u16-u8
ok 10 ab0f - Add pedit action with RAW_OP offset u16-u8-u8
ok 11 9d12 - Add pedit action with RAW_OP offset u32 set u16 clear u8 invert
ok 12 ebfa - Add pedit action with RAW_OP offset overflow u32 (INVALID)
ok 13 f512 - Add pedit action with RAW_OP offset u16 at offmask shift set
ok 14 c2cb - Add pedit action with RAW_OP offset u32 retain value
ok 15 1762 - Add pedit action with RAW_OP offset u8 clear value
ok 16 bcee - Add pedit action with RAW_OP offset u8 retain value
ok 17 e89f - Add pedit action with RAW_OP offset u16 retain value
ok 18 c282 - Add pedit action with RAW_OP offset u32 clear value
ok 19 c422 - Add pedit action with RAW_OP offset u16 invert value
ok 20 d3d3 - Add pedit action with RAW_OP offset u32 invert value
ok 21 57e5 - Add pedit action with RAW_OP offset u8 preserve value
ok 22 99e0 - Add pedit action with RAW_OP offset u16 preserve value
ok 23 1892 - Add pedit action with RAW_OP offset u32 preserve value
ok 24 4b60 - Add pedit action with RAW_OP negative offset u16/u32 set value
ok 25 a5a7 - Add pedit action with LAYERED_OP eth set src
ok 26 86d4 - Add pedit action with LAYERED_OP eth set src & dst
ok 27 f8a9 - Add pedit action with LAYERED_OP eth set dst
ok 28 c715 - Add pedit action with LAYERED_OP eth set src (INVALID)
ok 29 8131 - Add pedit action with LAYERED_OP eth set dst (INVALID)
ok 30 ba22 - Add pedit action with LAYERED_OP eth type set/clear sequence
ok 31 dec4 - Add pedit action with LAYERED_OP eth set type (INVALID)
ok 32 ab06 - Add pedit action with LAYERED_OP eth add type
ok 33 918d - Add pedit action with LAYERED_OP eth invert src
ok 34 a8d4 - Add pedit action with LAYERED_OP eth invert dst
ok 35 ee13 - Add pedit action with LAYERED_OP eth invert type
ok 36 7588 - Add pedit action with LAYERED_OP ip set src
ok 37 0fa7 - Add pedit action with LAYERED_OP ip set dst
ok 38 5810 - Add pedit action with LAYERED_OP ip set src & dst
ok 39 1092 - Add pedit action with LAYERED_OP ip set ihl & dsfield
ok 40 02d8 - Add pedit action with LAYERED_OP ip set ttl & protocol
ok 41 3e2d - Add pedit action with LAYERED_OP ip set ttl (INVALID)
ok 42 31ae - Add pedit action with LAYERED_OP ip ttl clear/set
ok 43 486f - Add pedit action with LAYERED_OP ip set duplicate fields
ok 44 e790 - Add pedit action with LAYERED_OP ip set ce, df, mf, firstfrag, nofrag fields
ok 45 cc8a - Add pedit action with LAYERED_OP ip set tos
ok 46 7a17 - Add pedit action with LAYERED_OP ip set precedence
ok 47 c3b6 - Add pedit action with LAYERED_OP ip add tos
ok 48 43d3 - Add pedit action with LAYERED_OP ip add precedence
ok 49 438e - Add pedit action with LAYERED_OP ip clear tos
ok 50 6b1b - Add pedit action with LAYERED_OP ip clear precedence
ok 51 824a - Add pedit action with LAYERED_OP ip invert tos
ok 52 106f - Add pedit action with LAYERED_OP ip invert precedence
ok 53 6829 - Add pedit action with LAYERED_OP beyond ip set dport & sport
ok 54 afd8 - Add pedit action with LAYERED_OP beyond ip set icmp_type & icmp_code
ok 55 3143 - Add pedit action with LAYERED_OP beyond ip set dport (INVALID)
ok 56 815c - Add pedit action with LAYERED_OP ip6 set src
ok 57 4dae - Add pedit action with LAYERED_OP ip6 set dst
ok 58 fc1f - Add pedit action with LAYERED_OP ip6 set src & dst
ok 59 6d34 - Add pedit action with LAYERED_OP ip6 dst retain value (INVALID)
ok 60 94bb - Add pedit action with LAYERED_OP ip6 traffic_class
ok 61 6f5e - Add pedit action with LAYERED_OP ip6 flow_lbl
ok 62 6795 - Add pedit action with LAYERED_OP ip6 set payload_len, nexthdr, hoplimit
ok 63 1442 - Add pedit action with LAYERED_OP tcp set dport & sport
ok 64 b7ac - Add pedit action with LAYERED_OP tcp sport set (INVALID)
ok 65 cfcc - Add pedit action with LAYERED_OP tcp flags set
ok 66 3bc4 - Add pedit action with LAYERED_OP tcp set dport, sport & flags fields
ok 67 f1c8 - Add pedit action with LAYERED_OP udp set dport & sport
ok 68 d784 - Add pedit action with mixed RAW/LAYERED_OP #1
ok 69 70ca - Add pedit action with mixed RAW/LAYERED_OP #2

Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
Fixes: f67169fef8db ("net/sched: act_pedit: fix WARN() in the traffic path")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 58 +++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 77d288d384ae..4559a1507ea5 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -181,26 +181,6 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(pattr);
-	if (!parm->nkeys) {
-		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
-		return -EINVAL;
-	}
-	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
-	if (nla_len(pattr) < sizeof(*parm) + ksize) {
-		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
-		return -EINVAL;
-	}
-
-	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
-	if (!nparms)
-		return -ENOMEM;
-
-	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
-	if (IS_ERR(nparms->tcfp_keys_ex)) {
-		ret = PTR_ERR(nparms->tcfp_keys_ex);
-		goto out_free;
-	}
 
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
@@ -209,25 +189,49 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 						&act_pedit_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			goto out_free_ex;
+			return ret;
 		}
 		ret = ACT_P_CREATED;
 	} else if (err > 0) {
 		if (bind)
-			goto out_free;
+			return 0;
 		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
 			ret = -EEXIST;
 			goto out_release;
 		}
 	} else {
-		ret = err;
-		goto out_free_ex;
+		return err;
+	}
+
+	if (!parm->nkeys) {
+		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
+		ret = -EINVAL;
+		goto out_release;
+	}
+	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
+	if (nla_len(pattr) < sizeof(*parm) + ksize) {
+		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
+		ret = -EINVAL;
+		goto out_release;
+	}
+
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
+	nparms->tcfp_keys_ex =
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+	if (IS_ERR(nparms->tcfp_keys_ex)) {
+		ret = PTR_ERR(nparms->tcfp_keys_ex);
+		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0) {
 		ret = err;
-		goto out_release;
+		goto out_free_ex;
 	}
 
 	nparms->tcfp_off_max_hint = 0;
@@ -278,12 +282,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 put_chain:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
-out_release:
-	tcf_idr_release(*a, bind);
 out_free_ex:
 	kfree(nparms->tcfp_keys_ex);
 out_free:
 	kfree(nparms);
+out_release:
+	tcf_idr_release(*a, bind);
 	return ret;
 }
 
-- 
2.34.1

