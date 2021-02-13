Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5956131AAEC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 11:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhBMKq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 05:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhBMKq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 05:46:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AB8C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wlRE8YaRf4ua3CWJ9wq67q41rBCV311mha14sQzY3JE=; b=g+vY8aY0kN0RlOQfPL2RDMKG7
        GfOJkgEaTm+znpvf+7Eaz26EJh3Vyyt4LPC/WfHBE7VKGHJei8ICz1HJKWgn8GILtHKkjwrITyJje
        DNw5PZas40UfK9df6vEFBGOKrLr5ZFqzb79RSRbnkuSbQdlt82qspRW/pivCKyE/IDi/85V6eglCs
        ogAD54VoSrqgOAPC+/JFBtKkHD/KbnSBncSeYRsypdAKH0hc5OdbVaz2vRW1GP2yLtGJqfSgLR3Dg
        1ivf1DUjPhUE0kagldIw+JrwedsZUQ5Jf3wz/JfqeIbg3cMxR20nvVvR94JFSrsSmsSP5uqramoE2
        4ROZAns3w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42840)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAsQm-00088B-IH; Sat, 13 Feb 2021 10:45:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAsQj-00082W-ES; Sat, 13 Feb 2021 10:45:37 +0000
Date:   Sat, 13 Feb 2021 10:45:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Message-ID: <20210213104537.GP1463@shell.armlinux.org.uk>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
 <20210213021840.2646187-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213021840.2646187-3-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 08:18:40PM -0600, Robert Hancock wrote:
> +	if (!phydev->sfp_bus &&
> +	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {

First, do we want this to be repeated in every driver?

Second, are you sure this is the correct condition to be using for
this?  phydev->sfp_bus is non-NULL when _this_ PHY has a SFP bus
connected to its fibre side, it will never be set for a PHY on a
SFP. The fact that it is non-NULL or NULL shouldn't have a bearing
on whether we configure the LED register.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
