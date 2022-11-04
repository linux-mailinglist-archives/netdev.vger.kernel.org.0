Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34C2619BEC
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiKDPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiKDPln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:41:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E8731F90;
        Fri,  4 Nov 2022 08:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sx/C8//eueYN27FFd7RsFm8ZuFMtDn5+1JYUqs9oj8I=; b=NGa7BhkIxza+B25dGMoEKIPUez
        Vxl7pZKw9IYQ207THU4ryHIdbkrhX+RvBj6P1b4Z1IVijsyf1RZNYpUthSXAWyZUQDZ2oWC5zx3Bq
        e6iJ0YwIR76i/c1Iy7Zu+NXO+Bf6ZLfkFdXkGBLt5sKeYSwQOCkwNXBg/pRkzWmO/xqc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqyoz-001RVF-59; Fri, 04 Nov 2022 16:41:29 +0100
Date:   Fri, 4 Nov 2022 16:41:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     bagasdotme@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next v2] net: ethernet: Simplify bool conversion
Message-ID: <Y2UyqcjbDYx1rqcd@lunn.ch>
References: <20221104030313.81670-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104030313.81670-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 11:03:13AM +0800, Yang Li wrote:
> The result of 'scaled_ppm < 0' is Boolean, and the question mark
> expression is redundant, remove it to clear the below warning:
> 
> ./drivers/net/ethernet/renesas/rcar_gen4_ptp.c:32:40-45: WARNING: conversion to bool not needed here
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2729
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v2:
> --According to Bagas's suggestion, describe what this patch does to fix this warning. 

The Subject line is too generic. It is a good idea to run git log on
the file you are changing and see how it is generally referred to:

b48b89f9c189 net: drop the weight argument from netif_napi_add
0140a7168f8b Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
6a1dbfefdae4 net: sh_eth: Fix PHY state warning splat during system resume
4924c0cdce75 net: ravb: Fix PHY state warning splat during system resume
1089877ada8d ravb: Add RZ/G2L MII interface support
949f252a8594 net: ravb: Add R-Car Gen4 support
e1154be73153 ravb: Add support for RZ/V2M
72069a7b2821 ravb: Use separate clock for gPTP
b0265dcba3d6 ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
cb99badde146 ravb: Separate handling of irq enable/disable regs into feature
91398a960edf ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
9a90986efcff sh_eth: kill useless initializers in sh_eth_{suspend|resume}()
e7d966f9ea52 sh_eth: sh_eth_close() always returns 0
be94a51f3e5e ravb: ravb_close() always returns 0

Without something specific like ravb, you won't get the right people
noticing the patch.

	 Andrew
