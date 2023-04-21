Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718A26EB396
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjDUVZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbjDUVZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:25:44 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF6E268C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:43 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-187b07ad783so1930690fac.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112342; x=1684704342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wD0C59tjjQYSLcmnLy7kgMbbGEO1G+xvyANyqxWFHHQ=;
        b=tm5XzlacpLJIj+t6zOGcTXUigZkc/DaIwN+F2nOKMPEEF+3rnhuhGStSZFp0HqVwFr
         0iXenzolGrgEZzsRyCdXDKR9qwjwmCMM0WGzFZpskfWKSZAdHHACMVFBi2SnAj9y4Grl
         v/D4rDNDe9FfWQ7adc2FL7QggKd8mrBSuTgCA9Y6DQszFYWxC3aySSlyWfjZg5cbS8OD
         smeDb5q82jX9TnTX7xqrwo/tCC34ImmjGnXq9cl5Clfr5mr23JkEowTyR3HYzqgcsQ/5
         2uiubFub9VT8SyhrQ0Ecz1BFgAw/lGUpl8GAGeFuwuDFELjUAB+n9G8CkrL5VsyLAL+J
         mC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112342; x=1684704342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wD0C59tjjQYSLcmnLy7kgMbbGEO1G+xvyANyqxWFHHQ=;
        b=HqjCraj0zWhmj4bMJyUfjYJ7UDzIs1kBkIIzi/XsRoX/T3u/vgXeTBSiT949bOdlPC
         1mo3YeFL7EeQ/AEV2SsNF2fwzN15mkKHs0je3N0tFnFVTHBacj4aduyVj8wK/BAPz1JX
         iDjHcX/xOi4Sf5uB0YbM+IUqynoUY3bZ3nOILus+0gsdqa5bm3TUeHEJ6Tj8Oaw8czHU
         n93gv7n2bP+etuN+8B4U8VJjdgXp9ddJDPH0InnIafaJgVr/qbAEp0MYqcLMnrF9I2Bt
         95XqhuxKCWI/0E5O1RmtY/mFakU8WWLzqiJQC8mi3dm07tZDcDVq8AfBTF9vQqFTqBH7
         Vuzw==
X-Gm-Message-State: AAQBX9fiHh5gMwHSudglzAjoC0+eRSnbxptAowiWTReGULy+oyvQafeX
        BbR5RGmGWWDTr/+RJo1bygz5ZUdxVXUlsNSB/xo=
X-Google-Smtp-Source: AKy350bdici1UCF5XZSJ2su+e1vktmxyywMncmlDcI+LyAlFb9PXLJ2xUGWNSf3EswWCFwNdT3cWCg==
X-Received: by 2002:a05:6870:2424:b0:187:83c8:5f0b with SMTP id n36-20020a056870242400b0018783c85f0bmr3563160oap.58.1682112342236;
        Fri, 21 Apr 2023 14:25:42 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:42 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 1/5] net/sched: act_pedit: use NLA_POLICY for parsing 'ex' keys
Date:   Fri, 21 Apr 2023 18:25:13 -0300
Message-Id: <20230421212516.406726-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transform two checks in the 'ex' key parsing into netlink policies
removing extra if checks.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 4559a1507ea5..45201f75e896 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -30,8 +30,9 @@ static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 };
 
 static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
-	[TCA_PEDIT_KEY_EX_HTYPE]  = { .type = NLA_U16 },
-	[TCA_PEDIT_KEY_EX_CMD]	  = { .type = NLA_U16 },
+	[TCA_PEDIT_KEY_EX_HTYPE] =
+		NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_HDR_TYPE_MAX),
+	[TCA_PEDIT_KEY_EX_CMD] = NLA_POLICY_MAX(NLA_U16, TCA_PEDIT_CMD_MAX),
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
@@ -81,12 +82,6 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
 		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
 
-		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
-		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
-			goto err_out;
-		}
-
 		k++;
 	}
 
-- 
2.34.1

