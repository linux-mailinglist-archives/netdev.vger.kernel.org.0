Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E540332B3A8
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449896AbhCCEEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580521AbhCBSEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:04:23 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D0C0611BD
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 10:01:49 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id n195so21599547ybg.9
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 10:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55eDiCGsugtCBKXFw5gh8tXzqEbCIFUmu5DswrRMbnI=;
        b=txmI7EjVZW3tRRpJCi4cg1x9YlhJSCPL7s677iFwsUZtsCVd0ou60ntmKsAkJGFH2G
         dR81nxJUmy1W49Brlzy3/oFkAsee0KrMDfQnJEOwAc97/fMefZewr8IFtvZtNBVxgWm1
         wciTWQjG79IOgqcvOyrMMyXUPwMGW4BJPGLXzPdGWc0knoeogKYz9EsYB8TYs64iTW06
         5uEVZQwVwjAxgT7uezGy0T2cBYhLL4NeIhPeIdSTK+3wGyn4EEw2FR16iYBgWAmrVSK0
         Xn+iF1S/v1mrSQ9C8t/UW0ECyChQpt0oVrITYy0jrrNmj1n10QsUYCXISTI/G+zuO0i5
         DFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55eDiCGsugtCBKXFw5gh8tXzqEbCIFUmu5DswrRMbnI=;
        b=sSjfycOQ58SSM1lxpnFZ1VsEmvwqVFueZfC+xdurxBUBJj7XIBqfEpAguZ9Vbi5cSg
         YPaguvVumM/D4sxFfhtAFjwFty+JM24bp3hQttm83KPBmBv8Tdv1+r3leQ3gTkPiQ8h9
         UAG1W4sq4ClRpR5uNw2vHxonjayiWiwVlfiySI1fJbKTxtD3NNPtFoVxsgjDzLqIoLBq
         7JPf7H7IuhefsfOAotuZ+hjnEqsYvrgwcxbLPTBeSCHST1Bd0FgP/IM67PLSOySqMXtg
         LuofOzSTbvWR0lcwphCrqUgjGbSLlxSdd65/c8FO3Kb6vH7qhHoQ0f97PHfQtm8tAfOp
         mQCA==
X-Gm-Message-State: AOAM530u7xkL3d6QSUgYSoQ25zqGRj2i7wGLRncR8hIhulJVFP4qu5oi
        2H12AfBAwdSOKGxhJi76uYbiRodtTu2AKvRvmBv1gtwV/xr91Q==
X-Google-Smtp-Source: ABdhPJyPe+lHXFLdTrhJG2rRnahIiED198C304dtHcVuV3GIOwgDo2LkFjvlUpX2zFzFmLsZ11VMn3mrN4TzNCsyyCk=
X-Received: by 2002:a25:ccc5:: with SMTP id l188mr3961766ybf.253.1614708107548;
 Tue, 02 Mar 2021 10:01:47 -0800 (PST)
MIME-Version: 1.0
References: <20210302175259.971778-1-kuba@kernel.org> <20210302100047.43e8fed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302100047.43e8fed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Mar 2021 19:01:36 +0100
Message-ID: <CANn89iLX9d3dcOG1g8pk=aBrfFjbCDdDhJCf8uXpRhv=nb1Hug@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tcp: make TCP Fast Open retransmission ignore
 Tx status
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 7:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  2 Mar 2021 09:52:59 -0800 Jakub Kicinski wrote:
> > When receiver does not accept TCP Fast Open it will only ack
> > the SYN, and not the data. We detect this and immediately queue
> > the data for (re)transmission in tcp_rcv_fastopen_synack().
> >
> > In DC networks with very low RTT and without RFS the SYN-ACK
> > may arrive before NIC driver reported Tx completion on
> > the original SYN. In which case skb_still_in_host_queue()
> > returns true and sender will need to wait for the retransmission
> > timer to fire milliseconds later.
> >
> > Work around this issue by passing negative segment count to
> > __tcp_retransmit_skb() as suggested by Eric.
> >
> > The condition triggers more often when Tx coalescing is configured
> > higher than Rx coalescing on the underlying NIC, but it does happen
> > even with relatively moderate and even settings (e.g. 33us).
> >
> > Note that DC machines usually run configured to always accept
> > TCP FastOpen data so the problem may not be very common.
> >
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Neil Spring <ntspring@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> .. and now I realized net-next is closed. I'll keep an eye on patchwork
> and resend as needed, sorry.

Ah, just open it ;)
