Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73157CC2B4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfJDSae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 14:30:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46095 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbfJDSae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 14:30:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id u22so9798020qtq.13
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 11:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5F9jp+3P+68jwAznLgj7oVx64SI5EHhSgDNeXcOVVQg=;
        b=g2HKDO/vwwOJO1vommCnEKk06YdVU4lWybPolJFcsAkJBHdzEYyVEBUUaSyYRXeM8q
         mvGtnf/uyPLQTaQNI27pEsmkF9r6IChNqHMIjLOT6uqLU/JRZcRzRLIdv5rl0rOAMLyy
         GV8ppbUOKXW3/9citdE6G0faU5arAR5fIgaGKfiez3V8omdTbz2lgaxCV2jJhBqvhtRk
         ik58ifENj5Zvh+HxUsnxhBUfRC9HwEuZQwwmwexGuY7F3bJ8OByYkxjL6Af8rcCEbY5B
         9bFp2cKf2e8ZsNib7qELM6DrSOzKUV+6rQfmvMIqR9v4gglwczYvmbasubs9/oGKdLx3
         SCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5F9jp+3P+68jwAznLgj7oVx64SI5EHhSgDNeXcOVVQg=;
        b=OOFBWmkcGsDkKys1EmiTbg5XiPV8tVq4Ez0/fCUN+jHkwjUtaA87az1vtX01TBsACs
         YXjYzlaHW3cEOTICJwAwm83bLuei+sZsvSXsXkj3S4KgPNYAW9g7QWUzu99ysp2g+Cjl
         N5xXuMKXbr67HbT7VWTiSMTOQt+HLuPSTiFchcXBQmlzIQCP7LZk3bEWMFwyRxSoYHB3
         1UwQQEGOHKG/ZU0Al/ned6tVUmRV0WG61WECKrnHCAKAX9XbcAMvL271cTdG0SimBi/P
         AAdbTVFYQxYMuYKj01XNjoCG7JtHmqiaXZ1pGmHtW/YnMzO3eftt0t7uojrbzxsBgLwJ
         w8Vg==
X-Gm-Message-State: APjAAAVcHpIKDVSJ/d/gL1ApEDDgvH96gYuUC6Z23Z6VB5T2JqVjvOwA
        EkQQ+8C32fIq6rGQxo5ob9AgMA==
X-Google-Smtp-Source: APXvYqzREQAiQ0R0gJWiDYmBXnX59gAzXW+vnkk/idXZAAcXA8VuDHv+mShW5axiBY5xxDluTeF9fg==
X-Received: by 2002:a0c:e2c9:: with SMTP id t9mr15127954qvl.22.1570213832072;
        Fri, 04 Oct 2019 11:30:32 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l48sm3870355qtb.50.2019.10.04.11.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 11:30:31 -0700 (PDT)
Date:   Fri, 4 Oct 2019 11:30:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Message-ID: <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
References: <20191003212856.1222735-1-andriin@fb.com>
        <20191003212856.1222735-6-andriin@fb.com>
        <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
        <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
        <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
        <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 09:00:42 -0700, Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 8:44 AM David Ahern <dsahern@gmail.com> wrote:
>> > I'm not following you; my interpretation of your comment seems like you
> > are making huge assumptions.
> >
> > I build bpf programs for specific kernel versions using the devel
> > packages for the specific kernel of interest.  
> 
> Sure, and you can keep doing that, just don't include bpf_helpers.h?
> 
> What I was saying, though, especially having in mind tracing BPF
> programs that need to inspect kernel structures, is that it's quite
> impractical to have to build many different versions of BPF programs
> for each supported kernel version and distribute them in binary form.
> So people usually use BCC and do compilation on-the-fly using BCC's
> embedded Clang.
> 
> BPF CO-RE is providing an alternative, which will allow to pre-compile
> your program once for many different kernels you might be running your
> program on. There is tooling that eliminates the need for system
> headers. Instead we pre-generate a single vmlinux.h header with all
> the types/enums/etc, that are then used w/ BPF CO-RE to build portable
> BPF programs capable of working on multiple kernel versions.
> 
> So what I was pointing out there was that this vmlinux.h would be
> ideally generated from latest kernel and not having latest
> BPF_FUNC_xxx shouldn't be a problem. But see below about situation
> being worse.

Surely for distroes tho - they would have kernel headers matching the
kernel release they ship. If parts of libbpf from GH only work with
the latest kernel, distroes should ship libbpf from the kernel source,
rather than GH.

> > > Nevertheless, it is a problem and thanks for bringing it up! I'd say
> > > for now we should still go ahead with this move and try to solve with
> > > issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> > > for someone, it's no worse than it is today when users don't have
> > > bpf_helpers.h at all.
> > >  
> >
> > If this syncs to the github libbpf, it will be worse than today in the
> > sense of compile failures if someone's header file ordering picks
> > libbpf's bpf_helpers.h over whatever they are using today.  
> 
> Today bpf_helpers.h don't exist for users or am I missing something?
> bpf_helpers.h right now are purely for selftests. But they are really
> useful outside that context, so I'm making it available for everyone
> by distributing with libbpf sources. If bpf_helpers.h doesn't work for
> some specific use case, just don't use it (yet?).
> 
> I'm still failing to see how it's worse than situation today.

Having a header which works today, but may not work tomorrow is going
to be pretty bad user experience :( No matter how many warnings you put
in the source people will get caught off guard by this :(

If you define the current state as "users can use all features of
libbpf and nothing should break on libbpf update" (which is in my
understanding a goal of the project, we bent over backwards trying 
to not break things) then adding this header will in fact make things
worse. The statement in quotes would no longer be true, no?
