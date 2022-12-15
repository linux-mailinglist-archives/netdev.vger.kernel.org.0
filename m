Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF5664D693
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 07:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiLOGm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 01:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLOGm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 01:42:57 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6992A8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 22:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671086575; x=1702622575;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pm6uNrQjsbjkEg80UIdNsEcOdC8rbC3az6NObzzXDQY=;
  b=U4HHme8WDo+B2Dbpo3dVmIu0Qu+yJrhmxfDcQWtMvgCyDA0winGRAsjA
   xaXpJjzYsDb+hyhrahWRHdIGlBMZNbsuPawadCbstEvHub8yTEimY8AOt
   v7M/wkPzHbKUXxoAAwPdJyjQWLZA5ya8LxslNC9jAYW9zlC5wnfT4j6CO
   nNHWDJ5U4aSjqoF1N3gcFlswFKnRy/curlTOQS6SyZNmmRqHlzWWBi0km
   AfRMRS21m5HNzxGSYf14V+1mu5TD7lZ7KJwyE1Thdvw2R1O1xIHyECnBb
   7bAYv7oo2A7yprNLR2t94qSpnn+afaWE7fz93G96OWcecSgYlOFDJ1HNX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316236058"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="316236058"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 22:42:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="712776321"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="712776321"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 22:42:52 -0800
Date:   Thu, 15 Dec 2022 07:42:43 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        intel-wired-lan@lists.osuosl.org, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com,
        benjamin.mikailenko@intel.com, paul.m.stillwell.jr@intel.com,
        netdev@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next v1 00/10] implement devlink reload in ice
Message-ID: <Y5rB4+WfR7BrSIaS@localhost.localdomain>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
 <20221212101505.403a4084@kernel.org>
 <f0078f0a-acbc-a9bd-effd-6d04507e71e2@intel.com>
 <Y5gdpoif/1zBUKDB@localhost.localdomain>
 <20221213171834.682641c3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213171834.682641c3@kernel.org>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 05:18:34PM -0800, Jakub Kicinski wrote:
> On Tue, 13 Dec 2022 07:37:26 +0100 Michal Swiatkowski wrote:
> > It was targeted to Tony dev-queue to allow some tests as Jake said.
> > Sorry, probably I should point it out in cover letter.
> 
> You can tag as intel-next, iwl-next or some such, to avoid confusion.

Thanks, I will use it next time.
