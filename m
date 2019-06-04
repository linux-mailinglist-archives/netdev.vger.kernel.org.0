Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD2C352A2
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFDWS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:18:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFDWS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 18:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w6YG6kyedbz6GiaMZ6Y5XJvnAVbhwy2d5zFmz5fUglI=; b=Gu5lo6INmGq7m2Q9oZsJDGKCjb
        2mTNNFkGdfLj3WCLcAwM3P709TzQ1TWuRKVO5QvrdLa3K8YNgJi9nxISNIpUuQCzsSPQ8e7+8VNMz
        d02I2yB+JYQIJiEBgia+l6v78DR13z7X1BxpkBsHP0soJ751PWILzwzWE+wN+dIW2lLg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYHlg-0000bD-Hw; Wed, 05 Jun 2019 00:18:56 +0200
Date:   Wed, 5 Jun 2019 00:18:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v3 07/19] net: axienet: Re-initialize MDIO
 registers properly after reset
Message-ID: <20190604221856.GB19627@lunn.ch>
References: <1559684626-24775-1-git-send-email-hancock@sedsystems.ca>
 <1559684626-24775-8-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559684626-24775-8-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	axienet_iow(lp, XAE_MDIO_MC_OFFSET,
> -		    (mdio_mcreg & (~XAE_MDIO_MC_MDIOEN_MASK)));
> +	mutex_lock(&lp->mii_bus->mdio_lock);
> +	axienet_mdio_disable(lp);

I wonder if it would look better structured if the lock was in
axienet_mdio_disable() and the unlock in axienet_mdio_enable(lp)?

As you said, you are trying to refactor all the MDIO code it mdio.c.

   Andrew
