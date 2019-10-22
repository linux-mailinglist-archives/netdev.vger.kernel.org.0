Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B04DFCF8
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 07:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbfJVFIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 01:08:10 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43041 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJVFIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 01:08:10 -0400
Received: by mail-il1-f196.google.com with SMTP id t5so14196583ilh.10;
        Mon, 21 Oct 2019 22:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=52b3tWAnG7HQZrTutbvURPwKuRo+pGYx/Wk2X/DQqSY=;
        b=Fj5lbiKW1YS3E69FeauD0Qn/oI0pzCVHUy+ucvPH6oncnBcNTK8ySQX2rpUlRox2zp
         HHOSXiOKAlEmQInxbL8d6FZ5LOo9JWK476HUUF2gp7B9FV/qwzyX4cWp6yfWchgp+cox
         UCWvbErzm5DGIpvskYfLD59MftxygQGIbhRqlg1V74NMwRbgSngVOEQJwM+7iGkyJuLk
         QB6IT0XmkFh0wfGf/59eqCE9O5/gEo0J4muVKMPv9OcFwJAqcWGKYVHiraJ9mgaOyU+C
         PGqegGiFdUO5YdilCICQNPpKQm/+R5J42aDVev9jn7ztJnMqWtM50nAH4CL1vUbJ7H4k
         CYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=52b3tWAnG7HQZrTutbvURPwKuRo+pGYx/Wk2X/DQqSY=;
        b=FzLiEF6MKXPCwgL3g2dF0CBRhURmW+JAKfSpqi0L3xb+HanR/yBOvP03IdnWNHzlb/
         vATumgAgcDsCgjXLCF1q4eRNFlAuIzeipjjDc7x++BNIN/3UrC5/FSoWVJCu+mpCu5r+
         COa7ohPKKRoaEj66HdpoAEDRzCZ8U3v8AX6VYgEowyYruq2URSBuptORG0BZKxsXs+AY
         QitJiM/3i8iSl7WU0c5dj9OURBAz/zXKX72wpLDG8KL0jDv0hYMk9ZksR02fUDf4ebjy
         9Duwy23JTMLa1PMTFw/cttXdqoaHWtZKQwB4c5HT4IRTnq4IJ9pDF8b7PAw/C9t/MwgR
         25GQ==
X-Gm-Message-State: APjAAAVuyG5TeeUMsSpN9zgzh0PfjGFT18Gz//zhl19LZL8HU/qsxdjr
        yeuvvDnE4wDMJVX8+4ea7tuqzV12Khs=
X-Google-Smtp-Source: APXvYqzhADfLKqfKAtuOxIXy9I/GZqmEflDsjk3Di/Q2qEp1DhcnPuFjj1t05aoL+Ky01ST+IOiu5w==
X-Received: by 2002:a92:8dd9:: with SMTP id w86mr28782910ill.93.1571720889151;
        Mon, 21 Oct 2019 22:08:09 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d21sm5173310iom.29.2019.10.21.22.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 22:08:08 -0700 (PDT)
Date:   Mon, 21 Oct 2019 22:07:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > kprobes programs on older kernels.
> >
> 
> My main concern with this is that this code is born bit-rotten,
> because selftests are never testing the legacy code path. How did you
> think about testing this and ensuring that this keeps working going
> forward?
> 

Well we use it, but I see your point and actually I even broke the retprobe
piece hastily fixing merge conflicts in this patch. When I ran tests on it
I missed running retprobe tests on the set of kernels that would hit that
code.

> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 73 insertions(+), 8 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index fcea6988f962..12b3105d112c 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
> >         return parse_uint_from_file(file, "config:%d\n");
> >  }
> >
> > +static int use_kprobe_debugfs(const char *name,
> > +                             uint64_t offset, int pid, bool retprobe)
> > +{
> > +       const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> > +       int fd = open(file, O_WRONLY | O_APPEND, 0);
> > +       char buf[PATH_MAX];
> > +       int err;
> > +
> > +       if (fd < 0) {
> > +               pr_warning("failed open kprobe_events: %s\n",
> > +                          strerror(errno));
> > +               return -errno;
> 
> errno after pr_warning() call might be clobbered, you need to save it
> locally first

Seems so thanks.

> 
> > +       }
> > +
> > +       snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
> > +                retprobe ? 'r' : 'p', name, name);
> 
> remember result, check it to detect overflow, and use it in write below?

sure seems more robust. If someone has names longer than PATH_MAX though
it seems a bit much.

> 
> > +
> > +       err = write(fd, buf, strlen(buf));
> > +       close(fd);
> > +       if (err < 0)
> > +               return -errno;
> > +       return 0;
> > +}
> > +
> >  static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >                                  uint64_t offset, int pid)
> >  {
> >         struct perf_event_attr attr = {};
> >         char errmsg[STRERR_BUFSIZE];
> > +       uint64_t config1 = 0;
> >         int type, pfd, err;
> >
> >         type = uprobe ? determine_uprobe_perf_type()
> >                       : determine_kprobe_perf_type();
> >         if (type < 0) {
> > -               pr_warning("failed to determine %s perf type: %s\n",
> > -                          uprobe ? "uprobe" : "kprobe",
> > -                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > -               return type;
> > +               if (uprobe) {
> > +                       pr_warning("failed to determine uprobe perf type %s: %s\n",
> > +                                  name,
> > +                                  libbpf_strerror_r(type,
> > +                                                    errmsg, sizeof(errmsg)));
> > +               } else {
> 
> I think this legacy kprobe setup deserves its own function (maybe even
> combine it with use_kprobe_debugfs to do entire attribute setup from A
> to Z?)
> 
> These 2 levels of nestedness is also unfortunate, how about having two
> functions that are filling out perf_event_attr? Something like:
> 
> err = determine_perf_probe_attr(...)
> if (err)
>     err = determine_legacy_probe_attr(...)
> if (!err)
>     <bail out>
> do perf call here
> 

Perhaps it makes sense to even uplevel this into the API? Something like
bpf_program__attach_legacy_kprobe() then we could test it easer?

> 
> > +                       /* If we do not have an event_source/../kprobes then we
> > +                        * can try to use kprobe-base event tracing, for details
> > +                        * see ./Documentation/trace/kprobetrace.rst
> > +                        */
> > +                       const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
> > +                       char c[PATH_MAX];
> 
> what does c stand for?

Can name it file and push the path into snprintf() below.

> 
> > +                       int fd, n;
> > +
> > +                       snprintf(c, sizeof(c), "%s/%s/id", file, name);
> 
> check result? also, is there a reason to not use
> "/sys/kernel/debug/tracing/events/kprobes/" directly in format string?
> 

I believe when I wrote that I just like the it as a const char better.
But no reason if you like it inline better.

> > +
> > +                       err = use_kprobe_debugfs(name, offset, pid, retprobe);
> > +                       if (err)
> > +                               return err;
> > +
> > +                       type = PERF_TYPE_TRACEPOINT;
> > +                       fd = open(c, O_RDONLY, 0);
> > +                       if (fd < 0) {
> > +                               pr_warning("failed to open tracepoint %s: %s\n",
> > +                                          c, strerror(errno));
> > +                               return -errno;
> > +                       }
> > +                       n = read(fd, c, sizeof(c));
> > +                       close(fd);
> > +                       if (n < 0) {
> > +                               pr_warning("failed to read %s: %s\n",
> > +                                          c, strerror(errno));
> 
> It's a bit fishy that you are reading into c and then print out c on
> error. Its contents might be corrupted at this point.
> 
> And same thing about errno as above.

Sure just didn't see much point in using yet another buffer. We can
just make the pr_warning general enough that the buffer isn't needed.

> 
> > +                               return -errno;
> > +                       }
> > +                       c[n] = '\0';
> > +                       config1 = strtol(c, NULL, 0);
> 
> no need for config1 variable, just attr.config = strtol(...)?

yes, fallout from some code churn. But no reason for it.

> 
> > +                       attr.size = sizeof(attr);
> > +                       attr.type = type;
> > +                       attr.config = config1;
> > +                       attr.sample_period = 1;
> > +                       attr.wakeup_events = 1;
> > +               }
> > +       } else {
> > +               config1 = ptr_to_u64(name);
> 
> same, just straight attr.config1 = ... ?

yes.

> 
> > +               attr.size = sizeof(attr);
> > +               attr.type = type;
> > +               attr.config1 = config1; /* kprobe_func or uprobe_path */
> > +               attr.config2 = offset;  /* kprobe_addr or probe_offset */
> >         }
> >         if (retprobe) {
> >                 int bit = uprobe ? determine_uprobe_retprobe_bit()
> > @@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >                 }
> >                 attr.config |= 1 << bit;
> >         }
> > -       attr.size = sizeof(attr);
> > -       attr.type = type;
> > -       attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
> > -       attr.config2 = offset;           /* kprobe_addr or probe_offset */
> >
> >         /* pid filter is meaningful only for uprobes */
> >         pfd = syscall(__NR_perf_event_open, &attr,
> >
> 
> What about the detaching? Would closing perf event FD be enough?
> Wouldn't we need to clear a probe with -:<event>?

It seems to be enough to close the fd. From an API standpoint might
make sense to have a detach() though if adding an attach().
