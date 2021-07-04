Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E453BAEA4
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhGDUAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 16:00:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39568 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhGDUAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 16:00:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kkGwSeTdihBY36VFXp/FW0w8u9NpfYN2EtWNHDIxCb4=; b=hj9idZMGWGuJ3OuEEx3R84ooYL
        ZNgwUH5aH6cg/IZPHrfGZ84NRfkBRkqjskcuyHD7W9Ks9Ey/xMXLo9bVDP0YrbI/1+yhxbYgv5jjC
        kstaa/KJ5OWOr3D5fCElI2wl0vBhrVMHP7A0gBI0Isafnc3PMqBnRJpVn3xURURd0SdI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m08FU-00C9ez-Qc; Sun, 04 Jul 2021 21:57:52 +0200
Date:   Sun, 4 Jul 2021 21:57:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, lipeng321@huawei.com
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
Message-ID: <YOISwD+8ZoMpjP2m@lunn.ch>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
 <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
 <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08395721-4ca1-9913-19fd-4d8ec7e41e4b@huawei.com>
 <20210701085447.2270b1df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a5d42bf6-d71f-978e-b9ae-6b04f072d988@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d42bf6-d71f-978e-b9ae-6b04f072d988@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Hi Jakub, I have a question to consult you.
> > > Some fault information in our patch are not existed in current ethtool extended
> > > link states, for examples:
> > > "Serdes reference clock lost"
> > > "Serdes analog loss of signal"
> > > "SFP tx is disabled"
> > > "PHY power down"
> > 
> > Why would the PHY be powered down if user requested port to be up?
> > 
> In the case of other user may use MDIO tool to write PHY register directly to make
> PHY power down, if link state can display this information, I think it is helpful.

If the user directly writes to PHY registers, they should expect bad
things to happen. They can do a lot more than power the PHY down. They
could configure it into loopback mode, turn off autoneg and force a
mode which is compatible with the peer, etc.

I don't think you need to tell the user they have pointed a foot gun
at their feet and pulled the trigger.

   Andrew
