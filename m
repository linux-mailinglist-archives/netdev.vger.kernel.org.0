Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1645A4E2
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhKWOOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:14:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238115AbhKWOOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 09:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X+TNGPal7EhXm+7VL/wGaFQfopH0R9aztYXI3u/fUmk=; b=C+0EpyEzUYQYcnoKgIYYy2OxjG
        1Jx9y8O8+UtULCl12YEgTABjCBENw6DW6sGKBjDOxkxUUqaA+4Hl5Ha+h2i/QHZjzuWMWNm5yIS6j
        H54aaeJT8L9UaN+7mkWTxkpKzIuzbVXdGKi2mrzyMter/xkqbragZ3qA3ozbczdDm1o8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mpWW2-00EPye-2g; Tue, 23 Nov 2021 15:11:22 +0100
Date:   Tue, 23 Nov 2021 15:11:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alessandro B Maurici <abmaurici@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] phy: fix possible double lock calling link changed
 handler
Message-ID: <YZz2irnGkrVQPjTb@lunn.ch>
References: <20211122235548.38b3fc7c@work>
 <YZxrhhm0YdfoJcAu@lunn.ch>
 <20211123014946.1ec2d7ee@work>
 <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017ea94f-7caf-3d4e-5900-aa23a212aa26@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Seeing the following code snippet in lan743x_phy_link_status_change()
> I wonder why it doesn't use phydev->speed and phydev->duplex directly.
> The current code seems to include unneeded overhead.

Yes, that is the change i would make. When adding the extra locks i
missed that a driver was doing something like this. I will check all
other callers to see if they are using it in odd contexts.

     Andrew
