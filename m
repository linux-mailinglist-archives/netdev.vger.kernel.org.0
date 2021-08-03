Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFA3DF105
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhHCPDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:03:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236643AbhHCPDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 11:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=00bMcGZr7g/To2yLQfcu2mY9cs2Wv9EJDvKiwmXlYDE=; b=d3fZd4o4xomyFb/dI6z3/8fThI
        Wncae1mmk9zKB+PhqU4NHOd/7NPpabhQNnTlPI3LYEVgB7XAXGJznRphwH/3QGI9yKL+Dze4S4V4s
        nGk9NPP2laqoFfc6k4nQR+5+qIaMQNFvL1+VDhJMdCRPcsK52SgIpc0Tt/99S1nWAXlk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAvx7-00Fysd-MY; Tue, 03 Aug 2021 17:03:33 +0200
Date:   Tue, 3 Aug 2021 17:03:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: update ethtool reporting of pauseframe control
Message-ID: <YQlaxfef22GxTF9r@lunn.ch>
References: <20210803103911.22639-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803103911.22639-1-simon.horman@corigine.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:39:11PM +0200, Simon Horman wrote:
> From: Fei Qin <fei.qin@corigine.com>
> 
> Pauseframe control is set to symmetric mode by default on the NFP.
> Pause frames can not be configured through ethtool now, but ethtool can
> report the supported mode.
> 
> Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
> Signed-off-by: Fei Qin <fei.qin@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 1b482446536d..8803faadd302 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -286,6 +286,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
>  
>  	/* Init to unknowns */
>  	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
> +	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
> +	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);

Hi Simon

Does it act on the results of the pause auto-neg? If the link peer
says it does not support pause, will it turn pause off?

     Andrew
