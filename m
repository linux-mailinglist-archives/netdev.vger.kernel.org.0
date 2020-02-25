Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAA816F26F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBYWFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:05:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgBYWFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5Nu7vVzAgRjIOT3nTKCs9kz7QufjSh2yf/3fHkW8+Zs=; b=gbA5lK2wqlsFBRMia+r1AyPz0b
        tI5grpHd3hS6O4tWDbZ00K4LMxYGrInJxRaPM1+HdS6L2NmzX4Rzcldr7uaWM+89LuY7SvascB2hS
        z0etRRCqMroh8OIE8DqzS5i5I0z+1yetLDNfPvOgSHhd5fA1cAyybEWNz5Z1Xpovpu1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6iKZ-0001ct-9M; Tue, 25 Feb 2020 23:05:31 +0100
Date:   Tue, 25 Feb 2020 23:05:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Message-ID: <20200225220531.GH7663@lunn.ch>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225163025.9430-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mvsw_pr_port_obj_attr_set(struct net_device *dev,
> +				     const struct switchdev_attr *attr,
> +				     struct switchdev_trans *trans)
> +{
> +	int err = 0;
> +	struct mvsw_pr_port *port = netdev_priv(dev);
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		err = -EOPNOTSUPP;
> +		break;

That is interesting. Is the linux bridge happy with this? Particularly
when you have other interfaces in the Linux SW bridge, which cause a
loop via the switch ports? I assume the network then dies in a
broadcast storm, since there is nothing Linux can do to solve the
loop.

       Andrew
