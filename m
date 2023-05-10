Return-Path: <netdev+bounces-1521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E42A6FE176
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C79D12814D9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378361641C;
	Wed, 10 May 2023 15:20:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A512B6F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:20:47 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5415026A2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:20:46 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6439b410679so4724964b3a.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683732045; x=1686324045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lgBgzOTPv9o7HyXcIQBoVEv7kUv/2WR4ggHsA/YTbXQ=;
        b=ju8nBd1M+wry7goQd4vnMl2bz8e3MjbL85UUlCTbJ0ShDpAdabAdWJlLJledss1+KM
         FtXeWs84fbaLDsW9qmX3bJeSnsDZdB/nvkIg8Jd4tUjpZMMQIXYHaXIArlpFkZobjLlz
         N71D2bXDUNSAMnK4HvpQTwCuxcWFwDVhTDkcBOyh3+OZ0Ngjb/e0NH331nWA234/H6hs
         yEBpVmHCBXNxOvZTpY4/iJEuds5C+GeE2jJpncNxIJjERN+B/ZkubhWFomDkfVKokVhz
         zfG9AzKFySaq91kyzTkVcoXsnOaQI2guY+yLyJqePXq4Sefh3qAQcoc/Pyc96nuXto1L
         ncTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683732045; x=1686324045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgBgzOTPv9o7HyXcIQBoVEv7kUv/2WR4ggHsA/YTbXQ=;
        b=Lk6SS167wkHzaMe9pf8msc7GXCygxQJTKc4Gy+m9SJb5/9e2I3Np+AN+0NmffghzRs
         VlP5z3WfT77OPnj38PvKRP+4KYUHtS6rBGDRMfjmJHsNQg4tcShTi1mWoqlYmV98mOff
         +kOJB4JxrTZ5/4WefgjH/bKGQSbgGftr/dCihaE6i3P6pJNmd7yYSD0gztZT8aZOdWau
         33ey8sbf1hMSE7Ngr+4LPda6S/jS23kECenlaqsKZBeFThGLqXa5G1hhmoukIHSDrlR7
         Zxg8E4gljVA0vF0Ip7cQMuZ9S6M3nfKBB3Ms+GvPnKtc90rQ8idBsIAkTd2aghJObpKY
         gMhw==
X-Gm-Message-State: AC+VfDxi7/d1Gml8Px2lfS4nU8TRI0C3mTzH2e5RAlVF7xcQvwHISN0i
	JyZDjWRNYL3HER1FzbYd/wJge5k+vutcvkH6QwctmA==
X-Google-Smtp-Source: ACHHUZ4ru6QNUCLqkUoZvD4gZHtXaol/jDOf8/o1PQc2/Mjx2K0K7NaiQ3Yei6NIfb6xdWtbbmfvbA==
X-Received: by 2002:a05:6a00:ace:b0:63b:89a2:d624 with SMTP id c14-20020a056a000ace00b0063b89a2d624mr23810519pfl.12.1683732045485;
        Wed, 10 May 2023 08:20:45 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p38-20020a631e66000000b0052c766b2f52sm3368663pgm.4.2023.05.10.08.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 08:20:44 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] remove unnecessary checks for NULL before calling free()
Date: Wed, 10 May 2023 08:20:42 -0700
Message-Id: <20230510152042.36586-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The function free() handles the case wher argument is NULL
by doing nothing. So the extra checks are not needed.

Found by modified version of kernel coccinelle script.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipnexthop.c | 9 +++------
 lib/utils.c    | 3 +--
 tc/m_ipt.c     | 3 +--
 tc/m_xt.c      | 3 +--
 tc/m_xt_old.c  | 3 +--
 tc/tc_qdisc.c  | 3 +--
 6 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9f16b8097b40..894f2a126f40 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -345,10 +345,8 @@ static void print_nh_res_bucket(FILE *fp, const struct rtattr *res_bucket_attr)
 
 static void ipnh_destroy_entry(struct nh_entry *nhe)
 {
-	if (nhe->nh_encap)
-		free(nhe->nh_encap);
-	if (nhe->nh_groups)
-		free(nhe->nh_groups);
+	free(nhe->nh_encap);
+	free(nhe->nh_groups);
 }
 
 /* parse nhmsg into nexthop entry struct which must be destroyed by
@@ -586,8 +584,7 @@ static struct nh_entry *ipnh_cache_add(__u32 nh_id)
 	ipnh_cache_link_entry(nhe);
 
 out:
-	if (answer)
-		free(answer);
+	free(answer);
 
 	return nhe;
 
diff --git a/lib/utils.c b/lib/utils.c
index b740531ab6c9..8dc302bdfe02 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1707,8 +1707,7 @@ int do_batch(const char *name, bool force,
 		}
 	}
 
-	if (line)
-		free(line);
+	free(line);
 
 	return ret;
 }
diff --git a/tc/m_ipt.c b/tc/m_ipt.c
index 465d1b8073d0..3fe70faf2ec6 100644
--- a/tc/m_ipt.c
+++ b/tc/m_ipt.c
@@ -412,8 +412,7 @@ static int parse_ipt(struct action_util *a, int *argc_p,
         m->tflags = 0;
         m->used = 0;
 	/* Free allocated memory */
-	if (m->t)
-	    free(m->t);
+	free(m->t);
 
 
 	return 0;
diff --git a/tc/m_xt.c b/tc/m_xt.c
index 8a6fd3ce0ffc..658084378124 100644
--- a/tc/m_xt.c
+++ b/tc/m_xt.c
@@ -299,8 +299,7 @@ static int parse_ipt(struct action_util *a, int *argc_p,
 		m->tflags = 0;
 		m->used = 0;
 		/* Free allocated memory */
-		if (m->t)
-			free(m->t);
+		free(m->t);
 	}
 
 	return 0;
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c
index efa084c5441b..7c6b79b99af5 100644
--- a/tc/m_xt_old.c
+++ b/tc/m_xt_old.c
@@ -337,8 +337,7 @@ static int parse_ipt(struct action_util *a, int *argc_p,
         m->tflags = 0;
         m->used = 0;
 	/* Free allocated memory */
-	if (m->t)
-	    free(m->t);
+	free(m->t);
 
 
 	return 0;
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 92ceb4c2f980..129ad9d96f8d 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -187,8 +187,7 @@ static int tc_qdisc_modify(int cmd, unsigned int flags, int argc, char **argv)
 			addattr_l(&req.n, sizeof(req), TCA_STAB_DATA, stab.data,
 				  stab.szopts.tsize * sizeof(__u16));
 		addattr_nest_end(&req.n, tail);
-		if (stab.data)
-			free(stab.data);
+		free(stab.data);
 	}
 
 	if (d[0])  {
-- 
2.39.2


