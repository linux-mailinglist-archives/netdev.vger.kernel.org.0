Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667D1432BA0
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJSB7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJSB7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 21:59:54 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC7EC06161C;
        Mon, 18 Oct 2021 18:57:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so1414415pjb.4;
        Mon, 18 Oct 2021 18:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qUY79MPyKMwGVT6iIJG0K/BwgiUzFm+gKagkPPohO2I=;
        b=JORsSZEgrR8G1WZivCfAlnol5GV1JeVfl2qbtl+N2GBfrV2qmq9cx4Ucm9Cr4ICODD
         m2TSG9wCBiYAb1EliNiQqhVdS/oo0xpYZb4uLT2fhWhDXpost+kj3rifEYv6ByZu5p0e
         9KQNYpgPyC6BMkt9t2etI9gL/EDenRkyssFJXDWth38RcD/+3G5UYtTLVRiqm3dgEGWg
         tMLOCUWqXJgb35eqz8BawmH+IElzSkyrmR1EcPFYqUk2DRNP9SXhhkpeDCr0TIoM5iXS
         9x1vs8ZNetPOA93nsY/q23x4QaJfp1iQ7rY/xbAmu3LOnYsp5ibK+ZQRHn2BwVzfCW7r
         Ebtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qUY79MPyKMwGVT6iIJG0K/BwgiUzFm+gKagkPPohO2I=;
        b=vyORHjmx4FU27BZgr1D84Hej0EBTcHgad+Fdxo7O0bDvya8m3PJ7Bi05nKvyw/hPB6
         sZBP3vDfF29ruJNg8Qudmi8fsuMNV22H0zeUBGzGJNTRlO1hKfUFoo4Tr0XCZ7aJEn6V
         kpe39QuxzNijEMJF+UiojlxFO91mlm9dVMsAEjIFCCr6vLNxmRrUuHdErmUDqNvmS4N1
         DWfj8beAAMajblafT3hSfC49XUb5CrP42DfnJ7ol+tnG+6DJRlAIgVA1xa46N+cp538c
         Bj9efwkF7fxtcOKyN+9RbA9v9zZOravQ/NDVcR70siZBLi+Q3/oBpbUtyKprJ9V4UYCc
         4u/g==
X-Gm-Message-State: AOAM530MIhoMKZBIpP63Qd2L9fHMU/vB3T5xNWQ9DQSx2GS1JL4weS4N
        myOaX5HEwEeM1WDNsezTLyNKyyLA747M91MASdixuTco
X-Google-Smtp-Source: ABdhPJyPybmmM9SrYlqMdXm4JeZRP35FsXVmolprketo+C/zDHmctWOYo01jj1/89HRUecM3oWT5PafbaAEzEj5wgu8=
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr2703651pjj.138.1634608661937;
 Mon, 18 Oct 2021 18:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
 <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com> <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com>
In-Reply-To: <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Oct 2021 18:57:30 -0700
Message-ID: <CAADnVQKG5=qVSjZGzHEc0ijwiYABVCU1uc8vOQ-ZLibhpW--Hg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] bpf: use count for prealloc hashtab too
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 10:49 PM Chengming Zhou
<zhouchengming@bytedance.com> wrote:
>
> =E5=9C=A8 2021/10/16 =E4=B8=8A=E5=8D=883:58, Alexei Starovoitov =E5=86=99=
=E9=81=93:
> > On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
> > <zhouchengming@bytedance.com> wrote:
> >>
> >> We only use count for kmalloc hashtab not for prealloc hashtab, becaus=
e
> >> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.
> >>
> >> But the problem is that __pcpu_freelist_pop() will traverse all CPUs a=
nd
> >> spin_lock for all CPUs to find there is no more elem at last.
> >>
> >> We encountered bad case on big system with 96 CPUs that alloc_htab_ele=
m()
> >> would last for 1ms. This patch use count for prealloc hashtab too,
> >> avoid traverse and spin_lock for all CPUs in this case.
> >>
> >> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> >
> > It's not clear from the commit log what you're solving.
> > The atomic inc/dec in critical path of prealloc maps hurts performance.
> > That's why it's not used.
> >
> Thanks for the explanation, what I'm solving is when hash table hasn't fr=
ee
> elements, we don't need to call __pcpu_freelist_pop() to traverse and
> spin_lock all CPUs. The ftrace output of this bad case is below:
>
>  50)               |  htab_map_update_elem() {
>  50)   0.329 us    |    _raw_spin_lock_irqsave();
>  50)   0.063 us    |    lookup_elem_raw();
>  50)               |    alloc_htab_elem() {
>  50)               |      pcpu_freelist_pop() {
>  50)   0.209 us    |        _raw_spin_lock();
>  50)   0.264 us    |        _raw_spin_lock();

This is LRU map. Not hash map.
It will grab spin_locks of other cpus
only if all previous cpus don't have free elements.
Most likely your map is actually full and doesn't have any free elems.
Since it's an lru it will force free an elem eventually.
