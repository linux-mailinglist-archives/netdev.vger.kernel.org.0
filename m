Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E474247B6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbhJFUJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239279AbhJFUJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 16:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633550831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHzIelJadnRS/j3Vm7h6CrTo9MDSeVUCHjzInhdbR2g=;
        b=Pj9zISJO5ulX+DZ1MEqGD6AASGXjICYb4j/lb6HoTom9Jc2tkG8zRRfcIAXbw7OjNqKA/o
        mdh+cm0Wgsh1cWPbFN3Iby70Q3MIPLcEmJvMg/5PMk3jar9KSUt11RUHAkWl3xJnL3f73u
        MrMaJsibJ6hRnCOw307Y9KjyIVvhWB8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-8Y81ZbtQMtKFv3SyWrbfiQ-1; Wed, 06 Oct 2021 16:07:10 -0400
X-MC-Unique: 8Y81ZbtQMtKFv3SyWrbfiQ-1
Received: by mail-wr1-f70.google.com with SMTP id a10-20020a5d508a000000b00160723ce588so2906266wrt.23
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 13:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wHzIelJadnRS/j3Vm7h6CrTo9MDSeVUCHjzInhdbR2g=;
        b=pXJAgziccUjD9lG4J4elib1yug3Ih36aV8S0YWt88dVY5yknfxkQ/EvDPh71U3W37C
         /hHrZb6TCmJe3zRUPGlxmc59edgsVWQCJsaTM7UMh7AI5eiqwgsC8GLsZs9jpYRUUKIp
         KUBjnhmz5lf2zQWJ6nCajdTr5eHYMLVmaC8tEFT72sTHCz0DhtvkUFSYz1xaRf/1iC/+
         VqS5Zsm+TpPPr/+Qdxl+tOJcg/BvYObDqNPPwspXc2MZqel5sPK7B7xH48+KtNf3w5OM
         313xgiFlZB72JT1sHXaeBamL0F1H55TLoBLI9aQK95ndTqCzfkTbeDuLsryeKao6Louy
         GutA==
X-Gm-Message-State: AOAM532R/IKY9gmFd9V8Jtb4BNlDaZDlH+mOtKfsYw/Q603ooHnGW0zv
        R8IC03cBDsLVS2G/QhJKE/rbQyPd3SF+KiO+d7L/EVE7agMq56XUuwZpxUmtm29itNSEQT5NsE/
        9LJqjlW5R5/UzYvjQ
X-Received: by 2002:adf:9791:: with SMTP id s17mr173935wrb.122.1633550829166;
        Wed, 06 Oct 2021 13:07:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzo2gS7y2xl/y0Q9acKCMNNR3wL2fxqFLbprZzYf1iP9T6dmu/b4rBaNjc7gJGDdzRbsvEgHQ==
X-Received: by 2002:adf:9791:: with SMTP id s17mr173917wrb.122.1633550829029;
        Wed, 06 Oct 2021 13:07:09 -0700 (PDT)
Received: from krava ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id l21sm7271308wmg.18.2021.10.06.13.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 13:07:08 -0700 (PDT)
Date:   Wed, 6 Oct 2021 22:07:06 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [RFC] store function address in BTF
Message-ID: <YV4B6nUbtCVLHbZW@krava>
References: <YV1hRboJopUBLm3H@krava>
 <YV1h+cBxmYi2hrTM@krava>
 <CAADnVQLeHHBsG3751Ld3--w6KEM1a+8V4KY8MReexWo+bLgdmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLeHHBsG3751Ld3--w6KEM1a+8V4KY8MReexWo+bLgdmg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 07:53:31AM -0700, Alexei Starovoitov wrote:
> On Wed, Oct 6, 2021 at 1:44 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Oct 06, 2021 at 10:41:41AM +0200, Jiri Olsa wrote:
> > > hi,
> > > I'm hitting performance issue and soft lock ups with the new version
> > > of the patchset and the reason seems to be kallsyms lookup that we
> > > need to do for each btf id we want to attach
> >
> > ugh, I meant to sent this as reply to the patchset mentioned above,
> > nevermind, here's the patchset:
> >   https://lore.kernel.org/bpf/20210605111034.1810858-1-jolsa@kernel.org/
> >
> > jirka
> >
> > >
> > > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > > but it has its own pitfalls like duplicate function names and it still
> > > seems not to be fast enough when you want to attach like 30k functions
> > >
> > > so I wonder we could 'fix this' by storing function address in BTF,
> > > which would cut kallsyms lookup completely, because it'd be done in
> > > compile time
> > >
> > > my first thought was to add extra BTF section for that, after discussion
> > > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > > indicate that? or new BTF_KIND_FUNC2 type?
> > >
> > > thoughts?
> 
> That would be on top of your next patch set?
> Please post it first.

ok, will do

jirka

