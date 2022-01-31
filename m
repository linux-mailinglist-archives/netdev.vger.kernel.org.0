Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D724A4FC2
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377696AbiAaT40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:56:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiAaT4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:56:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9B8C61453;
        Mon, 31 Jan 2022 19:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7729C340E8;
        Mon, 31 Jan 2022 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643658983;
        bh=vU4Z/wxnuRJijqxNOIHjuu8s4/C9L0yvdnHKwgU/Lig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RxhqrfzYfJwLsScPRrzN9VIqEgpbePmoKCxsIvS6Gmg4GtYq3chsMT3Jv3LZsnVDZ
         GvOS/fpXYqAF5cG1MLX/qy/Cl5ym4bsep7Btn+JMwUnUFL9VgalicU/KlgKMFRK15d
         hU8tMdAZ79IMXUVNDbT+JgYuQj/zit2yXQmA1hU74e+DBVhfIPoNLXseCiFntecTL7
         HAZ+gEvcAACWRXmEZY3TL8UAFOCC74q6A6fStETnuGP1FvlmHvCX/OZtPiw01cpf2U
         x35AEY5F9Jh2qVhfCsnC2GFDXSZrULfpy3ynjKTqe94H0hxFcWBar88t3UfhGOhClL
         qf3CzaYlBV3LA==
Date:   Mon, 31 Jan 2022 11:56:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v4 net-next 0/2] use bulk reads for ocelot statistics
Message-ID: <20220131115621.50296adf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128200549.1634446-1-colin.foster@in-advantage.com>
References: <20220128200549.1634446-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 12:05:47 -0800 Colin Foster wrote:
> Ocelot loops over memory regions to gather stats on different ports.
> These regions are mostly continuous, and are ordered. This patch set
> uses that information to break the stats reads into regions that can get
> read in bulk.
> 
> The motiviation is for general cleanup, but also for SPI. Performing two
> back-to-back reads on a SPI bus require toggling the CS line, holding,
> re-toggling the CS line, sending 3 address bytes, sending N padding
> bytes, then actually performing the read. Bulk reads could reduce almost
> all of that overhead, but require that the reads are performed via
> regmap_bulk_read.

This got into Changes Requested state in patchwork, I'm not sure why.

I revived it and will apply it by the end of the day PST if nobody
raises comments.
