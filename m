Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1659D64CD8A
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbiLNP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238122AbiLNP51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:57:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D93222B1;
        Wed, 14 Dec 2022 07:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671033434; x=1702569434;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5LFXBukgQPsSVobJ4TQvaAaS4znUymOqfbKoEQKnuF8=;
  b=E+ckExooB4bREp/WKswEEPddfmy6vnU0BLE2og4rz17i9GvWUK+yJU0M
   Fhe5aMBIMwEN8qyhY6ezagv9DP8KlU0vtmci7WljdbKY9rLLjol2Nk3xy
   Enh2voNRFcllcGHpbC6l73uDqeofyZz52fYoxRGVBpvaM0RbXN95FDCpj
   VAluPdVMacqYB0m5W6k60cMbZlnC9cU80KU0KWiZrx4lgRAtVrTwht3TK
   5o+i2n6Z1kLjdmGOLAKhpGFFpgo+YTtHzrrH9MdFsvHhsnQYaE422npXk
   ElU0VPEEF6nyiApt091AlCnE1F0MGZuNgQYsqVmHpJkU0iHoWo+oKTTfB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="380640649"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="380640649"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 07:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="737738842"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="737738842"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Dec 2022 07:57:11 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p5U86-009t4i-01;
        Wed, 14 Dec 2022 17:57:10 +0200
Date:   Wed, 14 Dec 2022 17:57:09 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
        david.keisarschm@mail.huji.ac.il, dri-devel@lists.freedesktop.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Renaming weak prng invocations -
 prandom_bytes_state, prandom_u32_state
Message-ID: <Y5nyVXv1KpX5baQE@smile.fi.intel.com>
References: <cover.1670778651.git.david.keisarschm@mail.huji.ac.il>
 <b3caaa5ac5fca4b729bf1ecd0d01968c09e6d083.1670778652.git.david.keisarschm@mail.huji.ac.il>
 <Y5c8KLzJFz/XZMiM@zx2c4.com>
 <20221214123358.GA1062210@linux.intel.com>
 <CANn89iJtK4m1cWvCwp=L_rEOEBa+B1kLZJAw0D9_cYPQcAj+Mw@mail.gmail.com>
 <Y5nxjzV0Mio86NU6@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5nxjzV0Mio86NU6@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 05:53:52PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 14, 2022 at 04:15:49PM +0100, Eric Dumazet wrote:
> > On Wed, Dec 14, 2022 at 1:34 PM Stanislaw Gruszka
> > <stanislaw.gruszka@linux.intel.com> wrote:
> > > On Mon, Dec 12, 2022 at 03:35:20PM +0100, Jason A. Donenfeld wrote:
> > > > Please CC me on future revisions.
> > > >
> > > > As of 6.2, the prandom namespace is *only* for predictable randomness.
> > > > There's no need to rename anything. So nack on this patch 1/5.
> > >
> > > It is not obvious (for casual developers like me) that p in prandom
> > > stands for predictable. Some renaming would be useful IMHO.
> > 
> > Renaming makes backports more complicated, because stable teams will
> > have to 'undo' name changes.
> > Stable teams are already overwhelmed by the amount of backports, and
> > silly merge conflicts.
> > 
> > Take another example :
> > 
> > u64 timecounter_read(struct timecounter *tc)
> > 
> > You would think this function would read the timecounter, right ?
> > 
> > Well, it _updates_ many fields from @tc, so a 'better name' would also
> > be useful.
> 
> Right, at some point we become into the world of
> 
> #define true 0
> 
> because... (read below)
> 
> > linux kernel is not for casual readers.
> 
> P.S. I believe you applied a common sense and in some cases
>      the renames are necessary.

And before you become to a wrong conclusion by reading between the lines,
no, I'm not taking either side (to rename or not to rename) in this case.

-- 
With Best Regards,
Andy Shevchenko


