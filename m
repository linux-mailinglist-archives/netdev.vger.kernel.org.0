Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3315F389018
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347142AbhESOPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240132AbhESOPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:11 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CEBC06175F;
        Wed, 19 May 2021 07:13:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f19-20020a05600c1553b02901794fafcfefso2910479wmg.2;
        Wed, 19 May 2021 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbHUTDLuMB6pIOxs8p0VNd1MCvB6Nfy/ShgHNNj7/Yo=;
        b=JqC56zZgjLrd6k0/8rlzrpRcWoP7C2iSTTp7RtIE8zlEbZ3fMYHdYUOP459sU5H3pI
         t9S7q0Lpmu6PuW8vQBTl+aUba3etyUO6BRE/9jF0M8xDOsQ5v2Ca35/Q5NBOcbToBT+s
         GbhSUI09FwQkTXoR92bRIN5VKUXRvP7nUATK2hbNDILdChBRBf5LUPJ98B1wJz1qEaTc
         GlUN/isz+msU3cn+LzPjPEY02CFN2yTtD+LeP2QNg9ntM4ccbRc8NLwiV9NFtSJhLs3A
         NVDiWXhsShSAOj9IJJuWlPkcE/FB4GDrMj82iqaSrucARtIPINgaJH3ocOod01YQk6o8
         xDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbHUTDLuMB6pIOxs8p0VNd1MCvB6Nfy/ShgHNNj7/Yo=;
        b=nWULpNpqiwuOAUZeFBVdrZGi7UI8nNL20x1rxU3G/rDZ0URnWKOVSS9RXHaGatOZZ0
         t3uabJ0rGCKMROEluzhmG9VZ22GriA6og0//ekN21sLNNy/AHO8HkdzukMJhTyR+CVt9
         w0p5OAPn4b4pgY7Mov9e01oBYFbQEqUXpMQSslmALyyPyPJsM9Govwr3sARMT7eQJKan
         zSvQEL7jm5qOkBhhZRbTmoL0SbJZL23bfFGS9r8zI+QJcKlV5O55UZ4uBiviJjTlsBBb
         ecxl73OA2fPGjzbQiy/1JKjJ83et4xwnNPPGdVpmIqSzBl7taWhizD4q2MQMFTaqs4eO
         pSrA==
X-Gm-Message-State: AOAM533q59j7bjpZ3LkCyPPgAy/ID62/4NHUyef/JdgInyHyxzTXzoBR
        oJAghGnO6D1K8VrxONsGt0O7WZqQra/yUyKJ
X-Google-Smtp-Source: ABdhPJyH1EPxE7vJoLh++X0LKIjxgLKfPAzbSKMwLR+3AJ2EmFyCKtBGYruLiohI/HtmlXkvATSS7w==
X-Received: by 2002:a1c:7e45:: with SMTP id z66mr11788309wmc.126.1621433629967;
        Wed, 19 May 2021 07:13:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:13:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [RFC v2 00/23] io_uring BPF requests
Date:   Wed, 19 May 2021 15:13:11 +0100
Message-Id: <cover.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main problem solved is feeding completion information of other
requests in a form of CQEs back into BPF. I decided to wire up support
for multiple completion queues (aka CQs) and give BPF programs access to
them, so leaving userspace in control over synchronisation that should
be much more flexible that the link-based approach.

For instance, there can be a separate CQ for each BPF program, so no
extra sync is needed, and communication can be done by submitting a
request targeting a neighboring CQ or submitting a CQE there directly
(see test3 below). CQ is choosen by sqe->cq_idx, so everyone can
cross-fire if willing.

A bunch of other features was added to play around (see v1 changelog
below or test1), some are just experimental only. The interfaces are
not even close to settle.
Note: there are problems known, one may live-lock a task, unlikely
to happen but better to be aware.

For convenience git branch for the kernel part is at [1],
libbpf + examples [2]. Examples are written in restricted C and libbpf,
and are under examples/bpf/, see [3], with 4 BPF programs and 4
corresponding test cases in uring.c. It's already shaping interesting
to play with.

test1:            just a set of use examples for features
test2/counting:   ticks-react N times using timeout reqs and CQ waiting
test3/pingpong:   two BPF reqs do message-based communication by
                  repeatedly writing a CQE to another program's CQ and
                  waiting for a response
test4/write_file: BPF writes N bytes to a file keeping QD>1

[1] https://github.com/isilence/linux/tree/ebpf_v2
[2] https://github.com/isilence/liburing/tree/ebpf_v2
[3] https://github.com/isilence/liburing/tree/ebpf_v2/examples/bpf

since v1:
- several bug fixes
- support multiple CQs
- allow BPF requests to wait on CQs
- BPF helpers for emit/reap CQE
- expose user_data to BPF program
- sleepable + let BPF read/write from userspace

Pavel Begunkov (23):
  io_uring: shuffle rarely used ctx fields
  io_uring: localise fixed resources fields
  io_uring: remove dependency on ring->sq/cq_entries
  io_uring: deduce cq_mask from cq_entries
  io_uring: kill cached_cq_overflow
  io_uring: rename io_get_cqring
  io_uring: extract struct for CQ
  io_uring: internally pass CQ indexes
  io_uring: extract cq size helper
  io_uring: add support for multiple CQs
  io_uring: enable mmap'ing additional CQs
  bpf: add IOURING program type
  io_uring: implement bpf prog registration
  io_uring: add support for bpf requests
  io_uring: enable BPF to submit SQEs
  io_uring: enable bpf to submit CQEs
  io_uring: enable bpf to reap CQEs
  libbpf: support io_uring
  io_uring: pass user_data to bpf executor
  bpf: Add bpf_copy_to_user() helper
  io_uring: wire bpf copy to user
  io_uring: don't wait on CQ exclusively
  io_uring: enable bpf reqs to wait for CQs

 fs/io_uring.c                  | 794 +++++++++++++++++++++++++++------
 include/linux/bpf.h            |   1 +
 include/linux/bpf_types.h      |   2 +
 include/uapi/linux/bpf.h       |  12 +
 include/uapi/linux/io_uring.h  |  15 +-
 kernel/bpf/helpers.c           |  17 +
 kernel/bpf/syscall.c           |   1 +
 kernel/bpf/verifier.c          |   5 +-
 tools/include/uapi/linux/bpf.h |   7 +
 tools/lib/bpf/libbpf.c         |   7 +
 10 files changed, 722 insertions(+), 139 deletions(-)

-- 
2.31.1

