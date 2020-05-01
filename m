Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929EA1C2097
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgEAW3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAW3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:29:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1B2C061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:29:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B46C14F4DE27;
        Fri,  1 May 2020 15:29:54 -0700 (PDT)
Date:   Fri, 01 May 2020 15:29:54 -0700 (PDT)
Message-Id: <20200501.152954.1266270078854134704.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, cphealy@gmail.com
Subject: Re: [PATCH net-next v2] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429205323.76908-1-andrew@lunn.ch>
References: <20200429205323.76908-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:29:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 29 Apr 2020 22:53:23 +0200

> The change to polled IO for MDIO completion assumes that MII events
> are only generated for MDIO transactions. However on some SoCs writing
> to the MII_SPEED register can also trigger an MII event. As a result,
> the next MDIO read has a pending MII event, and immediately reads the
> data registers before it contains useful data. When the read does
> complete, another MII event is posted, which results in the next read
> also going wrong, and the cycle continues.
> 
> By writing 0 to the MII_DATA register before writing to the speed
> register, this MII event for the MII_SPEED is suppressed, and polled
> IO works as expected.
> 
> v2 - Only infec_enet_mii_init()
> 
> Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> Reported-by: Andy Duan <fugang.duan@nxp.com>
> Suggested-by: Andy Duan <fugang.duan@nxp.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Hmmm, I reverted the Fixes: tag patch so you'll need to respin this I think.

Thanks.
