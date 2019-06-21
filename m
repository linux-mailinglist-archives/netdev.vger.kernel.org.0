Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563AF4DFCC
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUEmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:42:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34158 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfFUEmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:42:51 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so5686031qtu.1;
        Thu, 20 Jun 2019 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0phPAmXHZiY++ODa4LylUzpwFoY+97hggz//3Pk7dVg=;
        b=RNGHir3Fj1f2JT2IK4y0xa66MHatzm+5txOrq/P23QUWGOZ2sB3fwF71AQeuUlh33h
         PhonfzggMAi5UqC+pQTvh0rHRFv9tTKniDoMZN4X6F1LsoFb4D7QUXMQmu4jUjJ9Mxi4
         R/pGz9AbJclqAjTvwaUa8Om9JCy5s5CHYTbkPW3YipnuwAvPuQRKa9IMRetqIfhp6TyV
         twTWGSi1ob5c7+bin0fd9qjOJxScN1LgrooHTSAzSqQPLtUDZzGZl08q4wf3xKVCmzCS
         +tX1U/uToXmi/6QZH6Iied5CnipWIT/q9lumasPSY1UPvic8WB3NT1DqmwirS3siz2f4
         GNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0phPAmXHZiY++ODa4LylUzpwFoY+97hggz//3Pk7dVg=;
        b=Ys7DmlZvHZoDqZ9va/F9V5JOXi0guyhC10vgtcWuV51gt+Y6LBcWFS3TCm+pVRAowZ
         ssd1BNi87BWbdUnYqZ3aTJ6ZoHFUeVphRFsqTxNa+H6URF6rbKNepSWDybWCrgJtoQtF
         3cnK49L/C4MIkGjLR9RL60fd6TDDJNbosLM5EH6Peq5XKYXVrbTDe+nMBghGKuAIGBZj
         36EwOa/w7jcFbaR+Pp/4TkdMf/axzSzZenpAp8GgkiaRy4xVzlLeC2/kHgjyujgCQC3C
         906uw4fpOXPLZF80DbhKINzwCEZ494GLqxxtxKVjij7SpD+GRbyAiW0umEpF4gQ4dKAk
         S8zg==
X-Gm-Message-State: APjAAAUHSk/a0AjPtjYuzs1xYOD9hxlWDDWkwI2y4Y0VNwCEaIA/RGDa
        8M4CDmbKaaCnA4ijvs2aAFGlov58EzaPYdQlnPU=
X-Google-Smtp-Source: APXvYqy3R36Fx3MlKxPFfrKmN7TMuJpkFylPBTd4x3BMJkVHQBXwgrgc4mLAbE6hHOryMY3Az9nMa3vf2aYwKRR/CAo=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr89616397qta.93.1561092170557;
 Thu, 20 Jun 2019 21:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190620230951.3155955-1-andriin@fb.com> <20190620230951.3155955-5-andriin@fb.com>
 <20190621000704.GC1383@mini-arch>
In-Reply-To: <20190621000704.GC1383@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:42:37 -0700
Message-ID: <CAEf4BzYGtBcTEhf8gB5okAr0YKZFs1i+R6WyCPvMHnm1zW1H7w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] libbpf: add tracepoint/raw tracepoint attach API
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 5:07 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/20, Andrii Nakryiko wrote:
> > Add APIs allowing to attach BPF program to kernel tracepoints. Raw
> > tracepoint attach API is also added for uniform per-BPF-program API,
> > but is mostly a wrapper around existing bpf_raw_tracepoint_open call.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 99 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  5 ++
> >  tools/lib/bpf/libbpf.map |  2 +
> >  3 files changed, 106 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 11329e05530e..cefe67ba160b 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4176,6 +4176,105 @@ int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> >       return pfd;
> >  }
> >
> > +static int determine_tracepoint_id(const char* tp_category, const char* tp_name)
> > +{
> > +     char file[PATH_MAX];
> > +     int ret;
> > +
> > +     ret = snprintf(file, sizeof(file),
> > +                    "/sys/kernel/debug/tracing/events/%s/%s/id",
> > +                    tp_category, tp_name);
> > +     if (ret < 0)
> > +             return -errno;
> > +     if (ret >= sizeof(file)) {
> > +             pr_debug("tracepoint %s/%s path is too long\n",
> > +                      tp_category, tp_name);
> > +             return -E2BIG;
> > +     }
> > +     return parse_uint_from_file(file);
> > +}
> > +
> > +static int perf_event_open_tracepoint(const char* tp_category,
> > +                                   const char* tp_name)
> > +{
> > +     struct perf_event_attr attr = {};
> > +     char errmsg[STRERR_BUFSIZE];
> > +     int tp_id, pfd, err;
> > +
> [..]
> > +     tp_id = determine_tracepoint_id(tp_category, tp_name);
> Why no assign to attr.config directly here?

It's used in few places for error-handling branch, so it would look a
bit weird and make lines longer.


> You can move all other constants to the initialization as well:
>
> struct perf_event_attr attr = {
>         .type = PERF_TYPE_TRACEPON,
>         .size = sizeof(struct perf_event_attr),
> };
>
> attr.config = determine_tracepoint_id(...);
>
> (I guess that's a matter of style, but something to consider).

Yeah. It seems like explicit initialization of each member of
attribute structs is prevalent in libbpf.c. I also don't want to have
some fields initialized at declaration site, and some other in code.
Better to group all initialization together.

>
> > +     if (tp_id < 0){
> > +             pr_warning("failed to determine tracepoint '%s/%s' perf ID: %s\n",
> > +                        tp_category, tp_name,
> > +                        libbpf_strerror_r(tp_id, errmsg, sizeof(errmsg)));
> > +             return tp_id;
> > +     }
> > +
> [..]
> > +     memset(&attr, 0, sizeof(attr));
> Not needed since you do attr = {}; above?

Yep, removed.

>
> > +     attr.type = PERF_TYPE_TRACEPOINT;
> > +     attr.size = sizeof(attr);
> > +     attr.config = tp_id;
> > +
> > +     pfd = syscall( __NR_perf_event_open, &attr, -1 /* pid */, 0 /* cpu */,
> > +                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > +     if (pfd < 0) {
> > +             err = -errno;
> > +             pr_warning("tracepoint '%s/%s' perf_event_open() failed: %s\n",
> > +                        tp_category, tp_name,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return err;
> > +     }
> > +     return pfd;
> > +}
> > +

<snip>
