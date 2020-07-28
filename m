Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2942823124D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732672AbgG1TRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgG1TRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:17:03 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C073C061794;
        Tue, 28 Jul 2020 12:17:03 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b79so19785279qkg.9;
        Tue, 28 Jul 2020 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gOr8dfaejifYw9jU6Kda38E3nkEbRCrHeHIL/mLht1M=;
        b=otDe5YRwMr9ZjZkUAfDqHdRBs1piZUTe4CTkYv5N3vMilg+mwSd8u3nh4gsItkTo7x
         keGv4P2iTlq5DIJzJbBMN4GTDiOMD0OpJh1C2xP3g76mfiKGLMDy95jV6wJvHN/3sJmr
         mfk8p/IBXfxF+72g5+Qndb/0bmn+YszTDATRnNlgDVDtEaz7a4ax1jGDLrpcj2KFhDlm
         Q7ydb47hnhDV3tab+g7WDUAhUX+rkiq43CLewaraeGHwV047qEpRBRM8Fy5eKU5uNXeY
         hK52o5YD5CrotoRkYnlXey5UPBLKr8Mvz0KnkI1keJ43PNod7JGSjVNEwkF+sycxnOUC
         Udxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gOr8dfaejifYw9jU6Kda38E3nkEbRCrHeHIL/mLht1M=;
        b=WjsS7K/bShsv4h95+KvPV365kVrv7MvjmNC7TbGWF42ZgvKeMrP3G5Y35opFIxzRX3
         fjijdVG860/kW0ipkK+Pk/WMrpmmrn3yccI33QpMtDtnQ1hR7vz1LLPDBXd6OmTg6EfV
         6t6AhI1lJrJkJYnuq/ozEVUHp1vRVfgNfd9as2LwTb5YLtZhtEL5nUa+xJ8lqwNdAlHJ
         CEFyTm6fG9FdcVsSRMs8enoPXRRvIWxDpUqy657hLzyENFU/LHtU9tWZTH6ZkGuhUm65
         JOhIu3ScmZ9vQE3/zRZQJYVGhcDg/lXAY6fV/O3famQB02NwALF0F15kXtEcQPyfImjl
         IjTw==
X-Gm-Message-State: AOAM53175GuBPsR8Yd0FhMvk8AnZWQ4ni7tBpEEqQAE3fbS9GrN4oLex
        mn6QcbMVsJxQ71tVdkx/H3dp/QzTuNYKmEfOmAw=
X-Google-Smtp-Source: ABdhPJwbOmokpEJOP1fIf5cZoIesMV+H3fTQ9slHu7TTfq77cCg4b9LhjmIxLd0pBzSqpXX2DL3NsX7P95qN921rMQ0=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr3962581qkt.449.1595963822395;
 Tue, 28 Jul 2020 12:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-28-guro@fb.com>
 <CAPhsuW7jWztOVeeiRNBRK4JC_MS41qUSxzEDMywb-6=Don-ndA@mail.gmail.com>
 <CAEf4BzaOX_gc8F20xrHxiKFxYbwULK130m1A49rnMoT7T74T3Q@mail.gmail.com>
 <CAPhsuW5qBxWibkYMAvS0s6yLj-gijHqy9rVxSWCk5Xr+bXqtJg@mail.gmail.com> <20200728190830.GB410810@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200728190830.GB410810@carbon.DHCP.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:16:51 -0700
Message-ID: <CAEf4BzZuj9d_WT4nJ6c_W4uAnT2_4mBOXCbi1q1w97568rd4eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 27/35] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
To:     Roman Gushchin <guro@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:09 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Jul 27, 2020 at 11:06:42PM -0700, Song Liu wrote:
> > On Mon, Jul 27, 2020 at 10:58 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jul 27, 2020 at 10:47 PM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Mon, Jul 27, 2020 at 12:26 PM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > > > Remove rlimit-based accounting infrastructure code, which is not used
> > > > > anymore.
> > > > >
> > > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > [...]
> > > > >
> > > > >  static void bpf_map_put_uref(struct bpf_map *map)
> > > > > @@ -541,7 +484,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
> > > > >                    "value_size:\t%u\n"
> > > > >                    "max_entries:\t%u\n"
> > > > >                    "map_flags:\t%#x\n"
> > > > > -                  "memlock:\t%llu\n"
> > > > > +                  "memlock:\t%llu\n" /* deprecated */
> > > >
> > > > I am not sure whether we can deprecate this one.. How difficult is it
> > > > to keep this statistics?
> > > >
> > >
> > > It's factually correct now, that BPF map doesn't use any memlock memory, no?
>
> Right.
>
> >
> > I am not sure whether memlock really means memlock for all users... I bet there
> > are users who use memlock to check total memory used by the map.
>
> But this is just the part of struct bpf_map, so I agree with Andrii,
> it's a safe check.
>
> >
> > >
> > > This is actually one way to detect whether RLIMIT_MEMLOCK is necessary
> > > or not: create a small map, check if it's fdinfo has memlock: 0 or not
> > > :)
> >
> > If we do show memlock=0, this is a good check...
>
> The only question I have if it's worth checking at all? Bumping the rlimit
> is a way cheaper operation than creating a temporarily map and checking its
> properties.
>

for perf and libbpf -- I think it's totally worth it. Bumping
RLIMIT_MEMLOCK automatically means potentially messing up some other
parts of the system (e.g., BCC just bumps it to INFINITY allowing to
over-allocate too much memory, potentially, for unrelated applications
that do rely on RLIMIT_MEMLOCK). It's one of the reasons why libbpf
doesn't do it automatically, actually. So knowing when this is not
necessary, will allow to improve diagnostic messages by libbpf, and
would just avoid potentially risky operation by perf/BCC/etc.

> So is there any win in comparison to just leaving the userspace code* as it is
> for now?
>
> * except runqslower and samples
