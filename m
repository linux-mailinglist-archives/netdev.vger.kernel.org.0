Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4CD3F1BCC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbhHSOnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240502AbhHSOnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96F261155;
        Thu, 19 Aug 2021 14:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629384164;
        bh=QGXmAC/A9jwYeqDVJPovd8o70WkkpqjZbIsfUOtmXWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RprvYwxf7u53KoUlKleaLkDvrLeUXcAhnYTrw/fE4YeAU8edTZIxEWzT6Jd7Qzay7
         cv/OkZgHy2/iPWR0s7NX9XPiBmScrWhTU6T4P5GCXid9k8DLuyWYROnaN/Ox60A0Vp
         5Fsh7bNGrpiMQLLJEOTBxUEsuAQRb9KSZcVE2utEYZb0yt6HKJlMPYLXbH/Yn/V4O5
         nCPlZ9D5jOOrqzv6PFpod446u+9QViBlpmJWIXGzH3bQlp3YsutNiE8oCIq+MMB6ui
         xHIwa15L0f9R5GP3ME61f+FdT3LVeNiyufuVdZYY5Lvgd/fffZfHy8OgbbBLGsmLqd
         hkL98r3H71X/Q==
Date:   Thu, 19 Aug 2021 07:42:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210819074242.250ab9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YR5sBqnf7RZqVKl4@shredder>
References: <20210818155202.1278177-1-idosch@idosch.org>
        <20210818155202.1278177-2-idosch@idosch.org>
        <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YR2P7+1ZGiEBDtAq@lunn.ch>
        <YR4NTylFy2ejODV6@shredder>
        <YR5Y5hCavFaWZCFH@lunn.ch>
        <YR5sBqnf7RZqVKl4@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Aug 2021 17:34:46 +0300 Ido Schimmel wrote:
> > That is kind of my question. Do you want the default driver defined,
> > and varying between implementations, or do we want a clearly defined
> > default?
> > 
> > The stack has a mixture of both. An interface is admin down by
> > default, but it is anybody guess how pause will be configured?
> > 
> > By making it driver undefined, you cannot assume anything, and you
> > require user space to always configure it.
> > 
> > I don't have too strong an opinion, i'm more interested in what others
> > say, those who have to live with this.  
> 
> I evaluated the link up times using a QSFP module [1] connected to my
> system. There is a 36% increase in link up times when using the 'auto'
> policy compared to the 'high' policy (default on all Mellanox systems).
> Very noticeable and very measurable.
> 
> Couple the above with the fact that despite shipping millions of ports
> over the years, we are only now getting requests to control the power
> mode of transceivers and from a small number of users.
> 
> In addition, any user space that is interested in changing the behavior,
> has the ability to query the default policy and override it in a
> vendor-agnostic way.
> 
> Therefore, I'm strictly against changing the existing behavior.
> 
> [1] https://www.mellanox.com/related-docs/prod_cables/PB_MFS1S00-VxxxE_200GbE_QSFP56_AOC.pdf

Fine by me FWIW. Obviously in an ideal world we'd have uniform presets
as part of 'what it means to be upstream Linux' but from practical
standpoint where most features start out of tree having the requirement
of uniformity will be an impediment preventing vendors from switching to
upstream APIs. That's my personal opinion or should I say 'gut feeling',
I could well be wrong.
