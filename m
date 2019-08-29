Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3009EA1150
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfH2GBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:01:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:48676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfH2GBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 02:01:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C728AE12;
        Thu, 29 Aug 2019 06:01:39 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 74969E0CFC; Thu, 29 Aug 2019 08:01:38 +0200 (CEST)
Date:   Thu, 29 Aug 2019 08:01:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "liudongxu3@huawei.com" <liudongxu3@huawei.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Adding parameter detection in
 __ethtool_get_link_ksettings.
Message-ID: <20190829060138.GL29594@unicorn.suse.cz>
References: <aa0a372e-a169-7d78-0782-505cbdab8f90@gmail.com>
 <20190826094705.10544-1-liudongxu3@huawei.com>
 <0db9e18a4dd81d9a6025a2d8cda343b585d91fc4.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0db9e18a4dd81d9a6025a2d8cda343b585d91fc4.camel@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 07:01:41PM +0000, Saeed Mahameed wrote:
> On Mon, 2019-08-26 at 17:47 +0800, Dongxu Liu wrote:
> 
> > Maybe "if (!dev->ethtool_ops)" is more accurate for this bug.
> > 
> 
> Also i am not sure about this, could be a bug in the device driver your
> enslaving.
> 
> alloc_netdev_mqs will assign &default_ethtool_ops to dev->ethtool_ops ,
> if user provided setup callback didn't assign the driver specific
> ethtool_ops.

Dongxu said he encountered the null pointer dereference in a 3.10
kernel, not current mainline. But commit 2c60db037034 ("net: provide a
default dev->ethtool_ops") which introduced default_ethtool_ops came in
3.7-rc1 so 3.10 should have it already. There is indeed something wrong.

I don't think we should add either check unless we positively know that
dev->ethtool_ops can be null with current mainline kernel. And even
then, it would probably be more appropriate to fix the code which caused
it.

Michal
