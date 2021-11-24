Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1745B6BA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbhKXIpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:45:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241502AbhKXIod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u/va+vlehAJlaxnJ1ZxySwl63uZqtCxIq5+CeD0JTug=;
        b=B3zkKhcWjDONF5v00LAQ8W9Z7LGb4kkIXRnHXfthsLJzDwZR9qTScc9XKvJI5BZg6jZnIR
        Vu43Olx/sJXtsz4xd/UtBNnNcwZHfhroFm652OhDflTEq0G2u65en7yKzFyfnEvDGpSivC
        ETMHeG5wXpG5ZM0G713xn3VgkBp7QRc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-RZ13yoiLNc6GHitaZ9WZyA-1; Wed, 24 Nov 2021 03:41:22 -0500
X-MC-Unique: RZ13yoiLNc6GHitaZ9WZyA-1
Received: by mail-wr1-f71.google.com with SMTP id o4-20020adfca04000000b0018f07ad171aso286117wrh.20
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u/va+vlehAJlaxnJ1ZxySwl63uZqtCxIq5+CeD0JTug=;
        b=1sjmv/5sKJe6aQFG3ScvknhYxYIvnDgbjcD9+9G07wJWxRkdgYTqexWugn2zDtsf+C
         xLLxB01PA2TDuM/I5DTWW9jG47t2/o09t/jWQFR5dVVX5/wpeQ2FBP6fvt7XUoeOJlGR
         b1oBz4grZJVENigMOzKeL3BW/OTR67R9wKL+Vuuimv7v7nDUMn6F886zpeclVRP7+IIN
         2eKzCCaxVJpLAsPgCW+xzdpMLqs55H4ImPxXoyR6gZoOdkxuDr+Xq8t0QxrN9r/sqLgS
         /xE/muPmYYh55O78oKQTivu9b5E8b2MKdgNVhn9l2hDCrcUEr7hYMYhoCqnsIynug+TJ
         itpg==
X-Gm-Message-State: AOAM531m+cp4265Nb4WfT9YiooV1tFLDbV6oA1mcua/XPRZQgTqAkUIr
        sjpV4GNQtIUOFzF68evaBgUQPbW2uYX6Y0aCyWPc2Lhoql73MoFnsEk91FHI2SjQFooAWYG8xVh
        GE3Xg2KgyQRkwat/7
X-Received: by 2002:a5d:47a1:: with SMTP id 1mr15880044wrb.436.1637743280718;
        Wed, 24 Nov 2021 00:41:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyWGTplK/9gxTkHrPX7ToYBzdn9CjvD6F3A+rSgEpL5LIhBlGtlV2H4nGfmNsCx7aWrxZljvg==
X-Received: by 2002:a5d:47a1:: with SMTP id 1mr15880016wrb.436.1637743280545;
        Wed, 24 Nov 2021 00:41:20 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id bg12sm5272528wmb.5.2021.11.24.00.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:20 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [RFC 0/8] perf/bpf: Add batch support for [ku]probes attach
Date:   Wed, 24 Nov 2021 09:41:11 +0100
Message-Id: <20211124084119.260239-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
adding support to create multiple kprobes/uprobes within single
perf event. This way we can associate single bpf program with
multiple kprobes.

Sending this as RFC because I'm not completely sure I haven't
missed anything in the trace/events area.

Also it needs following uprobe fix to work properly:
  https://lore.kernel.org/lkml/20211123142801.182530-1-jolsa@kernel.org/

Also available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  bpf/kuprobe_batch

thanks,
jirka


---
Jiri Olsa (8):
      perf/kprobe: Add support to create multiple probes
      perf/uprobe: Add support to create multiple probes
      libbpf: Add libbpf__kallsyms_parse function
      libbpf: Add struct perf_event_open_args
      libbpf: Add support to attach multiple [ku]probes
      libbpf: Add support for k[ret]probe.multi program section
      selftest/bpf: Add kprobe multi attach test
      selftest/bpf: Add uprobe multi attach test

 include/uapi/linux/perf_event.h                            |   1 +
 kernel/trace/trace_event_perf.c                            | 214 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 kernel/trace/trace_kprobe.c                                |  47 ++++++++++++++++---
 kernel/trace/trace_probe.c                                 |   2 +-
 kernel/trace/trace_probe.h                                 |   6 ++-
 kernel/trace/trace_uprobe.c                                |  43 +++++++++++++++--
 tools/include/uapi/linux/perf_event.h                      |   1 +
 tools/lib/bpf/libbpf.c                                     | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 tools/lib/bpf/libbpf.h                                     |  25 +++++++++-
 tools/lib/bpf/libbpf_internal.h                            |   5 ++
 tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c |  83 +++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/multi_uprobe_test.c |  97 ++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/multi_kprobe.c           |  58 +++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/multi_uprobe.c           |  26 +++++++++++
 14 files changed, 765 insertions(+), 78 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_uprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_kprobe.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_uprobe.c

