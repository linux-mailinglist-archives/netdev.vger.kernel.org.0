Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DA2559BF
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFYVNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:13:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58778 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=A/NQpvmNbFWHvMWWPlx4XYpVJM2W6vODhSI5tf99DfA=; b=00wSm6HoiE+w8Fg/YaQagOZy3
        lBhwJjPAnC2sND4z+XSNrDxdKiedGkeLq5zw9EaggrPRm1DRYVG5SINz6uzSRP15jnuK7+f8c3w6g
        CfPYTWgSK1Z1TnM1jDohTQwrCGc0LzoWKpqG4YuBww1DCF0okd7sitGI2Qps8K8Y1b4P1ZXS7yt1a
        hgCDRjqaaHUKP9tCkPO+/O0eL8gcHeGRwdx9iWU7VX40Altri+h7F9MjCr9O1xDDzv2hveJkZbeSa
        OoMPUK9+aXdCmvLOSn1dOOSqIx2JuPeIM6ggloXHkitTA6vITKU9eGaHfnUyprdEKspNV7gHl5lrB
        nniGyiXlA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60002)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfskW-0000Y4-Jd; Tue, 25 Jun 2019 22:13:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfskO-0007YA-Rz; Tue, 25 Jun 2019 22:13:00 +0100
Date:   Tue, 25 Jun 2019 22:13:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Santos <daniel.santos@pobox.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190625211300.4hywbhyt6nj5pmvt@shell.armlinux.org.uk>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
 <20190625190246.GA27733@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625190246.GA27733@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 09:02:46PM +0200, Andrew Lunn wrote:
> > But will there still be a mechanism to ignore link partner's advertising
> > and force these parameters?
> 
> From man 1 ethtool:
> 
>        -a --show-pause
>               Queries the specified Ethernet device for pause parameter information.
> 
>        -A --pause
>               Changes the pause parameters of the specified Ethernet device.
> 
>            autoneg on|off
>                   Specifies whether pause autonegotiation should be enabled.
> 
>            rx on|off
>                   Specifies whether RX pause should be enabled.
> 
>            tx on|off
>                   Specifies whether TX pause should be enabled.
> 
> You need to check the driver to see if it actually implements this
> ethtool call, but that is how it should be configured.

Note that phylink provides this call, and provided mac_config() is
correctly implemented, will result in the pause mode parameters in
the MAC being correctly set.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
