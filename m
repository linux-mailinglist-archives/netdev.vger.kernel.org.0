Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C9514C9E0
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgA2Lo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:44:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46922 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726068AbgA2Lo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 06:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580298266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KHnJ1yw3/OPxyc1j5qauNbjyn7J8GCURt5U/MpR84IU=;
        b=EHY7ip09VCSS6h+xTPUvdpu2jPPlOmXsYD69IYJq9vcKyCwAzlh0tHWCjkIe7BFjTmbx9M
        1FJRxlywOZlf9r5ePzbOEDVm6R4QbbUT0bi2Kxw2eawKjD1d2HR0zSxP3IR7YqzPyriV95
        okEXqtZip9e29vxE/bgkp9+I8jvEVEQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-Ai_uyNp7PBuZTqSv85bAxQ-1; Wed, 29 Jan 2020 06:44:24 -0500
X-MC-Unique: Ai_uyNp7PBuZTqSv85bAxQ-1
Received: by mail-wm1-f69.google.com with SMTP id y24so2230146wmj.8
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 03:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KHnJ1yw3/OPxyc1j5qauNbjyn7J8GCURt5U/MpR84IU=;
        b=ewj2+fQYfKyJ8Y/G7XZGFY+hiQmhcVDmCSwvwNG1fAO8fNYbmWjO6dUNUm7XxqjMAB
         QG2zLTqfwH2GQrqM34YCbs8UZ+n21BqKPap0prU4E6CcP3F0E6U7A/uDAOddYdwXGM3w
         zeutX2wPZqYxvvZmZVcW3fdKNyzOwgIedhOVZ3QCVnqiScXnOYB6Q8vhF3izIV5bHjPy
         cEGDIcRTbjoAFcL+6qeQr+AGZ6SPuxEZb1r92gjW44PtMBLrpEa/qXLjqVxdpt3WrgTL
         imE+V2XF0uqUPGsL9MvsDH+uFuwRinIKkCa2LczY/MSFEonoFXrmf4jX2fLiIG1uqyTy
         XEZA==
X-Gm-Message-State: APjAAAVlTqDeEQ/dIZkoxxYVojlm2D25aMN9vL3yPRXWWJSzMOEM9WDp
        ykKVSek9bt1QZwfKMbeCUKrNUgKXTU1QhV7Djql7vuqhq7SZbMYO2KFo2GNDMiD4G8aCNsHnrpw
        hbToR2VtCzQZSJL4K
X-Received: by 2002:adf:cd04:: with SMTP id w4mr7060297wrm.219.1580298263021;
        Wed, 29 Jan 2020 03:44:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZlFqqVU8mA4h0Q7daXUYTHhoPd8+evmGaa3AflfnKUCMobv3/O2fyLKdBsVo4FD7eoRStIA==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr7060255wrm.219.1580298262473;
        Wed, 29 Jan 2020 03:44:22 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 16sm2046393wmi.0.2020.01.29.03.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 03:44:21 -0800 (PST)
Date:   Wed, 29 Jan 2020 12:44:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     James Chapman <jchapman@katalix.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200129114419.GA11337@pc-61.home>
References: <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 09:25:30AM +0000, James Chapman wrote:
> On 25/01/2020 11:57, Guillaume Nault wrote:
> > On Wed, Jan 22, 2020 at 11:55:35AM +0000, James Chapman wrote:
> >> In my experience, poor L2TP data performance is usually the result of
> >> MTU config issues causing IP fragmentation in the tunnel. L2TPv3
> >> ethernet throughput is similar to ethernet bridge throughput in the
> >> setups that I know of.
> >>
> > I said that because I remember I had tested L2TPv3 and VXLAN a few
> > years ago and I was surprised by the performance gap. I certainly can't
> > remember the details of the setup, but I'd be very surprised if I had
> > misconfigured the MTU.
> 
> Fair enough. I'd be interested in your observations and ideas regarding
> improving performance at some point. But I suggest keep this thread
> focused on the session ID scope issue.
> 
I had started working on the data path more than a year ago, but never
got far enough to submit anything. I might revive this work if I find
enough time. But yes, sure, let's focus on the sessions IDs for now.

> >> I can't see how replacing a lookup using a 32-bit hash key with one
> >> using a 260-bit or more key (128+128+4 for two IPv[46] addresses and
> >> the session ID) isn't going to hurt performance, let alone the
> >> per-session memory footprint. In addition, it is changing the scope of
> >> the session ID away from what is defined in the RFC.
> >>
> > I don't see why we'd need to increase the l2tp_session's structure size.
> > We can already get the 3/5-tuple from the parent's tunnel socket. And
> > there are some low hanging fruits to pick if one wants to reduce L2TP's
> > memory footprint.
> >
> > From a performance point of view, 3/5-tuple matches are quite common
> > operations in the networking stack. I don't expect that to be costly
> > compared to the rest of the L2TP Rx operations. And we certainly have
> > room to streamline the datapath if necessary.
> 
> I was assuming the key used for the session ID lookup would be stored
> with the session so that we wouldn't have to prepare it for each and
> every packet receive.
> 
I don't think that we could store the hash in the session structure.
The tunnel socket could be rebound or reconnected, thus changing the
5/3-tuple from under us.

My idea was to lookup the hash bucket using only the session ID, then
select the session from this bucket by checking both the session ID and
the 5/3-tuple.

> >> I think Linux shouldn't diverge from the spirit of the L2TPv3 RFC
> >> since the RFC is what implementors code against. Ridge's application
> >> relies on duplicated L2TPv3 session IDs which are scoped by the UDP
> >> 5-tuple address. But equally, there may be existing applications out
> >> there which rely on Linux performing L2TPv3 session lookup by session
> >> ID alone, as per the RFC. For IP-encap, Linux already does this, but
> >> not for UDP. What if we get a request to do so for UDP, for
> >> RFC-compliance? It would be straightforward to do as long as the
> >> session ID scope isn't restricted by the proposed patch.
> >>
> > As long as the external behavior conforms to the RFC, I don't see any
> > problem. Local applications are still responsible for selecting
> > session-IDs. I don't see how they could be confused if the kernel
> > accepted more IDs, especially since that was the original behaviour.
> 
> But it wouldn't conform with the RFC.
> 
> RFC3931 says:
> 
>  The Session ID alone provides the necessary context for all further
>  packet processing, including the presence, size, and value of the
>  Cookie, the type of L2-Specific Sublayer, and the type of payload
>  being tunneled.
> 
> and also
> 
>  The data message format for tunneling data packets may be utilized
>  with or without the L2TP control channel, either via manual
>  configuration or via other signaling methods to pre-configure or
>  distribute L2TP session information.
> 
Since userspace is in charge of selecting the session ID, I still can't
see how having the kernel accept duplicate IDs goes against the RFC.
The kernel doesn't assign duplicate IDs on its own. Userspace has full
control on the IDs and can implement whatever constraint when assigning
session IDs (even the DOCSIS DEPI way of partioning the session ID
space).

> > I would have to read the RFC with scoped session IDs in mind, but, as
> > far as I can see, the only things that global session IDs allow which
> > can't be done with scoped session IDs are:
> >   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
> >     vice-versa.
> >   * Accepting L2TPv3 packets from peers we're not connected to.
> >
> > I don't find any of these to be desirable. Although Tom convinced me
> > that global session IDs are in the spirit of the RFC, I still don't
> > think that restricting their scope goes against it in any practical
> > way. The L2TPv3 control plane requires a two way communication, which
> > means that the session is bound to a given 3/5-tuple for control
> > messages. Why would the data plane behave differently?
> 
> The Cable Labs / DOCSIS DEPI protocol is a good example. It is based on
> L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
> unscoped and not associated with a given tunnel.
> 
Fair enough. Then we could add a L2TP_ATTR_SCOPE netlink attribute to
sessions. A global scope would reject the session ID if another session
already exists with this ID in the same network namespace. Sessions with
global scope would be looked up solely based on their ID. A non-global
scope would allow a session ID to be duplicated as long as the 3/5-tuple
is different and no session uses this ID with global scope.

> > I agree that it looks saner (and simpler) for a control plane to never
> > assign the same session ID to sessions running over different tunnels,
> > even if they have different 3/5-tuples. But that's the user space
> > control plane implementation's responsability to select unique session
> > IDs in this case. The fact that the kernel uses scoped or global IDs is
> > irrelevant. For unmanaged tunnels, the administrator has complete
> > control over the local and remote session IDs and is free to assign
> > them globally if it wants to, even if the kernel would have accepted
> > reusing session IDs.
> 
> I disagree. Using scoped session IDs may break applications that assume
> RFC behaviour. I mentioned one example where session IDs are used
> unscoped above.
> 
I'm sorry, but I still don't understand how could that break any
existing application.

For L2TPoUDP, session IDs are always looked up in the context of the
UDP socket. So even though the kernel has stopped accepting duplicate
IDs, the session IDs remain scoped in practice. And with the
application being responsible for assigning IDs, I don't see how making
the kernel less restrictive could break any existing implementation.
Again, userspace remains in full control for session ID assignment
policy.

Then we have L2TPoIP, which does the opposite, always looks up sessions
globally and depends on session IDs being unique in the network
namespace. But Ridge's patch does not change that. Also, by adding the
L2TP_ATTR_SCOPE attribute (as defined above), we could keep this
behaviour (L2TPoIP session could have global scope by default).

> >> Could we ask Ridge to submit a new version of his patch which includes
> >> a knob to enable it?
> >>
> > But what would be the default behaviour? If it's "use global IDs", then
> > we'll keep breaking applications that used to work with older kernels.
> > Ridge would know how to revert to the ancient behaviour, but other
> > users would probably never know about the knob. And if we set the
> > default behaviour to "allow duplicate IDs for L2TPv3oUDP", then the
> > knob doesn't need to be implemented as part of Ridge's fix. It can
> > always be added later, if we ever decide to unify session lookups
> > accross L2TPoUDP and L2TPoIP and that extending the session hash key
> > proves not to be a practical solution.
> 
> 
> The default would be the current behaviour: "global IDs". We'll be
> breaking applications that assume scoped session IDs, yes. But I think
> the number of these applications will be minimal given the RFC is clear
> that session IDs are unscoped and the kernel has worked this way for
> almost 3 years.
> 
> I think it's important that the kernel continues to treat the L2TPv3
> session ID as "global".
> 
I'm uncomfortable with this. 3 years is not that long, it's the typical
long term support time for community kernels (not even mentioning
"enterprise" distributions). Also, we have a report showing that the
current behaviour broke some use cases, while we never had any problem
reported for the ancient behaviour (which had been in place for 7
years). And finally, rejecting duplicate IDs, won't make the session ID
space global. As I pointed out earlier, L2TPoUDP sessions are still
going to be scoped in practice, because that's how lookup is done
currently. So I don't see what would be the benefit of artificially
limitting the sessions IDs accepted by the kernel (but I agree that
L2TPoIP session IDs have to remain unique in the network namespace).

> However, there might be an alternative solution to fix this for Ridge's
> use case that doesn't involve adding 3/5-tuple session ID lookups in the
> receive path or adding a control knob...
> 
> My understanding is that Ridge's application uses unmanaged tunnels
> (like "ip l2tp" does). These use kernel sockets. The netlink tunnel
> create request does not indicate a valid tunnel socket fd. So we could
> use scoped session IDs for unmanaged UDP tunnels only. If Ridge's patch
> were tweaked to allow scoped IDs only for UDP unmanaged tunnels (adding
> a test for tunnel->fd < 0), managed tunnels would continue to work as
> they do now and any application that uses unmanaged tunnels would get
> scoped session IDs. No control knob or 3/5-tuple session ID lookups
> required.
> 
Well, I'd prefer to not introduce another subtle behaviour change. What
does rejecting duplicate IDs bring us if the lookup is still done in
the context of the socket? If the point is to have RFC compliance, then
we'd also need to modify the lookup functions.

