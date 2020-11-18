Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A829B2B744C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgKRCpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKRCpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:45:17 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01E1C0613D4;
        Tue, 17 Nov 2020 18:45:15 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id c25so44399ooe.13;
        Tue, 17 Nov 2020 18:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wpo5VsLk4AEgiYqixU2L/zk44EdFxc8s4iCzaoXeybY=;
        b=OSDImuQmHCnSYvy7hxnxYvk+9Dp8P1iA+m3BTZk22HVZMTGXIfmk6r9PXAMME5Eyru
         jxZVdMSPggLgi/wcWmBUyXZuw7WOse2lwxcZmuslE3Z5/58uQ5jwZQTvGHy4YDMkmOoR
         JQNUwz8h8buA1IL+Gb3LkjZr/takrtQVXziX9rgbRFLRm3ZFmigVCNCGD4A6c/uFUQhg
         Q70JRfIVsjk3zIGBqRWQYi7qBVdA4/BA9XYaUJg5Uu4ZookSdC031opm3LgxRS/i+9/v
         iptXSZlmZ6fHT1FOCYCHTnNawGBliotjKcdJ+cNaYb/DAHe0jh0x762amT/3gEwl1jRV
         1NFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wpo5VsLk4AEgiYqixU2L/zk44EdFxc8s4iCzaoXeybY=;
        b=jjs7Y1T/AI66ZsX7+K7dSm/0R2dtdvc1kdgFj4aRm1IRGwGWrmLlYOYsBB3r5MqvJH
         VwqKnQvtqo2c+vDDwxJAcCX2n3F/IHtubCauI+JE/TKvCGdMxbWuu+1Q6tCPYRUHhLZq
         TwZ7qm47I5TFmbbLT6zehEQF5dSFb00C934yBTQXQSd29nc44DxKIMxja6srTfCPG5kB
         JRnD+4SdQpPQvcIjgauiQmBvjbrWRGNWmFgELIZltR+vqsZ8/99ZcJd6KBI64Y8MSfFr
         oPq5nLJygW6rBaLFd2QJhCH9T/J6A6QfnhENAPSxMYkXL7zacckp0cfCpQRF/rzJCEAr
         kAWQ==
X-Gm-Message-State: AOAM53380lHo/nnFl/Kx74vXUZIilyUpzYXtED8ShO4sSdu64pMIig8U
        7I184R23QBzvPcaQV3IJvUwIiygSygLEM1Y97w==
X-Google-Smtp-Source: ABdhPJxRe1wWtbihQMgclKp5iTWtrLmR6eyHN3YLueft8EZeEiUJ3JUNPRGu/HdrsA+5sWjMA0N5MVaqk9byfPlnKgY=
X-Received: by 2002:a4a:9808:: with SMTP id y8mr5145229ooi.60.1605667514788;
 Tue, 17 Nov 2020 18:45:14 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-2-danieltimlee@gmail.com> <20201118011917.v5zagoksa4h2yuei@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201118011917.v5zagoksa4h2yuei@kafai-mbp.dhcp.thefacebook.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 11:44:58 +0900
Message-ID: <CAEKGpziZTKxbdC7pER4bVV=_2Bm5apyFa_DdabkQPwQVQMKzkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to trace_helper
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 10:19 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 17, 2020 at 02:56:36PM +0000, Daniel T. Lee wrote:
> > Under the samples/bpf directory, similar tracing helpers are
> > fragmented around. To keep consistent of tracing programs, this commit
> > moves the helper and define locations to increase the reuse of each
> > helper function.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
> >  samples/bpf/Makefile                        |  2 +-
> >  samples/bpf/hbm.c                           | 51 ++++-----------------
> >  tools/testing/selftests/bpf/trace_helpers.c | 33 ++++++++++++-
> >  tools/testing/selftests/bpf/trace_helpers.h |  3 ++
> >  4 files changed, 45 insertions(+), 44 deletions(-)
> >
> > [...]
> >
> > -#define DEBUGFS "/sys/kernel/debug/tracing/"
> Is this change needed?

This macro can be used in other samples such as the 4th' patch of this
patchset, task_fd_query.

> > -
> >  #define MAX_SYMS 300000
> >  static struct ksym syms[MAX_SYMS];
> >  static int sym_cnt;
> > @@ -136,3 +134,34 @@ void read_trace_pipe(void)
> >               }
> >       }
> >  }
> > +
> > +void read_trace_pipe2(char *filename)
> > +{
> > +     int trace_fd;
> > +     FILE *outf;
> > +
> > +     trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
> > +     if (trace_fd < 0) {
> > +             printf("Error opening trace_pipe\n");
> > +             return;
> > +     }
> > +
> > +     outf = fopen(filename, "w");
> > +     if (!outf)
> > +             printf("Error creating %s\n", filename);
> > +
> > +     while (1) {
> > +             static char buf[4096];
> > +             ssize_t sz;
> > +
> > +             sz = read(trace_fd, buf, sizeof(buf) - 1);
> > +             if (sz > 0) {
> > +                     buf[sz] = 0;
> > +                     puts(buf);
> > +                     if (outf) {
> > +                             fprintf(outf, "%s\n", buf);
> > +                             fflush(outf);
> > +                     }
> > +             }
> > +     }
> It needs a fclose().
>
> IIUC, this function will never return.  I am not sure
> this is something that should be made available to selftests.

Actually, read_trace_pipe and read_trace_pipe2 are helpers that are
only used under samples directory. Since these helpers are not used
in selftests, What do you think about moving these helpers to
something like samples/bpf/trace_pipe.h?

Thanks for your time and effort for the review.

-- 
Best,
Daniel T. Lee
