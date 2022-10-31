Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF1613813
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiJaNbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJaNbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:31:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC289A186
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 06:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6kRXwyfTcpt7W7LCYCHGBdc8yOudRqFyzurNf5ZoOjY=; b=j7OYmYB21A7LdGy7KcZqe50GGK
        p3ZVZCRldgYFfjrbcy/tdnUTRH2Kn5rIQOfqFL1mF+f1FYYarzdjWHCDEMplpA8CgVXxpgklzyu2L
        NGAJImaz5PxstSLLZ6zXro7bLw5K+YkSP1No34pf/cCujiT+WWs3wrf2ALv8jj7stsic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opUsQ-0011Qj-O4; Mon, 31 Oct 2022 14:30:54 +0100
Date:   Mon, 31 Oct 2022 14:30:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        afleming@freescale.com, buytenh@wantstofly.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: mdio: fix undefined behavior in bit shift for
 __mdiobus_register
Message-ID: <Y1/ODk5btv1EPTEg@lunn.ch>
References: <20221031132645.168421-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031132645.168421-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 09:26:45PM +0800, Gaosheng Cui wrote:
> Shifting signed 32-bit value by 31 bits is undefined, so changing
> significant bit to unsigned. The UBSAN warning calltrace like below:
> 
> UBSAN: shift-out-of-bounds in drivers/net/phy/mdio_bus.c:586:27
> left shift of 1 by 31 places cannot be represented in type 'int'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x7d/0xa5
>  dump_stack+0x15/0x1b
>  ubsan_epilogue+0xe/0x4e
>  __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
>  __mdiobus_register+0x49d/0x4e0
>  fixed_mdio_bus_init+0xd8/0x12d
>  do_one_initcall+0x76/0x430
>  kernel_init_freeable+0x3b3/0x422
>  kernel_init+0x24/0x1e0
>  ret_from_fork+0x1f/0x30
>  </TASK>
> 
> Fixes: 4fd5f812c23c ("phylib: allow incremental scanning of an mii bus")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
