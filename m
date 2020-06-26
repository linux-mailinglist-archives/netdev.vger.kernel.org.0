Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA8F20BC43
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgFZWOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:14:30 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4502DC03E979;
        Fri, 26 Jun 2020 15:14:30 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e197so1143039yba.5;
        Fri, 26 Jun 2020 15:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hHb3fXLwI6RRtMD9b/SQRRJExFm/2hYDLQ5mTPyybM=;
        b=f5l5O+7uYmWDvyL+K9n1e5E+LYBFxs5lyTnRIzqvGmwBKgmN87kyx9pGecU8M4qC6l
         BdWqPN0VtjyAxTGwHun+gBuJUmCHWqiuZcvgBIeNVtNSrKi865aeAuHfF9MCWy7uwE+/
         NJS8iYAfszwf98UhWdP0NRE5f0Hm+aweb011PEJ8iCDucBe25ZnZ+94iyfwFHy9K8WZE
         XaLYjqvQKPXXaG2FUV3MAcGOpY70eBhPLmUraY+Yy/N05wa3kdS+Ntf5o6tEYpwELOHr
         R6CDeNrtW2kFHPcdmjNNDsI4fSvIaJoPN/w2GHwf72n9cuk8UgNCMMVEqhS8elvwKyrx
         eHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hHb3fXLwI6RRtMD9b/SQRRJExFm/2hYDLQ5mTPyybM=;
        b=VkXNlzEZxZUSqM6oJizY7Z1sf8xqJ1KGM2mswy978ajhMhh5fgwDI+SScuFd1JjGSa
         PnLBtIrey5O33J1blDU8Jj1OGVfOCbQTt38ErpFum9gzAqOSnep0OV+q878Rd6D6NYfn
         RwNO/dXW/8CIp14JRNgvoitiwhB8dQdFfuURuXvVCTfuUUenUD/2F0BpNbGimF97NEtJ
         wFRErApKtmOIQTuY5wDKYGKv09xF4CPf8Z5BqGGFijgErMG6e0Ezd4yXLYVAEtgydUks
         AeJS6E6e/h4Hs+PSIB0ETtdGMJeQPDxLwyk7QsdTaK7JhgBlw7CButm0qZX1nElY5gCc
         aKHg==
X-Gm-Message-State: AOAM533ftr5KXBmCM69iIQcMV4Ha9iQd3TSR/AZCpNNpzOYy8kZya1kq
        dGcOc8/yjfB4H0c8F2fN+bLochZt/k/HrQ0OvA==
X-Google-Smtp-Source: ABdhPJxCL2CWN88xo/XK/yJl7JdvCokdz2xFJqgdui7FViyhlZ9Icq1WDwSRSjNFaGHf8+DFXR/6PUMFEoLCshZk3CI=
X-Received: by 2002:a25:a2c2:: with SMTP id c2mr7969960ybn.333.1593209669488;
 Fri, 26 Jun 2020 15:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-3-danieltimlee@gmail.com>
 <CAEf4BzbGk2xSGAkLEXKSg3NhrL28o+cmW9jTq2=EhggJEYT=5Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbGk2xSGAkLEXKSg3NhrL28o+cmW9jTq2=EhggJEYT=5Q@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 27 Jun 2020 07:14:14 +0900
Message-ID: <CAEKGpziJWYDhnq=DWvcFdSAA-jnGk=Vrci2A-9ktY6g5_4Ki8Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] samples: bpf: refactor BPF map in map test with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 5:30 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> > support"), a way to define internal map in BTF-defined map has been
> > added.
> >
> > Instead of using previous 'inner_map_idx' definition, the structure to
> > be used for the inner map can be directly defined using array directive.
> >
> >     __array(values, struct inner_map)
> >
> > This commit refactors map in map test program with libbpf by explicitly
> > defining inner map with BTF-defined format.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> Thanks for the clean up, looks good except that prog NULL check.
>

I'll fix this NULL check as well too.

> It also seems like this is the last use of bpf_map_def_legacy, do you
> mind removing it as well?
>

Actually, there is one more place that uses bpf_map_def_legacy.
map_perf_test_kern.c is the one, and I'm currently working on it, but
I'm having difficulty with refactoring this file at the moment.

It has a hash_map map definition named inner_lru_hash_map with
BPF_F_NUMA_NODE flag and '.numa_node = 0'.

The bpf_map_def in libbpf has the attribute name map_flags but
it does not have the numa_node attribute. Because the numa node
for bpf_map_def cannot be explicitly specified, this means that there
is no way to set the numa node where the map will be placed at the
time of bpf_object__load.

The only approach currently available is not to use libbbpf to handle
everything (bpf_object_load), but instead to create a map directly with
specifying numa node (bpf_load approach).

    bpf_create_map_in_map_node
    bpf_create_map_node

I'm trying to stick with the libbpf implementation only, and I'm wondering
If I have to create bpf maps manually at _user.c program.

Any advice and suggestions will be greatly appreciated.

Thanks for your time and effort for the review.
Daniel.

>
> >  samples/bpf/Makefile               |  2 +-
> >  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
> >  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
> >  3 files changed, 91 insertions(+), 49 deletions(-)
> >
>
> [...]
>
> >
> >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > +       obj = bpf_object__open_file(filename, NULL);
> > +       if (libbpf_get_error(obj)) {
>
> this is right, but...
>
> > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > +               return 0;
> > +       }
> >
> > -       if (load_bpf_file(filename)) {
> > -               printf("%s", bpf_log_buf);
> > -               return 1;
> > +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> > +       if (libbpf_get_error(prog)) {
>
> this is wrong. Just NULL check. libbpf APIs are not very consistent
> with what they return, unfortunately.
>
> > +               printf("finding a prog in obj file failed\n");
> > +               goto cleanup;
> > +       }
> > +
>
> [...]
