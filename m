Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EED31FDB
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfFAQEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 12:04:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfFAQEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 12:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tdktNTrvifj9xw6GAZ7hsKI1EUS0OsdpyU+NlVA+YKw=; b=Fuu+wpto1sIxwspHFc7oLCySGH
        a18IU1UhxSVCqO09eCLA4mbXAE6oGPteE/m0SEjUKb7lyfEFidanx4m7+umCv/huElZbw/DheZ4+t
        qtD+TIhNgZ13imGdrJeV8sK2vjBUjKue3rLlZe+mVLzzsvXqc07p6eZXjQ23AkNFgMNo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hX6U8-00058j-K2; Sat, 01 Jun 2019 18:03:56 +0200
Date:   Sat, 1 Jun 2019 18:03:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: sja1105: Force a negative value for
 enum sja1105_speed_t
Message-ID: <20190601160356.GB19081@lunn.ch>
References: <20190601103735.27506-1-olteanv@gmail.com>
 <20190601103735.27506-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601103735.27506-2-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 01:37:34PM +0300, Vladimir Oltean wrote:
> The code in sja1105_adjust_port_config relies on the fact that an
> invalid link speed is detected by sja1105_get_speed_cfg and returned as
> -EINVAL.  However storing this into an enum that only has positive
> members will cast it into an unsigned value, and it will miss the
> negative check.
> 
> So make the -EINVAL value part of the enum, so that it is stored as a
> signed number and passes the negative check.
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Hi Vladimir

It seems like just using a switch statement would be simpler, and more
likely to be correct. And it would avoid adding SJA1105_SPEED_INVALID
= -EINVAL which feels hackish.

  Andrew
