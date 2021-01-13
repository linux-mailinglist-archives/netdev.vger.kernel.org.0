Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA302F41C7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbhAMC37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbhAMC37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D021230FC;
        Wed, 13 Jan 2021 02:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610504958;
        bh=bwM/+4ZnOGn6R3CazElX5qW00u0dfS0O09MDa1BPvuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E02d5Ka3mvTpI4gj7Q65dC5OLUSxbVS10uHkdFLW+LnH5Z3gmytVkVxpyGTBWkDtm
         bTPR3Z9SXPUnPXOn/bdt48cfv4ABTTJgcCBkrSofkULHkOfrugfaK8VaERNmtgASJj
         JDnZ0J/mdCqDpEh8+blAI6qKJ+DXLaHXCFbBP1bxE6BBtCUY77BwxG8Iu9mmBikH+0
         cccpWiRYwSk+qVKBWpQsy/uS1yhFZgVo6h4WPdAGX/Z9yckqL9xFMBYy/LG8nMSO7m
         gOujYfH5b19wuZ8mnmzUjQheWVOa2sUKR6lsHNUR/5VgLHPNybCNnKSWNmLDHlXpMQ
         huNOEjepd/QCw==
Date:   Tue, 12 Jan 2021 18:29:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net 1/2] net: stmmac: fix taprio schedule configuration
Message-ID: <20210112182917.43a1edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112172457.20539-1-yannick.vignon@oss.nxp.com>
References: <20210112172457.20539-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 18:24:56 +0100 Yannick Vignon wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> When configuring a 802.1Qbv schedule through the tc taprio qdisc on an NXP
> i.MX8MPlus device, the effective cycle time differed from the requested one
> by N*96ns, with N number of entries in the Qbv Gate Control List. This is
> because the driver was adding a 96ns margin to each interval of the GCL,
> apparently to account for the IPG. The problem was observed on NXP
> i.MX8MPlus devices but likely affected all devices relying on the same
> configuration callback (dwmac 4.00, 4.10, 5.10 variants).
> 
> Fix the issue by removing the margins, and simply setup the MAC with the
> provided cycle time value. This is the behavior expected by the user-space
> API, as altering the Qbv schedule timings would break standards conformance.
> This is also the behavior of several other Ethernet MAC implementations
> supporting taprio, including the dwxgmac variant of stmmac.
> 
> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>

Thanks for the patches, could you repost and include appropriate Fixes
tags?

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

> +	u32 ctrl;
> 	int i, ret = 0x0;

Please keep the variable declaration lines sorted longest to shortest
in both patches.
