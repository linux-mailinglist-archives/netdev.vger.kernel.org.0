Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2A195AB
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEIXa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:30:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42003 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIXa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:30:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id 13so2117353pfw.9;
        Thu, 09 May 2019 16:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X0EhyXdJpFVtlXticnttUl+SFARY0aY87LKd2dIvVQ8=;
        b=rrj6r2+N1eUkVzqShP8wkR/b9dISnZO4EA4/zEYCDIsQVJRV6JHfrGWn4pffCN8o19
         TjKH+cTIIbMC/vk7M2MYHc3hfBV3/Z9ZCGaJ+dDwTsdLLWKN7zEFxu/yDB1hUbLcWpD4
         J+aqLuu98mK5B9LoN13oHSm+YP6vt6AWbsc1edwLBbojpiC44zKcwMGxk4hNBlYAFZA9
         MaJrtJlogckB8GqGFFjEIFs0AIueoAXgMBv+k4QhrzUWSmcDg1mZoF057ghznJTZ8lW3
         i8801UXoWWBshjd3+Cjp5o2ynv52vsODS1SPZVVA3RlgHpcMcVseiv5ICupUqZkO7f/V
         DD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X0EhyXdJpFVtlXticnttUl+SFARY0aY87LKd2dIvVQ8=;
        b=LWgSE7tzuPSmbrK++DQNheKwteG6iTdeNDorYX1Vali3DAWy1TRKrbaVcVhNhl5qaZ
         D58g35sQtQaYtH/eZlyVGrFRceXDR3jakA7IZGuP7i0AWjWzX8+zXqVofpWpLl/YWkuM
         trH92mmpKZQKOj0PNgw1oGedXawnjsvN/vO7MFjLXdzdEnWpB0/yN120ikejNocAiFER
         x4z+NH68Tq12LAYTMwx0zxgU359GL3scbiMPjBM4PyydY99x904k/7ZCtSEVEh34A0Zn
         nGRt6v5ZB3hcgEN0DLhuxacBQmEpt7YaSfJ2TA7bN7bmuak85DrDNzmcr2+j/xOVPOrC
         Au5w==
X-Gm-Message-State: APjAAAWDARFm1jHyPfv6cnp2vKPjhD0oIAK3Tv4T3/kzzPN5OxCWUTOf
        X5WHYJ+M/STdYbCPj1qS4Y0=
X-Google-Smtp-Source: APXvYqzI97GIocrYRREfaeAKKWQFV8YHUZCzCufPgYLgIUCfogXgsBmDXjrh21GF1y2tRQOtIywCWQ==
X-Received: by 2002:a63:d252:: with SMTP id t18mr9426277pgi.131.1557444627765;
        Thu, 09 May 2019 16:30:27 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::bc44])
        by smtp.gmail.com with ESMTPSA id r12sm4762439pfn.144.2019.05.09.16.30.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:30:26 -0700 (PDT)
Date:   Thu, 9 May 2019 16:30:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: Question about seccomp / bpf
Message-ID: <20190509233023.jrezshp2aglvoieo@ast-mbp>
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
 <20190508230941.6rqccgijqzkxmz4t@ast-mbp>
 <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
 <20190509044720.fxlcldi74atev5id@ast-mbp>
 <CANn89i+v52ktezz5J_0of_EvTUozf86rP1Uh36HpbHf33uzDJg@mail.gmail.com>
 <CANn89iK8e8ROW8CrtTDq9-_bFeg2MdeqAdjf10i6HiwKuaZi=g@mail.gmail.com>
 <e525ec9d-df46-4280-b1c8-486a809f61e6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e525ec9d-df46-4280-b1c8-486a809f61e6@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 01:49:25PM +0200, Daniel Borkmann wrote:
> On 05/09/2019 12:58 PM, Eric Dumazet wrote:
> > On Thu, May 9, 2019 at 3:52 AM Eric Dumazet <edumazet@google.com> wrote:
> >> On Wed, May 8, 2019 at 9:47 PM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>> On Wed, May 08, 2019 at 04:17:29PM -0700, Eric Dumazet wrote:
> >>>> On Wed, May 8, 2019 at 4:09 PM Alexei Starovoitov
> >>>> <alexei.starovoitov@gmail.com> wrote:
> >>>>> On Wed, May 08, 2019 at 02:21:52PM -0700, Eric Dumazet wrote:
> >>>>>> Hi Alexei and Daniel
> >>>>>>
> >>>>>> I have a question about seccomp.
> >>>>>>
> >>>>>> It seems that after this patch, seccomp no longer needs a helper
> >>>>>> (seccomp_bpf_load())
> >>>>>>
> >>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8
> >>>>>>
> >>>>>> Are we detecting that a particular JIT code needs to call at least one
> >>>>>> function from the kernel at all ?
> >>>>>
> >>>>> Currently we don't track such things and trying very hard to avoid
> >>>>> any special cases for classic vs extended.
> >>>>>
> >>>>>> If the filter contains self-contained code (no call, just inline
> >>>>>> code), then we could use any room in whole vmalloc space,
> >>>>>> not only from the modules (which is something like 2GB total on x86_64)
> >>>>>
> >>>>> I believe there was an effort to make bpf progs and other executable things
> >>>>> to be everywhere too, but I lost the track of it.
> >>>>> It's not that hard to tweak x64 jit to emit 64-bit calls to helpers
> >>>>> when delta between call insn and a helper is more than 32-bit that fits
> >>>>> into call insn. iirc there was even such patch floating around.
> >>>>>
> >>>>> but what motivated you question? do you see 2GB space being full?!
> >>>>
> >>>> A customer seems to hit the limit, with about 75,000 threads,
> >>>> each one having a seccomp filter with 6 pages (plus one guard page
> >>>> given by vmalloc)
> >>>
> >>> Since cbpf doesn't have "fd as a program" concept I suspect
> >>> the same program was loaded 75k times. What a waste of kernel memory.
> >>> And, no, we're not going to extend or fix cbpf for this.
> >>> cbpf is frozen. seccomp needs to start using ebpf.
> >>> It can have one program to secure all threads.
> >>> If necessary single program can be customized via bpf maps
> >>> for each thread.
> >>
> >> Yes,  docker seems to have a very generic implementation and  should
> >> probably be fixed
> >> ( https://github.com/moby/moby/blob/v17.03.2-ce/profiles/seccomp/seccomp.go )
> > 
> > Even if the seccomp program was optimized to a few bytes, it would
> > still consume at least 2 pages in module vmalloc space,
> > so the limit in number of concurrent programs would be around 262,144
> > 
> > We might ask seccomp guys to detect that the same program is used, by
> > maintaining a hash of already loaded ones.
> > ( I see struct seccomp_filter has a @usage refcount_t )
> 
> +1, that would indeed be worth to pursue as a short term solution.

I'm not sure how that can work. seccomp's prctl accepts a list of insns.
There is no handle.
kernel can keep a hashtable of all progs ever loaded and do a search
in it before loading another one, but that's an ugly hack.
Another alternative is to attach seccomp prog to parent task
instead of N childrens.

