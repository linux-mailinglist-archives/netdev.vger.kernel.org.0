Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F02AD99B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgKJPCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:02:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730070AbgKJPCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:02:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605020572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4T3X8VNa413Oylr6OLPkLsi6KYpR4hO/rJq5cFWu4A8=;
        b=ZWqf0QIIkZG68OggUjg4slXBeBCxuugKsCq7FriE6nvJwbD1M74/9K4Sp+7tXpW4Rx0Y7m
        KZw3GW7FxdreJNTXSRdFJXgbZKDXmtQJLPp7jCHx45SIbqDoVbPADeRxiesD9/AZ3NxZRl
        xh42VoKaOZbYqzPKF/6lpxNZ/GTe5Ak=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-6Xc2v-DlORK0vwz1ZroAiQ-1; Tue, 10 Nov 2020 10:02:51 -0500
X-MC-Unique: 6Xc2v-DlORK0vwz1ZroAiQ-1
Received: by mail-wm1-f69.google.com with SMTP id g3so795619wmh.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 07:02:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4T3X8VNa413Oylr6OLPkLsi6KYpR4hO/rJq5cFWu4A8=;
        b=T21Pm6abXU8/XOnfzokXYGWtuCAIx11WTX7UFZpmiz7+bIsZo/fVI0O0WzCXFgA/2D
         nu0yEo9ag6ptb5AkmyYZ/QXBiPjKG/U9r9kveb14HWrSnVLnfHPj3TSFBq4EBwaouSGJ
         JSj2bhm7KWhjk/eQdx7aUAWYdN/ffiupBF7z6AqKYhyLyTCcoWt1xHoiwauT3TF8AafD
         5a0UyWJeTPKkinQ3aaNMDiYjyrRdK1Mcg2DomTKXv8venlzDTijzTKY/XhJF7Kk4xkdJ
         2/2kR7mlczvkU2dGQoXsLveu7zIMtlBGAe3QWs/Ce3shQmRRA/ETbhb2+ur8nWXuf4XS
         Um4Q==
X-Gm-Message-State: AOAM531dCFFdq3uPZH7UszsSLxPHRMSyqCwabdQvs+KgazEl9kz7Hdlq
        fyG5ij8ZB1WLORTP9yGjZXopKO7AgToI2zVq/XCNDLLkWVciHQ1HAkoWVVJUUJzsLDONaTdB1Pc
        4zbIWi+UDaKSoFAeJ
X-Received: by 2002:adf:ec47:: with SMTP id w7mr24368739wrn.253.1605020568911;
        Tue, 10 Nov 2020 07:02:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEGM3L2g+NatMsY0dmh1HIqSp9OSdU/xeJonXE7R6Yx2pcghHIJ7KfIGhJ/mLuJTpGs27yhg==
X-Received: by 2002:adf:ec47:: with SMTP id w7mr24368708wrn.253.1605020568696;
        Tue, 10 Nov 2020 07:02:48 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id v16sm3409405wml.33.2020.11.10.07.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 07:02:47 -0800 (PST)
Date:   Tue, 10 Nov 2020 16:02:45 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201110150245.GF30007@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201110092834.GA30007@linux.home>
 <20201110124224.GC5635@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110124224.GC5635@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 12:42:24PM +0000, Tom Parkin wrote:
> On  Tue, Nov 10, 2020 at 10:28:34 +0100, Guillaume Nault wrote:
> > On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> > > On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:
> > > > This small RFC series implements a suggestion from Guillaume Nault in
> > > > response to my previous submission to add an ac/pppoe driver to the l2tp
> > > > subsystem[1].
> > > > 
> > > > Following Guillaume's advice, this series adds an ioctl to the ppp code
> > > > to allow a ppp channel to be bridged to another.
> > > 
> > > I have little understanding of the ppp code, but I can't help but
> > > wonder why this special channel connection is needed? We have great
> > > many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> > > is there anything ppp specific that is required here?
> > 
> > I can see two viable ways to implement this feature. The one described
> > in this patch series is the simplest. The reason why it doesn't reuse
> > existing infrastructure is because it has to work at the link layer
> > (no netfilter) and also has to work on PPP channels (no network
> > device).
> > 
> > The alternative, is to implement a virtual network device for the
> > protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
> > and teach tunnel_key about them.
> 
> One potential downside of this approach is the addition of two virtual
> interfaces for each pppoe->pppol2tp mapping: the concern here
> primarily being the cost of doing so.

No, this is fixed cost. There'd be only one PPPoE interface for
handling all the PPPoE sessions and one for L2TP. These virtual
interfaces wouldn't be specific to a particular session ID. Instead,
the encapsulation information would be attached to the skb and the
virtual PPPoE or L2TP device would build the header based on these
metadata.

> I'm not saying the cost is necessarily prohibitive, but the "bridge the
> channels" approach in the RFC is certainly cheaper.
> 
> Another concern would be the possibility of the virtual devices being
> misconfigured in such a way as to e.g. allow locally generated
> broadcast packets to go out on one of the interfaces.  Possibly this
> would be easy to avoid, I'm not sure.

I'm not too woried about that. A PPPoE or L2TP interface in external
mode couldn't build its header and forward the packet if the skb it
received doesn't have the proper metadat attached to it. So packets
couldn't be inadvertently sent through these interfaces, something
would have to attach the tunnel metadata to the skb beforehand.

But I agree that the setup becomes visible to the administrator, while
the ioctl() approach kept the whole kernel configuration in the hands
of the control-plane implementation. I think that's a good thing
(easier testing and troubleshooting), but yes, that also opens the
possibility for fat finger mistakes.

> > I think the question is more about long term maintainance. Do we want
> > to keep PPP related module self contained, with low maintainance code
> > (the current proposal)? Or are we willing to modernise the
> > infrastructure, add support and maintain PPP features in other modules
> > like flower, tunnel_key, etc.?
> 
> FWIW I would tend to agree.

Yes, it's really about how much we're ready to invest into PPP-related
features.

