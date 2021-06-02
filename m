Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E29397F28
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFBClK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:41:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhFBClI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 22:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3qVNE/QXB/qpTMMorkh/7KWm/TvbbrQ1imYAhkGJt3w=; b=TBIgmC0pg3+LNFG8Z01mdB/55E
        c4CITOibfFx0tiy5qBoIzo3ESis5yP25x9ViNxeNcMwNB9olRTRFiYiioal5hkKO7x/kVAcYUb1xL
        9HdvLBO2SYK5etYRN5s2HFMQfi77dbdBfKfOgNOQHOr5IXjp5wnADDkPVCZtKFfgP3JU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1loGmu-007Nr5-Fe; Wed, 02 Jun 2021 04:39:20 +0200
Date:   Wed, 2 Jun 2021 04:39:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] dt-bindings: net: add dt binding for
 realtek rtl82xx phy
Message-ID: <YLbvWKIE3FOhdzsl@lunn.ch>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601090408.22025-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +properties:
> +  rtl821x,clkout-disable:
> +    description: Disable CLKOUT clock.
> +    type: boolean
> +
> +  rtl821x,aldps-disable:
> +    description: Disable ALDPS mode.
> +    type: boolean

I think most of the problems are the ambiguity in the binding.

If rtl821x,clkout-disable is not present, should it enable the CLKOUT?
That needs clear define here.

Do we actually want a tristate here?

                rtl821x,clkout = <true>;

means ensure the clock is outputting.

                rtl821x,clkout = <false>;

means ensure the clock is not outputting.

And if the property is not in DT at all, leave the hardware alone, at
either its default value, or whatever came before has set it to?

    Andrew
