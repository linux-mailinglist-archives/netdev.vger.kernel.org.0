Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F116C453315
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236748AbhKPNsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhKPNsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:48:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C805F61B48;
        Tue, 16 Nov 2021 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637070325;
        bh=zjvb75GhYGXkCMh7lG6jmWfQfW8RDYm0eKS+88fTxQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=stnNGhKS9XDyIXxpa06FQ5bXqlIDk9iHPD725+sol/n9Citlh7EMHkVj7PRZd2q4/
         AcUiFvsie7IaH0SU0VVImnXYsYJDclOhcq+xuPga5skM9nE19Eoby694MGgW4ushku
         Zzl3WdhD+LPuUBruD64e+gnOrS4IzSKln9ESFBePSuzOM+dpL9hO16IcYQJNseSPVq
         3Z9urVZ2okyQET8NcWvFQmr+FeeGcP/e4YLSj+wJLhoyR+v8ILqj+Vw1LmO5ie0Fi/
         FiEkq4mVCwOcNeQS7p/IzfzbPWrlUwym3TTWulLQQ1HzhkyZHdpw+zh5C4OStKKEg2
         1K3B5Lc04zMAg==
Date:   Tue, 16 Nov 2021 05:45:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211116054523.16e7c01e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZNW+mtcXe2kjJlY@nanopsycho>
References: <20211109182427.GJ1740502@nvidia.com>
        <YY0G90fJpu/OtF8L@nanopsycho>
        <YY0J8IOLQBBhok2M@unreal>
        <YY4aEFkVuqR+vauw@nanopsycho>
        <YZCqVig9GQi/o1iz@unreal>
        <YZJCdSy+wzqlwrE2@nanopsycho>
        <20211115125359.GM2105516@nvidia.com>
        <YZJx8raQt+FkKaeY@nanopsycho>
        <20211115150931.GA2386342@nvidia.com>
        <20211115072206.72435d60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZNW+mtcXe2kjJlY@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 08:00:10 +0100 Jiri Pirko wrote:
> >> It is not that we care about events in different namespaces, it is
> >> that rdma, like everything else, doesn't care about namespaces and
> >> wants events from the netdev no matter where it is located.  
> >
> >devlink now allows drivers to be net ns-aware, and they should 
> >obey if they declare support.  Can we add a flag / capability 
> >to devlink and make it an explicit opt-in for drivers who care?  
> 
> Looks kind of odd to me. It is also not possible for netdevice to say if
> it should be net namespace aware or not. The driver should not be the
> one to decide this.

NETIF_F_NETNS_LOCAL, but yeah, if it can be fixed that's obviously better.
