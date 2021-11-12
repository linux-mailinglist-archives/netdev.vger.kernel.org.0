Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD48C44E25A
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhKLH0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:26:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230464AbhKLH0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 02:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636701826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kvPuxi8GCSBD/keJhT/UPDsGKj1mTYNPlAmJnLH932Y=;
        b=FdyJhE5Nhsy/exKq425ySutWpUL+AWB2Z1QwOMVYO/cvG9zY73iMpsbEKxjAdwxU+rygfW
        Syob+47ZRCXwBP59KpFjg1tsTM+gxKNcfbBPT93xG4qkrZ8xCN6kRDQE1KhQPXfflu5sxw
        f8OvLOJW8mh/K0P3WlLMmV/IsKJZ4nE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-HyQhBbBjMHeft3fIdwEAag-1; Fri, 12 Nov 2021 02:23:45 -0500
X-MC-Unique: HyQhBbBjMHeft3fIdwEAag-1
Received: by mail-wm1-f70.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so3869052wmb.3
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 23:23:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kvPuxi8GCSBD/keJhT/UPDsGKj1mTYNPlAmJnLH932Y=;
        b=xM4Gmt0cAmQhpZxXa/kRIHt32gWJSUzrrA5Ujj6aK/BNb9fuU0uk5ydANJnclPxPB2
         I8fHDz+VetZBOERlW03K8TyvT1yHmtSTAYToFcjD69Xl1xhAdwu79Sg76IFozxTgCHaz
         gLAeRyembBoTsX/Fa5t7inunyaGONlj7qexj75fitPgGEUev2QygbmTlPMVG4E9qJH/9
         Tac2sVXbmJgB/3ZHUBJWKm37wvLUrow2rePysCdXYZZ0/mzdK2AYxsUuND3HGGmdTJWa
         1lKyvpQ2myDE0hheQajGMOfy4xValFKmlPCyBMIZbBa88ETaphAb5fTkbbZL+znIeiLy
         1JlQ==
X-Gm-Message-State: AOAM533qNMYvQ6r/UX8lDRaUmHecYXb7pbkTbHS/9hUC18KOrL5MGGa0
        JekRBEY4/OOe12ajwGxGA8zJDEeuRk6MUeRtva4YE4F1iM7zyj1gSG1CUny+rHItYGh1R6+tZYc
        CsprgYGY42VQOYsBx
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr16674324wrq.109.1636701823694;
        Thu, 11 Nov 2021 23:23:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQhrwifxkOsJSh+PN45diQntSMrUUEBuY7gxGX9NPHXumQ496A5V6RDd0NLSenjh31hX6MhA==
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr16674270wrq.109.1636701823215;
        Thu, 11 Nov 2021 23:23:43 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d15sm7314921wri.50.2021.11.11.23.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 23:23:42 -0800 (PST)
Date:   Fri, 12 Nov 2021 08:23:41 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
Message-ID: <YY4WfQrExICZ6jI+@krava>
References: <YXfulitQY1+Gd35h@krava>
 <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava>
 <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
 <YXmX4+HDw9rghl0T@krava>
 <YXr2NFlJTAhHdZqq@krava>
 <CAEf4BzY1WLO+OmRQnRuJZc_-TEM12VZxd6RKQOrxWjT84KqBXw@mail.gmail.com>
 <YYFH2qSOGdcYAqaE@krava>
 <YYfpcN71HCqoY1DT@krava>
 <CAEf4BzYhnLt453hQj2=2uzR-yPiSTjgvyf2E_qHv=F-8ZM=ZyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYhnLt453hQj2=2uzR-yPiSTjgvyf2E_qHv=F-8ZM=ZyA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 03:23:25PM -0800, Andrii Nakryiko wrote:
> On Sun, Nov 7, 2021 at 6:57 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Nov 02, 2021 at 03:14:52PM +0100, Jiri Olsa wrote:
> > > On Mon, Nov 01, 2021 at 04:14:29PM -0700, Andrii Nakryiko wrote:
> > > > On Thu, Oct 28, 2021 at 12:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > On Wed, Oct 27, 2021 at 08:18:11PM +0200, Jiri Olsa wrote:
> > > > > > On Wed, Oct 27, 2021 at 10:53:55AM -0700, Andrii Nakryiko wrote:
> > > > > > > On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > > > > > > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > hi,
> > > > > > > > > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > > > > > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > > > > > > > > >
> > > > > > > > > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > > > > > > > > from kernel-core and kernel-module packages:
> > > > > > > > > > > >
> > > > > > > > > > > >                current   new
> > > > > > > > > > > >       aarch64      60M   76M
> > > > > > > > > > > >       ppc64le      53M   66M
> > > > > > > > > > > >       s390x        21M   41M
> > > > > > > > > > > >       x86_64       64M   79M
> > > > > > > > > > > >
> > > > > > > > > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > > > > > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > > > > > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > > > > > > > > has many small modules that increased significantly in size because
> > > > > > > > > > > > of that even after compression.
> > > > > > > > > > > >
> > > > > > > > > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > > > > > > > > to pahole for kernel module BTF generation.
> > > > > > > > > > > >
> > > > > > > > > > > > The other problem is more tricky and is the reason why this patchset
> > > > > > > > > > > > is RFC ;-)
> > > > > > > > > > > >
> > > > > > > > > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > > > > > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > > > > > > > > >
> > > > > > > > > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > > > > > > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > > > > > > > > >
> > > > > > > > > > > > Please let me know if you'd like to see other info/files.
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > > > > > > > > corresponding kernel image with BTF in it?
> > > > > > > > > >
> > > > > > > > > > sure, uploaded
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > vmlinux.btfdump:
> > > > > > > > >
> > > > > > > > > [174] FLOAT 'float' size=4
> > > > > > > > > [175] FLOAT 'double' size=8
> > > > > > > > >
> > > > > > > > > VS
> > > > > > > > >
> > > > > > > > > pnet.btfdump:
> > > > > > > > >
> > > > > > > > > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > > > > > > > > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> > > > > > > >
> > > > > > > > ugh, that's with no fix applied, sry
> > > > > > > >
> > > > > > > > I applied the first patch and uploaded new files
> > > > > > > >
> > > > > > > > now when I compare the 'module' struct from vmlinux:
> > > > > > > >
> > > > > > > >         [885] STRUCT 'module' size=1280 vlen=70
> > > > > > > >
> > > > > > > > and same one from pnet.ko:
> > > > > > > >
> > > > > > > >         [89323] STRUCT 'module' size=1280 vlen=70
> > > > > > > >
> > > > > > > > they seem to completely match, all the fields
> > > > > > > > and yet it still appears in the kmod's BTF
> > > > > > > >
> > > > > > >
> > > > > > > Ok, now struct module is identical down to the types referenced from
> > > > > > > the fields, which means it should have been deduplicated completely.
> > > > > > > This will require a more time-consuming debugging, though, so I'll put
> > > > > > > it on my TODO list for now. If you get to this earlier, see where the
> > > > > > > equivalence check fails in btf_dedup (sprinkle debug outputs around to
> > > > > > > see what's going on).
> > > > > >
> > > > > > it failed for me on that hypot_type_id check where I did fix,
> > > > > > I thought it's the issue of multiple same struct in the kmod,
> > > > > > but now I see I might have confused cannon_id with cand_id ;-)
> > > > > > I'll check more on this
> > > > >
> > > > > with more checking I got to the same conclusion as before,
> > > > > now maybe with little more details ;-)
> > > > >
> > > > > the problem seems to be that in some cases the module BTF
> > > > > data stores same structs under new/different IDs, while the
> > > > > kernel BTF data is already dedup-ed
> > > > >
> > > > > the dedup algo keeps hypot_map of kernel IDs to kmod IDs,
> > > > > and in my case it will get to the point that the kernel ID
> > > > > is already 'known' and points to certain kmod ID 'A', but it
> > > > > is also equiv to another kmod ID 'B' (so kmod ID 'A' and 'B'
> > > > > are equiv structs) but the dedup will claim as not equiv
> > > > >
> > > > >
> > > > > This is where the dedup fails for me on that s390 data:
> > > > >
> > > > > The pt_regs is defined as:
> > > > >
> > > > >         struct pt_regs
> > > > >         {
> > > > >                 union {
> > > > >                         user_pt_regs user_regs;
> > > > >                         struct {
> > > > >                                 unsigned long args[1];
> > > > >                                 psw_t psw;
> > > > >                                 unsigned long gprs[NUM_GPRS];
> > > > >                         };
> > > > >                 };
> > > > >                 ...
> > > > >         };
> > > > >
> > > > > considering just the first union:
> > > > >
> > > > >         [186] UNION '(anon)' size=152 vlen=2
> > > > >                 'user_regs' type_id=183 bits_offset=0
> > > > >                 '(anon)' type_id=181 bits_offset=0
> > > > >
> > > > >         [91251] UNION '(anon)' size=152 vlen=2
> > > > >                 'user_regs' type_id=91247 bits_offset=0
> > > > >                 '(anon)' type_id=91250 bits_offset=0
> > > > >
> > > > >
> > > > > ---------------------------------------------------------------
> > > > >
> > > > > Comparing the first member 'user_regs':
> > > > >
> > > > >         struct pt_regs
> > > > >         {
> > > > >                 union {
> > > > >     --->                user_pt_regs user_regs;
> > > > >                         struct {
> > > > >                                 unsigned long args[1];
> > > > >                                 psw_t psw;
> > > > >                                 unsigned long gprs[NUM_GPRS];
> > > > >                         };
> > > > >                 };
> > > > >
> > > > > Which looks like:
> > > > >
> > > > >         typedef struct {
> > > > >                 unsigned long args[1];
> > > > >                 psw_t psw;
> > > > >                 unsigned long gprs[NUM_GPRS];
> > > > >         } user_pt_regs;
> > > > >
> > > > >
> > > > > and is also equiv to the next union member struct.. and that's what
> > > > > kernel knows but not kmod... anyway,
> > > > >
> > > > >
> > > > > the dedup will compare 'user_pt_regs':
> > > > >
> > > > >         [183] TYPEDEF 'user_pt_regs' type_id=181
> > > > >
> > > > >         [91247] TYPEDEF 'user_pt_regs' type_id=91245
> > > > >
> > > > >
> > > > >         [181] STRUCT '(anon)' size=152 vlen=3
> > > > >                 'args' type_id=182 bits_offset=0
> > > > >                 'psw' type_id=179 bits_offset=64
> > > > >                 'gprs' type_id=48 bits_offset=192
> > > > >
> > > > >         [91245] STRUCT '(anon)' size=152 vlen=3
> > > > >                 'args' type_id=91246 bits_offset=0
> > > > >                 'psw' type_id=91243 bits_offset=64
> > > > >                 'gprs' type_id=91132 bits_offset=192
> > > > >
> > > > > and make them equiv by setting hypot_type_id for 181 to be 91245
> > > > >
> > > > >
> > > > > ---------------------------------------------------------------
> > > > >
> > > > > Now comparing the second member:
> > > > >
> > > > >         struct pt_regs
> > > > >         {
> > > > >                 union {
> > > > >                         user_pt_regs user_regs;
> > > > >     --->                struct {
> > > > >                                 unsigned long args[1];
> > > > >                                 psw_t psw;
> > > > >                                 unsigned long gprs[NUM_GPRS];
> > > > >                         };
> > > > >                 };
> > > > >
> > > > >
> > > > > kernel knows it's same struct as user_pt_regs and uses ID 181
> > > > >
> > > > >         [186] UNION '(anon)' size=152 vlen=2
> > > > >                 'user_regs' type_id=183 bits_offset=0
> > > > >                 '(anon)' type_id=181 bits_offset=0
> > > > >
> > > > > but kmod has new ID 91250 (not 91245):
> > > > >
> > > > >         [91251] UNION '(anon)' size=152 vlen=2
> > > > >                 'user_regs' type_id=91247 bits_offset=0
> > > > >                 '(anon)' type_id=91250 bits_offset=0
> > > > >
> > > > >
> > > > > and 181 and 91250 are equiv structs:
> > > > >
> > > > >         [181] STRUCT '(anon)' size=152 vlen=3
> > > > >                 'args' type_id=182 bits_offset=0
> > > > >                 'psw' type_id=179 bits_offset=64
> > > > >                 'gprs' type_id=48 bits_offset=192
> > > > >
> > > > >         [91250] STRUCT '(anon)' size=152 vlen=3
> > > > >                 'args' type_id=91246 bits_offset=0
> > > > >                 'psw' type_id=91243 bits_offset=64
> > > > >                 'gprs' type_id=91132 bits_offset=192
> > > > >
> > > > >
> > > > > now hypot_type_id for 181 is 91245, but we have brand new struct
> > > > > ID 91250, so we fail
> > > > >
> > > > > what the patch tries to do is at this point to compare ID 91250
> > > > > with 91245 and if it passes then we are equal and we throw away
> > > > > ID 91250 because the hypot_type_id for 181 stays 91245
> > > > >
> > > > >
> > > > > ufff.. thoughts? ;-)
> > > >
> > > > Oh, this is a really great analysis, thanks a lot! It makes everything
> > > > clear. Basically, BTF dedup algo does too good job deduping vmlinux
> > > > BTF. :)
> > > >
> > > > What's not clear is what to do about that, because a (current)
> > > > fundamental assumption of is_equiv() check is that any type within CU
> > > > (or in this case deduped vmlinux BTF) has exactly one unique mapping.
> > > > Clearly that's not the case now. That array fix you mentioned worked
> > > > around GCC bug where this assumption broke. In this case it's not a
> > > > bug of a compiler (neither of algo, really), we just need to make algo
> > > > smarter.
> > > >
> > > > Let me think about this a bit, we'll need to make the equivalence
> > > > check be aware that there could be multiple equivalent mappings and be
> > > > ok with that as long as all candidates are equivalent between
> > > > themselves. Lots of equivalence and recursion to think about.
> > > >
> > > > It would be great to have a simplified test case to play with that. Do
> > > > you mind distilling the chain of types above into a selftests and
> > > > posting it to the mailing list so that I can play with it? It
> > > > shouldn't be hard to write given BTF writing APIs. And we'll need a
> > > > selftests anyway once we improve the algo, so it's definitely not a
> > > > wasted work.
> > > >
> >
> >
> > I ended up with simply test, where the idea is to use
> > type id which is defined after currently processed type
> >
> > the last VALIDATE_RAW_BTF fails
> >
> > I'm not sending full atch, because I assume this is not
> > to merge yet also I assume you might want to change that
> > anyway ;-)
> >
> 
> Thanks, Jiri! I'll get to playing with this some time this week,
> hopefully. I hope this is not a huge blocker for you?

I switched off s390x for the moment, so we can move on
I don't think it's huge blocker, nobody is screaming yet ;-)

thanks,
jirka

> 
> 
> > I'll check later on that special array case
> >
> > thanks,
> > jirka
> >
> >
> > ---
> >  .../bpf/prog_tests/btf_dedup_split.c          | 113 ++++++++++++++++++
> >  1 file changed, 113 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> > index 64554fd33547..2ad54e185221 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
> > @@ -314,6 +314,117 @@ static void test_split_struct_duped() {
> >         btf__free(btf1);
> >  }
> >
> > +static void btf_add_data(struct btf *btf, int start_id)
> > +{
> > +#define ID(n) (start_id + n)
> > +       btf__set_pointer_size(btf, 8); /* enforce 64-bit arch */
> > +
> > +       btf__add_int(btf, "int", 4, BTF_INT_SIGNED);    /* [1] int */
> > +
> > +       btf__add_struct(btf, "s", 8);                   /* [2] struct s { */
> > +       btf__add_field(btf, "a", ID(3), 0, 0);          /*      struct anon a; */
> > +       btf__add_field(btf, "b", ID(4), 0, 0);          /*      struct anon b; */
> > +                                                       /* } */
> > +
> > +       btf__add_struct(btf, "(anon)", 8);              /* [3] struct anon { */
> > +       btf__add_field(btf, "f1", ID(1), 0, 0);         /*      int f1; */
> > +       btf__add_field(btf, "f2", ID(1), 32, 0);        /*      int f2; */
> > +                                                       /* } */
> > +
> > +       btf__add_struct(btf, "(anon)", 8);              /* [4] struct anon { */
> > +       btf__add_field(btf, "f1", ID(1), 0, 0);         /*      int f1; */
> > +       btf__add_field(btf, "f2", ID(1), 32, 0);        /*      int f2; */
> > +                                                       /* } */
> > +#undef ID
> > +}
> > +
> > +static void test_split_struct_missed()
> > +{
> > +       struct btf *btf1, *btf2;
> > +       int err;
> > +
> > +       /* generate the base data.. */
> > +       btf1 = btf__new_empty();
> > +       if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
> > +               return;
> > +
> > +       btf_add_data(btf1, 0);
> > +
> > +       VALIDATE_RAW_BTF(
> > +               btf1,
> > +               "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +               "[2] STRUCT 's' size=8 vlen=2\n"
> > +               "\t'a' type_id=3 bits_offset=0\n"
> > +               "\t'b' type_id=4 bits_offset=0",
> > +               "[3] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=1 bits_offset=0\n"
> > +               "\t'f2' type_id=1 bits_offset=32",
> > +               "[4] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=1 bits_offset=0\n"
> > +               "\t'f2' type_id=1 bits_offset=32");
> > +
> > +       /* ..dedup them... */
> > +       err = btf__dedup(btf1, NULL, NULL);
> > +       if (!ASSERT_OK(err, "btf_dedup"))
> > +               goto cleanup;
> > +
> > +       VALIDATE_RAW_BTF(
> > +               btf1,
> > +               "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +               "[2] STRUCT 's' size=8 vlen=2\n"
> > +               "\t'a' type_id=3 bits_offset=0\n"
> > +               "\t'b' type_id=3 bits_offset=0",
> > +               "[3] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=1 bits_offset=0\n"
> > +               "\t'f2' type_id=1 bits_offset=32");
> > +
> > +       /* and add the same data on top of it */
> > +       btf2 = btf__new_empty_split(btf1);
> > +       if (!ASSERT_OK_PTR(btf2, "empty_split_btf"))
> > +               goto cleanup;
> > +
> > +       btf_add_data(btf2, 3);
> > +
> > +       VALIDATE_RAW_BTF(
> > +               btf2,
> > +               "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +               "[2] STRUCT 's' size=8 vlen=2\n"
> > +               "\t'a' type_id=3 bits_offset=0\n"
> > +               "\t'b' type_id=3 bits_offset=0",
> > +               "[3] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=1 bits_offset=0\n"
> > +               "\t'f2' type_id=1 bits_offset=32",
> > +               "[4] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +               "[5] STRUCT 's' size=8 vlen=2\n"
> > +               "\t'a' type_id=6 bits_offset=0\n"
> > +               "\t'b' type_id=7 bits_offset=0",
> > +               "[6] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=4 bits_offset=0\n"
> > +               "\t'f2' type_id=4 bits_offset=32",
> > +               "[7] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=4 bits_offset=0\n"
> > +               "\t'f2' type_id=4 bits_offset=32");
> > +
> > +       err = btf__dedup(btf2, NULL, NULL);
> > +       if (!ASSERT_OK(err, "btf_dedup"))
> > +               goto cleanup;
> > +
> > +       /* after dedup it should match the original data */
> > +       VALIDATE_RAW_BTF(
> > +               btf2,
> > +               "[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED",
> > +               "[2] STRUCT 's' size=8 vlen=2\n"
> > +               "\t'a' type_id=3 bits_offset=0\n"
> > +               "\t'b' type_id=3 bits_offset=0",
> > +               "[3] STRUCT '(anon)' size=8 vlen=2\n"
> > +               "\t'f1' type_id=1 bits_offset=0\n"
> > +               "\t'f2' type_id=1 bits_offset=32");
> > +
> > +cleanup:
> > +       btf__free(btf2);
> > +       btf__free(btf1);
> > +}
> > +
> >  void test_btf_dedup_split()
> >  {
> >         if (test__start_subtest("split_simple"))
> > @@ -322,4 +433,6 @@ void test_btf_dedup_split()
> >                 test_split_struct_duped();
> >         if (test__start_subtest("split_fwd_resolve"))
> >                 test_split_fwd_resolve();
> > +       if (test__start_subtest("split_struct_missed"))
> > +               test_split_struct_missed();
> >  }
> > --
> > 2.32.0
> >
> 

