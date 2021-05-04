Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E273723F6
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhEDAvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEDAvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 20:51:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A79C061574;
        Mon,  3 May 2021 17:50:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s22so5163183pgk.6;
        Mon, 03 May 2021 17:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbtRKPIgnx4ziqmpluE9KAPXup6DKcajzjr0GhOhvFo=;
        b=UzEmuQyW4u4neQv/rHfBETpjWQWnJ0bDPbOOU3Nr+z15nIQlDPu/z/u8YJxZqAg1XI
         to/AN4BS4g+7JkaT1xoVyMshvvl28V9xsxvhPfE17plykR7ThmvIYIAkvyz+cq3NCnaD
         y1fVSmaai+9b8k9C10WBdB2RE6bpPQRpNWR8uoODluClQv7Lzjfb5320PfHwzW3i3Fsg
         FKWMJMgtIcBaimnMgCmaZ4Em3ecXvHjBc4EG09hrZHzXXesnXEIs+FQoiXdzd3Cyy1Vv
         kT4P9pr0sUU6re8Y3/UfHeabnrp7rGvf9fF3orexfGpsbGNjtf4qQvv+9f6KLxZclZsk
         clyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NbtRKPIgnx4ziqmpluE9KAPXup6DKcajzjr0GhOhvFo=;
        b=k/fxCfUji/cM29RsQffBD/5mFjaw5jFvcKGUgc9C0Hm2hGzRkzAPOQkbwZnXlVZjmr
         kolrD0KOudEiZG/TMlts1q2hIW+Yrb72tj9HPRiBwh24H+lgoKVR1Iftc4M06GzLlEZi
         96W3TGcaXjwFXm7+YyXEewa9JygspRQsPwy45lHc/l8DylJ4zXqYzLvIBLycEX81YPL5
         9TaejUjkCv2ZZDFIMur7eu8MfakYL83nSLBqbi89yvKVcj/ocrGft0tg2PG2+Pvj6mgb
         aZJd5EjBnicd9itMxVsxlBVzDQ8P0YApxz+R3kT6XJJYeN9y0F0Fbkk2ttDuPYsh5Eyb
         Oi4g==
X-Gm-Message-State: AOAM5334CTs7ok6dxHgSVHFkmxYjpYLVJfXuj+eERWgakxYmCdlziLsB
        646U5MBgosse42lWnyfSu2uu+rLLov439g==
X-Google-Smtp-Source: ABdhPJyHbHujyl1D2FhIoCUCkZJeMSOObuUb5cCyUtPFGmGEI9lg9XlLMD4HSeRT5YDTKNGzukaBBw==
X-Received: by 2002:a63:ed4d:: with SMTP id m13mr4661438pgk.433.1620089428189;
        Mon, 03 May 2021 17:50:28 -0700 (PDT)
Received: from localhost ([47.8.22.213])
        by smtp.gmail.com with ESMTPSA id h22sm10221815pfn.55.2021.05.03.17.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 17:50:27 -0700 (PDT)
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
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 0/3] Add TC-BPF API
Date:   Tue,  4 May 2021 06:20:20 +0530
Message-Id: <20210504005023.1240974-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the sixth version of the TC-BPF series.

It adds a simple API that uses netlink to attach the tc filter and its bpf
classifier program. Currently, a user needs to shell out to the tc command line
to be able to create filters and attach SCHED_CLS programs as classifiers. With
the help of this API, it will be possible to use libbpf for doing all parts of
bpf program setup and attach.

Changelog contains details of patchset evolution.

In an effort to keep discussion focused, this series doesn't have the high level
TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
hence that will be submitted as a separate patchset based on this.

The individual commit messages contain more details, and also a brief summary of
the API.

Changelog:
----------
v5 -> v6
v5: https://lore.kernel.org/bpf/20210428162553.719588-1-memxor@gmail.com

 * Address all comments from Andrii.
 * Reorganize selftest to make logical separation between each test's set up
   and clean up more clear to the reader. Also add a common way to test
   different combination of opts.
 * Cleanup the commit message a bit.
 * Fix instances of ret < 0 && ret == -ENOENT pattern everywhere.
 * Use C89 declaration syntax.
 * Drop PRIu32.
 * Move flags to bpf_tc_opts and bpf_tc_hook.
 * Other misc comments.

v4 -> v5
v4: https://lore.kernel.org/bpf/20210423150600.498490-1-memxor@gmail.com

 * Added bpf_tc_hook to represent the attach location of a filter.
 * Removed the bpf_tc_ctx context object, refactored code to not assume shared
   open socket across operations on the same ctx.
 * Add a helper libbpf_nl_send_recv that wraps socket creation, sending and
   receiving the netlink message.
 * Extended netlink code to cut short message processing using BPF_NL_DONE. This
   is used in a few places to return early to the user and discard remaining
   data.
 * selftests rewrite and expansion, considering API is looking more solid now.
 * Documented the API assumptions and behaviour in the commit that adds it,
   along with a few basic usage examples.
 * Dropped documentation from libbpf.h.
 * Relax some restrictions on bpf_tc_query to make it more useful (e.g. to
   detect if any filters exist).
 * Incorporate other minor suggestions from previous review (Andrii and Daniel).

v3 -> v4
v3: https://lore.kernel.org/bpf/20210420193740.124285-1-memxor@gmail.com

 * Added a concept of bpf_tc_ctx context structure representing the attach point.
   The qdisc setup and delete is tied to this object's lifetime if it succeeds
   in creating the clsact qdisc when the attach point is BPF_TC_INGRESS or
   BPF_TC_EGRESS. Qdisc is only deleted when there are no filters attached to
   it.
 * Refactored all API functions to take ctx.
 * Removed bpf_tc_info, bpf_tc_attach_id, instead reused bpf_tc_opts for filling
   in attributes in various API functions (including query).
 * Explicitly documented the expectation of each function regarding the opts
   fields set. Added some small notes for the defaults chosen by the API.
 * Rename bpf_tc_get_info to bpf_tc_query
 * Keep the netlink socket open in the context structure to save on open/close
   cycles for each operation.
 * Miscellaneous adjustments due to keeping the socket open.
 * Rewrote the tests, and also added tests for testing all preconditions of the
   TC-BPF API.
 * We now use bpf skeleton in examples and tests.

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

v1-> v2
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
  libbpf: add netlink helpers
  libbpf: add low level TC-BPF API
  libbpf: add selftests for TC-BPF API

 tools/lib/bpf/libbpf.h                        |  42 ++
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/netlink.c                       | 586 ++++++++++++++++--
 tools/lib/bpf/nlattr.h                        |  48 ++
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 544 ++++++++++++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
 6 files changed, 1173 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

-- 
2.30.2

