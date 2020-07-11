Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F263A21C669
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgGKV0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGKV0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:26:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF1C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HPQn0ck4gm6w0VBTI9pE3A0mzQw+Bw/ePvhwU2qYhwk=; b=lNXdddwMgxoNEGE9jbtjw4t62
        pWgHma2tqlVaoqmU9UeQ4PrGg/LYWztuoGy6/aGYZ0ioCm8PGPD4zIrIj3Qi+kltcubrZDbloygwI
        OkWHMt2fxIvKpQwnGB4eGKJeWkqjayT7K+dkthnpHsufLh4yKnR91tCyJuQtn2W38Ppv5CCkpM2zA
        EvBGDNOMXitCigGKl9/kI1dpVp/82Ir/4Hw7AYe0MrBs9xNIAmbYMbjd3MToBQz8olfsLzozvrLBn
        pGeLBICgZSbxCClxqWSsS0v/Dzy21bg4fdVKC3Gx/KKNAvbJmF4Mej5haoz9iZN2WFo6MB+DVLoBJ
        7DaTKLZBw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38288)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1juN0o-0002kL-TS; Sat, 11 Jul 2020 22:26:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1juN0k-0004b9-9o; Sat, 11 Jul 2020 22:26:18 +0100
Date:   Sat, 11 Jul 2020 22:26:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH net-next 0/2] Fix MTU warnings for fec/mv886xxx combo
Message-ID: <20200711212618.GP1551@shell.armlinux.org.uk>
References: <20200711203206.1110108-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711203206.1110108-1-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 10:32:04PM +0200, Andrew Lunn wrote:
> Since changing the MTU of dsa slave interfaces was implemented, the
> fec/mv88e6xxx combo has been giving warnings:
> 
> [    2.275925] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 9
> [    2.284306] eth1: mtu greater than device maximum
> [    2.287759] fec 400d1000.ethernet eth1: error -22 setting MTU to include DSA overhead
> 
> This patchset adds support for changing the MTU on mv88e6xxx switches,
> which do support jumbo frames. And it modifies the FEC driver to
> support its true MTU range, which is larger than the default Ethernet
> MTU.

It's not just the fec/mv88e6xxx combo - I've been getting them on
Clearfog too.  It just hasn't been important enough to report yet.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
