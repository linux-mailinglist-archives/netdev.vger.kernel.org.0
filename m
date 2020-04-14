Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F051A7B76
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 14:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502391AbgDNMzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 08:55:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36278 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502380AbgDNMzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 08:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lPJUTtOIuy5BU8KE3cbCX1+ZdoLjw8YCm2osvNCEtqA=; b=OQKalRLbHaPc/mThQHVJCQCVts
        EfVmzRhb1CJnXwB/0mYpg64P5UqAlFbld5Z2fKyY4rqortNFWWbMw19bLFFY2+yNz8dPh7oLttV2v
        2gePZkHhgS/eDO5UQBruCQ4OCwgYZhl+XrvO7MpXbQ0lSUCjlQGDWBi9qclBpT2UiQfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOL6D-002eMr-IC; Tue, 14 Apr 2020 14:55:33 +0200
Date:   Tue, 14 Apr 2020 14:55:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        Chris Heally <cphealy@gmail.com>
Subject: Re: [EXT] [PATCH] net: ethernet: fec: Replace interrupt driven MDIO
 with polled IO
Message-ID: <20200414125533.GD611399@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR0402MB3600B82EE105E43BD20E2190FFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <20200414034920.GA611399@lunn.ch>
 <VI1PR0402MB3600C15E60CB9436DFB59FCFFFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3600C15E60CB9436DFB59FCFFFDA0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If we switch to polling mode, it is better to add usleep or cpu relax between IO
> Polling.

Hi Andy

Yes. I can do that. I've been wanting to try iopoll.h. I will see what
the performance impacts are.

> > I also have follow up patches which allows the bus to be run at higher speeds.
> > The Ethernet switch i have on the bus is happy to run a 5MHz rather than the
> > default 2.5MHz. 
> 
> Please compatible with 2.5Hz for your following patches.

Yes. I'm adding device tree properties. If the property is not
present, it will default to 2.5MHz. Same for preamble suppression, if
the boolean DT property is not present, it will not suppress it, so
keeping backwards compatibility.

	Andrew
