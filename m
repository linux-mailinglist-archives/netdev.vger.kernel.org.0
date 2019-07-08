Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F9962AE5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbfGHVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:20:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39195 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732476AbfGHVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:20:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id j2so8202082pfe.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x0Zfx6J5t7C/VzP4ZN5cW6JbMAzBqC9yvvudAewYVms=;
        b=j4p9XZTMkEzSKYqVZPxUg2rMJvfHYOORuJ4dPSpE9FIqvH+ZIkEVxGyj9/SqiCBbu0
         8kJlJc0qJFD3ybchVBgAZLiPMDtNVbDRbcEcOFWd5G/slaXjXwvw9zYTcpR3UsujvDkT
         p5VIAG3c6CCPZmkQy74ctskMMjiUbNIwXvMxMW13mhheuAdR0CtDnTADu9pFV6txSzPo
         JzvRnwfYX45rQVNUa+BhSLAR8nwvBAmGxCj2v0v2+4YHL1gAKa08p638RCBxYeKAReQ8
         vgdT1SFYwqnqsiXc7hb8zOzR1RgS+gEGDVL9w84tPoaJZd+GU9blYKBaxL4VOSOaqnEy
         VFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x0Zfx6J5t7C/VzP4ZN5cW6JbMAzBqC9yvvudAewYVms=;
        b=nORuPugQPFUVyWmjGJVDfd/PQClj+5/PDo86cxOYAWqjPfXbEBWoMBX+YYNB+1arno
         AYk85lp1yvKVP0i+iO1RlGb/SBf7vGxc4P5G5akAyyntL27VG91oXmYU2ajam7tECBLz
         f+LjM9cc3aEFLqFV17djZbN2urNdFOODecKnp0Bp4p3HHHDVzJ1til6KfduHrV8zyIJA
         R36A0g9oXLT+Zdh+kgGdwl32UgdXLEWyrQBwPXlnG/SsHmoV2NICzWfdvG6uQKKLjGvJ
         EAVKsBOrQ4Ag6B9tGQV8Kh5+iGJWMD77K6VEd1FB7v3WQtFc44/UxZBnkXP7DBSjNQZn
         ocXA==
X-Gm-Message-State: APjAAAWZqrXn4s1V+GHQNze0bm1VWD/aQUe/YVAXmi0TURu8fZckueED
        0tZD8hpg9iRU1/PgcbJDctK8Qg==
X-Google-Smtp-Source: APXvYqwd0ctnUcrtexli5I1HDrCKU72TCRH08/KkYtJXxraMc73AiwFsB4/pGyQqzoslmKdYgLLe6A==
X-Received: by 2002:a17:90b:d8a:: with SMTP id bg10mr28390728pjb.92.1562620813471;
        Mon, 08 Jul 2019 14:20:13 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e11sm23767917pfm.35.2019.07.08.14.20.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:20:12 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:20:12 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Y Song <ys114321@gmail.com>, Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] selftests/bpf: make verifier loop tests arch
 independent
Message-ID: <20190708212012.GA9509@mini-arch>
References: <20190703205100.142904-1-sdf@google.com>
 <CAH3MdRWePmAZNRfGNcBdjKAJ+D33=4Vgg1STYC3khNps8AmaHQ@mail.gmail.com>
 <20190708161338.GC29524@mini-arch>
 <99593C98-5DEC-4B18-AE6D-271DD8A8A7F6@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99593C98-5DEC-4B18-AE6D-271DD8A8A7F6@linux.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08, Ilya Leoshkevich wrote:
> 
> 
> > Am 08.07.2019 um 18:13 schrieb Stanislav Fomichev <sdf@fomichev.me>:
> > 
> > On 07/03, Y Song wrote:
> >> On Wed, Jul 3, 2019 at 1:51 PM Stanislav Fomichev <sdf@google.com> wrote:
> >>> 
> >>> Take the first x bytes of pt_regs for scalability tests, there is
> >>> no real reason we need x86 specific rax.
> >>> 
> >>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>> ---
> >>> tools/testing/selftests/bpf/progs/loop1.c | 3 ++-
> >>> tools/testing/selftests/bpf/progs/loop2.c | 3 ++-
> >>> tools/testing/selftests/bpf/progs/loop3.c | 3 ++-
> >>> 3 files changed, 6 insertions(+), 3 deletions(-)
> >>> 
> >>> diff --git a/tools/testing/selftests/bpf/progs/loop1.c b/tools/testing/selftests/bpf/progs/loop1.c
> >>> index dea395af9ea9..d530c61d2517 100644
> >>> --- a/tools/testing/selftests/bpf/progs/loop1.c
> >>> +++ b/tools/testing/selftests/bpf/progs/loop1.c
> >>> @@ -14,11 +14,12 @@ SEC("raw_tracepoint/kfree_skb")
> >>> int nested_loops(volatile struct pt_regs* ctx)
> >>> {
> >>>        int i, j, sum = 0, m;
> >>> +       volatile int *any_reg = (volatile int *)ctx;
> >>> 
> >>>        for (j = 0; j < 300; j++)
> >>>                for (i = 0; i < j; i++) {
> >>>                        if (j & 1)
> >>> -                               m = ctx->rax;
> >>> +                               m = *any_reg;
> >> 
> >> I agree. ctx->rax here is only to generate some operations, which
> >> cannot be optimized away by the compiler. dereferencing a volatile
> >> pointee may just serve that purpose.
> >> 
> >> Comparing the byte code generated with ctx->rax and *any_reg, they are
> >> slightly different. Using *any_reg is slighly worse, but this should
> >> be still okay for the test.
> >> 
> >>>                        else
> >>>                                m = j;
> >>>                        sum += i * m;
> >>> diff --git a/tools/testing/selftests/bpf/progs/loop2.c b/tools/testing/selftests/bpf/progs/loop2.c
> >>> index 0637bd8e8bcf..91bb89d901e3 100644
> >>> --- a/tools/testing/selftests/bpf/progs/loop2.c
> >>> +++ b/tools/testing/selftests/bpf/progs/loop2.c
> >>> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
> >>> int while_true(volatile struct pt_regs* ctx)
> >>> {
> >>>        int i = 0;
> >>> +       volatile int *any_reg = (volatile int *)ctx;
> >>> 
> >>>        while (true) {
> >>> -               if (ctx->rax & 1)
> >>> +               if (*any_reg & 1)
> >>>                        i += 3;
> >>>                else
> >>>                        i += 7;
> >>> diff --git a/tools/testing/selftests/bpf/progs/loop3.c b/tools/testing/selftests/bpf/progs/loop3.c
> >>> index 30a0f6cba080..3a7f12d7186c 100644
> >>> --- a/tools/testing/selftests/bpf/progs/loop3.c
> >>> +++ b/tools/testing/selftests/bpf/progs/loop3.c
> >>> @@ -14,9 +14,10 @@ SEC("raw_tracepoint/consume_skb")
> >>> int while_true(volatile struct pt_regs* ctx)
> >>> {
> >>>        __u64 i = 0, sum = 0;
> >>> +       volatile __u64 *any_reg = (volatile __u64 *)ctx;
> >>>        do {
> >>>                i++;
> >>> -               sum += ctx->rax;
> >>> +               sum += *any_reg;
> >>>        } while (i < 0x100000000ULL);
> >>>        return sum;
> >>> }
> >>> --
> >>> 2.22.0.410.gd8fdbe21b5-goog
> >> 
> >> Ilya Leoshkevich (iii@linux.ibm.com, cc'ed) has another patch set
> >> trying to solve this problem by introducing s360 arch register access
> >> macros. I guess for now that patch set is not needed any more?
> > Oh, I missed them. Do they fix the tests for other (non-s360) arches as
> > well? I was trying to fix the issue by not depending on any arch
> > specific stuff because the test really doesn't care :-)
> 
> They are supposed to work for everything that defines PT_REGS_RC in
> bpf_helpers.h, but I have to admit I tested only x86_64 and s390.
> 
> The main source of problems with my approach were mismatching definitions
> of struct pt_regs for userspace and kernel, and because of that there was
> some tweaking required for both arches. I will double check how it looks
> for others (arm, mips, ppc, sparc) tomorrow.
Thanks, I've tested your patches and they fix my issue as well. So you
can have my Tested-by if we'd go with your approach.

One thing I don't understand is: why do you add 'ifdef __KERNEL__' to
the bpf_helpers.h for x86 case? Who is using bpf_helpers.h with
__KERNEL__ defined? Is it perf?

> Best regards,
> Ilya
