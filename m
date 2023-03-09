Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2046B2D2C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCISwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCISw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:52:29 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9BFAEF2
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:52:11 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso1606376oti.8
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 10:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678387931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Py87wm18nf6iBnrV1Xx+QX4xad9FSzmXnS6t2bxd9ZA=;
        b=GIJMb9yXmlIRwqK/4ioKUq7APtLFuk2fVD4P493ovPs05//6HxwkvwmbK4xzA21jNr
         5Myfn8tccrwwTb56n5aQsZygldjhlD5LL9HHFUUvdYYQYgMv8iP/wP4/Lp07nAndqLdU
         P1J+PG+Xn/YpVFm1acQiH6xHA5Kb/+AaxNunT33ex9RhAFQ5KCEeZOijNsh+QLT0XBau
         p2cFAGCTNJ9nbEy3fA3MKafunKluw08Wj/CkEqFI0SRXIZyMMEaH3vbKnrzwNQe4JFbp
         JXa2MxSRS12IPa/Qkeml2lwAJf8W/sru4d1zGjsQZfxTAKPTzP0GTzpFVRd0NdYi3vyn
         CQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678387931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Py87wm18nf6iBnrV1Xx+QX4xad9FSzmXnS6t2bxd9ZA=;
        b=v9jkdBtt6PrMzW31NRzODTiBYxl+IQFTzTIVLt1Z6nF5+wys66HDrngiTvIDXxwvjL
         kHzUu3VonV7qe/tdrw6GIYZEa3iFd4YVUmZbm3DnPHN8vU9UsYj1CNBt/9JGI2zj/tqC
         iFOMq0HMuPpT52CelHIKl8VslOydC5Uhl7fOnfbhb2vRqnkCAUW+Hl7Bx+/dONQ2ib4H
         d0pOLsQ1Wh0KfvjykmYMXqMaDWKoXOQUjg0CqyDd26Fz/mQ8c8LhEi5jEXZIaBS4tbXr
         Zr1T6QDM/MOhFEynqyw9InQYZEd9My6+JlJSwW9gQAeMKM0R9hxAER7fC4Dp2wHoLOac
         RXbA==
X-Gm-Message-State: AO0yUKWV7Cc/XEmDWW56MncMvV3z/JbNPjR6OJKYMLiB0ZG8wPBQ7zc5
        YERpPZi2ubMET+GrmSWvjIkQfGWFbGP3JdcKCQM=
X-Google-Smtp-Source: AK7set+n9zuxA0bIRHXQwFYsTCQ+4+tBrtEmU4fBlFEkU9Qit4vToYACpGs7Ft5H6EwvILhS8WdF+A==
X-Received: by 2002:a9d:700c:0:b0:68b:cada:6817 with SMTP id k12-20020a9d700c000000b0068bcada6817mr9311181otj.12.1678387931044;
        Thu, 09 Mar 2023 10:52:11 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:d22f:e7ce:9ab3:d054])
        by smtp.gmail.com with ESMTPSA id o25-20020a9d7199000000b0068657984c22sm63248otj.32.2023.03.09.10.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 10:52:10 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 1/3] net/sched: act_pedit: use extack in 'ex' parsing errors
Date:   Thu,  9 Mar 2023 15:51:56 -0300
Message-Id: <20230309185158.310994-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309185158.310994-1-pctammela@mojatatu.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
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

We have extack available when parsing 'ex' keys, so pass it to
tcf_pedit_keys_ex_parse and add more detailed error messages.
While at it, remove redundant code from the 'err_out' label code path.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 4559a1507ea5..f4ebe06aeaf2 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -35,7 +35,7 @@ static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
-							u8 n)
+							u8 n, struct netlink_ext_ack *extack)
 {
 	struct tcf_pedit_key_ex *keys_ex;
 	struct tcf_pedit_key_ex *k;
@@ -55,26 +55,21 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 	nla_for_each_nested(ka, nla, rem) {
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
 
-		if (!n) {
-			err = -EINVAL;
+		if (!n)
 			goto err_out;
-		}
 		n--;
 
-		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
-			err = -EINVAL;
+		if (nla_type(ka) != TCA_PEDIT_KEY_EX)
 			goto err_out;
-		}
 
-		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
-						  ka, pedit_key_ex_policy,
-						  NULL);
+		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
+						  pedit_key_ex_policy, extack);
 		if (err)
 			goto err_out;
 
 		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
 		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
 			goto err_out;
 		}
 
@@ -83,23 +78,21 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 
 		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
 		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit key is malformed");
 			goto err_out;
 		}
 
 		k++;
 	}
 
-	if (n) {
-		err = -EINVAL;
+	if (n)
 		goto err_out;
-	}
 
 	return keys_ex;
 
 err_out:
 	kfree(keys_ex);
-	return ERR_PTR(err);
+	return ERR_PTR(-EINVAL);
 }
 
 static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
@@ -222,7 +215,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
 	if (IS_ERR(nparms->tcfp_keys_ex)) {
 		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
-- 
2.34.1

