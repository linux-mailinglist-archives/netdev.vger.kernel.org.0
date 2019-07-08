Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E837362C23
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGHWwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:52:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34399 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfGHWwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:52:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so8412305pgn.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 15:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ccO32iSQkWY9XaGVnuzS5kNZ45vxe+sEhqUvVfwX6XY=;
        b=WYQHCOxjU6LPaiQPBwA+k25DXEhT6AIfMO0RcBDs7WGIspMGLbe0UN+XcFPk+RMwnm
         f4MxrZs7JjbGtboL0cQ06g2tcBp3a08WrYEG+6szMhz3KtgwEOgqzCxRPSb7oURzbE+w
         pxdGDKtZV5TSvXxC8fStugK/VBRmhHeK1YB6sfFy8cZCn64DOKN9G6+NDj7JBynx61Zi
         ks+SYWosA6VMsaEig2phZCOvPR6U46pXajboQmg/PPum0NyZJiqPY86OVJhnhl1tDNx0
         Tv2FEUD5s374rp6WC6QwKdbMVgSQAiqFEuE/tLp3J55UP3kZH+0NxtgWOaYW92Dyy39G
         JB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ccO32iSQkWY9XaGVnuzS5kNZ45vxe+sEhqUvVfwX6XY=;
        b=pRuunqE7S09/YzEzDJu50Le42cidUObawlIjtuLUKoyEdg9BCbLaMTrhUTjrQdiytz
         8iSIXpgtJ6trQLR0abhY9GQro7utFySLNTw0RqKisDbUhGOgJCCJvi+5qIxRgfwSLfyv
         J7bx37dPrXdbAaX9nYhLjRpfBgpYCopEFezspSqGgratCAKm0/r0WMxC18AXdZqrc6gb
         BrTG5DSKSANXcA1BBivypunEqA8eUrzCrThbVpCum2UsQlMhpoDk7/yxLTCKms2dzirM
         tNxr2akO6yVJtkcscm3CAfVQbwrbQUMjOgavwYLiOthKAmf1rB40R1g6CM6deJaO4Wm6
         KwCg==
X-Gm-Message-State: APjAAAWgfR1I8TqAMqQZPSkm9PKweooU3Qd9ckkHbbLxCu+JwbSk4BJ/
        wwOHF+aMeNW6shEucoJVpcueOQ==
X-Google-Smtp-Source: APXvYqxLibmiRBIvmKZJxyHYSq9GUe9mHnNaIpxTNz+TfcQ+WNqrUiaLAWcMiCIFoeYUMIha63//GQ==
X-Received: by 2002:a63:34c3:: with SMTP id b186mr26438086pga.294.1562626323017;
        Mon, 08 Jul 2019 15:52:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r1sm20665173pfq.100.2019.07.08.15.52.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 15:52:02 -0700 (PDT)
Date:   Mon, 8 Jul 2019 15:51:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data
 paths
Message-ID: <20190708155158.3f75b57c@cakuba.netronome.com>
In-Reply-To: <20190708131908.GA13672@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
        <20190707.124541.451040901050013496.davem@davemloft.net>
        <20190708131908.GA13672@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Jul 2019 16:19:08 +0300, Ido Schimmel wrote:
> On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
> > From: Ido Schimmel <idosch@idosch.org>
> > Date: Sun,  7 Jul 2019 10:58:17 +0300
> >   
> > > Users have several ways to debug the kernel and understand why a packet
> > > was dropped. For example, using "drop monitor" and "perf". Both
> > > utilities trace kfree_skb(), which is the function called when a packet
> > > is freed as part of a failure. The information provided by these tools
> > > is invaluable when trying to understand the cause of a packet loss.
> > > 
> > > In recent years, large portions of the kernel data path were offloaded
> > > to capable devices. Today, it is possible to perform L2 and L3
> > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> > > Different TC classifiers and actions are also offloaded to capable
> > > devices, at both ingress and egress.
> > > 
> > > However, when the data path is offloaded it is not possible to achieve
> > > the same level of introspection as tools such "perf" and "drop monitor"
> > > become irrelevant.
> > > 
> > > This patchset aims to solve this by allowing users to monitor packets
> > > that the underlying device decided to drop along with relevant metadata
> > > such as the drop reason and ingress port.  
> > 
> > We are now going to have 5 or so ways to capture packets passing through
> > the system, this is nonsense.
> > 
> > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
> > devlink thing.
> > 
> > This is insanity, too many ways to do the same thing and therefore the
> > worst possible user experience.
> > 
> > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
> > XDP perf events, and these taps there too.
> > 
> > I mean really, think about it from the average user's perspective.  To
> > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
> > listen on devlink but configure a special tap thing beforehand and then
> > if someone is using XDP I gotta setup another perf event buffer capture
> > thing too.  
> 
> Let me try to explain again because I probably wasn't clear enough. The
> devlink-trap mechanism is not doing the same thing as other solutions.
> 
> The packets we are capturing in this patchset are packets that the
> kernel (the CPU) never saw up until now - they were silently dropped by
> the underlying device performing the packet forwarding instead of the
> CPU.

When you say silently dropped do you mean that mlxsw as of today
doesn't have any counters exposed for those events?

If we wanted to consolidate this into something existing we can either
 (a) add similar traps in the kernel data path;
 (b) make these traps extension of statistics.

My knee jerk reaction to seeing the patches was that it adds a new
place where device statistics are reported. Users who want to know why
things are dropped will not get detailed breakdown from ethtool -S which
for better or worse is the one stop shop for device stats today. 

Having thought about it some more, however, I think that having a
forwarding "exception" object and hanging statistics off of it is a
better design, even if we need to deal with some duplication to get
there.

IOW having an way to "trap all packets which would increment a
statistic" (option (b) above) is probably a bad design.

As for (a) I wonder how many of those events have a corresponding event
in the kernel stack? If we could add corresponding trace points and
just feed those from the device driver, that'd obviously be a holy
grail. Not to mention that requiring trace points to be added to the
core would make Alexei happy:

http://vger.kernel.org/netconf2019_files/netconf2019_slides_ast.pdf#page=3

;)

That's my $.02, not very insightful.

> For each such packet we get valuable metadata from the underlying device
> such as the drop reason and the ingress port. With time, even more
> reasons and metadata could be provided (e.g., egress port, traffic
> class). Netlink provides a structured and extensible way to report the
> packet along with the metadata to interested users. The tc-sample action
> uses a similar concept.
> 
> I would like to emphasize that these dropped packets are not injected to
> the kernel's receive path and therefore not subject to kfree_skb() and
> related infrastructure. There is no need to waste CPU cycles on packets
> we already know were dropped (and why). Further, hardware tail/early
> drops will not be dropped by the kernel, given its qdiscs are probably
> empty.
> 
> Regarding the use of devlink, current ASICs can forward packets at
> 6.4Tb/s. We do not want to overwhelm the CPU with dropped packets and
> therefore we give users the ability to control - via devlink - the
> trapping of certain packets to the CPU and their reporting to user
> space. In the future, devlink-trap can be extended to support the
> configuration of the hardware policers of each trap.
