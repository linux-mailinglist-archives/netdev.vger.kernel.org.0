Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE30E22F3CD
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgG0PYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:24:46 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:57242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgG0PYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:24:45 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0611A556;
        Mon, 27 Jul 2020 17:24:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595863482;
        bh=hn58FXoen2c5hcuISRfMrC94wTve/jP6MVCX4UPsroc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TOtgNg6pn3s4CV6PtqBt5qEUizjlIx1xUFx96IWigxmrT3YMsqB0DXGRkj4vQZKhJ
         GXrzdUZgZ2E5m///S4l/CetxjqLV70HM3VeKCZE2TabSV7P940Zdu31oVtM72MjfhA
         M9ByVH0+RH8+FbLn069fUH9DL2g224YPICVt+RVg=
Date:   Mon, 27 Jul 2020 18:24:34 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Healy <cphealy@gmail.com>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727152434.GF20890@pendragon.ideasonboard.com>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
 <20200727120545.GN1661457@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200727120545.GN1661457@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 27, 2020 at 02:05:45PM +0200, Andrew Lunn wrote:
> On Sun, Jul 26, 2020 at 08:01:25PM -0700, Chris Healy wrote:
> > It appears quite a few boards were affected by this micrel PHY driver change:
> > 
> > 2ccb0161a0e9eb06f538557d38987e436fc39b8d
> > 80bf72598663496d08b3c0231377db6a99d7fd68
> > 2de00450c0126ec8838f72157577578e85cae5d8
> > 820f8a870f6575acda1bf7f1a03c701c43ed5d79
> > 
> > I just updated the phy-mode with my board from rgmii to rgmii-id and
> > everything started working fine with net-next again:
> 
> Hi Chris
> 
> Is this a mainline supported board? Do you plan to submit a patch?
> 
> Laurent, does the change also work for your board? This is another one
> of those cases were a bug in the PHY driver, not respecting the
> phy-mode, has masked a bug in the device tree, using the wrong
> phy-mode. We had the same issue with the Atheros PHY a while back.

Yes, setting the phy-mode to rgmii-id fixes the issue.

Thank you everybody for your quick responses and very useful help !

On a side note, when the kernel boots, there's a ~10s delay for the
ethernet connection to come up:

[    4.050754] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
[   15.628528] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   15.676961] Sending DHCP requests ., OK
[   15.720925] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210

The LED on the connected switch confirms this, it lits up synchronously
with the "Link is up" message. It's not an urgent issue, but if someone
had a few pointers on how I could debug that, it would be appreciated.

-- 
Regards,

Laurent Pinchart
