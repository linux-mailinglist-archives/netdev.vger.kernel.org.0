Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608E13BE25
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389571AbfFJVLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:11:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbfFJVLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=haNK3T2ZntFCRUM4zV1ClpWgl70cpyViZTlgMWG58Ik=; b=iPeeqdfVe8RjXjJ/ONYpk8FHS6
        t6xnvjAKjL2id1j8rgCoooi2T1HQNClxc5PbT1SaY/mVRxh3Wbc3HMNHcaqT6+Nb8tLCB5v6j3YlB
        dGqYuT6cbjheL4AeUj90MHpBZu3VUpq5zg4L4KhL3Uc2tqTc9NVdTQNFxpUbwYqP58BI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haRZl-0001xt-T0; Mon, 10 Jun 2019 23:11:33 +0200
Date:   Mon, 10 Jun 2019 23:11:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
Message-ID: <20190610211133.GC2191@lunn.ch>
References: <20190610193150.22231-1-f.fainelli@gmail.com>
 <CA+h21hrcymxF7zk4yHFGhjxbLERTCU6WkfzLGQVoZ5Yxoo4xxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrcymxF7zk4yHFGhjxbLERTCU6WkfzLGQVoZ5Yxoo4xxw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Florian,
> 
> Can you give an example of when this is a valid use case, and why
> fixed-link is not appropriate?

A DSA link is used to connect two switches together. ZII devel b and c
are two boards which does this. Such links have the MACs connected
back to back, no PHYs involved. You can also connect a SoC interface
to the CPU port of a switch without having PHYs involved.

We have defined that CPU and DSA ports are always configured by the
driver to there maximum speed. Because of this, you often don't need a
fixed-link on CPU or DSA ports. So you will see most DT blobs don't
have any sort of PHY for the CPU or DSA ports.

You only need fixed-link when you need to slow a port down, e.g. a SoC
FE port connected to a switch 1G port.

    Andrew
