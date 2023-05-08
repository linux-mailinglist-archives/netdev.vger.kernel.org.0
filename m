Return-Path: <netdev+bounces-842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F386FAD0A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 984BC1C208F4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9FA168DF;
	Mon,  8 May 2023 11:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA35171A7
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:30:22 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EAC3E749
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683545420; x=1715081420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kOFjoLDKLTPuBJQsFFuC9fwSNix/HAfdF2hTO22JBec=;
  b=HZD3bhBlZkXJLYTd8CrGWQWLsDrT10vL8fAAvK5RzbfFvqYGQcolb6cs
   HH3Sqbp9gZiJadqrMsckLeOrC+FCTdKo9kiNYaDUJUM3dvBDP70XZWB3M
   qEuOtGxQkSitJcxXWyAm5wLcMnfbW5qKBj0vSiqwQvzOKuYhwyxzCIDQh
   yGeWyKyN9V5zl6FpJAvEssOBDxv24QtYEP/0POr9RXSjgbnhMGj8+OAuB
   IbMho7eh1bHpdgZRnnd4Kdcvv1l+DcxuT3m0eqBqeRCcQHMaoKs4fzco4
   ZMFxcTgMw/kiOf8DBq8GRXoN5L8G5dOeFAeoAwHdXHgN+LxvRIDnjTkKY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="329978424"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="329978424"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 04:30:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="1028380205"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="1028380205"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 04:30:14 -0700
Date: Mon, 8 May 2023 13:30:04 +0200
From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org,
	Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>,
	George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net] ice: block LAN in case of VF to VF offload
Message-ID: <ZFjXiYdUR5hDwjEi@localhost.localdomain>
References: <20230503153935.2372898-1-anthony.l.nguyen@intel.com>
 <20230504074249.GQ525452@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504074249.GQ525452@unreal>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 10:42:49AM +0300, Leon Romanovsky wrote:
> On Wed, May 03, 2023 at 08:39:35AM -0700, Tony Nguyen wrote:
> > From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > 
> > VF to VF traffic shouldn't go outside. To enforce it, set only the loopback
> > enable bit in case of all ingress type rules added via the tc tool.
> > 
> > Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
> > Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> > index 76f29a5bf8d7..d1a31f236d26 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> > @@ -693,17 +693,18 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
> >  	 * results into order of switch rule evaluation.
> >  	 */
> >  	rule_info.priority = 7;
> > +	rule_info.flags_info.act_valid = true;
> 
> Do you still have path where rule_info.flags_info.act_valid = false?
> 

Good point, I will check if it is still needed.

Thanks

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

