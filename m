Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1DD45F157
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351995AbhKZQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:13:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53698 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349878AbhKZQLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=f7Uv7t+NsuUWnD5UFstPbXp4VqyfSzBZwWTUeqyMj1g=; b=1qp6WjW/Iu2Mz6oh/JQru3hseu
        x92k8G0r0mhBZq93NPbehwvtuJQe3MhMXD19rCMoyIWGT8OSEdUKXpDZ6Wmnx3nMBVgh3o94/6Hcd
        2q2lMMC8WXVsYiJ/R93Gsx/Cpv+POOizH7ByPHhzmtTij/0faG9nMlbTMzG7SM6oQrIk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqdm2-00Ehyx-MC; Fri, 26 Nov 2021 17:08:30 +0100
Date:   Fri, 26 Nov 2021 17:08:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Message-ID: <YaEGfrvdS0h0RAWf@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:42:48PM +0100, Holger Brunck wrote:
> This can be configured from the device tree. Add this property to the
> documentation accordingly.
> The eight different values added in the dt-bindings file correspond to
> the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> according to the datasheet.
> 
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
> ---
>  .../devicetree/bindings/net/dsa/marvell.txt    |  3 +++
>  include/dt-bindings/net/mv-88e6xxx.h           | 18 ++++++++++++++++++
>  2 files changed, 21 insertions(+)
>  create mode 100644 include/dt-bindings/net/mv-88e6xxx.h
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> index 2363b412410c..bff397a2dc49 100644
> --- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> @@ -46,6 +46,9 @@ Optional properties:
>  - mdio?		: Container of PHYs and devices on the external MDIO
>  			  bus. The node must contains a compatible string of
>  			  "marvell,mv88e6xxx-mdio-external"
> +- serdes-output-amplitude: Configure the output amplitude of the serdes
> +			   interface.
> +    serdes-output-amplitude = <MV88E6352_SERDES_OUT_AMP_210MV>;

Please make this actually millivolts, not an enum. Have the property
called serdes-output-amplitude-mv. The driver should convert from a mv
value to whatever value you need to write to the register, or return
-EINVAL.

	Andrew
