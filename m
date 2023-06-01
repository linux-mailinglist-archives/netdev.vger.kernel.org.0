Return-Path: <netdev+bounces-7193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5BE71F0AE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A067281862
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7592647012;
	Thu,  1 Jun 2023 17:22:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684A34700F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:22:04 +0000 (UTC)
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131981A6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:21:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-5289ce6be53so1836295a12.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685640118; x=1688232118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi+TlvcFR4h2vJbs4es2njLEIso9YCrBEu0B3+5RTO4=;
        b=anCTUNL3PkCXWLZ6a9rUnQYrehDhhPIsbLh7fxbKO3pQBkcI+A3toi4TPDltq41qsc
         c3oJVSTcEHFu9FC3QcFzEmaP00cQ+0o4fAuMRyzFL+tC2YVPFZMVIIjIUHKxTJIk0WWW
         F0DTkoaVIxhNfweHAOcacBtU+1ZXi3qng6L9gfEvEnZfCzgxKoO9bAnHigexNluxGA1f
         PizAMOWByo9uSwDGVYuXEKoFZEYtLV5G/BLonn7PyUJKNmKGuo1obU3zL/hjQF5BHwCk
         xxd9ZBpLTnE3tw9SEcIBsKzm136sJMjE2Jy5PNR+1F+VasJh7kWgDyPffwSjdZAqJh01
         WYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640118; x=1688232118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yi+TlvcFR4h2vJbs4es2njLEIso9YCrBEu0B3+5RTO4=;
        b=EQh06uklhk/6tCMzaFNZMrWsFmElgaUCxKnc9dyKPsxFdP+Tsk95uSpQWBJ26Zd9hf
         BuWCF+P6Ib7DmieGcyoSNjbXNl7aSIVxaUKp2MDnx7F0mwNedrDIsCnpdBAkI5Ave+dv
         eHnwDfdPE+y1E10OZ3mVmM3fRTs7TgBFsefopUFdAbkg+GqNx3rLIctgeTibc2hUNO/V
         uou61tBetwT96LBBZOEa6EI0MvaTTzSiCXKl9HOiPX+qIzOPK6tVP7jMbY7py3b3CE3l
         WA/S6d4LFqYyLhKXKZWZdDGsA7v4DVtveF1q7kIWZJgzdsj78A2odzOpNwHNLUBWUli+
         ll6g==
X-Gm-Message-State: AC+VfDzlPl4ELjYikAEmyy3EPgjXDQ/x7lYc/EyFaMd5UQd2h03XN/cZ
	37jYn/qua0ZXqpG6uuVQxcdr/aMr7l/0smal29eFLQ==
X-Google-Smtp-Source: ACHHUZ46b2SvWEaiWcIs1uRdjltgbEaK1yNnGzBg4aP9StdRkYuz7qWvyubq6p+b4f48NnzRZWRzow==
X-Received: by 2002:a17:902:e550:b0:1ac:6fc3:6beb with SMTP id n16-20020a170902e55000b001ac6fc36bebmr3328296plf.9.1685640118286;
        Thu, 01 Jun 2023 10:21:58 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020a170902760600b001b1920cffdasm2378945pll.204.2023.06.01.10.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 10:21:58 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 4/7] rt_names: drop unused rtnl_addrprot_a2n
Date: Thu,  1 Jun 2023 10:21:42 -0700
Message-Id: <20230601172145.51357-5-stephen@networkplumber.org>
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

This function is defined but never used in current code.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/rt_names.h |  1 -
 lib/rt_names.c     | 33 ---------------------------------
 2 files changed, 34 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index e96d80f30554..9003e67785b3 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -14,7 +14,6 @@ const char *rtnl_dsfield_get_name(int id);
 const char *rtnl_group_n2a(int id, char *buf, int len);
 
 int rtnl_rtprot_a2n(__u32 *id, const char *arg);
-int rtnl_addrprot_a2n(__u32 *id, const char *arg);
 int rtnl_rtscope_a2n(__u32 *id, const char *arg);
 int rtnl_rttable_a2n(__u32 *id, const char *arg);
 int rtnl_rtrealm_a2n(__u32 *id, const char *arg);
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 51d11fd056b1..8af3bca3245b 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -255,39 +255,6 @@ numeric:
 	return buf;
 }
 
-int rtnl_addrprot_a2n(__u32 *id, const char *arg)
-{
-	static char *cache;
-	static unsigned long res;
-	char *end;
-	int i;
-
-	if (cache && strcmp(cache, arg) == 0) {
-		*id = res;
-		return 0;
-	}
-
-	if (!rtnl_addrprot_tab_initialized)
-		rtnl_addrprot_initialize();
-
-	for (i = 0; i < 256; i++) {
-		if (rtnl_addrprot_tab[i] &&
-		    strcmp(rtnl_addrprot_tab[i], arg) == 0) {
-			cache = rtnl_addrprot_tab[i];
-			res = i;
-			*id = res;
-			return 0;
-		}
-	}
-
-	res = strtoul(arg, &end, 0);
-	if (!end || end == arg || *end || res > 255)
-		return -1;
-	*id = res;
-	return 0;
-}
-
-
 static char *rtnl_rtscope_tab[256] = {
 	[RT_SCOPE_UNIVERSE]	= "global",
 	[RT_SCOPE_NOWHERE]	= "nowhere",
-- 
2.39.2


