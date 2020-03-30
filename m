Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06541980DD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgC3QVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:21:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54990 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgC3QVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GbfrIshVipFvZAaUf1xECIkK8WlmrkabDNVQKio9D9Y=; b=UJDmIbYlBC4pc+FsKIJfQ8Kwx
        1agOG49RfpD+Yffxt9aprr9scvddGG0N7u9x5hgezvCgSYkFHu/XVgeco3Q7Mxd8hacPf/5B0W6kp
        EYf1xfHlWbVA4fc370u6/jpnfQgCX+22ZJjIygBpCReTTpmOLB5nG6lEqZQHsKjMvHirRsGH+Zwbm
        yNSI2LAFLgt4S1VHxqW81piCZNCBk/qcwwmynuvxQyd3P8bF4kKN9KTHYd0BlW6RRpoV3L7O/PLGT
        vxWh22/NQwfbG/mllWZWRgu07Pj3QynNyGYHhednPvoU7YGRrMmaKEq5YGjN0dmUERCljYO51cUw1
        CCnIRZgkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43400)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIxAL-0003A0-0S; Mon, 30 Mar 2020 17:21:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIxAI-0007GI-Jw; Mon, 30 Mar 2020 17:21:30 +0100
Date:   Mon, 30 Mar 2020 17:21:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200330162130.GF25745@shell.armlinux.org.uk>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330161740.GC23477@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330161740.GC23477@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 06:17:40PM +0200, Andrew Lunn wrote:
> On Mon, Mar 30, 2020 at 07:01:36PM +0300, Codrin Ciubotariu wrote:
> > Some ethernet controllers, such as cadence's macb, have an embedded MDIO.
> > For this reason, the ethernet PHY nodes are not under an MDIO bus, but
> > directly under the ethernet node.
> 
> Hi Codrin
> 
> That is deprecated. It causes all sorts of problems putting PHY nodes
> in the MAC without a container.
> 
> Please fix macb to look for an mdio node, and place your fixed link
> inside it.

Seems wrong.

fixed links have never needed to be under a mdio node - see
Documentation/devicetree/bindings/net/ethernet-controller.yaml

fixed-link is a child of the MAC controller, not of a mdio node.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
