Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AAD446863
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 19:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhKESfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 14:35:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKESfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 14:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+mQ4A9hRs1wqSR3JCmxXb/shrbbfV7c7LjQwewfHmU0=; b=faxhXY2IGXiEwVJhqdWcsijlKH
        L1aClFxzf7Lvb08RC9D6BYPxF7Cc2vsiJxmt1ueT+vkqFVuYipnw5V5/LuyFQE3E1LILVBxlqnxPL
        HSFr2e+SkeHXsyi7pExVGwyjztY6LjnWyBX+V7AB1Y2OFtg49tQqTSchWc4qVeS7BN1s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mj41D-00Chl3-QK; Fri, 05 Nov 2021 19:32:51 +0100
Date:   Fri, 5 Nov 2021 19:32:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     bage@linutronix.de
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
Message-ID: <YYV40/2N+2j02V/f@lunn.ch>
References: <20211105153648.8337-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105153648.8337-1-bage@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 04:36:48PM +0100, bage@linutronix.de wrote:
> From: Bastian Germann <bage@linutronix.de>
> 
> Take the return of phy_start_aneg into account so that ethtool will handle
> negotiation errors and not silently accept invalid input.

Hi Bastian

What PHY driver are you using this with? phy_start_aneg() generally
does not return errors, except for -EIO/-TIMEDOUT because
communication with the PHY has failed. All parameter validation should
of already happened before the call to phy_start_aneg(). So i'm
wondering if the PHY driver is doing something wrong.

The change itself however does seems sensible. If the PHY has
disappeared, returning -EIO would be valid.

    Andrew
