Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D132459C6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgHPWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:06:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgHPWGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 18:06:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7QnQ-009d8a-4R; Mon, 17 Aug 2020 00:06:32 +0200
Date:   Mon, 17 Aug 2020 00:06:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 2/7] net: dsa: Add devlink regions support to DSA
Message-ID: <20200816220632.GA2294711@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-3-andrew@lunn.ch>
 <20200816215009.m7ovmuwjme3lrl4g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816215009.m7ovmuwjme3lrl4g@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could we perhaps open-code these from the drivers themselves? There's
> hardly any added value in DSA providing a "helper" for creation of
> devlink resources (regions, shared buffers, etc).
 
It is something i considered. But we already have devlink wrappers. It
would be odd to have some parts of devlink wrapped and other parts
not.

The wrapping of phys is also causing Russell King problems. Both
phylink and devlink structures are mostly hidden away in the DSA core,
but do leak a bit into the drivers.

If we do change to open coding, would we remove the existing wrappers
as well?

> Take the ocelot/felix driver for example.

ocelot/felix is just plain odd. We have to do a balancing act for
it. We don't want to take stuff out of the core just for this one odd
switch, at the detriment for other normal DSA drivers.

	Andrew
