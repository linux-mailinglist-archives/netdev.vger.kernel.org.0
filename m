Return-Path: <netdev+bounces-7138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3126A71A3B0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D2A32817E7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C8140787;
	Thu,  1 Jun 2023 16:04:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE54DBA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:04:55 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD91C0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:04:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5692be06cb2so8924877b3.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685635490; x=1688227490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q93PMvw5Uyhh1MjxLoMV/LIN5l2onW/v7vIN0vplACE=;
        b=TJtSMxddEZv8Xe2HrA1PJ3w0zx9vtj2j+0mMJsNfWP27se4937s6zLAJfXYpojsEOS
         mZNdVcjTgYVRpfUrZ1xeP+b0Klxz/v/i7ymhga12XDS2tCn1pUrzLS7xtC0KrLuHF4/J
         sDlZYGMSNrNDDtJSGPgeGngB+tMwVbMOD0+91bl4BVMYgo4pGl5588wTG3j9mId3z+ve
         WQVXQsvm0zNh6kS3/v4aWwatud+nrv9rSlzdOp0f2iDJ6sgKuFDkmjV2Tg4O10uRyn6v
         8nL3QgqDPR9zToJfhymwzQJzzqxBS4YoydWlRHRREb78SxfFvJIaq5r9ms68WEXYuCoi
         gSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685635490; x=1688227490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q93PMvw5Uyhh1MjxLoMV/LIN5l2onW/v7vIN0vplACE=;
        b=MqAuObPW/v51bs3R77D6ahLFloKy8AzrnwoiLYe2K4ynsWYd/+9EaAyR60AK5IKpRO
         Y8SSy9mIJhoxHOS7utBHKV/cs2G2nCOW879CT4p64SB2A+8Wj2G2zGp/12kqBW3ffjXP
         KRESU/wkxSNHu2x9FbU7cGGx0Vf7kMllEOGcthw3N3UZnODceGTl51OThB66oW7X7QTj
         lI4V4Br4Zj1IjclRqFnrN1lo4hFYLacqaq4W4OMJt/nYuyBuOp82V0u/Mqs1COERAajK
         PZzC2s72DgpTZWSW7r4buw+y7Hg4t6L0FCuZLWFVk0IwvZ9fVqRGR6nNX+PQnv1QPJIq
         CMqQ==
X-Gm-Message-State: AC+VfDx4n99GuWohBOE9BuDjZQyUsy7zskpk3WXWDE6Pot9gXffeXNvT
	+2gtA04sqdjIV488WUt33xbrxq97NvEaHg==
X-Google-Smtp-Source: ACHHUZ6gv0V6/dsFUgOiOs9cr1eMx2IAhfMNcW0JlmPfehnLfXbBOWG9eR0ste7ZCGys4py+fKRWzT6OkS4Seg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:b650:0:b0:565:a42c:79fe with SMTP id
 h16-20020a81b650000000b00565a42c79femr5511284ywk.1.1685635490384; Thu, 01 Jun
 2023 09:04:50 -0700 (PDT)
Date: Thu,  1 Jun 2023 16:04:45 +0000
In-Reply-To: <20230601160445.1480257-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230601160445.1480257-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601160445.1480257-3-edumazet@google.com>
Subject: [PATCH net 2/2] net/ipv6: convert skip_notify_on_dev_down sysctl to u8
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Save a bit a space, and could help future sysctls to
use the same pattern.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/netns/ipv6.h | 2 +-
 net/ipv6/route.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index d44b2ee49698fa17bef0c54df8c960ec5addcbd0..5f2cfd84570aea8dd225208d36065b47b27b6b10 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -53,7 +53,7 @@ struct netns_sysctl_ipv6 {
 	int seg6_flowlabel;
 	u32 ioam6_id;
 	u64 ioam6_id_wide;
-	int skip_notify_on_dev_down;
+	u8 skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
 	u8 icmpv6_error_anycast_as_unicast;
 };
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e3aec46bd4662160d684999c4696daa6b451da90..392aaa373b6671e3f0f9e04f3fa7f4363a06dadb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6412,9 +6412,9 @@ static struct ctl_table ipv6_route_table_template[] = {
 	{
 		.procname	=	"skip_notify_on_dev_down",
 		.data		=	&init_net.ipv6.sysctl.skip_notify_on_dev_down,
-		.maxlen		=	sizeof(int),
+		.maxlen		=	sizeof(u8),
 		.mode		=	0644,
-		.proc_handler	=	proc_dointvec_minmax,
+		.proc_handler	=	proc_dou8vec_minmax,
 		.extra1		=	SYSCTL_ZERO,
 		.extra2		=	SYSCTL_ONE,
 	},
-- 
2.41.0.rc0.172.g3f132b7071-goog


