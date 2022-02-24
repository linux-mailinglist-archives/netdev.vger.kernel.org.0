Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4B54C33EB
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiBXRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiBXRny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:43:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D7B252937;
        Thu, 24 Feb 2022 09:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fp0EGUnqc8RMl+9AA8JB9DRwPTVJiBPYZtxhUdnF7mQ=; b=U20jT4e+wXtZmN24NmNeTGFFil
        BLvHQW3oGNWN0NQICvpNylRljw3bUfZMzqy93sajFW4Bj1fkN1hTS9SbTBQ4weRn+7XD3swmJv5Lr
        xetkyXjd7RQekaWaCtviYqiye+sCCdkw5caW3RWaYxhFXvUq/58BZmFJ2ZDzDMoBy+1Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nNI94-007zwg-BT; Thu, 24 Feb 2022 18:43:14 +0100
Date:   Thu, 24 Feb 2022 18:43:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mauri Sandberg <maukka@ext.kapsi.fi>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: mv643xx_eth: process retval from
 of_get_mac_address
Message-ID: <YhfDsrUke6OzsxAj@lunn.ch>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
 <20220223142337.41757-1-maukka@ext.kapsi.fi>
 <20220224085754.703860a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224085754.703860a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 08:57:54AM -0800, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 16:23:37 +0200 Mauri Sandberg wrote:
> > Obtaining a MAC address may be deferred in cases when the MAC is stored
> > in an NVMEM block, for example, and it may not be ready upon the first
> > retrieval attempt and return EPROBE_DEFER.
> > 
> > It is also possible that a port that does not rely on NVMEM has been
> > already created when getting the defer request. Thus, also the resources
> > allocated previously must be freed when doing a roll-back.
> > 
> > Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> 
> While we wait for Andrew's ack, is this the correct fixes tag?
> 
> Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")


Yes, that looks correct. The history around here is convoluted, and
anybody trying to backport that far is going to need a few different
versions.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
