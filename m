Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D504F3D8396
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhG0XAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbhG0XAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:00:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B491CC061757;
        Tue, 27 Jul 2021 16:00:21 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id x192so822510ybe.0;
        Tue, 27 Jul 2021 16:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lr7THcPI5OnUXfqdi56fDqXR5j/d3Far1qGQY5rJ9iw=;
        b=kCNsUiBEBned5TvuIoD5dANK7ghcXqURokGC44DgwUOd/Pd/1lqjw8PGRY4BjG37qH
         QFfZGeHBJQEezaskPCSm0uBMhvwWiR4HAj2UN4dDlf6N3EyBAcSCDjjo9LatS49WmlZQ
         TDFtx90fnEQWyxC1Sd4NeIjiHWhn4qonw6VF4kaIl0T94nKW0qw5cxsvRlsd4JDw30R3
         hBB4LhgfMeTm938wT6yemf5APBRmH7BNNohyc+e9xtQItwu6tCvYC7zVoAln/3CFVpDh
         0VGW/wQ5H9NrnXl5hd7594u3mAOIbwgsTliOC/SttkohVruD4JZx/vJbY8IDnpj/kUwz
         WEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lr7THcPI5OnUXfqdi56fDqXR5j/d3Far1qGQY5rJ9iw=;
        b=aymZUNxs4YgG5nW72vja8BDpDUs0p1VRoRunBusrq8lZM8/bpl+sNHrYqXRsQHGvlf
         D7sYJ0ZCq0IMCuIJ2Drk1+xlwDhgl1f7jxa40CyfjAI4IRj9aa/5HBOJUnnSmaL3A0xX
         59DEZ/GXNsVre8YE+OIJqJ7iRlc08rOQ2KFeFJX+8POK8hvKW2Saz5ZKjmPJDRJ9SoBd
         7MBYKEbsociBPIE0b3DRzyysH2+Gfp7MZKhuMhKP2AiAysA5UeOvLkMt1BtepaIYp3mW
         Y4JiPkE4gDHfaCWPJtJCCJnN2ue8LUvvABjgaBREeiWlYdBYkUfXmYureWy9/VnFefY8
         hFoQ==
X-Gm-Message-State: AOAM530OnDxlwE7DkeAoS6Pi9vAheOsei1pzfmNjaJSlSHbMgvhbU8VR
        DXnz1W2BztnfaUX7bi84nwrLXIhZ9uPG4Z38xn4=
X-Google-Smtp-Source: ABdhPJwk1noCwfc11zm4CjR+goC2/mbsdgkrYY1XikrCpfL/nJ/M3udExsa/F41y+Sp9wWiEXneW/hLGQJihAdgB3SY=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr33219292ybf.425.1627426820800;
 Tue, 27 Jul 2021 16:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210727222335.4029096-1-sdf@google.com>
In-Reply-To: <20210727222335.4029096-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 16:00:09 -0700
Message-ID: <CAEf4BzZJOH1wbQ2BCjaqkYWtW406Oh+UyWt_wM9AtggabY46RQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: increase supported cgroup storage value size
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
>
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
>
> netcnt test is extended to exercise those maximum values
> (non-percpu max size is close to, but not real max).
>
> v4:
> * remove inner union (Andrii Nakryiko)
> * keep net_cnt on the stack (Andrii Nakryiko)
>
> v3:
> * refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
> * anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
> * reorder free (Yonghong Song)
>
> v2:
> * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Added Martin's ack and applied to bpf-next. Please carry over received
Acks between revisions.

It's also a good practice to separate selftest from the kernel (or
libbpf) changes, unless kernel change doesn't immediately break
selftest. Please consider doing that for the future.

I also just noticed that test_netcnt isn't part of test_progs. It
would be great to migrate it under the common test_progs
infrastructure. We've been steadily moving towards that, but there are
still a bunch of tests that are not run in CI.


>  kernel/bpf/local_storage.c                    | 11 +++++-
>  tools/testing/selftests/bpf/netcnt_common.h   | 38 ++++++++++++++-----
>  .../testing/selftests/bpf/progs/netcnt_prog.c |  8 ++--
>  tools/testing/selftests/bpf/test_netcnt.c     |  4 +-
>  4 files changed, 45 insertions(+), 16 deletions(-)
>

[...]
