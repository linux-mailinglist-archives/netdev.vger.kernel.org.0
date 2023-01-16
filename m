Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAAC66BB9A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjAPKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAPKWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:22:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714441A943;
        Mon, 16 Jan 2023 02:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iKsbPmPOxLmnfubqPTJ5H1djw5UST5WyViZLMbpdVKo=; b=018EaVFyuOwt62sRzgWWnmFf3j
        dQ5EzGmQPrnj2doVCQdCX53P0hgvXrD59HW6dNtzk5TzYoNGH/4kDdlYFNwyEe4lqcGWXzsD+D192
        gkWLEaEQueeuz1pJKnC8zt9ygskjdExEhp0IoQrfY7RDjXZdg0ZeyAx48xhtLKzTSWxRIem9t9rH6
        vxNn1bLX4R5UkZ2JNR9qP+EW6zHZr2oq3n5ztpFN6pLufHwQIeooqVjb/NqOl/spLhwvthK1v7Bdn
        q2l/nWvHM1RZXT9blqw2nl+r0S6fCG0ODLVS8GKd78lPIC+Q7N7RlYRAyPNeszbpOvtgFcwcBqfpV
        BAucfrIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36118)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHMcn-0004Yz-9q; Mon, 16 Jan 2023 10:21:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHMcj-0005va-Fb; Mon, 16 Jan 2023 10:21:53 +0000
Date:   Mon, 16 Jan 2023 10:21:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8UlQaymWcYdqKJ/@shell.armlinux.org.uk>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
 <Y8SWPwM7V8yj9s+v@lunn.ch>
 <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 09:44:01AM +0000, Pierluigi Passaro wrote:
> I can't really understand why the MDIO bus must check the PHY presence.
> Other busses try the communication only while probing the slaves,
> never before.

That is not true.

Any bus that relies on hardware identification to bind drivers reads
the identifying information prior to probing. For example, PCI, USB,
AMBA to name a few. AMBA didn't used to have this problem, but does
now - but at least under AMBA there's a bit more standardisation to
what needs to be done. With ethernet PHYs, what's needed is highly
platform specific.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
