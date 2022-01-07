Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9E2487AC7
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348382AbiAGQzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:55:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240137AbiAGQza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 11:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=FkTExu1D4k82KDtMxdnFubWMlNtXlvkx9nkpxZUETKI=; b=M8
        ubU9Td1CyiMiw9EGk1w4kFsmdJfWUHwJi9V96VfK7XXCx3vjBfeo9Ia/AQy9CLSRjRE5BRBLe4PQY
        jjYfycPLSb91Rjwy7fiB6yPpSXjHL3+3EvBcCuJTO/JaO+w4BRX8vsmYP9HV73mh5k2W3UI9zBtfP
        w+FeIBx0d0Zxgec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5sWT-000mOt-9R; Fri, 07 Jan 2022 17:55:25 +0100
Date:   Fri, 7 Jan 2022 17:55:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] of: net: Add helper function of_get_ethdev_label()
Message-ID: <Ydhwfa/ECqTE3rLx@lunn.ch>
References: <20220107161222.14043-1-pali@kernel.org>
 <Ydhqa+9ya6nHsvLq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ydhqa+9ya6nHsvLq@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 04:29:31PM +0000, Russell King (Oracle) wrote:
> On Fri, Jan 07, 2022 at 05:12:21PM +0100, Pali Rohár wrote:
> > Adds a new helper function of_get_ethdev_label() which sets initial name of
> > specified netdev interface based on DT "label" property. It is same what is
> > doing DSA function dsa_port_parse_of() for DSA ports.
> > 
> > This helper function can be useful for drivers to make consistency between
> > DSA and netdev interface names.
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> Doesn't this also need a patch to update the DT binding document
> Documentation/devicetree/bindings/net/ethernet-controller.yaml ?
> 
> Also it needs a covering message for the series, and a well thought
> out argument why this is required. Consistency with DSA probably
> isn't a good enough reason.
> 
> >From what I remember, there have been a number of network interface
> naming proposals over the years, and as you can see, none of them have
> been successful... but who knows what will happen this time.

I agree with Russell here. I doubt this is going to be accepted.

DSA is special because DSA is very old, much older than DT, and maybe
older than udev. The old DSA platform drivers had a mechanism to
supply the interface name to the DSA core. When we added a DT binding
to DSA we kept that mechanism, since that mechanism had been used for
a long time.

Even if you could show there was a generic old mechanism, from before
the days of DT, that allowed interface names to be set from platform
drivers, i doubt it would be accepted because there is no continuity,
which DSA has.

      Andrew
