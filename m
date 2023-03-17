Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8656BF21C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjCQUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCQUGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:09 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE044200
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:06 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id v2-20020a056830090200b0069c6952f4d3so3484072ott.7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679083565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEbNWEQ2Tzjo+v75NSlVPWQEh095dnAAZdqY3OtxuKI=;
        b=HfkclB5RVvS174IfroSPMpH4SAObSGDdNjQrTrAiHbLhcTPxKdZGzNHnDmIoo7vpAe
         UyuRwbRMLdQIw202Q4uwVDewY7iAkCrlHAzBsqwmaNh58oQ7LuStoqdjnM5lsOvVZtbk
         wA6mcx6EgVBsZO1hXxahPmRJXF27lj+9SciY7/3mZ2YAvPKW6236DV8GCn+Ugk7cohWb
         2iC9Z4aZfQGjNYgWa8Nr1xUTNfJSz94OgH4D/94Er1CXxzwPiNAx0L04tuzBfCLvS+zF
         +TqOFNYaPMd2TIF3rYClZnN01GUvf+DQOX/EDtQxgQqUCo4ZpcKrsMZ1AvWa+3JUJuTS
         00mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEbNWEQ2Tzjo+v75NSlVPWQEh095dnAAZdqY3OtxuKI=;
        b=0L8rVpqUT7Rp0qnSCPK2GdQt+d7yyWxdbsHEhj8ivXhfDxk9ntzILdNhkmlyokFevw
         omiN/9uK0gcOFBH8FGN11QFGCWLLT0ZDqXQs9IzP8jof8NKc6lAP/w2hP9kpKqW7nOaE
         SP0rlR9QbhQL35BL7xua8P2DdpN0BLmrhAaSvY3F6CirQLlvXS+hN95cP5ZKk7/EaGLV
         mk9U2fm65KGFNKqHkXvpL4uXtt3uCOlt1bPdd6df9JWyfw55k5z0xUx1yIM65SJJhtD4
         OPdE4bxkwujco88hHv5ynXyPMyLKE8lBMbKrkMbaBFDLfJuoK9ZC6Zteq7TULl3XESlR
         I9qg==
X-Gm-Message-State: AO0yUKWLd+mrsaWEwuD2FS9kubMvxzB/DY9kKMLJUWHdHbbigWEMCwrc
        yfUpqKPAbenHJgwSCbut6pAIcF9EhgeTwzonvYE=
X-Google-Smtp-Source: AK7set/iynELw4sRhOrI/YpXzihg2YXYszD0KaEY5GfNNd5uM51tReFuUItjHzhoroZw7XfLTFyb/Q==
X-Received: by 2002:a05:6830:104e:b0:694:7da5:d04e with SMTP id b14-20020a056830104e00b006947da5d04emr403876otp.19.1679083565598;
        Fri, 17 Mar 2023 13:06:05 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id z8-20020a056830128800b00698a88cfad1sm1304209otp.68.2023.03.17.13.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:06:05 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 2/4] net/sched: act_pedit: check static offsets a priori
Date:   Fri, 17 Mar 2023 16:51:33 -0300
Message-Id: <20230317195135.1142050-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317195135.1142050-1-pctammela@mojatatu.com>
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
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

Static key offsets should always be on 32 bit boundaries. Validate them on
create/update time for static offsets and move the datapath validation
for runtime offsets only.

iproute2 already errors out if a given offset and data size cannot be packed
to a 32 bit boundary. This change will make sure users which create/update pedit
instances directly via netlink also error out, instead of finding out
when packets are traversing.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index cd3cbe397e87..d780acb44d06 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -249,6 +249,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		if (cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Pedit offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -407,12 +413,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 					       sizeof(_d), &_d);
 			if (!d)
 				goto bad;
-			offset += (*d & tkey->offmask) >> tkey->shift;
-		}
 
-		if (offset % 4) {
-			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-			goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+			if (offset % 4) {
+				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				goto bad;
+			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-- 
2.34.1

