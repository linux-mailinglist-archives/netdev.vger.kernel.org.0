Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D7643E8E1
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhJ1TPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 15:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhJ1TPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 15:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635448377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7kWaggMXHcCjYrfL5K2g0wTHvQtA1o0SDSDvVc1zEhk=;
        b=AllxVH+SLDNayhEOYUZ5yJPkqiw6JUOQ3niyPftxMQep3oDNdPNJi45QStj4EYkm/U0HSb
        7vSry5Eop2AibL6Z1uE6NGTKliGVRFgthPT5QFPnwhbK+iCxtfBKy3ODszDR3WUjZxxQz/
        3lkC8spRLtr22hjiUW4AcL4jzlNrMgM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-IOSlLDbDMcOeIAd_sMHc7Q-1; Thu, 28 Oct 2021 15:12:56 -0400
X-MC-Unique: IOSlLDbDMcOeIAd_sMHc7Q-1
Received: by mail-wm1-f69.google.com with SMTP id a18-20020a1cf012000000b0032ca3eb2ac3so2411726wmb.0
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 12:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7kWaggMXHcCjYrfL5K2g0wTHvQtA1o0SDSDvVc1zEhk=;
        b=ZXJpw7LyRAg0jc6Rqn6CTU2V+fwMs7Qp4JN0Rxsg4jloI/dlCmwMxOO9xttMOL+pz4
         HdswDFxFH5OMn5fHLcjrTj7PKn0ibX+NXOvsrJ5XU0bMoZTWVnZSWi5hL4/QGrEs6ftO
         6PusfM5OYD1lH0JRxmazAsMKQ7OXLK8mxT9b5Q86gTg+W7MZZPn2zB3JmLzA+6f063JF
         Em2O9YqL9WLORQdTu2QfbUnO4kKz0gJbGtGbKvd0YZLXPPFKd2Fv0SLDqwv7rxrQZZeV
         h5nIWR/4WE37+a7+9+Ux6613o8LkgrjxKf9+4rzmi6PyCuHzRiXKWfVncwmKzSIpFQRz
         aZHw==
X-Gm-Message-State: AOAM533NkQkUvAkxPD8/K8CW/PdNyXoUpSFXBSoV3mqQiUxZ+0oGBYEq
        UnPdOHsxlKjqvu+zELSdB3C+JyP+IThZJSIjeJkljdRQ4+u8gjf36o9XgXi5V2YsqdxAL6otjTn
        a/fDLKj5kFPAcJmc1
X-Received: by 2002:a5d:6484:: with SMTP id o4mr8153929wri.337.1635448375020;
        Thu, 28 Oct 2021 12:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz86mlmfH+fc0vXYdThyq8za2ykLti1AH/xGWc6hJN8YEC/qgGXhrYoop24bHDUbtTL96OhVA==
X-Received: by 2002:a5d:6484:: with SMTP id o4mr8153911wri.337.1635448374828;
        Thu, 28 Oct 2021 12:12:54 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id u13sm3989800wri.50.2021.10.28.12.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 12:12:53 -0700 (PDT)
Date:   Thu, 28 Oct 2021 21:12:52 +0200
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
Message-ID: <YXr2NFlJTAhHdZqq@krava>
References: <20211023120452.212885-1-jolsa@kernel.org>
 <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava>
 <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava>
 <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
 <YXmX4+HDw9rghl0T@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXmX4+HDw9rghl0T@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 08:18:11PM +0200, Jiri Olsa wrote:
> On Wed, Oct 27, 2021 at 10:53:55AM -0700, Andrii Nakryiko wrote:
> > On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > > >
> > > > > > > hi,
> > > > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > > > >
> > > > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > > > from kernel-core and kernel-module packages:
> > > > > > >
> > > > > > >                current   new
> > > > > > >       aarch64      60M   76M
> > > > > > >       ppc64le      53M   66M
> > > > > > >       s390x        21M   41M
> > > > > > >       x86_64       64M   79M
> > > > > > >
> > > > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > > > has many small modules that increased significantly in size because
> > > > > > > of that even after compression.
> > > > > > >
> > > > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > > > to pahole for kernel module BTF generation.
> > > > > > >
> > > > > > > The other problem is more tricky and is the reason why this patchset
> > > > > > > is RFC ;-)
> > > > > > >
> > > > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > > > >
> > > > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > > > >
> > > > > > > Please let me know if you'd like to see other info/files.
> > > > > > >
> > > > > >
> > > > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > > > corresponding kernel image with BTF in it?
> > > > >
> > > > > sure, uploaded
> > > > >
> > > >
> > > > vmlinux.btfdump:
> > > >
> > > > [174] FLOAT 'float' size=4
> > > > [175] FLOAT 'double' size=8
> > > >
> > > > VS
> > > >
> > > > pnet.btfdump:
> > > >
> > > > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > > > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> > >
> > > ugh, that's with no fix applied, sry
> > >
> > > I applied the first patch and uploaded new files
> > >
> > > now when I compare the 'module' struct from vmlinux:
> > >
> > >         [885] STRUCT 'module' size=1280 vlen=70
> > >
> > > and same one from pnet.ko:
> > >
> > >         [89323] STRUCT 'module' size=1280 vlen=70
> > >
> > > they seem to completely match, all the fields
> > > and yet it still appears in the kmod's BTF
> > >
> > 
> > Ok, now struct module is identical down to the types referenced from
> > the fields, which means it should have been deduplicated completely.
> > This will require a more time-consuming debugging, though, so I'll put
> > it on my TODO list for now. If you get to this earlier, see where the
> > equivalence check fails in btf_dedup (sprinkle debug outputs around to
> > see what's going on).
> 
> it failed for me on that hypot_type_id check where I did fix,
> I thought it's the issue of multiple same struct in the kmod,
> but now I see I might have confused cannon_id with cand_id ;-)
> I'll check more on this

with more checking I got to the same conclusion as before,
now maybe with little more details ;-)

the problem seems to be that in some cases the module BTF
data stores same structs under new/different IDs, while the
kernel BTF data is already dedup-ed

the dedup algo keeps hypot_map of kernel IDs to kmod IDs,
and in my case it will get to the point that the kernel ID
is already 'known' and points to certain kmod ID 'A', but it
is also equiv to another kmod ID 'B' (so kmod ID 'A' and 'B'
are equiv structs) but the dedup will claim as not equiv


This is where the dedup fails for me on that s390 data:

The pt_regs is defined as:

        struct pt_regs
        {
                union {
                        user_pt_regs user_regs;
                        struct {
                                unsigned long args[1];
                                psw_t psw;
                                unsigned long gprs[NUM_GPRS];
                        };
                };
                ...
        };

considering just the first union:

        [186] UNION '(anon)' size=152 vlen=2
                'user_regs' type_id=183 bits_offset=0
                '(anon)' type_id=181 bits_offset=0

        [91251] UNION '(anon)' size=152 vlen=2
                'user_regs' type_id=91247 bits_offset=0
                '(anon)' type_id=91250 bits_offset=0


---------------------------------------------------------------

Comparing the first member 'user_regs':

        struct pt_regs
        {
                union {
    --->                user_pt_regs user_regs;
                        struct {
                                unsigned long args[1];
                                psw_t psw;
                                unsigned long gprs[NUM_GPRS];
                        };
                };

Which looks like:

        typedef struct {
                unsigned long args[1];
                psw_t psw;
                unsigned long gprs[NUM_GPRS];
        } user_pt_regs;


and is also equiv to the next union member struct.. and that's what
kernel knows but not kmod... anyway,


the dedup will compare 'user_pt_regs':

        [183] TYPEDEF 'user_pt_regs' type_id=181

        [91247] TYPEDEF 'user_pt_regs' type_id=91245


        [181] STRUCT '(anon)' size=152 vlen=3
                'args' type_id=182 bits_offset=0
                'psw' type_id=179 bits_offset=64
                'gprs' type_id=48 bits_offset=192

        [91245] STRUCT '(anon)' size=152 vlen=3
                'args' type_id=91246 bits_offset=0
                'psw' type_id=91243 bits_offset=64
                'gprs' type_id=91132 bits_offset=192

and make them equiv by setting hypot_type_id for 181 to be 91245


---------------------------------------------------------------

Now comparing the second member:

        struct pt_regs
        {
                union {
                        user_pt_regs user_regs;
    --->                struct {
                                unsigned long args[1];
                                psw_t psw;
                                unsigned long gprs[NUM_GPRS];
                        };
                };


kernel knows it's same struct as user_pt_regs and uses ID 181

        [186] UNION '(anon)' size=152 vlen=2
                'user_regs' type_id=183 bits_offset=0
                '(anon)' type_id=181 bits_offset=0

but kmod has new ID 91250 (not 91245):

        [91251] UNION '(anon)' size=152 vlen=2
                'user_regs' type_id=91247 bits_offset=0
                '(anon)' type_id=91250 bits_offset=0


and 181 and 91250 are equiv structs:

        [181] STRUCT '(anon)' size=152 vlen=3
                'args' type_id=182 bits_offset=0
                'psw' type_id=179 bits_offset=64
                'gprs' type_id=48 bits_offset=192

        [91250] STRUCT '(anon)' size=152 vlen=3
                'args' type_id=91246 bits_offset=0
                'psw' type_id=91243 bits_offset=64
                'gprs' type_id=91132 bits_offset=192


now hypot_type_id for 181 is 91245, but we have brand new struct
ID 91250, so we fail

what the patch tries to do is at this point to compare ID 91250
with 91245 and if it passes then we are equal and we throw away
ID 91250 because the hypot_type_id for 181 stays 91245


ufff.. thoughts? ;-)

thanks,
jirka

