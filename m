Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFCD464779
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347072AbhLAG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347043AbhLAG64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:58:56 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76BC061574;
        Tue, 30 Nov 2021 22:55:35 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id d10so27501753ybn.0;
        Tue, 30 Nov 2021 22:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODGiWTQjsUXsYV6BLYMhLS5+XJpaRd+uTjnO8c+76tU=;
        b=DvroZLxf73AdNDsf5bqPoN/OHoAuos8KZvoFsEs11StTcauIYvpqh9XJ/4Lbdf5qvf
         zwjkQVg8hk7V+fq4jMP0Ysxk7DnUCVVZB6TxVEPus1WPhDzXbU0fP0o1jjD97lj+1Nyy
         ozAfnnN8mHAd+/qtesCT+gdTlXaeYAosODsBInGh9QwZVEzsKreVAtmu49yzbM3fn3d3
         M5zGOKqQm7+LakQKi0vjP8Kmy/w2bXJfB4CRUli0uOGO4Eo84h+HA8WpXJyoA70m0ZO3
         X/m/hDIrD9jIDyLgUak97xN4oImkn/NReUGdlru3ZmYeurP/yYoK5vBL8cLMCOnxgaAp
         vp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODGiWTQjsUXsYV6BLYMhLS5+XJpaRd+uTjnO8c+76tU=;
        b=2Zo2ZcqTIy4eKPoApgp+VogkqaSI07BcW0jND6q2EM2/PL5n7P7G1hWUzsU9jFmlnd
         v78yB5KLii69gDzj4Sh0pG3phonXXFxi0O82rtXSioXPFnawd+EC/w3hZwXusVetNp/W
         hItXG5yNBtfgiHiZF1Zziw2tBqwTNmK/yNVVO0aq2yV7rV24mebYE8bNCBBFW+HIRZeR
         /XeNS8c+5t4JR0rqNBsKQvjMrpvX/5yacsOn9J9OC/FdVaf9mZaxQln8sl19eB4v/Me/
         6Y6RE7Dd5WBlNGYj/6fExroxkzZcp240l8tJpK5wp+MTum4/xz5rm7q+lA4CcRAPTqhq
         2zkw==
X-Gm-Message-State: AOAM530eQ2hLSpko/ery7D0UOsPeYjwk2wXj0TEQIQrzKVp2zwckxTLz
        WN9Zs8TNKR3ylHdEqungJVMQ7lN2ZSiohCKc8tE=
X-Google-Smtp-Source: ABdhPJx41RsYCtAjJhZAU7Q6tVDvHQ9fpCHFmCRhDIrSzR/w0D3V7kELw2dXLqbW8hUphat7z0BpKsRcGdbVRkPFXQs=
X-Received: by 2002:a25:84c1:: with SMTP id x1mr5336161ybm.690.1638341735081;
 Tue, 30 Nov 2021 22:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20211124084119.260239-1-jolsa@kernel.org> <20211124084119.260239-2-jolsa@kernel.org>
 <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com>
In-Reply-To: <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 22:55:24 -0800
Message-ID: <CAEf4BzaWkTXaVQ9nnrPc+8izE=XJuN0WBrizCAAivQbS1fzRxw@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 10:53 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 24, 2021 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding support to create multiple probes within single perf event.
> > This way we can associate single bpf program with multiple kprobes,
> > because bpf program gets associated with the perf event.
> >
> > The perf_event_attr is not extended, current fields for kprobe
> > attachment are used for multi attachment.
>
> I'm a bit concerned with complicating perf_event_attr further to
> support this multi-attach. For BPF, at least, we now have
> bpf_perf_link and corresponding BPF_LINK_CREATE command in bpf()
> syscall which allows much simpler and cleaner API to do this. Libbpf
> will actually pick bpf_link-based attachment if kernel supports it. I
> think we should better do bpf_link-based approach from the get go.
>
> Another thing I'd like you to keep in mind and think about is BPF
> cookie. Currently kprobe/uprobe/tracepoint allow to associate
> arbitrary user-provided u64 value which will be accessible from BPF
> program with bpf_get_attach_cookie(). With multi-attach kprobes this
> because extremely crucial feature to support, otherwise it's both
> expensive, inconvenient and complicated to be able to distinguish
> between different instances of the same multi-attach kprobe
> invocation. So with that, what would be the interface to specify these
> BPF cookies for this multi-attach kprobe, if we are going through
> perf_event_attr. Probably picking yet another unused field and
> union-izing it with a pointer. It will work, but makes the interface
> even more overloaded. While for LINK_CREATE we can just add another
> pointer to a u64[] with the same size as number of kfunc names and
> offsets.

Oh, and to be clear, I'm not proposing to bypass underlying perf
infra. Rather use it directly as an internal API, not through
perf_event_open syscall.

>
> But other than that, I'm super happy that you are working on these
> complicated multi-attach capabilities! It would be great to benchmark
> one-by-one attachment vs multi-attach to the same set of kprobes once
> you arrive at the final implementation.
>
> >
> > For current kprobe atachment we use either:
> >
> >    kprobe_func (in config1) + probe_offset (in config2)
> >
> > to define kprobe by function name with offset, or:
> >
> >    kprobe_addr (in config2)
> >
> > to define kprobe with direct address value.
> >
> > For multi probe attach the same fields point to array of values
> > with the same semantic. Each probe is defined as set of values
> > with the same array index (idx) as:
> >
> >    kprobe_func[idx]  + probe_offset[idx]
> >
> > to define kprobe by function name with offset, or:
> >
> >    kprobe_addr[idx]
> >
> > to define kprobe with direct address value.
> >
> > The number of probes is passed in probe_cnt value, which shares
> > the union with wakeup_events/wakeup_watermark values which are
> > not used for kprobes.
> >
> > Since [1] it's possible to stack multiple probes events under
> > one head event. Using the same code to allow that for probes
> > defined under perf kprobe interface.
> >
> > [1] https://lore.kernel.org/lkml/156095682948.28024.14190188071338900568.stgit@devnote2/
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/perf_event.h |   1 +
> >  kernel/trace/trace_event_perf.c | 106 ++++++++++++++++++++++++++++----
> >  kernel/trace/trace_kprobe.c     |  47 ++++++++++++--
> >  kernel/trace/trace_probe.c      |   2 +-
> >  kernel/trace/trace_probe.h      |   3 +-
> >  5 files changed, 138 insertions(+), 21 deletions(-)
> >
>
> [...]
