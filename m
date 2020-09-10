Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92315263C76
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 07:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgIJFbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 01:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgIJFb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 01:31:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B66C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 22:31:25 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id b19so6479295lji.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 22:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XCigWya46aIE3KcFQFVYNjVQ5WTp8MhnCC5iKBEj3mQ=;
        b=TO/YScusohGWY7hDZ9uyBWWjSPE1iqWjxFuHmz00zzW7fodnvGZA+7yEJskrId42yQ
         VUsuooHrJeJKFfb30/ncaw+9QuGBZr2eE8AYwfUndKcWz0oQPImFwzES1+KbndT3szpw
         S8wtDe7d+FDuW8/zjWfpsTZEXuvg5d1dwriz0rRikSHtF4+TRcPo3J6l8mFs+qLwj5BE
         C7bEL3c/aFSLqS6YixIjrff/AHRs/bt5of3Lv75v+VA21hptaz3Rj9NqOlUi2w28cpdr
         sCloKs0w3RSSKSaAMMHJSbGqz1V/PHJ1GK/oos380WSb3UL0GJ7YcMOOVDnjOz1vtPQn
         hJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XCigWya46aIE3KcFQFVYNjVQ5WTp8MhnCC5iKBEj3mQ=;
        b=YW6dnG3sQuPnO+w6t2Pkz/DQes6svU4YGyHis0XSe9dDEhpWBKcNDEsCWyWbHAYfwg
         YAG2qBXg3ObGYMz06b7MW6Y/AQGmBjfSy+SSCYkpNZ3JCVOOpr2Z+LlNjgSAuGgtDXUd
         +THndj7icNTtS8fjp3ZAQLWOq6QrjHfvEfPQKGXmAncyDFmVR0889qS9hjOXiEr+VDWU
         zGW7z9an7NUxHY8kcLhTe0+TKy6Q668mKyqo/sUNJi22e4J5fwVRF2lqVC6tgYnG+4Vf
         B9b5xtRHYMNChSF0KIQyFVDHauoNZjeNRGrbEpfkA9o+5ga276o5tAfTbFuvXG6hL9Vv
         tYYQ==
X-Gm-Message-State: AOAM531FwyLUP0PuFclhVrcGGzqk2ZPeRJ6Q2s41U06BvkVRT5YlXmU9
        S47RCIuQLEMwEi5yv7swchY9YpjpfWzprb1xP4G5x0zU
X-Google-Smtp-Source: ABdhPJyVbbVlfbNq5QJu88tZzC/H8UW3x19+xUoLWojGTeX8DbTa4xZX3Jzy9HRgKpB8Y/1O3n3drsE5tBiDD+otg8w=
X-Received: by 2002:a05:651c:cb:: with SMTP id 11mr3647010ljr.2.1599715883466;
 Wed, 09 Sep 2020 22:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
 <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com> <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com>
In-Reply-To: <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Sep 2020 22:31:12 -0700
Message-ID: <CAADnVQ+8f0i9ffto05M0pZ_57pkiVnAQbHAQwD=kmCJp5MtVoQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] tcp: increase flexibility of EBPF congestion
 control initialization
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:24 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Sep 9, 2020 at 8:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Sep 09, 2020 at 02:15:52PM -0400, Neal Cardwell wrote:
> > > This patch series reorganizes TCP congestion control initialization so that if
> > > EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> > > by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> > > congestion control module immediately, instead of having tcp_init_transfer()
> > > later initialize the congestion control module.
> > >
> > > This increases flexibility for the EBPF code that runs at connection
> > > establishment time, and simplifies the code.
> > >
> > > This has the following benefits:
> > >
> > > (1) This allows CC module customizations made by the EBPF called in
> > >     tcp_init_transfer() to persist, and not be wiped out by a later
> > >     call to tcp_init_congestion_control() in tcp_init_transfer().
> > >
> > > (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
> > >     for existing code upstream that depends on the current order.
> > >
> > > (3) Does not cause 2 initializations for for CC in the case where the
> > >     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
> > >     algorithm.
> > >
> > > (4) Allows follow-on simplifications to the code in net/core/filter.c
> > >     and net/ipv4/tcp_cong.c, which currently both have some complexity
> > >     to special-case CC initialization to avoid double CC
> > >     initialization if EBPF sets the CC.
> > Thanks for this work.  Only have one nit in patch 3 for consideration.
> >
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
>
> Thanks for the review! I like your suggestion in patch 3 to further
> simplify the code. Do you mind submitting your idea for a follow-on
> clean-up/refactor as a separate follow-on commit?

I think it's better to be folded into this set.
It needs rebase to bpf-next anyway.
