Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70888918
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 09:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfHJHWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 03:22:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47002 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfHJHWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 03:22:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id w3so9734763pgt.13
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 00:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SUoVe7v3rT/MuQ/nwpXN/VHHe+ExuqKtoNBajOsMZ6w=;
        b=wQJH7ETUQf/Dh4ez18JN84T3l+cjXjy09Eucj14X0AHuvosMhmvOogUX+atkAp20mg
         SmV0+RgkID9grGKgKmWpop/TOMD8i0v3r4+jQ9itYf1FiRZ28doVdPHOTRf6LYovTj4l
         0qsL3fBBtjZJwSpnrTtiPbQLj/IHWXapZo1y4q03jxmYWnwZKDFcc+Gjbyixt23U8y+E
         egXKOO7CqMkvduanDLWTKBdCTiTbpwSrLmRRSZnvzYkQsI2JOQ3bmQiMScqg41bMQ6To
         +lCMPz4rEH2MSbhrKFvLRkW0JkDkbDpoR+eHWJQ0F0M+RxwMwE11pr3jKvrGCWplkSYQ
         VPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SUoVe7v3rT/MuQ/nwpXN/VHHe+ExuqKtoNBajOsMZ6w=;
        b=M2tNk+T0G7tR+COy4rDsImaus7JoATi++3kWsLNoMY0rFxcOgz5OHX3+XXX5F2WEPf
         lbv6ikqZUv+dwbp78l4gSr2slehBGB8s3oFBXOQrm0gQj9jj6QgDZvJADtCQSbs+I3yJ
         hKCvVlLxShHgPAD1Z12T0L4UhUAMAqzF8P+NJ09HVdBYtguczUTLXSmZ4spX5bgJO+VJ
         8W1K6bW+tgk4J7LgKDcCXlIxOjz80wzFU85la2cfY5RTx/W75gw2frokKx+cajC6pvGJ
         N8g+1Env6mZn8VnwNNssYcsbOi6MgLeSiIZ2yfHN1IKLsymdi14zWO85R5w/LnGrFMY6
         p3Kw==
X-Gm-Message-State: APjAAAWrrasNCzHDS15204JvWMW1z3YgXVahXhunT3xaBjVLh39qa1w/
        mzCFoRU36QRlFqui8mR72en+mA==
X-Google-Smtp-Source: APXvYqzxkyBjWeBhMgjcf0AF5nqX5W6XCYqkY4vXD020qE0nR/UE9vKOK8Vq3UHm4Jv8dakQKhuC1w==
X-Received: by 2002:a63:124a:: with SMTP id 10mr20982007pgs.254.1565421732167;
        Sat, 10 Aug 2019 00:22:12 -0700 (PDT)
Received: from localhost.localdomain (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id l17sm24872660pgj.44.2019.08.10.00.22.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 10 Aug 2019 00:22:11 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Milian Wolff <milian.wolff@kdab.com>,
        Donald Yandt <donald.yandt@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Wei Li <liwei391@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mark Drayton <mbd@fb.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v4 1/2] perf machine: Support arch's specific kernel start address
Date:   Sat, 10 Aug 2019 15:21:34 +0800
Message-Id: <20190810072135.27072-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190810072135.27072-1-leo.yan@linaro.org>
References: <20190810072135.27072-1-leo.yan@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

machine__get_kernel_start() gives out the kernel start address; some
architectures need to tweak the start address so that can reflect the
kernel start address correctly.  This is not only for x86_64 arch, but
it is also required by other architectures, e.g. arm/arm64 needs to
tweak the kernel start address so can include the kernel memory regions
which are used before the '_stext' symbol.

This patch refactors machine__get_kernel_start() by adding a weak
arch__fix_kernel_text_start(), any architecture can implement it to
tweak its specific start address; this also allows the arch specific
code to be placed into 'arch' folder.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/arch/x86/util/machine.c | 10 ++++++++++
 tools/perf/util/machine.c          | 13 +++++++------
 tools/perf/util/machine.h          |  2 ++
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/perf/arch/x86/util/machine.c b/tools/perf/arch/x86/util/machine.c
index 1e9ec783b9a1..9f012131534a 100644
--- a/tools/perf/arch/x86/util/machine.c
+++ b/tools/perf/arch/x86/util/machine.c
@@ -101,4 +101,14 @@ int machine__create_extra_kernel_maps(struct machine *machine,
 	return ret;
 }
 
+void arch__fix_kernel_text_start(u64 *start)
+{
+	/*
+	 * On x86_64, PTI entry trampolines are less than the
+	 * start of kernel text, but still above 2^63. So leave
+	 * kernel_start = 1ULL << 63 for x86_64.
+	 */
+	*start = 1ULL << 63;
+}
+
 #endif
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f6ee7fbad3e4..603518835692 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2671,6 +2671,10 @@ int machine__nr_cpus_avail(struct machine *machine)
 	return machine ? perf_env__nr_cpus_avail(machine->env) : 0;
 }
 
+void __weak arch__fix_kernel_text_start(u64 *start __maybe_unused)
+{
+}
+
 int machine__get_kernel_start(struct machine *machine)
 {
 	struct map *map = machine__kernel_map(machine);
@@ -2687,14 +2691,11 @@ int machine__get_kernel_start(struct machine *machine)
 	machine->kernel_start = 1ULL << 63;
 	if (map) {
 		err = map__load(map);
-		/*
-		 * On x86_64, PTI entry trampolines are less than the
-		 * start of kernel text, but still above 2^63. So leave
-		 * kernel_start = 1ULL << 63 for x86_64.
-		 */
-		if (!err && !machine__is(machine, "x86_64"))
+		if (!err)
 			machine->kernel_start = map->start;
 	}
+
+	arch__fix_kernel_text_start(&machine->kernel_start);
 	return err;
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index ef803f08ae12..9cb459f4bfbc 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -278,6 +278,8 @@ void machine__get_kallsyms_filename(struct machine *machine, char *buf,
 int machine__create_extra_kernel_maps(struct machine *machine,
 				      struct dso *kernel);
 
+void arch__fix_kernel_text_start(u64 *start);
+
 /* Kernel-space maps for symbols that are outside the main kernel map and module maps */
 struct extra_kernel_map {
 	u64 start;
-- 
2.17.1

