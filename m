Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFAA3774DB
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 03:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhEIB3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 21:29:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59770 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIB3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 21:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1b24zNaVFFBYFVzwJpUgjrHNNdNi+opTsx8fHsrr8zc=; b=5ZarRVBNm1xcD4+YleoljQ5nme
        B63CdlsC0EgYVHvgIlzIKQdxiBA6Al5zesq0vw2jIbyH3g67jnXGVokOvk62UjF+JqwW29/bQ3veV
        lQT6ptC7ThoDZ4vwSC9+WhpoVqX/bhldcirSrJRIwtn+bZBuy9wjiRnUxLW3Fx11GirM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfYEg-003Ka3-EL; Sun, 09 May 2021 03:27:58 +0200
Date:   Sun, 9 May 2021 03:27:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJc6ntahETrHRSIc@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-19-ansuelsmth@gmail.com>
 <YJbUignEbuthTguo@lunn.ch>
 <YJclj7wLsR3CK3KQ@Ansuel-xps.localdomain>
 <YJc1w9Mndqbdb71Z@lunn.ch>
 <YJc4I1EIX0HX6OaI@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJc4I1EIX0HX6OaI@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And that is the intention of the port. I didn't want the binding to be
> set on the switch node but on the rgmii node. Correct me if I'm wrong
> but isn't what this patch already do?
> 
> In of_rgmii_delay I get the ports node of the current switch, iterate
> every port, find the one with the phy-mode set to "rgmii-id"

You know this hardware only has one RGMII port, and you know which one
it is. So search the list of ports to find that one particular port,
and see if 'rgmii' is set as phy-mode and if so, what the delays are.
This is a port property, so you need to look at that specific port,
not any random port that might have rgmii set.

    Andrew
