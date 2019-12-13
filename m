Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCC711E8C7
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 17:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfLMQwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 11:52:01 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34418 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfLMQwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 11:52:00 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so1446186pjs.1;
        Fri, 13 Dec 2019 08:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qa1TSlB/YkLKGBzwqwvAAOSrVtrFdm5VNkLtw6aCthM=;
        b=VmHh92t253uE8/jq/rUvxTevFPhYGFqrehEu5mrF+UuGZWF1bJNmdhtB3bzrsAdqcA
         C5re+1+nqHXEfKTo7ZEttA4EjztT02D1cgMnniUnk0GZtOsazei96utNGioF0abC8qIA
         sI6ozLVzlSrjyx9lHT6nXBlI+5p2vehNvtybyTDVwip716zCH08ALtsymJ9gcAfZJiu+
         qe4eYb+GYPPXOh1kGOBiPIMnYFyTcoxUg9QXrkObPh2Yx83ZhTqegX09vaAKGfoqPqpC
         gGG2IhRZjLibNxHcU6tB+0hJgrEaZqdXZS09Eh0dBUsmEzVJjcTX0T5e3zHKEFY4O6I+
         MtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qa1TSlB/YkLKGBzwqwvAAOSrVtrFdm5VNkLtw6aCthM=;
        b=Wkxj9JUZlBbuFdEyOpHu/hwkGKb3v4ezAA6Azd/ecH4WXWybSjF0/Q9meddedH/R8H
         caLbLmp1wnIYpO12oyPeY8RrSnFwjRTSSWTiWqEgFiRcXl5koozdkg9tmZHXjuMSqSfx
         JKHmx7ZTg4hQddMttDlQZNogtoIAz2uCV8TU062BbPcvZyofxWyoosYzEM+/j3WSXWge
         POqCCEcINJrC/xC26NiVbxOa38pcjQxOU68ZG3SALYsvfRdpciuJ7lubv6500bGq86wz
         rc1FMZ0AhtoJqYu5XK3b4qTba2WUGtBSKfGP/IM04HfhLRoX3mxDd3GtDQyl0JjKXExP
         9DFg==
X-Gm-Message-State: APjAAAXPTCl/q8Gbr1h3CUJIdePno8rRZL+lp1VKmOGs5jEk8DInCA7F
        1a0lCouvHxD4+EaoL/9uhJA=
X-Google-Smtp-Source: APXvYqzY1Mjm7H6x1eBBxvX0UDJNwm0Lxe4yTUlBGBpwM2Qy6zcWxbWponVPWrG8iXzUTO3AzGlpIg==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr288784pjy.107.1576255919702;
        Fri, 13 Dec 2019 08:51:59 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::de66])
        by smtp.gmail.com with ESMTPSA id m45sm10052854pje.32.2019.12.13.08.51.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 08:51:58 -0800 (PST)
Date:   Fri, 13 Dec 2019 08:51:57 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213165155.vimm27wo7brkh3yu@ast-mbp.dhcp.thefacebook.com>
References: <20191213153553.GE20583@krava>
 <20191213112438.773dff35@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213112438.773dff35@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 11:25:00AM -0500, Steven Rostedt wrote:
> On Fri, 13 Dec 2019 16:35:53 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > I don't think dedup algorithm can handle this and I'm not sure if there's
> > some way in pahole to detect/prevent this.
> > 
> > I only found that if I rename the ring_buffer objects to have distinct
> > names, it will help:
> > 
> >   $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep task_struct
> >   [150] STRUCT 'task_struct' size=11008 vlen=205
> > 
> >   $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep "STRUCT 'perf_event'"
> >   [1665] STRUCT 'perf_event' size=1160 vlen=70
> > 
> > also the BTF data get smaller ;-) before:
> > 
> >   $ ll /sys/kernel/btf/vmlinux
> >   -r--r--r--. 1 root root 2067432 Dec 13 22:56 /sys/kernel/btf/vmlinux
> > 
> > after:
> >   $ ll /sys/kernel/btf/vmlinux
> >   -r--r--r--. 1 root root 1984345 Dec 13 23:02 /sys/kernel/btf/vmlinux
> > 
> > 
> > Peter, Steven,
> > if above is correct and there's no other better solution, would it be possible
> > to straighten up the namespace and user some distinct names for perf and ftrace
> > ring buffers?
> 
> Now, the ring buffer that ftrace uses is not specific for ftrace or
> even tracing for that matter. It is a stand alone ring buffer (oprofile
> uses it), and can be used by anyone else.
> 
> As the perf ring buffer is very coupled with perf (or perf events), and
> unless something changed, I was never able to pull the perf ring
> buffer out as a stand alone ring buffer.
> 
> As the ring buffer in the tracing directory is more generic, and not to
> mention around longer, if one is to change the name, I would suggest it
> be the perf ring buffer.

Thanks Jiri to bring it up.
Technically the kernel is written in valid C, but it's imo the case where C
standard isn't doing that great.

To rephrase what Jiri said...
If include/linux/perf_event.h instead of saying 'struct ring_buffer;'
would have done #include <kernel/events/internal.h>
the kernel/trace/ring_buffer.c would have had build error.
Even now sizeof(*perf_event->rb) would return different values depending
whether it's used in kernel/trace/ring_buffer.c or anywhere in kernel/events/.
dwarf/btf and gcc cannot deal with it nicely. It's a valid C.

'gdb vmlinux' for sizeof(struct ring_buffer) will pick perf ring buffer.
It had two choices. Both valid. I don't know why gdb picked this one.
So yeah I think renaming 'ring_buffer' either in ftrace or in perf would be
good. I think renaming ftrace one would be better, since gdb picked perf one
for whatever reason.

