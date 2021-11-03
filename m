Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37890443A87
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhKCAlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhKCAlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F271960F24;
        Wed,  3 Nov 2021 00:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635899924;
        bh=IADdOEF9lRlVoBcCABpgQbZIB9Dd/AMu4fq3dlVGaQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gkNwUyZjDO4imsbWpR/RdZfu0y6k9XEMTg4giwAtEFvIMy1a4YZLLn5Pe8ChORLj7
         dUafHb43O6tOVygh5oM06hrjChqjJ3IhwnSkG22QtudQN1ODLjtnrzIwONk+oUxQQV
         gcGFd45znOx5pREi2wmlB91AjR6IClLcGhxg8pat1I8eNhH1ayec1hF8e7j2sHUgZz
         x71JXDSf+1DkAFR4aqzZjehwtGRnyZfcAza9Q3F8qHCfaAl1eJ0Eg9HfvQ7qkicbWq
         LzFWwF/upv+FPkTHrEyZV8yTr5wjff8Lre8djkRrh5XLSGSNvE6RwMB9BEYMCRQyiZ
         j6qziu/4tPKpA==
Date:   Tue, 2 Nov 2021 17:38:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: ti: am65-cpsw: enable
 bc/mc storm prevention support
Message-ID: <20211102173840.01f464ec@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211101170122.19160-3-grygorii.strashko@ti.com>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
        <20211101170122.19160-3-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Nov 2021 19:01:21 +0200 Grygorii Strashko wrote:
>  - 01:00:00:00:00:00 fixed value has to be used for MC packets rate
>    limiting (exact match)

This looks like a stretch, why not use a mask? You can require users to
always install both BC and MC rules if you want to make sure the masked
rule does not match BC.
