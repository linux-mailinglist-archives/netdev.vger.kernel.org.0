Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E901464AFF7
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 07:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbiLMGhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 01:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiLMGhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 01:37:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969F6F52
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 22:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670913461; x=1702449461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OqFkktenWvRJT3uBFfhmwjcobPWl6vfKLitPa/v/UoU=;
  b=cXtx9URpfMHvCN3Vtxiw0wumUlEnVXd6+cSGvUTT4LZXafDSkleEdHv6
   5TkYzPC6zgkPCkZmyLpoRBUf3p+lHJJcP3hTb6LnfABJy2hX2XpcI9Dt7
   vMYlbBkJX0wMU55NuyevDXz0tBvlQ+vVnXEpiX5AWcBIwRY5BEy/rsXMZ
   WPyLm8t3wQRNZGKfUom22VMYuDo59+i2XTiAT2TR2xGQv4VYJWjlnIixv
   Q/wPeJgF1L6XSPnsPiWbEC1BrSCt0nMq3cBI4yNkH+fX2z54YLsdoz/7m
   KXJlACW4MYh/9S5NpsOQA5yY+G38DjkAj4AkLSusi3kCd5z+5d4Yc1hYG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="404313611"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="404313611"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 22:37:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="648455189"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="648455189"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 22:37:33 -0800
Date:   Tue, 13 Dec 2022 07:37:26 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, intel-wired-lan@lists.osuosl.org,
        alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com, benjamin.mikailenko@intel.com,
        paul.m.stillwell.jr@intel.com, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v1 00/10] implement devlink reload in ice
Message-ID: <Y5gdpoif/1zBUKDB@localhost.localdomain>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
 <20221212101505.403a4084@kernel.org>
 <f0078f0a-acbc-a9bd-effd-6d04507e71e2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0078f0a-acbc-a9bd-effd-6d04507e71e2@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 10:46:09AM -0800, Jacob Keller wrote:
> 
> 
> On 12/12/2022 10:15 AM, Jakub Kicinski wrote:
> > On Mon, 12 Dec 2022 12:16:35 +0100 Michal Swiatkowski wrote:
> > > This is a part of changes done in patchset [0]. Resource management is
> > > kind of controversial part, so I split it into two patchsets.
> > > 
> > > It is the first one, covering refactor and implement reload API call.
> > > The refactor will unblock some of the patches needed by SIOV or
> > > subfunction.
> > > 
> > > Most of this patchset is about implementing driver reload mechanism.
> > > Part of code from probe and rebuild is used to not duplicate code.
> > > To allow this reuse probe and rebuild path are split into smaller
> > > functions.
> > > 
> > > Patch "ice: split ice_vsi_setup into smaller functions" changes
> > > boolean variable in function call to integer and adds define
> > > for it. Instead of having the function called with true/false now it
> > > can be called with readable defines ICE_VSI_FLAG_INIT or
> > > ICE_VSI_FLAG_NO_INIT. It was suggested by Jacob Keller and probably this
> > > mechanism will be implemented across ice driver in follow up patchset.
> > 
> > Does not apply, unfortunately, which makes it easier for me to answer
> > to the question "should I try to squeeze this into 6.2"..
> > Hopefully we can get some reviews, but the changes seem uncontroversial.
> 
> Yea it seems a bit late to make it into 6.2, as much as that would be nice.
> 
> We can always hold and test it on iwl until net-next re-opens.
> 

It was targeted to Tony dev-queue to allow some tests as Jake said.
Sorry, probably I should point it out in cover letter.

Most of the changes are refactor of probe / remove path, so it will be
good to have some tests from iwl. I (or Tony as pull request) will send
it when the net-next re-opens. Thanks

> Thanks,
> Jake
