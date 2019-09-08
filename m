Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3746ACBBA
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 11:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfIHJFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 05:05:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbfIHJFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 05:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O0WFvOQaN+ekjjbfWKwM4BzrJm9+Kh8SvRW+1FwQixo=; b=A2nxOWrxLCAIY/PJpBmgX12D1g
        KroVZBJvOsRIMGaYto4hpiagDfjaZyKCDvbQoF6GJ+bDMSJ0JNxFDIglDXeFIRQXmf72DN/zbuye4
        ZhfC8Z0zBm9eb4ZvEhSGMLO1Vxm1Pl/VxQBtDOx2TD6B5XPdYwAc6i22KlbRoaGyvbmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6t8p-0007cj-PV; Sun, 08 Sep 2019 11:05:51 +0200
Date:   Sun, 8 Sep 2019 11:05:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ranran <ranshalit@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Q: fixed link
Message-ID: <20190908090551.GC28580@lunn.ch>
References: <CAJ2oMhKUTUU0eHTmS62itBw6L9Jut=ps6y8GuVDP44xadn03dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ2oMhKUTUU0eHTmS62itBw6L9Jut=ps6y8GuVDP44xadn03dw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 08, 2019 at 10:30:51AM +0300, Ranran wrote:
> Hello,
> 
> In documentation of fixed-link it is said:"
> Some Ethernet MACs have a "fixed link", and are not connected to a
> normal MDIO-managed PHY device. For those situations, a Device Tree
> binding allows to describe a "fixed link".
> "
> Does it mean, that on using unmanaged switch ("no cpu" mode), it is
> better be used with fixed-link ?

Hi Ranran

Is there a MAC to MAC connection, or PHY to PHY connection?

If the interface MAC is directly connected to the switch MAC, fixed
link is what you should use. The fixed link will then tell the
interface MAC what speed it should use.

If you have back to back PHYs, you need a PHY driver for the PHY
connected to the interface MAC, to configure its speed, duplex
etc. The dumb switch should be controlling its PHY, and auto-neg will
probably work.

	 Andrew
