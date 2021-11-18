Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72666455DCF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhKROUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhKROUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:20:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7A6D61181;
        Thu, 18 Nov 2021 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245057;
        bh=2tXq5tG9tim++xDKgHz7qG0RB/hUyPj5LTepwQl5woE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mVxeT2VaI95X/rh7epPgwVghYeFJNl7aHeNPce+F/oYgLBaSKczu5suHMHAKAZ55j
         idOpi3HNGtFuwaHWT/HWy9wVV/3qdVuBRAuYsDdCdLmsh+K7h2jCsGUz7vp3KeSI03
         OR3vmjNeZRumkoddoDPfGOrimLNzTLltsu0Srq45s4OC32Xrj3mdFwhYxPUPtduday
         vv8CLQNeeVzxg3XvTtM3AAxB7hH7Zv9BklxuGDFWNiwVoRgyatbHXlfuIOXoQ2h4aM
         QPSBmMzRQqHlHzwh0mVy3dOh40LdQBPFWYrLLR73VR+WDA7qdYSQKvVjpcYMocJHhX
         Uy1aKw3dtS+wQ==
Date:   Thu, 18 Nov 2021 06:17:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     Petr Machata <petrm@nvidia.com>, <davem@davemloft.net>,
        <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
        <87k0h9bb9x.fsf@nvidia.com>
        <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87a6i3t2zg.fsf@nvidia.com>
        <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 09:46:24 +0800 Ziyang Xuan (William) wrote:
> >> I think we should move the dev_hold() to ndo_init(), otherwise 
> >> it's hard to reason if destructor was invoked or not if
> >> register_netdevice() errors out.  
> > 
> > Ziyang Xuan, do you intend to take care of this?
> > .  
> 
> I am reading the related processes according to the problem scenario.
> And I will give a more clear sequence and root cause as soon as possible
> by some necessary tests.

Okay, I still don't see the fix. 

Petr would you mind submitting since you have a repro handy?
