Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3330A492FE0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349483AbiARVDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349473AbiARVDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:03:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227F8C061574;
        Tue, 18 Jan 2022 13:03:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD05B81800;
        Tue, 18 Jan 2022 21:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98FEC340E0;
        Tue, 18 Jan 2022 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642539795;
        bh=r6fgBCEB6nnPYCMFvKF+tFQj/SsCZQvgYPlXmU1d/gg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RiiIpcFDGq/FLjqrBbQe2iGRoffm05NojqmBa3AhwGImu4hXuQh7TFxfsfipH4X/U
         ygDrESNPuVje9jBxGWmqltDFuhY773ukO+ANxyne60epSIgdn2ruhdxakNtL1r1um1
         LfN9mlLiRyqZfd8hHKdb9Uu5UAOd+Ndvsff+Nk02QDW2tKCmZ9Golqfa9+y7d6ZDuN
         aUMJT81jo7uwVHo/zAYHroSSDvTHR9hru1ARAGzWex0AWX/rF2L3kEsdbNCEGP8WoR
         usD0i3w1jLIcoJDZAnzwbBzBkcj6jmh3uXfIYbVDVaIa1gaXVc6ttCtNerPtBBD7uT
         acKA4tpABwwUw==
Date:   Tue, 18 Jan 2022 13:03:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     netdev@vger.kernel.org, linux-omap@vger.kernel.org, arnd@arndb.de,
        davem@davemloft.net, Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking
 NET_IP_ALIGN into account
Message-ID: <20220118130313.411fb05c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118102204.1258645-1-ardb@kernel.org>
References: <20220118102204.1258645-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 11:22:04 +0100 Ard Biesheuvel wrote:
> Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
> takes NET_IP_ALIGN into account, but fail to use it appropriately when
> storing incoming packets in memory. This results in the IPv4 source and
> destination addresses to appear misaligned in memory, which causes
> aligment faults that need to be fixed up in software.
> 
> So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
> This gets rid of any alignment faults on the RX path on a Beaglebone
> White.
> 
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Fixes: 9ed4050c0d75 ("net: ethernet: ti: cpsw: add XDP support")

right?
