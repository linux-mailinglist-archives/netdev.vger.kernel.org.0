Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34656465DAB
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 06:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhLBFNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 00:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhLBFNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 00:13:45 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585F1C061574;
        Wed,  1 Dec 2021 21:10:23 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id o4so26798849pfp.13;
        Wed, 01 Dec 2021 21:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nYhvOFpnD+nATcij6pHFj/RlZs5yXdc5UYRL9Bv7hdA=;
        b=igG5uKin/YSTcw0YoaxGhQ3fNMMy/FFFseT8g7XGwh6qtPPs+iMBMJHnn+l6dfDVsd
         VYbFQUj/92Da0DLd3/XJgpv5F3P2a341NZDME8GFl4+J+9OhL5pou0Dhx3iYoIG5UKfA
         XGpDYNdioRMGWm/RhuuyV+5SGoW9kFsDDlHirpZ6SjwveAK6nOX3lRKrKbWMhiSn0pBo
         vo5QWmn5H53+u9YLVsCv0m5NP89cqTrHhnQ8aDo6xqqGFmyecP5Rkn6WbOMhrfRLFfSW
         L1eDHRgQ8DzsHD7/uRS99ue+WtLW7KZgYUQjp5JOnBOgeVYLdBjRWc2+YBECiDfVqwQI
         ZsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nYhvOFpnD+nATcij6pHFj/RlZs5yXdc5UYRL9Bv7hdA=;
        b=dlDQvaYouBpzlQw3dEdm9e6vKfLUf2vRdBTmA1PZHZacIWYglkwvMSNdqgXjZTOTQQ
         CCTLmah91TW/5GZnuifdpIsKNW5J+ROCYtge76qpwKSmyM+DCh6QZCR3EHE7ncLj+yky
         LALSShweFEzEHPIqkVLbI2pZLjU0efkTRbyFkdMg5ZYGnYakHBoZcQVJaWvVDFxbjj8s
         z78iq3UYMySzZHbnuznxyByerxWYMlLObndZhIx9A2HdEGaYI71vdMBWnba0+BvMcUMq
         MwlJ1uoOtRbnHOW2dqtbKElGsdldc810yH78vZB0h+eupxsOyVQUVM1fYMjk/yG6iVzs
         m0mQ==
X-Gm-Message-State: AOAM530OidGc1g6IOfcQwr/zCMtlWMrh2KP5fXREdu74dH98MKfxKvke
        424GZfR0xL/bzLBn9MYqdJo+fD4vVqAfULs6uxloCUqdRWA=
X-Google-Smtp-Source: ABdhPJy3xHjQer45zHTeWlFMZJmSYmh1eCEl5lkNepg7G+3DkiIDapz3rtXABRbc8iCwVyYY5YGKLntUwHu6Q5Lx4CA=
X-Received: by 2002:a63:6881:: with SMTP id d123mr7798010pgc.497.1638421822722;
 Wed, 01 Dec 2021 21:10:22 -0800 (PST)
MIME-Version: 1.0
References: <20211124084119.260239-1-jolsa@kernel.org> <20211124084119.260239-2-jolsa@kernel.org>
 <CAEf4Bzb5wyW=62fr-BzQsuFL+mt5s=+jGcdxKwZK0+AW18uD_Q@mail.gmail.com> <Yafp193RdskXofbH@krava>
In-Reply-To: <Yafp193RdskXofbH@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Dec 2021 21:10:11 -0800
Message-ID: <CAADnVQK2vEjnZVasTKASG6AmeWyyEF8Q3bpRfWvuJJ6_qHnEig@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf/kprobe: Add support to create multiple probes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Dec 1, 2021 at 1:32 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Nov 30, 2021 at 10:53:58PM -0800, Andrii Nakryiko wrote:
> > On Wed, Nov 24, 2021 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding support to create multiple probes within single perf event.
> > > This way we can associate single bpf program with multiple kprobes,
> > > because bpf program gets associated with the perf event.
> > >
> > > The perf_event_attr is not extended, current fields for kprobe
> > > attachment are used for multi attachment.
> >
> > I'm a bit concerned with complicating perf_event_attr further to
> > support this multi-attach. For BPF, at least, we now have
> > bpf_perf_link and corresponding BPF_LINK_CREATE command in bpf()
> > syscall which allows much simpler and cleaner API to do this. Libbpf
> > will actually pick bpf_link-based attachment if kernel supports it. I
> > think we should better do bpf_link-based approach from the get go.
> >
> > Another thing I'd like you to keep in mind and think about is BPF
> > cookie. Currently kprobe/uprobe/tracepoint allow to associate
> > arbitrary user-provided u64 value which will be accessible from BPF
> > program with bpf_get_attach_cookie(). With multi-attach kprobes this
> > because extremely crucial feature to support, otherwise it's both
> > expensive, inconvenient and complicated to be able to distinguish
> > between different instances of the same multi-attach kprobe
> > invocation. So with that, what would be the interface to specify these
> > BPF cookies for this multi-attach kprobe, if we are going through
> > perf_event_attr. Probably picking yet another unused field and
> > union-izing it with a pointer. It will work, but makes the interface
> > even more overloaded. While for LINK_CREATE we can just add another
> > pointer to a u64[] with the same size as number of kfunc names and
> > offsets.
>
> I'm not sure we could bypass perf event easily.. perhaps introduce
> BPF_PROG_TYPE_RAW_KPROBE as we did for tracepoints or just new
> type for multi kprobe attachment like BPF_PROG_TYPE_MULTI_KPROBE
> that might be that way we'd have full control over the API

Indeed. The existing kprobe prog type has this api:
 * Return: BPF programs always return an integer which is interpreted by
 * kprobe handler as:
 * 0 - return from kprobe (event is filtered out)
 * 1 - store kprobe event into ring buffer

that part we cannot change.
No one was using that filtering feature. It often was in a way.
New MULTI_KPROBE prog type should not have it.
