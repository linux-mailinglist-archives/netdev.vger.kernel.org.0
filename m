Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CE788F34
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 05:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHKDWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 23:22:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfHKDWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 23:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cI5p1XQLyIExMHElEEu9ho2V0ZrEcMfH/r5aBwEaBW0=; b=Yzr0rdSC7WwCIyIDdxVQKifrhr
        +0fqD6dxkh5xNxHyEfNgmrdpsq3nyHuz9YN702twIiDZMfz0A66jnS9DGnUVAB/g6+7BXRt3qdACO
        /ZrvpD3d/BdKElQ9dHneeszuonhkwqbZXYfKUwyOO5CQvZKrL3b+Mr7CyNfy4rioZVWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hweRH-0002Bu-UH; Sun, 11 Aug 2019 05:22:35 +0200
Date:   Sun, 11 Aug 2019 05:22:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Message-ID: <20190811032235.GK30120@lunn.ch>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
 <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

>  >> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
>  >> +	struct ethsw_core *ethsw = port_priv->ethsw_data;
>  >> +	int i, err;
>  >> +
>  >> +	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
>  >> +		if (ethsw->ports[i]->bridge_dev &&
>  >> +		    (ethsw->ports[i]->bridge_dev != upper_dev)) {
>  >> +			netdev_err(netdev,
>  >> +				   "Another switch port is connected to %s\n",
>  >> +				   ethsw->ports[i]->bridge_dev->name);
>  >> +			return -EINVAL;
>  >> +		}
>  >
>  > Am i reading this correct? You only support a single bridge?  The
>  > error message is not very informative. Also, i think you should be
>  > returning EOPNOTSUPP, indicating the offload is not possible. Linux
>  > will then do it in software. If it could actually receive/transmit the
>  > frames....
>  >
> 
> Yes, we only support a single bridge.

That is a pretty severe restriction for a device of this class. Some
of the very simple switches DSA support have a similar restriction,
but in general, most do support multiple bridges.

Are there any plans to fix this?

Thanks
	Andrew
