Return-Path: <netdev+bounces-1266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B6D6FD16F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23288281228
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF1B19934;
	Tue,  9 May 2023 21:30:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF419909
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:30:15 +0000 (UTC)
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57234D85C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:29:42 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-76c60c88d0cso65963239f.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667718; x=1686259718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZVejeAnxoqLBX7omICtCCw3k65BATms4dJx0VY3K70=;
        b=vokvyQ0nLmHudReBje6R+fBfXv+97LwPhdEWYgaRAvrf7ryb6hxhrfVsVCJr4yHdqh
         1KGi6tLmhBmJtlBLmiHdvo2SkmG3tJMrumxjZmwIzsWD+C/xp+7jiEUGfbKvssHC1rDX
         mIY4wIizaD8xk9dVdTn8Yg/YYGjvn7d0sCzvQJOhEZWUj2GzV5CiAV8REER3LUmsrCG5
         YPesnY7MO8EuWN2Yv5ax+WkaU1nFKcs3pcDZyLSHc4PIAKd4yXxHk3+Qd5TheouJbOP4
         QrlERFvjUaXsIxkJTSZcq8oPYzfLyQDr72koVbZYVMlbIIMcHsyqDTtWDykDmjGGPHhz
         ZUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667718; x=1686259718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZVejeAnxoqLBX7omICtCCw3k65BATms4dJx0VY3K70=;
        b=euIoZuYnlQZGdQcpSL8RdJ5mPxgp4ixR0X/mbHbbJ+FpItwTPnxwrsO1cM/aH4cpsd
         4367hAK4FJYOkZSphoeMtxGE53OeOSvfLc4EcDxR57hWKbA+uQKlK+PyFUGUFOkB054k
         cmJmpfhFgIwN8bhc3+WbS02d6OMU8PRCg3XX+E0RjQlIiGGQQNRD4uKAijmJeSBgng88
         q4ppNmcSzciQETKMM2twvCimMHDxaOoUoXtYImc8GTvQ0fvDyEH6Nm8w12pJpvdQfmoJ
         0OS9G5wPTMmsoHj+zbNlxz64rKcJYIMqrlbao2NXNA8A7kTpt/w/48M8+4dzl49y/XXw
         k8HA==
X-Gm-Message-State: AC+VfDwf+VuV0+tPBMjgB3h3ChngrWQ2rqd47Wl6Mr+btDwjGypWmkSk
	0ljaZHU1/e4wq+HKkQO9fS9sOgDsPy/80Nnh81tiPA==
X-Google-Smtp-Source: ACHHUZ62qFk1so0jtsqQNfzuXZHuv4rBgcgqfFDT+bkhnRv/hFjL/7zDENZiutP3XEONeAHiA0YhVA==
X-Received: by 2002:a05:6a00:1954:b0:645:4a3d:a14f with SMTP id s20-20020a056a00195400b006454a3da14fmr13759073pfk.29.1683667296246;
        Tue, 09 May 2023 14:21:36 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:35 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 06/11] tc_exec: don't dereference NULL on calloc failure
Date: Tue,  9 May 2023 14:21:20 -0700
Message-Id: <20230509212125.15880-7-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509212125.15880-1-stephen@networkplumber.org>
References: <20230509212125.15880-1-stephen@networkplumber.org>
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

Reported as:
tc_exec.c: In function ‘do_exec’:
tc_exec.c:103:18: warning: dereference of NULL ‘eu’ [CWE-476] [-Wanalyzer-null-dereference]
  103 |         return eu->parse_eopt(eu, argc, argv);
      |                ~~^~~~~~~~~~~~
  ‘do_exec’: events 1-6
    |
    |   81 | int do_exec(int argc, char **argv)
    |      |     ^~~~~~~
    |      |     |
    |      |     (1) entry to ‘do_exec’
    |......
    |   86 |         if (argc < 1) {
    |      |            ~
    |      |            |
    |      |            (2) following ‘false’ branch (when ‘argc > 0’)...
    |......
    |   91 |         if (matches(*argv, "help") == 0) {
    |      |            ~~~~~~~~~~~~~~~~~~~~~~~
    |      |            ||
    |      |            |(3) ...to here
    |      |            (4) following ‘true’ branch...
    |......
    |   96 |         strncpy(kind, *argv, sizeof(kind) - 1);
    |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |         |
    |      |         (5) ...to here
    |   97 |
    |   98 |         eu = get_exec_kind(kind);
    |      |              ~~~~~~~~~~~~~~~~~~~
    |      |              |
    |      |              (6) calling ‘get_exec_kind’ from ‘do_exec’
    |
    +--> ‘get_exec_kind’: events 7-10
           |
           |   40 | static struct exec_util *get_exec_kind(const char *name)
           |      |                          ^~~~~~~~~~~~~
           |      |                          |
           |      |                          (7) entry to ‘get_exec_kind’
           |......
           |   63 |         if (eu == NULL)
           |      |            ~
           |      |            |
           |      |            (8) following ‘true’ branch (when ‘eu’ is NULL)...
           |   64 |                 goto noexist;
           |      |                 ~~~~
           |      |                 |
           |      |                 (9) ...to here
           |......
           |   72 |         if (eu) {
           |      |            ~
           |      |            |
           |      |            (10) following ‘false’ branch (when ‘eu’ is NULL)...
           |
         ‘get_exec_kind’: event 11
           |
           |cc1:
           | (11): ...to here
           |
    <------+
    |
  ‘do_exec’: events 12-13
    |
    |   98 |         eu = get_exec_kind(kind);
    |      |              ^~~~~~~~~~~~~~~~~~~
    |      |              |
    |      |              (12) return of NULL to ‘do_exec’ from ‘get_exec_kind’
    |......
    |  103 |         return eu->parse_eopt(eu, argc, argv);
    |      |                ~~~~~~~~~~~~~~
    |      |                  |
    |      |                  (13) dereference of NULL ‘eu’
    |

Fixes: 4bd624467bc6 ("tc: built-in eBPF exec proxy")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_exec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tc/tc_exec.c b/tc/tc_exec.c
index 5d8834029a0b..182fbb4c35c9 100644
--- a/tc/tc_exec.c
+++ b/tc/tc_exec.c
@@ -96,6 +96,10 @@ int do_exec(int argc, char **argv)
 	strncpy(kind, *argv, sizeof(kind) - 1);
 
 	eu = get_exec_kind(kind);
+	if (eu == NULL) {
+		fprintf(stderr, "Allocation failed finding exec\n");
+		return -1;
+	}
 
 	argc--;
 	argv++;
-- 
2.39.2


