Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A34716A4C5
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBXLUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgBXLUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 06:20:34 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8CB220828;
        Mon, 24 Feb 2020 11:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582543234;
        bh=tfwxnUm8CTy64G41f2iMr9bjPIyqP0yFAFqjYV9SOYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FnM2JMMOaqo3jU/7fznFVD+LadG9PBNNBtKfvwkV4jblDtsqK1/uqVUVQqc7uf1cF
         AAD2elF8e05a0Y47WScHvQyp8eLtZPQjLNNyAs2WFWXTmnoZ0n8u6n4uKUhFe6G1Ja
         VH+gdhqHJxRWBqUuU4vEgOzijzhE7+Zx+uBTI0Ng=
Date:   Mon, 24 Feb 2020 19:20:26 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 devicetree 0/6] DT bindings for Felix DSA switch on
 LS1028A
Message-ID: <20200224112026.GF27688@dragon>
References: <20200223204716.26170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 10:47:10PM +0200, Vladimir Oltean wrote:
> This series officializes the device tree bindings for the embedded
> Ethernet switch on NXP LS1028A (and for the reference design board).
> The driver has been in the tree since v5.4-rc6.
> 
> It also performs some DT binding changes and minor cleanup, as per
> feedback received in v1 and v2:
> 
> - I've changed the DT bindings for the internal ports from "gmii" to
>   "internal". This means changing the ENETC phy-mode as well, for
>   uniformity. So I would like the entire series to be merged through a
>   single tree, probably the devicetree one - something which David
>   Miller has aggreed to, here [0].
> - Disabled all Ethernet ports in the LS1028A DTSI by default, which
>   means not only the newly introduced switch ports, but also RGMII
>   standalone port 1.
> 
> [0]: https://lkml.org/lkml/2020/2/19/973
> 
> Claudiu Manoil (2):
>   arm64: dts: fsl: ls1028a: add node for Felix switch
>   arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
> 
> Vladimir Oltean (4):
>   arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for ENETC
>     RCIE
>   arm64: dts: fsl: ls1028a: disable all enetc ports by default

I applied these 4 DTS patches with changing prefix to 'arm64: dts: ls1028a: '.

Shawn

>   net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
>   dt-bindings: net: dsa: ocelot: document the vsc9959 core
> 
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 116 ++++++++++++++++++
>  .../boot/dts/freescale/fsl-ls1028a-qds.dts    |   1 +
>  .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |  61 ++++++++-
>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |  89 +++++++++++++-
>  drivers/net/dsa/ocelot/felix.c                |   3 +-
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
>  6 files changed, 265 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt
> 
> -- 
> 2.17.1
> 
