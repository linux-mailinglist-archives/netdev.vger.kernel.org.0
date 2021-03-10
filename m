Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955EB334752
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhCJTBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhCJTAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:00:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED6EC061760;
        Wed, 10 Mar 2021 11:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eLUYXPQCapgp9lS9oibAyMyspjp7ZMO8iy8MRE7Vh+s=; b=zuUe0qkZ2JB0FiuYCbP1ZJNpX
        FPyW9bwvqTu7digUkN6R1+cp66ssZGrUyY/pukGDTY/hCx8JhLEcq8nE80En2LDCejNK12VBPHFbH
        sQOgIzJO8MsPaNJbHyqEAORb8mqdbyzboiMXtDKq+x2ClJMFKiLAApOuIbtpDpV0nH0c3BHbr0KQO
        P495RaFP3vOHZowUQhFBe4kjA617gE2JzsxDZR3/qmjGH3gSGsUMrwHimQCWzp8JiXP8EZGkc+hxw
        gCfXjhi/Dvwk6ps6f7LVE/DlkCQ8KAwTlJ71khbF2B2Cn0hNncQZGtKbsNsXrj0bOZRrF6c7CavPZ
        ZvmuqEzyQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50730)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lK44C-0004oe-Kp; Wed, 10 Mar 2021 19:00:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lK44A-0000vX-FM; Wed, 10 Mar 2021 19:00:18 +0000
Date:   Wed, 10 Mar 2021 19:00:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org, rabeeh@solid-run.com
Subject: Re: [net-next] net: mvpp2: Add reserved port private flag
 configuration
Message-ID: <20210310190018.GH1463@shell.armlinux.org.uk>
References: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615369329-9389-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:42:09AM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> According to Armada SoC architecture and design, all the PPv2 ports
> which are populated on the same communication processor silicon die
> (CP11x) share the same Classifier and Parser engines.
> 
> Armada is an embedded platform and therefore there is a need to reserve
> some of the PPv2 ports for different use cases.
> 
> For example, a port can be reserved for a CM3 CPU running FreeRTOS for
> management purposes or by user-space data plane application.
> 
> During port reservation all common configurations are preserved and
> only RXQ, TXQ, and interrupt vectors are disabled.

If a port is reserved for use by the CM3, what are the implications
for Linux running on the AP? Should Linux have knowledge of the port?
What configurations of the port should be permitted?

I think describing how a port reserved for use by the CM3 CPU should
appear to Linux is particularly important for the commit commentry
to cover.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
