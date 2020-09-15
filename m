Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C75926ACD9
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgIOTAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:00:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:24482 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgIORLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 13:11:42 -0400
IronPort-SDR: Xj6F/23TtSmJFMQKxcZWOgwtjrGYZpiYARBbokbasvZNjAcoBUqYYyf4asQ7mjCRftX/LQAd8p
 3/RvYF6rrG4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147058971"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147058971"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 10:11:27 -0700
IronPort-SDR: azfzuffcapFxu0y8d/ncJtgtbLEJGIi1b6VwTAHrdEm+kIhoJpSTkJ4vjpIFP/dBQ+zjJq5IsO
 3o0sPSiaw7QQ==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="482903784"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.118.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 10:11:26 -0700
Date:   Tue, 15 Sep 2020 10:11:24 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
Message-ID: <20200915101124.00004146@intel.com>
In-Reply-To: <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
        <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed wrote:
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Thanks! In all fairness, Jakub reviewed this in v1 too but I made enough
changes in v2 that I felt I had to drop the previous review ACKs.

> Hi Jesse, 
> What was the criteria to select which drivers to enable in your .config
> ?

As Jakub said, I'm using allmodconfig on x86_64, but just yesterday
discovered there was much more to fix because I ran the kernel-doc
script directly on the source (those other things come from different
ARCH= builds which limit allmodconfig)
 
> I think we need some automation here and have a well known .config that
> enables as many drivers as we can for static + compilation testing,
> otherwise we are going to need to repeat this patch every 2-3 months.

Totally agree! Jakub already has some cobbled together and is regularly
running W=1 C=1 builds on all new patches. I found I could cross compile
different ARCH targets to get (some of) the other warnings, or better
yet just run the scripts/kernel-doc script directly in automation.
 
> I know Jakub and Dave do some compilation testing before merging but i
> don't know how much driver coverage they have and if they use a
> specific .config or they just manually create one on demand..
> 
> bottom line, we need a bot after this series is applied.
> All we need is to daily apply all ongoing patches to some testing
> branch and let 0-DAY kernel test [1] run on it with whatever make
> command we define and with all drivers enabled.

Yes, that's the end goal and I think this moves us closer to that. A
little more work remains before we go and turn all warnings on - as
Andrew suggested in another reply. (it's also sometimes a losing game
fighting against many compiler versions, etc).  However, the zero-day
bot reporting more results from W=1 compiles would *really* help (I
looked at , but am having some troubles verifying that)

> [1] https://lists.01.org/pipermail/kbuild-all 
> 
> > ---
> > 
> > Q: Maybe I can fix the remaining warnings in a followup patch? If
> > I try to put it on this series it will make it much larger
> > (double).
