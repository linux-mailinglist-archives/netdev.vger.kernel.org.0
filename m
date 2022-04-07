Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565CF4F7E5D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbiDGLuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 07:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244977AbiDGLuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 07:50:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D12364E0
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 04:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eQB8iFIBxi4/jrqH56OzjZi+EP9sLHl16kNUELT1w98=; b=rB9lb9lk7DcvNAookvl/zI/2tm
        uqCtYOmwYf4VF3zB02wOox3ZJKQsPSWvfwdL6wTH1a9W8JpoCdygI6qFfIH0/dOXautBR+uFNBRU2
        ReZu05R8j/l9EjzT6Cb68WRhYu7lOdxg7MhLJA9XMlyt7aCvI0FeRM+bfb1qcXKVDSRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncQcm-00EdWF-0T; Thu, 07 Apr 2022 13:48:28 +0200
Date:   Thu, 7 Apr 2022 13:48:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3] net: phy: micrel: ksz9031/ksz9131: add cabletest
 support
Message-ID: <Yk7PjFwoq71/Yz/D@lunn.ch>
References: <20220407105534.85833-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407105534.85833-1-marex@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 12:55:34PM +0200, Marek Vasut wrote:
> Add cable test support for Micrel KSZ9x31 PHYs.
> 
> Tested on i.MX8M Mini with KSZ9131RNX in 100/Full mode with pairs shuffled
> before magnetics:
> (note: Cable test started/completed messages are omitted)
> 
>   mx8mm-ksz9131-a-d-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code Short within Pair
>   Pair B, fault length: 0.80m
>   Pair C code Short within Pair
>   Pair C, fault length: 0.80m
>   Pair D code OK
> 
>   mx8mm-ksz9131-a-b-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code OK
>   Pair C code Short within Pair
>   Pair C, fault length: 0.00m
>   Pair D code Short within Pair
>   Pair D, fault length: 0.00m
> 
> Tested on R8A77951 Salvator-XS with KSZ9031RNX and all four pairs connected:
> (note: Cable test started/completed messages are omitted)
> 
>   r8a7795-ksz9031-all-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code OK
>   Pair C code OK
>   Pair D code OK
> 
> The CTRL1000 CTL1000_ENABLE_MASTER and CTL1000_AS_MASTER bits are not
> restored by calling phy_init_hw(), they must be manually cached in
> ksz9x31_cable_test_start() and restored at the end of
> ksz9x31_cable_test_get_status().
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
