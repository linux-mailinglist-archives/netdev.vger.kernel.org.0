Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB42222CDE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGPUb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:31:28 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE9C061755;
        Thu, 16 Jul 2020 13:31:28 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w34so6027805qte.1;
        Thu, 16 Jul 2020 13:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q7fkaWy5BOtDK66VES6I+b2FcjwYtxNfF67s5vYVVds=;
        b=TQVqXQTlQbyDYaO4gsISTQQfQmiO2VHodzKgRjm2AkLSVfH/bscXy/M4ukmL9Dww7Y
         eu8Z1in18q8ssuF3uzYwVS6PLbdDkBKZgLDh5X1puh7JtVSquD0cHoSFxtnLozraH94X
         8m5y4dQrec6fV+nnoXL/15UiOVn5CpFTeyPEHLv32yYLwfhODOPiAkGeug/VfRYC6bdv
         O4+HwIvwKgGKG8T6IK1oAmXdAEFd47BxI7X24GNtVVWDakotZ8v/NeDJlXhAt3SBWjc0
         RAZlgTUV0yCzKMCf76Jaf8IBgBnI2LBP3hFkZ4FQEdSTsbQ+LFd9viXkrXm0tk7IT2qo
         fIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q7fkaWy5BOtDK66VES6I+b2FcjwYtxNfF67s5vYVVds=;
        b=WrZLd7PiS0CGLA8yZMUyebwuBa20ieHRKvooI9XvsdrifLMIx4443bcYAHfpcUCz6k
         14ANP+qBASbL535bo/4shx7MGPO8c37ON8wtkbMVp0l6OZ0OZNUf5N8mHKzRPc49LaPg
         QG3hxRIBPLjOUdLid4PoX50AvylZSwxjhnxrQVYTuIZJsjDpHOavPSUPWxDMxXy5uAKO
         BvlrIkL0Xms5KdGvAJrdLlHo18Nlpb1CSWwKdRdnL4/uvGyzv+2sqU6iLCYyjI2GhkhQ
         rSXpGN5wjMwoIWlzpchiPR7rWEWv8OaYjAq6hWctj5krVUz3x9Cr2ouAlfS9NSSIt23X
         Efqg==
X-Gm-Message-State: AOAM533uu7ZdouVsq/pMgI+9cGJF4Ae4xmWdt0/Z5fdMwZLPX3mYCKCd
        waF0bWVYeERrOL4TDvxlrlODyBcNPXG9GgdfurQ=
X-Google-Smtp-Source: ABdhPJxApln5rpI1d+//DgIRGwBSpTw1+8LsChc+F4EET3NnZ2MTL43y1VVVDJTX4QYXOm0DEF0u2ClJp6p9RiXGDSk=
X-Received: by 2002:ac8:345c:: with SMTP id v28mr6996098qtb.171.1594931487933;
 Thu, 16 Jul 2020 13:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200716045602.3896926-1-andriin@fb.com> <20200716045602.3896926-3-andriin@fb.com>
 <4cffee3d-6af9-57e6-a2d5-202925ee8e77@gmail.com>
In-Reply-To: <4cffee3d-6af9-57e6-a2d5-202925ee8e77@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jul 2020 13:31:17 -0700
Message-ID: <CAEf4BzZVxTGM9mDoHMv478vQjV6Hmf_ts50=ABXkP4GxAG85eg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/9] bpf, xdp: maintain info on attached XDP
 BPF programs in net_device
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:01 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/15/20 10:55 PM, Andrii Nakryiko wrote:
> > Instead of delegating to drivers, maintain information about which BPF
> > programs are attached in which XDP modes (generic/skb, driver, or hardware)
> > locally in net_device. This effectively obsoletes XDP_QUERY_PROG command.
> >
> > Such re-organization simplifies existing code already. But it also allows to
> > further add bpf_link-based XDP attachments without drivers having to know
> > about any of this at all, which seems like a good setup.
> > XDP_SETUP_PROG/XDP_SETUP_PROG_HW are just low-level commands to driver to
> > install/uninstall active BPF program. All the higher-level concerns about
> > prog/link interaction will be contained within generic driver-agnostic logic.
> >
> > All the XDP_QUERY_PROG calls to driver in dev_xdp_uninstall() were removed.
> > It's not clear for me why dev_xdp_uninstall() were passing previous prog_flags
> > when resetting installed programs. That seems unnecessary, plus most drivers
> > don't populate prog_flags anyways. Having XDP_SETUP_PROG vs XDP_SETUP_PROG_HW
> > should be enough of an indicator of what is required of driver to correctly
> > reset active BPF program. dev_xdp_uninstall() is also generalized as an
> > iteration over all three supported mode.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/netdevice.h |  17 +++-
> >  net/core/dev.c            | 158 +++++++++++++++++++++-----------------
>
> Similar to my comment on a v1 patch, this change is doing multiple
> things that really should be split into 2 patches - one moving code
> around and the second making the change you want. As is the patch is
> difficult to properly review.
>

You mean xdp_uninstall? In patch 1 leave it as three separate
sections, but switch to different querying. And then in a separate
patch do a loop?

Alright, I'll split that up as well. But otherwise I don't really see
much more opportunities to split it.

> Given that you need a v4 anyways, can you split this patch into 2?
