Return-Path: <netdev+bounces-1264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCD96FD15D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F56E1C20CAB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC721993E;
	Tue,  9 May 2023 21:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1D1993C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 21:23:41 +0000 (UTC)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EAA106D6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:23:24 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-64395e741fcso6509631b3a.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 14:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683667290; x=1686259290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/a1H5Uw7vjzJuOoJpULAG1rAFq0YE7GyjI2Q6kkpZiY=;
        b=WPMiEaRqTAWLmrn9/MHDHozgoWnJq3QeN0RuzFpcELM7oP+2AmJgYKkrNucsbT0BHt
         6WHk0wenPlHtPX/RzaSsasJm812yBudcW+YxKQ458ld8LGkvqkrRff+xEp5o/pPYqxul
         +ydOuCPcvNPK+svBDSewW6EChDuArOxPfOSXBZ4P3JUT26Ma1GXrqqWffCMGAMrj1UkJ
         EV2+u6JtJLlk7xR7Ygn630I4TMoiyRHUNMYivr01ta/VbiC9Ob418c32RpDmFyicWiVj
         9eDFxfwQuSR6TnQr4zUGXaGysxcK2LgZzyE37IwPmTjvAxDlbfiXDT5MXsW/WBOw3wtS
         uztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667290; x=1686259290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/a1H5Uw7vjzJuOoJpULAG1rAFq0YE7GyjI2Q6kkpZiY=;
        b=Q94uEvh39jcj1wm6AlwQB4fCZADibms0HfZWjxBHfGiSAFjd6e8Iu7oUFL0/4Lfi19
         O9O1FD/cCdtJ8oC9efLIBK7u5ZXY74xCR0yUhhNRGom1b/eS17RS7KkGAyWq7n+m5LcF
         kpEiC6F0o/WsU10ADjBg+6jlr0qjP3wXZf2dfnQxI0C+6ge+FOQUmxIiutTDdJRoAl8R
         3ngGbzPW9IaEGkrEJnKZBKvI6BvN+z9anrXwkXuUu6tv6LAwcfZeyyFhB25mX6PJ2a78
         L0tQt86d97y4Q8HBmDHHyp1e4m0DeU07dWlS5w44ZbiesaLJlgRv/2T5HEeXGGGAdfSX
         0mzw==
X-Gm-Message-State: AC+VfDxsEGpGzckto3Tc2F+YOPtk5PKN4ad+7iCXzElTpBmqOXg9EN46
	LXZ4YafTsnj8MejKk2PkvBOk5wlnp9oID0IyYKHcvA==
X-Google-Smtp-Source: ACHHUZ4K9ptLq49KvxM8/ijqM6fmIdsCbfJCm7eDShE7jYdpWAPQMMuR/OvxjcSUlAjmiH2hieoWAQ==
X-Received: by 2002:a05:6a00:1406:b0:62a:c1fa:b253 with SMTP id l6-20020a056a00140600b0062ac1fab253mr19105494pfu.31.1683667289805;
        Tue, 09 May 2023 14:21:29 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78e56000000b00646e7d2b5a7sm1932565pfr.112.2023.05.09.14.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:21:29 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 01/11] lib/fs: fix file leak in task_get_name
Date: Tue,  9 May 2023 14:21:15 -0700
Message-Id: <20230509212125.15880-2-stephen@networkplumber.org>
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
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fixes the problem identified -fanalyzer.
Why did rdma choose to reimplement the same function as
exiting glibc pthread_getname().

fs.c: In function ‘get_task_name’:
fs.c:355:12: warning: leak of FILE ‘f’ [CWE-775] [-Wanalyzer-file-leak]
  355 |         if (!fgets(name, len, f))
      |            ^
  ‘get_task_name’: events 1-9
    |
    |  345 |         if (!pid)
    |      |            ^
    |      |            |
    |      |            (1) following ‘false’ branch (when ‘pid != 0’)...
    |......
    |  348 |         if (snprintf(path, sizeof(path), "/proc/%d/comm", pid) >= sizeof(path))
    |      |            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |            ||
    |      |            |(2) ...to here
    |      |            (3) following ‘false’ branch...
    |......
    |  351 |         f = fopen(path, "r");
    |      |             ~~~~~~~~~~~~~~~~
    |      |             |
    |      |             (4) ...to here
    |      |             (5) opened here
    |  352 |         if (!f)
    |      |            ~
    |      |            |
    |      |            (6) assuming ‘f’ is non-NULL
    |      |            (7) following ‘false’ branch (when ‘f’ is non-NULL)...
    |......
    |  355 |         if (!fgets(name, len, f))
    |      |            ~ ~~~~~~~~~~~~~~~~~~~
    |      |            | |
    |      |            | (8) ...to here
    |      |            (9) following ‘true’ branch...
    |
  ‘get_task_name’: event 10
    |
    |cc1:
    | (10): ...to here
    |
  ‘get_task_name’: event 11
    |
    |  355 |         if (!fgets(name, len, f))
    |      |            ^
    |      |            |
    |      |            (11) ‘f’ leaks here; was opened at (5)
    |
fs.c:355:12: warning: leak of ‘f’ [CWE-401] [-Wanalyzer-malloc-leak]
  ‘get_task_name’: events 1-9
    |
    |  345 |         if (!pid)
    |      |            ^
    |      |            |
    |      |            (1) following ‘false’ branch (when ‘pid != 0’)...
    |......
    |  348 |         if (snprintf(path, sizeof(path), "/proc/%d/comm", pid) >= sizeof(path))
    |      |            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |            ||
    |      |            |(2) ...to here
    |      |            (3) following ‘false’ branch...
    |......
    |  351 |         f = fopen(path, "r");
    |      |             ~~~~~~~~~~~~~~~~
    |      |             |
    |      |             (4) ...to here
    |      |             (5) allocated here
    |  352 |         if (!f)
    |      |            ~
    |      |            |
    |      |            (6) assuming ‘f’ is non-NULL
    |      |            (7) following ‘false’ branch (when ‘f’ is non-NULL)...
    |......
    |  355 |         if (!fgets(name, len, f))
    |      |            ~ ~~~~~~~~~~~~~~~~~~~
    |      |            | |
    |      |            | (8) ...to here
    |      |            (9) following ‘true’ branch...
    |
  ‘get_task_name’: event 10
    |
    |cc1:
    | (10): ...to here
    |
  ‘get_task_name’: event 11
    |
    |  355 |         if (!fgets(name, len, f))
    |      |            ^
    |      |            |
    |      |            (11) ‘f’ leaks here; was allocated at (5)

Fixes: 81bfd01a4c9e ("lib: move get_task_name() from rdma")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/fs.c b/lib/fs.c
index 22d4af7583dd..7f4b159ccb65 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -352,8 +352,10 @@ int get_task_name(pid_t pid, char *name, size_t len)
 	if (!f)
 		return -1;
 
-	if (!fgets(name, len, f))
+	if (!fgets(name, len, f)) {
+		fclose(f);
 		return -1;
+	}
 
 	/* comm ends in \n, get rid of it */
 	name[strcspn(name, "\n")] = '\0';
-- 
2.39.2


