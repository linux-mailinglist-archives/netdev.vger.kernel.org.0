Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAC62D91C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbiKQLMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239901AbiKQLLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:11:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DCC3FB9F
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668683438; x=1700219438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Oicqt3xt9r5vV+mIlVk/9Z5wT9dzFGt7KwKw3hvXFME=;
  b=YGfHb7DqMMhanNNveNyfNhdwrvX3/Qo25k4cslYJ5W6JxcMVCAGandKx
   tgEw4Bt+4TW4lHvTkiPHPTMqvL2XkCIECc1M98NozdgiVFZ3/OPelBVdw
   XmMqM8a09Be10a5BRVOfUd6RVM8lwI0utp1fQAyxdJrWlKq9PepNwjtGL
   S9revI5rxp19a2hL4f8jSZSL4AOEgxay1aIIcK7xfmzlSKmeEFxB6GREV
   VgPpWIDjRcfMqFCw6UXVsLFU6Nug9XBFayaxjQfGDX/DFtAec9x00ffUm
   Iw4LEd4T2pUUDOL28U20NQzqLVHLF6H6F5qwEYMikYR8yB/+3y6dLQWEp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="313971991"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="313971991"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 03:10:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="728785804"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="728785804"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 03:10:30 -0800
Date:   Thu, 17 Nov 2022 12:10:21 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 00/13] resource management using devlink reload
Message-ID: <Y3YWkT/lMmYU5T+3@localhost.localdomain>
References: <Y3NWMVF2LV/0lqJX@localhost.localdomain>
 <Y3NcnnNtmL+SSLU+@unreal>
 <Y3NnGk7DCo/1KfpD@localhost.localdomain>
 <Y3OCHLiCzOUKLlHa@unreal>
 <Y3OcAJBfzgggVll9@localhost.localdomain>
 <Y3PS9e9MJEZo++z5@unreal>
 <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
 <Y3R9iAMtkk8zGyaC@unreal>
 <Y3TR1At4In5Q98OG@localhost.localdomain>
 <Y3UlD499Yxj77vh3@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3UlD499Yxj77vh3@unreal>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 07:59:43PM +0200, Leon Romanovsky wrote:
> On Wed, Nov 16, 2022 at 01:04:36PM +0100, Michal Swiatkowski wrote:
> > On Wed, Nov 16, 2022 at 08:04:56AM +0200, Leon Romanovsky wrote:
> > > On Tue, Nov 15, 2022 at 07:59:06PM -0600, Samudrala, Sridhar wrote:
> > > > On 11/15/2022 11:57 AM, Leon Romanovsky wrote:
> > > 
> > > <...>
> > > 
> > > > > > In case of ice driver lspci -vs shows:
> > > > > > Capabilities: [70] MSI-X: Enable+ Count=1024 Masked
> > > > > > 
> > > > > > so all vectors that hw supports (PFs, VFs, misc, etc). Because of that
> > > > > > total number of MSI-X in the devlink example from cover letter is 1024.
> > > > > > 
> > > > > > I see that mellanox shows:
> > > > > > Capabilities: [9c] MSI-X: Enable+ Count=64 Masked
> > > > > > 
> > > > > > I assume that 64 is in this case MSI-X ony for this one PF (it make
> > > > > > sense).
> > > > > Yes and PF MSI-X count can be changed through FW configuration tool, as
> > > > > we need to write new value when the driver is unbound and we need it to
> > > > > be persistent. Users are expecting to see "stable" number any time they
> > > > > reboot the server. It is not the case for VFs, as they are explicitly
> > > > > created after reboots and start "fresh" after every boot.
> > > > > 
> > > > > So we set large enough but not too large value as a default for PFs.
> > > > > If you find sane model of how to change it through kernel, you can count
> > > > > on our support.
> > > > 
> > > > I guess one main difference is that in case of ice, PF driver manager resources
> > > > for all its associated functions, not the FW. So the MSI-X count reported for PF
> > > > shows the total vectors(PF netdev, VFs, rdma, SFs). VFs talk to PF over a mailbox
> > > > to get their MSI-X vector information.
> > > 
> > > What is the output of lspci for ice VF when the driver is not bound?
> > > 
> > > Thanks
> > > 
> > 
> > It is the same after creating and after unbonding:
> > Capabilities: [70] MSI-X: Enable- Count=17 Masked-
> > 
> > 17, because 16 for traffic and 1 for mailbox.
> 
> Interesting, I think that your PF violates PCI spec as it always
> uses word "function" and not "device" while talks about MSI-X related
> registers.
> 
> Thanks
> 

I made mistake in one comment. 1024 isn't MSI-X amount for device. On
ice we have 2048 for the whole device. On two ports card each PF have
1024 MSI-X. Our control register mapping to the internal space looks
like that (Assuming two port card; one VF with 5 MSI-X created):
INT[PF0].FIRST	0
		1
		2
		
		.
		.
		.

		1019	INT[VF0].FIRST	__
		1020			  | interrupts used
		1021			  | by VF on PF0
		1022			  |
INT[PF0].LAST	1023	INT[VF0].LAST	__|
INT[PF1].FIRST	1024
		1025
		1026

		.
		.
		.
		
INT[PF1].LAST	2047

MSI-X entry table size for PF0 is 1024, but entry table for VF is a part
of PF0 physical space.

Do You mean that "sharing" the entry between PF and VF is a violation of
PCI spec? Sum of MSI-X count on all function within device shouldn't be
grater than 2048? It is hard to find sth about this in spec. I only read
that: "MSI-X supports a maximum table size of 2048 entries". I will
continue searching for information about that.

I don't think that from driver perspective we can change the table size
located in message control register.

I assume in mlnx the tool that You mentioned can modify this table size?

Thanks

> > 
> > Thanks
> > > > 
> > > > 
> > > > 
