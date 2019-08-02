Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8568A8019D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436919AbfHBUQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:16:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41775 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391076AbfHBUQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:16:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so26246620pgg.8
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YLAhV+4jhPUYACpUPTBG3b7Tlff8dIHdObEfywYVVAA=;
        b=foW0PubIFZ6J+5duhPpR+LUkQwaJ4aBGDBkzReFVLAKOixkSF2lP0MMC4GCUNOBOs6
         BtCf9duS9yWSMKqX+iyw8kMOsHGVwxCAe4R/U5BEw4sPiaRzNlVeZsGBvkgsbLOhI9Fx
         ojypklIw4OXkrCUi62NHHAylcV+dmxn9xptcTVm4V8Pvx3BrQa4jD8em58PdOBbXy7ML
         uoNmggPGiLdyE3BpLbm9M8pLC8QLMfGGEybb9MLif5y65i7S60xBRLnyj6WwI146D78a
         sbDY61TSxfpXMJ89fiTMpXzq6yQFVXbjGt+++sqqcCk+4c80tc822rhM+vY1txBcPJ8n
         KBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YLAhV+4jhPUYACpUPTBG3b7Tlff8dIHdObEfywYVVAA=;
        b=PnUljSdGFnXxhpihcsCME4NNc6KUkzDC6roBgM/f5dtefg5nDJkCj/9zRnU2Q9p1Kf
         6dYcib5RkQT0fAcqxsQbg82e/1Z/MfDNQcq5wmVMtbjTWpMvGfeP7nZGoed1vNS5Txbz
         GUzT3fdix/STv7TJlCUtsx8lpKATyrHr/SdGoGFdk/Xi38wx9kpaC+g4xYiLP1hhm1z+
         AfSUFOiUrvw3oVA1s6qV+wRvfWyhWkE08QhLk3/6cPj6Aitd0/723VQDlt8Et4z+M2yB
         nZ49V22nz9XemwNKxdcoXcY0aCf3aEOiDeCdHaEZtY0XovOIOePX5ln5fKwTwe3Funu/
         7bDg==
X-Gm-Message-State: APjAAAX0sa9TLC0jpv2VlGc1wqPTd5x1WXL4968KyjeJtvk4tYKN9bCl
        uMd4525wxPTfUW8jRzUXatY=
X-Google-Smtp-Source: APXvYqwdsmWRfliuCyFK2Bcv/RRNJuQkZ6+T2ov6OEd649ptJg0earjouGfCjCOsRngH1+01f8ydQg==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr5973740pjl.78.1564777000375;
        Fri, 02 Aug 2019 13:16:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 201sm92273064pfz.24.2019.08.02.13.16.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:16:39 -0700 (PDT)
Date:   Fri, 2 Aug 2019 13:16:39 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] selftests/bpf: switch test_progs back to
 stdio
Message-ID: <20190802201639.GC4544@mini-arch>
References: <20190802171710.11456-1-sdf@google.com>
 <c79d3a8c-4986-a321-7b68-5273be7c2be7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c79d3a8c-4986-a321-7b68-5273be7c2be7@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02, Andrii Nakryiko wrote:
> 
> On 8/2/19 10:17 AM, Stanislav Fomichev wrote:
> > I was looking into converting test_sockops* to test_progs framework
> > and that requires using cgroup_helpers.c which rely on stdio/stderr.
> > Let's use open_memstream to override stdout into buffer during
> > subtests instead of custom test_{v,}printf wrappers. That lets
> > us continue to use stdio in the subtests and dump it on failure
> > if required.
> >
> > That would also fix bpf_find_map which currently uses printf to
> > signal failure (missed during test_printf conversion).
> I wonder if we should hijack stderr as well?
I was planning to do it when I add cgroup_helpers support because they
log to stderr. Wanted to keep the changes minimal. But let's do
them all in this series while we are it.

> > Cc: Andrii Nakryiko <andriin@fb.com>
> >
> > Stanislav Fomichev (3):
> >   selftests/bpf: test_progs: switch to open_memstream
> >   selftests/bpf: test_progs: test__printf -> printf
> >   selftests/bpf: test_progs: drop extra trailing tab
> >
> >  .../bpf/prog_tests/bpf_verif_scale.c          |   4 +-
> >  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
> >  .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
> >  .../selftests/bpf/prog_tests/send_signal.c    |   4 +-
> >  .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
> >  .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
> >  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
> >  .../selftests/bpf/prog_tests/xdp_noinline.c   |   4 +-
> >  tools/testing/selftests/bpf/test_progs.c      | 116 +++++++-----------
> >  tools/testing/selftests/bpf/test_progs.h      |  12 +-
> >  10 files changed, 68 insertions(+), 94 deletions(-)
> >
