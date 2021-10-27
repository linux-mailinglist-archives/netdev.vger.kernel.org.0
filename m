Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB5F43C5A3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbhJ0I4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:56:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239638AbhJ0I4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635324815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xkEtfXaUHgkoGn6l6lm0Umryp7LWvtcOmvRvMtYrMj8=;
        b=NhV8Ph/c8zAS2itkvxhyFTweyLaOAvJRodpIqlR/BzNRV2/wLorhjn6mcPX5skh0VBjzKz
        thtMJCkQz92hY60lpuGxiTYceYEkrhLjhqaYpJZrEVdLYvc+sz4YciFQxuactVN5p28kbW
        by5lWnN2hGoV8GbdDRG5vmPADHepQ8U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-eC_81aNUNRevRwNLAS1yEA-1; Wed, 27 Oct 2021 04:53:34 -0400
X-MC-Unique: eC_81aNUNRevRwNLAS1yEA-1
Received: by mail-wr1-f69.google.com with SMTP id e7-20020adffc47000000b001688df0b917so398626wrs.22
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 01:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkEtfXaUHgkoGn6l6lm0Umryp7LWvtcOmvRvMtYrMj8=;
        b=0zLTS23G6fFkk5NhRYQZW7VeQeEXWP/DiANsbGu4QXrsNKQWlLn0+Owjy9a9y3At6l
         qVAAm+RlN3zdK36OY4xlNdIQmL02b9o8aAhE4Vz/yidWIU8XiQDOXF/b8B3BaytH6MSi
         q7TDc/aq9x+Wfp0/J7i6Z2hTe8hSTFxRhifZ+4EeLEpgxFndup+6TuYFphVNgC41ZYr4
         mlTdM1Ne+oJOrhILNWrBcqOuz82MTldft95SkIp0ztEvWZgpWz/QSXX52V4DCKF6rwi/
         vPL0ctsmtXmn3HQrX8flTNccG1llY/23rwVTC3uTXsGInT9p4PsFyqm2sT6EY5suXBNV
         N6fg==
X-Gm-Message-State: AOAM530qCjstv4ReOfHaw5g/ETWLeBV/XhcvuNHUOsOTFi/K0ymCzJGc
        36rN3MG/X2OwnJdQAAGtA38gypm3wIyHOUgRsTo9qBycQ6Uwp9/6ZKV0XuDnvXB0F4IL40902W0
        mNSntBvysW4Ce/EPQ
X-Received: by 2002:adf:ab46:: with SMTP id r6mr38915219wrc.71.1635324812883;
        Wed, 27 Oct 2021 01:53:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+69hHxkJc7BCA6VqOPiuK5KN6oHbbYMRxTdhStFp9IHN+k+N+npVbf8SXGSZwd9PPSNCZ8w==
X-Received: by 2002:adf:ab46:: with SMTP id r6mr38915189wrc.71.1635324812673;
        Wed, 27 Oct 2021 01:53:32 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id m8sm20814914wri.33.2021.10.27.01.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:53:32 -0700 (PDT)
Date:   Wed, 27 Oct 2021 10:53:30 +0200
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
Message-ID: <YXkTihiRKKJIc9M6@krava>
References: <20211023120452.212885-1-jolsa@kernel.org>
 <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava>
 <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > hi,
> > > > I'm trying to enable BTF for kernel module in fedora,
> > > > and I'm getting big increase on modules sizes on s390x arch.
> > > >
> > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > from kernel-core and kernel-module packages:
> > > >
> > > >                current   new
> > > >       aarch64      60M   76M
> > > >       ppc64le      53M   66M
> > > >       s390x        21M   41M
> > > >       x86_64       64M   79M
> > > >
> > > > The reason for higher increase on s390x was that dedup algorithm
> > > > did not detect some of the big kernel structs like 'struct module',
> > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > has many small modules that increased significantly in size because
> > > > of that even after compression.
> > > >
> > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > to pahole for kernel module BTF generation.
> > > >
> > > > The other problem is more tricky and is the reason why this patchset
> > > > is RFC ;-)
> > > >
> > > > The s390x compiler generates multiple definitions of the same struct
> > > > and dedup algorithm does not seem to handle this at the moment.
> > > >
> > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > >
> > > > Please let me know if you'd like to see other info/files.
> > > >
> > >
> > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > corresponding kernel image with BTF in it?
> >
> > sure, uploaded
> >
> 
> vmlinux.btfdump:
> 
> [174] FLOAT 'float' size=4
> [175] FLOAT 'double' size=8
> 
> VS
> 
> pnet.btfdump:
> 
> [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)

ugh, that's with no fix applied, sry

I applied the first patch and uploaded new files

now when I compare the 'module' struct from vmlinux:

	[885] STRUCT 'module' size=1280 vlen=70

and same one from pnet.ko:

	[89323] STRUCT 'module' size=1280 vlen=70

they seem to completely match, all the fields
and yet it still appears in the kmod's BTF

thanks,
jirka

> 
> 
> > jirka
> >
> > >
> > > > I found code in dedup that seems to handle such situation for arrays,
> > > > and added 'some' fix for structs. With that change I can no longer
> > > > see vmlinux's structs in kernel module BTF data, but I have no idea
> > > > if that breaks anything else.
> > > >
> > > > thoughts? thanks,
> > > > jirka
> > > >
> > > >
> > > > ---
> > > > Jiri Olsa (2):
> > > >       kbuild: Unify options for BTF generation for vmlinux and modules
> > > >       bpf: Add support to detect and dedup instances of same structs
> > > >
> > > >  Makefile                  |  3 +++
> > > >  scripts/Makefile.modfinal |  2 +-
> > > >  scripts/link-vmlinux.sh   | 11 +----------
> > > >  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
> > > >  tools/lib/bpf/btf.c       | 12 ++++++++++--
> > > >  5 files changed, 35 insertions(+), 13 deletions(-)
> > > >  create mode 100755 scripts/pahole-flags.sh
> > > >
> > >
> >
> 

