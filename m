Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34D66CE45
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjAPSEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbjAPSDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:03:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44E6A47;
        Mon, 16 Jan 2023 09:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qX2AsBL9WdyHBhYS9bfpTO+uUv44jFAX6gLKM1l0rZY=; b=R9XlZoA2no99LaQp3O2yjWNXVz
        snKXO4dg3kQSPDrUuD7Zhl5YeeS2z/sAOkqJJHAW7OmU+BWT47K2HWN0SqkcrtoaXUrqp96mJnejA
        PZTnIkhQ6WsMjdf+jHL7VgSqnYhAi6tNu/m/C3k9uXx+HzZZjpKKcx3i5J1vJqsN1v2y8IkJo0hj7
        O6mRmptnCwgmFnZE0eihKqV+BwXA0iDIoD9ReXNYhXBYGzwFvK1eK1CUa9kMHr+b1rletC9Y7iE9h
        6hLpcOhPeGjySJtxOprDR5xCQe4W/spr8aiUMdoaQxogfpW8qAlwayMwvOqDjOdFlU5kficNNBFkZ
        dCXl0Dmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36138)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHTcf-0005Z7-9K; Mon, 16 Jan 2023 17:50:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHTcb-0006Cd-I0; Mon, 16 Jan 2023 17:50:13 +0000
Date:   Mon, 16 Jan 2023 17:50:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116173420.1278704-3-mw@semihalf.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> fixed-link PHYs API is used by DSA and a number of drivers
> and was depending on of_. Switch to fwnode_ so to make it
> hardware description agnostic and allow to be used in ACPI
> world as well.

Would it be better to let the fixed-link PHY die, and have everyone use
the more flexible fixed link implementation in phylink?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
