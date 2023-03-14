Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20876BA0A8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjCNUZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjCNUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:25:04 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30412CC6B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:00 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-17683b570b8so18645769fac.13
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678825500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YVnzgg+Ck3vhoAoX3omT52Cmi1qLSD9CMfKQsgHwFE=;
        b=zLHlo4ExPsQsq7+3aUtR1Q66/zf1an4cUglvxIuvBcdjEcWTYJP+RDqKJhr/Ah3iep
         XRdBBkXfFtLitPU91YCqjWr3uaNzBbEJuEstlt+eT8U4dU5fHdZuT47M1BiVo7b8lsUP
         mxiPNRTrBWCkZmm2V4XRhCaghEfqqYzo1RAdJmT6sEQjRjclssDigR09gLKMPhko8xr7
         2btfPpwKxPW+s7CuStgVwPx+sxM3EieW9loMRSdKUp0AHwwCjyavWYAEpiEdguJvyKZo
         VVGZ2FYsmtKpZM+WVbqiV6KfuRzW/Go6Zxh/lOn/YY2fQd58myntqHMcESeS6MRH9H+D
         Ncsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1YVnzgg+Ck3vhoAoX3omT52Cmi1qLSD9CMfKQsgHwFE=;
        b=bPurD3KB5+qEKHaI7S7TFS18JCAPBQT0kaqr7dPg/uIvHhE18ZK49ejjj0j3ATpnDh
         A3acTGjqyhTHmO22dtAQ1UEPrcl1XAdW53uER9Wxo3mGXIkSb32vyX4X0UaoCziYwEvJ
         Lqsqe6pLtniwnZQBxAEfWRGfZQKEfgsElJFXRPRHLNgtukF2rrMiohlDXTX2JWxrs8Xi
         rFBs8K4tBAIDa/UiJaKgc5K1vblEPXbmlACyZpHKunIKIf97TV2Gd+5lCo68reW1HgQd
         gXPUoFrhizA1cl8BQdwdLaJCjuUy0h2YVDCRA6qUnULoi+zawSwuFXHWdjqGN1MJVklb
         1r/Q==
X-Gm-Message-State: AO0yUKUwEEmXhcvvkKPMVYQYVlqWj7TjJf+vq/5PO1n90Ksb5G/HXcql
        TzLKmerOOjpaO/aJBaZqrwHHH5ax2TmKHAF+N6g=
X-Google-Smtp-Source: AK7set9ewwjv6nDcCRxvwnD6lt7A1Vax1+2WS9seyXdHj78lss1QsTm/C6SGRD8s9zxaphKmVlWACQ==
X-Received: by 2002:a05:6870:9107:b0:176:3f58:4a06 with SMTP id o7-20020a056870910700b001763f584a06mr25558828oae.40.1678825499904;
        Tue, 14 Mar 2023 13:24:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id 103-20020a9d0870000000b00690e783b729sm1509278oty.52.2023.03.14.13.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:24:59 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 1/4] net/sched: act_pedit: use extack in 'ex' parsing errors
Date:   Tue, 14 Mar 2023 17:24:45 -0300
Message-Id: <20230314202448.603841-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314202448.603841-1-pctammela@mojatatu.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
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
 net/sched/act_pedit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 4559a1507ea5..be9e7e565551 100644
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
@@ -56,25 +56,25 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
 
 		if (!n) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
 			goto err_out;
 		}
+
 		n--;
 
 		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
 			goto err_out;
 		}
 
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
 
@@ -83,7 +83,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 
 		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
 		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit key is malformed");
 			goto err_out;
 		}
 
@@ -91,7 +91,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 	}
 
 	if (n) {
-		err = -EINVAL;
+		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
 		goto err_out;
 	}
 
@@ -99,7 +99,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 
 err_out:
 	kfree(keys_ex);
-	return ERR_PTR(err);
+	return ERR_PTR(-EINVAL);
 }
 
 static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
@@ -222,7 +222,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
 	if (IS_ERR(nparms->tcfp_keys_ex)) {
 		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
-- 
2.34.1

