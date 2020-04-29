Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE71BD2FB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2Deo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgD2Den (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 23:34:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB556C03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 20:34:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4067312759F5C;
        Tue, 28 Apr 2020 20:34:42 -0700 (PDT)
Date:   Tue, 28 Apr 2020 20:34:39 -0700 (PDT)
Message-Id: <20200428.203439.49635882087657701.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, cphealy@gmail.com,
        leonard.crestez@nxp.com
Subject: Re: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII
 event after MII_SPEED write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <HE1PR0402MB2745408F4000C8B2C119B9EDFFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200428175833.30517-1-andrew@lunn.ch>
        <20200428.143339.1189475969435668035.davem@davemloft.net>
        <HE1PR0402MB2745408F4000C8B2C119B9EDFFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 20:34:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Wed, 29 Apr 2020 01:55:35 +0000

> From: David Miller <davem@davemloft.net> Sent: Wednesday, April 29, 2020 5:34 AM
>> From: Andrew Lunn <andrew@lunn.ch>
>> Date: Tue, 28 Apr 2020 19:58:33 +0200
>> 
>> > The change to polled IO for MDIO completion assumes that MII events
>> > are only generated for MDIO transactions. However on some SoCs writing
>> > to the MII_SPEED register can also trigger an MII event. As a result,
>> > the next MDIO read has a pending MII event, and immediately reads the
>> > data registers before it contains useful data. When the read does
>> > complete, another MII event is posted, which results in the next read
>> > also going wrong, and the cycle continues.
>> >
>> > By writing 0 to the MII_DATA register before writing to the speed
>> > register, this MII event for the MII_SPEED is suppressed, and polled
>> > IO works as expected.
>> >
>> > Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven
>> > MDIO with polled IO")
>> > Reported-by: Andy Duan <fugang.duan@nxp.com>
>> > Suggested-by: Andy Duan <fugang.duan@nxp.com>
>> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>> 
>> Applied to net-next, thanks.
> 
> David, it is too early to apply the patch, it will introduce another
> break issue as I explain in previous mail for the patch.

So what should I do, revert?
