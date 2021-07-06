Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C793BD7CC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 15:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhGFNa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 09:30:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhGFNa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 09:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iW5yXRiM6Z1EIUMT/gNK7q4J8fz+0rzrf1+DLiKdxpM=; b=SlEsc8WJ8dCWMCGBpOuP5kbHSX
        MQbmxA9+mGkDLJ46H816lJynbHV+Zzj0sHk+ZL+fgojNwBOs33QrmnXR09E3M2gv3lwoy4cG5u1Yp
        vk7jxpMGXCwQfEVQRrgoswm8CEWdScoVqO/cV1db6AID4SfQsnrVaTXBMP10FiZYQeOA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m0l7L-00CO3c-V0; Tue, 06 Jul 2021 15:28:03 +0200
Date:   Tue, 6 Jul 2021 15:28:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Cc:     dsahern@kernel.org, nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linus.luessing@c0d3.blue
Subject: Re: [PATCH] net: Allow any address multicast join for IP sockets
Message-ID: <YORaY83GiD56/su0@lunn.ch>
References: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 01:15:47PM +1200, Callum Sinclair wrote:
> For an application to receive all multicast packets in a range such as
> 224.0.0.1 - 239.255.255.255 each multicast IP address has to be joined
> explicitly one at a time.
> 
> Allow the any address to be passed to the IP_ADD_MEMBERSHIP and
> IPV6_ADD_MEMBERSHIP socket option per interface. By joining the any
> address the socket will receive all multicast packets that are received
> on the interface. 
> 
> This allows any IP socket to be used for IGMP or MLD snooping.

Do you really want all multicast frames, or just IGMP and MLD
messages?

What is the advantage of this solution over using pcap with a filter
which matches on multicast?

      Andrew
