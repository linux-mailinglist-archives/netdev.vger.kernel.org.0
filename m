Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EF739A413
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhFCPOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:14:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231846AbhFCPOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 11:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Fb2y9y2wTlsDnlaiZCRMP7KJ4VwgHPLw9e1s4N8XbZc=; b=VU
        8SgVaEtfICjnU2iMLl8aKwR5YGpx1SaxE8k6X7CUVI5Mvgz14pQzRFWbHLYDww60eKgmkiklD2nqt
        1ByBqbC4n74HsYw/3h/Bk3/ChMm+SWIlhqgzS71abeeAP/iMeXvQA/3p7IhcRVuwqQ7J2YvjmH8rT
        7mGe/zMHGGljyVU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lop1L-007dj0-UZ; Thu, 03 Jun 2021 17:12:31 +0200
Date:   Thu, 3 Jun 2021 17:12:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <YLjxX/XPDoRRIvYf@lunn.ch>
References: <20210603143453.if7hgifupx5k433b@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210603143453.if7hgifupx5k433b@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 04:34:53PM +0200, Pali Rohár wrote:
> Hello!
> 
> In commit 84e0f1c13806 ("powerpc/mpc85xx: Add MDIO bus muxing support to
> the board device tree(s)") was added following DT property into DT node:
> arch/powerpc/boot/dts/fsl/t1023rdb.dts fm1mac3: ethernet@e4000
> 
>     phy-connection-type = "sgmii-2500";
> 
> But currently kernel does not recognize this "sgmii-2500" phy mode. See
> file include/linux/phy.h. In my opinion it should be "2500base-x" as
> this is mode which operates at 2.5 Gbps.
> 
> I do not think that sgmii-2500 mode exist at all (correct me if I'm
> wrong).

Kind of exist, unofficially. Some vendors run SGMII over clocked at
2500. But there is no standard for it, and it is unclear how inband
signalling should work. Whenever i see code saying 2.5G SGMII, i
always ask, are you sure, is it really 2500BaseX? Mostly it gets
changed to 2500BaseX after review.

PHY mode sgmii-2500 does not exist in mainline.

	Andrew

