Return-Path: <netdev+bounces-7194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AC471F0B0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D286281888
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD384700F;
	Thu,  1 Jun 2023 17:22:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F06D48221
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:04 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB91A8
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-651ffcc1d3dso375995b3a.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640119; x=1688232119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmhCnQReURl+m9p4HFEiVz0yBfpJy1/p0N1zQPsiHYI=;
        b=bfBMQ57EKlY/fjhqqdDe1Ptp2GsihQbRDMchE5n8pRMQa3BYB6LoDfTDVLLwukniSj
         AkGOM1Cv641M3WaVpXmh95cOXug414qRvRteD8H+cLjBDiJ/E6YrIfMw5kWkFHESXNNa
         AJ41jjYEHQzDYlBCplNeWkxtgvRr2kPEmjUHQg1t5qYjW9KhqPR6wGwqbFFyuKYb+LZg
         0TkXDahvZiQtCBiUlAMT7VyKV+uYaIG1DQ9NFvHODXwefYR2/SmdFKxAFLlZWzXuhQZI
         KPBJjrv2xyVrxKfNEIKRrJDm8FSZlZ8nj1v4c0ipWFC6SNJ8xVUuTXqC3XuQTiKHy9h5
         72Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640119; x=1688232119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmhCnQReURl+m9p4HFEiVz0yBfpJy1/p0N1zQPsiHYI=;
        b=FNtgDbA5ZgZLH+pWmWeeLhapb9ZvyJooRKYUk4yI/4JsISMO7WwLV6U6X/pIP0AkYX
         BamFAcZGRVs4AR1y0WFZAL1uHThzk1lWZJyrurlGDT4NJAvWBLA1U4AJOfDJfSHCtqx8
         JwCMFBAkQ5PEB52GNoetmNW3z4f+4lkM5ncROFRIG7dFaTT3nAVBeBl+I7bHQK7hFHmp
         GZHf38h1eKUynjlZKZ6iCeP1SHzBrnW8Ppe+7qlRIVSYwq3vLSQg8Y5mbQNtpR5hPiKr
         4tYqw6uYK5zhgwMU7aZ3Us58BBYF4je8wFJSlj0wnSfYtCzftpn+gKA5/kJgdSiCtTum
         9pHQ==
X-Gm-Message-State: AC+VfDxj2SwV2fVsskuzfikh0N9j+hklYDb9MMkj6u4JS+Ig1e+lvl3m
	8SHuOCK16LXTv+Ow0QpdO37dAzrz6aXqSqykYySPyw==
X-Google-Smtp-Source: ACHHUZ5qvxrsqPmB1CvdWVIKnAN7uKQPqJ8aAt6c3mwC7UuTfZAiQMHGtrvK/ZMkdr5TW9NhRXrwfA==
X-Received: by 2002:a05:6a20:3c8f:b0:10c:a627:7ede with SMTP id b15-20020a056a203c8f00b0010ca6277edemr8270687pzj.58.1685640119054;
        Thu, 01 Jun 2023 10:21:59 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:58 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 5/7] ip: make print_rta_gateway static
Date: Thu,  1 Jun 2023 10:21:43 -0700
Message-Id: <20230601172145.51357-6-stephen@networkplumber.org>
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

Function only used in one file.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ip_common.h | 2 --
 ip/iproute.c   | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index 4a20ec3cba62..b65c2b41dc87 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -226,8 +226,6 @@ void print_num(FILE *fp, unsigned int width, uint64_t count);
 void print_rt_flags(FILE *fp, unsigned int flags);
 void print_rta_ifidx(FILE *fp, __u32 ifidx, const char *prefix);
 void __print_rta_gateway(FILE *fp, unsigned char family, const char *gateway);
-void print_rta_gateway(FILE *fp, unsigned char family,
-		       const struct rtattr *rta);
 void size_columns(unsigned int cols[], unsigned int n, ...);
 void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
 		   const struct rtattr *carrier_changes, const char *what);
diff --git a/ip/iproute.c b/ip/iproute.c
index 7909c4a210cc..fdf1f9a9dd0a 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -558,7 +558,7 @@ void __print_rta_gateway(FILE *fp, unsigned char family, const char *gateway)
 	}
 }
 
-void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
+static void print_rta_gateway(FILE *fp, unsigned char family, const struct rtattr *rta)
 {
 	const char *gateway = format_host_rta(family, rta);
 
-- 
2.39.2


