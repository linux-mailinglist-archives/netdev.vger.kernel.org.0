Return-Path: <netdev+bounces-3292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFDD706622
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 792361C20ED8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C791EA97;
	Wed, 17 May 2023 11:04:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A984168D8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:15 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F5D5FE6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:45 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-62382464ca3so2708616d6.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321406; x=1686913406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xk52L0V25AupBGI2GjyEtBqD739kGIecliMY3ZyLU6I=;
        b=Afin7OhygdT8qU2n7X43OTh8CWyAsm6mbCmI9Rg56444oMswOa7xA+sQpnhdBYnXme
         X0KMVWwUu/sB5+k1LHx0RuznaQVay/XesCXZgmswXzN6NNFU8Ia0ESxuo58NqBzf5GMH
         5BA6E74x5M7QpbGfXtSnuydTcOFsULtew6CokPmcTjrOLihuR5pBWJjlnUOu/3Z+O5Nz
         W7G3nM7flBkJxiKm+wzNk2E4v0k2B7J2/E+9dQsvMztZA688NBMwFqSRKaXzLJSxv4/8
         LkuIDcoJNXmvwwu9R+5Sg1UIFborvANlmJuL7nd4xF6H1zQ0sMx33xIniRlx1qTVMvFi
         zlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321406; x=1686913406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xk52L0V25AupBGI2GjyEtBqD739kGIecliMY3ZyLU6I=;
        b=TRm05l0dm7IRsw3MscTDOgK/liLoVAfPHHm7fYsl12p/bIn8PcLSPSHSeKkq91mGE3
         pIS9h4UqkyN19qe6ArTLfMuEqT48L4kcc0MpMVIlUMW5nstW91osNMgziMf2hfytkHet
         /epo3eSmYG4LeJ4/In8PQ+2K15+MpsXVS4PQrYVam0PtDMvqxXZ0SEeH1fcAW5lfCEMw
         ere84/EQ0LuKBJf0lJ/LMbdzM6dIk8IENPcfXqGKthZsZh7ZdmEgH3hgf2D9o+txegt0
         pH0wm9D3RVWlIGXOfd81Voj+k8BDSCv9g0kbhaIhH2cezdUZ3MwDo20WV5g1qE4XglHU
         ohLg==
X-Gm-Message-State: AC+VfDyUeOd30GBQAbwR69bM6yZzc+Ocb1UiVtDmt3D355Z7lTDQrios
	vjKw/NzpXsb2LDD8GVg3NMw8gJ1cPcT2jI5bgLQ=
X-Google-Smtp-Source: ACHHUZ55ygTMQAJq6MidV3oNZ6NGtFmO/znKxxXeQ/dmz9q26WsAqVqZJ4lN6XsPbB+fb2RmnTHklg==
X-Received: by 2002:a05:6214:c6b:b0:623:66ee:79b2 with SMTP id t11-20020a0562140c6b00b0062366ee79b2mr15388432qvj.36.1684321406342;
        Wed, 17 May 2023 04:03:26 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id i11-20020a0cfd2b000000b0061b73e331b2sm6323913qvs.30.2023.05.17.04.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:25 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 08/28] net: introduce rcu_replace_pointer_rtnl
Date: Wed, 17 May 2023 07:02:12 -0400
Message-Id: <20230517110232.29349-8-jhs@mojatatu.com>
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

We use rcu_replace_pointer(rcu_ptr, ptr, lockdep_rtnl_is_held()) throughout the
P4TC infrastructure code.

It may be useful for other use cases, so we create a helper.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/linux/rtnetlink.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 3d6cf306cd55..971055e6633f 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -62,6 +62,18 @@ static inline bool lockdep_rtnl_is_held(void)
 #define rcu_dereference_rtnl(p)					\
 	rcu_dereference_check(p, lockdep_rtnl_is_held())
 
+/**
+ * rcu_replace_pointer_rtnl - replace an RCU pointer under rtnl_lock, returning
+ * its old value
+ * @rcu_ptr: RCU pointer, whose old value is returned
+ * @ptr: regular pointer
+ *
+ * Perform a replacement under rtnl_lock, where @rcu_ptr is an RCU-annotated
+ * pointer. The old value of @rcu_ptr is returned, and @rcu_ptr is set to @ptr
+ */
+#define rcu_replace_pointer_rtnl(rcu_ptr, ptr)			\
+	rcu_replace_pointer(rcu_ptr, ptr, lockdep_rtnl_is_held())
+
 /**
  * rtnl_dereference - fetch RCU pointer when updates are prevented by RTNL
  * @p: The pointer to read, prior to dereferencing
-- 
2.25.1


