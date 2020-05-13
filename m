Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8009F1D1D52
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390074AbgEMSTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732845AbgEMSTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:19:21 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AF3C061A0C;
        Wed, 13 May 2020 11:19:21 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id i5so179140qkl.12;
        Wed, 13 May 2020 11:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=enLNMF2hbjwMX7CcoiYwH93Tr3C01x5+cBgNYs19VDQ=;
        b=gBMhbAcuepVRkxY0oiQJSWv5k9AiRAm5ByDN3waSQDtXivKuc82sFb0ZNHLAK/Er6x
         s0KfGn4X0XS9nLVoj6Ri8jJRYA9t6tUCdtgmJGE0Q+W/4bRuFCgmOcKgsa7pouXV3FUY
         ocFZNNAkWwbIExwoI3ykDZc3E31twjVTs67mtLqjOubLkIM1MiYBoDQhlFdb/RP2LV70
         QcNPmN7coCgNhKYDQwirhSloI00IX9JptqBX2pzY87S6TY8HUBTFRwFQ2wUdHrDmNxq0
         SWu+ADvGlHum7WhPJUdThS+MOzhwoiafCMy1zPvrT9/IWaAtCta1UwI3/hgcmMTZmfYy
         d1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=enLNMF2hbjwMX7CcoiYwH93Tr3C01x5+cBgNYs19VDQ=;
        b=oIlRXIyH98J9ggQfoPshXEDo9jKRY6wS3apNboItlWSJTq6ChgxFTcQeGDrvgis6r2
         HSP2VLxCE1Ua2/mIraJPsVycZ1K0kTS1tVKG098YC2pQvqH1SfRGXv4qDS7ssy1u+5Pp
         R1d+nyT7iD3e5ogc73+klAaXhRbCfWJwAJrjyrp+UcilJSegkcAmhpMobSW9uGeWkEwt
         ab7Jtd0x5DccJ3KIxE2+A6bo+2n3VWXDiBiw5McY1Ycq4AGyJjDhdUR325akoH5ypGw2
         FAB6qXPo/0j9EvrkdJmv7UaJ1ydDYjw3FD6W9Gwtbu4GP9wMKQCfzkt6bGPGt7UbFrpI
         l4ig==
X-Gm-Message-State: AOAM533vkj3qL4Z5uJdxfBU9SCWy/4vHMghDyxT9FvZBo1kTOfzpTmEc
        4KAGDZXdZr8UHMoSSovUHEec0XJEEOC7Vo089jM=
X-Google-Smtp-Source: ABdhPJw6re7XBsicehrwHFERb97rZya0gylF/TJtKFF3/QlnV0oA7dNkmQzvGL08IoOE0/2SkTAsA7v+7jnMuL5wLRE=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr1023740qka.449.1589393960963;
 Wed, 13 May 2020 11:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200513180215.2949164-1-yhs@fb.com>
In-Reply-To: <20200513180215.2949164-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 May 2020 11:19:10 -0700
Message-ID: <CAEf4BzYeaL5QK0vQHyTzD2+Vof9B8-akjpUJsKTkRnUDztxadA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/7] bpf: misc fixes for bpf_iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:03 AM Yonghong Song <yhs@fb.com> wrote:
>
> Commit ae24345da54e ("bpf: Implement an interface to register
> bpf_iter targets") and its subsequent commits in the same patch set
> introduced bpf iterator, a way to run bpf program when iterating
> kernel data structures.
>
> This patch set addressed some followup issues. One big change
> is to allow target to pass ctx arg register types to verifier
> for verification purpose. Please see individual patch for details.
>
> Changelogs:
>   v1 -> v2:
>     . add "const" qualifier to struct bpf_iter_reg for
>       bpf_iter_[un]reg_target, and this results in
>       additional "const" qualifiers in some other places
>     . drop the patch which will issue WARN_ONCE if
>       seq_ops->show() returns a positive value.
>       If this does happen, code review should spot
>       this or author does know what he is doing.
>       In the future, we do want to implement a
>       mechanism to find out all registered targets
>       so we will be aware of new additions.
>
> Yonghong Song (7):
>   tools/bpf: selftests : explain bpf_iter test failures with llvm 10.0.0
>   bpf: change btf_iter func proto prefix to "bpf_iter_"
>   bpf: add comments to interpret bpf_prog return values
>   bpf: net: refactor bpf_iter target registration
>   bpf: change func bpf_iter_unreg_target() signature
>   bpf: enable bpf_iter targets registering ctx argument types
>   samples/bpf: remove compiler warnings
>
>  include/linux/bpf.h                    | 22 ++++++++----
>  include/net/ip6_fib.h                  |  7 ++++
>  kernel/bpf/bpf_iter.c                  | 49 +++++++++++++++-----------
>  kernel/bpf/btf.c                       | 15 +++++---
>  kernel/bpf/map_iter.c                  | 23 +++++++-----
>  kernel/bpf/task_iter.c                 | 42 ++++++++++++++--------
>  kernel/bpf/verifier.c                  |  1 -
>  net/ipv6/ip6_fib.c                     |  5 ---
>  net/ipv6/route.c                       | 25 +++++++------
>  net/netlink/af_netlink.c               | 23 +++++++-----
>  samples/bpf/offwaketime_kern.c         |  4 +--
>  samples/bpf/sockex2_kern.c             |  4 +--
>  samples/bpf/sockex3_kern.c             |  4 +--
>  tools/lib/bpf/libbpf.c                 |  2 +-
>  tools/testing/selftests/bpf/README.rst | 43 ++++++++++++++++++++++
>  15 files changed, 183 insertions(+), 86 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/README.rst
>
> --
> 2.24.1
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
