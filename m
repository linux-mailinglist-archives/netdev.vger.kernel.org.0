Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76CF290E51
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 02:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411283AbgJQAFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 20:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411510AbgJQABx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 20:01:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA1222203;
        Sat, 17 Oct 2020 00:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602892889;
        bh=xYyU7HNpb8kciSA2gjxbTtUsERt/l6+7SlYsGylARjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eGo4rDnfLljNjzPm8RP1uipVW0BUZf0yQ8y4aS3HyWaX0OxEHJKaMM46F6x0VS7nc
         9FE+W8dpD3tmiF87N5msDcCrQSnP2mhp3KSE69mxXLOampBjm+BmG7/YTMkz4/Up8F
         Q0qubTBoqDbwveNNj2Me36cDzRhfqMQuETNJplFA=
Date:   Fri, 16 Oct 2020 17:01:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>, anthony.l.nguyen@intel.com
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team@fb.com, jesse.brandeburg@intel.com,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net] ixgbe: fix probing of multi-port devices with one
 MDIO
Message-ID: <20201016170126.21b1cad5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA85sZsm0ZNGoU59Lhn+qUHDAUcNjLoJYdqUf45k_nSkANMDog@mail.gmail.com>
References: <20201016232006.3352947-1-kuba@kernel.org>
        <CAA85sZsm0ZNGoU59Lhn+qUHDAUcNjLoJYdqUf45k_nSkANMDog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 01:50:59 +0200 Ian Kumlien wrote:
> On Sat, Oct 17, 2020 at 1:20 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Ian reports that after upgrade from v5.8.14 to v5.9 only one
> > of his 4 ixgbe netdevs appear in the system.
> >
> > Quoting the comment on ixgbe_x550em_a_has_mii():
> >  * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
> >  * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
> >  * but we only want to register one MDIO bus.
> >
> > This matches the symptoms, since the return value from
> > ixgbe_mii_bus_init() is no longer ignored we need to handle
> > the higher ports of x550em without an error.  
> 
> Nice, that fixes it!
> 
> You can add a:
> Tested-by: Ian Kumlien <ian.kumlien@gmail.com>

Will do, thanks!

Tony, should I apply directly to net?
