Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FF71E00B7
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgEXQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgEXQu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:50:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28724C061A0E;
        Sun, 24 May 2020 09:50:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s69so7562934pjb.4;
        Sun, 24 May 2020 09:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=EZhgv/AuBcoqzCV6S9b1yh+jTf1ezpa6goCaGZvaxh0=;
        b=YwPQmpI9d8DzAFga40StUxy/ieSmC/yAOoOZaWh3tUBjedFtKlGZ0N5FChLi47JwcV
         sj7623eQlJyhWXj6DO+jpChmHfvbIKi/FzbGLmvxyp80WQ8YL++cMtMZinBcUCAJm8sg
         Re6Cuy48SychCN6uHfwFrUposYD4eeOT8hWsCwgA9w/ZsKgLy7fiNbjljv1S473JDTV9
         7Tw1PXmJuRK8wR8xeQvK5xqLNY2PpgbfG52n1wMQRDvl70BZ07G34cC5v6uwqdpFfwr8
         Nvwci/gtF6HRhY61hw20hWfIn7M10NcNVnaFhkqj5w+76CHDeKyMdZzDh8TJoZdssOzj
         K41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=EZhgv/AuBcoqzCV6S9b1yh+jTf1ezpa6goCaGZvaxh0=;
        b=b7J50AconMyM6k3eKnLjpYIOUKecaurXuBGEgFxO3IXTnhGwzH3u+mFMu8TkhKwxk+
         nWT1JFUZKVbmLzNEJgsJJoy6AmPOcbf7A52xbm1SoO9IYOtCvzCP2h7N+uGDTOOj7a6/
         Np/o8idOeoKT2Ocm8H73GK8E4SCvuFROnpTae/yT4sh0nMBZQw3cEbpfYHBVT8Gsi8Rt
         X/MtvfCl90HAiQiR/K5bl/OdlRwkEaEkPsD1Eg3sd6QgyU/cvG2b5UNlciwHrEPYnbus
         kBgXPdvQV4MRgdxiQZgrYlIlVnSGzo8SArwr1ETJvdaDPKvYfn/h3qiwMYLzpovogW5b
         hcVQ==
X-Gm-Message-State: AOAM531OmWrtSuwWCI8aSUdFW8oQ/lb9yfL/ttpvCZYocTzqYvhluQtA
        DZkEm1aXPCne9Ay81XHiRkVBQJYo
X-Google-Smtp-Source: ABdhPJzGlW0kFK/dUzrcccBqIw5yp2omfFdjwlA6L4NV03RwAPFlUYklu4Yyw1RN1AVrI/xy8EpKtw==
X-Received: by 2002:a17:902:b185:: with SMTP id s5mr10934858plr.304.1590339027635;
        Sun, 24 May 2020 09:50:27 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x6sm11701876pfn.90.2020.05.24.09.50.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:50:26 -0700 (PDT)
Subject: [bpf-next PATCH v5 0/5] bpf: Add sk_msg and networking helpers
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:50:12 -0700
Message-ID: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
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

v4->v5:
 Remove BPF_FUNC_current_task_under_cgroup because it requires a
 valid current and at least at the moment seems less usable in all
 contexts. It also probably doesn't need to be guarded by perfoman_cap.
 We can add it on a per type basis when its needed or decide later
 after some more experience that its universally useful.

v3->v4:
 patch4, remove macros and put code inline, add test cleanup, remove
 version in bpf program.
 patch5, use ctask returned from task_under_cgroup so that we avoid
 any potential compiler warnings, add test cleanup, use BTF style
 maps.

v2->v3:
 Pulled header update of tools sk_msg_md{} structure into patch3 for
 easier review. ACKs from Yonghong pushed into v3

v1->v2:
 Pulled generic helpers *current_task* and probe_* into the
 base func helper so they can be used more widely in networking scope.
 BPF capabilities patch is now in bpf-next so use perfmon_capable() check
 instead of CAP_SYS_ADMIN.

 Drop old probe helpers, probe_read() and probe_read_str()

 Added tests.

 Thanks to Daniel, Yonghong, and Andrii for review and feedback.

---

John Fastabend (5):
      bpf, sk_msg: add some generic helpers that may be useful from sk_msg
      bpf: extend bpf_base_func_proto helpers with probe_* and *current_task*
      bpf, sk_msg: add get socket storage helpers
      bpf, selftests: add sk_msg helpers load and attach test
      bpf, selftests: test probe_* helpers from SCHED_CLS


 include/uapi/linux/bpf.h                           |    2 +
 kernel/bpf/helpers.c                               |   24 ++++++++++
 kernel/trace/bpf_trace.c                           |   10 ++--
 net/core/filter.c                                  |   31 +++++++++++++
 tools/include/uapi/linux/bpf.h                     |    2 +
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 +++++++++++++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   35 +++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   28 ++++++++++++
 .../selftests/bpf/progs/test_skmsg_load_helpers.c  |   47 ++++++++++++++++++++
 9 files changed, 204 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skmsg_load_helpers.c

--
Signature
