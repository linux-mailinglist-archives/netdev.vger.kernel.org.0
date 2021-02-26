Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBBE3265A4
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBZQgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZQgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 11:36:35 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FBAC06178A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:35:24 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id x19so9496983ybe.0
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lHVNeQILzQc3DvddInxQZMwaQso06/xEuc3t0kbfZTI=;
        b=EMgODNntEcuFYkfHj6fGMVzTHTRLGquZyXnh8N86RGG+1vNS7Te7xF7sBbylhia3Ah
         SIF6h9g/zvMMlflxJd7E8E3tNTyJMTk14K91YFil7vkHWSnQVZNhFaG1jB9SjDfPBRYb
         5Iqd8EyyvxQnqlRj0GGEDV4btjEFGIRDAZCgXpnspO5HsRyYprj71zV/fMv1t+/UlUPs
         W+VfFyz6Ar/zd2HMGLPiIR87in/WjgEmopo3F7snMeQeXEOYKxJxwTGjlc/KDwqFjeQ+
         8IWOOQ6w+Y+3Eh1GdgXMOgkL3ghZHvs0WBgAQPpuD5DKdnSB+r/LgNKzUzmIOihNRk23
         rC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lHVNeQILzQc3DvddInxQZMwaQso06/xEuc3t0kbfZTI=;
        b=n4+QD0TGwQS9DSVtBF5FKLkQA6rk2znaILpc8s4gjSql2wy6V1ea9YMMqECJw+DeoI
         bcJyNc8R8AJ4+gmbvqw4mfBfAPHwc9FVwOdYs1W1tKuIJSGvO0EWc08ZUjWsoyZqBKy3
         5lPlzcRo1/D1RSX590LmUwS+maWaJVoMXdXWic9RvzqFikivkjtm6jlGvqSZ4Vla3GK/
         WFzB3ndZGgnijDcB4ZRrWpDtO8/lDrNMrabC3YYEW5X560CwKbd5V9gLY3UwKbj1jSdH
         BbwNtqms1DGhXriCvShd49vobyS8b7AkKrFV+Zaqzj6nTEkmSWacY0JfHkHDRHpiNocx
         ITEQ==
X-Gm-Message-State: AOAM531/TLod+5KXeG4briyA4cCqyIIrWs89pfYa7EeAKV1wuv0v5mrK
        pnpDBDciZkh0mLrpUyc0uq/5Z71I1bT8ANyjrZbUNa9KSLVwNA==
X-Google-Smtp-Source: ABdhPJxAepM6rNfeB0Eqm75WGDMnZzwVlLMP7ZP0yOgf0Bcx0esH0Nbt5DqBzJgqK+BeRW1PS1eYV50RAt4PHWCljy4=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr5345474ybd.446.1614357323214;
 Fri, 26 Feb 2021 08:35:23 -0800 (PST)
MIME-Version: 1.0
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJwfXFKnSAQpwaBnfrrE01PXyxLUieBxaB0RzyOajCzLQ@mail.gmail.com>
 <CANn89iL7XCLBxsUnV3c_5AD8eSJ=jXs6o_KJUjmZAGo6_6sqUg@mail.gmail.com> <20210226080918.03617088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226080918.03617088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Feb 2021 17:35:11 +0100
Message-ID: <CANn89iL8KO5KLqCRdGbGJg5cZj7zVBUjrStFv7A_wqnLusQQ_Q@mail.gmail.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 5:09 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Feb 2021 11:41:22 +0100 Eric Dumazet wrote:
> > > > Seems like I'm pretty lost here and the tcp:tcp_retransmit_skb events
> > > > are less spurious than I thought. Looking at some tcpdump traces we see:
> > > >
> > > > 0.045277 IP6 A > B: Flags [SEW], seq 2248382925:2248383296, win 61920, options [mss 1440,sackOK,TS val 658870494 ecr 0,nop,wscale 11], length 371
> > > >
> > > > 0.045348 IP6 B > A: Flags [S.E], seq 961169456, ack 2248382926, win 65535, options [mss 1440,sackOK,TS val 883864022 ecr 658870494,nop,wscale 9], length 0
> > >
> > > The SYNACK does not include the prior payload.
> > >
> > > > 0.045369 IP6 A > B: Flags [P.], seq 1:372, ack 1, win 31, options [nop,nop,TS val 658870494 ecr 883864022], length 371
> > >
> > > So this rtx is not spurious.
> > >
> > > However in your prior email you wrote :
> > >
> > > bytes_in:      0
> > > bytes_out:   742
> > > bytes_acked: 742
> > >
> > > Are you sure that at the time of the retransmit, bytes_acked was 742 ?
> > > I do not see how this could happen.
> >
> > Yes, this packetdrill test confirms TCP INFO stuff seems correct .
>
> Looks like it's TcpExtTCPSpuriousRtxHostQueues - the TFO fails as it
> might, but at the time the syn is still not kfree_skb()d because of
> the IRQ coalescing settings, so __tcp_retransmit_skb() returns -EBUSY
> and we have to wait for a timeout.
>
> Credit to Neil Spring @FB for figuring it out.

Yes, this makes sense.

Presumably tcp_send_syn_data() could allocate a regular (non fclone)
skb, to avoid this.

But if skb_still_in_host_queue() returns true, __tcp_retransmit_skb()
should return -EBUSY
and your tracepoint should not be called ?

In anycase, the bytes_acked should not be 742 as mentioned in your
email, if only the SYN was acked ?
