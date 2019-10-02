Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB34C87D2
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfJBMEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:04:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45199 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbfJBMEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 08:04:15 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so16805174ljb.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 05:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y95OajR8Z4EhoKVV/d/GtPK38UmcXtK59LFx+wA+Kn4=;
        b=OmP5kq+z+zbFpIxkBNzdy160yYdL/tMN7p+YDlhaPbcErQwKwPUXwv2VJg5sUXmyup
         ygBxLJXG5geeSgJTdIEycdXlvcJ4VTiDNeCAcPjC9oX6zR5voiv5Ww3rBRcWuZD7otui
         XmJuS4uPT/e5ZSoyF4+mdfA9VFyOem72gpoqPJVVo9aWJuI2LHax7Cs3gE8ErSWQazFK
         JaESnbyXsinx1R/cgxTvkqrAHVdAH6gFw5ZUBlVLwH3Uwfnogt6FlnURjAsPrds0wVmq
         reyXAR9+mGKS3WAcXU8dMUB8XLZ00ncKR8c6OPrSVvIyojBl/q0L730b+Ns7dEOXDGfS
         0eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y95OajR8Z4EhoKVV/d/GtPK38UmcXtK59LFx+wA+Kn4=;
        b=SDVy5JYMVYzPF3xKzQnCqA5UtN11rSicNno+84vPdFMYdLO6mh8dMLdnMeZuAAzP/t
         8zszWiMkhIXHsTuXVaPCY+NPCh4aQWpWe6KODuaFxV6abAxp4uN/HK6SpPPQWrxGQALI
         8q5S8rdCeRP53SEtv7qBeMG+8lDeH+liHwykeW2FMHNtBqLi5CQNdS4Wfg3Y8+qPFSFs
         jxyCGmjXEAFfcJxm+ssVGJbtgVMAWu2qHee6JOPI3zm9/Je6mRFEqAvL2EniM5k/Kpmu
         Ou6CtTgs0CirB0veYN5u4ngivbzUGab9xTmtbhO76TGLJj6x9lFASuuIi9MhClbFnbCs
         AzpQ==
X-Gm-Message-State: APjAAAXy8N7mtyB/ZrYcWBqO6mRO/l7lMt1WwNcRkpvUWXfgkQ+UjJF0
        1Eyvj9eecj3szN6xYCUdrQuurw==
X-Google-Smtp-Source: APXvYqwCgHv5cQQHT5flHSQGpsA/3qpFgY9BqKRSoHwTcS8bpTuL/U1VGR2qPBiljcvG8ANgpwX2YQ==
X-Received: by 2002:a2e:5c09:: with SMTP id q9mr2285090ljb.4.1570017853751;
        Wed, 02 Oct 2019 05:04:13 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id x2sm4833827ljj.94.2019.10.02.05.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 05:04:13 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next 1/2] selftests/bpf: add static to enable_all_controllers()
Date:   Wed,  2 Oct 2019 15:04:03 +0300
Message-Id: <20191002120404.26962-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
References: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add static to enable_all_controllers() to get rid from annoying warn:

samples/bpf/../../tools/testing/selftests/bpf/cgroup_helpers.c:44:5:
warning: no previous prototype for ‘enable_all_controllers’
[-Wmissing-prototypes]
 int enable_all_controllers(char *cgroup_path)

while samples/bpf build.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index e95c33e333a4..4d74f3c4619b 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -41,7 +41,7 @@
  *
  * If successful, 0 is returned.
  */
-int enable_all_controllers(char *cgroup_path)
+static int enable_all_controllers(char *cgroup_path)
 {
 	char path[PATH_MAX + 1];
 	char buf[PATH_MAX];
-- 
2.17.1

