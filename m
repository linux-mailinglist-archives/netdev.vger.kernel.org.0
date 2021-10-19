Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E669432C6B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhJSDsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhJSDsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:48:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFC5C06161C;
        Mon, 18 Oct 2021 20:46:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so959699pjc.3;
        Mon, 18 Oct 2021 20:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BZZTHz9glvu1cCcglzMbueWb2cAg5BGgcHCHhFUYOyo=;
        b=TYnT0JHLak+IGcZunfBdTnuCxhsG4IO5Tbh/KUz/Psnz1HThhD88kQE12+vOZa+imz
         kD/cMsM18F6DFAaN9wH6mmBOOgG8/U66kxQgWQphN1BIx5I6ZZ8bFVJYKRpoLj+U5UVS
         pokXtrPApMxYYppvRzlANb0W0WEsBwt1t9LMKWU6ZqWv+gM9aAgj0MuudOWDSgtQ7qEi
         mX/K5MzheHeBndh+f5s+unzTp+0xMHLU932x/aV8h/pCBCYvbQdaW4y5N1TKodsGaN3Q
         bLv6XV5NTrzIas5YWc5nwRNNX1Aq24HU4wDl9NR7TfWVO/UBADX832LXKDklBZg6cPO0
         eEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BZZTHz9glvu1cCcglzMbueWb2cAg5BGgcHCHhFUYOyo=;
        b=gJFdCen47zvuNRBpGfAv2gmEboQaRzw0CaPrYMksMaXT5us+m7WCSfcjrvTacbI6qR
         LLbH0byPnqQLlcG+vf68hV1YZ6auj+Quhzcf384cs3AF0eKMh+hP8K4LF5Idt4PGlVBS
         baAXLyApc3KiOQyUbrB7VdaAS1Iu4nB4aKBrRn5/zjvPVA54+ncYMkdbUFoRETXf7Dxw
         /UxeIe4mKcFZUONMKoGjZ9gGZDDJVjvf0Ojv5b1ObOpVm10s86yPSCcl8lSCR+z5PEz3
         CZK9W4huN/JJeLjxPYDLLptKC/Y5/3qIKB10zRCPeTWRXg8nAFZyYh4aalILd/jeNCBj
         lExw==
X-Gm-Message-State: AOAM533Wu13TxmPPsUOVovSF0tBfSE4Ly+1HNi7jS9HgftZzZIeiWkd2
        3l0VxKz1LJUfdWRJ2PdMblhkHAkwWmgJm8QSViE=
X-Google-Smtp-Source: ABdhPJxUtFFZ/TdUvhg3UFl/iRBV82O13ot3ca0wwDlvmopzKaMuVbedurIxZEDyynaNtS/8vAkxaNqYlz17/ZTpTQE=
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id
 c6-20020a170902724600b00138a6ed66ccmr32071190pll.22.1634615168946; Mon, 18
 Oct 2021 20:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
 <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
 <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com> <CAADnVQKG5=qVSjZGzHEc0ijwiYABVCU1uc8vOQ-ZLibhpW--Hg@mail.gmail.com>
 <b8f6c2f6-1b07-9306-46da-5ab170a125f9@bytedance.com>
In-Reply-To: <b8f6c2f6-1b07-9306-46da-5ab170a125f9@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Oct 2021 20:45:57 -0700
Message-ID: <CAADnVQJpcFXVE1j5aEdeyCoBZytzytiYP+3AwQxtWmNj6q-kNQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] bpf: use count for prealloc hashtab too
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 8:14 PM Chengming Zhou
<zhouchengming@bytedance.com> wrote:
>
> =E5=9C=A8 2021/10/19 =E4=B8=8A=E5=8D=889:57, Alexei Starovoitov =E5=86=99=
=E9=81=93:
> > On Sun, Oct 17, 2021 at 10:49 PM Chengming Zhou
> > <zhouchengming@bytedance.com> wrote:
> >>
> >> =E5=9C=A8 2021/10/16 =E4=B8=8A=E5=8D=883:58, Alexei Starovoitov =E5=86=
=99=E9=81=93:
> >>> On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
> >>> <zhouchengming@bytedance.com> wrote:
> >>>>
> >>>> We only use count for kmalloc hashtab not for prealloc hashtab, beca=
use
> >>>> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist=
.
> >>>>
> >>>> But the problem is that __pcpu_freelist_pop() will traverse all CPUs=
 and
> >>>> spin_lock for all CPUs to find there is no more elem at last.
> >>>>
> >>>> We encountered bad case on big system with 96 CPUs that alloc_htab_e=
lem()
> >>>> would last for 1ms. This patch use count for prealloc hashtab too,
> >>>> avoid traverse and spin_lock for all CPUs in this case.
> >>>>
> >>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> >>>
> >>> It's not clear from the commit log what you're solving.
> >>> The atomic inc/dec in critical path of prealloc maps hurts performanc=
e.
> >>> That's why it's not used.
> >>>
> >> Thanks for the explanation, what I'm solving is when hash table hasn't=
 free
> >> elements, we don't need to call __pcpu_freelist_pop() to traverse and
> >> spin_lock all CPUs. The ftrace output of this bad case is below:
> >>
> >>  50)               |  htab_map_update_elem() {
> >>  50)   0.329 us    |    _raw_spin_lock_irqsave();
> >>  50)   0.063 us    |    lookup_elem_raw();
> >>  50)               |    alloc_htab_elem() {
> >>  50)               |      pcpu_freelist_pop() {
> >>  50)   0.209 us    |        _raw_spin_lock();
> >>  50)   0.264 us    |        _raw_spin_lock();
> >
> > This is LRU map. Not hash map.
> > It will grab spin_locks of other cpus
> > only if all previous cpus don't have free elements.
> > Most likely your map is actually full and doesn't have any free elems.
> > Since it's an lru it will force free an elem eventually.
> >
>
> Maybe I missed something, the map_update_elem function of LRU map is
> htab_lru_map_update_elem() and the htab_map_update_elem() above is the
> map_update_elem function of hash map.
> Because of the implementation of percpu freelist used in hash map, it
> will spin_lock all other CPUs when there is no free elements.

Ahh. Right. Then what's the point of optimizing the error case
at the expense of the fast path?
