Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB6149562
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYL5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:57:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726146AbgAYL5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579953430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B5BRoN6IfgoB1+mrmtYZOg8dawdN0zyVwIoVkpBJgvM=;
        b=EgOD7Gb3QV/Z+S/YctQqzEHsbY+Nj/RlEN8yRc5kbWqYRsm3v1YJL6i6m1tyYIWxrBduFc
        dLGHqD3D1C11gacohd6GurSXu+R3Xn8xwZVsZZD7K1eWHfCjJkfCaLLR2hVV1lPD0/Fs7x
        DKTeuU3oROWtNRpCv2NHm0RAVTDy9cA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-BeB7m4jjPDud6Q_RfuZWuw-1; Sat, 25 Jan 2020 06:57:07 -0500
X-MC-Unique: BeB7m4jjPDud6Q_RfuZWuw-1
Received: by mail-wr1-f69.google.com with SMTP id o6so2870573wrp.8
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B5BRoN6IfgoB1+mrmtYZOg8dawdN0zyVwIoVkpBJgvM=;
        b=GBGp9NYiNE2s6wU+469AvgcqtotqOVw+PFZDXJiN2a28i4bPD8mF4Cic8NTKoVuLzO
         vrpXR/aqn+Rs2RGNSzlGnFJsIJOmvZqCD+R2/KhhMPWzjvYDS6GkMC0U+gHBjdsAu6VO
         UJOJECJnETsb6tW1MCcAvOlmp2rjxYEFmkT8E3bLPTuRAKUJxupRobE/bHhwwk5t/iFE
         e6XdZFPP3xBBLtd8QMNVD+wkGaOFzOJPd7/L0vAML3fwBmdS5GLSFxoW0k0Kx0TjjTu5
         KJVW79WbcbHC+t7hWDzeY1JDHQGkxdZ7bfCwRktxy0Jxx5cTHEhm5fEWn0Q8XISSQgSb
         NNXg==
X-Gm-Message-State: APjAAAVqpPxJ6FIE66cnYlwr7qBAIWnJ9A2p7GI7Xfbzb70qUh7xqtAQ
        qoBc1y1GIrSUM7dp8RvDIt57dnVw2soLucLcwC2X+Z09zVNwpGJvYPtVZflPQlrxg6VYS5KqOsh
        9IYBooB+aFU8tdWNz
X-Received: by 2002:a1c:7419:: with SMTP id p25mr4016915wmc.129.1579953426254;
        Sat, 25 Jan 2020 03:57:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzi9GdomOZq3g5VkCRdPLCB9AExgpz9ySSC8ULhMxqt/FlMjG0SJHnHiZxt/6l+XesffVa00g==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr4016897wmc.129.1579953425887;
        Sat, 25 Jan 2020 03:57:05 -0800 (PST)
Received: from p271.fit.wifi.vutbr.cz ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id d14sm12565705wru.9.2020.01.25.03.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:57:04 -0800 (PST)
Date:   Sat, 25 Jan 2020 12:57:02 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     James Chapman <jchapman@katalix.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
References: <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 11:55:35AM +0000, James Chapman wrote:
> On Tue, 21 Jan 2020 at 16:35, Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Mon, Jan 20, 2020 at 03:09:46PM +0000, Tom Parkin wrote:
> > > I'm struggling with it a bit though.  Wouldn't extending the hash key
> > > like this get expensive, especially for IPv6 addresses?
> > >
> > From what I recall, L2TP performances are already quite low. That's
> > certainly not a reason for making things worse, but I believe that
> > computing a 3 or 5 tuple hash should be low overhead in comparison.
> > But checking with real numbers would be interesting.
> >
> In my experience, poor L2TP data performance is usually the result of
> MTU config issues causing IP fragmentation in the tunnel. L2TPv3
> ethernet throughput is similar to ethernet bridge throughput in the
> setups that I know of.
> 
I said that because I remember I had tested L2TPv3 and VXLAN a few
years ago and I was surprised by the performance gap. I certainly can't
remember the details of the setup, but I'd be very surprised if I had
misconfigured the MTU.

> Like my colleague, Tom, I'm also struggling with this approach.
> 
I don't pretend that implementing scoped sessions IDs is trivial. It
just looks like the best way to solve the compatibility problem (IMHO).

> I can't see how replacing a lookup using a 32-bit hash key with one
> using a 260-bit or more key (128+128+4 for two IPv[46] addresses and
> the session ID) isn't going to hurt performance, let alone the
> per-session memory footprint. In addition, it is changing the scope of
> the session ID away from what is defined in the RFC.
> 
I don't see why we'd need to increase the l2tp_session's structure size.
We can already get the 3/5-tuple from the parent's tunnel socket. And
there are some low hanging fruits to pick if one wants to reduce L2TP's
memory footprint.

From a performance point of view, 3/5-tuple matches are quite common
operations in the networking stack. I don't expect that to be costly
compared to the rest of the L2TP Rx operations. And we certainly have
room to streamline the datapath if necessary.

> I think Linux shouldn't diverge from the spirit of the L2TPv3 RFC
> since the RFC is what implementors code against. Ridge's application
> relies on duplicated L2TPv3 session IDs which are scoped by the UDP
> 5-tuple address. But equally, there may be existing applications out
> there which rely on Linux performing L2TPv3 session lookup by session
> ID alone, as per the RFC. For IP-encap, Linux already does this, but
> not for UDP. What if we get a request to do so for UDP, for
> RFC-compliance? It would be straightforward to do as long as the
> session ID scope isn't restricted by the proposed patch.
> 
As long as the external behavior conforms to the RFC, I don't see any
problem. Local applications are still responsible for selecting
session-IDs. I don't see how they could be confused if the kernel
accepted more IDs, especially since that was the original behaviour.

> I'm not aware
> that such an application exists, but my point is that the RFC is a key
> document that implementors use when implementing applications so
> diverging from it seems more likely to result in unforseen problems
> later.
> 
I would have to read the RFC with scoped session IDs in mind, but, as
far as I can see, the only things that global session IDs allow which
can't be done with scoped session IDs are:
  * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
    vice-versa.
  * Accepting L2TPv3 packets from peers we're not connected to.

I don't find any of these to be desirable. Although Tom convinced me
that global session IDs are in the spirit of the RFC, I still don't
think that restricting their scope goes against it in any practical
way. The L2TPv3 control plane requires a two way communication, which
means that the session is bound to a given 3/5-tuple for control
messages. Why would the data plane behave differently?

I agree that it looks saner (and simpler) for a control plane to never
assign the same session ID to sessions running over different tunnels,
even if they have different 3/5-tuples. But that's the user space
control plane implementation's responsability to select unique session
IDs in this case. The fact that the kernel uses scoped or global IDs is
irrelevant. For unmanaged tunnels, the administrator has complete
control over the local and remote session IDs and is free to assign
them globally if it wants to, even if the kernel would have accepted
reusing session IDs.

> It's unfortunate that Linux previously unintentionally allowed L2TPv3
> session ID clashes and an application is in the field that relies on
> this behaviour. However, the change that fixed this (and introduced
> the reported regression) was back in March 2017 and the problem is
> only coming to light now. Of the options we have available, a knob to
> re-enable the old behaviour may be the best compromise after all.
> 
> Could we ask Ridge to submit a new version of his patch which includes
> a knob to enable it?
> 
But what would be the default behaviour? If it's "use global IDs", then
we'll keep breaking applications that used to work with older kernels.
Ridge would know how to revert to the ancient behaviour, but other
users would probably never know about the knob. And if we set the
default behaviour to "allow duplicate IDs for L2TPv3oUDP", then the
knob doesn't need to be implemented as part of Ridge's fix. It can
always be added later, if we ever decide to unify session lookups
accross L2TPoUDP and L2TPoIP and that extending the session hash key
proves not to be a practical solution.

Sorry for replying late. It's been a busy week.

