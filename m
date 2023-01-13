Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE256698EB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbjAMNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241792AbjAMNmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:42:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63117A23C;
        Fri, 13 Jan 2023 05:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6tMz3uj91sZWGT4+8mYXTqsk5KW2CRLjomXJqZADZa0=; b=Bz6kN7EjszZZCYeO0ZCPouGgE0
        3rT2En9B2v6DZL8BTPZx/dwSTLZCK2LQUApPo/v7i6Fcc+YnJVZaV6zt+SmQAy35VJsGvfz4r0LmQ
        fdMEkKA9KG1F7kaHeSHj8esnEuHkNy1fJy8IMR4q9v9EdKPHAo9RRuEQx+10MwBU4pGFK6OMLWQEq
        ymngc/Cb899QZEz3JZz6xwOU67eqcSN/5XpU87D7BnnzqH6q6VUpVsiyxtN/dmvfkE8Jd6J3sWi/M
        UnzSM83R1o7JcxcMLxi50uAaV3GhW9d3kxcOS/Zo2t+8ITJOhF9DVyU6vIqFd4wYKmozyCE2nVKoa
        B+OdVHzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36090)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pGKED-0007tu-0L; Fri, 13 Jan 2023 13:36:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pGKEC-0003By-0R; Fri, 13 Jan 2023 13:36:16 +0000
Date:   Fri, 13 Jan 2023 13:36:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: 6.1: possible bug with netfilter conntrack?
Message-ID: <Y8FeT7pAUDeILb/X@shell.armlinux.org.uk>
References: <Y8CR3CvOIAa6QIZ4@shell.armlinux.org.uk>
 <Y8CaaCoOAx6XzWq/@shell.armlinux.org.uk>
 <20230112234503.GB19463@breakpoint.cc>
 <Y8E8uX9gLBBywmf5@shell.armlinux.org.uk>
 <20230113125629.GD19463@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113125629.GD19463@breakpoint.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 01:56:29PM +0100, Florian Westphal wrote:
> Right, this is silly.  I'll see about this; the rst packet
> bypasses conntrack because nf_send_reset attaches the exising
> entry of the packet its replying to -- tcp conntrack gets skipped for
> the generated RST.
> 
> But this is also the case in 5.16, so no idea why this is surfacing now.

Maybe it's just down to a change in the traffic characteristics that
now makes it a problem, and it appearing after upgrading to 6.1 is
just coincidence?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
