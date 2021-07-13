Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4273C768F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 20:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhGMSmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:42:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38740 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGMSmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 14:42:53 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2DDF062437;
        Tue, 13 Jul 2021 20:39:45 +0200 (CEST)
Date:   Tue, 13 Jul 2021 20:40:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
Message-ID: <20210713184002.GA26070@salvia>
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210713160745.59707-4-nbd@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 06:07:41PM +0200, Felix Fietkau wrote:
[...]
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..7ea6a1db0338 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -885,6 +885,10 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
>  		if (WARN_ON_ONCE(last_dev == ctx.dev))
>  			return -1;
>  	}
> +
> +	if (!ctx.dev)
> +		return ret;

This is not a safety check, right? After this update ctx.dev might be NULL?

> +
>  	path = dev_fwd_path(stack);
>  	if (!path)
>  		return -1;
> -- 
> 2.30.1
> 
