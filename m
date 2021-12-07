Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8646B0BE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhLGClh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhLGClh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:41:37 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C636BC061746;
        Mon,  6 Dec 2021 18:38:07 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id g17so36662586ybe.13;
        Mon, 06 Dec 2021 18:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=INMJW+5EYKlIRvkqknDrxt9nVIm+nRcqXViKKvXHHy0=;
        b=iZzFCdGqM3+ohqSYSSs6CbLiqcsUr7PZ89YdoEnq5mhtjykLt1cfpXk+ORWPHjkDvb
         UK5lP8iUwrUZzCkpLHFhR4x3C9NeSecw0tNvvOFE7hkI/8y5dxeX677KQYWJ5s8Kc8mV
         AfCflEiu+6G33fv9XDE5eELpISQ3EHyjteMhbepkDILrwvwVTaHncib+SQxpGuxWJ4Z0
         eD7oNhixpiVth3Ndxle/LgFlw6Uc0F7ITGTZAxX6mSIzKU//8bybkkFSwiO/u8OP8eSu
         tKbprr2njLcs5k9VRP1/puLnTQrm6z9Lfs/BLVaW9xxYM1ESt5Tw7eJ7VeaBVXya81ro
         VaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=INMJW+5EYKlIRvkqknDrxt9nVIm+nRcqXViKKvXHHy0=;
        b=75iD1kYQ0o5t1lJTQ9JcnQhYQ0Kp+zEkwtFFLtKnbwEZ7jAaf/uHdV4FpL4pqwA1/S
         z+57mxnCF3MbWqzzlPzZ/JL+JJW/huHbPrmSFALWlFAzpiP8vVKpKWQ9aIh289G8SHyq
         LnIcon7eWVui4yLbokuWiBwUKXXFCtKvAO7iBGuK4eSLy2tUyXh6Q9zUfpoSOipZ77QD
         1Fyo9qkiMQ2X3i0wdqN1vzoNqQz0QQd8c4ccYMezuKNfoiMiwTCROMW+DdY9MfHhI5gB
         rhQUyOHdRj79APIMxd9qAhLOckK6rNHBs/oe9u1I4PGuCJEkEmivuHiuRxhLTMSur4IN
         qdeA==
X-Gm-Message-State: AOAM533F9ykBAQwDcf/J97ZoCSmG5Kr41iShKXkEJ+TJsHJFYaw81y+g
        hoSafhXdnAWq5ovy5wrsjqLk9RTmJHh8dZT6QSc=
X-Google-Smtp-Source: ABdhPJw26c8algIvgbQt6qRYPX2JmMn1/lWiequpmBsc7tfjt0NtbJMg9juL0kpEE2v55wYoE9xiwDZm+uFZ44Qhu0o=
X-Received: by 2002:a25:b204:: with SMTP id i4mr45855083ybj.263.1638844687043;
 Mon, 06 Dec 2021 18:38:07 -0800 (PST)
MIME-Version: 1.0
References: <20211206230811.4131230-1-song@kernel.org>
In-Reply-To: <20211206230811.4131230-1-song@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 18:37:55 -0800
Message-ID: <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of bpf_create_map
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 3:08 PM Song Liu <song@kernel.org> wrote:
>
> bpf_create_map is deprecated. Replace it with bpf_map_create.
>
> Fixes: 992c4225419a ("libbpf: Unify low-level map creation APIs w/ new bpf_map_create()")

This is not a bug fix, it's an improvement. So I don't think "Fixes: "
is warranted here, tbh.

> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/perf/util/bpf_counter.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> index c17d4a43ce065..ed150a9b3a0c0 100644
> --- a/tools/perf/util/bpf_counter.c
> +++ b/tools/perf/util/bpf_counter.c
> @@ -320,10 +320,10 @@ static int bperf_lock_attr_map(struct target *target)
>         }
>
>         if (access(path, F_OK)) {
> -               map_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
> +               map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, NULL,

I think perf is trying to be linkable with libbpf as a shared library,
so on some older versions of libbpf bpf_map_create() won't be (yet)
available. So to make this work, I think you'll need to define your
own weak bpf_map_create function that will use bpf_create_map().

>                                         sizeof(struct perf_event_attr),
>                                         sizeof(struct perf_event_attr_map_entry),
> -                                       ATTR_MAP_SIZE, 0);
> +                                       ATTR_MAP_SIZE, NULL);
>                 if (map_fd < 0)
>                         return -1;
>
> --
> 2.30.2
>
