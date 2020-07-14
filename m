Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5820821FD0B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgGNTNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgGNTNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:13:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AAE922461;
        Tue, 14 Jul 2020 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753999;
        bh=FU1zyShPdiqPGFo5zwac+vHs4d5Y28ja+xiY5htjO8M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yykzRCMvWZTaRyOPOi06X7BumoSHem4c/fPCCfced53ufJsbrx1WCrZWhWJ8a9355
         9JhSLXS9xsQTzfUhlO5O82erSzNDcocUqlWYXifaPU2CP1QzKHN67nBBUHKC8BiIHk
         g4bzfH9yeq0re+q5JxCXpSAPXQtXxVM43OiItZiM=
Date:   Tue, 14 Jul 2020 12:13:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Westergreen, Dalon" <dalon.westergreen@intel.com>
Cc:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ooi, Joyce" <joyce.ooi@intel.com>,
        "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Message-ID: <20200714121317.732331aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9a8ba2616f72fb44cdc3b45fabfb4d7bdf961fd0.camel@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
        <20200708072401.169150-10-joyce.ooi@intel.com>
        <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
        <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
        <20200714092903.38581b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9a8ba2616f72fb44cdc3b45fabfb4d7bdf961fd0.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 18:51:15 +0000 Westergreen, Dalon wrote:
> > I've seen vendors abuse fields of ethtool --coalesce to configure
> > similar settings. tx-usecs-irq and rx-usecs-irq, I think. Since this
> > part of ethtool API has been ported to netlink, could we perhaps add 
> > a new field to ethtool --coalesce?  
> 
> I don't think this is necessary, i think just having a module parameter
> meets our needs.  I don't see a need for the value to change on a per
> interface basis.  This was primarily used during testing / bringup.

It's hard to tell which knobs users will find worth turning therefore
the testing / bringup justification unfortunately has little bearing on
our upstream interface choices.

We try hard to avoid module parameters in networking drivers, so if you
want this tunable upstream a proper user interface will be required.
