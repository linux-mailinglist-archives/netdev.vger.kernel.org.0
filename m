Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CBE3AB5B0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhFQOUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:20:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhFQOUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 10:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3Ot9bRG4UGOhknIs3KrZRAdz/ZdNqp7qKa5NdrkwD8E=; b=f7Vtledvt65n+YULvHKCRKGw3S
        ioDeQSEVsjUPrpPyggJEEO383gSvdLOqIj7IfKepyx5J7cx8pxf8K3VKxe7sAVDbXJEJ3SGNRehlf
        FgK9GGV5ne0SEygEjB7ygQQDgUgxgKfjrmVdDoEkC1GJuJ+o55ArG5tW7hg/NfWJ8aVk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltsqg-009vL3-DN; Thu, 17 Jun 2021 16:18:26 +0200
Date:   Thu, 17 Jun 2021 16:18:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Cc:     dsahern@kernel.org, nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linus.luessing@c0d3.blue
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Message-ID: <YMtZspsYH0wd9SVf@lunn.ch>
References: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
 <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 09:50:20PM +1200, Callum Sinclair wrote:
> To receive IGMP or MLD packets on a IP socket on any interface the
> multicast group needs to be explicitly joined. This works well for when
> the multicast group the user is interested in is known, but does not
> provide an easy way to snoop all packets in the 224.0.0.0/8 or the
> FF00::/8 range.
> 
> Define a new sysctl to allow a given interface to become a IGMP or MLD
> snooper. When set the interface will allow any IGMP or MLD packet to be
> received on sockets bound to these devices.

Hi Callum

What is the big picture here? Are you trying to move the snooping
algorithm into user space? User space will then add/remove Multicast
FIB entries to the bridge to control where mulitcast frames are sent?

In the past i have written a multicast routing daemon. It is a similar
problem. You need access to all the join/leaves. But the stack does
provide them, if you bind to the multicast routing socket. Why not use
that mechanism? Look in the mrouted sources for an example.

     Andrew
