Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76051364176
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhDSMSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhDSMSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:18:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE8EC06174A;
        Mon, 19 Apr 2021 05:18:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s22so3021081pgk.6;
        Mon, 19 Apr 2021 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FS9eUWQBzPFmXBIhw/M3KyM94oXuT5zWRYZ7FLuaBsw=;
        b=NN5ZhbKG64vkIPJ97wrmD/nLO78n9wn5ujp5E8YK+cdAjRopD1vhK9vNWn8foA1nsI
         hPyKhJfaUzxGV7NDnlzELkmMVAc5NK01MTlp6umFOOzwKJ2CvQds2qLOx3cUTXvzbx/b
         y/C8FZlLJk21jg4yFnBp9WITHXEAfMfCuRf3ctaUquzKmlTBLJjqQkkBpobCTGm15vm7
         SQENcxFCQ/zwBF/MNjF6ZCK5CZ6WaDT3WY2mouJoHTp3bXfK2UHUiR+1OVZW1EYKnQr5
         Hv/P5ySDrfKSC2WCPIQ9J3ZuEzhP79LUxDBNpUyw7n41ao4j9qKt+DwCdyWUqgMQ0mQQ
         7ZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FS9eUWQBzPFmXBIhw/M3KyM94oXuT5zWRYZ7FLuaBsw=;
        b=fsN8eF8jmx4088X0/ITAn/KiHoVmM0JNaT4ZA0toPgodjTZOeo9dJzJ7z4/UU7fpjI
         KE7DrunezS5emFLFAs9Qw2Gvo3hmJINqeuw0JzkRKHdjJzLi7oC0rUxq6ZpdhzSiqFga
         DmzQVo0pV6+8pHtxa4XnJW9Asszo6/6YxXyOWyq9FasrqQKmXUG/Tmg7LrzsLPrVZcA3
         22k4qtyTlvy6cBR16M+xyiT644I5hVkqcyAohePuGbw2DdrjQ3PJgtmMnpF7gkmCGuD+
         w5xMwjDuxgyTTa5jQJ46AfdWKh1jshThUxPy75MbN6dZAw+ybVl+6629Czj+HZYD7g4I
         Ld1w==
X-Gm-Message-State: AOAM531UWD+wGO7fFxWmcN1BSZR0RF+sr8uZvZT2MQeuiaZwssulJRNd
        OrMx2cZCASetreiX7csNsqcO9b7kc78y1A==
X-Google-Smtp-Source: ABdhPJwZgeMHmOXKaC9e+0OTJsfpFxZm/JVQYrotQH09pstPM+DB6lFrasvDOw9VWyLR6atojEZ5mg==
X-Received: by 2002:a63:1a5e:: with SMTP id a30mr11692093pgm.156.1618834701808;
        Mon, 19 Apr 2021 05:18:21 -0700 (PDT)
Received: from localhost ([112.79.253.181])
        by smtp.gmail.com with ESMTPSA id 22sm14625765pjl.31.2021.04.19.05.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:18:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 0/4] Add TC-BPF API
Date:   Mon, 19 Apr 2021 17:48:07 +0530
Message-Id: <20210419121811.117400-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second version of the TC-BPF series.

It adds a simple API that uses netlink to attach the tc filter and its bpf
classifier. Currently, a user needs to shell out to the tc command line to be
able to create filters and attach SCHED_CLS programs as classifiers. With the
help of this API, it will be possible to use libbpf for doing all parts of bpf
program setup and attach.

Direct action is now the default, and currently no way to disable it has been
provided. This also means that SCHED_ACT programs are a lot less useful, so
support for them has been removed for now. In the future, if someone comes up
with a convincing use case where the direct action mode doesn't serve their
needs, a simple extension that allows disabling direct action mode and passing
the list of actions that would be bound to the classifier can be added.

In an effort to keep discussion focused, this series doesn't have the high level
TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
hence that will be submitted as a separate patchset.

The individual commit messages contain more details, and also a brief summary of
the API.

Changelog:
----------
v1 -> v2
v1: https://lore.kernel.org/bpf/20210325120020.236504-1-memxor@gmail.com

 * netlink helpers have been renamed to object_action style.
 * attach_id now only contains attributes that are not explicitly set. Only
   the bare minimum info is kept in it.
 * protocol is now an optional and defaults to ETH_P_ALL.
 * direct-action mode is default, and cannot be unset for now.
 * skip_sw and skip_hw options have also been removed.
 * bpf_tc_cls_info struct now also returns the bpf program tag and id, as
   available in the netlink response. This came up as a requirement during
   discussion with people wanting to use this functionality.
 * support for attaching SCHED_ACT programs has been dropped, as it isn't
   useful without any support for binding loaded actions to a classifier.
 * the distinction between dev and block API has been dropped, there is now
   a single set of functions and user has to pass the special ifindex value
   to indicate operation on a shared filter block on their own.
 * The high level API returning a bpf_link is gone. This was already non-
   functional for pinning and typical ownership semantics. Instead, a separate
   patchset will be sent adding a bpf_link API for attaching SCHED_CLS progs to
   the kernel, and its corresponding libbpf API.
 * The clsact qdisc is now setup automatically in a best-effort fashion whenever
   user passes in the clsact ingress or egress parent id. This is done with
   exclusive mode, such that if an ingress or clsact qdisc is already set up,
   we skip the setup and move on with filter creation.
 * Other minor changes that came up during the course of discussion and rework.

Kumar Kartikeya Dwivedi (4):
  tools: pkt_cls.h: sync with kernel sources
  libbpf: add helpers for preparing netlink attributes
  libbpf: add low level TC-BPF API
  libbpf: add selftests for TC-BPF API

 tools/include/uapi/linux/pkt_cls.h            | 174 +++++++-
 tools/lib/bpf/Makefile                        |   3 +
 tools/lib/bpf/libbpf.h                        |  52 +++
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/netlink.c                       | 414 ++++++++++++++++--
 tools/lib/bpf/nlattr.h                        |  48 ++
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 112 +++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 +
 8 files changed, 789 insertions(+), 31 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

--
2.30.2

