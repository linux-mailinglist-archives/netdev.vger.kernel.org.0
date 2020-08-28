Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137FB256232
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgH1Upv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 16:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1Ups (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 16:45:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35450C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 13:45:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id bh1so205253plb.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 13:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y1vRrSw74hzdEFN2YKOnNcET1rruw1sr9+hR2REhuZ8=;
        b=PmBb9Kb9j1SDN4NQ54W8X3xtrOws00i0IHKQ88oR8SCphS9c97+dmDraBZR8WLrglo
         4YDC7CjZdueIMZ2aJ+mEaBvk/4ACO4hiRbCKiJnww6FMCA1Vf8fvdkuJ3aqrgJkQNKu2
         3JrkzfYUUl/Q9Fb/DPw2ntU4zNjUuMO6n0fWIiaEaC79WW85ZbLEAAf4qGmG4l6AaMW7
         l27sRncZMsSnnGxT8mcW4hgwWKhYYd/8tMr463uu5JypWY7TWgaRdXSD0QTx3kViBTN/
         mxnZjcUx6lmrnWYebSJ8kemuaAEebGYVGuZOyQCx+nmkYxrxxlGMkflSz6XLejadGK8Y
         rDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1vRrSw74hzdEFN2YKOnNcET1rruw1sr9+hR2REhuZ8=;
        b=ihj+DxKMsHwPQUrs6OCP/fILnVeglMhQMIOeiUhi+jnvyV4lBjXGWUw4oTGxq+wo7Z
         caaAUylJYDvHGBZRu69qN5P4fRpW9Tk/9TkjYgXozQjP0Rj+qPRKoXqI5LD5YFQKocm0
         mE0+vgFg2So7Lmx/Gwzql5pFuPIMU/DeK7PgY2vPmOyRsWTLDCXjHjMHcq2kMPQMCmpn
         S/oev5/6Rqzkkz/fXy1YdK4ztCWHx0+RGNHvfTmak3t6eQtDHZe1NIXMDCW7WmFXVOgg
         g2/7skVM8YL+aElEg3CdxZ+4L+vBzzE2F1kXaFeCNQiKm2di8ArUcoRwvzw+xaefZIDf
         cCxw==
X-Gm-Message-State: AOAM531uB0+XQYRZU5+Z/8fBKryhXBWofA9wr60OK2gblaTPcBB4oRxl
        9vAMfxZ5JE/4hoY+sI6DOcQzTg==
X-Google-Smtp-Source: ABdhPJwpFN6T8k6xkpIxbdgqeCHGL93nyi6gR1AN9UckainSDEhSr6p/bPcNndjL7/ne7bwKPdBA6Q==
X-Received: by 2002:a17:90b:a54:: with SMTP id gw20mr620914pjb.183.1598647546649;
        Fri, 28 Aug 2020 13:45:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 65sm296177pfx.104.2020.08.28.13.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 13:45:46 -0700 (PDT)
Date:   Fri, 28 Aug 2020 13:45:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "S.V.R.Anand" <anandsvr@iisc.ac.in>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: packet deadline and process scheduling
Message-ID: <20200828134538.67eaf7b5@hermes.lan>
In-Reply-To: <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
References: <20200828064511.GD7389@iisc.ac.in>
        <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
        <20200828085053.GA4669@iisc.ac.in>
        <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 16:01:31 +0200
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> On Fri, Aug 28, 2020 at 10:51 AM S.V.R.Anand <anandsvr@iisc.ac.in> wrote:
> >
> > There is an active Internet draft "Packet Delivery Deadline time in
> > 6LoWPAN Routing Header"
> > (https://datatracker.ietf.org/doc/draft-ietf-6lo-deadline-time/) which
> > is presently in the RFC Editor queue and is expected to become an RFC in
> > the near future. I happened to be one of the co-authors of this draft.
> > The main objective of the draft is to support time sensitive industrial
> > applications such as Industrial process control and automation over IP
> > networks.  While the current draft caters to 6LoWPAN networks, I would
> > assume that it can be extended to carry deadline information in other
> > encapsulations including IPv6.
> >
> > Once the packet reaches the destination at the network stack in the
> > kernel, it has to be passed on to the receiver application within the
> > deadline carried in the packet because it is the receiver application
> > running in user space is the eventual consumer of the data. My mail below is for
> > ensuring passing on the packet sitting in the socket interface to the
> > user receiver application process in a timely fashion with the help of
> > OS scheduler. Since the incoming packet experieces variable delay, the
> > remaining time left before deadline approaches too varies. There should
> > be a mechanism within the kernel, where network stack needs to
> > communicate with the OS scheduler by letting the scheduler know the
> > deadline before user application socket recv call is expected to return.
> >
> > Anand
> >
> >
> > On 20-08-28 10:14:13, Eric Dumazet wrote:  
> > >
> > >
> > > On 8/27/20 11:45 PM, S.V.R.Anand wrote:  
> > > > Hi,
> > > >
> > > > In the control loop application I am trying to build, an incoming message from
> > > > the network will have a deadline before which it should be delivered to the
> > > > receiver process. This essentially calls for a way of scheduling this process
> > > > based on the deadline information contained in the message.
> > > >
> > > > If not already available, I wish to  write code for such run-time ordering of
> > > > processes in the earlist deadline first fashion. The assumption, however
> > > > futuristic it may be, is that deadline information is contained as part of the
> > > > packet header something like an inband-OAM.
> > > >
> > > > Your feedback on the above will be very helpful.
> > > >
> > > > Hope the above objective will be of general interest to netdev as well.
> > > >
> > > > My apologies if this is not the appropriate mailing list for posting this kind
> > > > of mails.
> > > >
> > > > Anand
> > > >  
> > >
> > > Is this described in some RFC ?
> > >
> > > If not, I guess you might have to code this in user space.  
> 
> Could ingress redirect to an IFB device with FQ scheduler work for
> ingress EDT? With a BPF program at ifb device egress hook to read
> the header and write skb->tstamp.

This might be an attack vector for remote DOS. If you believe all messages
it might be possible to create huge set of messages all of which have to be
processed at once.

