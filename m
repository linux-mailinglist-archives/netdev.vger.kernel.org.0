Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63D2FA722
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKMDTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:19:47 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46978 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfKMDTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:19:47 -0500
Received: by mail-qt1-f196.google.com with SMTP id r20so951022qtp.13;
        Tue, 12 Nov 2019 19:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jABndcZBzvuqmV48EOJ4ssQ9rvNduL7vt2CVS2VLZH8=;
        b=ofaOLRa0W+MVcy4OnARzIS0FJY8qn5H/9oeHdm9+52RmllY4+zxBdtheiFHBy9fJGM
         oRhI0jm+ejM/5cLwiVG73L0kR0OwBxdcxeldim2jBdpEHsnWT8woQaBB/XstC1GWYWnW
         QBo8uZlLFT0Rsj5HSaSmQ9kw1iOfSAzvX9NSbvkiVdWS23b3B2AUlgmx12+o/naS8djy
         puU+v5rkFrSfSO5NIJgDxbMZnMVLZGgo3SNammnhdEWwbJHsU89x3UGTcYENlR6ArFZJ
         b3fD81Z3uYM0ZQ1vvrgJ9QGFHPFHpPU/vDLvtfbwsZ2I2PDzu3s5p1lY8w8K68mvGyow
         0WCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jABndcZBzvuqmV48EOJ4ssQ9rvNduL7vt2CVS2VLZH8=;
        b=RH5XmhhFm7ZnfT7BBXCZhYhj2GPjOoLGqtF7O6SdSYTUNIWT3T5TRzDi2VVRCVLxHv
         MA4yElb6T9aeEznnvA8W+VOXhDq9cJXQEF0mvmZ5L+s4QuvrCIWS3o8erC76BEyZgVX3
         nfN6bDd6Mv1JHyIjFdJa+xgywj9ABDfO0pDaePUKkhSs0+HRxedMqCXqmUo7XWImJy77
         2qenobj0QDx39XMnJdD7RdPzPB8YZ+RkA+eyn89bwUwnF7Q4DOZYGbcx88MLCojPUe8+
         +2xTuZuLRcKvBH3SvCplxAY+4TX4aiWgXysh5EbiJyDWxg4ppyMF2Mtoc1uF5zrYEzS7
         a4Og==
X-Gm-Message-State: APjAAAXA+pJSXcDsTZkMljQ1Kh7C9sQYQhrRuaEnIcIdhkGFNOh013q2
        ZpnQiyg/Nr52mvu39CEpbb2pUPGQeB1Djkt4AYw=
X-Google-Smtp-Source: APXvYqx+YGq/3B6qg3YAmz2pmE01fHQQk079Cq/uqzz6oiOHD8gsD4nZnmZrkmEiKrj/2tWOGxtF4NhqaA6UNasdOak=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr628550qtj.93.1573615185793;
 Tue, 12 Nov 2019 19:19:45 -0800 (PST)
MIME-Version: 1.0
References: <20191109080633.2855561-1-andriin@fb.com> <20191109080633.2855561-2-andriin@fb.com>
 <20191111103743.1c3a38a3@cakuba> <CAEf4Bzay-sCd5+5Y1+toJuEd6vNh+R7pkosYA7V7wDqTdoDxdw@mail.gmail.com>
 <20191112111750.2168b131@cakuba> <CAEf4Bzbx0WvgX9uGF4U1HM41m6kfdvWHCeYBSBRnQhR3egGy5w@mail.gmail.com>
 <20191112143817.0c0eb768@cakuba>
In-Reply-To: <20191112143817.0c0eb768@cakuba>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Nov 2019 19:19:33 -0800
Message-ID: <CAEf4Bzb5y3eEq4QU_3zdGJts4PeSVGr1YVmmWjTgs=LOf4PLKw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 2:38 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 12 Nov 2019 14:03:50 -0800, Andrii Nakryiko wrote:
> > On Tue, Nov 12, 2019 at 11:17 AM Jakub Kicinski wrote:
> > > On Mon, 11 Nov 2019 18:06:42 -0800, Andrii Nakryiko wrote:
> > > > So let's say if sizeof(struct bpf_array) is 300, then I'd have to either:
> > > >
> > > > - somehow make sure that I allocate 4k (for data) + 300 (for struct
> > > > bpf_array) in such a way that those 4k of data are 4k-aligned. Is
> > > > there any way to do that?
> > > > - assuming there isn't, then another way would be to allocate entire
> > > > 4k page for struct bpf_array itself, but put it at the end of that
> > > > page, so that 4k of data is 4k-aligned. While wasteful, the bigger
> > > > problem is that pointer to bpf_array is not a pointer to allocated
> > > > memory anymore, so we'd need to remember that and adjust address
> > > > before calling vfree().
> > > >
> > > > Were you suggesting #2 as a solution? Or am I missing some other way to do this?
> > >
> > > I am suggesting #2, that's the way to do it in the kernel.
> >
> > So I'm concerned about this approach, because it feels like a bunch of
> > unnecessarily wasted memory. While there is no way around doing
> > round_up(PAGE_SIZE) for data itself, it certainly is not necessary to
> > waste almost entire page for struct bpf_array. And given this is going
> > to be used for BPF maps backing global variables, there most probably
> > will be at least 3 (.data, .bss, .rodata) per each program, and could
> > be more. Also, while on x86_64 page is 4k, on other architectures it
> > can be up to 64KB, so this seems wasteful.
>
> With the extra mutex and int you grew struct bpf_map from 192B to 256B,
> that's for every map on the system, unconditionally, and array map has
> an extra pointer even if it doesn't need it.
>
> Increasing "wasted" space when an opt-in feature is selected doesn't
> seem all that terrible to me, especially that the overhead of aligning
> up map size to page size is already necessary.

Well, I've been talking about one more extra page for struct bpf_array
itself, on top of what we already potentially waste for mmap()'ing
array data. But I went ahead and posted v3 with layout we discussed
here, aligning array->value on page boundary. Let's see if you like it
better.

>
> > What's your concern exactly with the way it's implemented in this patch?
>
> Judging by other threads we seem to care about performance of BPF
> (rightly so). Doing an extra pointer deref for every static data access
> seems like an obvious waste.
>
> But then again, it's just an obvious suggestion, take it or leave it..
