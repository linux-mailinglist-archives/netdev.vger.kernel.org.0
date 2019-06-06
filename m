Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8448E370C6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfFFJtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:49:20 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:34698 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfFFJtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:49:20 -0400
Received: by mail-yw1-f65.google.com with SMTP id v189so626495ywe.1
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9i+39qzlLlaj4ZIJyuysO0V74pT4jxs4rHh5xzjVecc=;
        b=xvEQkpFW7U+cyfXABrk8OGQT+iMDWfuf5C9izUay98hemQXRn3UvCf2XQZAhqeKbaY
         /HPKE5mNFJPLJ+MTNCbLBTR1uDHjxMtYu5EF2B1FpffQXMyok0Hz8OTS3775SFYIZfw/
         DMIo5SI91aay1zX2lMniEIhb19rXUi/eVBzpm4U5HXUjhmDLRajWqMrBDLz2GC6wsKlS
         /NV1SeA9mN2R/AWMr4/PmWPPS2nBek24yhnuY6ENbh7zJ6OYdhVtBop5R2RFxXkkyBmL
         QOiwh1PEjWETnYXNQVS4hVhUNRlaieNO0/kMGBzfCTEV7dwtrF8OnipFjO7s260W0xg4
         b9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9i+39qzlLlaj4ZIJyuysO0V74pT4jxs4rHh5xzjVecc=;
        b=RGDqD5nGXhTB/Chi6WYJ7rFQItal0do7T5aWQq8SyozqyJtTursXgUa1bfS41q63p2
         7oPSKQeieor2wWDX11uW28TKJOFlPlvQfPfhyzuQJsn0Ww2Tgoc5UWRqQ10pFb8ztNGc
         ciIi1ZDaJr2woavlQYQbONe6oeoCpUQ3I/H1+f0X3ajDJw7SwORS27Qpeja/B9SQhYsr
         VTCxTcyTb2UAZhTUGcO5XLDFqnJvmePW32zgnh5czlwfIO2S/joR54lD+eC33J3CFtxg
         nGBJYcT1I0mHq55kamckX8JPc0oyu+KEgyFlPBdMsyB/p5FBajr9gBaV6+DfZRjkY3Yv
         bMGA==
X-Gm-Message-State: APjAAAXziS6uowyA0HE/z1dmyi2bXWAAnX/CZHpyMCAg0QND/0ocudPx
        cLqsbMulMu2JSdQhvpd9HdLIvA==
X-Google-Smtp-Source: APXvYqwDSr3ftmtzGq2Eavu2mXsep/ph3M2uO8tVmzY2rXGXL7dsLXs+WeafPr3rFrhn3KEV7e5wNQ==
X-Received: by 2002:a0d:ea91:: with SMTP id t139mr16181530ywe.119.1559814559608;
        Thu, 06 Jun 2019 02:49:19 -0700 (PDT)
Received: from localhost.localdomain (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id 85sm357652ywm.64.2019.06.06.02.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 02:49:18 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v2 2/4] perf augmented_raw_syscalls: Remove duplicate macros
Date:   Thu,  6 Jun 2019 17:48:43 +0800
Message-Id: <20190606094845.4800-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606094845.4800-1-leo.yan@linaro.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro SYS_EXECVE has been defined twice, remove the duplicate one.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/examples/bpf/augmented_raw_syscalls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/examples/bpf/augmented_raw_syscalls.c b/tools/perf/examples/bpf/augmented_raw_syscalls.c
index 68a3d61752ce..5c4a4e715ae6 100644
--- a/tools/perf/examples/bpf/augmented_raw_syscalls.c
+++ b/tools/perf/examples/bpf/augmented_raw_syscalls.c
@@ -90,7 +90,6 @@ struct augmented_filename {
 /* syscalls where the second arg is a string */
 
 #define SYS_PWRITE64            18
-#define SYS_EXECVE              59
 #define SYS_RENAME              82
 #define SYS_QUOTACTL           179
 #define SYS_FSETXATTR          190
-- 
2.17.1

