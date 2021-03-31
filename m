Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BD034FCE1
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhCaJcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbhCaJcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:32:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C8EC061574;
        Wed, 31 Mar 2021 02:32:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h20so7607900plr.4;
        Wed, 31 Mar 2021 02:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ShH/N+LuitDskBEJpZBlqa67DkTm7tlQyc3A8jlCGS4=;
        b=UtRNvJqcOt5ePiZVPOcbruviGUQSupiQWNq7jOFp+i0A/pXW9vKyMEk83Qy+U/Jp7j
         peH02WF8tp7zZLGCoQiVgElbOemKzfzlwbJJVhrOEqmcRzuXVYZq62iMGALv3jrTYUJ4
         hwSbp0Ja/9J8tEf9XyI4dhz+OGF/R1YUvld7huQoo+uhBthMahkfAizHEaLbkabPtgZq
         X7z96OTaJudoLILxLWnOs+WHrkKXFylehpkbt+QxiGSxFEdr5LSIzggQjQSvPPGVepYe
         SSQ9H+i46PXpPTn+4Bk1u9Qd8o6lg8meAzoGKswxcGmvSErCrnT9gOrDSoCnRIs1SYc+
         p8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ShH/N+LuitDskBEJpZBlqa67DkTm7tlQyc3A8jlCGS4=;
        b=p1MUQA7rBIKLn7gSIjb2+ZVY5clQ4d+VHRYO4snviVq26tZ4YFWufrI7PKb7Mv1jln
         a9E3zkBJGY2nMFi1x+4AsC/WdsWt8G16Wb++z0CLSzuAZsfFH5YvG+7KlNtPLJ8e7xi5
         /pHmJR/06mB2oATUnfx/7yJA3veKfRTGDCQeAf+yBuhPt4fMjfZ7NtwXl8nE+zaDswmf
         3wIRw8hAFyiIvRVIIQ32WEpN6XPBhISxomn4AojJNMp0dPUDPBRPv26PgJr9bw4HuQ0v
         0no27FYy8G+keZHfKXfFwE9lmXZJjTL2hXgnMhFGx0M0SeLJnzVub1lxZnPYXQ02doFi
         EOAg==
X-Gm-Message-State: AOAM533UKOg32knrScBOTIVcUrU/GcUcfclKbRH13xZHtiK15YBf/DfR
        X2ef05iUcQmnyxqnfyzxy7A=
X-Google-Smtp-Source: ABdhPJxYtSB6s7l7Dnrg2H92pPBeuZr0752z5hSuE6HiWx0i4BvnAGhHPckHkloZ9IzWb054zUTTBw==
X-Received: by 2002:a17:90a:f314:: with SMTP id ca20mr2604192pjb.136.1617183152567;
        Wed, 31 Mar 2021 02:32:32 -0700 (PDT)
Received: from localhost ([47.9.181.160])
        by smtp.gmail.com with ESMTPSA id k13sm1647439pfc.50.2021.03.31.02.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 02:32:32 -0700 (PDT)
Date:   Wed, 31 Mar 2021 15:02:29 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210331093026.hbxjbu43dnlm6mr4@apollo>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <87czvgqrcj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czvgqrcj.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 02:41:40AM IST, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sun, Mar 28, 2021 at 1:11 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> >>
> >> On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
> >> > Is there some succinct but complete enough documentation/tutorial/etc
> >> > that I can reasonably read to understand kernel APIs provided by TC
> >> > (w.r.t. BPF, of course). I'm trying to wrap my head around this and
> >> > whether API makes sense or not. Please share links, if you have some.
> >> >
> >>
> >> Hi Andrii,
> >>
> >> Unfortunately for the kernel API part, I couldn't find any when I was working
> >> on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
> >> m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
> >> act_bpf.c) to grok anything I didn't understand. There's also similar code in
> >> libnl (lib/route/{act,cls}.c).
> >>
> >> Other than that, these resources were useful (perhaps you already went through
> >> some/all of them):
> >>
> >> https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
> >> https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
> >> tc(8), and tc-bpf(8) man pages
> >>
> >> I hope this is helpful!
> >
> > Thanks! I'll take a look. Sorry, I'm a bit behind with all the stuff,
> > trying to catch up.
> >
> > I was just wondering if it would be more natural instead of having
> > _dev _block variants and having to specify __u32 ifindex, __u32
> > parent_id, __u32 protocol, to have some struct specifying TC
> > "destination"? Maybe not, but I thought I'd bring this up early. So
> > you'd have just bpf_tc_cls_attach(), and you'd so something like
> >
> > bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, parent_id, protocol))
> >
> > or
> >
> > bpf_tc_cls_attach(prog_fd, TC_BLOCK(block_idx, protocol))
> >
> > ? Or it's taking it too far?
>
> Hmm, that's not a bad idea, actually. An earlier version of the series
> did have only a single set of functions, but with way too many
> arguments, which is why we ended up agreeing to split them. But
> encapsulating the destination in a separate struct and combining it with
> some helper macros might just make this work! I like it! Kumar, WDYT?
>

SGTM.

> -Toke
>

--
Kartikeya
