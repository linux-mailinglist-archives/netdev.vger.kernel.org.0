Return-Path: <netdev+bounces-7476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2FB720697
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 393FD2817FE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EB21B91F;
	Fri,  2 Jun 2023 15:54:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A931B909
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:54:25 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702BD1B1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:54:23 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-652d1d3e040so664894b3a.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 08:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685721262; x=1688313262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hMPm1WCidcSa7noQChdpx0ZZe8xArHI7ltSKDz1DDHE=;
        b=tcxr6+xHc0dKRRo96CqkcIqBovCSUV11nd+BwQ2JMg48WC4/qqNkLA74NuZ63972Rs
         tu9+V9lrzutApv/kp76Ajt1M1biLCg1nzcvVtWtHckX9t1OAMoWof7l+os1txHDPFJZd
         7griBh+vsUAxpQlYtJEvqSAlKkQhpXvA27sJJVLwtRyAdMujw6Mo5Zob0bPrqLMOoLVB
         10522mkHWgjScV8IXkCzWy/HLPRRha6mixfYskLshweInfTRrnd701Q7IGIqxYXgBqVf
         bnMnbXa5SonSsfWc7P021ZPS6uuNYOOY+pB8jKy3Iq96R1j2tLuVYpi2mUQVoNnkoVao
         jCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685721262; x=1688313262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMPm1WCidcSa7noQChdpx0ZZe8xArHI7ltSKDz1DDHE=;
        b=SRc/2MtXIIer46xW8dTwldd4+RErxuAIVxAhnoRJfDCsC5xX3SzAomHzXvigli1wQG
         mofGuUHbqmZZk2UkM908nrQxH9P55iBrzfcHzedO/miUP2vXFvk1D5k0ZAVjW6DZvrc3
         D7s6LxlhpXC1WFM0X6zAwfTQmVADtDT8Xk79gPorI6aeGCTJeddqCGuV0AezTJ3im4bi
         oioEm20z600/Jtyrl5ltEASP0+CpIuwWqTrQAg2Drv6irGEKE1MAYxWlb4N/h/eIDcKT
         61xmqkLUsjBQ2XzMvfUTVsRUm1tz+eoWAJpmXqLOpLSS8xKq62uMqj/opr9dTz7URO+1
         Jndw==
X-Gm-Message-State: AC+VfDzH7DrJTyU7d/k8nO2Ba0yUklFoJMbMpk4qeygJPupcjpe94Kbb
	Pzbz7I25YZMUK12nw0A4JUmPTtQp4nBnLSg5O0g1UA==
X-Google-Smtp-Source: ACHHUZ4oaDo0rbZItYz6oMCPDQhXrkPcHbCn2XGxqiGVI6RYzkRorDCHJvKzcLwF91rM/0rGtOkrRA==
X-Received: by 2002:aa7:88cf:0:b0:64a:f730:1552 with SMTP id k15-20020aa788cf000000b0064af7301552mr11400839pff.19.1685721262487;
        Fri, 02 Jun 2023 08:54:22 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f4-20020aa78b04000000b0063f00898245sm1191756pfd.146.2023.06.02.08.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 08:54:21 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	petrm@nvidia.com
Subject: [PATCH iproute2] ipaddress: accept symbolic names
Date: Fri,  2 Jun 2023 08:54:19 -0700
Message-Id: <20230602155419.8958-1-stephen@networkplumber.org>
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

The function rtnl_addproto_a2n() was defined but never used.
Use it to allow for symbolic names, and fix the function signatures
so protocol value is consistently __u8.

Fixes: bdb8d8549ed9 ("ip: Support IP address protocol")
Cc: petrm@nvidia.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/rt_names.h |  4 ++--
 ip/ipaddress.c     |  2 +-
 lib/rt_names.c     | 18 +++++-------------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index e96d80f30554..0275030704c1 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 const char *rtnl_rtprot_n2a(int id, char *buf, int len);
-const char *rtnl_addrprot_n2a(int id, char *buf, int len);
+const char *rtnl_addrprot_n2a(__u8 id, char *buf, int len);
 const char *rtnl_rtscope_n2a(int id, char *buf, int len);
 const char *rtnl_rttable_n2a(__u32 id, char *buf, int len);
 const char *rtnl_rtrealm_n2a(int id, char *buf, int len);
@@ -14,7 +14,7 @@ const char *rtnl_dsfield_get_name(int id);
 const char *rtnl_group_n2a(int id, char *buf, int len);
 
 int rtnl_rtprot_a2n(__u32 *id, const char *arg);
-int rtnl_addrprot_a2n(__u32 *id, const char *arg);
+int rtnl_addrprot_a2n(__u8 *id, const char *arg);
 int rtnl_rtscope_a2n(__u32 *id, const char *arg);
 int rtnl_rttable_a2n(__u32 *id, const char *arg);
 int rtnl_rtrealm_a2n(__u32 *id, const char *arg);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index c428dd3d5413..7accbf7d7822 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2547,7 +2547,7 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			__u8 proto;
 
 			NEXT_ARG();
-			if (get_u8(&proto, *argv, 0))
+			if (rtnl_addrprot_a2n(&proto, *argv))
 				invarg("\"proto\" value is invalid\n", *argv);
 			addattr8(&req.n, sizeof(req), IFA_PROTO, proto);
 		} else {
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 51d11fd056b1..b441e98f8078 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -242,9 +242,9 @@ static void rtnl_addrprot_initialize(void)
 	rtnl_addrprot_tab_initialized = true;
 }
 
-const char *rtnl_addrprot_n2a(int id, char *buf, int len)
+const char *rtnl_addrprot_n2a(__u8 id, char *buf, int len)
 {
-	if (id < 0 || id >= 256 || numeric)
+	if (numeric)
 		goto numeric;
 	if (!rtnl_addrprot_tab_initialized)
 		rtnl_addrprot_initialize();
@@ -255,27 +255,19 @@ numeric:
 	return buf;
 }
 
-int rtnl_addrprot_a2n(__u32 *id, const char *arg)
+int rtnl_addrprot_a2n(__u8 *id, const char *arg)
 {
-	static char *cache;
-	static unsigned long res;
+	unsigned long res;
 	char *end;
 	int i;
 
-	if (cache && strcmp(cache, arg) == 0) {
-		*id = res;
-		return 0;
-	}
-
 	if (!rtnl_addrprot_tab_initialized)
 		rtnl_addrprot_initialize();
 
 	for (i = 0; i < 256; i++) {
 		if (rtnl_addrprot_tab[i] &&
 		    strcmp(rtnl_addrprot_tab[i], arg) == 0) {
-			cache = rtnl_addrprot_tab[i];
-			res = i;
-			*id = res;
+			*id = i;
 			return 0;
 		}
 	}
-- 
2.39.2


