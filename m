Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000241C0B28
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgEAABd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:01:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgEAABc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 20:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dQJZqv0jbv8xJipHeV964cSitXyw0u38aI2IjcFctcg=; b=S/lpXOL2loivCVqVHYJrQr0EHp
        QgpZTNRwSmTxzesaGFAK2RPu3COj+YrWHD48+2K1p01kRruyU0geAvv1te3K0ZgUivfNrMlsYUBAW
        5gyteqBVPDc9kEFGeP4vuk7NK/XXgXR5vmV/kHp1E5PV5S5+kOPY+6lTtSxEA3SeI34Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUJ7P-000U6j-0M; Fri, 01 May 2020 02:01:27 +0200
Date:   Fri, 1 May 2020 02:01:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 5/5] dt-bindings: marvell,prestera: Add
 address mapping for Prestera Switchdev PCIe driver
Message-ID: <20200501000126.GD22077@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-6-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430232052.9016-6-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 02:20:52AM +0300, Vadym Kochan wrote:
> Document requirement for the PCI port which is connected to the ASIC, to
> allow access to the firmware related registers.
> 
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> ---
>  .../devicetree/bindings/net/marvell,prestera.txt    | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.txt b/Documentation/devicetree/bindings/net/marvell,prestera.txt
> index 83370ebf5b89..103c35cfa8a7 100644
> --- a/Documentation/devicetree/bindings/net/marvell,prestera.txt
> +++ b/Documentation/devicetree/bindings/net/marvell,prestera.txt
> @@ -45,3 +45,16 @@ dfx-server {
>  	ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
>  	reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
>  };
> +
> +Marvell Prestera SwitchDev bindings
> +-----------------------------------
> +The current implementation of Prestera Switchdev PCI interface driver requires
> +that BAR2 is assigned to 0xf6000000 as base address from the PCI IO range:
> +
> +&cp0_pcie0 {
> +	ranges = <0x81000000 0x0 0xfb000000 0x0 0xfb000000 0x0 0xf0000
> +		0x82000000 0x0 0xf6000000 0x0 0xf6000000 0x0 0x2000000
> +		0x82000000 0x0 0xf9000000 0x0 0xf9000000 0x0 0x100000>;
> +	phys = <&cp0_comphy0 0>;
> +	status = "okay";

The base MAC address should be here as well. As was said for v1,
module parameters are bad.

       Andrew
