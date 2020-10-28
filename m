Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9712D29D36D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgJ1Vnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgJ1Vnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:43:50 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456F7C0613CF;
        Wed, 28 Oct 2020 14:43:50 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id b2so536758ots.5;
        Wed, 28 Oct 2020 14:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+63OmldnYBrpvkEXMvjWspQh8qYoz92cud0eWRZNhSQ=;
        b=alq5MqFMfTHkfoMxtHKP6ghQ32ndGdHJQ4isAx3t6q+VC10nVSXS98tag1+OCwvpWu
         DMHtTiHeAZKZY/KuKuKUpvaSWBhbCuP71TYduhIdFwc+AY9BKr9sfIaGN99qyKDgpeo5
         75h+fhTcrIoKhUxZKeG7ikSOL5j3So1DnU9qea+jB8r+vB/V/upQBuX4yFMq/yliXId1
         BARgKTCQFMZTrAb9H3n1E4hwd1LV35+NkbUZnPOFDRvwYwpRJc2GFmeYpZitZlffWYRr
         bNlJZQAGYKj9Zjeuw8Jrj3v1JKLN6d6MT+9dnb1wY4zIGfAsxCS5oMv4aAAWowTgO12o
         Z3Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+63OmldnYBrpvkEXMvjWspQh8qYoz92cud0eWRZNhSQ=;
        b=S15dKMp6hIjuuDQ90LrPE7Sga+1Ln3v1NlAnG7ULaAQldC+8arZewhFiAH2QpWw4qN
         Y9IljtWUrUFjUcQYTORt/YcdCLYYg73scaDia84xFkvLuw8+9r2N8A6HN6HNI54gfyI2
         8YfVrIvG4e0zx75aMf0W3DecI6yvRhQP0tnLSPO7p/90xWAB4VG+by+f/Z3doj5MiJuD
         G459vdYE86gr+PvtVWLBziXP36b+EKBJUMwWrZbXxcLfBFz7CN/000L+v1UqmKj9rhas
         sH7z1BCcBWCKUzToXZElJNX0141VQt2kUVSQQf0yiqIN+W9A32musRjnYGB1dlfESajS
         RiQg==
X-Gm-Message-State: AOAM532vBKMJ1/jwRYXyyhD7PjwYvcP1nIOj563A1HgMqhcZ29bdeZwG
        RJaxLId6jdn8zNsRQIqNu41CL3J+ejmDovgAGWK2huia
X-Google-Smtp-Source: ABdhPJx3AEqk1XPhIUL8p1UAjBdIvQzWuoaXYRmWlNF3OcOfLkhdJ8eC8zP6oMUC1t5Jp6gWsOOzNNxJxxEkFbRUwfM=
X-Received: by 2002:a25:4102:: with SMTP id o2mr9492746yba.115.1603887860713;
 Wed, 28 Oct 2020 05:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20201027205723.12514-1-ardb@kernel.org> <72f0dd64-9f65-cbd0-873a-684540912847@iogearbox.net>
 <CAKwvOdmvyBbqKiR=wFmyiZcXaN1mYHe-VJtqbBS9enhDcUcN=w@mail.gmail.com> <20201028081123.GT2628@hirez.programming.kicks-ass.net>
In-Reply-To: <20201028081123.GT2628@hirez.programming.kicks-ass.net>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 28 Oct 2020 13:24:09 +0100
Message-ID: <CANiq72mDwYcR9=giW76+wAk_ZihAqbScx94nfh5pL9wfdDCfng@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: Remove broken __no_tail_call attribute
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?Q?Martin_Li=C5=A1ka?= <mliska@suse.cz>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 9:11 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Subject: tools/perf: Remove broken __no_tail_call attribute

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
