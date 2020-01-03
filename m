Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0173712F267
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgACBBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:01:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACBBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 20:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=px54fSZwt7jjaEocuUTsFqdzEOA+eLfkgKcFMaWnq0Y=; b=st4nOm2exA+Dtys48L7dL74LWL
        QofMq+pGoNnj1WhMBjkNP34Ku3ZpNqUtVncYk72szNkgH6P4EK7++Hh4xJvNy/eDUBkMUrGbLpQRx
        OQL1JZnHok4JbRwwUbtGl7P0VgkBruxkxDyUBVJedvAlfscY5sc3XI5rKDXdTFEsnRhY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inBLK-0006KI-Lw; Fri, 03 Jan 2020 02:01:34 +0100
Date:   Fri, 3 Jan 2020 02:01:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net] net: freescale: fec: Fix ethtool -d runtime PM
Message-ID: <20200103010134.GC27690@lunn.ch>
References: <20200102143334.27613-1-andrew@lunn.ch>
 <8658c955-eaac-f6d9-5fbe-b8542e26d141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8658c955-eaac-f6d9-5fbe-b8542e26d141@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This fix will do, but you should consider implementing
> ethtool_ops::begin and ethtool_ops::end to make sure this condition is
> resolved for all ethtool operations.
> 
> For instance the following looks possibly problematic too:
> fec_enet_set_coalesce -> fec_enet_itr_coal_set

Hi Florian

I did a quick test of all the ethtool operations which the driver
supports, including setting coalescing. I did not exhaustively try all
possible coalescing settings, but the ones i did try did not provoke a
data abort.

Still, it would make sense to implement begin and end, but only for
net-next.

	Andrew
