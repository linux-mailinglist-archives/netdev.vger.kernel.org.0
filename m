Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD046BF03
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhLGPT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:19:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhLGPT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 10:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qP8+O/gRwcoIWKNvm0K0i0AMA/UfbiCfK7Wrt+s47ko=; b=GC0Tpen6RVJp3cdWwNMGKrCUsZ
        HW0pB8fGH1RY0+5kdBHDrJxkJA8iX7aacTtLij7owxX/0ptDWlz8AcEoXxlo6bI95Qq7XdjjmvEn3
        XMJu7eolUgQDgzigUQuv6ILG7wo5WXPIFrf0y9AdTASg+jB69zDJZbZQQmXJOs+nkp2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mucC7-00FmoY-W7; Tue, 07 Dec 2021 16:15:51 +0100
Date:   Tue, 7 Dec 2021 16:15:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <Ya96pwC1KKZDO9et@lunn.ch>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
> Hi, this is still WIP and currently has some problem but I would love if
> someone can give this a superficial review and answer to some problem
> with this.
> 
> The main reason for this is that we notice some routing problem in the
> switch and it seems assisted learning is needed. Considering mdio is
> quite slow due to the indirect write using this Ethernet alternative way
> seems to be quicker.
> 
> The qca8k switch supports a special way to pass mdio read/write request
> using specially crafted Ethernet packet.

Oh! Cool! Marvell has this as well, and i suspect a few others. It is
something i've wanted to work on for a long long time, but never had
the opportunity.

This also means that, even if you are focusing on qca8k, please try to
think what could be generic, and what should specific to the
qca8k. The idea of sending an Ethernet frame and sometime later
receiving a reply should be generic and usable for other DSA
drivers. The contents of those frames needs to be driver specific.
How we hook this into MDIO might also be generic, maybe.

I will look at your questions later, but soon.

  Andrew
