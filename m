Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD81C570F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgEENft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:35:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgEENft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 09:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cll9ckXAm9hU+VNYEQhApAlvJV5zaQe2RZKf7ey9cIw=; b=TLRyq4czkOc39+47G9rTUdqp/1
        qoiv8e3x7ry++NczA8FCrQg9So5nJR9/ChkjDXcV+WRyCvHpuJsFzrN3+ARZzsSHuldQFagX27yhJ
        o0HhkVuuvE4AtLVZqAyAtzxRUXiq/NfxzX568d46mTGLRTN2bCybUwx7nrE0Q8UfWNl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVxjd-000wDi-Rr; Tue, 05 May 2020 15:35:45 +0200
Date:   Tue, 5 May 2020 15:35:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 10/10] net: phy: Send notifier when starting
 the cable test
Message-ID: <20200505133545.GI208718@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-11-andrew@lunn.ch>
 <20200505113247.GN8237@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505113247.GN8237@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int ethnl_cable_test_started(struct phy_device *phydev)
> > +{
> > +	struct sk_buff *skb;
> > +	int err = -ENOMEM;
> > +	void *ehdr;
> > +
> > +	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> > +	if (!skb)
> > +		goto out;
> > +
> > +	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_CABLE_TEST_NTF);
> > +	if (!ehdr) {
> > +		err = -EINVAL;
> 
> This should rather be -EMSGSIZE. But as we are not going to use the
> return value anyway, it's only cosmetic problem.

Yes, cut/paste from the alloc function. I might put a phydev_err() in
out: so we get to know about errors.

     Andrew
