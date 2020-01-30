Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B581814E58D
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgA3Weu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:34:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgA3Wet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 17:34:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580423687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EEM9HolciifAYz0GM4coblxGAsWe1f5rYSH3pnCoLuc=;
        b=PSjTGzO9csciF8yGlINcQOY85TNCxSnhsIF9p+lEbPXcA5XerLTGXG2BifhWplBcIIYOS5
        hTtuahPEuvregymJzwzNl9uaw13G6HsebDzO5qPkzzIsR8p1jVQQVh/piyzbIx3TgfEdN1
        kXd7otXPwtSYPU/Hjli+yrmMml+KEWw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-LLKb6pYuNGSJ5z-IZyNFxQ-1; Thu, 30 Jan 2020 17:34:44 -0500
X-MC-Unique: LLKb6pYuNGSJ5z-IZyNFxQ-1
Received: by mail-wr1-f70.google.com with SMTP id z14so2396199wrs.4
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 14:34:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EEM9HolciifAYz0GM4coblxGAsWe1f5rYSH3pnCoLuc=;
        b=dNeLoFh7FfgQ8YWkZ/OxQzj8DhG1fTiLhQywDaAaj2HNvqpjqK/Z1bVZpK2ajYdZhV
         DEUVRmJMmJLgFf2jaxuWLLu7E8rMR6r9zl8PPtIy1G8undsDRoG4qiDsRxMgGQg/PNHF
         5WBl/PFUEfdwMiWrHZ/hx8ZJRCEcgqCTkJVRTDZEZrRCbn8HtQgExrNMoeYS+LRSuPji
         h8OPtRGzX5JBWEdXGa85ZfRDGuR3CAT8CA/CvMKIU01djIqwdVhDDyTHap0UF8di0nm9
         00JJODx95kGW6OaY1TuJF3o+oIvW6HTyC2/UaFlqIEuIWfSS9uHdLwrVirjM8tavoMO1
         nqGA==
X-Gm-Message-State: APjAAAXMdlkt46CXl41LZZ3nRsK33pneQTdk7gelzISHNGW8ukfLmt7l
        MUakZ1pO4TXOzE2viyfz/kus6bjy0ypWiYF2ARtV00cGNX57QcI0c/ERyU3PJPiydaoWF31DpjJ
        OgA3Aui3EkxnxOwEw
X-Received: by 2002:adf:f18b:: with SMTP id h11mr8459854wro.56.1580423683543;
        Thu, 30 Jan 2020 14:34:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhV21aYvjRvl1XI3dZFswtf9b1Dxfsjn53FkxMaZOFDORT1n9OOk81bBRd3CkDXZkafkNC4g==
X-Received: by 2002:adf:f18b:: with SMTP id h11mr8459820wro.56.1580423683105;
        Thu, 30 Jan 2020 14:34:43 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id h2sm9436293wrt.45.2020.01.30.14.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 14:34:42 -0800 (PST)
Date:   Thu, 30 Jan 2020 23:34:40 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     James Chapman <jchapman@katalix.com>
Cc:     Tom Parkin <tparkin@katalix.com>,
        Ridge Kennedy <ridgek@alliedtelesis.co.nz>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200130223440.GA28541@pc-61.home>
References: <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
 <20200121163531.GA6469@localhost.localdomain>
 <CAEwTi7Q4JzaCwug3M8Aa9y1yFXm1qBjQvKq3eiw=ekBft9wETw@mail.gmail.com>
 <20200125115702.GB4023@p271.fit.wifi.vutbr.cz>
 <72007ca8-3ad4-62db-1b38-1ecefb82cb20@katalix.com>
 <20200129114419.GA11337@pc-61.home>
 <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7f9d7e-e13b-8254-6a90-fc08bade3e16@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 10:28:23AM +0000, James Chapman wrote:
> On 29/01/2020 11:44, Guillaume Nault wrote:
> > Since userspace is in charge of selecting the session ID, I still can't
> > see how having the kernel accept duplicate IDs goes against the RFC.
> > The kernel doesn't assign duplicate IDs on its own. Userspace has full
> > control on the IDs and can implement whatever constraint when assigning
> > session IDs (even the DOCSIS DEPI way of partioning the session ID
> > space).
> Perhaps another example might help.
> 
> Suppose there's an L2TPv3 app out there today that creates two tunnels
> to a peer, one of which is used as a hot-standby backup in case the main
> tunnel fails. This system uses separate network interfaces for the
> tunnels, e.g. a router using a mobile network as a backup. If the main
> tunnel fails, it switches traffic of sessions immediately into the
> second tunnel. Userspace is deliberately using the same session IDs in
> both tunnels in this case. This would work today for IP-encap, but not
> for UDP. However, if the kernel treats session IDs as scoped by 3-tuple,
> the application would break. The app would need to be modified to add
> each session ID into both tunnels to work again.
> 
That's an interesting use case. I can imagine how this works on Rx, but
how can packets be transmitted on the new tunnel? The session will
still send packets through the original tunnel with the original
3-tuple, and there's no way to reassign a session to a new tunnel. We
could probably rebind/reconnect the tunnel socket, but then why
creating the second tunnel in the kernel?

> >>> I would have to read the RFC with scoped session IDs in mind, but, as
> >>> far as I can see, the only things that global session IDs allow which
> >>> can't be done with scoped session IDs are:
> >>>   * Accepting L2TPoIP sessions to receive L2TPoUDP packets and
> >>>     vice-versa.
> >>>   * Accepting L2TPv3 packets from peers we're not connected to.
> >>>
> >>> I don't find any of these to be desirable. Although Tom convinced me
> >>> that global session IDs are in the spirit of the RFC, I still don't
> >>> think that restricting their scope goes against it in any practical
> >>> way. The L2TPv3 control plane requires a two way communication, which
> >>> means that the session is bound to a given 3/5-tuple for control
> >>> messages. Why would the data plane behave differently?
> >> The Cable Labs / DOCSIS DEPI protocol is a good example. It is based on
> >> L2TPv3 and uses the L2TPv3 data plane. It treats the session ID as
> >> unscoped and not associated with a given tunnel.
> >>
> > Fair enough. Then we could add a L2TP_ATTR_SCOPE netlink attribute to
> > sessions. A global scope would reject the session ID if another session
> > already exists with this ID in the same network namespace. Sessions with
> > global scope would be looked up solely based on their ID. A non-global
> > scope would allow a session ID to be duplicated as long as the 3/5-tuple
> > is different and no session uses this ID with global scope.
> >
> >>> I agree that it looks saner (and simpler) for a control plane to never
> >>> assign the same session ID to sessions running over different tunnels,
> >>> even if they have different 3/5-tuples. But that's the user space
> >>> control plane implementation's responsability to select unique session
> >>> IDs in this case. The fact that the kernel uses scoped or global IDs is
> >>> irrelevant. For unmanaged tunnels, the administrator has complete
> >>> control over the local and remote session IDs and is free to assign
> >>> them globally if it wants to, even if the kernel would have accepted
> >>> reusing session IDs.
> >> I disagree. Using scoped session IDs may break applications that assume
> >> RFC behaviour. I mentioned one example where session IDs are used
> >> unscoped above.
> >>
> > I'm sorry, but I still don't understand how could that break any
> > existing application.
> 
> Does my example of the hot-standby backup tunnel help?
> 
Yes, even though I'm not sure how it precisely translate in terms of
userspace/kernel interraction. But anyway, with L2TP_ATTR_SCOPE, we'd
have the possibility to keep session ID unscoped for l2tp_ip by
default. That should be enough to keep any such scenario working
without any modification.

> > For L2TPoUDP, session IDs are always looked up in the context of the
> > UDP socket. So even though the kernel has stopped accepting duplicate
> > IDs, the session IDs remain scoped in practice. And with the
> > application being responsible for assigning IDs, I don't see how making
> > the kernel less restrictive could break any existing implementation.
> > Again, userspace remains in full control for session ID assignment
> > policy.
> >
> > Then we have L2TPoIP, which does the opposite, always looks up sessions
> > globally and depends on session IDs being unique in the network
> > namespace. But Ridge's patch does not change that. Also, by adding the
> > L2TP_ATTR_SCOPE attribute (as defined above), we could keep this
> > behaviour (L2TPoIP session could have global scope by default).
> 
> I'm looking at this with an end goal of having the UDP rx path later
> modified to work the same way as IP-encap currently does. I know Linux
> has never worked this way in the L2TPv3 UDP path and no-one has
> requested that it does yet, but I think it would improve the
> implementation if UDP and IP encap behaved similarly.
> 
Yes, unifying UDP and IP encap would be really nice.

> L2TP_ATTR_SCOPE would be a good way for the app to select which
> behaviour it prefers.
> 
Yes. But do we agree that it's also a way to keep the existing
behaviour: unscoped for IP, scoped to the 5-tuple for UDP? That is, IP
and UDP encap would use a different default value when user space
doesn't request a specific behaviour.

> >> However, there might be an alternative solution to fix this for Ridge's
> >> use case that doesn't involve adding 3/5-tuple session ID lookups in the
> >> receive path or adding a control knob...
> >>
> >> My understanding is that Ridge's application uses unmanaged tunnels
> >> (like "ip l2tp" does). These use kernel sockets. The netlink tunnel
> >> create request does not indicate a valid tunnel socket fd. So we could
> >> use scoped session IDs for unmanaged UDP tunnels only. If Ridge's patch
> >> were tweaked to allow scoped IDs only for UDP unmanaged tunnels (adding
> >> a test for tunnel->fd < 0), managed tunnels would continue to work as
> >> they do now and any application that uses unmanaged tunnels would get
> >> scoped session IDs. No control knob or 3/5-tuple session ID lookups
> >> required.
> >>
> > Well, I'd prefer to not introduce another subtle behaviour change. What
> > does rejecting duplicate IDs bring us if the lookup is still done in
> > the context of the socket? If the point is to have RFC compliance, then
> > we'd also need to modify the lookup functions.
> > 
> I agree, it's not ideal. Rejecting duplicate IDs for UDP will allow the
> UDP rx path to be modified later to work the same way as IP. So my idea
> was to allow for that change to be made later but only for managed
> tunnels (sockets created by userspace). My worry with the original patch
> is that it suggests that session IDs for UDP are always scoped by the
> tunnel so tweaking it to apply only for unmanaged tunnels was a way of
> showing this.
> 
> However, you've convinced me now that scoping the session ID by
> 3/5-tuple could work. As long as there's a mechanism that lets
> applications choose whether the 3/5-tuple is ignored in the rx path, I'm
> ok with it.
> 
Do we agree that, with L2TP_ATTR_SCOPE being a long-term solution, we
shouldn't need to reject duplicate session IDs for UDP tunnels?

To summarise my idea:

  * Short term plan:
    Integrate a variant of Ridge's patch, as it's simple, can easily be
    backported to -stable and doesn't prevent the future use of global
    session IDs (as those will be specified with L2TP_ATTR_SCOPE).

  * Long term plan:
    Implement L2TP_ATTR_SCOPE, a session attribute defining if the
    session ID is global or scoped to the X-tuple (3-tuple for IP,
    5-tuple for UDP).
    Original behaviour would be respected to avoid breaking existing
    applications. So, by default, IP encapsulation would use global
    scope and UDP encapsulation would use 5-tuple scope.

Does that look like a good way forward?

