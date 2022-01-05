Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41470485B5E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbiAEWLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:11:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244752AbiAEWKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 17:10:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sV+cVGNhfu4EhoH05ZyDTLIELwabBgpwLOZPBe9qnEY=; b=WnLSb4zo9m4IMxpCchfBOjvpvp
        SkhT2oV/yEwW28XAShvaZSb+OpVGbTgYf4gK5rcfrFLRIpFtAeR9kUXCcPj+DKAuez39SlBf+3U2O
        6OwSjT0i6UzJuhm5BARTOpuTckMRI1peV9A3b1cjVcQdd5MKAhRiFEDgTb2JNc34yKO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5EUN-000bFF-D2; Wed, 05 Jan 2022 23:10:35 +0100
Date:   Wed, 5 Jan 2022 23:10:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next 2/7] net: dsa: merge all bools of struct
 dsa_port into a single u8
Message-ID: <YdYXWy241wJo5wuC@lunn.ch>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105132141.2648876-3-vladimir.oltean@nxp.com>
 <d41c058c-d20f-2e9f-ea2c-0a26bdb5fea3@gmail.com>
 <20220105183934.yxidfrcwcuirm7au@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105183934.yxidfrcwcuirm7au@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 06:39:34PM +0000, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, Jan 05, 2022 at 10:30:54AM -0800, Florian Fainelli wrote:
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Thanks a lot for the review.
> 
> I'm a bit on the fence on this patch and the other one for dsa_switch.
> The thing is that bit fields are not atomic in C89, so if we update any
> of the flags inside dp or ds concurrently (like dp->vlan_filtering),
> we're in trouble. Right now this isn't a problem, because most of the
> flags are set either during probe, or during ds->ops->setup

I've no idea if it ever got merged, but:

https://lwn.net/Articles/724319/

	Andrew
