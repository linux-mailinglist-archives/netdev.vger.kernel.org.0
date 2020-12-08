Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4480B2D218B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgLHDnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgLHDnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:43:11 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39683C0613D6;
        Mon,  7 Dec 2020 19:42:31 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id w127so3412768ybw.8;
        Mon, 07 Dec 2020 19:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVF0ZTpG4KyKSrWlbeJiAw2aw7KsjahNGWMZr7fhkHk=;
        b=BPa3/BjB+L6D2YqA9dPlyXktUcodacMyngTKOJWFJk7ozjZiZ8WaFDP1g65futKeDn
         jFCXr3S+1EpOHmwW7kUhz/X19KmZZDq+Av+tWHU82lzEMKu30IeH8IVmLyvlAN5CvVT6
         g8NYlRnHhHCun/UoIluyV+FpDWwZ5yUsvN3/qTpeuy8cSKXmyHGGTXFHs5M1SUAuwnrF
         jRhu0q6CUItI1S1axL2FuB1sF9IASYLF3SHJ8mEs7xSXJAmH11hkhp2mIBq9ERZWPMD7
         UZszu2w+0ZW/F/ki25Of6Tp9I1+tT1wuHRNEsQAU6RaBVVYWsPTwRyaoyhYEPIg68iEA
         YWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVF0ZTpG4KyKSrWlbeJiAw2aw7KsjahNGWMZr7fhkHk=;
        b=oXOCdL3P26HU2X96iOgKUEts8cGs5fUoq2MYCFgAQIBQOcVvAPbLadYYJGGspjMbS4
         e3UR4iKzmKD0JjNGrUTeqsEEESkFguC3E73eZbaIUN0BrH7YyX5exGvMf4yXqBov8SQW
         qPi1YlgG8BJyELdW6+lwm+mGYAd9TQa8Sf6Zvq8ylvX2/XELHs+gkkQn+XaU+IHfg6It
         JEWmB6fzEzw7uhQ+348zOTfRRac4gjafOo+NQe2k9UK/5bnC5K+gBfz+h+8BmPnCz7g6
         pA2CK2b/feWHOjYzIbDGFO9rtQZ22O6t0pgRJFLVvNozcQkql7MGB2PIdEFQ5jWQAWaq
         ymqA==
X-Gm-Message-State: AOAM53202hSYdlt+ZF6qLDj6LF+uJDIXxbpRfBwR1YnVXPUFcJdRIOyu
        zvZvGv/ZKmK84BamWGIh256lsN1GBDi5WIMNo+8=
X-Google-Smtp-Source: ABdhPJx8F2SwxSvT6CvUqSpa4NJjcxoee7gCMdq75xz/NayiKTXs/2afKhPU+7rA6Jf+xlNlUnGeXChrAdKN+jBObqw=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr26537481ybg.230.1607398950542;
 Mon, 07 Dec 2020 19:42:30 -0800 (PST)
MIME-Version: 1.0
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
 <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com> <alpine.LRH.2.23.451.2012060038260.1505@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2012060038260.1505@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 19:42:19 -0800
Message-ID: <CAEf4BzYmDZVnHRYFJk+J90s-GKUt_Sa2HPNs6mKxyZ8Bm6TN3w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display helpers
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 4:44 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
>
> On Sat, 5 Dec 2020, Yonghong Song wrote:
>
> >
> >
> > __builtin_btf_type_id() is really only supported in llvm12
> > and 64bit return value support is pushed to llvm12 trunk
> > a while back. The builtin is introduced in llvm11 but has a
> > corner bug, so llvm12 is recommended. So if people use the builtin,
> > you can assume 64bit return value. libbpf support is required
> > here. So in my opinion, there is no need to do feature detection.
> >
> > Andrii has a patch to support 64bit return value for
> > __builtin_btf_type_id() and I assume that one should
> > be landed before or together with your patch.
> >
> > Just for your info. The following is an example you could
> > use to determine whether __builtin_btf_type_id()
> > supports btf object id at llvm level.
> >
> > -bash-4.4$ cat t.c
> > int test(int arg) {
> >   return __builtin_btf_type_id(arg, 1);
> > }
> >
> > Compile to generate assembly code with latest llvm12 trunk:
> >   clang -target bpf -O2 -S -g -mcpu=v3 t.c
> > In the asm code, you should see one line with
> >   r0 = 1 ll
> >
> > Or you can generate obj code:
> >   clang -target bpf -O2 -c -g -mcpu=v3 t.c
> > and then you disassemble the obj file
> >   llvm-objdump -d --no-show-raw-insn --no-leading-addr t.o
> > You should see below in the output
> >   r0 = 1 ll
> >
> > Use earlier version of llvm12 trunk, the builtin has
> > 32bit return value, you will see
> >   r0 = 1
> > which is a 32bit imm to r0, while "r0 = 1 ll" is
> > 64bit imm to r0.
> >
>
> Thanks for this Yonghong!  I'm thinking the way I'll tackle it
> is to simply verify that the upper 32 bits specifying the
> veth module object id are non-zero; if they are zero, we'll skip

Let's instead of the real veth module use selftests's bpf_testmod,
which I added specifically to use for tests like these. We can define
whatever types we need in there.

> the test (I think a skip probably makes sense as not everyone will
> have llvm12). Does that seem reasonable?
>
> With the additional few minor changes on top of Andrii's patch,
> the use of __builtin_btf_type_id() worked perfectly. Thanks!
>
> Alan
