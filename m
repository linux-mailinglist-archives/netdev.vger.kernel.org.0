Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E43221A7D0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGITay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGITay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:30:54 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540FFC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:30:54 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id s20so1728935vsq.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 12:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+Iiknzssx2BLNVA85CWMv3h3VCQdbvepQpFN6a560I=;
        b=P3hW3+bJK2eq3KaoQxsbg4RGoWckniS/BCo1HK0DNLBmkHpn6QItgJs6OYF6xenxc7
         /kc5vW4o/JuBFltq0WahAu8x0C0Kdw31ouAx/jgCrMwdmRC8vUI5x+r3LTokhRgem60m
         axQkMyR3dWmOteaS5VWz8RU4DUgaGplJIlvqFV+j8nailGLfNSd+BKKdKJF2WrHtik8B
         mbWhXCGA4QzqFt1/elR3xTjSBxiYR3ForS7tN1PMV3lcQ9ZSwv+NFgPUkHubhjtZ5xvL
         lc0Rco9EEuvlSH2cOiFhdXWHraONAUXThSWfhaCNbctTHF9sKzAOdBZwN8fZXJjwaR5+
         92Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+Iiknzssx2BLNVA85CWMv3h3VCQdbvepQpFN6a560I=;
        b=j8OcmN+obWTEuOi769SvhCLK9Zpt9PMj99Yu3ZLpsX6/vF4A6c4YaEg6I0FDcGZYlb
         pvC1lPRMcynY9L7SVjjhbb6GSj8LjdAUGPUxYI5fovJTokEbj+AO+kY0H9iGTT3VogZ4
         oiA4tL/q8iXirDyFYyltUGxCC0NiPkEAqZ8CFrO4k5ttrK11nT1ashFqcbK1BEohzTXm
         lcTBFcWAgPA5TFSj884odHoTzWzp8E72dD2m9a30TPxZ7w6o9iyUDjHgVzYuz3tTqLJQ
         1vkQ/BpXugwYAtdP6pvujyNweVhE0o2dEIxHtGp74f4CFQHPq75TwkMHmfmVR9SzlekZ
         yrpA==
X-Gm-Message-State: AOAM533Wi9PV8Mo6tB7662zI9u819XsbH0BwJnAS3G2zYY/dp0sgPHjK
        U9O5b38XTEdmi/4vkmb/OEJTEwsi+/zqwQjFdd8=
X-Google-Smtp-Source: ABdhPJye93S++oXzzup3JzXD9/tG1XJFndu9e4EscwdQt/v/CranlPC1U7zi1dC0L3dhKRUL8msg4+SEihA1z5KagT0=
X-Received: by 2002:a67:c114:: with SMTP id d20mr39698412vsj.158.1594323053497;
 Thu, 09 Jul 2020 12:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com>
 <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com> <CAJ8uoz2_m+-s4UXuChu9Edk99BS7NK=0cRFGFB4+z9KsHiDTMg@mail.gmail.com>
In-Reply-To: <CAJ8uoz2_m+-s4UXuChu9Edk99BS7NK=0cRFGFB4+z9KsHiDTMg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 9 Jul 2020 21:30:42 +0200
Message-ID: <CAJ8uoz1WTvNC52GTB4rqNV3arDhufXr_xrDg9pJfxvMK6stkZg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: do not discard packet when QUEUE_STATE_FROZEN
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        A.Zema@falconvsystems.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 7:10 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Thu, Jul 9, 2020 at 7:06 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Thu, Jul 09, 2020 at 11:45:51AM +0200, Magnus Karlsson wrote:
> > > In the skb Tx path, transmission of a packet is performed with
> > > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > > possible to send the packet now, please try later. Unfortunately, the
> > > xsk transmit code discarded the packet and returned EBUSY to the
> > > application. Fix this unnecessary packet loss, by not discarding the
> > > packet and return EAGAIN. As EAGAIN is returned to the application, it
> > > can then retry the send operation and the packet will finally be sent
> > > as we will likely not be in the QUEUE_STATE_FROZEN state anymore. So
> > > EAGAIN tells the application that the packet was not discarded from
> > > the Tx ring and that it needs to call send() again. EBUSY, on the
> > > other hand, signifies that the packet was not sent and discarded from
> > > the Tx ring. The application needs to put the packet on the Tx ring
> > > again if it wants it to be sent.
> >
> > Doesn't the original code leak the skb if NETDEV_TX_BUSY is returned?
> > I'm not seeing where it was released.  The new code looks correct.
>
> You are correct. Should also have mentioned that in the commit message.

Jonathan,

Some context here. The bug report from Arkadiusz started out with the
unnecessary packet loss. While fixing it, I discovered that it was
actually leaking memory too. If you want, I can send a v2 that has a
commit message that mentions both problems? Let me know what you
prefer.

> /Magnus
>
> >
> > > Fixes: 35fcde7f8deb ("xsk: support for Tx")
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Reported-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > > Suggested-by: Arkadiusz Zema <A.Zema@falconvsystems.com>
> > > ---
> > >  net/xdp/xsk.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 3700266..5304250 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -376,13 +376,22 @@ static int xsk_generic_xmit(struct sock *sk)
> > >               skb->destructor = xsk_destruct_skb;
> > >
> > >               err = dev_direct_xmit(skb, xs->queue_id);
> > > -             xskq_cons_release(xs->tx);
> > >               /* Ignore NET_XMIT_CN as packet might have been sent */
> > > -             if (err == NET_XMIT_DROP || err == NETDEV_TX_BUSY) {
> > > +             if (err == NET_XMIT_DROP) {
> > >                       /* SKB completed but not sent */
> > > +                     xskq_cons_release(xs->tx);
> > >                       err = -EBUSY;
> > >                       goto out;
> > > +             } else if  (err == NETDEV_TX_BUSY) {
> >
> > Should be "if (err == ..." here, no else.
> >
> >
> > > +                     /* QUEUE_STATE_FROZEN, tell application to
> > > +                      * retry sending the packet
> > > +                      */
> > > +                     skb->destructor = NULL;
> > > +                     kfree_skb(skb);
> > > +                     err = -EAGAIN;
> > > +                     goto out;
> > >               }
> > > +             xskq_cons_release(xs->tx);
> > >
> > >               sent_frame = true;
> > >       }
> > > --
> > > 2.7.4
> > >
