Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879474791C7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhLQQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhLQQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:45:25 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F590C061574;
        Fri, 17 Dec 2021 08:45:25 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id g17so7998546ybe.13;
        Fri, 17 Dec 2021 08:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m7Y7ckw+IgW4yU6GDHbrZEnkRBsrFfzHCVFkQQiHxak=;
        b=kcyeSOnDd9J0q0McHdlTwt2+/AaFjyYI8vm8T3n5p7L2MFKyooEiDZXin00Vkh2QHA
         gln30x7Ctw47OckybLamsXsvHYyt02zS89/Z1cMj9XqHqu2igcYveTXj7nikEKn+TOFN
         8nMbon5bb/PxrXi7WxNId9RXz+YrBRxzqjsW/IcwVym7CGhE+sgcHXt1d5fwJ3086H5u
         SBV6vpaVm6D5wvf9v1V6BSUCLmaqsWbpq2TRgwGMQ1XN/Tluu2qQVw2c0suY143k727i
         qCLnLwrAJ6YMRQhYz0dl9FYkE4xUuQxAbUS4+qghM+lH6goboXo7USCaZeu1RzdUxE8J
         WF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m7Y7ckw+IgW4yU6GDHbrZEnkRBsrFfzHCVFkQQiHxak=;
        b=YvxsYW715qbaHGxUBtpsAtk6nAIN8Hh2s1z0gGWrwLoSEUUJ83uQ34mklslrLRIYr1
         o+y7nvT03j2AiCV6XyDdFhdOzd3BM3pDtkyEbLkSRXiNTHZBl6D36rKz9jXapV742pHt
         G4iC7usjPmWvvyN6be/yEulW7nJRbIO5whVSqiOc8+nGEJB8Ri7rWSECCaCA/6Kmghep
         cazk6gMuM3CNeK8DQndAuSxd90gnd5yk6gth0Lm8PJHQLNKEYNsNXjFTeTz+FcaldksB
         XqiWQsD1lmaSmWY3gCIjQ8tQOaATfAM/ublZXGQG5xFRi9VhUaR52CmTdS3IenMqzvx1
         CMqw==
X-Gm-Message-State: AOAM533+DxwTUOojaYOjNRAprIZNd9f1/ACR6++N0fmNpaBl2WM9S8VM
        ZSZs8ylucBk2vTwZdWrZCEQ7XpWAJjOpGwPaWG4=
X-Google-Smtp-Source: ABdhPJzfKY1BO8ehGRFdS69WpfFRf+Rny7uieyPckkgvNhRP9CTEpoL1kfBsBWCeBrYRSpnHy6RCQHVZuZ/MXgnkvwg=
X-Received: by 2002:a25:3c9:: with SMTP id 192mr5496379ybd.766.1639759524593;
 Fri, 17 Dec 2021 08:45:24 -0800 (PST)
MIME-Version: 1.0
References: <20211214135555.125348-1-pulehui@huawei.com> <CAEf4BzaQcHV3iY5XqEbt3ptw+KejVVEZ8gSmW7u46=xHnsTaPA@mail.gmail.com>
 <a83777e4-528f-8adb-33e4-a0fea8d544a0@huawei.com>
In-Reply-To: <a83777e4-528f-8adb-33e4-a0fea8d544a0@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Dec 2021 08:45:13 -0800
Message-ID: <CAEf4BzZf2UBgO=uaOOhPFEdJV9Jo7x3KAC3G9Wa1RVdmOD35nA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix building error when using
 userspace pt_regs
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 6:25 PM Pu Lehui <pulehui@huawei.com> wrote:
>
>
>
> On 2021/12/16 12:06, Andrii Nakryiko wrote:
> > On Tue, Dec 14, 2021 at 5:54 AM Pu Lehui <pulehui@huawei.com> wrote:
> >>
> >> When building bpf selftests on arm64, the following error will occur:
> >>
> >> progs/loop2.c:20:7: error: incomplete definition of type 'struct
> >> user_pt_regs'
> >>
> >> Some archs, like arm64 and riscv, use userspace pt_regs in
> >> bpf_tracing.h, which causes build failure when bpf prog use
> >> macro in bpf_tracing.h. So let's use vmlinux.h directly.
> >
> > We could probably also extend bpf_tracing.h to work with
> > kernel-defined pt_regs, just like we do for x86 (see __KERNEL__ and
> > __VMLINUX_H__ checks). It's more work, but will benefit other end
> > users, not just selftests.
> >
> It might change a lot. We can use header file directory generated by
> "make headers_install" to fix it.

We don't have dependency on "make headers_install" and I'd rather not add it.

What do you mean by "change a lot"?

>
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -294,7 +294,8 @@ MENDIAN=$(if
> $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>   CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>   BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) \
>              -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) \
> -            -I$(abspath $(OUTPUT)/../usr/include)
> +            -I$(abspath $(OUTPUT)/../usr/include) \
> +            -I../../../../usr/include
> >>
> >> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> >> ---
> >>   tools/testing/selftests/bpf/progs/loop1.c     |  8 ++------
> >>   tools/testing/selftests/bpf/progs/loop2.c     |  8 ++------
> >>   tools/testing/selftests/bpf/progs/loop3.c     |  8 ++------
> >>   tools/testing/selftests/bpf/progs/loop6.c     | 20 ++++++-------------
> >>   .../selftests/bpf/progs/test_overhead.c       |  8 ++------
> >>   .../selftests/bpf/progs/test_probe_user.c     |  6 +-----
> >>   6 files changed, 15 insertions(+), 43 deletions(-)
> >>
> >
> > [...]
> > .
> >
