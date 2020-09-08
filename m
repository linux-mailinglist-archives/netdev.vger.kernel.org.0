Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7138261CDA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbgIHT1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731053AbgIHT12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 15:27:28 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34201C061755;
        Tue,  8 Sep 2020 12:27:27 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g72so193175qke.8;
        Tue, 08 Sep 2020 12:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EuLkSq/h0PySLcoqUIZc9Efa6tDdDoFulMc8JT2FysQ=;
        b=ZEGSvO1Xxpu4aYBEXdy/Uqc+1JVUorIAdGjltx0ruEgo5ZTtEgGP7I+4jiQA7N6ow2
         +4Ilwq9NZX5LyYDKc1yKs0o1fk8JUVY43cFEU77WQvKnoSwLbJutwoATJASAqvV0Fof0
         SxwgXE3ob7/3vdfQDXj+sSNo7We5M34zE3Sa0+/WN5i0XaK0xwXa7zUCc+ypiExINtpy
         ZjbU292Fb+cNMOU68F6UCgcOpqQj7ClVDPspjDSo7N3nDqUmfi2QtNb88OCDKaxXJ3wd
         ZBLphlojXQn4AzogWIsdd3DDaZGxk9JwYuz7qAj7r+T7AL1KIMFCvgbdpuJDSroD+XPt
         VHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EuLkSq/h0PySLcoqUIZc9Efa6tDdDoFulMc8JT2FysQ=;
        b=Oce3LMu0THjPqGfcUFj6HyhLwc9HR3SrSvyLtHyRuqxP0PhwsFBUhS2JVVpB2AtEJc
         mtAYqnc9A6F5AlOWdUJSqvyztJfweCLmvlOTvAPnDw99LCc82aEuoP7bdW0AeG9REejZ
         hRYKSavG8Q4hAkxFhppfz3gL8cPSLOolO5BjHVMjYrvWsItfByuO+gSsD5RloBXK9IUN
         VeIrU6wJJR234VIUMiQlqYa1mQScs3vgtKB9QJ+l0VFjXc5IEVdP3cQdRbf22nVZLFXu
         yWh2KFcqFwSHuOGG/quyor+O4Gd/6ZtZ2tt6/d+/yT3DZFTzwmqkLGV06tANACcp9bnv
         Xc7w==
X-Gm-Message-State: AOAM530TXWXpsJfOIFq6CJhc5cbWu6Zl9tLr6OeQrVgrZloL/g/oyqeE
        Q45VnRF02IixxOTFYhdQ/ss=
X-Google-Smtp-Source: ABdhPJyITvFLn0aDwyur1S830ay0M188rfil6lyR9M/2GxDZBgbKck1xnCqdKDMGjOSzwW7KdhPBVg==
X-Received: by 2002:a37:e504:: with SMTP id e4mr134369qkg.290.1599593246277;
        Tue, 08 Sep 2020 12:27:26 -0700 (PDT)
Received: from bpf-dev (pc-199-79-45-190.cm.vtr.net. [190.45.79.199])
        by smtp.gmail.com with ESMTPSA id g45sm422689qtb.60.2020.09.08.12.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 12:27:25 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:27:20 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v1 bpf-next] bpf: new helper bpf_get_current_pcomm
Message-ID: <20200908192719.GA1300@bpf-dev>
References: <20200826160424.14131-1-cneirabustos@gmail.com>
 <CAEf4BzYt3Wt5ABivJKifoW3XLL-U0B_KgXim0pUtqJUapo7raw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYt3Wt5ABivJKifoW3XLL-U0B_KgXim0pUtqJUapo7raw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 10:25:55PM -0700, Andrii Nakryiko wrote:
> On Wed, Aug 26, 2020 at 9:06 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > In multi-threaded applications bpf_get_current_comm is returning per-thread
> > names, this helper will return comm from real_parent.
> > This makes a difference for some Java applications, where get_current_comm is
> > returning per-thread names, but get_current_pcomm will return "java".
> >
> 
> Why not bpf_probe_read_kernel_str(dst, 16, task->real_parent->comm)
> for fentry/fexit/tp_btf/etc BTF-aware BPF programs or
> BPF_CORE_READ_STR_INTO(dst, task, real_parent, comm) for any BPF
> program that has bpf_probe_read_kernel[_str]() (which is pretty much
> every BPF program nowadays, I think)?
> 
> Yes, CONFIG_DEBUG_INFO_BTF=y Kconfig is a requirement, but it's a good
> idea to have that if you are using BPF anyways.
> 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >  include/linux/bpf.h                           |  1 +
> >  include/uapi/linux/bpf.h                      | 15 ++++-
> >  kernel/bpf/core.c                             |  1 +
> >  kernel/bpf/helpers.c                          | 28 +++++++++
> >  kernel/trace/bpf_trace.c                      |  2 +
> >  tools/include/uapi/linux/bpf.h                | 15 ++++-
> >  .../selftests/bpf/prog_tests/current_pcomm.c  | 57 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_current_pcomm.c  | 17 ++++++
> >  8 files changed, 134 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/current_pcomm.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_current_pcomm.c
> >
> 
> [...]
Thanks Andrii,
I'll use bpf_probe_read_kernel_str(dst, 16, task->real_parent->comm),
I was not aware of that.

Bests!. 

