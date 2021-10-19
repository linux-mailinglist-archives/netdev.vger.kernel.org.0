Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB8432CDE
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 06:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJSEpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 00:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSEpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 00:45:51 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED93C06161C;
        Mon, 18 Oct 2021 21:43:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v8so12396858pfu.11;
        Mon, 18 Oct 2021 21:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LFH55MUDTWph2zfWxBLDmD2A2hWHaeINGUWcGNTepAw=;
        b=g7dBDr7PfFckDM+mqmoSLH10uPl32t/Pgwdm7hBYp0UqdbULKTF68hrJqv9JsgkFBI
         DXn2cdfx1ux2RtizwPzP+EFEkHWN5U7VZB3oZ9tXsGTbX0BxGdNyLar811zgbubeBX7T
         yeO42LRs+UGQ1Po+r8zks8z0CpKLrPU3FBGJb8gCjXMig3Vb1D5+nCAe5U7gl7jM+9di
         uC4yGOQ6exwGOA2kHxTSFEuekXwjCeKcjCSglBzYTwF+rd1PD4WhZOxyWmgqWode8Jkk
         7+nT2XkCkasa/Mg3okDoKsqjS/RdIF60p2h1KdcD78/mce5BY+/lTPn4E/pXw0R7VxiD
         oA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LFH55MUDTWph2zfWxBLDmD2A2hWHaeINGUWcGNTepAw=;
        b=2ZxXChTiI0deGWMBdj4rrnmgEcyeqb6kAh1K9SSTIEHYwq27mDhYupnHM9m37Eum7/
         uCBLz1/K6jipd7gHBKxGHTdDbB3qQVcZgQy/odACfp48aNIsdKZwbKVEpJUnNwr3Lv5I
         YkSMAKNsUEaSC1E7a5zZhfCBL8FOHAkZB9Yub9hNKpuZNJbmGBprAm0FwYIQv96YpO8f
         UNSMPxHT03w4s1+AXSyeP/Q0FhNXMOJqjgchjvLR+yhI2ICfQV9EXUvFiPxU+o9xcYgk
         GgjYVG/tQomBN8dfocpg5d1Xr7TQIpW2UOVD4M772JlHJh3LECz5UAWcXK1nY/4JMbRA
         tz4Q==
X-Gm-Message-State: AOAM531zoSMSTg2mC1Z570DIpZBtbm+5byzsTUjVw+eYJhyHYA9aLyT8
        cbDN9cMVakyNR3AlbdKlCwTgDXsQYrkBNt7i30A=
X-Google-Smtp-Source: ABdhPJyoTtgAxuyN2+TeP7YU5nBJUGFw28pm3HxWILjaCZ07rIB9BWLlUHelBpPgTqUa0OfJCkpV2/EFzU5AqiAN91A=
X-Received: by 2002:a05:6a00:17a6:b0:44d:df1f:5626 with SMTP id
 s38-20020a056a0017a600b0044ddf1f5626mr7138670pfg.59.1634618618954; Mon, 18
 Oct 2021 21:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
 <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
 <6d7246b6-195e-ee08-06b1-2d1ec722e7b2@bytedance.com> <CAADnVQKG5=qVSjZGzHEc0ijwiYABVCU1uc8vOQ-ZLibhpW--Hg@mail.gmail.com>
 <b8f6c2f6-1b07-9306-46da-5ab170a125f9@bytedance.com> <CAADnVQJpcFXVE1j5aEdeyCoBZytzytiYP+3AwQxtWmNj6q-kNQ@mail.gmail.com>
 <36b27bba-e20b-8fd4-1436-d2d4c0e86896@bytedance.com>
In-Reply-To: <36b27bba-e20b-8fd4-1436-d2d4c0e86896@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 18 Oct 2021 21:43:27 -0700
Message-ID: <CAADnVQ+ijmng_s1EP_qTG3Xsvg6v5EWLvP9PTFEH0vLnyJUtRg@mail.gmail.com>
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

On Mon, Oct 18, 2021 at 9:31 PM Chengming Zhou
<zhouchengming@bytedance.com> wrote:
>
> =E5=9C=A8 2021/10/19 =E4=B8=8A=E5=8D=8811:45, Alexei Starovoitov =E5=86=
=99=E9=81=93:
> > On Mon, Oct 18, 2021 at 8:14 PM Chengming Zhou
> > <zhouchengming@bytedance.com> wrote:
> >>
> >> =E5=9C=A8 2021/10/19 =E4=B8=8A=E5=8D=889:57, Alexei Starovoitov =E5=86=
=99=E9=81=93:
> >>> On Sun, Oct 17, 2021 at 10:49 PM Chengming Zhou
> >>> <zhouchengming@bytedance.com> wrote:
> >>>>
> >>>> =E5=9C=A8 2021/10/16 =E4=B8=8A=E5=8D=883:58, Alexei Starovoitov =E5=
=86=99=E9=81=93:
> >>>>> On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
> >>>>> <zhouchengming@bytedance.com> wrote:
> >>>>>>
> >>>>>> We only use count for kmalloc hashtab not for prealloc hashtab, be=
cause
> >>>>>> __pcpu_freelist_pop() return NULL when no more elem in pcpu freeli=
st.
> >>>>>>
> >>>>>> But the problem is that __pcpu_freelist_pop() will traverse all CP=
Us and
> >>>>>> spin_lock for all CPUs to find there is no more elem at last.
> >>>>>>
> >>>>>> We encountered bad case on big system with 96 CPUs that alloc_htab=
_elem()
> >>>>>> would last for 1ms. This patch use count for prealloc hashtab too,
> >>>>>> avoid traverse and spin_lock for all CPUs in this case.
> >>>>>>
> >>>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> >>>>>
> >>>>> It's not clear from the commit log what you're solving.
> >>>>> The atomic inc/dec in critical path of prealloc maps hurts performa=
nce.
> >>>>> That's why it's not used.
> >>>>>
> >>>> Thanks for the explanation, what I'm solving is when hash table hasn=
't free
> >>>> elements, we don't need to call __pcpu_freelist_pop() to traverse an=
d
> >>>> spin_lock all CPUs. The ftrace output of this bad case is below:
> >>>>
> >>>>  50)               |  htab_map_update_elem() {
> >>>>  50)   0.329 us    |    _raw_spin_lock_irqsave();
> >>>>  50)   0.063 us    |    lookup_elem_raw();
> >>>>  50)               |    alloc_htab_elem() {
> >>>>  50)               |      pcpu_freelist_pop() {
> >>>>  50)   0.209 us    |        _raw_spin_lock();
> >>>>  50)   0.264 us    |        _raw_spin_lock();
> >>>
> >>> This is LRU map. Not hash map.
> >>> It will grab spin_locks of other cpus
> >>> only if all previous cpus don't have free elements.
> >>> Most likely your map is actually full and doesn't have any free elems=
.
> >>> Since it's an lru it will force free an elem eventually.
> >>>
> >>
> >> Maybe I missed something, the map_update_elem function of LRU map is
> >> htab_lru_map_update_elem() and the htab_map_update_elem() above is the
> >> map_update_elem function of hash map.
> >> Because of the implementation of percpu freelist used in hash map, it
> >> will spin_lock all other CPUs when there is no free elements.
> >
> > Ahh. Right. Then what's the point of optimizing the error case
> > at the expense of the fast path?
> >
>
> Yes, this patch only optimized the very bad case that no free elements le=
ft,
> and add atomic operation in the fast path. Maybe the better workaround is=
 not
> allowing full hash map in our case or using LRU map?

No idea, since you haven't explained your use case.

> But the problem of spinlock contention also exist even when the map is no=
t full,
> like some CPUs run out of its freelist but other CPUs seldom used, then h=
ave to
> grab those CPUs' spinlock to get free element.

In theory that would be correct. Do you see it in practice?
Please describe the use case.

> Should we change the current implementation of percpu freelist to percpu =
lockless freelist?

Like llist.h ? That was tried already and for typical hash map usage
it's slower than percpu free list.
Many progs still do a lot of hash map update/delete on all cpus at once.
That is the use case hashmap optimized for.
Please see commit 6c9059817432 ("bpf: pre-allocate hash map elements")
that also lists different alternative algorithms that were benchmarked.
