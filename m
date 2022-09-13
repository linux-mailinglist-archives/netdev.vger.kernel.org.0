Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6FC5B7A6C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiIMTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiIMTCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:02:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA8D40573;
        Tue, 13 Sep 2022 12:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WJdOTfMwQ25C5S+sRAKKqg98Zh0BSkoWiC/SDz7TTXo=; b=hUcBhEt6VrM6L/zEfILLtl3fb6
        aw9dZalSeLsEWHoGsEHzworw4K4N6ZrWLzEiY5yTQH/Lv1K3w2QqnD4kGmvpTi9RhAjvnrJW1lMc/
        3vuN6QA3fv/QZVwRzz8C/eAXC4BGm0Oqirj7VPyPSqz9NgAPLi4LmShA1+U6UC4f7ZgnGKeUcSqbC
        A+jvi8NqOwTQh6hHrdmsdJUpoDfFiuLOiKSxx5pJDDip+TQiaTx3oh7F8QI5Y5MfpMwMN2EoyxXQW
        7HwYYsywWd2MWGUIRnl166IqNpe1EJ+VSQXeeZ+PhdOvh3LrN1aUkE04+qqbh37rluj8HbrOswO/L
        hT4gVDWw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34302)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYB9C-0003Pw-1y; Tue, 13 Sep 2022 20:00:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYB99-0000u9-EC; Tue, 13 Sep 2022 20:00:35 +0100
Date:   Tue, 13 Sep 2022 20:00:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH 1/2] net: sfp: add quirk for FINISAR FTLX8574D3BCL and
 FTLX1471D3BCL SFP modules
Message-ID: <YyDTU4JynJy2+pxf@shell.armlinux.org.uk>
References: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
 <20220913181009.13693-2-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913181009.13693-2-oleksandr.mazur@plvision.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 09:10:08PM +0300, Oleksandr Mazur wrote:
> FINISAR FTLX8574D3BCL and FTLX1471D3BCL modules report 10Gbase-SR mode
> support, but can also operate at 1000base-X.
> 
> Add quirk to also support 1000base-X.
> 
> EEPROM content of FTLX8574D3BCL SFP module is (where XX is serial number):
> 
> 00:  03 04 07 10 00 00 00 00  00 00 00 06 67 00 00 00  |............g...|
> 10:  08 03 00 1e 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
> 20:  2e 20 20 20 00 00 90 65  46 54 4c 58 38 35 37 34  |.   ...eFTLX8574|
> 30:  44 33 42 43 4c 20 20 20  41 20 20 20 03 52 00 4b  |D3BCL   A   .R.K|
> 40:  00 1a 00 00 41 30 XX XX  XX XX XX XX XX XX XX XX  |....A0XXXXXXXXXX|
> 50:  20 20 20 20 31 38 30 38  31 32 20 20 68 f0 05 e7  |    180812  h...|
> 
> EEPROM content of FTLX1471D3BCL SFP module is (where XX is serial number):
> 
> 00:  03 04 07 20 00 00 00 00  00 00 00 06 67 00 0a 64  |... ........g..d|
> 10:  00 00 00 00 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
> 20:  2e 20 20 20 00 00 90 65  46 54 4c 58 31 34 37 31  |.   ...eFTLX1471|
> 30:  44 33 42 43 4c 20 20 20  41 20 20 20 05 1e 00 63  |D3BCL   A   ...c|
> 40:  00 1a 00 00 55 4b XX XX  XX XX XX XX XX XX XX XX  |....UKXXXXXXXXXX|
> 50:  20 20 20 20 31 31 30 34  30 32 20 20 68 f0 03 bb  |    110402  h...|

Please include the ethtool -m output so we can see what this decodes
to. I'd rather not have to keep on writing tools to parse hexdumps
back to binary and then using a custom tool based on ethtool to get
that information.

However, having the binary dump from ethtool -m emailed to me so it
can be added to my database of EEPROM contents for future testing
would be useful.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
