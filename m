Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95273437799
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJVM7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:59:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231356AbhJVM7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 08:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ngvl55BVglJNfhG958B3E7zNuug8mH7+G2ICcfvX7Gw=; b=m8n+Xy/27I0SjdMX3bXR9Mq27V
        S83w6VQc3m/3YsSeDBP6IT0kuKQbasOGmV6C1tEtbYc9EbIM1v6SHeh1BjBbtUhaUhE/61zs00sSL
        UbZD0sz5aj1MXSGCNK8N61fSkHDjkmvo6XZPRdKXHZA69FFcrZczl9du8F2FBSI59otc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdu6N-00BNvh-55; Fri, 22 Oct 2021 14:56:51 +0200
Date:   Fri, 22 Oct 2021 14:56:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
 available
Message-ID: <YXK1E9LLDCfajzmR@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
 <YW7SWKiUy8LfvSkl@lunn.ch>
 <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
 <YXBk8gwuCqrxDbVY@lunn.ch>
 <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
 <YXFh/nLTqvCsLAXj@lunn.ch>
 <7a478c1f25d2ea96ff09cee77d648e9c63b97dcf.camel@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a478c1f25d2ea96ff09cee77d648e9c63b97dcf.camel@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm, lots of network drivers? I tried to find an example, but all
> drivers that generate -EPROBE_DEFER for missing PHYs at all don't have
> an internal MDIO bus and thus avoid the circular dependency.

Try drivers/net/dsa.

These often have mdio busses which get registered and then
unregistered. There are also IRQ drivers which do the same.

	Andrew
