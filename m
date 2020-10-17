Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C127290F9F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436676AbgJQFv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:51:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:23251 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436625AbgJQFv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 01:51:28 -0400
IronPort-SDR: N3CzGG33LLLsrbj9Hb2yvmvkshKiLPMBUFvNAtl0cMtzedTKxdZZAvbCO6sGSFTj01qJLOgPmO
 2x7Jh8mb0QjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="163249688"
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="163249688"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:48:08 -0700
IronPort-SDR: qakLwofJDkzDvRzd12cDraidC26PGXAW5xTWyfqRJEIai9rk0a+2/LQ6zVvrl1PA02X2jmOjmC
 8pJlH3mWQTFA==
X-IronPort-AV: E=Sophos;i="5.77,384,1596524400"; 
   d="scan'208";a="331327207"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 17:48:07 -0700
Date:   Fri, 16 Oct 2020 17:48:07 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ian Kumlien <ian.kumlien@gmail.com>, anthony.l.nguyen@intel.com,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team@fb.com, Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net] ixgbe: fix probing of multi-port devices with one
 MDIO
Message-ID: <20201016174807.000036d6@intel.com>
In-Reply-To: <20201016170126.21b1cad5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201016232006.3352947-1-kuba@kernel.org>
        <CAA85sZsm0ZNGoU59Lhn+qUHDAUcNjLoJYdqUf45k_nSkANMDog@mail.gmail.com>
        <20201016170126.21b1cad5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> On Sat, 17 Oct 2020 01:50:59 +0200 Ian Kumlien wrote:
> > On Sat, Oct 17, 2020 at 1:20 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Ian reports that after upgrade from v5.8.14 to v5.9 only one
> > > of his 4 ixgbe netdevs appear in the system.
> > >
> > > Quoting the comment on ixgbe_x550em_a_has_mii():
> > >  * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
> > >  * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
> > >  * but we only want to register one MDIO bus.
> > >
> > > This matches the symptoms, since the return value from
> > > ixgbe_mii_bus_init() is no longer ignored we need to handle
> > > the higher ports of x550em without an error.  
> > 
> > Nice, that fixes it!
> > 
> > You can add a:
> > Tested-by: Ian Kumlien <ian.kumlien@gmail.com>
> 
> Will do, thanks!
> 
> Tony, should I apply directly to net?

Thank you Kuba!

Seems like a pretty straight forward bug-fix. I recommend
you apply it directly.

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
