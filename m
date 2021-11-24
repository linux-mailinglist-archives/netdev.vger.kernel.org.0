Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA94645CF1A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 22:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244663AbhKXVin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 16:38:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhKXVin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 16:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EI7GShQSKTvjqRLbX+UM0VPPE9bnZ8M+LNJiC6UWQsc=; b=HscuuQondF46GO197L39boqbtv
        VQrmhfrngPlMwPA6h7kDARGUPKWAw+mL5g88U/0LLYYeJ1HcQeH7r0dFpMTgK6wQ/1qJAMexl82oj
        7HOMva1KyxyuLR8DMIRpI4r7SXsJSfT6kZAO1BVGCFM0ySWln0GJMoySiu8RttMM4AOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpzvI-00EY0k-OS; Wed, 24 Nov 2021 22:35:24 +0100
Date:   Wed, 24 Nov 2021 22:35:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Heidelberg <david@ixit.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        ~okias/devicetree@lists.sr.ht, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ethernet-controller: add 2.5G and 10G
 speeds
Message-ID: <YZ6wHOu07okJ1p+3@lunn.ch>
References: <20211124202046.81136-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124202046.81136-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 09:20:46PM +0100, David Heidelberg wrote:
> Both are already used by HW and drivers inside Linux.
> 
> Fix warnings as:
> arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml: ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
>         From schema: Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>

This is valid for the binding, but not all Linux implementations of
fixed-link support > 1G. Only the phylink one does. But that is
outside the scope of the binding document.

You probably should list all speeds in
drivers/net/phy/phy-core.c:phy_setting settings[]. They are all valid
when using phylink and fixed-link.

	Andrew
