Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B425CF13
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 03:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgIDB3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 21:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgIDB3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 21:29:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830FC061244;
        Thu,  3 Sep 2020 18:29:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o16so2420907pjr.2;
        Thu, 03 Sep 2020 18:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GvMH0hlLtrOknCj47mhqApAyGYb83/XohGv2CTFb4SY=;
        b=GBRYyc76jg4BzxckhAPQC6u899ObYMAc+oRzzGiT15KxaSFQOyZUA4Ebxm+k4is6SG
         0vu/xO29fuSJA2ZbPS5bXq681/quJfO5n2BkWhZlJ2i+mopBV2736BLTcqy2PkYisyVi
         bnAiWeZLKARKFDkOap0omMlYHj4RDtOfknTJTUjkLBXvch/4XOnJp5lwtrEUlUyxzzWd
         KyRlMj9tDxRWgWPdm+tImlAm7tFpXabhzaD/AW9Ppo/0CqylLGz2Rv2l8ZuD04dN/3eA
         D8iD/Jx7MkoZAZvr623hSz+xQZID5ACeIRd9+BP3F9KV/q+RcNudZulikFkuZJtQmUE0
         mqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GvMH0hlLtrOknCj47mhqApAyGYb83/XohGv2CTFb4SY=;
        b=X8YvLAo7cXgr1IQoQG3sy/4sZBVDBg0EtEiViCuSaiw0a7TJLbrPfJwZ/b822vE/4c
         rLBE4ohVFqmwHrQdJIEiVDLpRFKY91zYltWttrCPR0nsaWdhtEYW503lvxCGNNJtAoVu
         z2ElnV+K1hRnnLVH5WmheyA5B9Zjn29stKFUkxux7x+hB3iNDMybyP815nVpxRjOcaqY
         wdjUHZebLK1330U6XU4R81WududodLLCrlTh7z9ng++Sd5OrL75N77dCq4aYRulw/YwQ
         rHRawsbO03N9OKpKlfmUnsx95wk9S7fJmf+IJgoRsquLQwW2VgdARDocEO8rNFOlnUKH
         WoPg==
X-Gm-Message-State: AOAM531luvjnuoS1L57lyRZN5lRyufzHBkmN4nmu9QEh4iZcXvECr1W1
        j7QlZJNNjbJuJpDnpHzcCUs=
X-Google-Smtp-Source: ABdhPJzz/arDtGXQ8gm662yBuSBmd72o+cvNH3s8uLsJR1pfhUMiJFxHQqhlHPN+Q4GR6rpZgsLDMw==
X-Received: by 2002:a17:902:43:: with SMTP id 61mr6695916pla.16.1599182952174;
        Thu, 03 Sep 2020 18:29:12 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id v11sm3887065pgs.22.2020.09.03.18.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 18:29:11 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:29:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall
 and use it on .metadata section
Message-ID: <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 07:31:33PM -0700, Andrii Nakryiko wrote:
> On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > From: YiFei Zhu <zhuyifei@google.com>
> >
> > The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> > And when using libbpf to load a program, it will probe the kernel for
> > the support of this syscall, and scan for the .metadata ELF section
> > and load it as an internal map like a .data section.
> >
> > In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
> > a .metadata section exists, the map will be explicitly bound to
> > the program via the syscall immediately after program is loaded.
> > -EEXIST is ignored for this syscall.
> 
> Here is the question I have. How important is it that all this
> metadata is in a separate map? What if libbpf just PROG_BIND_MAP all
> the maps inside a single BPF .o file to all BPF programs in that file?
> Including ARRAY maps created for .data, .rodata and .bss, even if the
> BPF program doesn't use any of the global variables? If it's too
> extreme, we could do it only for global data maps, leaving explicit
> map definitions in SEC(".maps") alone. Would that be terrible?
> Conceptually it makes sense, because when you program in user-space,
> you expect global variables to be there, even if you don't reference
> it directly, right? The only downside is that you won't have a special
> ".metadata" map, rather it will be part of ".rodata" one.

That's an interesting idea.
Indeed. If we have BPF_PROG_BIND_MAP command why do we need to create
another map that behaves exactly like .rodata but has a different name?
Wouldn't it be better to identify metadata elements some other way?
Like by common prefix/suffix name of the variables or
via grouping them under one structure with standard prefix?
Like:
struct bpf_prog_metadata_blahblah {
  char compiler_name[];
  int my_internal_prog_version;
} = { .compiler_name[] = "clang v.12", ...};

In the past we did this hack for 'version' and for 'license',
but we did it because we didn't have BTF and there was no other way
to determine the boundaries.
I think libbpf can and should support multiple rodata sections with
arbitrary names, but hardcoding one specific ".metadata" name?
Hmm. Let's think through the implications.
Multiple .o support and static linking is coming soon.
When two .o-s with multiple bpf progs are statically linked libbpf
won't have any choice but to merge them together under single
".metadata" section and single map that will be BPF_PROG_BIND_MAP-ed
to different progs. Meaning that metadata applies to final elf file
after linking. It's _not_ per program metadata.
May be we should talk about problem statement and goals.
Do we actually need metadata per program or metadata per single .o
or metadata per final .o with multiple .o linked together?
What is this metadata?
If it's just unreferenced by program read only data then no special names or
prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any map to any
program and it would be up to tooling to decide the meaning of the data in the
map. For example, bpftool can choose to print all variables from all read only
maps that match "bpf_metadata_" prefix, but it will be bpftool convention only
and not hard coded in libbpf.
