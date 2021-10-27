Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAB443D089
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbhJ0SUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:20:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231232AbhJ0SUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:20:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635358696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oeVb0xwU3RVC2ffCwrZ+tSJ1H6eF2Vx0w179pJgMmVw=;
        b=f+a2pQMbhXDKj0ZacaDKqR2i1QNPIp8RmKKQJ4X9jWrXm1Qac/+oTrRGZXy18EClLK4jN3
        E9PG2ML7PYL+0ZPlBXIH5n1ow1xM0TXQEUsoppE6EHTfKunbcKujoU+TE/3hMsKfNRrV7J
        /FJ6/LSfr0BBHaWh9ZyaJzqKSTN2z9Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-sZHmtJVKO8mMEbG7hab2RA-1; Wed, 27 Oct 2021 14:18:15 -0400
X-MC-Unique: sZHmtJVKO8mMEbG7hab2RA-1
Received: by mail-ed1-f72.google.com with SMTP id h16-20020a05640250d000b003dd8167857aso3183470edb.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oeVb0xwU3RVC2ffCwrZ+tSJ1H6eF2Vx0w179pJgMmVw=;
        b=rOfm3JMy3+FRKJpOEs9FbbMaoED8NcK5VHYhYGgRK7X57NJoNThAQaq+zzLE/zVESa
         vxsqIBifbhNLKLFVjp57C7PYcuhHTRKOEmKzFnuICT9htfJPrjYEYEzLlmpxQCAs9eSd
         zX/8lDdMom9QV1maU7+XmZYJf+2XUihi6hZ36sGM2LXbLKPQUNtS5W1XyVBhP21zxSHG
         Qn6I1z6ZlbiPL6gOhcZ9ifdZUecsS1NHzlxLAmOWDn64WvgzWnsh4jngzMBjgIA3iXFP
         UdXmQmcfGx+d4Fw+M+2LGbzLWRiARrzpgmE03CWZQsc9mdQwsH3nXMgd5ffg8b6sn3oW
         bRJg==
X-Gm-Message-State: AOAM531tR0ICq+zfngZ7BuaoVkmkcjVYzj1gUjgI53zaT6rWW0wwhJHA
        VM/K3i4+WYQdYxbFI6+KvGxKvn+MQllGyTg0gOKGmtgO5G52MXHw9SpX4LBwAkRsjaF/dsTbAey
        vMs4XoPhiVWBkh09P
X-Received: by 2002:a17:907:7b8c:: with SMTP id ne12mr3847598ejc.53.1635358693731;
        Wed, 27 Oct 2021 11:18:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7HLhT8fA2OZWkOdlrdfjdjwZ72FLBAdd0wsJSEP/sO5KD8178JLePGdGWCjpkEL+qyCdArA==
X-Received: by 2002:a17:907:7b8c:: with SMTP id ne12mr3847566ejc.53.1635358693518;
        Wed, 27 Oct 2021 11:18:13 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id e9sm312678ejs.76.2021.10.27.11.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 11:18:13 -0700 (PDT)
Date:   Wed, 27 Oct 2021 20:18:11 +0200
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
Message-ID: <YXmX4+HDw9rghl0T@krava>
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

On Wed, Oct 27, 2021 at 10:53:55AM -0700, Andrii Nakryiko wrote:
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

it failed for me on that hypot_type_id check where I did fix,
I thought it's the issue of multiple same struct in the kmod,
but now I see I might have confused cannon_id with cand_id ;-)
I'll check more on this

jirka

