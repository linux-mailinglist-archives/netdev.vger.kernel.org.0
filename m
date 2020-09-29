Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2927BC27
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 06:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgI2Eme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 00:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI2Eme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 00:42:34 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4476EC061755;
        Mon, 28 Sep 2020 21:42:34 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k2so2647591ybp.7;
        Mon, 28 Sep 2020 21:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wy9ej14LRvl4nWE/PIY+t/pIRhCnJYdbgSPQ0Fl2e2Q=;
        b=TCBfF2+cI2n48t41J2QHPVdVq+2HEBFHl3OxHDgqB2lg6fNOns+lnqQps0zY7jTBZj
         9KPS3/4zp63AKKt6LMSSxD+dj7oWN8+6Gp4JxsCSwR7tUd7RDXTd1YCl4TkDOrC9XRZx
         EEJYNMxpoLV8qfWdcQce/CQqIkIxxvsuvcyGBFWCXpXOFLw7hgvfLGc5CW7ECuS8EG7X
         6ZGnJ57ds/QVW8hgCRSwqjE+RQ36YfqKDP+f67/+iYCaFeKfudgb4MpX5BqsTsBt8WSc
         vtGoFYmWaHeFp2NsJ80UlmXwEC+MgmnIYF6OgbuGY1zYxdoWbMuc0hvazKUm+JHO2rLH
         CWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wy9ej14LRvl4nWE/PIY+t/pIRhCnJYdbgSPQ0Fl2e2Q=;
        b=MEIp//gFS40xtOlr4J89Cp2VnwXQ6jM79T/kkC2G4IN2gxOgIasKEkQy7/Wpfpmye8
         MFBZBD3ACH2hjyd15SUKUgFNqfSmEx2c+M+sj0p5y4E9gCairRq0FPbcQqYRpSKc9cE2
         3L72xAhb3lIh6XeBm2XUkFoTgn7PoE/GaxAimZMYTJlvD82ilComviD59DevZkEOA4wo
         XN6j07wfdlVr4tOrGLrDeZXRqMy19UPdMYmvcMov3v5vpnkc7rpbMn1fn26+M6ptKWnb
         QNSD3rmVgtbrWS99hICBalcH8CGAhwtJ/ybxImN7oBsePDgBUuieKyc/pBI+ZcjNXgRG
         Mz/g==
X-Gm-Message-State: AOAM530kGDxbQz03I9y45tm89kHVUXt+QIRVHqSz73YmHamq0hfikz49
        0uowSeYWUztOGjEwsxKhhUAkqZU3mVw5mEtJuIM=
X-Google-Smtp-Source: ABdhPJxGfwxGbXwq0QrXarG4kpNQGm3ZRViG/OrHCDRuD/c7wbOZkS+rq2YpBxA/6ZJ6u5djgka6DkiPqrrG80RHbxs=
X-Received: by 2002:a25:6644:: with SMTP id z4mr3789946ybm.347.1601354553467;
 Mon, 28 Sep 2020 21:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <1601292670-1616-1-git-send-email-alan.maguire@oracle.com> <1601292670-1616-9-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1601292670-1616-9-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Sep 2020 21:42:22 -0700
Message-ID: <CAEf4Bzb+V-EKgqMFWUGoQLiC_560mCUCdjD4UTPuqnN26-qnvA@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 8/8] selftests/bpf: add test for
 bpf_seq_printf_btf helper
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        andriy.shevchenko@linux.intel.com, Petr Mladek <pmladek@suse.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Andrey Ignatov <rdna@fb.com>, scott.branden@broadcom.com,
        Quentin Monnet <quentin@isovalent.com>,
        Carlos Neira <cneirabustos@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 4:36 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Add a test verifying iterating over tasks and displaying BTF
> representation of task_struct succeeds.
>
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Hey Alan,

These selftests rely on having struct btf_ptr and BTF_F_COMPACT (and
other) flags to be present in vmlinux.h. While there is nothing wrong
with that per se, it does break selftests builds on older kernels,
because there struct btf_ptr isn't yet present in kernel:

progs/netif_receive_skb.c:131:21: error: use of undeclared identifier
'BTF_F_NONAME'
        TEST_BTF(str, int, BTF_F_NONAME, "0", 0);
                           ^
progs/netif_receive_skb.c:131:2: error: use of undeclared identifier
'BTF_F_COMPACT'; did you mean 'TT_COMPAT'?
        TEST_BTF(str, int, BTF_F_NONAME, "0", 0);
        ^
progs/netif_receive_skb.c:50:28: note: expanded from macro 'TEST_BTF'
                __u64 _hflags = _flags | BTF_F_COMPACT;                 \
                                         ^
/data/users/andriin/linux/tools/testing/selftests/bpf/tools/include/vmlinux.h:330:2:
note: 'TT_COMPAT' declared here
        TT_COMPAT = 2,
        ^
fatal error: too many errors emitted, stopping now [-ferror-limit=]

progs/bpf_iter_task_btf.c:21:24: error: variable has incomplete type
'struct btf_ptr'
        static struct btf_ptr ptr = { };
                              ^
/data/users/andriin/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:33:8:
note: forward declaration of 'struct btf_ptr'
struct btf_ptr;


We actually do build the very latest selftests against old kernels
(4.9 and 5.5 at the moment) as part of libbpf CI, so it would be nice
to fix this problem and keep selftests compilable.

Do you mind following up with a change to define struct btf_ptr and
those BTF_F_xxx flags explicitly for selftests only, similarly to how
we do it for bpf_iter context structs? See progs/bpf_iter.h for
examples. Thanks.

>  tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 74 ++++++++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_task_btf.c        | 50 +++++++++++++++
>  2 files changed, 124 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
>

[...]
