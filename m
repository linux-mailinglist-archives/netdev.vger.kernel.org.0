Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45B23132A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgG1TyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgG1TyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:54:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FA72065C;
        Tue, 28 Jul 2020 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595966040;
        bh=rp7vzY/jQjxENZUIm0/KJILQs0DODNpkJdTnQKHxXjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qjyUoUUe/FbVBAH+vbZ9eFTMoMAmeqt2njcPRSkuHiniuCQByb7t2dtElKcBTIMAv
         /W3Q0gyP/VZdLB2Cf7xvMdPhkNfkuoIpwWBeXmOho4Z9cSBKSEeAxojqzu1EaQpCsi
         wMX+3BJhBZZNUG1Z+nwIQlsb6u+e6IuuZXEUq73Y=
Date:   Tue, 28 Jul 2020 12:53:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Message-ID: <20200728125359.1e9f9b92@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <VI1PR0402MB3871C269BF4C0C3EA7CF3B22E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
        <20200728120334.28577106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871C269BF4C0C3EA7CF3B22E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 19:33:46 +0000 Ioana Ciornei wrote:
> > Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs stats
> > No, come on, you know what we're going to say to a debugfs patch like this...
> 
> Eh, I figured it was worth a try since I saw that i40e also supports clearing
> the stats through debugfs.

The stuff that got snuck into i40e is the reason I pay very close
attention to Intel patches these days.

> > Is there anything dpaa2-specific here?  We should be able to add a common API
> > for this.  
> 
> No, there is nothing dpaa2-specific. The common API would be in the
> 'ethtool --reset' area or do you have anything other in mind?

We have this huge ongoing discussion about devlink reset/reload:

https://lore.kernel.org/netdev/1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com/
https://lore.kernel.org/netdev/1595847753-2234-1-git-send-email-moshe@mellanox.com/

Perhaps it could fit in there? I presume your reset is on the device
level? If it's per netdev, I'd personally not be opposed to extending
the ethtool API.
