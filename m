Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2E43B1C6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhJZMGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235051AbhJZMGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635249820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P0nMxe3hVb70E+20hbG82Aa3810ivgtjZzwzfNSAWc0=;
        b=ZlPa5SdhYxUrO2LvoUTntUrMJwqYegSqJNBU6puc6z4Wl+cNSg+Dzo+6MyqcIT5Ik6dDxw
        6/uh3v+Vph7udeGLVOZuMPFyYIfzOrquOpcQj27ttDBRR9F+NnGoFV1aRAnw7eBCtWIVHb
        cqyNvwerV0uIw8GOhxQcg3xlWsqEdC4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-BQ3ZSfTBO8yfgbOl93dKmw-1; Tue, 26 Oct 2021 08:03:38 -0400
X-MC-Unique: BQ3ZSfTBO8yfgbOl93dKmw-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so5027109wmj.8
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 05:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P0nMxe3hVb70E+20hbG82Aa3810ivgtjZzwzfNSAWc0=;
        b=ZyDiVqocfJ7ZQusIpzamm4wLT2NYR/PONxX3Fxwufmqw2D6WbpjmzCjqSzzgxQFf55
         Lzeyu0iYD23BytrcCHZ5c99phSrmCeb0BjYwE5Cz04psDeJ8ZUueiphTfqRbB1W8ZXak
         KARGlE13leYPTZYPisIuzlEnT5MrqA7DWSq1mDPO1Lt2mtE593T+nOMo/Pdw7pTkdBe2
         ggYwVEtGlm2On654FC9bGbUpnksouQFMIYn2+pGxJzTbs8bP6fiheRynSoBqDX66BHws
         NDEYLE3cTDIM5PM2lJ/albE44FWFO5Mp5UNqa+yorTkXWHMWmCtyyNB/0o945NZJuK4s
         fijQ==
X-Gm-Message-State: AOAM532QCFT+j1+WkLOMXXlXA6M4fPEN3RwiiVbEhzoLMH4pL7PVyvnO
        p9JzN2LJJJoPjo59T3ekDANJZ6ieJJWnCWtNc4SRY1nunhpl54QC/FHe5HPAEIltpg9OpG9FyXj
        Fa6YO2wh3pR1wMXQ6
X-Received: by 2002:a5d:5274:: with SMTP id l20mr4432615wrc.328.1635249817465;
        Tue, 26 Oct 2021 05:03:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGFYcDWKegak7lZKWZVg6qGQjlpWchFLO+aS1HDBIcbjueIlb4z8WBG5ZhcQkJ/2SdXt38Vg==
X-Received: by 2002:a5d:5274:: with SMTP id l20mr4432576wrc.328.1635249817265;
        Tue, 26 Oct 2021 05:03:37 -0700 (PDT)
Received: from krava ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id w5sm18934729wra.87.2021.10.26.05.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 05:03:36 -0700 (PDT)
Date:   Tue, 26 Oct 2021 14:03:34 +0200
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
Message-ID: <YXfulitQY1+Gd35h@krava>
References: <20211023120452.212885-1-jolsa@kernel.org>
 <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > hi,
> > I'm trying to enable BTF for kernel module in fedora,
> > and I'm getting big increase on modules sizes on s390x arch.
> >
> > Size of modules in total - kernel dir under /lib/modules/VER/
> > from kernel-core and kernel-module packages:
> >
> >                current   new
> >       aarch64      60M   76M
> >       ppc64le      53M   66M
> >       s390x        21M   41M
> >       x86_64       64M   79M
> >
> > The reason for higher increase on s390x was that dedup algorithm
> > did not detect some of the big kernel structs like 'struct module',
> > so they are duplicated in the kernel module BTF data. The s390x
> > has many small modules that increased significantly in size because
> > of that even after compression.
> >
> > First issues was that the '--btf_gen_floats' option is not passed
> > to pahole for kernel module BTF generation.
> >
> > The other problem is more tricky and is the reason why this patchset
> > is RFC ;-)
> >
> > The s390x compiler generates multiple definitions of the same struct
> > and dedup algorithm does not seem to handle this at the moment.
> >
> > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> >   http://people.redhat.com/~jolsa/kmodbtf/
> >
> > Please let me know if you'd like to see other info/files.
> >
> 
> Hard to tell what's going on without vmlinux itself. Can you upload a
> corresponding kernel image with BTF in it?

sure, uploaded

jirka

> 
> > I found code in dedup that seems to handle such situation for arrays,
> > and added 'some' fix for structs. With that change I can no longer
> > see vmlinux's structs in kernel module BTF data, but I have no idea
> > if that breaks anything else.
> >
> > thoughts? thanks,
> > jirka
> >
> >
> > ---
> > Jiri Olsa (2):
> >       kbuild: Unify options for BTF generation for vmlinux and modules
> >       bpf: Add support to detect and dedup instances of same structs
> >
> >  Makefile                  |  3 +++
> >  scripts/Makefile.modfinal |  2 +-
> >  scripts/link-vmlinux.sh   | 11 +----------
> >  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
> >  tools/lib/bpf/btf.c       | 12 ++++++++++--
> >  5 files changed, 35 insertions(+), 13 deletions(-)
> >  create mode 100755 scripts/pahole-flags.sh
> >
> 

