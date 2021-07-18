Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C963CCA69
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhGRTfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhGRTfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:35:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626636728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CyZcIVod7cdW84KhhpNZDvdJDIPNl5OvVdbjX4Ic2xE=;
        b=fCpw1EkEDhQpA41cUKMDfEMwo0nqRjGaNX4Q6Gqz1vxYQfE/R62Q/CLrV7mxc1VAh8uVxE
        KLj8PNGfRSGAo0hSyr2ExbZFohOzuL88CzpNQqLHv7c676UfWBUe0U5JJK2TxOr1bxz2f4
        jZA0wMZuU0UaPc1CYRVkUn5Fs0YQ70M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-K7CJEnwRO9SVFALsCULg1Q-1; Sun, 18 Jul 2021 15:32:06 -0400
X-MC-Unique: K7CJEnwRO9SVFALsCULg1Q-1
Received: by mail-ed1-f69.google.com with SMTP id x16-20020aa7d6d00000b02903a2e0d2acb7so8004047edr.16
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 12:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CyZcIVod7cdW84KhhpNZDvdJDIPNl5OvVdbjX4Ic2xE=;
        b=kAjco4g7N5fVhjs6HTw0KSTUKf44HYS1UwOZhqVsaclVfX1NF0cDW81CPg9UDHfH27
         QTWcmqvPFyJufLZ1/ylNqq2YhhXjxXV+y6BJcdEwMUYMZa4pqA45CMuRYz84QBULDyI4
         gpuoSIA1N8gjl2jKQYMb96S7GJsias+oWxjOHd5/Hvzyx+Mo6b5B9khF/3D+2WOhOppL
         vv9OzEQ1j5veTZoxH2P9jRqBLXaMR6EQSB5FxdaotaLLyx6gGQL0Ghaf024LG3wGBaEX
         /DReMeeS0UjcEvCHSaqWqErtqt77iU/pRlfNQfvSt30U+d5HN1Atpn4zYey7VbhNBUUf
         DhMQ==
X-Gm-Message-State: AOAM533przi1WXNXu9we7VJJOU9ZrNdhG3AA0m2FlKW4O2Oh0IHCvo1l
        T87rC58jZMSWV2a8PIDp/0PT5xhXodS6VKvfAmAN+U2gW8rsNhBfkI/Oej12CZCIiare70FB6/L
        R/2nOv3C23x1GuHqg
X-Received: by 2002:a05:6402:18de:: with SMTP id x30mr30561738edy.351.1626636725871;
        Sun, 18 Jul 2021 12:32:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNpOXTpk0iHmNrW3fnPsuuHKTIXu+GevSMOyP+swg3XWPwhH1nhXLCAVgX3iaLMdTR8YI34w==
X-Received: by 2002:a05:6402:18de:: with SMTP id x30mr30561715edy.351.1626636725731;
        Sun, 18 Jul 2021 12:32:05 -0700 (PDT)
Received: from krava ([83.240.60.59])
        by smtp.gmail.com with ESMTPSA id w24sm6769141edv.59.2021.07.18.12.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 12:32:05 -0700 (PDT)
Date:   Sun, 18 Jul 2021 21:32:03 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv4 bpf-next 6/8] libbpf: Add
 bpf_program__attach_kprobe_opts function
Message-ID: <YPSBs51JR5cWVuc1@krava>
References: <20210714094400.396467-1-jolsa@kernel.org>
 <20210714094400.396467-7-jolsa@kernel.org>
 <CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbk-nyenpc86jtEShset_ZSkapvpy3fG2gYKZEOY7uAQg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 06:41:59PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 14, 2021 at 2:45 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding bpf_program__attach_kprobe_opts that does the same
> > as bpf_program__attach_kprobe, but takes opts argument.
> >
> > Currently opts struct holds just retprobe bool, but we will
> > add new field in following patch.
> >
> > The function is not exported, so there's no need to add
> > size to the struct bpf_program_attach_kprobe_opts for now.
> 
> Why not exported? Please use a proper _opts struct just like others
> (e.g., bpf_object_open_opts) and add is as a public API, it's a useful
> addition. We are going to have a similar structure for attach_uprobe,
> btw. Please send a follow up patch.

there's no outside user.. ok

> 
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 34 +++++++++++++++++++++++++---------
> >  1 file changed, 25 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 88b99401040c..d93a6f9408d1 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -10346,19 +10346,24 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> >         return pfd;
> >  }
> >
> > -struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> > -                                           bool retprobe,
> > -                                           const char *func_name)
> > +struct bpf_program_attach_kprobe_opts {
> 
> when you make it part of libbpf API, let's call it something shorter,
> like bpf_kprobe_opts, maybe? And later we'll have bpf_uprobe_opts for
> uprobes. Short and unambiguous.

ok

jirka

> 
> > +       bool retprobe;
> > +};
> > +
> > +static struct bpf_link*
> > +bpf_program__attach_kprobe_opts(struct bpf_program *prog,
> > +                               const char *func_name,
> > +                               struct bpf_program_attach_kprobe_opts *opts)
> >  {
> >         char errmsg[STRERR_BUFSIZE];
> >         struct bpf_link *link;
> >         int pfd, err;
> >
> 
> [...]
> 

