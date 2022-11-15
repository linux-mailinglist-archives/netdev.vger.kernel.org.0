Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FE162920F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 07:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbiKOG4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 01:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbiKOG4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 01:56:53 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFAE1FCE2
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 22:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668495412; x=1700031412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VUjNQoT1dcrn7tDvWBx0o2oRpkIBdIS+5GXB/nGQbC0=;
  b=C7z6EB+1J6MNU5QQ628aTPf22b6Oc9Xmrsh4JBLUMTFcRBnqPlDa+HAL
   9QWrCuZ4ggfKbXlLgXWXjLazc/AuHcoktS5rwUjRgqUReyyXm74kYzEeC
   Z9NY4MmZCKVzPJMSwKWNh1P3f26RzYUVPJphUd5esumI4LBbDaWeamAUJ
   gDIQ/zI6qJeTXOWg0PtGJFHVzwGAM8P1VnaxiZYL5HgxY/CExLV/swMa8
   ouKcBcvrcQi8oq8wuftthyuH9jvRz2SmCiy8IA40ncevHck0jJ1XVNr6S
   URH/wz8Krb9OjmKu7n0WenKfYgd46gmd9UkwC+B1mRfTPDtCaB0anVcu5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310888326"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="310888326"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:56:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616646014"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="616646014"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 22:56:47 -0800
Date:   Tue, 15 Nov 2022 07:56:43 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next 13/13] devlink, ice: add MSIX vectors as devlink
 resource
Message-ID: <Y3M4K5x/WP10apab@localhost.localdomain>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
 <20221114125755.13659-14-michal.swiatkowski@linux.intel.com>
 <Y3Jepn7bxkCFP+cg@nanopsycho>
 <Y3Jm36rYH4J1jSoc@praczyns-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Jm36rYH4J1jSoc@praczyns-desk3>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 05:03:43PM +0100, Piotr Raczynski wrote:
> On Mon, Nov 14, 2022 at 04:28:38PM +0100, Jiri Pirko wrote:
> > Mon, Nov 14, 2022 at 01:57:55PM CET, michal.swiatkowski@linux.intel.com wrote:
> > >From: Michal Kubiak <michal.kubiak@intel.com>
> > >
> > >Implement devlink resource to control how many MSI-X vectors are
> > >used for eth, VF and RDMA. Show misc MSI-X as read only.
> > >
> > >This is first approach to control the mix of resources managed
> > >by ice driver. This commit registers number of available MSI-X
> > >as devlink resource and also add specific resources for eth, vf and RDMA.
> > >
> > >Also, make those resources generic.
> > >
> > >$ devlink resource show pci/0000:31:00.0
> > >  name msix size 1024 occ 172 unit entry dpipe_tables none
> > 
> > 
> > So, 1024 is the total vector count available in your hw?
> > 
> 
> For this particular device and physical function, yes.
> 
> 
> > 
> > >    resources:
> > >      name msix_misc size 4 unit entry dpipe_tables none
> > 
> > What's misc? Why you don't show occupancy for it? Yet, it seems to be
> > accounted in the total (172)
> > 
> > Also, drop the "msix_" prefix from all, you already have parent called
> > "msix".
> 
> misc interrupts are for miscellaneous purposes like communication with
> Firmware or other control plane interrupts (if any).
> 

I will drop msix_ prefix. I didn't show the occupancy because it is the
same all the time and user can't change it. But You are righ it is
accounted, so I will add occupancy also here in next version.

> > 
> > 
> > >      name msix_eth size 92 occ 92 unit entry size_min 1 size_max
> > 
> > Why "size_min is not 0 here?
> 
> Thanks, actually 0 would mean disable the eth, default, netdev at all.
> It could be done, however not implemented in this patchset. But for
> cases when the default port is not needed at all, it seems like a good
> idea.
>

I will try to do it in next version, thanks.

> > 
> > 
> > >	128 size_gran 1 dpipe_tables none
> > >      name msix_vf size 128 occ 0 unit entry size_min 0 size_max
> > >	1020 size_gran 1 dpipe_tables none
> > >      name msix_rdma size 76 occ 76 unit entry size_min 0 size_max
> > 
> > Okay, this means that for eth and rdma, the vectors are fully used, no
> > VF is instanciated?
> 
> Yes, in this driver implementation, both eth and rdma will most probably
> be always fully utilized, but the moment you change the size and execute
> `devlink reload` then they will reconfigure with new values.
> 
> The VF allocation here is the maximum number of interrupt vectors that
> can be assigned to actually created VFs. If so, then occ shows how many
> are actually utilized by the VFs.
> 
> > 
> > 
> > 
> > >	132 size_gran 1 dpipe_tables none
> > >
> > >example commands:
> > >$ devlink resource set pci/0000:31:00.0 path msix/msix_eth size 16
> > >$ devlink resource set pci/0000:31:00.0 path msix/msix_vf size 512
> > >$ devlink dev reload pci/0000:31:00.0
