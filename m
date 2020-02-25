Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6300116C27A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgBYNhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:37:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33366 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgBYNhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 08:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FbCMjDal70kbhx4LrrpUETU6UYSnew6BU+EfiJ/QW/c=; b=BVvsfhX6gl7hjMo5DrjrSEdFQ7
        ouw9JKvdWeCS8iXukYGYhcgua3k5L/pnUe5fpf7morS9bN09KLPZfc2SYeFsr8WqNSanRmPPL6yBv
        fi8KfdX5KzHtmrJT7am8U0v1Co0JmCk378WSV85RRaAJh3iCpHXywrZFpVWeUm7R0wUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6aOu-0007L0-S5; Tue, 25 Feb 2020 14:37:28 +0100
Date:   Tue, 25 Feb 2020 14:37:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for
 Felix DSA
Message-ID: <20200225133728.GE9749@lunn.ch>
References: <20200224213458.32451-1-olteanv@gmail.com>
 <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
 <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Secondly, even traffic that the CPU _intends_ to terminate remains
> "unknown" from the switch's perspective, due to the
> no-learning-from-injected-traffic issue. So that traffic is still
> going to be flooded, potentially to unwanted ports as well.

Hi Vladimir

Can you add an entry to its table to solve this? Make it known
traffic. Hook into dsa_slave_set_rx_mode() and
dsa_slave_set_mac_address()?

	Andrew
