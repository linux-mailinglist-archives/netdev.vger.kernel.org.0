Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BBA2675BB
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgIKWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgIKWNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:13:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC7221D7E;
        Fri, 11 Sep 2020 22:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599862425;
        bh=5D1in9FwtxKTgkgh54fJD2MbqEmt+F6oQgpQ0SrLP7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TCcIwM1eVBXPs96eMd4/MV9yrEJkyMJ7d7Eo0JeZgW2ZQxSzuKt3muPOVS35wxMtB
         9fwcJ1pbkbQ5TS/a2pbT17h/eLHJwxaWFhhV/n7/MtqKeQqhPNrOb4qV3i4H58IKuj
         Zfd+UFJGePcBIpR0KBHvGF4LrYFyL1nsuBfMLnVg=
Date:   Fri, 11 Sep 2020 15:13:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Michael Chan <michael.chan@broadcom.com>, tariqt@nvidia.com,
        saeedm@nvidia.com, Andrew Lunn <andrew@lunn.ch>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next 7/8] ixgbe: add pause frame stats
Message-ID: <20200911151343.25fbbdec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0UccY586mhxRjf+W5gKZdhDMOCXW=p+reEivPnqyFryUbQ@mail.gmail.com>
References: <20200911195258.1048468-1-kuba@kernel.org>
        <20200911195258.1048468-8-kuba@kernel.org>
        <CAKgT0UccY586mhxRjf+W5gKZdhDMOCXW=p+reEivPnqyFryUbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 14:12:50 -0700 Alexander Duyck wrote:
> On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > @@ -3546,6 +3556,7 @@ static const struct ethtool_ops ixgbe_ethtool_ops = {
> >         .set_eeprom             = ixgbe_set_eeprom,
> >         .get_ringparam          = ixgbe_get_ringparam,
> >         .set_ringparam          = ixgbe_set_ringparam,
> > +       .get_pause_stats        = ixgbe_get_pause_stats,
> >         .get_pauseparam         = ixgbe_get_pauseparam,
> >         .set_pauseparam         = ixgbe_set_pauseparam,
> >         .get_msglevel           = ixgbe_get_msglevel,  
> 
> So the count for this is simpler in igb than it is for ixgbe. I'm
> assuming you want just standard link flow control frames. If so then
> this patch is correct. Otherwise if you are wanting to capture
> priority flow control data then those are a seperate array of stats
> prefixed with a "p" instead of an "l". Otherwise this looks fine to
> me.

That's my interpretation, although I haven't found any place the
standard would address this directly. Non-PFC pause has a different
opcode, so I'm reasonably certain this makes sense.

BTW I'm not entirely clear on what "global PFC pause" is either.

Maybe someone can clarify? Mellanox folks?

> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Thanks!

