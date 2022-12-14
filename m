Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027F264CD7A
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbiLNP40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238855AbiLNP4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:56:00 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A232314C;
        Wed, 14 Dec 2022 07:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671033239; x=1702569239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=12BnbcHagZMkwl9OeOA4D0nsPFyieVD2ck3mCiVJ72w=;
  b=h6PL/+6dLs5+Gpxr8c4tc3r5F+WFquxrdMSSjYsVOxpbOqewub25mPz4
   ThkkUdN9OXqFnDVHZWoHRdQNEdhhsF9bnReRYZWQbMdfCScad2wAzL4J0
   n9HIlh6AWB4jHw/jgGWAjcfHJroVQw0d8Lxr/fwblhGmYdyS8FuJ9LN0X
   YNMydrEuYPt0/i9HXFYVJaHABUIqj9X1qKiPqKa6TqSJVmB5+bCnzlEO8
   QQgNmgP1OFPS2pRzJJ5i0eLwzRsi5Qg7xGwdvBUF1aq7ngoCAmgXBnzyW
   p0xDGittwLVbFQ9f26qRKaZaj6Hb3WfSnVTi7d9P3mPVrdVynHCauYS5h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="382739966"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="382739966"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 07:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="642545781"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="642545781"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 14 Dec 2022 07:53:54 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p5U4u-009sxL-0B;
        Wed, 14 Dec 2022 17:53:52 +0200
Date:   Wed, 14 Dec 2022 17:53:51 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
        david.keisarschm@mail.huji.ac.il, dri-devel@lists.freedesktop.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Renaming weak prng invocations -
 prandom_bytes_state, prandom_u32_state
Message-ID: <Y5nxjzV0Mio86NU6@smile.fi.intel.com>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <Y5c8KLzJFz/XZMiM@zx2c4.com>
 <20221214123358.GA1062210@linux.intel.com>
 <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 04:15:49PM +0100, Eric Dumazet wrote:
> On Wed, Dec 14, 2022 at 1:34 PM Stanislaw Gruszka
> <stanislaw.gruszka@linux.intel.com> wrote:
> > On Mon, Dec 12, 2022 at 03:35:20PM +0100, Jason A. Donenfeld wrote:
> > > Please CC me on future revisions.
> > >
> > > As of 6.2, the prandom namespace is *only* for predictable randomness.
> > > There's no need to rename anything. So nack on this patch 1/5.
> >
> > It is not obvious (for casual developers like me) that p in prandom
> > stands for predictable. Some renaming would be useful IMHO.
> 
> Renaming makes backports more complicated, because stable teams will
> have to 'undo' name changes.
> Stable teams are already overwhelmed by the amount of backports, and
> silly merge conflicts.
> 
> Take another example :
> 
> u64 timecounter_read(struct timecounter *tc)
> 
> You would think this function would read the timecounter, right ?
> 
> Well, it _updates_ many fields from @tc, so a 'better name' would also
> be useful.

Right, at some point we become into the world of

#define true 0

because... (read below)

> linux kernel is not for casual readers.

P.S. I believe you applied a common sense and in some cases
     the renames are necessary.

-- 
With Best Regards,
Andy Shevchenko


