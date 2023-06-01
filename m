Return-Path: <netdev+bounces-7137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E6971A3A4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D576D281798
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB88340789;
	Thu,  1 Jun 2023 16:04:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FFF40787
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:04:50 +0000 (UTC)
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A29C0
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:04:49 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id af79cd13be357-75b2f94940bso135859185a.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685635489; x=1688227489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXpUVfe+5QjSRmZEGstJAfGRdBEqJFQ+9dDLuo/Db/4=;
        b=l5d9fPYhvgJayl9uiFj0laLNzH6HFKtf8NPqgkFnrUj8mnktkn9b4dl/VUoKRWq2YH
         Tkf28OBlGMqEt5D9hMpH5A01f57xNISQuKQMzI8YKJU4b9AfGZNYwbVBpRccu6khXUmm
         /H8/XQTDsRP95QyYlzXpQoovCpyeYWtC3+B0hX//zOy5u5yUAkQNQMXcM67rLhyj2KCM
         gcgVZoVNACU9YChJ/7p+Ag4nFxNI6vOQLH1IxGD9IuTouZmFr9VTVk+RJtTHYSORe1rM
         Ns5z3JOxeQNNIQ0IzyEiSbTu3mspdn6Rt4L/2actpTV/5zMNeUDKWUi/7PjCTv40ervR
         4C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685635489; x=1688227489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXpUVfe+5QjSRmZEGstJAfGRdBEqJFQ+9dDLuo/Db/4=;
        b=U43sk9jllfXHjLECWTPtx5HbsYcJf1U4tYqoQs6Sg7bWchaIBLc7yE4T3zi6y5D6nC
         IcRBo1UAETM+DcSvV/3EBtwJXisIm9M6sPkQRHZhXAqoZUI2Evlb+lkqBSlNWqqSlm3I
         tPrzyHptuG6oDsHo9WJD0Pe+Z9ijBNYbfQqLUwP6+fKoleg4X2smnZPen65nQe0WyN3j
         OYgqxpjiEot+KHLU8IClaUFbXzvA8RMmtI761DGCkbTliFIBaj86BO2eQkqKX6Hz2k6T
         Q+5fpC15esBL31e9t8q3lWAl3Qbs7ll3sawpcEsE0pdR0meQvIaBpWzJ+30pKLC6Q0m3
         bFvQ==
X-Gm-Message-State: AC+VfDwmKcb60sDewmGyxf7/ufvMQb3YKKZ6KW5oG1YxQHRAxmGKGNL7
	9woTHZUnNqq59P1qWVZUNx0N+Uzx+NEUEQ==
X-Google-Smtp-Source: ACHHUZ6GapXAMkSQKjlr8FcDn+YSXMs1qq2YB4ShYSKXPOAiCIiZkfbbRBJzNR+hzIw/k9hhVStC1dO5e5u17A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:4003:b0:759:1798:d849 with SMTP
 id h3-20020a05620a400300b007591798d849mr3040612qko.3.1685635488815; Thu, 01
 Jun 2023 09:04:48 -0700 (PDT)
Date: Thu,  1 Jun 2023 16:04:44 +0000
In-Reply-To: <20230601160445.1480257-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230601160445.1480257-1-edumazet@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601160445.1480257-2-edumazet@google.com>
Subject: [PATCH net 1/2] net/ipv6: fix bool/int mismatch for skip_notify_on_dev_down
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

skip_notify_on_dev_down ctl table expects this field
to be an int (4 bytes), not a bool (1 byte).

Because proc_dou8vec_minmax() was added in 5.13,
this patch converts skip_notify_on_dev_down to an int.

Following patch then converts the field to u8 and use proc_dou8vec_minmax().

Fixes: 7c6bb7d2faaf ("net/ipv6: Add knob to skip DELROUTE message on device down")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/netns/ipv6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 3cceb3e9320b9c614026846a451676edf766e4d3..d44b2ee49698fa17bef0c54df8c960ec5addcbd0 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -53,7 +53,7 @@ struct netns_sysctl_ipv6 {
 	int seg6_flowlabel;
 	u32 ioam6_id;
 	u64 ioam6_id_wide;
-	bool skip_notify_on_dev_down;
+	int skip_notify_on_dev_down;
 	u8 fib_notify_on_flag_change;
 	u8 icmpv6_error_anycast_as_unicast;
 };
-- 
2.41.0.rc0.172.g3f132b7071-goog


