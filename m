Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524BE62BD44
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiKPML1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiKPMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:11:11 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB37D12ACD
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668600283; x=1700136283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=szQ+eh5iF6xXmafylI8uPZAw0AOvf0cuNVf12JThADM=;
  b=cwGizXnYo3CJad+LxB1UXaRF4MiCNI+zP4ekdTlN6yF+hL09iR6s/qtO
   5y9nDhfXz5x7zAN1e4bHsCNfY8Bmpt8al3e8qyM/114VHM/giUUAtqBYU
   fOAY54vg72K3RIRhcNL19sW5zFd+WHs7IigmXpwmjW0wS1jCkWqFdB63P
   v3z6unAHqAAgU+KCMqNPlmeSLz/PFXntwv4A0TDfYUNYckFP7e48eNUgd
   JvhlyeMnWhanNAA3oAccEI6FmzmWIaovAJcNR3aQGiUWhNAYRr98VyghV
   7Oyv8ZNYgyUqLBaRNLSX3Hxin3/uLKAEh6RTwnzB78Z7lf3fBCqPoVD7f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="339340027"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="339340027"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 04:04:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="884380899"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="884380899"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 04:04:39 -0800
Date:   Wed, 16 Nov 2022 13:04:36 +0100
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
Message-ID: <Y3TR1At4In5Q98OG@localhost.localdomain>
References: <Y3M79CuAQNLkFV0S@localhost.localdomain>
 <Y3NJnhxetoSIvqYV@unreal>
 <Y3NWMVF2LV/0lqJX@localhost.localdomain>
 <Y3NcnnNtmL+SSLU+@unreal>
 <Y3NnGk7DCo/1KfpD@localhost.localdomain>
 <Y3OCHLiCzOUKLlHa@unreal>
 <Y3OcAJBfzgggVll9@localhost.localdomain>
 <Y3PS9e9MJEZo++z5@unreal>
 <be2954f2-e09c-d2ef-c84a-67b8e6fc3967@intel.com>
 <Y3R9iAMtkk8zGyaC@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3R9iAMtkk8zGyaC@unreal>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 08:04:56AM +0200, Leon Romanovsky wrote:
> On Tue, Nov 15, 2022 at 07:59:06PM -0600, Samudrala, Sridhar wrote:
> > On 11/15/2022 11:57 AM, Leon Romanovsky wrote:
> 
> <...>
> 
> > > > In case of ice driver lspci -vs shows:
> > > > Capabilities: [70] MSI-X: Enable+ Count=1024 Masked
> > > > 
> > > > so all vectors that hw supports (PFs, VFs, misc, etc). Because of that
> > > > total number of MSI-X in the devlink example from cover letter is 1024.
> > > > 
> > > > I see that mellanox shows:
> > > > Capabilities: [9c] MSI-X: Enable+ Count=64 Masked
> > > > 
> > > > I assume that 64 is in this case MSI-X ony for this one PF (it make
> > > > sense).
> > > Yes and PF MSI-X count can be changed through FW configuration tool, as
> > > we need to write new value when the driver is unbound and we need it to
> > > be persistent. Users are expecting to see "stable" number any time they
> > > reboot the server. It is not the case for VFs, as they are explicitly
> > > created after reboots and start "fresh" after every boot.
> > > 
> > > So we set large enough but not too large value as a default for PFs.
> > > If you find sane model of how to change it through kernel, you can count
> > > on our support.
> > 
> > I guess one main difference is that in case of ice, PF driver manager resources
> > for all its associated functions, not the FW. So the MSI-X count reported for PF
> > shows the total vectors(PF netdev, VFs, rdma, SFs). VFs talk to PF over a mailbox
> > to get their MSI-X vector information.
> 
> What is the output of lspci for ice VF when the driver is not bound?
> 
> Thanks
> 

It is the same after creating and after unbonding:
Capabilities: [70] MSI-X: Enable- Count=17 Masked-

17, because 16 for traffic and 1 for mailbox.

Thanks
> > 
> > 
> > 
