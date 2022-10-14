Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5D5FEC36
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJNKBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiJNKBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:01:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2D69F741;
        Fri, 14 Oct 2022 03:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665741664; x=1697277664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P/LSpeZ4rqXERhvqeByUhgiXrNe//GKUtdTAL6L6Qi0=;
  b=JJA6w3Du8u/X1imOMeaVUvpNg9zdN77YLlHslLTm7HmC0SjvRjV0bJC/
   pOUk/lUzYkibWn6+YM017dgcElCh61Gda+DvzwCgqDw4vt6dD+sWgCh0x
   Gs9uPSPxoVepvKEmRmaXf7CAEd8Z9zobVQOdq/R6KxCzZVUG9uLX0NzH7
   Ksm615gtIzaQWoPaVY9kbfjg1+6cfE74q4JIo7lzIbzBpHVoqaLNgtlor
   3cJkoU9YZviR63YB11sNPbsjfINM3LUTE8Gd1Isq++lpMFD4JYMdbj6Al
   IS/RKXavduPQerKAIw7WWd1VTezu4uX6YFwQwgR91eVO6hruIu6kKckcB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="306989649"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="306989649"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 03:01:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="732246731"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="732246731"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2022 03:00:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ojHUv-006sKo-2K;
        Fri, 14 Oct 2022 13:00:57 +0300
Date:   Fri, 14 Oct 2022 13:00:57 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     guoren@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <Y0kzWQZSdCR93s/y@smile.fi.intel.com>
References: <20221014030459.3272206-1-guoren@kernel.org>
 <20221014030459.3272206-2-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014030459.3272206-2-guoren@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 11:04:58PM -0400, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> Don't pass nr_bits as arg1, cpu_max_bits_warn would cause warning
> now 854701ba4c39 ("net: fix cpu_max_bits_warn() usage in
> netif_attrmask_next{,_and}").
> 
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
> Modules linked in:

Submitting Patches documentation suggests to cut this to only what makes sense
for the report.

-- 
With Best Regards,
Andy Shevchenko


