Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4452219839D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgC3SpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:45:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgC3SpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 14:45:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CXPdVTiCp/UQlA1jkwVcGXrb4CsvV02soGOt8kpgYnw=; b=f0UCPHg1Gf1xj0tFDxE3HFlJ2m
        xKOE3rozjJmI7jBEsw6TNxh8RkcB0DwAt9EmfigF8mElTVo0L9qpKlkve/cgNc5FMYy7+JksQyWkY
        JSY0zuL5mk/+1yeJAlR5yER8geO9K9DkRCyNzd51ruwxgnaUShK5jdZS0LUjPQI+d+HI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIzPR-000790-F5; Mon, 30 Mar 2020 20:45:17 +0200
Date:   Mon, 30 Mar 2020 20:45:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200330184517.GH23477@lunn.ch>
References: <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
 <20200327235220.GV3819@lunn.ch>
 <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
 <20200330134010.GA23477@lunn.ch>
 <7a777bc3-9109-153a-a735-e36718c06db5@zonque.org>
 <20200330182307.GG23477@lunn.ch>
 <82d8e785-ec00-d815-3b11-b694aa9f4d50@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82d8e785-ec00-d815-3b11-b694aa9f4d50@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Even when the MAC is *forced* to 1G, which is what the code currently
> does? Sorry for the dumb question, but wich code path would undo these
> settings? Where would you start debugging this?

You could add #define DEBUG to the top of driver/net/phy/phylink.c.
You should then see what phylink is up to, including it trying to
configure the MAC. You can add additional printk to
mv88e6xxx_mac_link_up(), mv88e6xxx_mac_link_down(),
mv88e6xxx_mac_config(), etc.

	  Andrew
