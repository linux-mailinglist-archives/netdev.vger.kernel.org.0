Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA59620691D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbgFXAlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387586AbgFXAlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:41:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EFEC061573;
        Tue, 23 Jun 2020 17:41:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id n23so597576ljh.7;
        Tue, 23 Jun 2020 17:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlrfwFPk6kvFxjY4l0Nm18TGePH36uTIEOuxFjNyvwU=;
        b=E2E3v5f2E7yDGarvxE8ZoG+cXYxukTdBJXvEpokctGv0l1x6A+t0uqgAsoY9PE7V+r
         NuUif+4KJi91Zhry65mDajAwPMlzUXpmNVg8WDZf9HKJ/070mmbL1NHpvwdQXqIQkBb4
         pbt7fTd7Csvvg0GZ50u0LjrCMjJpbyQmAKnEkFHof4l8eNaUBnDa+/Njkoxl0WM8e4qx
         G5CiQC4obO16EQyBgrCOKXlyomBYvCCLXHZSdI5aCPkLk2rpQWDt/dKRlsUtKrvNw4ap
         zsHND87c1I3XF4lyZ6Mma8uAhccyNp+qcnvP3bRh4J84wPoJwMGC9s0vk9Gr+POJHhub
         mixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlrfwFPk6kvFxjY4l0Nm18TGePH36uTIEOuxFjNyvwU=;
        b=GmQ9H6UNz/QJxUtxhyYN3K+vMHLDSGpPy77hqMlUX/n4IsEi1+inx0nvP8ZPiBF90M
         xRaKySqf3WUDCH7kNKUnBa+W43fOd7lOpV+oLuWmw/9AM3kNicfvtqjlGfFKcMRDyFf0
         YmRh4RagWGtWTVbNPkEjM7S5dH5DY3bhDQ7Q/poqV6uvQrsrBKtR2B02gHL8rIo//cJF
         5M49yCakk0IkT5jkU/TB+YOYv3gxZIjqmy+4pORSaPFdJ1E6Q1E2I76f0PkEPqadux7V
         dDoO1cgVQkHUlZMIqsOVwFTDW2Y90WIaSWEN4mCqT+GrLP352iqMzv8VDQuLNiaxq3Bh
         K98w==
X-Gm-Message-State: AOAM532XoaLjHxb9fYWy7GwFzxVM73oBSIQEnBMmj1B8I4Jt4d8o4X2R
        6uF1ePm3lPcogzErEskNi2Uzf6YzKpicidkeFA0=
X-Google-Smtp-Source: ABdhPJyQW/T0hFJ3e8muY+8mbZKC9XTXZ+tXfelwgvcCtqS7E1Yvy61uQcMhm24VC1mWHLdQcFZRidGaP6wK95GWtv8=
X-Received: by 2002:a2e:b1d4:: with SMTP id e20mr11928288lja.290.1592959265279;
 Tue, 23 Jun 2020 17:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200619230423.691274-1-andriin@fb.com> <ff1e49a8-57bb-a323-f477-018f9a6f0597@fb.com>
In-Reply-To: <ff1e49a8-57bb-a323-f477-018f9a6f0597@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jun 2020 17:40:53 -0700
Message-ID: <CAADnVQ+_HD3sfXPoT9bQ3ZdyBW1ibUGrt1KrFo4_7pgppTK-Wg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix CO-RE relocs against .text section
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 12:06 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/19/20 4:04 PM, Andrii Nakryiko wrote:
> > bpf_object__find_program_by_title(), used by CO-RE relocation code, doesn't
> > return .text "BPF program", if it is a function storage for sub-programs.
> > Because of that, any CO-RE relocation in helper non-inlined functions will
> > fail. Fix this by searching for .text-corresponding BPF program manually.
> >
> > Adjust one of bpf_iter selftest to exhibit this pattern.
> >
> > Reported-by: Yonghong Song <yhs@fb.com>
> > Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> But the fix here only fixed the issue for interpreter mode.
> For jit only mode, we still have issues. The following patch can fix
> the jit mode issue,
>
> =============
>
>  From 4d66814513ec45b86a30a1231b8a000d4bfc6f1a Mon Sep 17 00:00:00 2001
> From: Yonghong Song <yhs@fb.com>
> Date: Fri, 19 Jun 2020 23:26:13 -0700
> Subject: [PATCH bpf] bpf: set the number of exception entries properly for
>   subprograms
>
> Currently, if a bpf program has more than one subprograms, each
> program will be jitted separately. For tracing problem, the
> prog->aux->num_exentries is not setup properly. For example,
> with bpf_iter_netlink.c modified to force one function not inlined,
> and with proper libbpf fix, with CONFIG_BPF_JIT_ALWAYS_ON,
> we will have error like below:
>    $ ./test_progs -n 3/3
>    ...
>    libbpf: failed to load program 'iter/netlink'
>    libbpf: failed to load object 'bpf_iter_netlink'
>    libbpf: failed to load BPF skeleton 'bpf_iter_netlink': -4007
>    test_netlink:FAIL:bpf_iter_netlink__open_and_load skeleton
> open_and_load failed
>    #3/3 netlink:FAIL
> The dmesg shows the following errors:
>    ex gen bug
> which is triggered by the following code in arch/x86/net/bpf_jit_comp.c:
>    if (excnt >= bpf_prog->aux->num_exentries) {
>      pr_err("ex gen bug\n");
>      return -EFAULT;
>    }
>
> If the program has more than one subprograms, num_exentries is actually
> 0 since it is not setup.
>
> This patch fixed the issue by setuping proper num_exentries for
> each subprogram before calling jit function.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Thanks for fixing. Applied both to bpf tree.
Yonghong, next time please submit the patch properly.
It was very awkward to copy-paste it manually from the thread.
I've edited the commit log a bit.
