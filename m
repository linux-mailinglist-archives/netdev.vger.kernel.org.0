Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC362646C3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 15:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgIJNTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 09:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730165AbgIJNSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:18:48 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F28AC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 06:18:01 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y194so3353088vsc.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 06:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VPg+zruk0U2NFpy/EQmoCT9wT1bxwhyLUiwslfit3Xk=;
        b=Vh7pg4GoExk9Olog7Yim+i5ia/KNKV/y4uSCAiva/o4AJOxZ6KD53YluSGxYqCL0A9
         wZff47wG9KOI7oGSVLl1kZYbu9dFqkj2WT6xsh4EAYputzv8H4CF3dvL0OY7GYd/fk9U
         Lcbh8JzxHihHNpDJwBCH5E1DDEJYagfW/QkGOArNIo3euJwnQZ8AOpiT1QlZZP1q3shO
         Hugb4MRReSxI0NCJnmskpfGcnZfFa5pKomlaG70DTmkXUS4bsMWKABHfgkcJEZo4p6eV
         rxTMGYodbSgRHjhLzFQjuBXehZf6GIIKNWqrZrx0BMaYSKLNeeYwHyuXC4OE0TMiZ3Bv
         g9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VPg+zruk0U2NFpy/EQmoCT9wT1bxwhyLUiwslfit3Xk=;
        b=tBFzCX8O5Yjzy1xE+DIcqHLDtRYmF5HVwMdcciEaY5p6lN5LWxQ3WKZ71SKoCb3xnw
         uvx2DVYRToy6+n9l/UO/uOYyVoKr7RR5kplAEhnfcM9MEPADy1M9t7WedPg9HUyKTM6p
         N4S0JKH+swibHUgTCfnqWKZZXMPjD0iIlGLxPl5eUafa82r9O4og2E7bs4Bz31fE5DOZ
         WyEnNPY2C/8UogMG0MhOzVUuYUTLCTXZvl/gxVKivDR5ECpVoyT3ctePv8B/W/PAlWIH
         9ejGB4ksiL51tNg5KeRfxJu9yikBH3Fmv72HaheYMBPYUOCSWIkZ2bCsOuZ/dWRBjfT7
         cG7Q==
X-Gm-Message-State: AOAM5336Vx15qNanXWPE1fBBoZ/dXfVPOWnl5TBXRyspGxRLkNvNvZRg
        7V7un+zPlmZOb/CI8yRmyE8x2aCpg5uczNOTTh5ERA==
X-Google-Smtp-Source: ABdhPJwn4iPulsKxfJZBZdyO9PUH1CKGcHX8Il88ooPViH7w6xoWZcjR0ZoaBdHTkkdT2oOZ/CwrHKl89wkKIFWpQtU=
X-Received: by 2002:a67:cf8c:: with SMTP id g12mr3714142vsm.4.1599743880178;
 Thu, 10 Sep 2020 06:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
 <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com>
 <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com> <CAADnVQ+8f0i9ffto05M0pZ_57pkiVnAQbHAQwD=kmCJp5MtVoQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+8f0i9ffto05M0pZ_57pkiVnAQbHAQwD=kmCJp5MtVoQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 10 Sep 2020 09:17:43 -0400
Message-ID: <CADVnQymRJ6-SSswjAgh+hU_5=bdp70yn-0oSS9_0-9_XmCYdxA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] tcp: increase flexibility of EBPF congestion
 control initialization
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, thanks everyone. I will rebase the series onto bpf-next and
include a patch with Martin's suggested follow-on cleanup. Will
resubmit ASAP.

thanks,
neal


On Thu, Sep 10, 2020 at 1:31 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 8:24 PM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Wed, Sep 9, 2020 at 8:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Sep 09, 2020 at 02:15:52PM -0400, Neal Cardwell wrote:
> > > > This patch series reorganizes TCP congestion control initialization so that if
> > > > EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> > > > by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> > > > congestion control module immediately, instead of having tcp_init_transfer()
> > > > later initialize the congestion control module.
> > > >
> > > > This increases flexibility for the EBPF code that runs at connection
> > > > establishment time, and simplifies the code.
> > > >
> > > > This has the following benefits:
> > > >
> > > > (1) This allows CC module customizations made by the EBPF called in
> > > >     tcp_init_transfer() to persist, and not be wiped out by a later
> > > >     call to tcp_init_congestion_control() in tcp_init_transfer().
> > > >
> > > > (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
> > > >     for existing code upstream that depends on the current order.
> > > >
> > > > (3) Does not cause 2 initializations for for CC in the case where the
> > > >     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
> > > >     algorithm.
> > > >
> > > > (4) Allows follow-on simplifications to the code in net/core/filter.c
> > > >     and net/ipv4/tcp_cong.c, which currently both have some complexity
> > > >     to special-case CC initialization to avoid double CC
> > > >     initialization if EBPF sets the CC.
> > > Thanks for this work.  Only have one nit in patch 3 for consideration.
> > >
> > > Acked-by: Martin KaFai Lau <kafai@fb.com>
> >
> > Thanks for the review! I like your suggestion in patch 3 to further
> > simplify the code. Do you mind submitting your idea for a follow-on
> > clean-up/refactor as a separate follow-on commit?
>
> I think it's better to be folded into this set.
> It needs rebase to bpf-next anyway.
