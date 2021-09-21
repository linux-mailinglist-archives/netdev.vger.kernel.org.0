Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A943B413C24
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhIUVQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhIUVQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 17:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5E860F70;
        Tue, 21 Sep 2021 21:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632258887;
        bh=JvHHxunR9C6HL904dqCGT0x/I+zMsf/fDJibZ/XVyeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GtxFzJ8LQwtKchSk/UKGo7VGd3z6NfQhoVlp2+lxjnaxOkPXCltbaEvjse3GuYXtd
         9J+nfbVXyuwkvyB3DEQktFUC3BpWrUI8lEOioxqK6N4v+qSrQe2PT9VHR6caCOR9bP
         7xwnqKSATywN48kRm6RAvwgo4CmXXBtDyt/9jSFa0JLAjBFzn26eLcEmCicuaXS2n9
         Nf7S5ViRg1Ez/GEvcF4OGZ7IJ07C6M8scRgCYErvqELp97ceHn8j8z8iBaPQPu0wEK
         z/Bfq8bZqyf/ICuOL35o4xzYT2S1XWkF1p0cCrRtTepEFwl8cHER1oHsvNSe+bxfUP
         EE2kS7ADsTRig==
Date:   Tue, 21 Sep 2021 14:14:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210921141445.24ae714e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YUny/edqnbdTFnBS@shredder>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <YUnbCzBOPP9hWQ5c@shredder>
        <PH0PR11MB4951E98FCEC0F1EA230BA1DAEAA19@PH0PR11MB4951.namprd11.prod.outlook.com>
        <YUny/edqnbdTFnBS@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 17:58:05 +0300 Ido Schimmel wrote:
> > > The only source type above is 'port' with the ability to set the
> > > relevant port, but more can be added. Obviously, 'devlink clock show'
> > > will give you the current source in addition to other information such
> > > as frequency difference with respect to the input frequency.  
> > 
> > We considered devlink interface for configuring the clock/DPLL, but a
> > new concept was born at the list to add a DPLL subsystem that will
> > cover more use cases, like a TimeCard.  
> 
> The reason I suggested devlink is that it is suited for device-wide
> configuration and it is already used by both MAC drivers and the
> TimeCard driver. If we have a good reason to create a new generic
> netlink family for this stuff, then OK.

For NICs mapping between devlink instances and HW is not clear.
Most register devlink per PCI dev which usually maps to a Eth port.
So if we have one DPLL on a 2 port NIC mapping will get icky, no?

Is the motivation to save the boilerplate code associated with new
genetlink family or something more? 
