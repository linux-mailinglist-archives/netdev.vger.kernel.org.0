Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0471CDFC11
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfJVC50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 22:57:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46630 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730304AbfJVC50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 22:57:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id u22so24523898qtq.13;
        Mon, 21 Oct 2019 19:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PuGGrq0XMF+yPedewYeBXtdITakCb8nnz/W9nccug/M=;
        b=tqERiE3EuL/7yrFyz5TccnhPVXSgSe81MO84+nfiqL7rijNcrLCSJbwbFsMgJ3Ct8Z
         6rt+PzSKfMX1lp/rZHmmS5WW1DBFv9q1I3S6aWFhm+9raRAAZyF7BM0+B6rj/loGXo+h
         n51V0sZKSkI+ObeullSsnuTh8onPx7kcr7RarDd7ZH3EVAR8UHyL7+Xhvg9zw71AbqDA
         0p/Wa937fJVWAyOrhDEd3bcmL0ED3BVzz9qdZkdjXYxdhRDxDxa1Htii81hpRXSP7vI+
         yW7kSdC+npnLeRu1txzX2CrfU055QtmF8gUpQzvHY3mva3wjOArPnOTnHk4DY7bYbQPS
         8oXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuGGrq0XMF+yPedewYeBXtdITakCb8nnz/W9nccug/M=;
        b=pw14jep84tl+B3Nlqua+ExDR4IzEiAq+0rKeZiCXDvLzIkrXmnYgpCiNBFdnYDNnX/
         Qsu5Xfq08Gl4PIg1wZayz1hrd2F1bWaKy4F5N47qVKWD01xyH66z70fHjFxHtAlTGFnO
         CA8OojD4rjLbBX7TdP7zOg+Xk/BU2Zq27O7J+oc5cuCfb8xpWfafqRVNi0tPvVRPruks
         bKxv6KqNc+X/o7S/QPfoCdwdnScmIwtByqQo2nBTkPVeMmySqqp3leOmK62ahXLsdw3v
         s/8bcbhVvJOnwxUOFohrSD/TqpA3rSoCqQGfM14NZ4QcyTQ7NHplFD5cK0Wh1D7yisVo
         fbZA==
X-Gm-Message-State: APjAAAUw9KrSv2jkOpYa2/GKhrxFQA6HWFEHA/wa9jwC8Jx6PW8qjYhu
        YxMtYIuFeVTMNfQOiYLCQVOpCnsTOtUmukWilzE=
X-Google-Smtp-Source: APXvYqy1BbwjK0wbd/XPEOk8D9LPZmvzMzgLyzPE4iXXMxugQJBUzGpAt7tS5hL5qVSnPBlcyTYC5+j86lIVi7UQqIs=
X-Received: by 2002:a0c:fde4:: with SMTP id m4mr963235qvu.163.1571713044519;
 Mon, 21 Oct 2019 19:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
In-Reply-To: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Oct 2019 19:57:13 -0700
Message-ID: <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Following ./Documentation/trace/kprobetrace.rst add support for loading
> kprobes programs on older kernels.
>

My main concern with this is that this code is born bit-rotten,
because selftests are never testing the legacy code path. How did you
think about testing this and ensuring that this keeps working going
forward?

> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 73 insertions(+), 8 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fcea6988f962..12b3105d112c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
>         return parse_uint_from_file(file, "config:%d\n");
>  }
>
> +static int use_kprobe_debugfs(const char *name,
> +                             uint64_t offset, int pid, bool retprobe)
> +{
> +       const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +       int fd = open(file, O_WRONLY | O_APPEND, 0);
> +       char buf[PATH_MAX];
> +       int err;
> +
> +       if (fd < 0) {
> +               pr_warning("failed open kprobe_events: %s\n",
> +                          strerror(errno));
> +               return -errno;

errno after pr_warning() call might be clobbered, you need to save it
locally first

> +       }
> +
> +       snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
> +                retprobe ? 'r' : 'p', name, name);

remember result, check it to detect overflow, and use it in write below?

> +
> +       err = write(fd, buf, strlen(buf));
> +       close(fd);
> +       if (err < 0)
> +               return -errno;
> +       return 0;
> +}
> +
>  static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>                                  uint64_t offset, int pid)
>  {
>         struct perf_event_attr attr = {};
>         char errmsg[STRERR_BUFSIZE];
> +       uint64_t config1 = 0;
>         int type, pfd, err;
>
>         type = uprobe ? determine_uprobe_perf_type()
>                       : determine_kprobe_perf_type();
>         if (type < 0) {
> -               pr_warning("failed to determine %s perf type: %s\n",
> -                          uprobe ? "uprobe" : "kprobe",
> -                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> -               return type;
> +               if (uprobe) {
> +                       pr_warning("failed to determine uprobe perf type %s: %s\n",
> +                                  name,
> +                                  libbpf_strerror_r(type,
> +                                                    errmsg, sizeof(errmsg)));
> +               } else {

I think this legacy kprobe setup deserves its own function (maybe even
combine it with use_kprobe_debugfs to do entire attribute setup from A
to Z?)

These 2 levels of nestedness is also unfortunate, how about having two
functions that are filling out perf_event_attr? Something like:

err = determine_perf_probe_attr(...)
if (err)
    err = determine_legacy_probe_attr(...)
if (!err)
    <bail out>
do perf call here


> +                       /* If we do not have an event_source/../kprobes then we
> +                        * can try to use kprobe-base event tracing, for details
> +                        * see ./Documentation/trace/kprobetrace.rst
> +                        */
> +                       const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
> +                       char c[PATH_MAX];

what does c stand for?

> +                       int fd, n;
> +
> +                       snprintf(c, sizeof(c), "%s/%s/id", file, name);

check result? also, is there a reason to not use
"/sys/kernel/debug/tracing/events/kprobes/" directly in format string?

> +
> +                       err = use_kprobe_debugfs(name, offset, pid, retprobe);
> +                       if (err)
> +                               return err;
> +
> +                       type = PERF_TYPE_TRACEPOINT;
> +                       fd = open(c, O_RDONLY, 0);
> +                       if (fd < 0) {
> +                               pr_warning("failed to open tracepoint %s: %s\n",
> +                                          c, strerror(errno));
> +                               return -errno;
> +                       }
> +                       n = read(fd, c, sizeof(c));
> +                       close(fd);
> +                       if (n < 0) {
> +                               pr_warning("failed to read %s: %s\n",
> +                                          c, strerror(errno));

It's a bit fishy that you are reading into c and then print out c on
error. Its contents might be corrupted at this point.

And same thing about errno as above.

> +                               return -errno;
> +                       }
> +                       c[n] = '\0';
> +                       config1 = strtol(c, NULL, 0);

no need for config1 variable, just attr.config = strtol(...)?

> +                       attr.size = sizeof(attr);
> +                       attr.type = type;
> +                       attr.config = config1;
> +                       attr.sample_period = 1;
> +                       attr.wakeup_events = 1;
> +               }
> +       } else {
> +               config1 = ptr_to_u64(name);

same, just straight attr.config1 = ... ?

> +               attr.size = sizeof(attr);
> +               attr.type = type;
> +               attr.config1 = config1; /* kprobe_func or uprobe_path */
> +               attr.config2 = offset;  /* kprobe_addr or probe_offset */
>         }
>         if (retprobe) {
>                 int bit = uprobe ? determine_uprobe_retprobe_bit()
> @@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
>                 }
>                 attr.config |= 1 << bit;
>         }
> -       attr.size = sizeof(attr);
> -       attr.type = type;
> -       attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
> -       attr.config2 = offset;           /* kprobe_addr or probe_offset */
>
>         /* pid filter is meaningful only for uprobes */
>         pfd = syscall(__NR_perf_event_open, &attr,
>

What about the detaching? Would closing perf event FD be enough?
Wouldn't we need to clear a probe with -:<event>?
