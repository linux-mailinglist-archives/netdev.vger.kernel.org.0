Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724B6399607
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 00:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhFBWnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 18:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhFBWnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 18:43:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589ECC06174A;
        Wed,  2 Jun 2021 15:41:22 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso4683857wmi.3;
        Wed, 02 Jun 2021 15:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SMLKgtfzFTtNrhbiL6cD20E7gNbNd4sAIT8l+acqgE=;
        b=b6/s6tFIRIft9gCYchObMSOTJ02+08GMwVOVkZlGerz4Sj/HODJGkVnRhWfSh52dXx
         hWdeUV9x0a22x8J+7BROrn9EjDO5MfavRFS0w/PvRbruokRotdXnMwIxvMeOye78vK2I
         qyrPmQ0BKeZCMTjw0KYTxjKmRPVf0cq9MawSzrWVip8EoiKIsnXIZdV7MKHRPHfJJEPn
         AcSEwLcXb9Ns8b6DueMJLuQoX2HyJ6+bBryvsyROM41mLqrl1sJEJ9xz8GXoA6bCcEbH
         oVf0hDbnkpADv7cBTCBzLFowOi+qYb8QsnnFcjTNfQ55kuE4AdYuLZHO5HW8c/TGZYCb
         jMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7SMLKgtfzFTtNrhbiL6cD20E7gNbNd4sAIT8l+acqgE=;
        b=exsomPgJl99ntlMPO1PB9qTsnOxBVa/NMzG1zWcsAPhG78JLaZ54gbl+qb6VP+PfCu
         KABl+lAd/XKfnwOHkhIpgxATrTUwNaS7amDmlx+ETR9KvL8iXw4drJguluBOKQPbf5sK
         j315xzobHGdc2q7SEWAgykiX0HMv2c2o5FqFdX+Q4C4bHj7oUjyqlTv+640mw8WFarME
         SeWDOm2IpsUbmJB0GqTSPZ9zAMyGHwuo1bM7WoVwcIrFtR4aEu1pxYwmh0gZ+rAbN5DA
         rKzJnKzkKCMwhepqJEINZGetO26vHbx6FYjkzEJ00PqaOGOKeJvPw4qC/lvDlbqNALWx
         /pPw==
X-Gm-Message-State: AOAM532S0H1bySRiuty8btXL07GUJoq41Azx0dFEvBezfNsVUbBrTBtp
        SNKhDowY+97tEnWVmSo7Xxw=
X-Google-Smtp-Source: ABdhPJx68oQrhXRFKI2BC5VsXcE66i95OnCh99GSXYS8dNm9F0OWAXIyaAozg1vda20ltNHMcAAUMA==
X-Received: by 2002:a1c:1d14:: with SMTP id d20mr7160755wmd.177.1622673679238;
        Wed, 02 Jun 2021 15:41:19 -0700 (PDT)
Received: from honeypot.epfl.ch ([151.29.82.133])
        by smtp.googlemail.com with ESMTPSA id 11sm957010wmo.24.2021.06.02.15.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 15:41:18 -0700 (PDT)
From:   Riccardo Mancini <rickyman7@gmail.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>
Cc:     Riccardo Mancini <rickyman7@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] perf env: fix memory leak: free bpf_prog_info_linear
Date:   Thu,  3 Jun 2021 00:40:23 +0200
Message-Id: <20210602224024.300485-1-rickyman7@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASan reported a memory leak caused by info_linear not being
deallocated. The info_linear was allocated during
perf_event__synthesize_one_bpf_prog.
This patch adds the corresponding free() when bpf_prog_info_node
is freed in perf_env__purge_bpf.

$ sudo ./perf record -- sleep 5
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.025 MB perf.data (8 samples) ]

=================================================================
==297735==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 7688 byte(s) in 19 object(s) allocated from:
    #0 0x4f420f in malloc (/home/user/linux/tools/perf/perf+0x4f420f)
    #1 0xc06a74 in bpf_program__get_prog_info_linear /home/user/linux/tools/lib/bpf/libbpf.c:11113:16
    #2 0xb426fe in perf_event__synthesize_one_bpf_prog /home/user/linux/tools/perf/util/bpf-event.c:191:16
    #3 0xb42008 in perf_event__synthesize_bpf_events /home/user/linux/tools/perf/util/bpf-event.c:410:9
    #4 0x594596 in record__synthesize /home/user/linux/tools/perf/builtin-record.c:1490:8
    #5 0x58c9ac in __cmd_record /home/user/linux/tools/perf/builtin-record.c:1798:8
    #6 0x58990b in cmd_record /home/user/linux/tools/perf/builtin-record.c:2901:8
    #7 0x7b2a20 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
    #8 0x7b12ff in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
    #9 0x7b2583 in run_argv /home/user/linux/tools/perf/perf.c:409:2
    #10 0x7b0d79 in main /home/user/linux/tools/perf/perf.c:539:3
    #11 0x7fa357ef6b74 in __libc_start_main /usr/src/debug/glibc-2.33-8.fc34.x86_64/csu/../csu/libc-start.c:332:16

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
---
 tools/perf/util/env.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
index 9130f6fad8d54..bc5e4f294e9e9 100644
--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -144,6 +144,7 @@ static void perf_env__purge_bpf(struct perf_env *env)
 		node = rb_entry(next, struct bpf_prog_info_node, rb_node);
 		next = rb_next(&node->rb_node);
 		rb_erase(&node->rb_node, root);
+		free(node->info_linear);
 		free(node);
 	}
 
-- 
2.31.1

