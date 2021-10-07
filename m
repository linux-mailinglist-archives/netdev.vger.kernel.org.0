Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1F424B12
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhJGA0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:26:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53264 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhJGA0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+KHrHdefD48iwVdmlm+TEmLgV1AdnuE5tAzPDwQHJ5g=; b=hJFtruz+fJVqhxEtG0V+CPDzlJ
        /l2LXWWFoB4WdBoq9BtIb2d5+HZfyLvu2WhAhFNqBM9ywMcV5Aqs4DyaWv0jhZnGCZlRr8rNvs6tj
        jQhnCCm7tMC48/9zmErj0kEM7QDCK4C20qPBSkm+U28eLtpuua19JV0ZdsJ0XIiOrUb4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYHCi-009tFC-1S; Thu, 07 Oct 2021 02:24:08 +0200
Date:   Thu, 7 Oct 2021 02:24:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 09/13] net: dsa: qca8k: check rgmii also on port
 6 if exchanged
Message-ID: <YV4+KDQWNhDmcaHL@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:59AM +0200, Ansuel Smith wrote:
> Port 0 can be exchanged with port6. Handle this special case by also
> checking the port6 if present.

This is messy.

The DSA core has no idea the ports have been swapped, so the interface
names are going to be taken from DT unswaped. Now you appear to be
taking phy-mode from the other port in DT. That is inconsistent. All
the configuration for a port should come from the same place, nothing
gets swapped. Or everything needs to swap, which means you need to
change the DSA core.

    Andrew
