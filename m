Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6524E6274
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349810AbiCXL1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbiCXL1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:27:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5924A66EC;
        Thu, 24 Mar 2022 04:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648121162; x=1679657162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TKRStjgNvvvrYB1tQ/Y0SqCKUerOWglVcd2B3O7GaC4=;
  b=JO28bFqU5xlE1DdLMHKs+6zrmzYc3211QFlWNeq8TLqSsfIe4gjAKCRw
   smFcFsQjevRvtRyW8YqF9zMnVOQE2YLb47L1t7knRQ0FlYCrKYds5NrEw
   rKv46Bpn4Lkp37MKw2HS3RQyPq6K0JqazAbH4+muOeU7Kbw9nhQDNWToo
   f8zNgOvn/Qyh1eWTy2URC+WUJX8aoC18FFgd0JzkX1UZzjItmSbSa7t7/
   Dp4eMkguH16PTmMRw2dPc8WMqrHzsQGsRM9i2527sGGZTQlqopltdNrCx
   inIRd0VSi4rz9sHrMQp2iMgm9sr2pYlkH7QQNyGh22QU8dgO7vG614z1r
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258304846"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="258304846"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 04:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="561333561"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 24 Mar 2022 04:25:59 -0700
Date:   Thu, 24 Mar 2022 12:25:58 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Ivan Vecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "poros@redhat.com" <poros@redhat.com>,
        "mschmidt@redhat.com" <mschmidt@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix MAC address setting
Message-ID: <YjxVRqTppQeYKb1h@boxer>
References: <20220323135829.4015645-1-ivecera@redhat.com>
 <CO1PR11MB508946CC906E8B851D69D31AD6189@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB508946CC906E8B851D69D31AD6189@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 05:28:02PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Ivan Vecera <ivecera@redhat.com>
> > Sent: Wednesday, March 23, 2022 6:58 AM
> > To: netdev@vger.kernel.org
> > Cc: poros@redhat.com; mschmidt@redhat.com; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; moderated
> > list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> > kernel@vger.kernel.org>
> > Subject: [PATCH net] ice: Fix MAC address setting
> > 
> > Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
> > the usage of 'status' and 'err' variables into single one in
> > function ice_set_mac_address(). Unfortunately this causes
> > a regression when call of ice_fltr_add_mac() returns -EEXIST because
> > this return value does not indicate an error in this case but
> > value of 'err' value remains to be -EEXIST till the end of

s/'err' value/'err'

> > the function and is returned to caller.
> > 
> > Prior this commit this does not happen because return value of

s/this/mentioned ?

> > ice_fltr_add_mac() was stored to 'status' variable first and
> > if it was -EEXIST then 'err' remains to be zero.
> > 
> > The patch fixes the problem by reset 'err' to zero when
> > ice_fltr_add_mac() returns -EEXIST.

Again, i'd recommend imperative mood. Besides, good catch!

> > 
> > Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > b/drivers/net/ethernet/intel/ice/ice_main.c
> > index 168a41ea37b8..420558d1cd21 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -5474,14 +5474,15 @@ static int ice_set_mac_address(struct net_device
> > *netdev, void *pi)
> > 
> >  	/* Add filter for new MAC. If filter exists, return success */
> >  	err = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
> > -	if (err == -EEXIST)
> > +	if (err == -EEXIST) {
> >  		/* Although this MAC filter is already present in hardware it's
> >  		 * possible in some cases (e.g. bonding) that dev_addr was
> >  		 * modified outside of the driver and needs to be restored back
> >  		 * to this value.
> >  		 */
> >  		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
> > -	else if (err)
> > +		err = 0;
> > +	} else if (err)
> >  		/* error if the new filter addition failed */
> >  		err = -EADDRNOTAVAIL;
> > 
> 
> Style wise, don't we typically use {} for all branches if its needed on one?

+1, please add braces around second branch as well.

> 
> I'm ok takin this fix as-is now and doing the {} fix up afterwards if we want to avoid delay.
> 
> Thanks,
> Jake
> 
> > --
> > 2.34.1
> 
