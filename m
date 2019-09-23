Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B0BBC21
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 21:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733273AbfIWTRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 15:17:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33092 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727284AbfIWTRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 15:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UO1YUp317W/qiDTpgnuwDwCMJs/wvk2OlOqj3P/4wRs=; b=Sa4Ts1u2h3nbuc+dmEnakoZS8X
        KGPjVX2HzGp7U+w1/FTrIYttaqmOrA7B1AC1Ia8TxpWXC4alBswY9mCfe92KXlOlFKyItkH+xKf8g
        qcbQL8sG6SDe/MTI7krmxsmFIgbjFuWSZGMAFfWJDgpf/e6x+qC32s3jDDZCPWxEhThI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCTph-0000Rw-24; Mon, 23 Sep 2019 21:17:13 +0200
Date:   Mon, 23 Sep 2019 21:17:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
Message-ID: <20190923191713.GB28770@lunn.ch>
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We have the configuration problem with the Marvell 88E6190 switch.
> What the our problem is... Is the switch is NOT configured with the
> EEPROM (24C512), which does not exist on the board.

That is pretty normal. If there is a EEPROM, i generally recommend it
is left empty. We want Linux to configure the switch, and if it finds
it already partially configured, things can get confused.

> It is put in autoconfig by HW straps (NOCPU mode).

So dumb switch mode. All ports are switched between each other.

> Once the MDIO command, issued to
> probe the switch and read the make of it, the switch jumps out of the
> autoconfig mode.

Correct. Dumb switch mode is dangerous. There is no STP, etc.
Depending on what you have in device tree, the ports are either
configured down, or separated.

> There are some commands issued from the DSA to
> configure the switch (to apply to switch TXC and RXC RGMII delays -
> RGMII-ID mode), but this is not enough to make it work properly.

Define 'work properly'. How are you configuring the interfaces?  Do
you remember to bring the master interface up? Are you adding the
interfaces to a bridge?

   Andrew
