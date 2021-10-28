Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0131343D8D8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhJ1Bq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ1Bq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:46:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD19FC061570;
        Wed, 27 Oct 2021 18:44:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l203so4480348pfd.2;
        Wed, 27 Oct 2021 18:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XYa3fqfz71wH6LVuE2LZZfaWJcojH6MSqSH6yXHipXk=;
        b=Y0UwAZxbaldS17IoHYkh+w90oDGWeC5bO30qVYwY9vLj7G+WsM9ljf5NL3IT9X36x2
         SEnIY18Tf6Hy+qx4e4WZqDIOzWuTBvDsvKL96RxH3wf/phaO4IUlsB5aPlF6vQft/qgA
         4ww+dYAV59hcZQBSqwP+T7xbL4n5HgzLiLhn/b3V1sxcEvlmAc14RoBjKkrzthH/ffUI
         FT0JVv6LNyBaHbZTBiYhGJjTmXZKjXQ9dhwje2zjtfZ8OKRF/kbsUVQRmCG4Rd9cUUzw
         1Mp5xsCiMMTTBwDMT/jFhBfXis3bEDGhKRzjEveQNwORaT5iMoMH3L3gLLuQfUlWTCEo
         2BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XYa3fqfz71wH6LVuE2LZZfaWJcojH6MSqSH6yXHipXk=;
        b=UDbzqSoTl/b1KKh+qGWK4CXiPRbgqngsD80yLDfYPZWGqEk4rUHI8zE+L/4o2laQcF
         9XCBIaqZlWXGDUHZaK5CehtSIW+0tgtuipCdWkpZSmxzb/k4RQF9XnLyZw1SmIdWuEPM
         LFjh4yBo92KgS0U8xn/5NEyB5J4XYqdvYqVB7UX/7LjNSD7JAZq1GuV6OxZxuH/XIRRY
         y5R//bZ56Ty5dMp1bHbPp/Mt9gW5dfmLpi9KYeyCrAsO6SkvqCNP+Nc9LD/A/CJoCjPW
         iAqG2ZCTq5rXqQ9Bv860BTHUaJFHHc2XO7icSNSIQQkHHU6cc1jR9Hw4+H5MPTUpLQCF
         k8Tw==
X-Gm-Message-State: AOAM533Kegm2s5195ssipGhYbBJSrnnSNRACe8my1esSy4wYk233jhMb
        XC+purjFUW18QRxYQzQdzPU=
X-Google-Smtp-Source: ABdhPJx0UHQUBNN21MY930gMna5O1tYBvUPkA5IJ7p5pXuDkLLU2mrBd+6N2hSR1q/GwT30uEDIAFQ==
X-Received: by 2002:a05:6a00:998:b0:47b:e61e:c0f4 with SMTP id u24-20020a056a00099800b0047be61ec0f4mr1169839pfg.31.1635385472357;
        Wed, 27 Oct 2021 18:44:32 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id s28sm914406pgo.86.2021.10.27.18.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 18:44:32 -0700 (PDT)
Date:   Thu, 28 Oct 2021 07:14:28 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
Message-ID: <20211028014428.rsuq6rkfvqzq23tg@apollo.localdomain>
References: <20211023120452.212885-1-jolsa@kernel.org>
 <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava>
 <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava>
 <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:23:55PM IST, Andrii Nakryiko wrote:
> On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > >
> > > > > > hi,
> > > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > > >
> > > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > > from kernel-core and kernel-module packages:
> > > > > >
> > > > > >                current   new
> > > > > >       aarch64      60M   76M
> > > > > >       ppc64le      53M   66M
> > > > > >       s390x        21M   41M
> > > > > >       x86_64       64M   79M
> > > > > >
> > > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > > has many small modules that increased significantly in size because
> > > > > > of that even after compression.
> > > > > >
> > > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > > to pahole for kernel module BTF generation.
> > > > > >
> > > > > > The other problem is more tricky and is the reason why this patchset
> > > > > > is RFC ;-)
> > > > > >
> > > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > > >
> > > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > > >
> > > > > > Please let me know if you'd like to see other info/files.
> > > > > >
> > > > >
> > > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > > corresponding kernel image with BTF in it?
> > > >
> > > > sure, uploaded
> > > >
> > >
> > > vmlinux.btfdump:
> > >
> > > [174] FLOAT 'float' size=4
> > > [175] FLOAT 'double' size=8
> > >
> > > VS
> > >
> > > pnet.btfdump:
> > >
> > > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
> >
> > ugh, that's with no fix applied, sry
> >
> > I applied the first patch and uploaded new files
> >
> > now when I compare the 'module' struct from vmlinux:
> >
> >         [885] STRUCT 'module' size=1280 vlen=70
> >
> > and same one from pnet.ko:
> >
> >         [89323] STRUCT 'module' size=1280 vlen=70
> >
> > they seem to completely match, all the fields
> > and yet it still appears in the kmod's BTF
> >
>
> Ok, now struct module is identical down to the types referenced from
> the fields, which means it should have been deduplicated completely.
> This will require a more time-consuming debugging, though, so I'll put
> it on my TODO list for now. If you get to this earlier, see where the
> equivalence check fails in btf_dedup (sprinkle debug outputs around to
> see what's going on).
>

Hello Andrii,

I think I'm seeing something similar when working on the conntrack patches [0],
I was looking to match whether the type in a PTR_TO_BTF_ID register is same as
struct nf_conn, but it seems that there can be two BTF IDs for the same struct
type.

When doing bpftool dump, I see:

 ; bpftool btf dump file /sys/kernel/btf/vmlinux format raw | grep nf_conn
 ...
[89224] STRUCT 'nf_conn' size=256 vlen=15
 ...

 ; bpftool btf dump file /sys/kernel/btf/nf_conntrack format raw | grep nf_conn
 ...
[103077] STRUCT 'nf_conn' size=256 vlen=15
[104988] STRUCT 'nf_conn' size=256 vlen=15
[106490] STRUCT 'nf_conn' size=256 vlen=15
[108187] STRUCT 'nf_conn' size=256 vlen=15
 ...

Inside the kernel, when trying to match both, register PTR_TO_BTF_ID refers to
the nf_conntrack BTF ID, while the BTF_ID_LIST resolves to the one in vmlinux,
this ends up making the job of matching the two struct types a bit difficult
(for now, I am thinking of going with btf_struct_ids_match). My original plan
was to compare the result of btf_types_by_id.

[0]: https://github.com/kkdwivedi/linux/commits/conntrack-bpf

> > thanks,
> > jirka
> >
> > >
> > >
> > > > jirka
> > > >
> > > > >
> > > > > > I found code in dedup that seems to handle such situation for arrays,
> > > > > > and added 'some' fix for structs. With that change I can no longer
> > > > > > see vmlinux's structs in kernel module BTF data, but I have no idea
> > > > > > if that breaks anything else.
> > > > > >
> > > > > > thoughts? thanks,
> > > > > > jirka
> > > > > >
> > > > > >
> > > > > > ---
> > > > > > Jiri Olsa (2):
> > > > > >       kbuild: Unify options for BTF generation for vmlinux and modules
> > > > > >       bpf: Add support to detect and dedup instances of same structs
> > > > > >
> > > > > >  Makefile                  |  3 +++
> > > > > >  scripts/Makefile.modfinal |  2 +-
> > > > > >  scripts/link-vmlinux.sh   | 11 +----------
> > > > > >  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
> > > > > >  tools/lib/bpf/btf.c       | 12 ++++++++++--
> > > > > >  5 files changed, 35 insertions(+), 13 deletions(-)
> > > > > >  create mode 100755 scripts/pahole-flags.sh
> > > > > >
> > > > >
> > > >
> > >
> >

--
Kartikeya
