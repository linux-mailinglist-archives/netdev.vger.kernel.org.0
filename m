Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17F3F6A4A
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKJQuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:50:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 11:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zM5ApvmisTKS0QZHwZBZ3BCEBCQ7ne5nYq+QgXrTFcM=; b=xxRqUB4HuP1dAzRY58JxKG9M49
        BBeUejgTJRWP3wsqs/KjUiLeEOxvD4RJPHcHUIlIdr10jbyYmTdAkfWyaadYthRQr09+ZsgOQky52
        DPe8DJpCqp180XzmW80diDMuaJtKuRTTtUb5++0Bi4XZQiIoOVJLMQhfqVLbLv6PzYw8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTqQ3-0006vo-Bm; Sun, 10 Nov 2019 17:50:31 +0100
Date:   Sun, 10 Nov 2019 17:50:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
Message-ID: <20191110165031.GF25889@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-16-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109130301.13716-16-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
> queuing subsystem for terminating traffic locally).

So maybe that answers my last question.
 
> There are 2 issues with hardcoding the CPU port as #10:
> - It is not clear which snippets of the code are configuring something
>   for one of the CPU ports, and which snippets are just doing something
>   related to the number of physical ports.
> - Actually any physical port can act as a CPU port connected to an
>   external CPU (in addition to the local CPU). This is called NPI mode
>   (Node Processor Interface) and is the way that the 6-port VSC9959
>   (Felix) switch is integrated inside NXP LS1028A (the "local management
>   CPU" functionality is not used there).

So i'm having trouble reading this and spotting the difference between
the DSA concept of a CPU port and the two extra "CPU ports". Maybe
using the concept of virtual ports would help?

Are the physical ports number 0-9, and so port #10 is the first extra
"CPU port", aka a virtual port? And so that would not work for DSA,
where you need a physical port.

      Andrew
