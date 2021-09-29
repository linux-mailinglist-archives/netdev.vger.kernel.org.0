Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A2741CAF5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbhI2RRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:17:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245166AbhI2RRs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 13:17:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=erakbhXi+Me/Hw6BfHO0fnn9A6VZYP8g4nNvk9wz1wk=; b=rET1WvGeyugFQQWf/LZPIylmrZ
        MKL+mHILNJPR/yNtRW7ROeEP0f1w7YcUdqDbIbUhI87hC85ot6kqOIpHbynk9Iilf6xp8v7sG1x/x
        o+PMwVNCAslqh5dEq+wBPWqelalVRBIRz7/+GMK3Co5su7XfNxzK4UbFZ3K/7ESot+Wo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVdBQ-008p2N-VY; Wed, 29 Sep 2021 19:15:52 +0200
Date:   Wed, 29 Sep 2021 19:15:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
Message-ID: <YVSfSNyVeaIx6n8k@lunn.ch>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:50:47PM +0800, Jian Shen wrote:
> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.
> 
> This patchset try to solve it by change the prototype of
> netdev_features_t from u64 to bitmap. With this change,
> it's necessary to introduce a set of bitmap operation helpers
> for netdev features. Meanwhile, the functions which use
> netdev_features_t as return value are also need to be changed,
> return the result as an output parameter.
> 
> With above changes, it will affect hundreds of files, and all the
> nic drivers. To make it easy to be reviewed, split the changes
> to 167 patches to 5 parts.
> 
> patch 1~22: convert the prototype which use netdev_features_t
> as return value
> patch 24: introduce fake helpers for bitmap operation
> patch 25~165: use netdev_feature_xxx helpers
> patch 166: use macro __DECLARE_NETDEV_FEATURE_MASK to replace
> netdev_feature_t declaration.
> patch 167: change the type of netdev_features_t to bitmap,
> and rewrite the bitmap helpers.
> 
> Sorry to send a so huge patchset, I wanna to get more suggestions
> to finish this work, to make it much more reviewable and feasible.

What you should of done is converted just one MAC driver. That gives
us enough we can review the basic idea, etc, and not need to delete
130 nearly identical patches.

   Andrew
