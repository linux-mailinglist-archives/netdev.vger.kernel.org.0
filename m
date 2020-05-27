Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572BF1E5097
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgE0Viq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:38:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgE0Vip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F5/7Ag9u4a15gIrxx4gP/9yATGMdkJnjIZU3PkOYAFI=; b=1WNWJj/GHi7OKyZQMeP4htlLek
        AjH4pWG1fsHyJxlqwzAZ5RyAwPQHwiK1D9uppMXphouY/FcaJZ0ZIYqK87dc/Si/w/T8PBwr+MhWq
        7jzrEfigUP9r6TMd1blx5fxnMGYEVFCWP6XEsAP+f4b/VHXtF5FNJZ/vRuuLxoInKuLY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1je3l5-003SPq-Dx; Wed, 27 May 2020 23:38:43 +0200
Date:   Wed, 27 May 2020 23:38:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
Message-ID: <20200527213843.GC818296@lunn.ch>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 03:41:22PM +0000, Amit Cohen wrote:
> Hi Andrew,
> 
> We are planning to send a set that exposes link-down reason in ethtool.
> 
> It seems that the ability of your set “Ethernet cable test support” can be
> integrated with link-down reason.
> 
>  
> 
> The idea is to expose reason and subreason (if there is):
> 
> $ ethtool ethX
> 
> …
> 
> Link detected: no (No cable) // No sub reason
> 
>  
> 
> $ ethtool ethY
> 
> Link detected: no (Autoneg failure, No partner detected)
> 
>  
> 
> Currently we have reason “cable issue” and subreasons “unsupported cable” and
> “shorted cable”.
> 
> The mechanism of cable test can be integrated and allow us report “cable issue”
> reason and “shorted cable” subreason.

Hi Amit

I don't really see them being combinable. First off, your API seems
too limiting. How do you say which pair is broken, or at what
distance? What about open cable, as opposed to shorted cable?

So i would suggest:

Link detected: no (cable issue)

And then recommend the user uses ethtool --cable-test to get all the
details, and you have a much more flexible API to provide as much or
as little information as you have.

   Andrew
