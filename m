Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C393A5AA9
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhFMVhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 17:37:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhFMVhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 17:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mg4Lpxlg2vwXRq7IENBCwUP9tCkcfMn5TrmgBWwvVrs=; b=0txgwuGX11gGqdNfbJo7CfC1bv
        BLV+VwZn75me2Kax6Rkh11wzSbhu33Uxz7RXoJqU9hWy/jRPNtdZUFTA1cDPp9LaK2AeogMaU/4kA
        brCzoG+7l2LL+UessyKx454iL4zokwpBDvzjY5g1hNK07SqNtYX+eHXJ/2LNTrpDrrzU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsXlD-009Csz-GJ; Sun, 13 Jun 2021 23:35:15 +0200
Date:   Sun, 13 Jun 2021 23:35:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
Message-ID: <YMZ6E99Q/zuFh4b1@lunn.ch>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-3-mw@semihalf.com>
 <YMZg27EkTuebBXwo@lunn.ch>
 <CAPv3WKfWqdpntPKknZ+H+sscyH9mursvCUwe8Q1DH-wGpsWknQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKfWqdpntPKknZ+H+sscyH9mursvCUwe8Q1DH-wGpsWknQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> True. I picked the port type properties that are interpreted by
> phylink. Basically, I think that everything that's described in:
> devicetree/bindings/net/ethernet-controller.yaml
> is valid for the ACPI as well

So you are saying ACPI is just DT stuff into tables? Then why bother
with ACPI? Just use DT.

Right, O.K. Please document anything which phylink already supports:

hylink.c:		ret = fwnode_property_read_u32(fixed_node, "speed", &speed);
phylink.c:		if (fwnode_property_read_bool(fixed_node, "full-duplex"))
phylink.c:		if (fwnode_property_read_bool(fixed_node, "pause"))
phylink.c:		if (fwnode_property_read_bool(fixed_node, "asym-pause"))
phylink.c:		ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
phylink.c:		ret = fwnode_property_read_u32_array(fwnode, "fixed-link",
phylink.c:	if (dn || fwnode_property_present(fwnode, "fixed-link"))
phylink.c:	if ((fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&

If you are adding new properties, please do that In a separate patch,
which needs an ACPI maintainer to ACK it before it gets merged.

	 Andrew

