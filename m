Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7683FD8CC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 13:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243781AbhIALdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 07:33:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238369AbhIALdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 07:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630495970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6netPg1DM6J6m9jP5JMQpkuST6xoxnvoTUqGxm7eQwk=;
        b=VUpP0Bt9zWTnlDPvY6dMy1sGXOL5XKtSYvm2a57TebdNTWRvxaD8llVWws+T6RBuR44rlU
        RUJVQBvdXaAvI2gdzCVayb4i+WrNuUejzOETCUjBI2sHTnixcANN6FTaxMNLIFgQkVBSpq
        8oCxnImSz5STVOaMVvMJfKM5akCERn8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Tvv3FineO8KDWLUN5Jcerg-1; Wed, 01 Sep 2021 07:32:47 -0400
X-MC-Unique: Tvv3FineO8KDWLUN5Jcerg-1
Received: by mail-wr1-f69.google.com with SMTP id h1-20020adffd41000000b0015931e17ccfso425803wrs.18
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 04:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6netPg1DM6J6m9jP5JMQpkuST6xoxnvoTUqGxm7eQwk=;
        b=HkyKmNYaSEc05nYTooPVFHjckQLQk1x2bVUwdWcHnHslXBNrWpZlutFjGOEscJYQuE
         Jhr3DaleH7tiF4OT3L1z1R1BjeskKYhn4qq/GS5+sUJZgrptVB8GM0cQWwywS+ddZTsN
         7UAaTxUF3PNBZhaMggXghhleA3H/ltPghm/E1eNA2EdNQJeXdOzZ2vvhMgnO8fXtYG7B
         AMHvmh11ZwANJAJlGAy5r26RTtUhlBZ6+1v3OsBNNK6nlzq8q/eXcwNF8bmc/+Xv7Sub
         zb6ypLN6YgjJRhElxcp/yEIPdFfkSlJyBv/ftTwCYWbhRtsn/y7F0L0NIfBLaGf4nQSK
         ZRTw==
X-Gm-Message-State: AOAM530iMN7VrSuhPIVJKpC0O93wfF3/kYWz+uksKRd+gx5jjWdFPO+2
        ExYeM06Zcp6Q7JplsBHXI3p08zqGkH5dmGfvq+NANDZj5hsmFRmqxjyvnYmzG0kH7onrlyDxGD7
        knUGnD8wKzo7mom86
X-Received: by 2002:a5d:58dc:: with SMTP id o28mr36823631wrf.399.1630495966110;
        Wed, 01 Sep 2021 04:32:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcfZ/12Kfh5NvWIe2vyaXR1GLTi0LGhQYmazC3xTeeM387yIBEh8dT9AhLZyVsR+2hfbVP6w==
X-Received: by 2002:a5d:58dc:: with SMTP id o28mr36823617wrf.399.1630495965953;
        Wed, 01 Sep 2021 04:32:45 -0700 (PDT)
Received: from krava ([94.113.247.3])
        by smtp.gmail.com with ESMTPSA id v21sm22763524wra.92.2021.09.01.04.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 04:32:45 -0700 (PDT)
Date:   Wed, 1 Sep 2021 13:32:43 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH bpf-next v4 09/27] bpf: Add support to load multi func
 tracing program
Message-ID: <YS9k26rRcUJVS/vx@krava>
References: <20210826193922.66204-1-jolsa@kernel.org>
 <20210826193922.66204-10-jolsa@kernel.org>
 <CAEf4BzYJXJbquSKdc_iEfFGXuA3eYMgwvAbOWEkBo7BW4faZww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYJXJbquSKdc_iEfFGXuA3eYMgwvAbOWEkBo7BW4faZww@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 04:17:33PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 26, 2021 at 12:40 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
> > that allows the program to be loaded without specific function to be
> > attached to.
> 
> Are there any benefits to using a new load flag vs having separate
> expected attach types like FENTRY_MULTI/FEXIT_MULTI? I find load flags
> a bigger pain to work with compared to expected attach type (and
> expected attach type should be more apparent in BPF link info, bpftool
> output, etc).

it means more of the additional code, with the flag we just reuse
BPF_TRACE_FENTRY/BPF_TRACE_FEXIT related code because we use
current trampoline paths

I recall trying that approach while back, but ended up with bigger
changes that seemed unnecessary, I can dig it up to get more
details

jirka

> 
> >
> > Such program will be allowed to be attached to multiple functions
> > in following patches.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h            |  1 +
> >  include/uapi/linux/bpf.h       |  7 +++++++
> >  kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
> >  kernel/bpf/verifier.c          |  3 ++-
> >  tools/include/uapi/linux/bpf.h |  7 +++++++
> >  5 files changed, 47 insertions(+), 6 deletions(-)
> >
> 
> [...]
> 

