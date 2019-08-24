Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA169BE08
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfHXNcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 09:32:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48222 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbfHXNcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 09:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KHhx6Ie16m3agM3oyiR904J/GzPfUFeS/cpVkces4OY=; b=KQ2WNi+3wj+TUeA22nFBkmqBN
        gwndjfYh++memDYTISgSG8YumxD7BAlcn0Mvp8xBPrZYYxCRdQ7g7FYuTL5uzxRLOsp9+BG+/NefZ
        nqX48vmt4TA2dhNxKdz6E4A6MZX0JznD8Rwghk/T/+Mcqt48XHhv4VL+QeEtygqbm1GTFPutfucjI
        leaEFkzav2/CixtoO+4K+B/GPZJtKnNV/lv1kG1bX6HPqFPhpbQuRSnvAo4R88eZQR6UJaVpTG0TM
        0GWJFeSywCrfatmbPAssUr+gplC7b/gykdRfl9JLQe++4UZcWUU6BaFaVeTMLOkI6WpXgSR4XcB44
        W+aXDJ2IA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33290)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1W9d-0003Gx-Nu; Sat, 24 Aug 2019 14:32:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1W9Z-0002eV-Ei; Sat, 24 Aug 2019 14:32:25 +0100
Date:   Sat, 24 Aug 2019 14:32:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: mediatek: Re-add support
 SGMII
Message-ID: <20190824133225.GE13294@shell.armlinux.org.uk>
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-3-opensource@vdorst.com>
 <20190824092156.GD13294@shell.armlinux.org.uk>
 <20190824131117.Horde.vSCF_CQ5jCMHcSTWkh7Woxm@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190824131117.Horde.vSCF_CQ5jCMHcSTWkh7Woxm@www.vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi René,

On Sat, Aug 24, 2019 at 01:11:17PM +0000, René van Dorst wrote:
> Hi Russell,
> 
> Mediatek calls it Turbo RGMII. It is a overclock version of RGMII mode.
> It is used between first GMAC and port 6 of the mt7530 switch. Can be used
> with
> an internal and an external mt7530 switch.
> 
> TRGMII speed are:
> * mt7621: 1200Mbit
> * mt7623: 2000Mbit and 2600Mbit.
> 
> I think that TRGMII is only used in a fixed-link situation in combination
> with a
> mt7530 switch and running and maximum speed/full duplex. So reporting
> 1000baseT_Full seems to me the right option.

I think we can ignore this one for the purposes of merging this patch
set, since this seems to be specific to this setup.  Neither 1000BaseT
nor 1000BaseX fit very well, but we have to choose something.

> PHY_INTERFACE_MODE_GMII:
> 	  10baseT_Half
> 	  10baseT_Full
> 	 100baseT_Half
> 	 100baseT_Full
> 	1000baseT_Half
> 	1000baseT_Full

I think GMII can be connected to a PHY that can convert to 1000BaseX, so
should probably include that here too.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
