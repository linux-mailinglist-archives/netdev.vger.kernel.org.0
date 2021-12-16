Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453E9477B78
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhLPSYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbhLPSYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:24:51 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD2EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 10:24:50 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id kj6so105121qvb.2
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 10:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3bQug7Q3Y8bGfDQ90oiL7YlAL/sesqoY0B+mdgASAE=;
        b=ihLB1h+Rgl72xRpn+k9ZhT1kdNXT+Nqs4XGJHZ7OaLplnDAJe3aNTJ15nJd5m8VUmW
         Wh1NoK7hOl/+m7vRS0rM3Ij/VbmElam8MPFWKTU5DMSYtWGozNwzKPoaGDR2duRt7UqG
         mlATVlZmF1FM9zA8EwGpFzZG7TKPf3zCHULt4U6d8PGBKNsmXonALM5Q6QvNmHxbn31g
         Db7ogFshTMtcoCF3OB2ohrUkCYJEs37POuMpJ5eiDyUwWG2t0niKCxQ0qk1TKj6cuuPu
         BrdbI5MgXIRD5XP4giDSFdrjtsT3BcNMA9U2DMHRn5KnsyfSjIk047tb9taXZCBpBkSf
         A/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3bQug7Q3Y8bGfDQ90oiL7YlAL/sesqoY0B+mdgASAE=;
        b=lqJOr8D9JCz6lC4q0932NGmhpaSHwG0pgrjn8ahG+G6wkDXlBmxuex3oLCrvG1ROFx
         aU7XBfjR+1nIyKbHaLE2K7+pZG0T+XMRrl54nQl06x9QArVvyDsOXsCWEj/2r3YQqc2S
         iEMPjLyDRjAaI7Ce4U27ksrZtmm3PRXEnMWFfoLVdaLNdryE6SpaQMth/vnB4vo6nrg6
         USqZJGUzttgqqp1cWRShOUCBnytUh+3fjDC9pLrFOezf1K5023iPfvfjs9u7uU1mHcVl
         HRgBK6Hq8YuA9A6Xlt9q0INpDeYfp8v9QsSurJwzyr2BeP1FwYAuT44p0UNuMtrfc6va
         0Ccw==
X-Gm-Message-State: AOAM53276uKDp4CjrqKbTO/cVZqHrGncy3zrxIcFRLRyBFBhpYDKKH0T
        kcEAEmsN8Wm0HYynoWWPg13Tj5ylJKBKdf5X3ybxG2++0FwPpQ==
X-Google-Smtp-Source: ABdhPJxmfD/HFoD7QRvwBZ38fcHdjZTFJJJt0+kkFuzoNVWsCXU+XmZlr3QxbwmDKkh25oZF5D6rr6K+FVIIqjnvfD4=
X-Received: by 2002:a05:6214:d88:: with SMTP id e8mr7230680qve.80.1639679089762;
 Thu, 16 Dec 2021 10:24:49 -0800 (PST)
MIME-Version: 1.0
References: <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com> <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com> <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com> <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
 <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com> <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 16 Dec 2021 10:24:38 -0800
Message-ID: <CAKH8qBuAZoVQddMUkyhur=WyQO5b=z9eom1RAwgwraXg2WTj5w@mail.gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 10:14 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
> > On 12/15/21 22:07, Stanislav Fomichev wrote:
> > > On Wed, Dec 15, 2021 at 11:55 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > >
> > > > On 12/15/21 19:15, Stanislav Fomichev wrote:
> > > > > On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > > > >
> > > > > > On 12/15/21 18:24, sdf@google.com wrote:
> > [...]
> > > > > > > I can probably do more experiments on my side once your patch is
> > > > > > > accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
> > > > > > > If you claim there is visible overhead for a direct call then there
> > > > > > > should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
> > > > > > > well.
> > > > > >
> > > > > > Interesting, sounds getsockopt might be performance sensitive to
> > > > > > someone.
> > > > > >
> > > > > > FWIW, I forgot to mention that for testing tx I'm using io_uring
> > > > > > (for both zc and not) with good submission batching.
> > > > >
> > > > > Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
> > > > > more details in 9cacf81f8161, it was pretty visible under perf.
> > > > > That's why I'm a bit skeptical of your claims of direct calls being
> > > > > somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).
> > > >
> > > > migrate_disable/enable together were taking somewhat in-between
> > > > 1% and 1.5% in profiling, don't remember the exact number. The rest
> > > > should be from rcu_read_lock/unlock() in BPF_PROG_RUN_ARRAY_CG_FLAGS()
> > > > and other extra bits on the way.
> > >
> > > You probably have a preemptiple kernel and preemptible rcu which most
> > > likely explains why you see the overhead and I won't (non-preemptible
> > > kernel in our env, rcu_read_lock is essentially a nop, just a compiler
> > > barrier).
> >
> > Right. For reference tried out non-preemptible, perf shows the function
> > taking 0.8% with a NIC and 1.2% with a dummy netdev.
> >
> >
> > > > I'm skeptical I'll be able to measure inlining one function,
> > > > variability between boots/runs is usually greater and would hide it.
> > >
> > > Right, that's why I suggested to mirror what we do in set/getsockopt
> > > instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
> > > to you, Martin and the rest.
> I also suggested to try to stay with one way for fullsock context in v2
> but it is for code readability reason.
>
> How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
> in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?

SG!

> It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
> want to check if there is bpf to run before proceeding everything else
> and then I don't need to jump to the non-inline function itself to see
> if there is other prog array empty check.
>
> Stan, do you have concern on an extra inlined sock_cgroup_ptr()
> when there is bpf prog to run for set/getsockopt()?  I think
> it should be mostly noise from looking at
> __cgroup_bpf_run_filter_*sockopt()?

Yeah, my concern is also mostly about readability/consistency. Either
__cgroup_bpf_prog_array_is_empty everywhere or this new
CGROUP_BPF_TYPE_ENABLED everywhere. I'm slightly leaning towards
__cgroup_bpf_prog_array_is_empty because I don't believe direct
function calls add any visible overhead and macros are ugly :-) But
either way is fine as long as it looks consistent.
