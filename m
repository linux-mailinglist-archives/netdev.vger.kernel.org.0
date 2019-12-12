Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219EB11D710
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfLLTbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:31:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730349AbfLLTbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 14:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=scTYhFS4gCZxtXXzzXGMtUTLl8jjS7IBFHIFMMYsAHs=; b=1DzgO9h9kwCosyav4PiUsyAkmM
        MrUxIw1TWK74U2H7Rb9VPBk9i7KDjdcmsm9zJDzUud7i/bfyE9TsDEmLZntV5Xi0Fapj7ivLCHQzM
        ybP1ZueTu7DtrRZFTt71MIRnd4cvObLE27OUPqMU064WsrJ18YgpkCYkF6EKa13y2SiM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ifUBN-0004aT-UX; Thu, 12 Dec 2019 20:31:29 +0100
Date:   Thu, 12 Dec 2019 20:31:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212193129.GF30053@lunn.ch>
References: <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> index bd881497b872..8f61cae9d3b0 100644
> --- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> +++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
> @@ -408,6 +408,11 @@ port@5 {
>  				reg = <5>;
>  				label = "cpu";
>  				ethernet = <&cp1_eth2>;
> +
> +				fixed-link {
> +					speed = <2500>;
> +					full-duplex;
> +				};
>  			};
>  		};

The DSA driver is expected to configure the CPU port at its maximum
speed. You should only add a fixed link if you need to slow it down.
I expect 2500 is the maximum speed of this port.

  Andrew
