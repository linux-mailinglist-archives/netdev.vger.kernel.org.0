Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AB64354F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiLEUKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiLEUKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:10:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B56A22B35;
        Mon,  5 Dec 2022 12:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=839OKKzCVDPKtFVu49J+atfC/zfYRjB2Yd5vFb9Y3D8=; b=LO8JFiyR7NPl2iwUzEq5UEb45H
        lzpLg7EFa4f10bylCULWTPnbZlHl6hglNH18+2FNdiZA/RnwkW/CPgQeSQs640wxdVodnW7753X3j
        UeZwTokAnMM9XCq0x2FicSWOuHgVugwAi5seSEYEabtO0SK/Kt086H+jziOuTF9dFc/w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2Hlm-004Rbe-4p; Mon, 05 Dec 2022 21:08:54 +0100
Date:   Mon, 5 Dec 2022 21:08:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: phy: mxl-gpy: add MDINT workaround
Message-ID: <Y45P1l/t1vorsGca@lunn.ch>
References: <20221205200453.3447866-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205200453.3447866-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:04:53PM +0100, Michael Walle wrote:
> At least the GPY215B and GPY215C has a bug where it is still driving the
> interrupt line (MDINT) even after the interrupt status register is read
> and its bits are cleared. This will cause an interrupt storm.
> 
> Although the MDINT is multiplexed with a GPIO pin and theoretically we
> could switch the pinmux to GPIO input mode, this isn't possible because
> the access to this register will stall exactly as long as the interrupt
> line is asserted. We exploit this very fact and just read a random
> internal register in our interrupt handler. This way, it will be delayed
> until the external interrupt line is released and an interrupt storm is
> avoided.
> 
> The internal register access via the mailbox was deduced by looking at
> the downstream PHY API because the datasheet doesn't mention any of
> this.
> 
> Fixes: 7d901a1e878a ("net: phy: add Maxlinear GPY115/21x/24x driver")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
