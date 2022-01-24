Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C84498845
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245234AbiAXSZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiAXSZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:25:19 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D4CC06173D
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:25:19 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id de18so29391qkb.0
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K6etE/ly2g0VeXSdeIkDpJwMBD9Oa8SeCLG1zWSfgrU=;
        b=Pcs1V+CdhZCKff3WNADfaPdxie2c9AoWyjHN3xGrBOrslo+5Ry9Su4Wg81Yg58YjO+
         e5PtYQEs05Ne337BKKtfad0inw/4ziYXpp3kIwYQVfkfLnKx3wJNjIuaMh/X2QszO+Zl
         9kyxYlWKd3aiMhUU7Ow7VTonasdUwHVTJPUcv/aYE1uyGc9M2WJtUVTM5Y2vLsYjTIeJ
         z0087J0F1jlYYFkzLgeejHJCAqKyDFadvc5knPzsPD7nHcSIQl27ffC4veEliT7/PpD5
         JjP/3wJ0hs7WCnfe1pNTb+rX5iQcEstoRA3wi8llqhD4Sp0J/82l7yfrEcGUOn3IaMTv
         ozQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K6etE/ly2g0VeXSdeIkDpJwMBD9Oa8SeCLG1zWSfgrU=;
        b=x69VTPHHiOflgCzyw1zEjtcTW+m7BDe/cxpbuWb16PJyyL42VkI+VKSkXHmixmZHFj
         Yu2uyd7zzb5WUe5MNvO7rBNwpfHsxcpcYvvIOLaznuBHWm2COSsz50yomvafOMHcL7E/
         b7STpwZs4YLwppD5ZV+KaR9PfhdGRFu4INP1U5gZXZTkhS/F+CjSNsfEX4+DWxAlhD0Y
         Zh8wu8rkAYqlcViEJ+JDOhSjchNvX+sr6HMq0RyoOE/F2/pQg2cmIkAM/5QR/XgN0fGW
         2sV2SnjrwvQmtAp1c/XWnK7TQvK0gqaQx3CLdZaB2LOpchZZDXmWB+1h0zNMwD/2YcKb
         Yk2w==
X-Gm-Message-State: AOAM531SiVDuQyFm/oYqD82Z7QuJI2+4CBMVo8p4NQMGbtuFCjhxnlgp
        tBe8Ps9sp5CCUX8p709dlWDOS/gC8rGtWIkdP1hclA==
X-Google-Smtp-Source: ABdhPJwVmpBJh+L3pkv2NUpvbujhb1GpxAtUDey9JzaQf/umiNBIUxrPnv3lzPWtoX0EddYiSt5MEAJmYzwoi9JSu7w=
X-Received: by 2002:a05:620a:4689:: with SMTP id bq9mr12401158qkb.496.1643048718462;
 Mon, 24 Jan 2022 10:25:18 -0800 (PST)
MIME-Version: 1.0
References: <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com> <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com> <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com> <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
 <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com> <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuAZoVQddMUkyhur=WyQO5b=z9eom1RAwgwraXg2WTj5w@mail.gmail.com> <9b8632f9-6d7a-738f-78dc-0287d441d1cc@gmail.com>
In-Reply-To: <9b8632f9-6d7a-738f-78dc-0287d441d1cc@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 24 Jan 2022 10:25:07 -0800
Message-ID: <CAKH8qBvX8_vy0aYhiO-do0rh3y3CzgDGfHqt1bB6uRcr_DxncQ@mail.gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 7:49 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 12/16/21 18:24, Stanislav Fomichev wrote:
> > On Thu, Dec 16, 2021 at 10:14 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >> On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
> >>> On 12/15/21 22:07, Stanislav Fomichev wrote:
> >>>>> I'm skeptical I'll be able to measure inlining one function,
> >>>>> variability between boots/runs is usually greater and would hide it.
> >>>>
> >>>> Right, that's why I suggested to mirror what we do in set/getsockopt
> >>>> instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
> >>>> to you, Martin and the rest.
> >> I also suggested to try to stay with one way for fullsock context in v2
> >> but it is for code readability reason.
> >>
> >> How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
> >> in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?
> >
> > SG!
> >
> >> It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
> >> want to check if there is bpf to run before proceeding everything else
> >> and then I don't need to jump to the non-inline function itself to see
> >> if there is other prog array empty check.
> >>
> >> Stan, do you have concern on an extra inlined sock_cgroup_ptr()
> >> when there is bpf prog to run for set/getsockopt()?  I think
> >> it should be mostly noise from looking at
> >> __cgroup_bpf_run_filter_*sockopt()?
> >
> > Yeah, my concern is also mostly about readability/consistency. Either
> > __cgroup_bpf_prog_array_is_empty everywhere or this new
> > CGROUP_BPF_TYPE_ENABLED everywhere. I'm slightly leaning towards
> > __cgroup_bpf_prog_array_is_empty because I don't believe direct
> > function calls add any visible overhead and macros are ugly :-) But
> > either way is fine as long as it looks consistent.
>
> Martin, Stanislav, do you think it's good to go? Any other concerns?
> It feels it might end with bikeshedding and would be great to finally
> get it done, especially since I find the issue to be pretty simple.

I'll leave it up to the bpf maintainers/reviewers. Personally, I'd
still prefer a respin with a consistent
__cgroup_bpf_prog_array_is_empty or CGROUP_BPF_TYPE_ENABLED everywhere
(shouldn't be a lot of effort?)
