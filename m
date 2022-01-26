Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D618A49CAF3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbiAZNg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:36:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233208AbiAZNg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/5ue71kmL2h4LWcj6pXkYjWtIJCP5T9x8ay3aCSwqhM=; b=mHueb7dI9SdXd/Oaw8DN23GYUI
        Ycf5aktSYPmd3r6tdSdJragw4sKlk9rLDgZVU0oIW/Pw2DgAGTeLZ6tOgAQlD6V6wK2ud5tF9/vGG
        8gJOY7iBfYVJ3HCZI9ETTpDxMOWpMsFvs/D2+QmT+wGm7hh6Xxt9dCvF70gRp7GOsIfw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCiTk-002oTB-U5; Wed, 26 Jan 2022 14:36:52 +0100
Date:   Wed, 26 Jan 2022 14:36:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] dt-bindings: net: xgmac_mdio: Add
 "clock-frequency" and "suppress-preamble"
Message-ID: <YfFOdGa7iVFQK7EZ@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-6-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126101432.822818-6-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:14:32AM +0100, Tobias Waldekranz wrote:
> The driver now supports the standard "clock-frequency" and
> "suppress-preamble" properties, do document them in the binding
> description.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

However, you could convert to yaml as well, if you wanted.

> +- clocks
> +		Usage: optional
> +		Value type: <phandle>
> +		Definition: A reference to the input clock of the controller
> +		from which the MDC frequency is derived.

That answers my question. However, in the presence of a
'clock-frequency' property it cannot be optional, so -ENODEV seems
reasonable if it is missing. Potentially you also need to handle
-EPROBE_DEFER, although it seems quiet unlikely for an internal SoC
clock.

	Andrew
