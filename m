Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEB29A1C6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbfHVVML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:12:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48788 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbfHVVML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6fPuCyNtPPHONbqitxGDkXj/u9ByqXfl6hc0qfPlS5k=; b=Z8rdHmDZCZ53dvugjnLpqbC+L
        3Ulx7byW/NVefVjP67+vtLKu+wAT5Gl+DVMlfkoz9480p1Ws/kyZdhIRd9iOh/r7DWi3S75CWgXN8
        2V2jeoFQlSP/fmjXEejk2EDl5lmEoip7+NIcOVw/bjIOdlVi3UFHBFXEtoTDtIP+8N9dZnE49Lkwl
        +eLmdywbkvZFnUOdFwa50KPYjYRXmJMCzMCzIFyXi6QxYTnfrqtkjbOx6l+hvMLLxLTs13k0FGZpC
        X+ZNFJ9mcz1cWayeuxZOkIMzRxnfXtonFqfNC/L/Z1GB5ImpbxY41df7UDwkAJ7AT5ofiUL5N8+yz
        P45N4wHlA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48168)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i0uNE-0000W5-M7; Thu, 22 Aug 2019 22:12:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i0uNA-00081K-Dh; Thu, 22 Aug 2019 22:11:56 +0100
Date:   Thu, 22 Aug 2019 22:11:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Nelson Chang <nelson.chang@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        linux-mips@vger.kernel.org, linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stefan Roese <sr@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: mediatek: Re-add support
 SGMII
Message-ID: <20190822211156.GV13294@shell.armlinux.org.uk>
References: <20190821144336.9259-1-opensource@vdorst.com>
 <20190821144336.9259-3-opensource@vdorst.com>
 <20190822144433.GT13294@shell.armlinux.org.uk>
 <20190822195033.Horde.hEW8FBGNfFrugQOCv0gaDfx@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190822195033.Horde.hEW8FBGNfFrugQOCv0gaDfx@www.vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rene,

On Thu, Aug 22, 2019 at 07:50:33PM +0000, René van Dorst wrote:
> Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:
> > Isn't this set for Cisco SGMII as well as for 802.3 1000BASE-X and
> > the up-clocked 2500BASE-X modes?
> > 
> > If so, is there a reason why 10Mbps and 100Mbps speeds aren't
> > supported on Cisco SGMII links?
> 
> I can only tell a bit about the mt7622 SOC, datasheet tells me that:
> 
> The SGMII is the interface between 10/100/1000/2500 Mbps PHY and Ethernet MAC,
> the spec is raised by Cisco in 1999, which is aims for pin reduction compare
> with the GMII. It uses 2 differential data pair for TX and RX with clock
> embedded bit stream to convey frame data and port ability information.
> The core leverages the 1000Base-X PCS and Auto-Negotiation from IEEE 802.3
> specification (clause 36/37). This IP can support up to 3.125G baud for
> 2.5Gbps
> (proprietary 2500Base-X) data rate of MAC by overclocking.
> 
> Also features tells me: Support 10/100/1000/2500 Mbps in full duplex mode and
> 10/100 Mbps in half duplex mode.

Yep, that is what I'd expect.  Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
