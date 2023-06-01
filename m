Return-Path: <netdev+bounces-7195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E89FB71F0B1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:23:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787091C210B1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC76F4822D;
	Thu,  1 Jun 2023 17:22:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B942501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:05 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC5C136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:22:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-65292f79456so159701b3a.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640120; x=1688232120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xv6eJw2DiGVgYMv8ombmduKjli5mYs0yS1xccHR83qU=;
        b=hodt/n241Ypc+onmI570qU+QrfsukXXEopLbt3exynwkAUlEaKgWPYGPsigHJqB9/9
         Cz4uG2jNUnhuETZ+mhvqScscOD34vyRvi5OmqZfaYGEfxlsfo3hnUn2GtSyUF7MhIR8y
         S+uzi90HJ+nVV3g03GjdeA+uP2s9EBHvVB2dQhNgwGniPC5nDrDYKMTA2SUAsowFsBcq
         rh1Z4C+5jyWl4S2QY+PN9GRyK8XnA6EJZAgvv6BN5VxwybSNJQep9/kxm96x1ClSnaAn
         Ux+4O90Dq70ljqr2xUsJ90pUgPdLyTta/DORyQvtLIUJvfcerrY6/6XcpcFgw2ltF9oP
         n1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640120; x=1688232120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xv6eJw2DiGVgYMv8ombmduKjli5mYs0yS1xccHR83qU=;
        b=BpK4NNWc9Gz2RmVmFkNOzdlTShFHDyUPRXpRPplZ9bDlWafof59+KVV4FWkC7yi1nI
         vhKH/3WrqKgAs0RJrpvSVHVQVWog/SrLSaRkWTyxdCVnbJeiz4zEwt/bsZCN0kUvqF/j
         Y4kGJuUuwoRFeXeYn12RPIkvwDT5EjaNjHyn72vlaHU9DT4tYtuja/qsjvjjnduRvyBg
         Fp9mj06/IIdOh4FMy6N3Xmg1N4weNDybCT7eXTC3AbQ6jYMcaToasGfFkM76Sk/zimJQ
         JB0InNPWu/fIPna/sRrdoDJH2mxNVobQLENaZS5xcV753J5VLx6JF80C7+4rPxpOsI2t
         KN2Q==
X-Gm-Message-State: AC+VfDy24EbteSloo5NGoehNGsXAriUtw35VGbAlXFxw32AFJ19tyJAu
	E6THbMjHtVfg7bpbStQ4ZR3vH1fSnxd80Fdm9Naseg==
X-Google-Smtp-Source: ACHHUZ6QkodgP/YEl7b4jlfpPIEkoKKULZ53b0TeuaTNW2zYiWz30CJEdftLSoBYoVRJv65+NAm9Pw==
X-Received: by 2002:a05:6a20:3d85:b0:10e:457f:254c with SMTP id s5-20020a056a203d8500b0010e457f254cmr8657016pzi.2.1685640119876;
        Thu, 01 Jun 2023 10:21:59 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:59 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 6/7] xfrm: make xfrm_stat_print_nokeys static
Date: Thu,  1 Jun 2023 10:21:44 -0700
Message-Id: <20230601172145.51357-7-stephen@networkplumber.org>
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

This function is only used in one file.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/xfrm.h       | 1 -
 ip/xfrm_state.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/ip/xfrm.h b/ip/xfrm.h
index 33c42730375d..5238fc8b2b88 100644
--- a/ip/xfrm.h
+++ b/ip/xfrm.h
@@ -90,7 +90,6 @@ struct xfrm_filter {
 extern struct xfrm_filter filter;
 
 int xfrm_state_print(struct nlmsghdr *n, void *arg);
-int xfrm_state_print_nokeys(struct nlmsghdr *n, void *arg);
 int xfrm_policy_print(struct nlmsghdr *n, void *arg);
 int do_xfrm_state(int argc, char **argv);
 int do_xfrm_policy(int argc, char **argv);
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index aa0dce072dff..a7b3d0e14156 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -1027,7 +1027,7 @@ int xfrm_state_print(struct nlmsghdr *n, void *arg)
 	return __do_xfrm_state_print(n, arg, false);
 }
 
-int xfrm_state_print_nokeys(struct nlmsghdr *n, void *arg)
+static int xfrm_state_print_nokeys(struct nlmsghdr *n, void *arg)
 {
 	return __do_xfrm_state_print(n, arg, true);
 }
-- 
2.39.2


