Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA42EB423
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbhAEUXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:23:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbhAEUXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:23:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwsrI-00GEIt-Rf; Tue, 05 Jan 2021 21:23:12 +0100
Date:   Tue, 5 Jan 2021 21:23:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <X/TKsHr+8U82kwAz@lunn.ch>
References: <20210105171921.8022-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105171921.8022-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -4913,8 +4914,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
>  	bool running = netif_running(port->dev);
>  	bool reset = !prog != !port->xdp_prog;
>  
> -	if (port->dev->mtu > ETH_DATA_LEN) {
> -		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
> +	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");

Hi Marek

Since MVPP2_MAX_RX_BUF_SIZE is a constant, you can probably do some
CPP magic and have it part of the extack message, to give the user a
clue what the maximum is.

     Andrew
