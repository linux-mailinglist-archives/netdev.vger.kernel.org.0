Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AAA49BDDB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiAYV13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 16:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiAYV13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 16:27:29 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F9FC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 13:27:29 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id y17so25165642qtx.9
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 13:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5SSh6nJHHvPVmsJSI+vEXdltA1GV2tgb9vC7RDs5Dw=;
        b=ecg4PDMzVWLxJkebhbl1fQpefiKywwl9qWbu4wGisfvshkHU8Je5+O+eBQkwffkjYS
         mkpasBUqDZb9584KWqzLYP07Y2gg/6hstu6VoOAVasDyvxGyr2YLdQoXAde1NliSiG/l
         U2vOcLTWgrN6SSRwn2bNGhPhPmyqjksasUX4XeasmykLTmdsbDV96ocfm+W7u6FCwt/u
         0W8zv8P2B6VbgPC0lE4C7ANmp2ThA3fTFbFFI2l7Elgssx4tkKqIYZthJ2uUkADpbCjb
         WiyA3qj1MaHdlkwNQ3nZtY4VDLxziKOX+FF2ipVV99OAkfrEBdAKeHVxa++Yhovq6tdh
         KxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5SSh6nJHHvPVmsJSI+vEXdltA1GV2tgb9vC7RDs5Dw=;
        b=IPzz4akrgCuDInwmwM7bagVPRTvh2Ssz9BeDF21XJzT130VVo5PddgDbUQQ/qo/rfm
         YRcjncv7gkNtuUVtxP/1HqrKEMQ8/y6Rax138cICedIyUtJxfv+68BcnOOu83S+yDpNR
         zfFtCFGMsQtLY2/EDjPClq9gfeUXPak826dGlogbAsDFO45Jx7I6QHlrkFfZm3LPf87B
         WTIAnkIUS+oI7FtN5mj9iyoyqUhVzbYY7FMy4XrK3cm1HlaPtzS5yWkTQsovz5AUkc3M
         FbL6u3wvknR/7xCUO2O+QbSfJazZkpfBJoAQajxmCog7kJyIuktc7rt8lWxoLARZ1nQu
         g/uQ==
X-Gm-Message-State: AOAM530ky2z580ZVhl+HC9eP7cD2NKq/lC61MH3lpAZYLGDX7wid0ssd
        OsRLEeHxY+n4xBzce4SkFF2LrwysytYRp4A6G5cclg==
X-Google-Smtp-Source: ABdhPJyeQavyvs3YFtYpuC19nWKfqoYonkE0/NbRWUStqzfvITyHg15jrXM0uRkM9BbFKYdvxUsQyDIIs56jEMAOPz8=
X-Received: by 2002:ac8:1083:: with SMTP id a3mr18184689qtj.125.1643146047873;
 Tue, 25 Jan 2022 13:27:27 -0800 (PST)
MIME-Version: 1.0
References: <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com> <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com> <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com> <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
 <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com> <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuAZoVQddMUkyhur=WyQO5b=z9eom1RAwgwraXg2WTj5w@mail.gmail.com>
 <9b8632f9-6d7a-738f-78dc-0287d441d1cc@gmail.com> <CAKH8qBvX8_vy0aYhiO-do0rh3y3CzgDGfHqt1bB6uRcr_DxncQ@mail.gmail.com>
 <ea0b2f62-9145-575e-d007-cce2c7244f77@gmail.com>
In-Reply-To: <ea0b2f62-9145-575e-d007-cce2c7244f77@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 25 Jan 2022 13:27:17 -0800
Message-ID: <CAKH8qBtGvWqLpE7Dy1kiTZc1MnVyJSKH1e-Nz0=KNEOrZFqEFw@mail.gmail.com>
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

On Tue, Jan 25, 2022 at 10:55 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 1/24/22 18:25, Stanislav Fomichev wrote:
> > On Mon, Jan 24, 2022 at 7:49 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 12/16/21 18:24, Stanislav Fomichev wrote:
> >>> On Thu, Dec 16, 2021 at 10:14 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >>>> On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
> >>>>> On 12/15/21 22:07, Stanislav Fomichev wrote:
> >>>>>>> I'm skeptical I'll be able to measure inlining one function,
> >>>>>>> variability between boots/runs is usually greater and would hide it.
> >>>>>>
> >>>>>> Right, that's why I suggested to mirror what we do in set/getsockopt
> >>>>>> instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
> >>>>>> to you, Martin and the rest.
> >>>> I also suggested to try to stay with one way for fullsock context in v2
> >>>> but it is for code readability reason.
> >>>>
> >>>> How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
> >>>> in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?
> >>>
> >>> SG!
> >>>
> >>>> It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
> >>>> want to check if there is bpf to run before proceeding everything else
> >>>> and then I don't need to jump to the non-inline function itself to see
> >>>> if there is other prog array empty check.
> >>>>
> >>>> Stan, do you have concern on an extra inlined sock_cgroup_ptr()
> >>>> when there is bpf prog to run for set/getsockopt()?  I think
> >>>> it should be mostly noise from looking at
> >>>> __cgroup_bpf_run_filter_*sockopt()?
> >>>
> >>> Yeah, my concern is also mostly about readability/consistency. Either
> >>> __cgroup_bpf_prog_array_is_empty everywhere or this new
> >>> CGROUP_BPF_TYPE_ENABLED everywhere. I'm slightly leaning towards
> >>> __cgroup_bpf_prog_array_is_empty because I don't believe direct
> >>> function calls add any visible overhead and macros are ugly :-) But
> >>> either way is fine as long as it looks consistent.
> >>
> >> Martin, Stanislav, do you think it's good to go? Any other concerns?
> >> It feels it might end with bikeshedding and would be great to finally
> >> get it done, especially since I find the issue to be pretty simple.
> >
> > I'll leave it up to the bpf maintainers/reviewers. Personally, I'd
> > still prefer a respin with a consistent
> > __cgroup_bpf_prog_array_is_empty or CGROUP_BPF_TYPE_ENABLED everywhere
> > (shouldn't be a lot of effort?)
>
> I can make CGROUP_BPF_TYPE_ENABLED() used everywhere, np.
>
> I'll leave out unification with cgroup_bpf_enabled() as don't
> really understand the fullsock dancing in
> BPF_CGROUP_RUN_PROG_INET_EGRESS(). Any idea whether it's needed
> and/or how to shove it out of inlined checks?

I'm not sure we can do anything better than whatever you did in your
patch. This request_sk->full_sk conversion is needed because
request_sk doesn't really have any cgroup association and we need to
pull it from the listener ("full_sk"). So you wave to get full_sk and
then run CGROUP_BPF_TYPE_ENABLED on it.
