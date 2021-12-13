Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352824730A2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbhLMPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:34:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240161AbhLMPeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=dJY05+1gZYPiJP0ruhyyNVXNhlDEUrFUFZE1MRI+O68=; b=mK
        8PrH6HtVteXVggNdT6k4v9dzBQy1fc4LM5rMv6ZfN7u8e15FwDCtmVEtf2fnk4kTihfUTDm1luVyz
        m+LIhR4a5MHMT2l0jLkGX9proWRmZ3pGrUpRB4pGNDm6Ve2kR7jCVhcloFMAXKZ4yjPQMA9iowuvL
        mH1SWElBNIMlvXM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mwnL4-00GPP7-Mi; Mon, 13 Dec 2021 16:34:06 +0100
Date:   Mon, 13 Dec 2021 16:34:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Andr=E9?= Werner <Andre.Werner@b-tu.de>
Cc:     netdev@vger.kernel.org, andre.werner@systec-electronic.com
Subject: Re: Help: Using DSA capabilities with Microchip KSZ8 Ethernet switch
 and i.MX8plus does not work
Message-ID: <Ybdn7gcxuWRb/BmW@lunn.ch>
References: <20211213082630.Horde.ZNGY1CvfyMcmXElbyNHgwGJ@webmail.b-tu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211213082630.Horde.ZNGY1CvfyMcmXElbyNHgwGJ@webmail.b-tu.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 08:26:30AM +0100, André Werner wrote:
> 
> Dear community,
> 
> trying to connect a custom board with i.MX8plus SOM to a Microchip KSZ8795
> Ethernet switch still fails. Searching on the Internet did not provide a
> solution anywhere. I was trying different suggestions and follow the steps
> provided in the DSA documentation. The switch is working at the SOM if it is
> not configured with the ksz8795 driver and DSA capabilities. Thus,
> electrical connections on the custom board seem working.
> 
> The switch uses tail tagging in the driver, so maybe the connection of the
> i.MX8 FEC driver and its internet acceleration features drop frames with
> length and CRC errors. I tried to disable all that RACC-features in the
> driver and I proved the configuration using devmem. It looks reasonable but
> I still did not see any receiving frames or see frames send to the host.
> Moreover, using VLAN from the manual of the DSA documentation still shows
> tail tagging switched on if reading the switch's configuration registers. I
> was wondering about that since I thought that this is not necessary when
> using VLAN capabilities.
> 
> Did anyone use an Ethernet switch e.g. Microchip KSZ8 family, with similar
> problems, and get it working?

The FEC is well tested with Marvell switches. But they put the DSA tag
at the beginning of the packet, not the tail.

Counters can be useful to see what is going on. What does ethtool -S
for the FEC show? Any statistics about errors greater than 0? The
KSZ8795 also has statistics. The stats for the CPU port will be
appended to the end of the FEC statistics. Anything interesting there?

	 Andrew
