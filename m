Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959103A7542
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFODff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhFODfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:35:34 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65DC061574;
        Mon, 14 Jun 2021 20:33:30 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id a1so24469316lfr.12;
        Mon, 14 Jun 2021 20:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XkNi4rwVylaVb0abADv814UCtybS9N/wS29ZXtQgO/Q=;
        b=Uq9+nsLgjuVOUaar6OjqVnUHTrTeg9RW90K5Y8/PzWrOTcN2m47vooyeYfK6F6VD5c
         oYkJVa0h8zkmsiS0B2KQq95oemzIW1RzLuqObHVkKvThoS13A3lSbb9kSvYDFwGp/jfC
         M09g5m8vr/wIkdAWun1sDs58oSkRfTcG35v3uwckEt+ur1RDi1H4PVS5U+EbJnSSQk0Z
         aitWWsjjYn8JotS/6UmfwVCzDZX/samxPGIwAYmzoclhDw/AtYJ1qYmu+YWOChcS2Lbg
         G22IOlAZPdfJs7I0hVGV6XD/rHZvHEQE1yddlXSikUfjiV1RXVWGrUe7T195zY4V8mg2
         fUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XkNi4rwVylaVb0abADv814UCtybS9N/wS29ZXtQgO/Q=;
        b=Rrts82PB3x1YhC7GV1tZasjXY3AA6TGwv5468pY/egE/l0frkbu2GEN5D8yRhD0A+4
         8a7wioc/0XO3qLOJY6o2xUJg5d6Q+BC0gtVKiy5fd5YmlZ8JOMLA8vJm/KMTBMMtO7d8
         Y8HkSERYrAisgkmvgUyU9qGhDj8YwPT4T1dXULa0axv0KtLLNCjL7Jf5Cc9k1lwaYGbd
         f1QASi1BgJpmu/WZpZmm/rooAkrzezAHWdnRUPPv5CvysTKhUnpTM6Ol4CQMGQpCIMrW
         mV/DLJ108TIUze3kaaDArCpHi+OfWopE8bWFCwd12Zg/QtRBnWwR4NHpTomE83rjPfNF
         BNJA==
X-Gm-Message-State: AOAM531lSqc8Xrn7LR36gSSVR0TKMIHgL0u10PZ6sb1Qqsw0aC5THbXi
        cdlJ6xD9+tou6CBlWiJJYi9ar90RUa3KmkU4rDOi702Qiu4=
X-Google-Smtp-Source: ABdhPJyorB84vU2WUTl1+T9OkRpLdTaE4IJhV4nnDRA/0ezQc/e70PoVX9gWqHBhldeMjjwbXP4x2uiz+589lw2xZII=
X-Received: by 2002:ac2:46cb:: with SMTP id p11mr14106251lfo.182.1623728009095;
 Mon, 14 Jun 2021 20:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <f36d19e7-cc6f-730b-cf13-d77e1ce88d2f@fb.com>
In-Reply-To: <f36d19e7-cc6f-730b-cf13-d77e1ce88d2f@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Jun 2021 20:33:17 -0700
Message-ID: <CAADnVQKKrb1kz_C-v7RcgYgEe_JPhhpL4W6ySM28HcE_g=ncVw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 3:12 PM Yonghong Song <yhs@fb.com> wrote:
> > +struct bpf_hrtimer {
> > +     struct hrtimer timer;
> > +     struct bpf_map *map;
> > +     struct bpf_prog *prog;
> > +     void *callback_fn;
> > +     void *value;
> > +};
> > +
> > +/* the actual struct hidden inside uapi struct bpf_timer */
> > +struct bpf_timer_kern {
> > +     struct bpf_hrtimer *timer;
> > +     struct bpf_spin_lock lock;
> > +};
>
> Looks like in 32bit system, sizeof(struct bpf_timer_kern) is 64
> and sizeof(struct bpf_timer) is 128.
>
> struct bpf_spin_lock {
>          __u32   val;
> };
>
> struct bpf_timer {
>         __u64 :64;
>         __u64 :64;
> };
>
> Checking the code, we may not have issues as structure
> "bpf_timer" is only used to reserve spaces and
> map copy value routine handles that properly.
>
> Maybe we can still make it consistent with
> two fields in bpf_timer_kern mapping to
> two fields in bpf_timer?
>
> struct bpf_timer_kern {
>         __bpf_md_ptr(struct bpf_hrtimer *, timer);
>         struct bpf_spin_lock lock;
> };

Such alignment of fields is not necessary,
since the fields are not accessible directly from bpf prog.
struct bpf_timer_kern needs to fit into struct bpf_timer and
alignof these two structs needs to be the same.
That's all. I'll add build_bug_on to make sure.
