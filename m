Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF33369593
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242689AbhDWPGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhDWPGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:06:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B215BC061574;
        Fri, 23 Apr 2021 08:06:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q10so35371755pgj.2;
        Fri, 23 Apr 2021 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jlFjeMrY51eGzmAt0epcO53og1wArwrENzvx0COGPak=;
        b=PtU4XlGmecTNXArYLD++y1GuaubvrOM/KcIlXiV1jcu/i57++tSkCZd4oS1QJ3r7rU
         9MPZswQreE7ZuL2as4hhHaDHG2NsK02bdfCJMqvrb64P7tAtF53i3P3w98TuYYF1Wru+
         7TcW63YJ0D2bYOX9eQcM87iOJa1LCwQtzCWfBbmJZ62bnmwLOLsl4wjKoWBDTcGsRzQY
         2dULvycmwoiOkQcnXKZ8fooRBM14ISgfcWp9qavGmzoljY9qhoywNrvkUSF88+tGNeWg
         Kl0O/9IhRkCHBTSSAAhxiti8cxs3Msk26lMBJtf+83Ea5nCBGcrikq/Lk98rZw89XR18
         tK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jlFjeMrY51eGzmAt0epcO53og1wArwrENzvx0COGPak=;
        b=oq9QUHp4xuXJVuy6jZkOwQ0/43Sh+8GL/CgXHYE1o81/3nFdVdPo2foiGDOvxesUWU
         XD2diQkNpjHB4IPdGXrL9DO359LnMqKfbZvgCqoexmYIBj4Ug6+JWljAb1nB5f9batn1
         33HEZZ9XIRG4ujVioe6Qk3sAfSXXh7LMzNrvCBW91eppmD2lQvr7MaNvVZ66xvcq3Sam
         tX/5Jk72XLJzgYvXViirx0dtCcLxy58+gItmyNoXLhJ6hCD/8egfiLjSw2AJBFdyU1hp
         f/woiqY0Iuc2WWywhD2Py8If6cis4RoodWmL49HnvSgPMIWPXh2d3+YDlsXKRbJD9MfZ
         3dPw==
X-Gm-Message-State: AOAM53123WCfyCb4trEsmyIDiZN3oAl1q29xqnk5IwoQKv0yWzYOVSCD
        eDquYHswgWKOMe3eILvWSKWcOf0f1+pijw==
X-Google-Smtp-Source: ABdhPJwZI5oxOvrQzNPmk8mB47BPs62/TKrfesMcU/KyyaHNPict7FiGVfl8jXxJGzHfdKwFwHGU0Q==
X-Received: by 2002:a62:82c8:0:b029:25a:b502:e1aa with SMTP id w191-20020a6282c80000b029025ab502e1aamr4203677pfd.64.1619190364924;
        Fri, 23 Apr 2021 08:06:04 -0700 (PDT)
Received: from localhost ([112.79.255.145])
        by smtp.gmail.com with ESMTPSA id n11sm5576399pff.96.2021.04.23.08.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:06:04 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 0/3] Add TC-BPF API
Date:   Fri, 23 Apr 2021 20:35:57 +0530
Message-Id: <20210423150600.498490-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the fourth version of the TC-BPF series.

It adds a simple API that uses netlink to attach the tc filter and its bpf
classifier. Currently, a user needs to shell out to the tc command line to be
able to create filters and attach SCHED_CLS programs as classifiers. With the
help of this API, it will be possible to use libbpf for doing all parts of bpf
program setup and attach.

Changelog contains details of patchset evolution.

In an effort to keep discussion focused, this series doesn't have the high level
TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
hence that will be submitted as a separate patchset.

The individual commit messages contain more details, and also a brief summary of
the API.

Changelog:
----------
v3 -> v4
v3: https://lore.kernel.org/bpf/20210420193740.124285-1-memxor@gmail.com

 * We add a concept of bpf_tc_ctx context structure representing the attach point.
   The qdisc setup and delete is tied to this object's lifetime if it succeeds
   in creating the clsact qdisc when the attach point is BPF_TC_INGRESS or
   BPF_TC_EGRESS. Qdisc is only deleted when there are no filters attached to
   it. The struct itself is opaque to the user.
 * Refactor all API functions to take ctx.
 * Remove bpf_tc_info, bpf_tc_attach_id, instead reuse bpf_tc_opts for filling
   in attributes in various API functions (including query).
 * Explicitly document the expectation of each function regarding the opts
   fields that must be set/unset. Add some small notes for the defaults chosen
   by the API.
 * Rename bpf_tc_get_info to bpf_tc_query
 * Keep the netlink socket open in the context structure to save on open/close
   cycles for each operation.
 * Miscellaneous adjustments due to keeping the socket open.
 * Rewrite the tests, and also add tests for verifying all preconditions of the
   TC-BPF API.
 * Use bpf skeleton API in examples and tests.

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

 tools/lib/bpf/libbpf.h                        |  92 ++++
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/netlink.c                       | 515 +++++++++++++++++-
 tools/lib/bpf/nlattr.h                        |  48 ++
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 204 +++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
 6 files changed, 854 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

--
2.30.2

