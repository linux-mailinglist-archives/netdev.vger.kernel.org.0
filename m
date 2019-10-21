Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEC1DEC5E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfJUMho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:37:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfJUMhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UAufsu3nJsKPFGLcmHSRIICkk6jhTpBPs8ucFPOVo0E=; b=y/N7A3iU4w1jIlhOQHp1YSft7J
        c2DOulzr5zb6FlEi+hjBoj/CbAtOjvj6Lxopi7WaBuA0Rto8WKE2qW/jDBiFdQKrjT5YZOOcGEi23
        L9cfOkJ4mLfnzjJhd/OxjrF8vJfpS1C2dkhNWNJMpzTfu1LfxAb0tVMCxdxt7TEIPUTk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMWwO-0004KY-Dw; Mon, 21 Oct 2019 14:37:40 +0200
Date:   Mon, 21 Oct 2019 14:37:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/16] net: dsa: add ports list in the switch
 fabric
Message-ID: <20191021123740.GC16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-3-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020031941.3805884-3-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
> +{
> +	struct dsa_switch_tree *dst = ds->dst;
> +	struct dsa_port *dp;
> +
> +	dp = &ds->ports[index];
> +
> +	dp->ds = ds;
> +	dp->index = index;
> +
> +	INIT_LIST_HEAD(&dp->list);
> +	list_add(&dp->list, &dst->ports);
> +
> +	return dp;
> +}

Bike shedding, but i don't particularly like the name touch.  How
about list. The opposite would then be delist, if we ever need it?

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
