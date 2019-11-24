Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D2108563
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKXWsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:48:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfKXWsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 17:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wRUHE6GhEtEFZO0D62uFVoZL+soMx8piOGtC/s36Npo=; b=W4P/kQPPqmJuSMJJFgx70nRhCt
        ZB537MbE1GSmke8nk/+jHNKKMef+XmTiOQ0PAOQJ1MJU3VnvCWspofc3yGWuprVVMxINtLhUOopLR
        jLQX5ypChMY/OJ3dWPPX0yIH390Qilj7G2H7lB9JHr67R5cDAzeYj1scyBkAUfqcw1Xk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZ0g7-0005Ea-T8; Sun, 24 Nov 2019 23:48:27 +0100
Date:   Sun, 24 Nov 2019 23:48:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
Message-ID: <20191124224827.GD6009@lunn.ch>
References: <20191123194844.9508-1-olteanv@gmail.com>
 <20191123194844.9508-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123194844.9508-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The CPU port is called with an MTU equal to the largest configured MTU
> of the slave ports. The assumption is that the user might want to
> sustain a bidirectional conversation with a partner over any switch
> port.

There is an assumption here that the MTU is enforced before the DSA
header is applied on the egress patch. And MRU is also applied once
the header is removed on ingress.  I've no idea if this is true for
all the switches we support in DSA.

We should clearly document that if the switch need the header to be
included, the function to set the MTU needs to add it.

	  Andrew
