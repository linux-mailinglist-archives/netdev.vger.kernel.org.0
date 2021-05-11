Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFF737B221
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhEKXGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhEKXGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 19:06:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF9CC061574;
        Tue, 11 May 2021 16:05:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b15so5385628plh.10;
        Tue, 11 May 2021 16:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZ04Cdi1Q+iZSR9td6ccoqa0ATxHeCbWNy7peeaFY2I=;
        b=hCNWboKRcRvHv34X4VY3Kf/5XLiv+njGQyG7Od1lWrabsw4BTwlsiXqTEYEfP52jIs
         dwfmSDJb/NVzRdKrPRMZYElJ4g+Yr4/eDNXvri1CNl4ces2jthrtCHlSZz4+KCjaPook
         bf+P4cU9Qx6F7nVw/wd+HBLuWwmTWqwvb+dzG4Z6ne8TM2cF1g3Rhxlic8vPcWS2P23u
         1CbYfO2lDMneMZU0UPoDa9bGriOa4amMXha0Wnia8g/dFDeEHxEa2tZl8ouPSMg/kqm/
         pmg6WtQapsmEF8AE6+JPXcFT/M5lFYZzlCVdiid+zDg70h8sYohTeeMJb2PoapwdXcJG
         DnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mZ04Cdi1Q+iZSR9td6ccoqa0ATxHeCbWNy7peeaFY2I=;
        b=Ds7Gg/qOFBzbDeKlS8zI+ayTEUozOyhVYl8gm7wdJXYvGMCq83D1XCS43EHVRLARGr
         2K+BeYbCTZqSOZdZvLqwYCN8QI/LjqGr7tTCtZNHb0MKfJb+7FU2Mmd8/y1dL4YL3O6v
         SOb8tY/h33F/pZB1ssP7gEFCAEdOUcajvNN3b0eR3l81Q8zTj+IM8XFnFlLTq49U/okW
         fVrsWv/ZuVc24busHsWHEEH1LCDAeVZSekXr2GBx9jaV8e/KofD7JRSxK3s6KVFMjXTy
         t5vrt9CLLaELIWBHT7kZaUlwFHVQ5aRVKV/Gj5v4mMOQDYDctQTKvbnGLhzBq4nfPwpV
         mEhA==
X-Gm-Message-State: AOAM530ES3T6+Iaz3O8m9VyhIqmVoRp0SfJDpSMozdVtVABnYfMCxhEX
        qtH56+AHhomTxcit27hYQoI=
X-Google-Smtp-Source: ABdhPJzg69bAEHAQkG3RWJuFv6jaj+opmRV5orf412RfIvmAyhHbBHY5hEjvbU12TZ8o9WY/DKlwlA==
X-Received: by 2002:a17:90a:ea13:: with SMTP id w19mr4871692pjy.215.1620774309966;
        Tue, 11 May 2021 16:05:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:eb4c])
        by smtp.gmail.com with ESMTPSA id x35sm14156364pfu.209.2021.05.11.16.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 16:05:09 -0700 (PDT)
Date:   Tue, 11 May 2021 16:05:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
Message-ID: <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp>
 <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 11:59:01AM -0700, Andrii Nakryiko wrote:
> >
> > If I understood what folks were saying no one is excited about namespaces in C.
> > So probably #3 is out and sounds like 1 is prefered?
> > So don't emit statics ?
> >
> 
> I'm in favor of not emitting statics. They just seem to cause more
> problems than providing any extra benefits. Given it's trivial to just
> use globals instead and global vs static is already an explicit signal
> of what has to be in BPF skeleton and what's not. See my RFC about
> __internal + __hidden semantics, but even if we supported nothing but
> STV_DEFAULT globals wouldn't be horrible. Clearly we'd expect users to
> just not mess with BPF library's internal state with not way to
> enforce that, so I'd still like to have some enforceability.

I'm glad that with Daniel and Lorenz we have a strong consensus here.
So I've applied first 6 patches from your RFC that stop exposing static
in skeleton and fix tests.
I'm only not 100% sure whether
commit 31332ccb7562 ("bpftool: Stop emitting static variables in BPF skeleton")
is enough to skip them reliably.
I think 'char __pad[N]' logic would do the rigth thing when
statics and globals are interleaved, but would be good to have a test.
In one .o file clang emits all globals first and then all statics,
so even without __pad it would have been enough,
but I don't know how .o-s with statics+global look after static linker combines them.

I skipped patch 7, since without llvm part it cannot be used and it's
not clear yet whether llvm will ever be able to emit __internal.

> So my proposal is to allow having a special "library identifier"
> variable, e.g., something like:
> 
> SEC(".lib") static char[] lib_name = "my_fancy_lib"; (let's not
> bikeshed naming for now)

without 'static' probably? since license and version are without?

and at will be optional (mostly ignored by toolchain) for libs that
don't need sub-skeleton and mandatory for sub-skeleton?

> With such library identifiers, BPF static linker will:
>   1) enforce uniqueness of library names when linking together
> multiple libraries

you're not proposing for lib name to do namespacing of globals, right?
Only to indicate that liblru.o and libct.o (as normal elf files)
are bpf libraries as can be seen in their 'lib_name' strings
instead of regular .o files.
(that would be a definition of bpf library).
So linker can rely on explicit library names given by users in .bpf.c
(and corresponding dependency on sub-skel) instead of relying
on file names?
If so, I agree that it's necessary.
Such 'char lib_name[]' is probably better than elf note.

>   2) append zero-size markers to the very beginning and the very end
> of each BPF library's DATASECS, something like
> 
> DATASEC .data:
> 
>    void *___my_fancy_lib__start[0];
>    /* here goes .data variables */
>    void *___my_fancy_lib__end[0];
> 
> And so on for each DATASEC. What those markers provide? Two things:
> 
> 1). It makes it much easier for sub-skeleton to find where a
> particular BPF library's .data/.rodata/.bss starts within the final
> BPF application's  .data/.rodata/.bss section. All that without
> storing local BTF and doing type comparisons. Only a simple loop over
> DATASECs and its variables is needed.

indeed. some lib name or rather sub-skeleton name is needed.
Since progs can have extern funcs in the lib I see no clean way to
reliably split prog loading between main skeleton and sub-skeletons.
Meaning that prog loading and map creation can only be done
by the main skeleton.
After that is done and mmap-ing of data/rodata/bss is done
the main skeleton will init sub-skeleton with offsets to their
corresponding data based on these offsets?
I think that will work for light skel.
I don't see a use case for __end marker yet, but I guess it's good
for consistency.
rodata init is tricky.
Since the main skel and sub-skels will init their parts independently.
But I think it can be managed.

> 2). (optionally) we can exclude everything between ___<libname>__start
> and ___<libname>__end from BPF application's skeleton.

So that's leaning towards namespacing ideas?
The lib_name doesn't hide any names and globals will conflict during
the linking as usual.
But with this optional hiding (inside .bpf.c it will have special name?)
the partial namespacing can happen. And the lib can hide the stuff
from its users.
The concept is nice, but lib scope maybe too big.

> It's a pretty long email already and there are a lot things to unpack,
> and still more nuances to discuss. So I'll put up BPF static linking +
> BPF libraries topic for this week's BPF office hours for anyone
> interested to join the live discussion. It would hopefully allow
> everyone to get more up to speed and onto the same page on this topic.
> But still curious WDYT?

Sounds great to me. I hope more folks can join the discussion.
