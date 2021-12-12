Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0C6471A71
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhLLNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhLLNrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:47:32 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2752FC0613F8
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:47:32 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w1so43953686edc.6
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqWs8DPwgrK4V8do+h3/zlOpIdi25/lNlJflq/UjYQE=;
        b=AHq59JGlV0k7iw3rdhr5yfTpsM6dqF9Ki2s8OAhjW91L+zM6coM6t3mrEX9YOC7QXC
         SdFFStr9Q/4IALFGkySkl1ZLsySsWiZwg50xlTLX+hzretjoScM4tbfmaBBM6YFvtdGI
         1SLKcjWy+GB23J4BFc3Fv/Ob9hekQb8xRSYukTSbh4jL+gd8NlQWBrdmUsvv+u2qGG/5
         V0VMiN1BBLd21hSxSIf4X0AwVuQLqwK7R1GJD22igEg7jMe1ZjUEP3U7lHrXaaZ6BVK5
         GuTCB2o3Bzji9Gx3G4MHjAE45YmjG2ejVbrZM2UXl6LPVO6gp14NDqsxXLTfWycAhpoL
         HTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqWs8DPwgrK4V8do+h3/zlOpIdi25/lNlJflq/UjYQE=;
        b=k441zhVV9NWM3le4GkMgUmu2cmqwBDmP4JZv0vXNy9oMVxH+pj17qtR3xMbf4mDc4F
         VpeNhlVk1EM5qEpW6g7dkFxbrlG4u/WowhajfrXsbMUYrucItisiShMlkdU5YwoGVwAo
         d0rTzTrbWRvNwx+8+Z0sBeqZQGL9cb+KGd79+iinBNwPRyk9ftIgcjTn9wNeNOYf1RBK
         ccTd63A4xLfSukuMvENDpkO+3uyRo7uh1LjZJd6Y+Xov1jlJCjW9LF9nAr9Ss33Y1ReS
         gNPiWhlL4BCBwQf1/9A8HoON+OinrI7jUdYnuyxaZCzKcxxIbhR4Ntn2qd9zdHfXF3gF
         tImw==
X-Gm-Message-State: AOAM533MCX2eME9OOMdOofJ/dzHIN+UiqQk4lM5LyN8wHI6Vi5d/KnBb
        qUEKvupE80Bxhs53V+zMap7vLQ==
X-Google-Smtp-Source: ABdhPJzDCfz3+3qv85xX++TCcQcIFr8NszHqqXCovx9fPQXwcS4W4cFGhV+xYEm2fPgBZRvXvNa//w==
X-Received: by 2002:a05:6402:5c9:: with SMTP id n9mr54686840edx.306.1639316850583;
        Sun, 12 Dec 2021 05:47:30 -0800 (PST)
Received: from localhost ([104.245.96.202])
        by smtp.gmail.com with ESMTPSA id oz31sm4543552ejc.35.2021.12.12.05.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 05:47:30 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 0/2] perf: Fix perf in non-root PID namespace
Date:   Sun, 12 Dec 2021 21:47:19 +0800
Message-Id: <20211212134721.1721245-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When perf tool runs in non-root PID namespace, it fails to gather the
correct process and namespace info for the profiled (forked) program
since it wrongly uses the non-root PID number to access '/proc' nodes.

To fix this issue, this patchset adds the checking if the perf tool runs
in the non-root namespace, if it is the case, perf tool reports error to
notify users to run perf tool in root PID namespace.  This can ensure
perf tool gathers correct process info for profiled program.

After applied this patchset:

  # unshare --fork --pid perf record -e cs_etm//u -a -- uname
  Perf runs in non-root PID namespace; please run perf tool in the root PID namespace for gathering process info.
  Couldn't run the workload!

  # perf record -e cs_etm//u -a -- unshare --fork --pid uname
  Couldn't synthesize bpf events.
  Linux
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.438 MB perf_test.data ]


Leo Yan (2):
  perf namespaces: Add helper nsinfo__is_in_root_namespace()
  perf evlist: Don't run perf in non-root PID namespace when launch
    workload

 tools/perf/util/evlist.c     |  7 ++++
 tools/perf/util/namespaces.c | 76 ++++++++++++++++++++++--------------
 tools/perf/util/namespaces.h |  2 +
 3 files changed, 55 insertions(+), 30 deletions(-)

-- 
2.25.1

