Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE08277A27
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIXUZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIXUZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:25:33 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4004EC0613CE;
        Thu, 24 Sep 2020 13:25:33 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so399259ybe.0;
        Thu, 24 Sep 2020 13:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iylEi7Ra5waA1AGePpjrrWiu+33+FxmMQwPUwXf82Eo=;
        b=H87VT+Xf21uO6xFPitD8pIstdQ/Vlexufj5sWS4qQ9Wh33ZtA6mPoCWDOhF3q0BV7w
         iLRLOiBphrq/B81KEcODLcRh0NwYFKgWLsyPO2Fq5LECWCuLTBEvDnbOGR5bEfqSL4hY
         qp2xc9+02ntyymZ29TE2Oj4ezgorc+zhS3ZlSiceQfQiURu6+XU+Rg7eJek+/ehsORxC
         p1AKbbA6VZuRVlbpHRjs8+i+N04CKWNE7wZk8nRU1WdyrMAnZDi3v84L8Fs2Kbyv7cIK
         fZt2jm5EWixzY3pMvTMT0Lm/xNnBsgs3IM6IXJrr5CfSiAZyAKiDsKy+4Z0PcE4mtYSN
         /UpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iylEi7Ra5waA1AGePpjrrWiu+33+FxmMQwPUwXf82Eo=;
        b=bzQzF+Zb+2YBAOCLo4DSZ0ooqdp6l5s404FEeHsDtOkZF/0gxohEOxXTQfES0XhVoN
         Gd5vaFPmSrAr6bBjHXdMYFwe8YXMYFAHyNzpVoRiS/Mkgtx/EClnpP9cJ/clW3iJf5X8
         fhg/DPODjsJEAav4xKIuBOHpHRomWnC6rB5JKpTOkHCH2QmXA7IYu14hOEYYo02qAPwR
         yaOUyCuU3lz702IUqJiYrZHd+Ck2KppqO5DpHLoe+CWvjvljMAM0ZO/f+AnyTIrFRIv+
         XFysOkAcGdJQwKbqPUvZ2FHmxrARWNcXHFxvUtfcK7VRTPzUd5Rxm2LhLL44L0rsJRCV
         CM1g==
X-Gm-Message-State: AOAM532r6Om314f157xKM0MzwzSJ81bCH97y9qvgUPMAZb2dpB4oe+ZY
        OGg1HQOyC9W4QYest1yXANQIGr6bafxMVUDW0jM=
X-Google-Smtp-Source: ABdhPJz2ROQke/w3oZQ7WRb6R0DBfTw5cw5RzTX6IOa79McU8bMmFnbitC8LkJic+eTwJgvFq+5wLNlc679zOTo25gw=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr736403ybz.27.1600979132497;
 Thu, 24 Sep 2020 13:25:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200923155436.2117661-1-andriin@fb.com> <20200923155436.2117661-3-andriin@fb.com>
 <5f6cb9778cbd7_4939c208b8@john-XPS-13-9370.notmuch>
In-Reply-To: <5f6cb9778cbd7_4939c208b8@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:25:21 -0700
Message-ID: <CAEf4BzYV+f2JXJDMvbNL0f6GQDPMaOOmsM7M=pO=f4mF2RfUig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/9] libbpf: remove assumption of single
 contiguous memory for BTF data
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 8:21 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Refactor internals of struct btf to remove assumptions that BTF header, type
> > data, and string data are layed out contiguously in a memory in a single
> > memory allocation. Now we have three separate pointers pointing to the start
> > of each respective are: header, types, strings. In the next patches, these
> > pointers will be re-assigned to point to independently allocated memory areas,
> > if BTF needs to be modified.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> [...]
>
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -27,18 +27,37 @@
> >  static struct btf_type btf_void;
> >
> >  struct btf {
> > -     union {
> > -             struct btf_header *hdr;
> > -             void *data;
> > -     };
> > +     void *raw_data;
> > +     __u32 raw_size;
> > +
> > +     /*
> > +      * When BTF is loaded from ELF or raw memory it is stored
> > +      * in contiguous memory block, pointed to by raw_data pointer, and
> > +      * hdr, types_data, and strs_data point inside that memory region to
> > +      * respective parts of BTF representation:
>
> I find the above comment a bit confusing. The picture though is great. How
> about something like,
>
>   When BTF is loaded from an ELF or raw memory it is stored
>   in a continguous memory block. The hdr, type_data, and strs_data
>   point inside that memory region to their respective parts of BTF
>   representation
>

Had to do a mental diff to find the part you didn't like :) I'll
update the comment as you suggested.

> > +      *
> > +      * +--------------------------------+
> > +      * |  Header  |  Types  |  Strings  |
> > +      * +--------------------------------+
> > +      * ^          ^         ^
> > +      * |          |         |
> > +      * hdr        |         |
> > +      * types_data-+         |
> > +      * strs_data------------+
> > +      */
> > +     struct btf_header *hdr;
> > +     void *types_data;
> > +     void *strs_data;
> > +
> > +     /* type ID to `struct btf_type *` lookup index */
> >       __u32 *type_offs;
> >       __u32 type_offs_cap;
> > -     const char *strings;
> > -     void *nohdr_data;
> > -     void *types_data;
> >       __u32 nr_types;
> > -     __u32 data_size;
> > +
> > +     /* BTF object FD, if loaded into kernel */
> >       int fd;
> > +
> > +     /* Pointer size (in bytes) for a target architecture of this BTF */
> >       int ptr_sz;
> >  };
> >
>
> Thanks,
> John
