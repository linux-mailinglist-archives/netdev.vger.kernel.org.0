Return-Path: <netdev+bounces-3286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E153A706606
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D969281191
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E07171B0;
	Wed, 17 May 2023 11:04:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF778182A5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:00 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996E335AE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:27 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-ba841216e92so755055276.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321371; x=1686913371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqfjnIXqJfXZ89QrntS0b/0XB83XXdfHUZ3LMpbBoq0=;
        b=A/iGFnkxqZlOnFJsNunWT4kUoNk/bIArEKOHXCQUaBXOdA4XTB+cuM4UK3K0fO5j0T
         aQo/UxE5vyVUPVsXpAaeenEx9EpsIeEmiYAvRQlYc2MwLE+7dDUJhHmfs1zYWRHil+kr
         v4pZ0p69huatEBky9gW9awEgbUE+JIlowHSvhyGI4Z9rACDDsAYVTz18bDx4a7sT6bx8
         yr6SIwaK5AhHARZPAxyZNdq3L1iI2WaNxGUmJRvR8y17kX+sFTc2f7yYxHkK6G8Aw1+x
         bCKr+OIxFYzZXwUSzAxEPDC+rOnVoNADeCJ5gOmrocUy4it+f73G1W51fEzv6NmlTUw4
         ZhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321371; x=1686913371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqfjnIXqJfXZ89QrntS0b/0XB83XXdfHUZ3LMpbBoq0=;
        b=D5Rhg5vvjhzrUw4qb7Z91P9TKtviyZqyI6PIDSPhrKy6SMIjGUfpL2RvUCWiBEcsaO
         KSz4AxsHuSnc1GYPVLwO7i4XQ5u+o8kE5rlkaP7J2Iu/UDnqudRQrUJzka1e66hGPx6G
         pkIp8Y+Iz1Pr8s6D4rU/7e0OnQ/exkhx3V+BBj2ApHnoeuLPekxsJXjNTSpPGnh+aoRV
         LkYdJMk0QCcszYh99sR84p5naVb4yfQTCmqnRU/Tz5ulZ305NybJKrp1CpcD8VXObuqO
         MxMgWL5vYzIwewTaK2yEGSnUL4/nccgKMqaRoUIBrfyndG/zeFBuCJE9IoKkHAFfKwSd
         DJuA==
X-Gm-Message-State: AC+VfDwJdKYmhN5M83fFPU2BfnzEgQSNlMJFudMaCiObcZ+iTVuvh773
	SLl+ATrzoDGqqobQa5xAovltVRyAFqP/A2mupQI=
X-Google-Smtp-Source: ACHHUZ69Gq93TzaVnb4+uk6mlV82eiT8WtWZ63J3h/v11udtAMe843E8EqAnSMGR9tuzQmH/OtQlFA==
X-Received: by 2002:a25:21d7:0:b0:ba6:f4fd:181a with SMTP id h206-20020a2521d7000000b00ba6f4fd181amr14454692ybh.42.1684321370911;
        Wed, 17 May 2023 04:02:50 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id w13-20020a05620a128d00b0075785052e97sm519882qki.95.2023.05.17.04.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:49 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 03/28] net/sched: act_api: increase TCA_ID_MAX
Date: Wed, 17 May 2023 07:02:07 -0400
Message-Id: <20230517110232.29349-3-jhs@mojatatu.com>
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

Increase TCA_ID_MAX from 255 to 1023

Given P4TC dynamic actions required new IDs (dynamically) and 30 of those are
already taken by the standard actions (such as gact, mirred and ife) we are left
with 225 actions to create, which seems like a small number.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Suggested-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/uapi/linux/pkt_cls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 5b66df3ec332..337411949ad0 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -140,9 +140,9 @@ enum tca_id {
 	TCA_ID_MPLS,
 	TCA_ID_CT,
 	TCA_ID_GATE,
-	TCA_ID_DYN,
+	TCA_ID_DYN = 256,
 	/* other actions go here */
-	__TCA_ID_MAX = 255
+	__TCA_ID_MAX = 1023
 };
 
 #define TCA_ID_MAX __TCA_ID_MAX
-- 
2.25.1


