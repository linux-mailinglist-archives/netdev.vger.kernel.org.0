Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D2121A7EC
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGITjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgGITjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:39:54 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392E8C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:39:54 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id b13so1098247uav.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 12:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnE3qdXGpMyNm8Oh3xCm33hvZVYcAbi5yH6tSVaScNA=;
        b=pl3A5LuBz/IZl07f0hwrnc5uEedBhkG1gnFExf/RDW9U7Mu741ggJr6KdkxViarWE6
         KHWYLGKlHwJG6xhlgyTqYXE+ZMmniUdalbcSiA1Eot1VXHWACFe1U2JTVaTF0HGbjM/e
         koNNqNENyInUmSKKDTZokV+8QtxoGcm95wRPNaABqQq5ph9rsNOjQUf0CrwvyvV3kwy2
         NpuE6bs7WwOAfGvZudZTGJDTu0N9i7RQhv2ZxCVp6HAh3snWpIaPrzu0l/4rLyJvykSN
         hz9B4BeIHZ43LWvNCMlrr3atMDhGds1UlFBH1xidwLUc7k+h2I8oxFKmZL/MFbChzXJK
         OC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnE3qdXGpMyNm8Oh3xCm33hvZVYcAbi5yH6tSVaScNA=;
        b=bPUzWS5LOfZJS3GZAR5yvTxlTEo770Tyq+Ca36ISugOOHqQ+9sSBgz0mP8qPhbYxJI
         U7JH0aUDi+twG+8DY8AXhtt1rcQbV2P/hWJHCEYWwLqx8IXTT/C6HDuARE2hr4TgtGdk
         TuAn2eizqAXmxJ2QR0TjJnNEDMfRkoOH+/VhhqICyRaPOQrOIHrwN6i1hY0Y4d+AU1Nq
         XBdufU3ukb/LKOeEuOjlrCAX6E3dvDYcgsHW3KsLJGUosPqTdIr3tS44nMAXJxbDpsa7
         voMm9+yq+MN7nB9KDH6jvwYHNuG08AGU3qEDl8kIstNKgx4rQ+I7S3KnSZeSQyvFP032
         lGbg==
X-Gm-Message-State: AOAM533GjbcfV6YyumK+gFY48L7GNT7Ro7fgx5FlPOcAmRn0lAGF2sMB
        DgIuzXtcmp3lE1xcpz05trJbKlMXyzBhE+7W/C8=
X-Google-Smtp-Source: ABdhPJwBSRgJLEIhnLBBBkU0NQWqipYGHp38UGSP3fnIaitubT6vQDyIGeDOYd611XBDNNfWCoEAM4WfGNX1ELVzD7U=
X-Received: by 2002:ab0:64cd:: with SMTP id j13mr15216299uaq.33.1594323593489;
 Thu, 09 Jul 2020 12:39:53 -0700 (PDT)
MIME-Version: 1.0
References: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com>
 <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com>
 <CAJ8uoz2_m+-s4UXuChu9Edk99BS7NK=0cRFGFB4+z9KsHiDTMg@mail.gmail.com>
 <CAJ8uoz1WTvNC52GTB4rqNV3arDhufXr_xrDg9pJfxvMK6stkZg@mail.gmail.com> <20200709193431.wruc3u6x5ddnkicv@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200709193431.wruc3u6x5ddnkicv@bsd-mbp.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 9 Jul 2020 21:39:42 +0200
Message-ID: <CAJ8uoz2-q5EVcSj1nURgVsg_y5rfBbYrbVugcvj2LPWwTBpH+w@mail.gmail.com>
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

On Thu, Jul 9, 2020 at 9:34 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Thu, Jul 09, 2020 at 09:30:42PM +0200, Magnus Karlsson wrote:
> > On Thu, Jul 9, 2020 at 7:10 PM Magnus Karlsson
> > <magnus.karlsson@gmail.com> wrote:
> > >
> > > On Thu, Jul 9, 2020 at 7:06 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > >
> > > > On Thu, Jul 09, 2020 at 11:45:51AM +0200, Magnus Karlsson wrote:
> > > > > In the skb Tx path, transmission of a packet is performed with
> > > > > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > > > > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > > > > possible to send the packet now, please try later. Unfortunately, the
> > > > > xsk transmit code discarded the packet and returned EBUSY to the
> > > > > application. Fix this unnecessary packet loss, by not discarding the
> > > > > packet and return EAGAIN. As EAGAIN is returned to the application, it
> > > > > can then retry the send operation and the packet will finally be sent
> > > > > as we will likely not be in the QUEUE_STATE_FROZEN state anymore. So
> > > > > EAGAIN tells the application that the packet was not discarded from
> > > > > the Tx ring and that it needs to call send() again. EBUSY, on the
> > > > > other hand, signifies that the packet was not sent and discarded from
> > > > > the Tx ring. The application needs to put the packet on the Tx ring
> > > > > again if it wants it to be sent.
> > > >
> > > > Doesn't the original code leak the skb if NETDEV_TX_BUSY is returned?
> > > > I'm not seeing where it was released.  The new code looks correct.
> > >
> > > You are correct. Should also have mentioned that in the commit message.
> >
> > Jonathan,
> >
> > Some context here. The bug report from Arkadiusz started out with the
> > unnecessary packet loss. While fixing it, I discovered that it was
> > actually leaking memory too. If you want, I can send a v2 that has a
> > commit message that mentions both problems? Let me know what you
> > prefer.
>
> I think it would be best to mention both problems for the benefit of
> future readers.

You will get a v2 tomorrow.

/Magnus

> --
> Jonathan
