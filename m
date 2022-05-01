Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E1B516430
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346377AbiEALdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbiEALdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:33:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBF114F
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0XjKY1BWW4pxGeJb8SF+mkYTBKzTSLago00wH5aI1IM=; b=BSv0OP7Q5/bHYcOa3TyOsJO6+f
        Kdcy9RfnTLv+pEcEoV3pyepmuKIHBCLUKQsNP4uKC6qB7dq5Y7htpNzHbOYappFBFUp8dfDpF5NiC
        pmP/XxUCU6dlfdZ4QOSp2qIeg2trO0E6g/8e+QjHa4T5dbuwRMUNk0WDe+1qKX1tAI1uG3yCs8cTu
        OrTLZlMoDsuL2bv45M4idqlXuedV1/0bbXorBvZt0zz/bCedJz2gfedkjCU5U0BqyRzAIcsf9/UxG
        0JHJ6D6dfPkcIhxV/X1hDrCJGQ62ZXt2mZblWILrz6AVmV+DUeDNPVZ3hLgG11ENcHBQCqYo9f74D
        heUR5WLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58474)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nl7mE-0006Cx-Bw; Sun, 01 May 2022 12:30:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nl7mB-0003qe-N7; Sun, 01 May 2022 12:30:07 +0100
Date:   Sun, 1 May 2022 12:30:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Message-ID: <Ym5vP8VXR7WDnlzS@shell.armlinux.org.uk>
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 06:05:36PM +0300, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Without this delay PHY mode switch from XLG to SGMII fails in a weird
> way. Rx side works. However, Tx appears to work as far as the MAC is
> concerned, but packets don't show up on the wire.
> 
> Tested with Marvell 10G 88X3310 PHY.

Which firmware do you have running on the 88x3310 PHY? Early versions
are buggy when switching between modes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
