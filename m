Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820DF15AFEB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgBLSeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:34:17 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35645 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgBLSeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:34:17 -0500
Received: by mail-qt1-f196.google.com with SMTP id n17so2372301qtv.2;
        Wed, 12 Feb 2020 10:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppTbYAeaRi4HGHzhBmSL5qenb20hzXZyJTAfyENo4g8=;
        b=pvlyIrckBUMPUw/Cqnkp2AW9P2wf4AWlzS394dVdzdW+LLn6adQvwbydmd5/M1N/Pe
         SO06nil4ZZ0GwBDu4ZjEZgga2yTL0h4dXrN/yuOq76KuCdJAeKjFtM8n88qbZNSCw4bU
         axqBibsv25HSJUvupQJzgO3aObBHmvhABsHiQ5B6nP7MK9NzdQYGXr9MjGYe2px80CNp
         S3Tr2ZQaO0obhN6iuyKZzhOnkeCch15Tv798wF4frlIi63Z4Vm8SyAa1SRqWyy0AX3wB
         SrENrYGdGDU39agKUxJ0BcmA/te/cliAWc63z4GHxmaaLZYMZyD6VTVBNhtJH9kUfXtM
         Rl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppTbYAeaRi4HGHzhBmSL5qenb20hzXZyJTAfyENo4g8=;
        b=tFZpFx5Oe4/Nga73J6EFYg7AxWVqTtqzjN2T+RI057QdwuUuGTO1NMDbr80VZUksUm
         8wQWMg/HCVjbGS1xgv/nDZ0NbvFIOtv9787TcJxcevoni6ygS9Ny7f5odqga9VmbcJPQ
         hAuVqmdHRBO/HFuJ3AeGdctx3DmTOZwtMRaUg0ALHplEZphqHXItYLTEDdJw1/TG1yTG
         IiTvo2+3n1giDnZygsLXeUDN8Bw+fN2n9urXXD1Oy/7jcNUy5BYd4BGmgYzqZaCo4qE/
         WtFePxXgJWa6K53c2Ub4AGcmxcPSw3VbhhjeR6kEwr5zQzUZonfin7Ezxwy7bYdfg3z6
         MUVw==
X-Gm-Message-State: APjAAAXODOVYezOQpi2cMN1L9Gj2nRPntMEHxdWgkWxOCYw6UYUCLTSE
        qkbAqC7p4Wr60j8J1E3trRbbKPvnolHxgNlMyO4=
X-Google-Smtp-Source: APXvYqyMHxVMsuFzPJHoZsG0/eBu2ac0kWDkUOzw+k1JcOqiJ438wccP7vWaG51b8/4N2KPNvIo7KApVnXOGLm3PY2E=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr20537207qtj.117.1581532456325;
 Wed, 12 Feb 2020 10:34:16 -0800 (PST)
MIME-Version: 1.0
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
 <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com> <CAEf4BzYFVtgW4Zyz09vuppAJA3oQ-UAT4yALeFJk2JQ70+mE2g@mail.gmail.com>
 <F37F13F4-DAFE-4431-804F-BF7940D9970D@fb.com>
In-Reply-To: <F37F13F4-DAFE-4431-804F-BF7940D9970D@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Feb 2020 10:34:05 -0800
Message-ID: <CAEf4Bza4MQW6QEg7_VdWJwMJPKP8nPSD-ErkUFhVtxyA=jLkHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
To:     Song Liu <songliubraving@fb.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:29 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Feb 12, 2020, at 10:14 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Feb 12, 2020 at 10:07 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Feb 12, 2020, at 9:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> wrote:
> >>>>
> >>>> Currently when you want to attach a trace program to a bpf program
> >>>> the section name needs to match the tracepoint/function semantics.
> >>>>
> >>>> However the addition of the bpf_program__set_attach_target() API
> >>>> allows you to specify the tracepoint/function dynamically.
> >>>>
> >>>> The call flow would look something like this:
> >>>>
> >>>> xdp_fd = bpf_prog_get_fd_by_id(id);
> >>>> trace_obj = bpf_object__open_file("func.o", NULL);
> >>>> prog = bpf_object__find_program_by_title(trace_obj,
> >>>>                                          "fentry/myfunc");
> >>>> bpf_program__set_attach_target(prog, xdp_fd,
> >>>>                                "fentry/xdpfilt_blk_all");
> >>>> bpf_object__load(trace_obj)
> >>>>
> >>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >>
> >>
> >> I am trying to solve the same problem with slightly different approach.
> >>
> >> It works as the following (with skeleton):
> >>
> >>        obj = myobject_bpf__open_opts(&opts);
> >>        bpf_object__for_each_program(prog, obj->obj)
> >>                bpf_program__overwrite_section_name(prog, new_names[id++]);
> >>        err = myobject_bpf__load(obj);
> >>
> >> I don't have very strong preference. But I think my approach is simpler?
> >
> > I prefer bpf_program__set_attach_target() approach. Section name is a
> > program identifier and a *hint* for libbpf to determine program type,
> > attach type, and whatever else makes sense. But there still should be
> > an API to set all that manually at runtime, thus
> > bpf_program__set_attach_target(). Doing same by overriding section
> > name feels like a hack, plus it doesn't handle overriding
> > attach_program_fd at all.
>
> We already have bpf_object_open_opts to handle different attach_program_fd.

Not really, because open_opts apply to bpf_object and all its
bpf_programs, not to individual bpf_program. So it works only if BPF
application has only one BPF program. If you have many, you can only
set the same attach_program_fd for all of them. Basically, open_opts'
attach_prog_fd should be treated as a default or fallback
attach_prog_fd.

> Can we depreciate bpf_object_open_opts.attach_prog_fd with the
> bpf_program__set_attach_target() approach?

bpf_program__set_attach_target() overrides attach_prog_fd, yes. But we
can't just deprecate that option because it's part of an API already,
even though adding it to open opts was probably a mistake. But for
simple BPF apps with single BPF program it does work fine, so...

>
> Thanks,
> Song
>
