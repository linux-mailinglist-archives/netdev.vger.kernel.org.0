Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3A4105A9D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKUTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:50:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbfKUTuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=idWpHQ/nnw+4hOuXenxT8j2yx3qPjOnf1q6Eq3KqWUM=; b=SkmYuTDF0Z/Nyn4W1aaPwWN/ag
        +jBgzLFgxMI0FOqyr15NFjRdVza41fVD0cOoYmz5QwKaqGRQ29LMbWA1ETw1DkKzlvG2+vCAgiBUR
        7KYoJH/VFtNUdp2Y2/DJDE5Y+kOuSqMWMUdkXw/NE/i7WEpxb5E2uq3tIJfabPWWqAtg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXsSy-00023J-0u; Thu, 21 Nov 2019 20:50:12 +0100
Date:   Thu, 21 Nov 2019 20:50:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next 1/3] dpaa2-eth: do not hold rtnl_lock on
 phylink_create() or _destroy()
Message-ID: <20191121195012.GA6602@lunn.ch>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
 <1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:15:25PM +0200, Ioana Ciornei wrote:
> The rtnl_lock should not be held when calling phylink_create() or
> phylink_destroy() since it leads to the deadlock listed below:
> 
> [   18.656576]  rtnl_lock+0x18/0x20
> [   18.659798]  sfp_bus_add_upstream+0x28/0x90
> [   18.663974]  phylink_create+0x2cc/0x828
> [   18.667803]  dpaa2_mac_connect+0x14c/0x2a8
> [   18.671890]  dpaa2_eth_connect_mac+0x94/0xd8

Hi Ioana

Have you done any testing with CONFIG_PROVE_LOCKING enabled. It should
find this sort of problem if the code paths get exercised.

     Andrew
