Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5FC1FFA5F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732297AbgFRRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:35:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbgFRRfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 13:35:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlyRG-0019Je-Kk; Thu, 18 Jun 2020 19:34:58 +0200
Date:   Thu, 18 Jun 2020 19:34:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
Message-ID: <20200618173458.GH240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-7-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-7-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:40:26AM +0200, Kurt Kanzenbach wrote:
> The switch has registers which are useful for debugging issues:

debugfs is not particularly likes. Please try to find other means
where possible. Memory usage fits nicely into devlink. See mv88e6xxx
which exports the ATU fill for example. Are trace registers counters?

> +static int hellcreek_debugfs_init(struct hellcreek *hellcreek)
> +{
> +	struct dentry *file;
> +
> +	hellcreek->debug_dir = debugfs_create_dir(dev_name(hellcreek->dev),
> +						  NULL);
> +	if (!hellcreek->debug_dir)
> +		return -ENOMEM;

Just a general comment. You should not check the return value from any
debugfs call, since it is totally optional. It will also do the right
thing if the previous call has failed. There are numerous emails from
GregKH about this.

       Andrew
