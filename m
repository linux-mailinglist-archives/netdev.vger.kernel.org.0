Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB55255BD6
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgH1OCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 10:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgH1OCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 10:02:09 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EDAC061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 07:02:09 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id b16so621175vsl.6
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 07:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ahg6SwLGlK3CWvua4G/j/vIMurB0g6i8M9RZ0GeLfr8=;
        b=RB+1nEJOxm6QM0eDtjpcIvoSlUfZEqeZold/KeCX42J65KGCaR81Yz9g+E7u+FIged
         ddbb+yvUV3zZcZYXM4NdLlWw3S0DRi2hTmhmg5AWKsMdRrX5KpI/RaCYGp5sbWoDhHNR
         Qlf1UUFMGt2Tfyw4R7U5XIIMAh4YANrGKiwDQsWEN1cP3phMGn0q7xNTL4Tqi3cxlPjd
         3LyvEF/2u2Cnp1+Qc6vRscIpXy6wddJXzBrOW9Y0xQ7YjU3vlKCYN6CEUMIg2gH5JoCq
         NFSWENGYrsM7UyHlG5aIwYZDbIhHpAR56zFfJqqI4ilJx9/TT+9VDdwY2GUHRMa0fso0
         cQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ahg6SwLGlK3CWvua4G/j/vIMurB0g6i8M9RZ0GeLfr8=;
        b=oDlzKSE1oFiGUC+iBsXNgSGqzQFX2vsP8X99opXfpxKhX5w6KIfFqjLjQ6p5X5uxtb
         RUUdmSTeTIWzBJa2pOmuXiChuz4NdWq4OzvdCrD+etUbK7qmLTp8xstrEHXsF5Z3QFfw
         EBrlTUCFl13VIbGA/DGZZwVlMkgyA0fNEgcBbODFxC81eCFCaZsZQ2Q/o7sjGbwFTKoC
         Zbwnd+v4IQrNPx72LLa0+Qr8qeA4o2SJC8p7vUCUFkuB0VBlTXsZmXylEZyQ9+J0I/8y
         1eCLh5it0rBVR9xPD3mCdNkUGD54h0owcur0US75YdWjS7i/5UICD2G4SDx/T6Y7haR/
         vBAw==
X-Gm-Message-State: AOAM533tcHRIEjIxMeVh3MxpIYGZ7U2HFJ76a8w/cOmlOFdMHyM9SfDP
        TEkDP2OE8eTzvtcyR9wYCsEhRuEkXcmX8w==
X-Google-Smtp-Source: ABdhPJwvQX7ED9IZ6eDGsUme6BUcDYjvVdOV3tVe9dGHrgFiC/GaYcfw31h7J7LJWBIrEvJb9vmBmQ==
X-Received: by 2002:a67:3157:: with SMTP id x84mr1018933vsx.113.1598623328166;
        Fri, 28 Aug 2020 07:02:08 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id t124sm166243vst.24.2020.08.28.07.02.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 07:02:07 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id x17so399286uao.5
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 07:02:07 -0700 (PDT)
X-Received: by 2002:ab0:60d7:: with SMTP id g23mr1046510uam.122.1598623326483;
 Fri, 28 Aug 2020 07:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200828064511.GD7389@iisc.ac.in> <c9eb6d14-cbc3-30de-4fb7-5cf18acfbe75@gmail.com>
 <20200828085053.GA4669@iisc.ac.in>
In-Reply-To: <20200828085053.GA4669@iisc.ac.in>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Aug 2020 16:01:31 +0200
X-Gmail-Original-Message-ID: <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
Message-ID: <CA+FuTSeOx53Vq_JW4icjV-QnuKwj+PGkPpg5XWAoHWea5bfviQ@mail.gmail.com>
Subject: Re: packet deadline and process scheduling
To:     "S.V.R.Anand" <anandsvr@iisc.ac.in>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 10:51 AM S.V.R.Anand <anandsvr@iisc.ac.in> wrote:
>
> There is an active Internet draft "Packet Delivery Deadline time in
> 6LoWPAN Routing Header"
> (https://datatracker.ietf.org/doc/draft-ietf-6lo-deadline-time/) which
> is presently in the RFC Editor queue and is expected to become an RFC in
> the near future. I happened to be one of the co-authors of this draft.
> The main objective of the draft is to support time sensitive industrial
> applications such as Industrial process control and automation over IP
> networks.  While the current draft caters to 6LoWPAN networks, I would
> assume that it can be extended to carry deadline information in other
> encapsulations including IPv6.
>
> Once the packet reaches the destination at the network stack in the
> kernel, it has to be passed on to the receiver application within the
> deadline carried in the packet because it is the receiver application
> running in user space is the eventual consumer of the data. My mail below is for
> ensuring passing on the packet sitting in the socket interface to the
> user receiver application process in a timely fashion with the help of
> OS scheduler. Since the incoming packet experieces variable delay, the
> remaining time left before deadline approaches too varies. There should
> be a mechanism within the kernel, where network stack needs to
> communicate with the OS scheduler by letting the scheduler know the
> deadline before user application socket recv call is expected to return.
>
> Anand
>
>
> On 20-08-28 10:14:13, Eric Dumazet wrote:
> >
> >
> > On 8/27/20 11:45 PM, S.V.R.Anand wrote:
> > > Hi,
> > >
> > > In the control loop application I am trying to build, an incoming message from
> > > the network will have a deadline before which it should be delivered to the
> > > receiver process. This essentially calls for a way of scheduling this process
> > > based on the deadline information contained in the message.
> > >
> > > If not already available, I wish to  write code for such run-time ordering of
> > > processes in the earlist deadline first fashion. The assumption, however
> > > futuristic it may be, is that deadline information is contained as part of the
> > > packet header something like an inband-OAM.
> > >
> > > Your feedback on the above will be very helpful.
> > >
> > > Hope the above objective will be of general interest to netdev as well.
> > >
> > > My apologies if this is not the appropriate mailing list for posting this kind
> > > of mails.
> > >
> > > Anand
> > >
> >
> > Is this described in some RFC ?
> >
> > If not, I guess you might have to code this in user space.

Could ingress redirect to an IFB device with FQ scheduler work for
ingress EDT? With a BPF program at ifb device egress hook to read
the header and write skb->tstamp.
