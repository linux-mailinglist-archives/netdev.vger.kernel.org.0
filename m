Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C73816F3D4
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBYXuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:50:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgBYXun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 18:50:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=crD2rzOD48/+GNJtyVFGr73/eJ540szR74AUVuFwdtQ=; b=gEPI1Qt8UVfR1Ty9MHSk/HzY4f
        Z84ANp9jx40kWebm8SQ1qV0WWeQQeWkIU6rzyr2045LJnDelAxePGD+JkGSDWstqMz1D/SXrWHzJJ
        b5D1o58Yc0V3MzsGWwBPBGCWUIGzJMESx6D0Yza1GzQEpAewxPQPd7GIpTSPKi5CRPRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6jyK-00028g-N5; Wed, 26 Feb 2020 00:50:40 +0100
Date:   Wed, 26 Feb 2020 00:50:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH 0/2] AT8031 PHY timestamping support
Message-ID: <20200225235040.GF9749@lunn.ch>
References: <20200225230819.7325-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225230819.7325-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 12:08:17AM +0100, Michael Walle wrote:
> This patchset is the current state of my work for adding PHY timestamping
> support. I just wanted to post this to the mailinglist before I never do
> it. Maybe its a starting point for other people. That being said, I
> wouldn't mind comments ;) The code basically works but there are three
> major caveats:
> 
>  (1) The reading of timestamps via MDIO sometimes return wrong values. What
>      I see is that a part of the timestamp corresponds to the new timestamp
> 	 while another part still contains old values. Thus at the moment, I'm
> 	 reading the registers twice. I don't know if the reading actually
> 	 affects the update of the timestamp or the different timing (my MDIO
> 	 bus is rather slow, so reading the timestamp a second time take some
> 	 amount of time; but I've also tested with some delays and it didn't
> 	 had any effects). There is also no possibility to read the timestamp
> 	 atomically :(

Hi Michael

That sounds fundamentally broken. Which would be odd. Sometimes there
is a way to take a snapshot of the value. Reading the first word could
trigger this snapshot. Or the last word, or some status register. One
would hope the datasheet would talk about this.

      Andrew
