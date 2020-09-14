Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC29268259
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 03:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgINBs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 21:48:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINBsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 21:48:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHdbk-00EXKT-V0; Mon, 14 Sep 2020 03:48:40 +0200
Date:   Mon, 14 Sep 2020 03:48:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 1/8] ethtool: add standard pause stats
Message-ID: <20200914014840.GD3463198@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911232853.1072362-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911232853.1072362-2-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int pause_prepare_data(const struct ethnl_req_info *req_base,
> @@ -34,10 +36,17 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
>  
>  	if (!dev->ethtool_ops->get_pauseparam)
>  		return -EOPNOTSUPP;
> +
>  	ret = ethnl_ops_begin(dev);
>  	if (ret < 0)
>  		return ret;
>  	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
> +	if (req_base->flags & ETHTOOL_FLAG_STATS &&
> +	    dev->ethtool_ops->get_pause_stats) {
> +		memset(&data->pausestat, 0xff,
> +		       sizeof(struct ethtool_pause_stats));

Sorry, i missed v1 of these patches. Maybe this has been commented?

Filling with 0xff is odd. I don't know of any other code doing this.

	Andrew
