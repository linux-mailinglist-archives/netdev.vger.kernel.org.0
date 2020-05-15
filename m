Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8D1D5C0B
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgEOWFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOWFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:05:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07BBC061A0C;
        Fri, 15 May 2020 15:05:51 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id s10so4364910iog.7;
        Fri, 15 May 2020 15:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=fJCcmDWv9i650K++RtYXkBDXQKpfGbJx5ifHnvlC5xc=;
        b=ThaIx8TtF5a3mFBJPP8REl+mi+kOtJi95TKRNbjaioXv3WNCwpF1nJMiFlwFNukQEn
         lfHRWgzCpMIrkZSyLyf3D8u/4s+OHllXq+euVpOxAyk6EC34nsmy5M5fnWpvEoIYsA+L
         9x9Sjmi4gIBZyljCA0ihjXdH1iap9xh4cVhlbWFfRgYXlAGhfYwED2EXFi5SJ5d9PmNo
         BKdwjxgup3ic2h5P+/LiV7crZmSLVeSvPyCx2dzG5mc6BqiZrHMLDZdWGpkrckJYxMA6
         nfXZ5fi0ZdbAEWHSG5YuXjRk3net0TVZg8Jtvdij7POY84gProkT1hVdDRGFfDui69ae
         s9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=fJCcmDWv9i650K++RtYXkBDXQKpfGbJx5ifHnvlC5xc=;
        b=b838Wx1OJaFoGKoT2MvfFfnEK6qOkC0rSTgFkby7ikUJELVCqrMGa8+6vyvxZvlKAI
         qxJbubHdCQZHgEQPQX/kYfpIMnmY0mhABTePk8UVqYoa9LDoEhYnl5qPNotlC5xrukJ0
         1NGfALtwlQXqQg9yLMz/Yjn3AY/ggm6TjusHK2YzzLB3WktXyRSUuhxujFIw3YaZYhey
         P8QAxvSpUERt7QBlSmxSO7kFpVAU48IJ5BUX/UQ9AUL71N3iFQ54XuCGmGB6bWTETYrR
         H7Ia7IBWXy7LXrjM3pcJGW4e58xmEoMckmd/VAizDIxciZHuXchGiVccsK0lZqfPbkCK
         Z2bw==
X-Gm-Message-State: AOAM532VmFEKW1ix+o4u1zJW4vBCTbqQp2HIlvDQKkhxzWNNcmTJQ9E3
        VF/wEaFZsT6u0ShNDko9WCk=
X-Google-Smtp-Source: ABdhPJxzyOr4+dEmwAYEOB+C6FNXCW4je/ekwHRG51Px/fQ+k0I2n/WKUBjOwK3yKfoaaf7VqVMXbA==
X-Received: by 2002:a5e:a80e:: with SMTP id c14mr3765244ioa.3.1589580351199;
        Fri, 15 May 2020 15:05:51 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 80sm1076118iou.44.2020.05.15.15.05.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:05:50 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/5] bpf: Add sk_msg and networking helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:05:36 -0700
Message-ID: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds helpers for sk_msg program type and based on feedback
from v1 adds *_task_* helpers and probe_* helpers to all networking
programs with perfmon_capable() capabilities.

The list of helpers breaks down as follows,

Networking with perfmon_capable() guard (patch2):

 BPF_FUNC_get_current_task
 BPF_FUNC_current_task_under_cgroup
 BPF_FUNC_probe_read_user
 BPF_FUNC_probe_read_kernel
 BPF_FUNC_probe_read_user_str
 BPF_FUNC_probe_read_kernel_str

Added to sk_msg program types (patch1,3):

 BPF_FUNC_perf_event_output
 BPF_FUNC_get_current_uid_gid
 BPF_FUNC_get_current_pid_tgid
 BPF_FUNC_get_current_cgroup_id
 BPF_FUNC_get_current_ancestor_cgroup_id
 BPF_FUNC_get_cgroup_classid

 BPF_FUNC_sk_storage_get
 BPF_FUNC_sk_storage_delete

For testing we create two tests. One specifically for the sk_msg
program types which encodes a common pattern we use to test verifier
logic now and as the verifier evolves.

Next we have skb classifier test. This uses the test run infra to
run a test which uses the get_current_task, current_task_under_cgroup,
probe_read_kernel, and probe_reak_kernel_str.

Note we dropped the old probe_read variants probe_read() and
probe_read_str() in v2.

v1->v2:
 Pulled generic helpers *current_task* and probe_* into the
 base func helper so they can be used more widely in netowrking scope.

 BPF capabilities patch is now in bpf-next so use perfmon_capable() check
 instead of CAP_SYS_ADMIN.

 Drop old probe helpers, probe_read() and probe_read_str()

 Added tests. 

 Thanks to Daniel and Yonghong for review and feedback.

---

John Fastabend (5):
      bpf: sk_msg add some generic helpers that may be useful from sk_msg
      bpf: extend bpf_base_func_proto helpers with probe_* and *current_task*
      bpf: sk_msg add get socket storage helpers
      bpf: selftests, add sk_msg helpers load and attach test
      bpf: selftests, test probe_* helpers from SCHED_CLS


 include/uapi/linux/bpf.h                           |    2 +
 kernel/bpf/helpers.c                               |   27 +++++++++
 kernel/trace/bpf_trace.c                           |   16 +++---
 net/core/filter.c                                  |   31 +++++++++++
 tools/include/uapi/linux/bpf.h                     |    2 +
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 +++++++++++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   57 ++++++++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   48 +++++++++++++++++
 9 files changed, 238 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

--
Signature
