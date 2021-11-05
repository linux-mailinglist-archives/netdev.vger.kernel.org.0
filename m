Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ABA446A9C
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhKEVcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhKEVcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 17:32:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B3760F9E;
        Fri,  5 Nov 2021 21:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636147814;
        bh=oootQZeYYYplOWWYhY3tq5Fb/rwytVkcvr0prXYBCT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G6vOWwVPGj5lzL5B77HFTUMsJFDBr5Yjfl+852/61PfiyBy4nL1K+9td4VaTqg88c
         9dk4AiU3Hsc9UDIrVT85ZrkvoTDyHwGSfEyHk01wXaMiga+vgmDBqurCmq3TLOYqRn
         lFzW5TeCu3V6q2J2dbF6Sbk9ADf+xOVtlMe1uqlMwqPDKBW2y9BxKcF9iE9RogYN+c
         3bo1bCFUHkjw/6ioyTK8eksPSMASL62UVKFA01AFamByB2OLCYrewyklGLTm85FWh+
         fmZJKTt4n2tk5ap8TuEyPB/hEFH9y3FZf8kZJOFIu2D3q/nQe85/dwA4jta6bRDpO5
         WQQzLqmTxjnvA==
Date:   Fri, 5 Nov 2021 14:30:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 6/6] docs: net: Add description of SyncE
 interfaces
Message-ID: <20211105143013.2cded2f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MW5PR11MB5812FA6647FF189D368C75A5EA8E9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211104081231.1982753-1-maciej.machnikowski@intel.com>
        <20211104081231.1982753-7-maciej.machnikowski@intel.com>
        <20211104110855.3ead1642@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MW5PR11MB5812FA6647FF189D368C75A5EA8E9@MW5PR11MB5812.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Nov 2021 11:51:48 +0000 Machnikowski, Maciej wrote:
> > I'm still struggling to understand your reasoning around not making
> > EEC its own object. "We can do this later" seems like trading
> > relatively little effort now for extra work for driver and application
> > developers for ever.  
> 
> That's not the case. We need EEC and the other subsystem we wanted
> to make is the DPLL subsystem. While EEC can be a DPLL - it doesn't have
> to, and it's also the other way round - the DPLL can have numerous different
> usages.

We wanted to create a DPLL object to the extent that as a SW guy 
I don't understand the difference between that and an EEC. Whatever
category of *PLL etc. objects EEC is, that's what we want to model.

> When we add the DPLL subsystem support the future work will be as simple 
> as routing the EEC state read function to the DPLL subsystem. But if someone
> decides to use a different HW implementation he will still be able to
> implement his own version of API to handle it without a bigger DPLL block

All we want is something that's not a port to hang whatever attributes
exist in RTM_GETEECSTATE.
