Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D504A1C56AD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgEENWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:22:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgEENWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hVfUHHjlv46RQ1l+YXEbPOpdzuWu6b+PUyGbuOSTRSw=; b=Hc6jRazIO66vYIoMr8Y5M4qwTU
        57oK+4AsmpGXetUyuOJAfiI+jVsAN5cFnsiVF+TLhffQ7C2vLTigLdotYD32r9OyaM4Y+9rsocWJN
        yTSUV/IUG92ftRJZNrSIAMl6GjZKsFddyWcPBJaaUTWDCaSgSbhEaffCaDHfUJRoAqzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVxWN-000w4r-PV; Tue, 05 May 2020 15:22:03 +0200
Date:   Tue, 5 May 2020 15:22:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 07/10] net: ethtool: Add helpers for
 reporting test results
Message-ID: <20200505132203.GG208718@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-8-andrew@lunn.ch>
 <20200505105043.GK8237@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505105043.GK8237@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
> > +{
> > +	struct nlattr *nest;
> > +	int ret = -EMSGSIZE;
> > +
> > +	nest = nla_nest_start(phydev->skb,
> > +			      ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH);
> > +	if (!nest)
> > +		return -EMSGSIZE;
> > +
> > +	if (nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR, pair))
> > +		goto err;
> > +	if (nla_put_u16(phydev->skb, ETHTOOL_A_CABLE_FAULT_LENGTH_CM, cm))
> > +		goto err;
> 
> This should be nla_put_u32().

Yes. I think i messed up a rebase merge conflict somewhere. I'm also
surprised user space is not complaining.

	  Andrew
