Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E02E613680
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJaMg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJaMgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:36:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF82B1B4
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2/zPDwzHAPqBN9BdcnUEzywicnfiVbwLBf3XfZwuQuk=; b=TkaSmSEp3PUTq+UueuWHcA1lTA
        Gt1lyX3V+KKpzI6XJ/8LwWsBg98zBQkxBYHnaXg4Y3kJlQsC0/B/laF4YoCf5ofngGTWLl9kklixX
        fETGM0r+rs/Bn25k3gc3N8OZ74xLpSkfAqH2o8aX/r1sFd8a/tKGZnuoDK5mKIAj2ExY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opU0b-00117S-2Z; Mon, 31 Oct 2022 13:35:17 +0100
Date:   Mon, 31 Oct 2022 13:35:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        afleming@freescale.com, buytenh@wantstofly.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: mdio: fix undefined behavior in bit shift for
 __mdiobus_register
Message-ID: <Y1/BBbXOo2Ii68Z/@lunn.ch>
References: <20221031060116.3967513-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031060116.3967513-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	for (i = 0; i < PHY_MAX_ADDR; i++) {
> -		if ((bus->phy_mask & (1 << i)) == 0) {
> +		if ((bus->phy_mask & (1U << i)) == 0) {

Please use the BIT() macro.

       Andrew
