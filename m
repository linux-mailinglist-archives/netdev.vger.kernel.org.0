Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314BD42426A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 18:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhJFQTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 12:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhJFQTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 12:19:43 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C38C061746;
        Wed,  6 Oct 2021 09:17:50 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i84so6587830ybc.12;
        Wed, 06 Oct 2021 09:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91Fc9jEO5xfvs7S6V5r6TadJ+s30PnjatWWASHP9jzg=;
        b=hm43oDZ1ckcJHVtw8p0wRfre56rpiz6dVwxaKhk45ZqD8+ektT3Ao5AUDvHHFZge+V
         oUPCmTMjz3Lxq8jd2yrf8j9TS5WwIJ0LG9btwxfZU4A8AN9Hd4QoKUH9ysTzQ6/82LYV
         /8Uog1VMTbAk3zu82E1Ckemfv9/nkWkusLeYBt6APdZKEt+fD+D76K2oujJFA6EwFe/V
         0jT2p+dz9pegU/ZbBaJ02g9fXxjxBrhEChvHRgVMyJ5jGs7ecJ8/VCt/Jt5mz0m4rbkX
         RNi9G5U1MHyQGczTFb4iyror7bTu/mGKEFxHW85Az2DB53YxzdYmafIhuSSX8+cl4Mqx
         p+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91Fc9jEO5xfvs7S6V5r6TadJ+s30PnjatWWASHP9jzg=;
        b=k0eP4WOK1eo3oiCa8WhXFP26JgBmR6J99f1jlizURK5rVrBD66xpxoUBCBEHqIzu0j
         +VViN26R1cJ0awv8bnWTEVjfCCb86oQgp4zlFedWzux8Ik/zafpXJeCdIv2dXu+e1UI5
         /Pt8SXTe8JNUpLcdRyaspFSukFVGv0pde+M9ss97UzuTEttzx+MBwDvppiR1144gqeVx
         3NCgYRywTrqe65quhnmsDxaqW0Yi3DVJslyve4Uq17CxOcuew04yKzFK5hB+J/qT5nYk
         mP9xiC05zBfnlMUpeI750OPEeE1rkhqTR2BYQAYWW9Z3P5CsO5SxYyzI2S+8j0Uq3T9d
         joMw==
X-Gm-Message-State: AOAM532cBhXVMayLYG+2nE77xfgkiFWMPRP8ZtRbtm8/zSRHH3ieszwc
        +Yxz3UBPRSE4JW4ewOz16dTcFpMwCE/sdrXolMU=
X-Google-Smtp-Source: ABdhPJz+tUblt820huLntwRPWc0cKJZTUS2P1ytK77bMVSQ2w7I0UJ+zEmXhOVPyaPamYKC58wPxbY4qDzhtUDdPnBY=
X-Received: by 2002:a25:1884:: with SMTP id 126mr29878189yby.114.1633537069922;
 Wed, 06 Oct 2021 09:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <YV1hRboJopUBLm3H@krava>
In-Reply-To: <YV1hRboJopUBLm3H@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 09:17:39 -0700
Message-ID: <CAEf4BzZPH6WQTYaUTpWBw1gW=cNUtPYPnN8OySgXtbQLzZLhEQ@mail.gmail.com>
Subject: Re: [RFC] store function address in BTF
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 1:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> hi,
> I'm hitting performance issue and soft lock ups with the new version
> of the patchset and the reason seems to be kallsyms lookup that we
> need to do for each btf id we want to attach
>
> I tried to change kallsyms_lookup_name linear search into rbtree search,
> but it has its own pitfalls like duplicate function names and it still
> seems not to be fast enough when you want to attach like 30k functions

How not fast enough is it exactly? How long does it take?

>
> so I wonder we could 'fix this' by storing function address in BTF,
> which would cut kallsyms lookup completely, because it'd be done in
> compile time
>
> my first thought was to add extra BTF section for that, after discussion
> with Arnaldo perhaps we could be able to store extra 8 bytes after
> BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> indicate that? or new BTF_KIND_FUNC2 type?
>
> thoughts?

I'm strongly against this, because (besides the BTF bloat reason) we
need similar mass attachment functionality for kprobe/kretprobe and
that one won't be relying on BTF FUNCs, so I think it's better to
stick to the same mechanism for figuring out the address of the
function.

If RB tree is not feasible, we can do a linear search over unsorted
kallsyms and do binary search over sorted function names (derived from
BTF IDs). That would be O(Nlog(M)), where N is number of ksyms, M is
number of BTF IDs/functions-to-be-attached-to. If we did have an RB
tree for kallsyms (is it hard to support duplicates? why?) it could be
even faster O(Mlog(N)).


>
> thanks,
> jirka
>
