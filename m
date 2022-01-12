Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9E48CAB9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbiALSNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:13:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356090AbiALSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:12:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9793CB8202D;
        Wed, 12 Jan 2022 18:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025DAC36AEB;
        Wed, 12 Jan 2022 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642011146;
        bh=a183lKx4PC5zf+c/gc5RhkgtDZtPasXoWHQOEfZbw14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oM2tz27gB4m7a3AEhHGjxpeZn4mydUPRQZD8awQdebN5CuanbZEuf+GYDJqyF+Rn+
         EIk6gyc+OElrvCNJivcwM6keSmw1YzhYT0op14+pFQHDDE7ZESuElbudzCh+wuRFlt
         1Wto5CMe0qZtJN+crNf9iXEA40QN2vQYZsOjSO0N7cbOO44/pAFy7bEbUJO1cQLFK1
         o2OlXx+UgoYKPr3xLvfKWduQuCekwMD3ZMFhww094dcOpjyCReuO7mXO7j+ZpxlDdr
         yNQUXuJnOVXjEHI6RHsm0zsnvLLlOtYBSkKTGod7kl+Vs6d5aFH/J7UtAstSiH2NYV
         EP/uWXavOQtKQ==
Date:   Wed, 12 Jan 2022 10:12:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1 net-next 0/2] use bulk reads for ocelot statistics
Message-ID: <20220112101224.0b7c9331@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110010618.428927-1-colin.foster@in-advantage.com>
References: <20220110010618.428927-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 17:06:16 -0800 Colin Foster wrote:
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

Looks like this missed our 5.17 PR, please repost in two weeks once the
merge window is open. You can check if net-next is open here:

http://vger.kernel.org/~davem/net-next.html
