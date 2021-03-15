Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8005133AB5F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 07:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCOGB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 02:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhCOGB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 02:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6554E64DD1;
        Mon, 15 Mar 2021 06:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615788087;
        bh=drYFlIid6rsqUkgt0Cko/3Jdwkm243e1+tZlPErUmX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nA5GqDSOKxB0KaDZF6IQbql8tbEopmyQeyyGQniU9ZA7BaEGFv4yFCIKBNTymR4Yb
         6KyT0G2gWIcj7ap/Hsn1GoQ1B3uMD3xRDuYgHvso/C2ZkajwnWSUcVv/djv9Ps6yox
         PmUf9W76WRjLAe1Gv0jkyOKi2Iz0lpSQZ3QJ2WVW1ONgR4qEhalmQommguGkM9QJvq
         tzkDdbY4XARJmRHrK50KpFAPsTM3Xs2DhI+Lb8hHjc5dIWZUJXn4pA0VQgTtuu3mO4
         J5rHLeSywgd4t5cgIGhCJxlTqnHaD0MrgAkheTNAJo90i5zl4mqE3FlTv/tE0OAJ68
         tvwGp0Q60a8Yg==
Date:   Mon, 15 Mar 2021 14:01:21 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a: set up the real link
 speed for ENETC port 2
Message-ID: <20210315060121.GH11246@dragon>
References: <20210308130834.2994658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308130834.2994658-1-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 03:08:34PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In NXP LS1028A there is a MAC-to-MAC internal link between enetc_port2
> and mscc_felix_port4. This link operates at 2.5Gbps and is described as
> such for the mscc_felix_port4 node.
> 
> The reason for the discrepancy is a limitation in the PHY library
> support for fixed-link nodes. Due to the fact that the PHY library
> registers a software PHY which emulates the clause 22 register map, the
> drivers/net/phy/fixed_phy.c driver only supports speeds up to 1Gbps.
> 
> The mscc_felix_port4 node is probed by DSA, which does not use the PHY
> library directly, but phylink, and phylink has a different representation
> for fixed-link nodes, one that does not have the limitation of not being
> able to represent speeds > 1Gbps.
> 
> Since the enetc driver was converted to phylink too as of commit
> 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX"), the limitation
> has been practically lifted there too, and we can describe the real link
> speed in the device tree now.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
