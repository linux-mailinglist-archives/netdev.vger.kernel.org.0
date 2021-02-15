Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA831BABE
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhBOOIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:08:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhBOOId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 09:08:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lBeXR-006RWz-Jq; Mon, 15 Feb 2021 15:07:45 +0100
Date:   Mon, 15 Feb 2021 15:07:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
Message-ID: <YCqAMUfinMsnZnrq@lunn.ch>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
 <20210210085255.2006824-3-steen.hegelund@microchip.com>
 <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
 <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
 <704b850f-9345-2e36-e84b-b332fed22270@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <704b850f-9345-2e36-e84b-b332fed22270@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 05:25:10PM +0530, Kishon Vijay Abraham I wrote:
> Okay. Is it going to be some sort of manual negotiation where the
> Ethernet controller invokes set_speed with different speeds? Or the
> Ethernet controller will get the speed using some out of band mechanism
> and invokes set_speed once with the actual speed?

Hi Kishon

There are a few different mechanism possible.

The SFP has an EEPROM which contains lots of parameters. One is the
maximum baud rate the module supports. PHYLINK will combine this
information with the MAC capabilities to determine the default speed.

The users can select the mode the MAC works in, e.g. 1000BaseX vs
2500BaseX, via ethtool -s. Different modes needs different speeds.

Some copper PHYs will change there host side interface baud rate when
the media side interface changes mode. 10GBASE-X for 10G copper,
5GBase-X for 5G COPPER, 2500Base-X for 2.5G copper, and SGMII for
old school 10/100/1G Ethernet.

Mainline Linux has no support for it, but some 'vendor crap' will do a
manual negotiation, simply trying different speeds and see if the
SERDES establishes link. There is nothing standardised for this, as
far as i know.

    Andrew
