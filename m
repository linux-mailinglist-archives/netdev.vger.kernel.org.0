Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78F136EEF
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgAJOEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:04:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgAJOEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:04:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nFFRscT+IEUSdIlTKVGLh7JmrVqmM9hERdN1OMh753E=; b=sqPc5dtbH/Pa0ldbgijbqpyiA2
        NFyuGhgwcNaakqdbI7Fre08QK1jIO5X0Eetn3g2gL3g8c+mIthPeKgpbWxx1Hqutbz18+SJyLrYTQ
        0TU7jTBOx6kkKbB0aaPXW5acQkYmvdtR41mJm+BcnhG5LwDyOp2E0+d5HH/gZ4w5M0UQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iputb-0007IB-O4; Fri, 10 Jan 2020 15:04:15 +0100
Date:   Fri, 10 Jan 2020 15:04:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110140415.GE19739@lunn.ch>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115415.75683-8-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:54:08AM +0000, Andre Przywara wrote:
> With SGMII, the MAC and the PHY can negotiate the link speed between
> themselves, without the host needing to mediate between them.
> Linux recognises this, and will call phylink's mac_config with the speed
> member set to SPEED_UNKNOWN (-1).
> Currently the axienet driver will bail out and complain about an
> unsupported link speed.
> 
> Teach axienet's mac_config callback to leave the MAC's speed setting
> alone if the requested speed is SPEED_UNKNOWN.

Hi Andre

Is there an interrupt when SGMII signals a change in link state? If
so, you should call phylink_mac_change().

    Andrew
