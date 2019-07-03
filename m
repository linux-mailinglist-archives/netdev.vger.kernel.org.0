Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9004D5E837
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfGCPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:55:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfGCPzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 11:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y5u5+eN+IOcT/cjbotCc6sj/oFgAPYdu3ukdDY4zf34=; b=CLHlKmx3VU/sWoaxoxQff59Py3
        /fYjhCOFUo/6gKq5mcXzmI5HmVAwbgTNOLfeIxNsCpchudYmUQWpfX/2YJapvNc8ryy/vwiwYsHRp
        5TBrH3sd2z6ntPbmWwtxnnY2TfDTuLw/nGREmtleJzgcBCgOGR7uyOpuB3eOg5pQ9MuM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hihbK-00063z-TD; Wed, 03 Jul 2019 17:55:18 +0200
Date:   Wed, 3 Jul 2019 17:55:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190703155518.GE18473@lunn.ch>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 03:10:34PM +0200, Benjamin Beckmeyer wrote:
> Hey folks,
> 
> I'm having a problem with a custom i.mx6ul board. When DSA is loaded I can't 
> get access to the switch via MDIO, but the DSA is working properly. I set up
> a bridge for testing and the switch is in forwarding mode and i can ping the 
> board. But the MDIO access isn't working at address 2 for the switch. When I 
> delete the DSA from the devicetree and start the board up, I can access the 
> switch via MDIO.
> 
> With DSA up and running:
> 
> mii -i 2 0 0x9800
> mii -i 2 1
> phyid:2, reg:0x01 -> 0x4000
> mii -i 2 0 0x9803
> mii -i 2 1
> phyid:2, reg:0x01 -> 0x4000
> mii -i 2 1 0x1883
> mii -i 2 1
> phyid:2, reg:0x01 -> 0x4000

Hi Benjamin

I'm guessing that the driver is also using register 0 and 1 at the
same time you are, e.g. to poll the PHYs for link status etc.

There are trace points for MDIO, so you can get the kernel to log all
registers access. That should confirm if i'm right.

	  Andrew
