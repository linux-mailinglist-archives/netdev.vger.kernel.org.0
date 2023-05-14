Return-Path: <netdev+bounces-2403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 582D9701B2B
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 04:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02E7E1C20A4C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 02:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6793111F;
	Sun, 14 May 2023 02:26:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B31112
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 02:26:19 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4843210D
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 19:26:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5208be24dcbso8141883a12.1
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 19:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684031176; x=1686623176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b/4vH24fYTgJ0kP4jRKiQx+QFK9ZnJalTDaPVC2Eqtw=;
        b=OFYYU+2AyRF4L9Yp5npogR2qkK1nBzI4WeUZ0qH0qKASM7g4tn+sSiNZ+wZhB87HuN
         P9sgknFyYCEHVtA1Z1ZxcumoNXim1gys4DAtVHOb65FWvcRs8UBolj+ro0dtobrGI4DE
         6Spiht02DFpuRJXtFG8nT6wIgaglG9yKHxdtlnfBK53uhXmO5RRQ+oMXxnEwAgvr79ZM
         kdANRmgLjLPSLymun3LJYK+UgQ9LQEQ/0hXxE30D39Xs1mYoeJNfxSdKEGpxRiCG1Py7
         zwmtjE/ug19OREYH2cOiHT2SsAiXxyfKqmCE4/IhKFojasRivY3ItYLHAQ644h9zWInC
         1coQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684031176; x=1686623176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b/4vH24fYTgJ0kP4jRKiQx+QFK9ZnJalTDaPVC2Eqtw=;
        b=iLw49SFDjUWYxz1G8zXjlei4qUla7JbgwOMmHYV+iopJsae5jbmDJdIOkjVp10G0IH
         lJbHaGId7r8zk4KwxfPYB7Lmdok3uLT1W+2CtgoWjVCz4JpzN6s8LgufZfnhIGebMjhu
         djfNKfkXrBGI0kPKjQ3MvY/Zd4eFtNrthhwCIxjpndI+TxysOSVWY9btIlHBotu3mULj
         mZEq9OpYyMOmFnYCObJhfb8WtERxDNTqJTHOqG70JIDM60cx0lI4F3mLg+lRtVzUH3eH
         MSkQKzpIaNWfIF7vA6awXWqdGDoZA3y14U2569cdip/TPcrfYJWVF6KMmoCJac7l+y8A
         FP7g==
X-Gm-Message-State: AC+VfDyG6S31teUj/rzt8ePhvQ36xyuBXOdaAZk+KZHLOgF2G6f7q6GH
	iQbXYWkrda2p0TfxSGqrJdSuLzriGzsaNxKntDHqrQ==
X-Google-Smtp-Source: ACHHUZ5GyHIjlUQUFgds/D3szLcVPNEI4kCKEleimZGS+PREyKO+vsSLIVJ1QpSMti3Ehrp0buv7fg==
X-Received: by 2002:a17:902:ea11:b0:1ac:7f56:de04 with SMTP id s17-20020a170902ea1100b001ac7f56de04mr26596392plg.45.1684031175911;
        Sat, 13 May 2023 19:26:15 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y15-20020a1709027c8f00b001ab1d5726dcsm10461944pll.243.2023.05.13.19.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 19:26:15 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] CREDITS: add file
Date: Sat, 13 May 2023 19:26:13 -0700
Message-Id: <20230514022613.10047-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Like the kernel, record some of the historical contributors to iproute2.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 CREDITS | 30 ++++++++++++++++++++++++++++++
 README  |  4 ++--
 2 files changed, 32 insertions(+), 2 deletions(-)
 create mode 100644 CREDITS

diff --git a/CREDITS b/CREDITS
new file mode 100644
index 000000000000..bcfe05b47a00
--- /dev/null
+++ b/CREDITS
@@ -0,0 +1,30 @@
+	This is at least a partial credits file of people that have
+	contributed to iproute2 over its history.
+	It is sorted by name and formatted to allow easy grepping
+	and beautification by scripts. The fields are: name (N),
+	email (E), web-address (W)
+
+N: Werner Almesberger
+E: werner@almesberger.net
+W: https://www.almesberger.net/
+D: Wrote original classifiers, qdiscs, etc.
+
+N: Stephen Hemminger
+E: stephen@networkplumber.org
+D: Took over iproute2 starting with 2.6 kernel
+
+N: Alexey Kuznetsov
+E: kuznet@ms2.inr.ac.ru
+D: Original author of iproute2
+
+N: YOSHIFUJI Hideaki/ 吉藤英明
+E: yoshfuji@linux-ipv6.org
+D: USAGI project - Linux IPv6 Development
+
+N: David S. Miller
+E: davem@davemloft.net
+D: Developed the kernel networking and routing system
+
+N: Jamal Hadi Salam
+D: Original developer of TC classifier and action 
+E: hadi@cyberus.ca
diff --git a/README b/README
index fa0c7869f1f6..4eb9390a3ffa 100644
--- a/README
+++ b/README
@@ -38,5 +38,5 @@ kernel include files.
 Stephen Hemminger
 stephen@networkplumber.org
 
-Alexey Kuznetsov
-kuznet@ms2.inr.ac.ru
+David Ahern
+dsahern@gmail.com
-- 
2.39.2


