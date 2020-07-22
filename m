Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA022913E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgGVGsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:48:53 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993B7C061794;
        Tue, 21 Jul 2020 23:48:53 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x69so1039454qkb.1;
        Tue, 21 Jul 2020 23:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xn6DCNrCACsPaHy/JnedLuq5l1Q08x4DIxQzqp4E2o=;
        b=V/WZPLdmABqyjF7mBozMxnLkMO/wRfC8i5sqYbn3ykQVklaIQeaIyFXrQCBCUmIPg4
         V5Y0uZJSiLw1UQ/QHavYlTi+TEv2uOe6X5etD+xRl4onRYVmgLjSEpcZG8WAp2tP7GHW
         TxewFLwfPlUW7KKRwMESoQQUl8KGxfNzf/NYCJPNOVQp4gLYF7vjfXF70GBl5qlfZCUt
         C9d7K+eNMGcGFg7BGrPPejBxIuD4bwYHOxDzQgsxz9uFgEAgvX2klo8eZZhR7KO7/Ghp
         uQ1koM5mIT9g2dJ2GiQfOpDYcnuAqaZ7NmtO5zkQE3apiWyn25/V19z7iq+Pj0K1WnaH
         0X2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xn6DCNrCACsPaHy/JnedLuq5l1Q08x4DIxQzqp4E2o=;
        b=V0K5XwTpIoheiVGzxn/iWSyTd5MIT2yqJeO9txYd/zKKFxwe/d1a4q/pwbY7LiDVsg
         gEyK/gc1kVZg6PnIIRGMg5dASvZ+HyCwUKID5px8MYcpZIhSK+o3q+UVH6/Thy72fZ1b
         8Lpv6tf3I7ION+YmiG6as/U7Ro9bx6SqtcLi4bpd63dyd7dsWnDon8vD9QapQELEZJal
         jFrI7dt+gvPdvMl6x0DOPBhc7XVp6IaMee3pTffjyh2sieEyOzZY14dh6MRY3aRWPgHP
         vcZNcMD0YzMy3PUJZ2gLk8eYX/qSYnQMBrmxB4wJ7RYE8nNbBaTQ7VkcDRrjxZhbTbNJ
         nslA==
X-Gm-Message-State: AOAM53118wGuQ3EarBL6wME5EJPsIuU8ulEwvNilGPZLDLpd38rDDbB6
        kuh5AjE4wICgJiDFI2ASnGuuXVAvumdQmJ+WHjU=
X-Google-Smtp-Source: ABdhPJw+xpPMnnoGTxGZh8x2OZBtTOaZXy+jmVlD4k3uJAum0TIK/Zr8Se+wXO3z/YPxr4trxugJPdwLN3igq0mTvcA=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr31677770qkg.437.1595400532768;
 Tue, 21 Jul 2020 23:48:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200716045602.3896926-1-andriin@fb.com> <20200716045602.3896926-3-andriin@fb.com>
 <4cffee3d-6af9-57e6-a2d5-202925ee8e77@gmail.com> <CAEf4BzZVxTGM9mDoHMv478vQjV6Hmf_ts50=ABXkP4GxAG85eg@mail.gmail.com>
In-Reply-To: <CAEf4BzZVxTGM9mDoHMv478vQjV6Hmf_ts50=ABXkP4GxAG85eg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jul 2020 23:48:41 -0700
Message-ID: <CAEf4BzZiZPj0+HucA0mZT6VOFKb+xO3v2XCPj=kig7tEx8FCRA@mail.gmail.com>
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

On Thu, Jul 16, 2020 at 1:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jul 16, 2020 at 12:01 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 7/15/20 10:55 PM, Andrii Nakryiko wrote:
> > > Instead of delegating to drivers, maintain information about which BPF
> > > programs are attached in which XDP modes (generic/skb, driver, or hardware)
> > > locally in net_device. This effectively obsoletes XDP_QUERY_PROG command.
> > >
> > > Such re-organization simplifies existing code already. But it also allows to
> > > further add bpf_link-based XDP attachments without drivers having to know
> > > about any of this at all, which seems like a good setup.
> > > XDP_SETUP_PROG/XDP_SETUP_PROG_HW are just low-level commands to driver to
> > > install/uninstall active BPF program. All the higher-level concerns about
> > > prog/link interaction will be contained within generic driver-agnostic logic.
> > >
> > > All the XDP_QUERY_PROG calls to driver in dev_xdp_uninstall() were removed.
> > > It's not clear for me why dev_xdp_uninstall() were passing previous prog_flags
> > > when resetting installed programs. That seems unnecessary, plus most drivers
> > > don't populate prog_flags anyways. Having XDP_SETUP_PROG vs XDP_SETUP_PROG_HW
> > > should be enough of an indicator of what is required of driver to correctly
> > > reset active BPF program. dev_xdp_uninstall() is also generalized as an
> > > iteration over all three supported mode.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  include/linux/netdevice.h |  17 +++-
> > >  net/core/dev.c            | 158 +++++++++++++++++++++-----------------
> >
> > Similar to my comment on a v1 patch, this change is doing multiple
> > things that really should be split into 2 patches - one moving code
> > around and the second making the change you want. As is the patch is
> > difficult to properly review.
> >
>
> You mean xdp_uninstall? In patch 1 leave it as three separate
> sections, but switch to different querying. And then in a separate
> patch do a loop?
>
> Alright, I'll split that up as well. But otherwise I don't really see
> much more opportunities to split it.

So I ended up not doing that. Given dev_xdp_uninstall() is just 15
lines of code, half of which are trivial, it just doesn't make sense
to split dev_xdp_uninstall() refactor into two phases.

>
> > Given that you need a v4 anyways, can you split this patch into 2?
