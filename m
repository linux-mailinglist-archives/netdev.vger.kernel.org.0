Return-Path: <netdev+bounces-3285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08676706604
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B774A28156B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405E1171BE;
	Wed, 17 May 2023 11:03:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A0C171B0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:03:58 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC2D3C32
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:23 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-7577ef2fa31so631732585a.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321363; x=1686913363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOsAgtFnUv40z8ltHKypmFjRPulCrmNdD97YCaR01n0=;
        b=nUIqHJgkagnqJRjNbgVDcZUEwRfOGGCNGMRQNOpAMnxViQcfMFbYC2DbU6vhM+PuoO
         rekxJ427eEpPQ2ghHZ/+lVCNK6Sm8GexXjKGXA8E0zvgCEziUdhmvOtT637YTqyPiahx
         I67g8XE1d4Ve1q3Gm0mTw61eK9BUt48qQNm5+sRjnCjJR5L5iKoiJQcnxInERbSkKSz/
         As+vjRJtFks9E0hT/a7ILSR+yDKXhGwQjrbNnfyGf/Xrq7iMPuQsqwWkV/LV1J7hT/0s
         ot/pUTkD9jkMRvRD3RP1viWaXIqcKgypxU8lsJi1OYe45EXfEGjhlBejslCwPn/SRkIX
         mzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321363; x=1686913363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOsAgtFnUv40z8ltHKypmFjRPulCrmNdD97YCaR01n0=;
        b=UyTTwwYPYDg9mNRjn+WNdCV1A8kd1HkHH+/4iZAgzV+poqq+Rjs1sSPiTRlXQVOO9U
         jZuWz/ic1bpHCZ+qU8wFIPYQF1IN7/fOZNZ2zHAKU9ImuAaydkkn93+ZVcY5fz6MJZUT
         Biuvrz3VSCL2N+7NH4T6QAK8ZJOqsgcFM12kEE0TyBE6ASA+4BW2vSp/iP6JWgIT5ofT
         QbdtHZcDiuynEf1lfZf5sYpjM+hbYJvLqG/N9VINMQ6B6uG5Zd4rpp9q+xhdZ/9giPQo
         M0hOF82BI85Kl5Uo0kIM96MWSrw7Fhtn4N2PEpqwpqvGDRJREE757Ei4vQiAqhbH5ht4
         1QCw==
X-Gm-Message-State: AC+VfDwkgx7tlttgKe1VFEEV8gjYiWaPAWWufDvsoGvVvRcZqw5UwdT4
	2ASbYDdAug8zr4ISM/z0wbTRsIDv5vc88WBdECQ=
X-Google-Smtp-Source: ACHHUZ6RCABbHP32O4GsEBCdS4yqn45CWc+ewF0fgEDfRYMRf2uwVyZIMlgO1ZKRFBJy1a0m/lAjdQ==
X-Received: by 2002:a05:622a:1997:b0:3f4:d3a7:9827 with SMTP id u23-20020a05622a199700b003f4d3a79827mr2537390qtc.25.1684321362995;
        Wed, 17 May 2023 04:02:42 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id p11-20020ae9f30b000000b0074df8eefe2dsm520109qkg.98.2023.05.17.04.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:42 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 02/28] net/sched: act_api: increase action kind string length
Date: Wed, 17 May 2023 07:02:06 -0400
Message-Id: <20230517110232.29349-2-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Increase action kind string length from IFNAMSIZ to 64

The new P4TC dynamic actions, created via templates, will have longer names
of format: "pipeline_name/act_name". IFNAMSIZ is currently 16 and is most
of the times undersized for the above format.
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
index 54754deed15e..a414c0f94ff1 100644
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
index 4d716841ca05..5b66df3ec332 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -6,6 +6,7 @@
 #include <linux/pkt_sched.h>
 
 #define TC_COOKIE_MAX_SIZE 16
+#define ACTNAMSIZ 64
 
 /* Action attributes */
 enum {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 3cd686d0094e..bc4e178873e4 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -479,7 +479,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 	rcu_read_unlock();
 
 	return  nla_total_size(0) /* action number nested */
-		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
+		+ nla_total_size(ACTNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
 		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_HW_STATS */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
@@ -1403,7 +1403,7 @@ struct tc_action_ops *tc_action_load_ops(struct net *net, struct nlattr *nla,
 {
 	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct tc_action_ops *a_o;
-	char act_name[IFNAMSIZ];
+	char act_name[ACTNAMSIZ];
 	struct nlattr *kind;
 	int err;
 
@@ -1418,7 +1418,7 @@ struct tc_action_ops *tc_action_load_ops(struct net *net, struct nlattr *nla,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			return ERR_PTR(err);
 		}
-		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
+		if (nla_strscpy(act_name, kind, ACTNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
 			return ERR_PTR(err);
 		}
-- 
2.25.1


