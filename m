Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3880831B731
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhBOKdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 05:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhBOKdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 05:33:15 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CFBC061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 02:32:27 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i20so5579913edv.2
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 02:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dg1kbR1M2SLHicy4cXmZfoeWyMZM/kATeM5xaC4Dvx4=;
        b=Xg/EVUeJZw66Yw1D3Anhf9Hv647D67csorgJKXOvVQ/IaAZMllze+tHLhbiPapDYwa
         zXRIkL+VFbBRJWFjGSRsvtxJHPv8eLcXZ5UNBU5CANFYceC65zE4am80RwR4Q3LbOFrV
         RsQuUm0svvTEl+mtx7mifvJFfWnI+BVpLc2LeOtrhbweR9kqoTAOawWZ74kt/W+QgERQ
         Pfjqi26Kw0PyDl/VoroqErt8Sw4hAxmakPt8yoZUNbk/YsPKwK4kMO8Ugs4ILE42e7sv
         BrtBL4b60GxJefWWKAfRNm4RQF08WXf+fJ8hFRp0fjuS0J1BgSqlMF6Gp4mgROV/6HHX
         VwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dg1kbR1M2SLHicy4cXmZfoeWyMZM/kATeM5xaC4Dvx4=;
        b=VC6ngcUekJUcSc/Bfl66cdt1/YVQAgXgV0TSLqDE+l8JRpKWgCAceCO7ZJ6Pup3ukt
         Iz7tMBqY5TuBoZdJCwYUDHMEdeCSxEU8RnoAFBsJEdADNbtlRNjhi3DQBWktKgglLtke
         f3rILI4UpjFxEhTx/iuX2I8rudfcYyJzC4HUCGIRAwGIYHxkBilRedYl6a2HSEvRu1ow
         bUy8vtK46gKgXNYQj9FhhSXF7trXmTfWx6kFx6L8gkqfPrK3BnTx4qSl5dKOYHKDbNb3
         /MkCWBbM44CDmHX+JDOq8RIgwpYhiRGRJs+vk/00lhl5ZhUfrclfJE2T8cqk7FgTMWm7
         qQVQ==
X-Gm-Message-State: AOAM533yRw8RX0znZgjSMAyGvezvSbmL7TUEIX3xfGvBFsCfsHBSjiRD
        kL4OrM8ONzV3VQdekd8z3og=
X-Google-Smtp-Source: ABdhPJyAkLo0u5Lb8425WC5JtNFP2EmkA9UO/ZsiXjBpflL5hl2bg8A7kZ4DGj70JgpRZoQfgfDKug==
X-Received: by 2002:aa7:d80b:: with SMTP id v11mr14885185edq.17.1613385146582;
        Mon, 15 Feb 2021 02:32:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e22sm10332523edu.61.2021.02.15.02.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 02:32:26 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:32:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 5/6] man8/bridge.8: explain self vs master for
 "bridge fdb add"
Message-ID: <20210215103224.zpjhi5tiokov2gvy@skbuf>
References: <20210211104502.2081443-1-olteanv@gmail.com>
 <20210211104502.2081443-6-olteanv@gmail.com>
 <65b9d8b6-0b04-9ddc-1719-b3417cd6fb89@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b9d8b6-0b04-9ddc-1719-b3417cd6fb89@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandra,

On Mon, Feb 15, 2021 at 09:22:47AM +0100, Alexandra Winter wrote:
> In the section about 'bridge link set' Self vs master mention physical
> device vs software bridge. Would it make sense to use the same
> terminology here?

You mean like this?

.TP
.B self
operation is fulfilled by the driver of the specified network interface.

.TP
.B master
operation is fulfilled by the specified interface's master, for example
a bridge, which in turn may or may not notify the underlying network
interface driver. This flag is considered implicit by the kernel if
'self' was not specified.

> The attributes are listed under 'bridge fdb add' not under 'bridge fdb
> show'. Is it correct that the attributes displayed by 'show' are a
> 1-to-1 representation of the ones set by 'add'?

Bah, not quite. I'll try to summarize below.

> What about the entries that are not manually set, like bridge learned
> adresses? Is it possible to add some explanation about those as well?

Ok, challenge accepted. Here's my take on 'bridge fdb show', I haven't
used most of these options (I'm commenting solely based on code
inspection) so if anybody with more experience could chime in, I'd be
happy to adjust the wording.


.SS bridge fdb show - list forwarding entries.

This command displays the current forwarding table. By default all FDB
entries in the system are shown. The following options can be used to
reduce the number of displayed entries:

.TP
.B br
Filter the output to contain only the FDB entries of the specified
bridge, or belonging to ports of the specified bridge (optional).

.B brport
Filter the output to contain only the FDB entries present on the
specified network interface (bridge port). This flag is optional.

.B dev
Same as "brport".

.B vlan
Filter the output to contain only the FDB entries with the specified
VLAN ID (optional).

.B dynamic
Filter out the local/permanent (not forwarded) FDB entries.

.B state
Filter the output to contain only the FDB entries having the specified
state. The bridge FDB is modeled as a neighbouring protocol for
PF_BRIDGE (similar to what ARP is for IPv4 and ND is for IPv6).
Therefore, an FDB entry has a NUD ("Network Unreachability Detection")
state given by the generic neighbouring layer.

The following are the valid components of an FDB entry state (more than
one may be valid at the same time):

.B permanent
Associated with the generic NUD_PERMANENT state, which means that the L2
address of the neighbor has been statically configured by the user and
therefore there is no need for a neighbour resolution.
For the bridge FDB, it means that an FDB entry is 'local', i.e. the L2
address belongs to a local interface.

.B reachable
Associated with the generic NUD_REACHABLE state, which means that the L2
address has been resolved by the neighbouring protocol. A reachable
bridge FDB entry can have two sub-states (static and dynamic) detailed
below.

.B static
Associated with the generic NUD_NOARP state, which is used to denote a
neighbour for which no protocol is needed to resolve the mapping between
the L3 address and L2 address. For the bridge FDB, the neighbour
resolution protocol is source MAC address learning, therefore a static
FDB entry is one that has not been learnt.

.B dynamic
Is a NUD_REACHABLE entry that lacks the NUD_NOARP state, therefore has
been resolved through address learning.

.B stale
Associated with the generic NUD_STALE state. Denotes an FDB entry that
was last updated longer ago than the bridge's hold time, but not yet
removed. The hold time is equal to the forward_delay (if the STP
topology is still changing) or to the ageing_time otherwise.


.PP
In the resulting output, each FDB entry can have one or more of the
following flags:

.B self
This entry is present in the FDB of the specified network interface driver.

.B router
???

.B extern_learn
This entry has been added to the master interface's FDB by the lower
port driver, as a result of hardware address learning.

.B offload
This entry is present in the hardware FDB of a lower port and also
associated with an entry of the master interface.

.B master
This entry is present in the software FDB of the master interface of
this lower port.

.B sticky
This entry cannot be migrated to another port by the address learning
process.

.PP
With the
.B -statistics
option, the command becomes verbose. It prints out the last updated
and last used time for each entry.

> >  .B self
> > -- the address is associated with the port drivers fdb. Usually hardware
> > -  (default).
> > +- the operation is fulfilled directly by the driver for the specified network
> > +device. If the network device belongs to a master like a bridge, then the
> > +bridge is bypassed and not notified of this operation (and if the device does
> > +notify the bridge, it is driver-specific behavior and not mandated by this
> > +flag, check the driver for more details). The "bridge fdb add" command can also
> > +be used on the bridge device itself, and in this case, the added fdb entries
> > +will be locally terminated (not forwarded). In the latter case, the "self" flag
> > +is mandatory. 
> Maybe I misunderstand this sentence, but I can do a 'bridge fdb add' without 'self'
> on the bridge device. And the address shows up under 'bridge fdb show'.
> So what does mandatory mean here?

It's right in the next sentence:

> The flag is set by default if "master" is not specified.

It's mandatory and implicit if "master" is not specified, ergo 'bridge
fdb add dev br0' will work because 'master' is not specified (it is
implicitly 'bridge fdb add dev br0 self'. But 'bridge fdb add dev br0
master' will fail, because the 'self' flag is no longer implicit (since
'master' was specified) but mandatory and absent.

I'm not sure what I can do to improve this.
