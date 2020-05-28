Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6D1E6657
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404510AbgE1PkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:40:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404383AbgE1PkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vISeVBA39C4KgDGVhcVMI0rOohaYtufXdJxJGAHnXFY=; b=qCpZsI/QWFRgwySZ7NVTihSBV3
        tZrsaJGHw7N89kdrdI30QyUCjg++XeZFZf5IrTDMT+Yje2gZL+pnf2+L+VGJN9LfSRjTqD5moBBPy
        MWuKpNRTycdf+dc3HmpN4xNijJy2o0a714z8BXmupK235ppNFi52k7Tys75K15ViMiJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeKde-003Y3H-SY; Thu, 28 May 2020 17:40:10 +0200
Date:   Thu, 28 May 2020 17:40:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Amit Cohen <amitc@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
Message-ID: <20200528154010.GD840827@lunn.ch>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <20200527213843.GC818296@lunn.ch>
 <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <87zh9stocb.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh9stocb.fsf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, pardon my ignorance in these matters, can a PHY driver in
> general determine that the issue is with the cable, even without running
> the fairly expensive cable test?

No. To diagnose a problem, you need the link to be idle. If the link
peer is sending frames, they interfere with TDR. So all the cable
testing i've seen first manipulates the auto-negotiation to make the
link peer go quiet. That takes 1 1/2 seconds. There are some
optimizations possible, e.g. if the cable is so broken it never
establishes link, you can skip this. But Ethernet tends to be robust,
it drops back to 100Mbps only using two pairs if one of the four pairs
is broken, for example.

   Andrew
