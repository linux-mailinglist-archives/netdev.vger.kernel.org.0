Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4716E6DED2C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDLIDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDLIDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:03:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8EA2100
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681286626; x=1712822626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9giIUV4HKnheHcPP36MHmIq3PW1nyIBJHDdbGeHnQQQ=;
  b=P5xDqt2sg/ra8gRbYeaBODig1Ifhjf3UpzULKaH92ZTYOXTo2EMMK1ej
   vmHP4M7PzyGyWg2fxWr68aIfhhGtOhs05J/SV0VNV7sZnLJkXSpFC2XQi
   nYwC4owCOhDV4Nl6oVVD8HIINtoqcYvmmdy1j8GWP8w3VWrvkhBgypE/3
   0oelIBQaCs8UYK5VYrB80vtSHWFdfh9X4vUKYzXk9amz43C4S3yP+IWkl
   E0b7FxzsTO9g0VKle8dY0CzB8s4Bkpt859wQ0VPnm2jmEl4XmfQ4UiVdv
   i8QVaOa3l/dBFZCfgp5muWOnRV6oChP5ravPVwhoLgltGQ+Csrx3rtLiU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408971303"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="408971303"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 01:03:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778218300"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="778218300"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 01:03:39 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id C599D14B; Wed, 12 Apr 2023 11:03:43 +0300 (EEST)
Date:   Wed, 12 Apr 2023 11:03:43 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: thunderbolt: Fix sparse warnings in
 tbnet_xmit_csum_and_map()
Message-ID: <20230412080343.GF33314@black.fi.intel.com>
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
 <20230411091049.12998-3-mika.westerberg@linux.intel.com>
 <ZDVJeJd3mM0kBdE4@corigine.com>
 <ZDVLXQ/8O7YxTHRv@smile.fi.intel.com>
 <ZDVUpvzP8V+xzqKr@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDVUpvzP8V+xzqKr@corigine.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:37:58PM +0200, Simon Horman wrote:
> On Tue, Apr 11, 2023 at 02:58:21PM +0300, Andy Shevchenko wrote:
> > On Tue, Apr 11, 2023 at 01:50:16PM +0200, Simon Horman wrote:
> > > On Tue, Apr 11, 2023 at 12:10:48PM +0300, Mika Westerberg wrote:
> > > > Fixes the following warning when the driver is built with sparse checks
> > > > enabled:
> > > > 
> > > > main.c:993:23: warning: incorrect type in initializer (different base types)
> > > > main.c:993:23:    expected restricted __wsum [usertype] wsum
> > > > main.c:993:23:    got restricted __be32 [usertype]
> > > > 
> > > > No functional changes intended.
> > > 
> > > This seems nice.
> > > 
> > > After you posted v1 I was wondering if, as a follow-up, it would be worth
> > > creating a helper for this, say cpu_to_wsum(), as I think this pattern
> > > occurs a few times. I'm thinking of a trivial wrapper around cpu_to_be32().
> > 
> > But it looks like it makes sense to have a standalone series for that matter.
> > I.o.w. it doesn't belong to Thunderbolt (only).
> 
> Yes, agreed.
> 
> I was more asking if it is a good idea than for any changes to this patchset.

I think it is a good idea :) I'll add this to my todo list and will do
at some point if nobody else have already done it.
