Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8C459B0C
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 05:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhKWEVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 23:21:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhKWEVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 23:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OdGYiSkg88hXBdF/GLgKE1MOsv9Rl7Eokof/wMweiHQ=; b=wi8oO2Yk49dkwPTrWo6lGcu9EQ
        /s41ylWGjEX5eiH96OdZHbY4ruDF+/hQMJt5+/TjW2t+Pf28ALaN4w8DMp1iQiiJ8vWjMmP9ts/zI
        mxUZUF7GMNUI9qFM3reh+6hyaGgK5GWizTZLd+JHqXqZz0HYChXitFxPTCGlfT4upTzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpNG2-00EMas-4P; Tue, 23 Nov 2021 05:18:14 +0100
Date:   Tue, 23 Nov 2021 05:18:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alessandro B Maurici <abmaurici@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <YZxrhhm0YdfoJcAu@lunn.ch>
References: <20211122235548.38b3fc7c@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122235548.38b3fc7c@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 11:55:48PM -0300, Alessandro B Maurici wrote:
> From: Alessandro B Maurici <abmaurici@gmail.com>
> 
> Releases the phy lock before calling phy_link_change to avoid any worker
> thread lockup. Some network drivers(eg Microchip's LAN743x), make a call to
> phy_ethtool_get_link_ksettings inside the link change handler

I think we need to take a step back here and answer the question, why
does it call phy_ethtool_get_link_ksettings in the link change
handler. I'm not aware of any other MAC driver which does this.

	 Andrew
