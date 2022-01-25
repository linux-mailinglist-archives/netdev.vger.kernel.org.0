Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E010D49BADA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357889AbiAYSBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357892AbiAYR7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF19C061751;
        Tue, 25 Jan 2022 09:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679FF614F1;
        Tue, 25 Jan 2022 17:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634A3C340E0;
        Tue, 25 Jan 2022 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133574;
        bh=k21UjJLZbebZ1k0oSRvA1Q+UR3HKMKDNhfsWhlor4lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OjUVEEPp1xSLAGSKZxsmxPapYBkRTBVU+1ocosZ4VvVMQ7XrHKwkcTdDqkZmyCO7r
         h5wXBoj8iEhWsHZGDt8H5oN7/fTbuiaAltCr8l4qYTfKoYwkMZu/jVqUOsyXcDPnk4
         JUEC0Wrt/GGRizfpoQQBXaa/3kLCYpj5w4xVM/Xg30bphX9vpfnrrfM1O2irroNTvD
         xUuTETbr3OGfYla94YYk397f6jTYjfXS2Kh33g9w0IdwKeCuqDGf8zcj3I/YZgu91k
         Utl4SXvy33Wguo84gW1pWT3eFzhOFJrR3G5X63FVAy2+uuBcDAwJ9nFur56gSUsctv
         gyMAQA3wo0rGg==
Date:   Tue, 25 Jan 2022 09:59:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH][next] net: mana: Use struct_size() helper in
 mana_gd_create_dma_region()
Message-ID: <20220125095933.79ba895c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <BYAPR21MB127022573CE9A4158B2317E9BF5E9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20220124214347.GA24709@embeddedor>
        <BYAPR21MB127022573CE9A4158B2317E9BF5E9@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 21:47:38 +0000 Dexuan Cui wrote:
> > From: Gustavo A. R. Silva <gustavoars@kernel.org>
> > Sent: Monday, January 24, 2022 1:44 PM
> >  ...
> > Make use of the struct_size() helper instead of an open-coded version,
> > in order to avoid any potential type mistakes or integer overflows that,
> > in the worst scenario, could lead to heap overflows.
> > 
> > Also, address the following sparse warnings:
> > drivers/net/ethernet/microsoft/mana/gdma_main.c:677:24: warning: using
> > sizeof on a flexible structure
> >  ...
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>  
> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>

Thanks! Applied to net-next, 10cdc794dae8 ("net: mana: Use
struct_size() helper in mana_gd_create_dma_region()")
