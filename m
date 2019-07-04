Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D605FC4C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfGDRNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:13:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52415 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfGDRNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:13:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so6395995wms.2;
        Thu, 04 Jul 2019 10:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVkyOsnwbLJnvov8gKU5rdvTrE1Z1ljmL0ULAFvpbeg=;
        b=bGG9ggHK/zW4uS7jJqgIgO+nREbqlh4Ev3uIK7HHlROlCbzGlJshPiqPNofyKOE88S
         CMzUglWE1UfZiR+IyiGgZVAbmVf/VvDqirzBJXXRpQMEUuQVUtywXc/M+NuYvYoIk3FX
         dpEO1rgNJ3rAiujbOWsaGln5p03adEPu8SUGw8LdAygow3wdWtZZSJBm7JzBtduparMQ
         eFxV1XOwaCdM8Kp9P0pU4axlHiZ78dzFzY5ci6AE7JByAHXECRPrFZR6yddUJEOOgZeg
         nnBPg09c7oFyBVwKFia/9KOF1YWLNps8jZQGbkWPMtkdH3JsWwbM/nyJP3efUlZyXPeP
         uwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVkyOsnwbLJnvov8gKU5rdvTrE1Z1ljmL0ULAFvpbeg=;
        b=rAEObOvk3WVK4jmzKbmEC2Zn2dDxMjQFdJJIKYGo9pIL20Sl9BQ6KTKhKwnKOLHyDs
         XI1rkrB/S+Gzb7mdqNHWjgGM63BjkHW5nRxdzY5HMJgYr1PWdff83oVnudKDEJ+gd6iQ
         at/M4wSmwRdoLy1sQCsOOatFkHy/KgfolM0PYhfGGX+QQ7AUuyD/fjgNksXko6MPmc55
         iQMMdKCek9y7ZS+EAVrpS4G+xGaXKBxb89Uvaqd5gght/wl+S+NhWuLtxs8SbssM1A3D
         Hyc0QBPG+AtO1h/+n39rbDsdplIECmbK3zNvHmyvCZGYNEF1YipXXYxAtNFgpFAUxp/m
         f/7A==
X-Gm-Message-State: APjAAAV9B/JRu4boUnbhIJqSvdgSI6wabWz+aas2gwd2vwUdP133z1mf
        CPR7BlijC+d90GLH2ViVC0SBUQHHDJ+RMfwnbgc=
X-Google-Smtp-Source: APXvYqwRvtnSu8SXq9oMh7dpaCOtxaaM6f9X7CsV89vnYM7FnXZ6Fkl7GffIv1GaVqztG7YdU1Op7iZ7usEStfXSNfc=
X-Received: by 2002:a7b:c106:: with SMTP id w6mr419153wmi.80.1562260412563;
 Thu, 04 Jul 2019 10:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <201907040313.x643D8Pg025951@userv0121.oracle.com> <201907040314.x643EUoA017906@aserv0122.oracle.com>
In-Reply-To: <201907040314.x643EUoA017906@aserv0122.oracle.com>
From:   Brendan Gregg <brendan.d.gregg@gmail.com>
Date:   Thu, 4 Jul 2019 10:13:06 -0700
Message-ID: <CAE40pdeSfJBpbBHTmwz1xZ+MW02=kJ0krq1mN+EkjSLqf2GX_w@mail.gmail.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 8:17 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> This initial implementation of a tiny subset of DTrace functionality
> provides the following options:
>
>         dtrace [-lvV] [-b bufsz] -s script
>             -b  set trace buffer size
>             -l  list probes (only works with '-s script' for now)
>             -s  enable or list probes for the specified BPF program
>             -V  report DTrace API version
>
> The patch comprises quite a bit of code due to DTrace requiring a few
> crucial components, even in its most basic form.

This patchset has moved from adding tests (which actually belong in
selftests, not tools/dtrace), to the start of adding a giant tracer to
the kernel code base.

First, in some ways you're doing this for me -- I've been the number
one user of DTrace for 15 years -- and thanks, but no thanks. I don't
need this anymore. I needed this 6 years ago, and I would have helped
you build it, but in the meantime Linux has built something better,
built from the ground up for BPF: bpftrace.

Second, you argued that DTrace was needed because of speculative
tracing (a feature I never used), as you had customers who wanted it.
Those customers aren't going to be happy with this initial tiny
implementation of DTrace -- this is really the start of adding a large
and complex tracer to the kernel.

We've all been working under the assumption that these user-space
tracers did not belong in the kernel, and so far that's been working
fine for us. Is it now open season for tracers in the kernel? Let's
have:

tools/bpftrace
tools/ply
tools/systemtap
tools/LTTng
tools/sysdig
tools/ktap
etc

Yes, that's ridiculous. If there's only going to be one, let's have
the best one, bpftrace. We'll offer a version that is GPL, C, and has
no dependencies.

But it would be news to us all that we're allowed to have even one.

There are more things that don't make sense about this, but I'll stop
here for now.




Brendan
