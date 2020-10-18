Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE73291FAB
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 22:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgJRUEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 16:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgJRUEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 16:04:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A314122269;
        Sun, 18 Oct 2020 20:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603051452;
        bh=CcbzXlUvlztgfVLb1xA8aP21hB1V3F4mA1ukHZN9LcY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aICfQcGS6NnAfAH88MROoXXVGCRDpXTSOcGu1JJrNly2YiL+vZEIKDZ4OdEAB9GNf
         4KIGozY9BWvU0XgUMuC7aP5GFOFhsLpwQqg4WBXK/lUndKKAbH48j+UeObAwoUhwJJ
         KsyPQJREF9pPsL/vB4sSQpl9dvKoYL0xkvTjIF3M=
Date:   Sun, 18 Oct 2020 13:04:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Ian Kumlien <ian.kumlien@gmail.com>, anthony.l.nguyen@intel.com,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team@fb.com, Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net] ixgbe: fix probing of multi-port devices with one
 MDIO
Message-ID: <20201018130410.6bc9672e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016174807.000036d6@intel.com>
References: <20201016232006.3352947-1-kuba@kernel.org>
        <CAA85sZsm0ZNGoU59Lhn+qUHDAUcNjLoJYdqUf45k_nSkANMDog@mail.gmail.com>
        <20201016170126.21b1cad5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201016174807.000036d6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 17:48:07 -0700 Jesse Brandeburg wrote:
> Jakub Kicinski wrote:
> 
> > On Sat, 17 Oct 2020 01:50:59 +0200 Ian Kumlien wrote:  
> > > On Sat, Oct 17, 2020 at 1:20 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > Ian reports that after upgrade from v5.8.14 to v5.9 only one
> > > > of his 4 ixgbe netdevs appear in the system.
> > > >
> > > > Quoting the comment on ixgbe_x550em_a_has_mii():
> > > >  * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
> > > >  * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
> > > >  * but we only want to register one MDIO bus.
> > > >
> > > > This matches the symptoms, since the return value from
> > > > ixgbe_mii_bus_init() is no longer ignored we need to handle
> > > > the higher ports of x550em without an error.    
> > > 
> > > Nice, that fixes it!
> > > 
> > > You can add a:
> > > Tested-by: Ian Kumlien <ian.kumlien@gmail.com>  
> > 
> > Will do, thanks!
> > 
> > Tony, should I apply directly to net?  
> 
> Thank you Kuba!
> 
> Seems like a pretty straight forward bug-fix. I recommend
> you apply it directly.

Done.

> Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thank you!
