Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95A26D57B1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDDEug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDDEuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:35 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5369B184;
        Mon,  3 Apr 2023 21:50:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ja10so30180587plb.5;
        Mon, 03 Apr 2023 21:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583833; x=1683175833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DS+zOSf7M9g/T+P60kmTdXV5CVv7dh4XI7ph0ByvMTQ=;
        b=eT2yIqiQ6Dy2uZChd7fljc6hYDyrQT7pxEhflXR+Okfi/s3R9fypBe8FDmsuEHsOmF
         Sda2JMzzCKyI4MTZ/coMlEq1jbl/eO0HDvvuM+YovaOiMiIfzNaP1dfCyztcAGK6b11H
         mGaWp3HWw1SV2MbhBCXhqqSAEe9dMK2ZClPRiN+99CAfLAHRL3NhTdxPJ9vURuTTaC23
         8TDN5I/f3DLs9bAu+gYTCxTbNQDNO6s+ys2Y4zgAjbv6Cbw6aq99LDZzWF2c3+5rOVaU
         6vYCWGCxUrYgfxtaDkIZIhzf25/baJmkjuKA9recUiBi3rEEHvQCnRezxAj9eB3UQfZ3
         EtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583833; x=1683175833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DS+zOSf7M9g/T+P60kmTdXV5CVv7dh4XI7ph0ByvMTQ=;
        b=q3Q0wxTugirSGG/XZaY/E7JD6DpWgS+ohInAcupW0/bx2gsXdVqqf4MHHoDB5jwrTr
         s4vBhIBsBi7CQyrGSnbCB9qfkrxvO6HrJN+D4VD8XW9b9XXgkFv37YgyYbz7QDpgvvgE
         ZfckLGXNTXpfLSkqpbRsL6CXPsxRIUNMHJGX8UfrUQEUt+UG0ZNXmb/kbpj+Ufyuezbq
         e2u1WKKc0TD00uQvh6rBXhceVnlPzjeCjqW/OUYT1UwqX2MzZzYvWV+ZRvd5h6X89Xiu
         DsAFWvmsob1FePGA5BiagkKNUoP0EFT3ZKR8zXd66NSx/ZQwJpqytA5KveJJmLoT6exm
         U4ow==
X-Gm-Message-State: AAQBX9eku/cARHGIqgKz6m9M3I3O1Km7CUYcbSNgdo+lcUecjaRZw2ZG
        mB0OFeXKjwn4Naf0huX7OMc=
X-Google-Smtp-Source: AKy350YC2eehCVzdVkBd2ZiJXqmlWFrrtGBti4+lDYBmn7Mu/Px7NQTrEyPePvLDyXhOp+QNCnnHjg==
X-Received: by 2002:a05:6a20:b930:b0:e3:8710:6846 with SMTP id fe48-20020a056a20b93000b000e387106846mr1235478pzb.10.1680583833377;
        Mon, 03 Apr 2023 21:50:33 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id h20-20020a62b414000000b00625e14d3a15sm7742195pfn.166.2023.04.03.21.50.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:32 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
Date:   Mon,  3 Apr 2023 21:50:21 -0700
Message-Id: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The patch set is addressing a fallout from
commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
It was too aggressive with PTR_UNTRUSTED marks.
Patches 1-6 are cleanup and adding verifier smartness to address real
use cases in bpf programs that broke with too aggressive PTR_UNTRUSTED.
The partial revert is done in patch 7 anyway.

Alexei Starovoitov (8):
  bpf: Invoke btf_struct_access() callback only for writes.
  bpf: Remove unused arguments from btf_struct_access().
  bpf: Refactor btf_nested_type_is_trusted().
  bpf: Teach verifier that certain helpers accept NULL pointer.
  bpf: Refactor NULL-ness check in check_reg_type().
  bpf: Allowlist few fields similar to __rcu tag.
  bpf: Undo strict enforcement for walking untagged fields.
  selftests/bpf: Add tracing tests for walking skb and req.

 include/linux/bpf.h                           | 10 +-
 include/linux/filter.h                        |  3 +-
 kernel/bpf/bpf_cgrp_storage.c                 |  4 +-
 kernel/bpf/bpf_inode_storage.c                |  4 +-
 kernel/bpf/bpf_task_storage.c                 |  8 +-
 kernel/bpf/btf.c                              | 44 ++++-----
 kernel/bpf/verifier.c                         | 91 ++++++++++++++-----
 net/bpf/bpf_dummy_struct_ops.c                | 14 ++-
 net/core/bpf_sk_storage.c                     |  4 +-
 net/core/filter.c                             | 21 ++---
 net/ipv4/bpf_tcp_ca.c                         |  6 +-
 net/netfilter/nf_conntrack_bpf.c              |  3 +-
 .../bpf/progs/test_sk_storage_tracing.c       | 16 ++++
 13 files changed, 131 insertions(+), 97 deletions(-)

-- 
2.34.1

