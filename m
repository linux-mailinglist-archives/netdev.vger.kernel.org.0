Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ECD3EDFFB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhHPWdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhHPWdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:33:37 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB764C061764;
        Mon, 16 Aug 2021 15:33:05 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id i8so13045796ybt.7;
        Mon, 16 Aug 2021 15:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwmG96ZBl3mgbXjTr/PRTrqDNEWr8ktyZ6U+CRAeclU=;
        b=qljUs/LJ3TT44kHmN2d8VEptxsgsOHIDzLRWg6046KAMC5cNZ5qlm45zjpGvW9PZR8
         aTmHHHvU509ezSGGxeD962uTsleOLtN/NaqQB5udajepFxQSKTD5wKhNhGfc1yUBS1Ln
         6tARH6MGVSc8Fc/w8ZEV10EOGRooPgyIH/swN1nhayX3/pveEXVq/ors7eRnEPSvZtM8
         +Y58TWvlU2eHzD4KpmuEpazpvTIoG+DA5qaIS4nd3MxvJopvKEr+1Itw68clyHtq/fgN
         zJUm2uX1kBxSVL+KrwMQ/2j2OSA4n8GVSwy8jsHZXXnsaLH7t7zPD0FrX1CtkOtSz5ln
         1zqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwmG96ZBl3mgbXjTr/PRTrqDNEWr8ktyZ6U+CRAeclU=;
        b=ZlURTe81rqkd5EfmXn1fL3JaPArf39kODiiTRlRlpMgQCv6iJIme2CEjwuJxFmWgUB
         eSMn6QfwmnoCsS8vATPw3sAssB/jlIIOtDCHe4TN1rgbIs0PFZuyu4PP3OVcXGXE4uEH
         JITQ8q7bSyMx9NUi9sTBxmkSnSC/YTTunDe6v5oupONyo+80RO52u6Jzcz6VJZf+1HUl
         w161Ct2cnVlp/2UBxqiYZp9jD36fa1O8V31EUpoiwzL8F+yZLiJV4KwOoEO3Cn8GBdZa
         ZmyZeMrM+fH6aSr6w6MmVFgRss5ypV3sbua7rZ07FwK4bsQIFOibINXoy+UuC1V3U4Om
         rdHg==
X-Gm-Message-State: AOAM530vdLOPQqg7UlahGaOvj57mRJITnWaHIjK9MaDKxcCDA+1LEPGQ
        mlcoyIY6wSMIgmAfycQPd4oyu+5vPylxAzuVgoYCT0eIjK0=
X-Google-Smtp-Source: ABdhPJwZYtqW13o+gkXw+Sy46tL80aKMi6UydegVVc3nuptxVbojJSIITyPnVXy2mE1vIZXabzrkEE6G2TVuQhGJXus=
X-Received: by 2002:a25:4941:: with SMTP id w62mr431735yba.230.1629153185106;
 Mon, 16 Aug 2021 15:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210816164832.1743675-1-sdf@google.com> <1b3cb059-9ecb-a0c9-3c99-805788088d09@iogearbox.net>
In-Reply-To: <1b3cb059-9ecb-a0c9-3c99-805788088d09@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Aug 2021 15:32:54 -0700
Message-ID: <CAEf4Bzb5A06ZP5k4uDwspBp7KfzY8n3=D7kr9K=6Xbf9cj4-Tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use kvmalloc in map_lookup_elem
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 2:43 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/16/21 6:48 PM, Stanislav Fomichev wrote:
> > Use kvmalloc/kvfree for temporary value when looking up a map.
> > kmalloc might not be sufficient for percpu maps where the value is big.
> >
> > Can be reproduced with netcnt test on qemu with "-smp 255".
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   kernel/bpf/syscall.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 9a2068e39d23..ae0b1c1c8ece 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -1076,7 +1076,7 @@ static int map_lookup_elem(union bpf_attr *attr)
> >       value_size = bpf_map_value_size(map);
> >
> >       err = -ENOMEM;
> > -     value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
> > +     value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
> >       if (!value)
> >               goto free_key;
>
> What about other cases like map_update_elem(), shouldn't they be adapted
> similarly?

And in the same vein (with keys potentially being big as well), should
we switch __bpf_copy_key() to use vmemdup_user() instead of
memdup_user()?

>
> Thanks,
> Daniel
