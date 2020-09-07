Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF32526039E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgIGRwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbgIGRwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 13:52:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A092080A;
        Mon,  7 Sep 2020 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599501119;
        bh=Hqa9s+doomo9cBO9eKXZjZCGDgl5B/JLzs4maHo8b6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VbL5CAmTopZu8i3760hA5mo4J5WlioayGSCx8q9OVMg0WwF0YG+/2Xr67l9mukSIh
         aneVCCImdHfFc/hZa9m/6lRZola3AXXALtV7l/o66yLJhEu65HCRg+yQdSEXktvKwj
         SRE99a8zbFuwxh6vhWnRr8lI6dHfgFRs285LyVuI=
Date:   Mon, 7 Sep 2020 20:51:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        yishaih@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] mlx4: make sure to always set the port type
Message-ID: <20200907175155.GD421756@unreal>
References: <20200904200621.2407839-1-kuba@kernel.org>
 <20200906072759.GC55261@unreal>
 <20200906093305.5c901cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907062135.GJ2997@nanopsycho.orion>
 <20200907064830.GK55261@unreal>
 <20200907093614.12231d6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907093614.12231d6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 09:36:14AM -0700, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 09:48:30 +0300 Leon Romanovsky wrote:
> >>>> And can we call to devlink_port_type_*_set() without IS_ENABLED() check?
> >>>
> >>> It'll generate two netlink notifications - not the end of the world but
> >>> also doesn't feel super clean.
> >
> > I would say that such a situation is corner case during the driver init and
> > not an end of the world to see double netlink message.
>
> Could you spell out your reasoning here? Are you concerned about
> out-of-tree drivers?

Nothing fancy, I just didn't see users who compiled mlx4_core and used
it without eth/ib.

The corner case is because this double netlink can be seen only during
driver reload and only if port type wasn't set.

>
> I don't see how adding IS_ENABLED() to the condition outweighs
> the benefit of not having duplicated netlink notifications.

Readability?

Anyway, it doesn't matter.

Thanks
