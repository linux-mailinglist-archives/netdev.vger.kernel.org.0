Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95B50B7CB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347908AbiDVNCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 09:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbiDVNCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 09:02:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D85C57B18;
        Fri, 22 Apr 2022 05:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N8vHuTwPATpwwlOw/DsH67ghNaVvbs3LtAD5h9mrBs0=; b=FkZysAF1vf7oMtSIe49s+Drqah
        QT72I2uYhUKJYYy8t+JhZQCTdP0HBm9GzVPy744j32ZD9nfwavIWrNMP+snINiiYj3zWgD5l+wr+D
        xWK3yh7YIaGzNYThvjigGHyvZUQna0BvABZYyOH2Ucx/iXK3RE7xpoSTiANOebh1sE7U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhss6-00GyU2-09; Fri, 22 Apr 2022 14:58:50 +0200
Date:   Fri, 22 Apr 2022 14:58:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: stmmac: introduce PHY-less setup
 support
Message-ID: <YmKmifSfqRdjOXSd@lunn.ch>
References: <20220422073505.810084-1-boon.leong.ong@intel.com>
 <20220422073505.810084-3-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422073505.810084-3-boon.leong.ong@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:35:03PM +0800, Ong Boon Leong wrote:
> Certain platform uses PHY-less configuration whereby the MAC controller
> is connected to network switch chip directly over SGMII or 1000BASE-X.
> 
> This patch prepares the stmmac driver to support PHY-less configuration
> described above.

The normal way to do a PHY less setup is to use a fixed-PHY. It offers
the same API to the MAC as a real PHY but is fixed speed, dupex
etc. The MAC sees a PHY as usual, and you don't need anything special
in the MAC.

What you need to do is extend your DSD to list the fixed-link. See

https://www.kernel.org/doc/html/latest/firmware-guide/acpi/dsd/phy.html#mac-node-example-with-a-fixed-link-subnode

	Andrew
