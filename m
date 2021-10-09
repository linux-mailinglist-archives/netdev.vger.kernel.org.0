Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6251427C49
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhJIRQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:16:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhJIRQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ew+yMrSTpg9IhspE8AzrvbQjeSk7geL9IQkRlqtQrgg=; b=vPqj3J7Bo/WKMJ78CT0g6nReZc
        DvWEvvl2WhOKZN8Kl+nkQr3ziXI3LmLpeOejfa7LPVDzS+3E+r/wWQe6e+vFphgzWxO+8FjDpfpI5
        si+FAbRjmi5ELppuesVfoD6NlSeAHOjPR5Jo0b9FAYyQH2cUL7h0APJd/x4HihC09rv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZFv4-00AALz-Ug; Sat, 09 Oct 2021 19:13:58 +0200
Date:   Sat, 9 Oct 2021 19:13:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 11/15] dt-bindings: net: dsa: qca8k: Document
 qca,sgmii-enable-pll
Message-ID: <YWHN1iDSelFQTPUC@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-12-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:21AM +0200, Ansuel Smith wrote:
> Document qca,sgmii-enable-pll binding used in the CPU nodes to
> enable SGMII PLL on MAC config.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 208ee5bc1bbb..b9cccb657373 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -50,6 +50,12 @@ A CPU port node has the following optional node:
>                            managed entity. See
>                            Documentation/devicetree/bindings/net/fixed-link.txt
>                            for details.
> +- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
> +                          chain along with Signal Detection.
> +                          This should NOT be enabled for qca8327.

So how about -EINVAL for qca8327, and document it is not valid then.

> +                          This can be required for qca8337 switch with revision 2.

Maybe add a warning if enabled with revision < 2? I would not make it
an error, because there could be devices manufactured with a mixture
or v1 and v2 silicon. Do you have any idea how wide spread v1 is?

> +                          With CPU port set to sgmii and qca8337 it is advised
> +                          to set this unless a communication problem is observed.

  Andrew
