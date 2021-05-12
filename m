Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA337F03A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 02:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhEMAF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 20:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352660AbhEMAB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 20:01:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87064C061379;
        Wed, 12 May 2021 16:39:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q15so15313467pgg.12;
        Wed, 12 May 2021 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aGfzMiuiCCtvZswOkm4Od1Y3YxVLjQnaUsfjgGWQ9Wg=;
        b=LHw5pvZdaxJVwSpYjcuiyTtUim9nCjJyqH5aMSX75v53AlSlmQIfaGijq5S45PhmUK
         K7VE2xHkUcOYkmshJea5ud2Xhb2cmBnRS1AzPLuHlcqT/QiKOrrGhCQP+CC793Bd4PeL
         qFHV0IOgiJeSVhLie81mfHjc+h/OGd3W1Q3HVIcr6V2iLL605aTthXs6VuUSyR+XWxEx
         i5hh0yybNBD38zo0PeB+vMyjD0rkeOrlapoCvOIhD97qMTo2XMCjYS1k1auFuH2NInRY
         qCaReSw3tA7PA0te1xSmq52u4/pGYj1e8U93cWF8lRTx+OyOxgjsGVaksZk1cwpDy6cm
         m+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aGfzMiuiCCtvZswOkm4Od1Y3YxVLjQnaUsfjgGWQ9Wg=;
        b=QnZrGOWzOQxzB6sdJnivVDrct0TJuN1P9f6PLX/h3fwGrjN2T6syxCCXAan66iq52W
         vjavV1M631daABF4Zlmg2AXMziOY/5qFG7v3fksngQsS5VwWzgEL7004ido1bN6pCJIX
         DsG7C4Od2tix3QFMd6Wf3LoAx6dTa5wi2+QbOhCvC6nk0eHSSluo/g6v0PmR962IsbAk
         E3Bf1d1ndZddBXFMeA2FugB+qmPL7EwHwen312jFJXUWeX+Dfer1eoYGYe/Z74vyg4t0
         ShFljdwJHxlFE2l7Pyt9CYsrqQV0Wo1y7U3QbSsvoJJUiJ6aC65+fDTcwR1V/LOwJXh+
         kgiw==
X-Gm-Message-State: AOAM532ii4SJyTHHOrpAKUQwvG264x5+SQYubgtKksUvEJaN8FRHnMJd
        nNM0Ih1TDccThDJWNxHC+EZdX3v1rPw=
X-Google-Smtp-Source: ABdhPJy47cGeqyWRgxLkYY1gQw6rrRnoQTBgO64E1847V4Zn9evccGm4GPgsEQo47L5KmoFqqdla4A==
X-Received: by 2002:a63:ff66:: with SMTP id s38mr38340713pgk.154.1620862753048;
        Wed, 12 May 2021 16:39:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c6f4])
        by smtp.gmail.com with ESMTPSA id gb9sm5316253pjb.7.2021.05.12.16.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:39:12 -0700 (PDT)
Date:   Wed, 12 May 2021 16:39:07 -0700
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
Message-ID: <20210512233907.skhbwmbnwaajnscm@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp>
 <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com>
 <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbJ==4iUFp4pYpkgbKy40+Q6+RTPJVh0gUANHajs88ZTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbJ==4iUFp4pYpkgbKy40+Q6+RTPJVh0gUANHajs88ZTg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 11:50:19AM -0700, Andrii Nakryiko wrote:
> 
> It's not so clear. static allows to have different library names for
> different files. Currently we enforce that version and license
> contents match. It's part of what I said earlier that it feels like we
> need two separate linking commands: one for building BPF libraries and
> one for linking BPF applications. Which is not that far from
> user-space, where you linked shared libraries with a special options.
> We just want BPF static libraries to have properties of user-space BPF
> shared libraries (w.r.t. protection at least). We can discuss it at
> office hours, though.

If we're saying "no" to .a archives (which is user space definition
of static library) then we can reuse the name "BPF static library"
to mean linked .o that is intermediate step towards bpf application .o.
We also need to distinguish BPF static and dynamic libraries.
The dynamic libs would be already loaded in the kernel.
They will be seen by the kernel as partially verified bpf programs.
We can support both global and static style of
the verification for such dynamic libs. The global entry functions
will be verified as global funcs and static funcs can be loaded
without verification if they're not called.
The static funcs wouldn't be static in C file, of course,
since we've put a stop on static visibility.
They would probably need to be global __hidden similar to what
we already do in libbpf with static linking.
The rules we pick should be consistent for dynamic and static libs.
The workflow of loading bpf dynamic library into the kernel and using
it from the application can be made to look very similar to
using bpf static library.

> > After that is done and mmap-ing of data/rodata/bss is done
> > the main skeleton will init sub-skeleton with offsets to their
> > corresponding data based on these offsets?
> > I think that will work for light skel.
> 
> What I had in mind kept skeleton completely isolated from
> sub-skeleton. Think about this, when BPF library author is compiling
> it's user-space parts that use sub-skeleton, they don't and generally
> speaking can't know anything about the final BPF application, so they
> can't have any access to the final skeleton. But they need
> code-generated sub-skeleton header file, similarly to BPF skeleton
> today. So at least for BPF skeleton, the flow I was imagining would be
> like this.
> 
> 1. BPF library abc consists of abc1.bpf.c and abc2.bpf.c. It also has
> user-space component in abc.c.
> 2. BPF app uses abs library and has its own app1.bpf.c and app2.bpf.c
> and app.c for user-space.
> 3. BPF library author sets up its Makefile to do
>   a. clang -target bpf -g -O2 -c abc1.bpf.c -o abc1.bpf.o
>   b. clang -target bpf -g -O2 -c abc2.bpf.c -o abc2.bpf.o
>   c. bpftool gen lib libabc.bpf.o abc1.bpf.o abc2.bpf.o
>   d. bpftool gen subskeleton libabc.bpf.o > libabc.subskel.h
>   e. abc.c (user-space library) is of the form
> 
> #include "libabc.subskel.h"
> 
> static struct libabc_bpf *subskel;
> 
> int libabc__init(struct bpf_object *obj)
> {
>     subskel = libabc_bpf__open_subskel(obj);

right. I was thinking the same for lskel except
there is no 'bpf_object'.
Either subskel_open will receive already adjusted addresses
from the main skel or they will be grouped into aux struct.

>     subskel->data->abc_my_var = 123;

and then library's custom init can do exactly this line.

> }
> 
> int libabc__attach()
> {
>     libabc_bpf__attach(subskel);
> }
> 
>   f. cc abc.c into libabc.a and then libabc.a and libabc.bpf.o are
> distributed to end user
> 
> 3. Now, from BPF application author side:
>   a. clang -target bpf -g -O2 -c app1.bpf.c -o app1.bpf.o
>   b. clang -target bpf -g -O2 -c app2.bpf.c -o app2.bpf.o
>   c. bpftool gen object app.bpf.o app1.bpf.o app2.bpf.o libabc.bpf.o
>   d. on user-space side of app in app.c
> 
> #include "app.skel.h"
> 
> int main()
> {
>     struct app_bpf *skel;
> 
>     skel = app_bpf__open();
>     skel->rodata->app_var = 123;
> 
>     libabc__init(skel->obj);
> 
>     app_bpf__load(skel);
> 
>     libabc__attach();
> 
>     /* probably shouldn't auto-attach library progs, but don't know
> yet how to prevent that */
>     app_bpf__attach(skel);
> 
>     /* do some useful logic now */
> }
> 
>   e. cc app.c -o app && sudo ./app

right. That's a necessary workflow.

> So, app author doesn't need and doesn't have direct access to
> subskeleton header. And sub-skeleton header is generated by BPF
> library way before the library is linked into the final application.

right. We certainly need that for dynamic and static bpf libs.
