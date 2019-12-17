Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA8C12295E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 11:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfLQK7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 05:59:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfLQK7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 05:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j+kDSnNZibDPGmGiavTo8MBbX0StIr3Q6zqHd8Wr8m8=; b=RWR5ySgH5WF0N8DME7aypZQWpM
        QRnSlcwOD2YVcxgoz1DTu1qgN8s4UuejHEbgewyeE8nZQgb8bkUcoLDA/A1o1WugxM/YG3RjPlI6T
        BYwFOkjiYqUwiJZ+DSd0CZt9k3USMvWFk0v9BltXNQHX3crx2JsPL0HTmXcVTdRG7tVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihAZt-0007CG-CF; Tue, 17 Dec 2019 11:59:45 +0100
Date:   Tue, 17 Dec 2019 11:59:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH net-next 3/3] net: axienet: Pass ioctls to the phy.
Message-ID: <20191217105945.GA17965@lunn.ch>
References: <cover.1576520432.git.richardcochran@gmail.com>
 <361f63095be92df10e8e953af3b981cdac58d98e.1576520432.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <361f63095be92df10e8e953af3b981cdac58d98e.1576520432.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> +{
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case SIOCGMIIPHY:
> +	case SIOCGMIIREG:
> +	case SIOCSMIIREG:
> +	case SIOCSHWTSTAMP:
> +	case SIOCGHWTSTAMP:
> +		return phy_mii_ioctl(dev->phydev, rq, cmd);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}

Hi Richard

You don't need to be conditional. phy_mii_ioctl() and
phylink_mii_ioctl() will return -EOPNOTSUPP for anything it does not
support.

	Andrew
