Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD63C2201
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhGIKCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhGIKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:02:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F882C0613DD;
        Fri,  9 Jul 2021 02:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GDAKEVAY6G2FkEMJUuqWlfJMGpOgImfNbDfdp8SNumE=; b=IMZi9QswDZgjH87rP0vZpPXoF
        hkkdXd5InlsEhhdJjWVgtPUSzH8uLG1mhs1nLgoJJGh1TJ/umARn53rRP2XFvZfTfrqhig93+SrEk
        pwSdP0aiFbhBENQhAM0rgOslCQM6GiVkJkdzxlHoZ6jeDm+YEKs6hQ2Ef45vT8MpHaoShG9hM6lEL
        2J4tVIIQoTMfyMszH1ymZ/IiUmcXyU8uMLVL3pza6vWQACxls3lgWLTjRQ5XiC6JP8UKk+/fQqkcJ
        mhiCWgutwI1MQY2qUSq115qrial/eLIyOqV2+P74Tsp8YNW7Dhz6reW2bby88gZoY5TMXrPrUv4ff
        gv1ZmfeKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45906)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m1nHr-0001gg-Hc; Fri, 09 Jul 2021 10:59:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m1nHi-0004ra-CP; Fri, 09 Jul 2021 10:59:02 +0100
Date:   Fri, 9 Jul 2021 10:59:02 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH 1/6] arm: crypto: rename 'mod_init' & 'mod_exit'
 functions to be module-specific
Message-ID: <20210709095902.GY22278@shell.armlinux.org.uk>
References: <20210709021747.32737-1-rdunlap@infradead.org>
 <20210709021747.32737-2-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709021747.32737-2-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 07:17:42PM -0700, Randy Dunlap wrote:
> Rename module_init & module_exit functions that are named
> "mod_init" and "mod_exit" so that they are unique in both the
> System.map file and in initcall_debug output instead of showing
> up as almost anonymous "mod_init".
> 
> This is helpful for debugging and in determining how long certain
> module_init calls take to execute.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
