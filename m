Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE69C3B1AEE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFWNTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:19:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhFWNTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l3Mdl37ptulzi/amZuYMo3pqLMLTnrhN/xeuh+SnyY8=; b=kj1EEQcNerDvoNaOpZPQx+HRzu
        ebWZrS0pOrocIWAhBnbn+/i9T/S82Fkb/O7sg09rffUiVIKuoX+Zc+31QPNK7RtOY5dg1pSvTtUtb
        RvMknfGRuDsyiMjxY8xUILT+kRu7/kjp+8x1m18gJHxERyA00gi+wzWL2deEobmxqkYU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw2kl-00AqVp-2V; Wed, 23 Jun 2021 15:17:15 +0200
Date:   Wed, 23 Jun 2021 15:17:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <YNM0Wz1wb4dnCg5/@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-2-lukma@denx.de>
 <YNH3mb9fyBjLf0fj@lunn.ch>
 <20210622225134.4811b88f@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622225134.4811b88f@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 10:51:34PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
> > > The 'eth_switch' node is now extendfed to enable support for L2
> > > switch.
> > > 
> > > Moreover, the mac[01] nodes are defined as well and linked to the
> > > former with 'phy-handle' property.  
> > 
> > A phy-handle points to a phy, not a MAC! Don't abuse a well known DT
> > property like this.
> 
> Ach.... You are right. I will change it.
> 
> Probably 'ethernet' property or 'link' will fit better?

You should first work on the overall architecture. I suspect you will
end up with something more like the DSA binding, and not have the FEC
nodes at all. Maybe the MDIO busses will appear under the switch?

Please don't put minimal changes to the FEC driver has your first
goal. We want an architecture which is similar to other switchdev
drivers. Maybe look at drivers/net/ethernet/ti/cpsw_new.c. The cpsw
driver has an interesting past, it did things the wrong way for a long
time, but the new switchdev driver has an architecture similar to what
the FEC driver could be like.

	Andrew
