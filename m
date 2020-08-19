Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108222491C4
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHSAYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSAYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 20:24:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF5B620738;
        Wed, 19 Aug 2020 00:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597796663;
        bh=FWPHmdBQHTKcM6rXSZw0Vlb7kcy9ULMPqViOX64OtjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BDj4dLCl+8QjKaFZMOXPRbTEHE5jjXmwManAIhBL+fSrZ4fSE9fBxF911ae9p3X+x
         KlwOR7BPOKiSAkAEE5GGmbq+X8ZYo9NEfAXv7KySuibChC8plqsKgbrsiO8cpIZSLD
         Vs2rltF0q8igwayvHur2kzxbLwCUoRe+epHJZETg=
Date:   Tue, 18 Aug 2020 17:24:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 15:50:53 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set extends devlink to allow device drivers to expose device
> metrics to user space in a standard and extensible fashion, as opposed
> to the driver-specific debugfs approach.

I feel like all those loose hardware interfaces are a huge maintenance
burden. I don't know what the solution is, but the status quo is not
great.

I spend way too much time patrolling ethtool -S outputs already.

I've done my absolute best to make sure that something as simple as
updating device firmware can be done in a vendor-agnostic fashion, 
and I'm not sure I've succeeded. Every single vendor comes up with
their own twists.

Long story short I'm extremely unexcited about another interface where
drivers expose random strings of their picking. Maybe udp_tunnel module
can have "global" stats?

This would be a good topic for netconf, or LPC hallway discussion :(
