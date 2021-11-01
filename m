Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657294423D6
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhKAXRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhKAXRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:17:15 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A46C061764;
        Mon,  1 Nov 2021 16:14:41 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 131so36942392ybc.7;
        Mon, 01 Nov 2021 16:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3X+23GliW4zdXKrlECgpOzMA41mPXcLxYhtwK6MVl5M=;
        b=lOQl+d4b6zW6Crd9GwcPib7+gkPzpK6352C3JunkMmhZUYqY7BmkFbk9tHgjJqFIrA
         oPGd4X706Q8LDxuJPeayKfMcwxnqMBKdOQHWi8EFlyRVmlOSd2y1I0z7amDLrTmxekwj
         BJlaE1DDsDTQllSfmoRv4xylHmQ5RpDRDWoRENpLyy1xin1mrCWT+dg35QMS7lKRYi5A
         jRsyNnDyAa4HT8C7DsAA7HUzU8hYH/v4GyvaXODcUZNpa8jJyLtqAULxy/Gi7NjNIXsG
         nGfoKBF1nHtMX6ZguuOC82R3a7WXGeDkvXbX+btr93wJbjrEiqioy45Mx9i/6p1M35Ku
         IZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3X+23GliW4zdXKrlECgpOzMA41mPXcLxYhtwK6MVl5M=;
        b=C/wOCt3ojeda461G5m4MgDsZB6NuxD6lFbdmpFTqHr6llI2M6LjchYVMLln2BtO1UK
         sICboUUP4Ntsad/9W+4oti3KteQLDIJLs9XQRTTdjQNaBczz137NGbnJ4v9UxnTcbMpk
         nmrd7UmMa+K9XngtufgP9Uf+2VDVo5wl1iBCs8/pPwyzXYgGcz62S9y2NBo3G1jFGF5M
         sLUWcwTBpbNsk0WA3DnQGZSW2sbjqssbvWB7es0PiqgLf95olcP1RzJ1eqfuMmdhg1QO
         dhoP3c+KQnzembDguL5ACaHFNB5jzHnCG7NDOZSaR/GKPDEy+U0FdOzMV5D4SM1rjCE5
         BTxA==
X-Gm-Message-State: AOAM533abulCCblrB2A3X9ZmWJoOlLYUBdj9FCtuIBX7rRzgtx+WI4Zq
        ggiF1m8q+jt0RBbZ1ALccVsxZlXbgzkYUYbRiDo=
X-Google-Smtp-Source: ABdhPJxJmy2F4RJGo/+6ULpROz/8c5z7XKBkts0JUvLQ077E3FH1kb7Ae6zPUT/u6U5aU8Nt05+/ci4S+OGWgHFqsUo=
X-Received: by 2002:a25:d010:: with SMTP id h16mr25410293ybg.225.1635808481046;
 Mon, 01 Nov 2021 16:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org> <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava> <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava> <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
 <YXmX4+HDw9rghl0T@krava> <YXr2NFlJTAhHdZqq@krava>
In-Reply-To: <YXr2NFlJTAhHdZqq@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Nov 2021 16:14:29 -0700
Message-ID: <CAEf4BzY1WLO+OmRQnRuJZc_-TEM12VZxd6RKQOrxWjT84KqBXw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 12:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 27, 2021 at 08:18:11PM +0200, Jiri Olsa wrote:
> > On Wed, Oct 27, 2021 at 10:53:55AM -0700, Andrii Nakryiko wrote:
> > > On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > > > > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > >
> > > > > > > > hi,
> > > > > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > > > > >
> > > > > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > > > > from kernel-core and kernel-module packages:
> > > > > > > >
> > > > > > > >                current   new
> > > > > > > >       aarch64      60M   76M
> > > > > > > >       ppc64le      53M   66M
> > > > > > > >       s390x        21M   41M
> > > > > > > >       x86_64       64M   79M
> > > > > > > >
> > > > > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > > > > has many small modules that increased significantly in size because
> > > > > > > > of that even after compression.
> > > > > > > >
> > > > > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > > > > to pahole for kernel module BTF generation.
> > > > > > > >
> > > > > > > > The other problem is more tricky and is the reason why this patchset
> > > > > > > > is RFC ;-)
> > > > > > > >
> > > > > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > > > > >
> > > > > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > > > > >
> > > > > > > > Please let me know if you'd like to see other info/files.
> > > > > > > >
> > > > > > >
> > > > > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > > > > corresponding kernel image with BTF in it?
> > > > > >
> > > > > > sure, uploaded
> > > > > >
> > > > >
> > > > > vmlinux.btfdump:
> > > > >
> > > > > [174] FLOAT 'float' size=4
> > > > > [175] FLOAT 'double' size=8
> > > > >
> > > > > VS
> > > > >
> > > > > pnet.btfdump:
> > > > >
> > > > > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > > > > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> > > >
> > > > ugh, that's with no fix applied, sry
> > > >
> > > > I applied the first patch and uploaded new files
> > > >
> > > > now when I compare the 'module' struct from vmlinux:
> > > >
> > > >         [885] STRUCT 'module' size=1280 vlen=70
> > > >
> > > > and same one from pnet.ko:
> > > >
> > > >         [89323] STRUCT 'module' size=1280 vlen=70
> > > >
> > > > they seem to completely match, all the fields
> > > > and yet it still appears in the kmod's BTF
> > > >
> > >
> > > Ok, now struct module is identical down to the types referenced from
> > > the fields, which means it should have been deduplicated completely.
> > > This will require a more time-consuming debugging, though, so I'll put
> > > it on my TODO list for now. If you get to this earlier, see where the
> > > equivalence check fails in btf_dedup (sprinkle debug outputs around to
> > > see what's going on).
> >
> > it failed for me on that hypot_type_id check where I did fix,
> > I thought it's the issue of multiple same struct in the kmod,
> > but now I see I might have confused cannon_id with cand_id ;-)
> > I'll check more on this
>
> with more checking I got to the same conclusion as before,
> now maybe with little more details ;-)
>
> the problem seems to be that in some cases the module BTF
> data stores same structs under new/different IDs, while the
> kernel BTF data is already dedup-ed
>
> the dedup algo keeps hypot_map of kernel IDs to kmod IDs,
> and in my case it will get to the point that the kernel ID
> is already 'known' and points to certain kmod ID 'A', but it
> is also equiv to another kmod ID 'B' (so kmod ID 'A' and 'B'
> are equiv structs) but the dedup will claim as not equiv
>
>
> This is where the dedup fails for me on that s390 data:
>
> The pt_regs is defined as:
>
>         struct pt_regs
>         {
>                 union {
>                         user_pt_regs user_regs;
>                         struct {
>                                 unsigned long args[1];
>                                 psw_t psw;
>                                 unsigned long gprs[NUM_GPRS];
>                         };
>                 };
>                 ...
>         };
>
> considering just the first union:
>
>         [186] UNION '(anon)' size=152 vlen=2
>                 'user_regs' type_id=183 bits_offset=0
>                 '(anon)' type_id=181 bits_offset=0
>
>         [91251] UNION '(anon)' size=152 vlen=2
>                 'user_regs' type_id=91247 bits_offset=0
>                 '(anon)' type_id=91250 bits_offset=0
>
>
> ---------------------------------------------------------------
>
> Comparing the first member 'user_regs':
>
>         struct pt_regs
>         {
>                 union {
>     --->                user_pt_regs user_regs;
>                         struct {
>                                 unsigned long args[1];
>                                 psw_t psw;
>                                 unsigned long gprs[NUM_GPRS];
>                         };
>                 };
>
> Which looks like:
>
>         typedef struct {
>                 unsigned long args[1];
>                 psw_t psw;
>                 unsigned long gprs[NUM_GPRS];
>         } user_pt_regs;
>
>
> and is also equiv to the next union member struct.. and that's what
> kernel knows but not kmod... anyway,
>
>
> the dedup will compare 'user_pt_regs':
>
>         [183] TYPEDEF 'user_pt_regs' type_id=181
>
>         [91247] TYPEDEF 'user_pt_regs' type_id=91245
>
>
>         [181] STRUCT '(anon)' size=152 vlen=3
>                 'args' type_id=182 bits_offset=0
>                 'psw' type_id=179 bits_offset=64
>                 'gprs' type_id=48 bits_offset=192
>
>         [91245] STRUCT '(anon)' size=152 vlen=3
>                 'args' type_id=91246 bits_offset=0
>                 'psw' type_id=91243 bits_offset=64
>                 'gprs' type_id=91132 bits_offset=192
>
> and make them equiv by setting hypot_type_id for 181 to be 91245
>
>
> ---------------------------------------------------------------
>
> Now comparing the second member:
>
>         struct pt_regs
>         {
>                 union {
>                         user_pt_regs user_regs;
>     --->                struct {
>                                 unsigned long args[1];
>                                 psw_t psw;
>                                 unsigned long gprs[NUM_GPRS];
>                         };
>                 };
>
>
> kernel knows it's same struct as user_pt_regs and uses ID 181
>
>         [186] UNION '(anon)' size=152 vlen=2
>                 'user_regs' type_id=183 bits_offset=0
>                 '(anon)' type_id=181 bits_offset=0
>
> but kmod has new ID 91250 (not 91245):
>
>         [91251] UNION '(anon)' size=152 vlen=2
>                 'user_regs' type_id=91247 bits_offset=0
>                 '(anon)' type_id=91250 bits_offset=0
>
>
> and 181 and 91250 are equiv structs:
>
>         [181] STRUCT '(anon)' size=152 vlen=3
>                 'args' type_id=182 bits_offset=0
>                 'psw' type_id=179 bits_offset=64
>                 'gprs' type_id=48 bits_offset=192
>
>         [91250] STRUCT '(anon)' size=152 vlen=3
>                 'args' type_id=91246 bits_offset=0
>                 'psw' type_id=91243 bits_offset=64
>                 'gprs' type_id=91132 bits_offset=192
>
>
> now hypot_type_id for 181 is 91245, but we have brand new struct
> ID 91250, so we fail
>
> what the patch tries to do is at this point to compare ID 91250
> with 91245 and if it passes then we are equal and we throw away
> ID 91250 because the hypot_type_id for 181 stays 91245
>
>
> ufff.. thoughts? ;-)

Oh, this is a really great analysis, thanks a lot! It makes everything
clear. Basically, BTF dedup algo does too good job deduping vmlinux
BTF. :)

What's not clear is what to do about that, because a (current)
fundamental assumption of is_equiv() check is that any type within CU
(or in this case deduped vmlinux BTF) has exactly one unique mapping.
Clearly that's not the case now. That array fix you mentioned worked
around GCC bug where this assumption broke. In this case it's not a
bug of a compiler (neither of algo, really), we just need to make algo
smarter.

Let me think about this a bit, we'll need to make the equivalence
check be aware that there could be multiple equivalent mappings and be
ok with that as long as all candidates are equivalent between
themselves. Lots of equivalence and recursion to think about.

It would be great to have a simplified test case to play with that. Do
you mind distilling the chain of types above into a selftests and
posting it to the mailing list so that I can play with it? It
shouldn't be hard to write given BTF writing APIs. And we'll need a
selftests anyway once we improve the algo, so it's definitely not a
wasted work.

And thanks again for analysis and writing this down, it would take me
ages to get to this otherwise.

P.S. If the improved BTF dedup algo will be able to handle this, we
should also remove the array workaround, because that one should work
automatically. I don't know if we have a test for duplicate array
scenario, but it's probably good to have that as well.


>
> thanks,
> jirka
>
