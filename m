Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2AA48FF65
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 23:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiAPWC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 17:02:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbiAPWC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 17:02:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3knO7OSDFmDrjBjUFT/RKq5UesrI35HL2yAjB5FjxUQ=; b=KKqMO7ku8+sHLs6c2XiTL5FYUM
        X/U+EMcydUfqksaFOUHi7pLm6xHOZxFzf/wmEtLiNY5hvjBtbjcWsi/5kEXmFvs9P4gLJBYJhM9St
        X6imZ6F02flpYAKBRyXWkuX3Xj+VSpWJMcZmFzuz1gJKvEPG3rKLlyBOH+f4nnF3PFmM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9DbP-001YxH-83; Sun, 16 Jan 2022 23:02:19 +0100
Date:   Sun, 16 Jan 2022 23:02:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, madalin.bucur@nxp.com,
        robh+dt@kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 1/4] net/fsl: xgmac_mdio: Add workaround for erratum
 A-009885
Message-ID: <YeSV67WeMTSDigUK@lunn.ch>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220116211529.25604-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 10:15:26PM +0100, Tobias Waldekranz wrote:
> Once an MDIO read transaction is initiated, we must read back the data
> register within 16 MDC cycles after the transaction completes. Outside
> of this window, reads may return corrupt data.
> 
> Therefore, disable local interrupts in the critical section, to
> maximize the probability that we can satisfy this requirement.

Since this is for net, a Fixes: tag would be nice. Maybe that would be
for the commit which added this driver, or maybe when the DTSI files
for the SOCs which have this errata we added?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
