Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8A04AF35B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiBINy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiBINy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:54:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8770DC050CC8;
        Wed,  9 Feb 2022 05:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Dx/PKWpzQCecS5LJJThre2isPFS/IqAyk2Jvk4HRdb0=; b=Vgmk0z0l+9jPpsmVtPt3YDGe09
        g870jZd2okb+F2agLNYbzeYNb+Ogu/LxP0STrp3BYie9juwJlk9zrTCTZ1U9cmf5R4frDqu8tcLb0
        bWMz5gMmpe8zxJEkgcHYNJYI0GPXCSNu+PttpvvBngJzV9EVgx+zWJEIUFvmMV6Dvmzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHnQN-00582r-Ve; Wed, 09 Feb 2022 14:54:23 +0100
Date:   Wed, 9 Feb 2022 14:54:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix when CONFIG_IPV6 is not set
Message-ID: <YgPHjxpo0N4ND1ch@lunn.ch>
References: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 11:18:23AM +0100, Horatiu Vultur wrote:
> When CONFIG_IPV6 is not set, then the compilation of the lan966x driver
> fails with the following error:
> 
> drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
> reference to `ipv6_mc_check_mld'
> 
> The fix consists in adding #ifdef around this code.

It might be better to add a stub function for when IPv6 is
disabled. We try to avoid #if in C code.

	  Andrew
