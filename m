Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12A51E8A0B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgE2VaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 17:30:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbgE2VaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 17:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EjeQ19nbXVFnrPaJuA6nByzgVYQHLpECzUkme2m6ZJg=; b=Bzs1i5FY6gDhqz5dw22fVgCH+5
        yGk9i8r4QRg3Yv06muM526S+47nti+ir64nZJL6zuhg0sigIpX2JyXTpT3x8C1xh1w0DWaNg8xvLT
        UqQssVPCzqYmKSnf1DW2g+BOvCiQ208FI873sP/WSlfk1KtXCjgAeh2eZ4N5Dyo/6x+A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jemZk-003god-R6; Fri, 29 May 2020 23:30:00 +0200
Date:   Fri, 29 May 2020 23:30:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed link and RGMII support
Message-ID: <20200529213000.GO869823@lunn.ch>
References: <20200529193003.3717-1-rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529193003.3717-1-rberg@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 09:30:02PM +0200, Roelof Berg wrote:
> Microchip lan7431 is frequently connected to a phy. However, it
> can also be directly connected to a MII remote peer without
> any phy in between. For supporting such a phyless hardware setup
> in Linux we utilized phylib, which supports a fixed-link
> configuration via the device tree. And we added support for
> defining the connection type R/GMII in the device tree.
> 
> New behavior:
> -------------
> . The automatic speed and duplex detection of the lan743x silicon
>   between mac and phy is disabled. Instead phylib is used like in
>   other typical Linux drivers. The usage of phylib allows to
>   specify fixed-link parameters in the device tree.
> 
> . The device tree entry phy-connection-type is supported now with
>   the modes RGMII or (G)MII (default).
> 
> Development state:
> ------------------
> . Tested with fixed-phy configurations. Not yet tested in normal
>   configurations with phy. Microchip kindly offered testing
>   as soon as the Corona measures allow this.
> 
> . All review findings of Andrew Lunn are included
> 
> Example:
> --------
> &pcie {
> 	status = "okay";
> 
> 	host@0 {
> 		reg = <0 0 0 0 0>;
> 
> 		#address-cells = <3>;
> 		#size-cells = <2>;
> 
> 		ethernet@0 {
> 			compatible = "weyland-yutani,noscom1", "microchip,lan743x";
> 			status = "okay";
> 			reg = <0 0 0 0 0>;
> 			phy-connection-type = "rgmii";
> 
> 			fixed-link {
> 				speed = <100>;
> 				full-duplex;
> 			};
> 		};
> 	};
> };
> 
> Signed-off-by: Roelof Berg <rberg@berg-solutions.de>

Hi Roelof

It looks like you took my suggestion as a basis. So i should give you:

Signed-off-by: Andrew Lunn <andrew@lunn.ch>

since i did not include one in my posting. I'm happy to see it helped,
and fixed some other issues you were seeing.

    Andrew
