Return-Path: <netdev+bounces-7191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 090A071F093
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B78BC281823
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D593D47003;
	Thu,  1 Jun 2023 17:22:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92B4252C
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:02 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B87819F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b065154b79so19148475ad.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640116; x=1688232116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gGbHI0EP2JdmUgp0kX9QSWkRivCDca1WWwkFWiYqH7I=;
        b=t8MqQ6AjMDejliTsWSNbj4XVIOJlNg4DY4JV4xqLQf6UF9BeLjkjr4WUDJrKbB+833
         Vuc9J17iOU/ywajhsdIkILvqwQd38FTV7gl2IEgXbfR3Im4332mxCpLyc/EqvgeSRorW
         BAGu7sqU5Tf+2b5/AxDdB4RrUkgD0a5IPDXvuin2vFznZ944k1lUWv1TZCyknM/vQtvQ
         IDYZnNo4je1hPsl2sYkUWd7Un/EK5lZCaSvxunGwVcrqcmS1WLyI8MelDVyZ8MBzNmci
         MhWHS/7teM9On+7zrWOdsAasUrOLwPmJxLQoXmT9El1RxwIpcsZpIFsCyWGmEKOkFYP7
         svXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640116; x=1688232116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gGbHI0EP2JdmUgp0kX9QSWkRivCDca1WWwkFWiYqH7I=;
        b=F8y6azlFV3k06l8M0DKfQy1JDqBwo0wO1t2EFO9LjeF6wmWrHaaCsvXjYR3Zbav0Zg
         IbWlMXF6PEcR8JQoTXSUQIGc70ReVePxLvfNvsM3jCvMbpjpaDhqPrLfqBIHuCpzMk3P
         vMGRq2qFDNu7h2NZUrG/it82gIsxHlQ6TEsMj3Y7Ez6Yr3WScPWGznHdBLbQFxRX5Qk7
         zgtjHRrfwqw6fO+5F+Uy8E3AhnODYfnaeD+3jRy56/Xo7xnjhFUUaLKn7KsBLgTtrK+/
         Bff8ZZpP0PKZ1ARb3ydSndHSjdm7iq55FJWj46v9p6vlAH4jrlEfvEuBz5RRoyf7kOiC
         xZog==
X-Gm-Message-State: AC+VfDz25HEUo0JTKEFyWuf1rIyHmqL6NyXtGaPoL97sTXnPzlD89FwD
	sLn/VdOj261gFdfMQd1qfQnzJ3VYhH9DpHbiXUNcYQ==
X-Google-Smtp-Source: ACHHUZ4UYYNSQM01gzoabDyd4j3ZU5/JPHg0+/GrEEJ8W+H8dyMTOCrHGIykBx92BpwLl2N9RI3vCA==
X-Received: by 2002:a17:903:22ce:b0:1b0:3ab6:5140 with SMTP id y14-20020a17090322ce00b001b03ab65140mr3243656plg.4.1685640116366;
        Thu, 01 Jun 2023 10:21:56 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:55 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/7] libnetlink: drop unused rtnl_talk_iov
Date: Thu,  1 Jun 2023 10:21:40 -0700
Message-Id: <20230601172145.51357-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601172145.51357-1-stephen@networkplumber.org>
References: <20230601172145.51357-1-stephen@networkplumber.org>
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

Function was defined but not used in current iproute2 code.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/libnetlink.h | 3 ---
 lib/libnetlink.c     | 6 ------
 2 files changed, 9 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index c91a22314548..39ed87a7976e 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -177,9 +177,6 @@ int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n, int json,
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
-int rtnl_talk_iov(struct rtnl_handle *rtnl, struct iovec *iovec, size_t iovlen,
-		  struct nlmsghdr **answer)
-	__attribute__((warn_unused_result));
 int rtnl_talk_suppress_rtnl_errmsg(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 				   struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 68360b0f4c96..7edcd28569fd 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1168,12 +1168,6 @@ int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	return __rtnl_talk(rtnl, n, answer, true, NULL);
 }
 
-int rtnl_talk_iov(struct rtnl_handle *rtnl, struct iovec *iovec, size_t iovlen,
-		  struct nlmsghdr **answer)
-{
-	return __rtnl_talk_iov(rtnl, iovec, iovlen, answer, true, NULL);
-}
-
 int rtnl_talk_suppress_rtnl_errmsg(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 				   struct nlmsghdr **answer)
 {
-- 
2.39.2


