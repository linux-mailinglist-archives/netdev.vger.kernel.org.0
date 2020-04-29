Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795321BE3ED
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD2Qcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:32:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgD2Qcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 12:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mr4SmgFjGqrLl+AU3YAL2UQlmBX0OT8Fgl+zV5qraGs=; b=bSH6e4cbCZZ4AVGAGLiywNdVkr
        DFJg2R80Q3MwKOS6f3AsaNzEK01rXGHjwVoyCxbHTgxdKdr6cEao5TVwPNQSXKJxHKHfz72bpDPDh
        bZRYoSjrU96ReyW15QvJZUMv8B3Wxbre/sH5rYFnAo+0MQssi9vY+wq+UE79p2kWTYPI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTpdf-000IMX-Bp; Wed, 29 Apr 2020 18:32:47 +0200
Date:   Wed, 29 Apr 2020 18:32:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Message-ID: <20200429163247.GC66424@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429160213.21777-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 06:02:13PM +0200, Michael Walle wrote:
> Hi Andrew,
> 
> > Add infrastructure in ethtool and phylib support for triggering a
> > cable test and reporting the results. The Marvell 1G PHY driver is
> > then extended to make use of this infrastructure.
> 
> I'm currently trying this with the AR8031 PHY. With this PHY, you
> have to select the pair which you want to start the test on. So
> you'd have to start the test four times in a row for a normal
> gigabit cable. Right now, I don't see a way how to do that
> efficiently if there is no interrupt. One could start another test
> in the get_status() polling if the former was completed
> successfully. But then you'd have to wait at least four polling
> intervals to get the final result (given a cable with four pairs).
> 
> Any other ideas?

Hi Michael

Nice to see some more PHYs getting support for this.

It is important that the start function returns quickly. However, the
get status function can block. So you could do all the work in the
first call to get status, polling for completion at a faster rate,
etc.

	Andrew
