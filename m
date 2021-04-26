Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B444436B3C8
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhDZNGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 09:06:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233294AbhDZNGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 09:06:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lb0vG-001AfE-8R; Mon, 26 Apr 2021 15:05:10 +0200
Date:   Mon, 26 Apr 2021 15:05:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH V2 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Message-ID: <YIa6hnmYhOAOyZLY@lunn.ch>
References: <20210426090447.14323-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426090447.14323-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (wol->wolopts & WAKE_PHY) {
> +		int ret = phylink_ethtool_set_wol(priv->phylink, wol);

This is wrong. No PHY actually implements WAKE_PHY.

What PHYs do implement is WAKE_MAGIC, WAKE_MAGICSEC, WAKE_UCAST, and
WAKE_BCAST. So there is a clear overlap with what the MAC can do.

So you need to decide which is going to provide each of these wakeups,
the MAC or the PHY, and make sure only one does the actual
implementation.

	Andrew
