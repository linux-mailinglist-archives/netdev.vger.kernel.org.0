Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B85366047
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhDTTiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhDTTiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:38:17 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B89C06174A;
        Tue, 20 Apr 2021 12:37:45 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w6so11767012pfc.8;
        Tue, 20 Apr 2021 12:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQcbHkQRvAIVBM6QLR6pEb0EAXH5YyaL6ocR+yZBvXk=;
        b=Tx+Q7pIuhTc4YquaExj7b66YPOfHLSNsmeDiJ/GGvgFbHqTX4+pUwXAnHczB+wgZ9O
         VRLetM0h+rbXloJt1mRz7RFwM7jgNP8ujRdZjrAkCt7Qrza1L99hjsulx/Al+f4aMQnG
         aALV3JKlksxrSkknsFo6RMhfUS3pQ/N9URmXFPOKOPu+eFY8TsLtTb6qyYjdQPPyIGx8
         SB3JUfx2yxkHLhMlpC+UGgnMf/V9Wqe4T7/DktI6j8YskBh9UdnaPldKIURhuDNPYhwV
         9NVwSKINZrpMYTH1jxv06uX4rfiVkhQRNaZqBVWxu5HuaK5av6rhDourG+MjUvOqLUB2
         hrmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AQcbHkQRvAIVBM6QLR6pEb0EAXH5YyaL6ocR+yZBvXk=;
        b=B9MYi1iBN5lYHAViCrWoNgq1TxwAqwOH5Gg23ZSN2limhyLHny0RdEcpNB0eDqsVAL
         iDh9iITk0n2XqHZrXQ2MTVsxDXUD0A4qUEruEb4aSZxHFiHxhAGtc29aTK27n0cL+Rf5
         8Q4gmkRAQaE8WNfP/viIFl2liR9G/ht6jh16mhGoHinPTH2tCzK5PnDavxRbA3CmAUr1
         TBmohxhRDNV6dydAMnSYGne1mZLkWdSpbNxd6brTP3Hls3h9XH6G2h1ftQKkZrS64PYZ
         Th8CEOU+25fpxe2naNoJBM7nW2uBdV+kF3ddY1sYOJAxmYFG15rD173skYGjlQllyUUF
         1tLQ==
X-Gm-Message-State: AOAM532zW/QYQAcbB6RPWa+gJM6opFpESejnNv6xrWfy6LaaPAyRxsFv
        LmqUzMbjmmVeA4GVUKyGS/cFSUMEK1fp+g==
X-Google-Smtp-Source: ABdhPJxc45vmZthP/mC92Cl1LWQZg8o0Vrp5d+HAH4V2AsGp9R3IiEF+zFWTlPaVwLO4TGTac2vrrw==
X-Received: by 2002:a63:a47:: with SMTP id z7mr18160808pgk.350.1618947464809;
        Tue, 20 Apr 2021 12:37:44 -0700 (PDT)
Received: from localhost ([112.79.227.195])
        by smtp.gmail.com with ESMTPSA id i11sm16420532pfa.108.2021.04.20.12.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:37:44 -0700 (PDT)
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 0/3] Add TC-BPF API
Date:   Wed, 21 Apr 2021 01:07:37 +0530
Message-Id: <20210420193740.124285-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third version of the TC-BPF series.

It adds a simple API that uses netlink to attach the tc filter and its bpf
classifier. Currently, a user needs to shell out to the tc command line to be
able to create filters and attach SCHED_CLS programs as classifiers. With the
help of this API, it will be possible to use libbpf for doing all parts of bpf
program setup and attach.

Direct action is now always set, and currently no way to disable it has been
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
v2 -> v3
v2: https://lore.kernel.org/bpf/20210419121811.117400-1-memxor@gmail.com

 * bpf_tc_cls_* -> bpf_tc_* rename
 * bpf_tc_attach_id now only consists of handle and priority, the two variables
   that user may or may not set.
 * bpf_tc_replace has been dropped, instead a replace bool is introduced in
   bpf_tc_opts for the same purpose.
 * bpf_tc_get_info now takes attach_id for filling in filter details during
   lookup instead of requiring user to do so. This also allows us to remove the
   fd parameter, as no matching is needed as long as we have all attributes
   necessary to identify a specific filter.
 * A little bit of code simplification taking into account the change above.
 * priority and protocol are now __u16 members in user facing API structs to
   reflect actual size.
 * Patch updating pkt_cls.h header has been removed, as it is unused now.
 * protocol and chain_index options have been dropped in bpf_tc_opts,
   protocol is always set to ETH_P_ALL, while chain_index is set as 0 by
   default in the kernel. This also means removal of chain_index from
   bpf_tc_attach_id, as it is unconditionally always 0.
 * bpf_tc_cls_change has been dropped
 * selftest now uses ASSERT_* macros

v1 -> v2
v1: https://lore.kernel.org/bpf/20210325120020.236504-1-memxor@gmail.com

 * netlink helpers have been renamed to object_action style.
 * attach_id now only contains attributes that are not explicitly set. Only
   the bare minimum info is kept in it.
 * protocol is now an optional and always set to ETH_P_ALL.
 * direct-action mode is always set.
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

Kumar Kartikeya Dwivedi (3):
  libbpf: add helpers for preparing netlink attributes
  libbpf: add low level TC-BPF API
  libbpf: add selftests for TC-BPF API

 tools/lib/bpf/libbpf.h                        |  44 +++
 tools/lib/bpf/libbpf.map                      |   3 +
 tools/lib/bpf/netlink.c                       | 356 ++++++++++++++++--
 tools/lib/bpf/nlattr.h                        |  48 +++
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 +++++++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 +
 6 files changed, 605 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

--
2.30.2

