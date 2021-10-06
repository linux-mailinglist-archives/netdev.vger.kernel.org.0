Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781A84241CF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhJFPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhJFPvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E791F610A5;
        Wed,  6 Oct 2021 15:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535358;
        bh=t+fefmIzou1MCCdMpMTGXpgtZCXQhx/8uLCzjTBTudk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o6lgB6Z55oFS4ow66q9dzjQ5Ae6/DDcNAVXEKvaAxyZ+3p/iC5Zfibwbr32j8XTln
         Gn+tUjaQMuY2jXrYZ1ayp7qAaGF08hNjKv/HHZAwYF7Btt+PKz0P/C5ZDkjj3lZEvJ
         9NYZC2aKt/sZXmaPHdqkz2mvsCLv2BETCc+fer4vt2VglO7/jucaH0yfqXN22f1nJ+
         zKke7BcJ7kiAjgp5PlJqw4LJ0xtx7lkf/hDtIN0IWFVB3EGJAiUwf04LjaWG2gCZuL
         2mD/jVN+95j+L6DMouh8U7CnKOMwedl53xQ75XZ0GzQWlX/ajyZMKCLG4BYcEt/nnW
         JTTnlKwkJJwKA==
Date:   Wed, 6 Oct 2021 08:49:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        jeremy.linton@arm.com
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
Message-ID: <20211006084916.2d924104@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YV23gINkk3b9m6tb@lunn.ch>
References: <20211006022444.3155482-1-kuba@kernel.org>
        <YV23gINkk3b9m6tb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 16:49:36 +0200 Andrew Lunn wrote:
> > --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> > +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> > @@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
> >  		return -ENOMEM;
> >  	}
> >  
> > -	if (!device_get_ethdev_addr(dev, ndev))
> > +	if (device_get_ethdev_addr(dev, ndev))
> >  		eth_hw_addr_random(ndev);  
> 
> That is going to be interesting for out of tree drivers.

Indeed :(  But I think it's worth it - I thought it's only device tree
that has the usual errno return code but inside eth.c there are also
helpers for platform and nvmem mac retrieval which also return errno.
