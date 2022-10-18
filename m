Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F560346B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJRU5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJRU5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:57:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845653A54;
        Tue, 18 Oct 2022 13:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666126664; x=1697662664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Iw7ifpwqC5dIzOmjFQLDFvPXcRHwlPq0OQd/Sm9QAtA=;
  b=NQ4EQ9z2BxtfVz9nxbG04h38WFmQLNE3XmBGXW3yvSqwfDxm1bM9qq8e
   GISOio/mOU1b1xAslEGQjyx85NbXPU+DaUwT4p3q3pq+hX1DwAgpZ/Q7h
   h5CifCbwYiBD4H3V+KjPePyTvPuy3yvOAcNQCwzotU5r/qjfMhNSV/vnY
   58mI9GCbdmPN3krqUBMzcyus5xYywovZZW50mPtD9zHcBgHH5QMOpaHoF
   AR5+Fys26yZujCi/bR1+dvEhpYWYtZ0dUXM7jkHK37R8flSbRb2wxT9rU
   69hux/erEHRxUdHymsSoHYmz3nTCwyE/msR9P5TCSxvj9HXgs7BVSadfh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="289553784"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="289553784"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 13:57:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="803946119"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="803946119"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 18 Oct 2022 13:57:41 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1okted-009YNz-1S;
        Tue, 18 Oct 2022 23:57:39 +0300
Date:   Tue, 18 Oct 2022 23:57:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <Y08TQwcY3zL3kGHR@smile.fi.intel.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
 <Y08PVnsTw75sHfbg@smile.fi.intel.com>
 <Y08SGz/xGSN87ynk@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y08SGz/xGSN87ynk@zx2c4.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 02:52:43PM -0600, Jason A. Donenfeld wrote:
> On Tue, Oct 18, 2022 at 11:40:54PM +0300, Andy Shevchenko wrote:
> > On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> > > On some platforms, `char` is unsigned, which makes casting -7 to char
> > > overflow, which in turn makes the clamping operation bogus. Instead,
> > > deal with an explicit `s8` type, so that the comparison is always
> > > signed, and return an s8 result from the function as well. Note that
> > > this function's result is assigned to a `short`, which is always signed.
> > 
> > Why not to use short? See my patch I just sent.
> 
> Trying to have the most minimal change here that doesn't rock the boat.
> I'm not out to rewrite the driver. I don't know the original author's
> rationales. This patch here is correct and will generate the same code
> as before on architectures where it wasn't broken.
> 
> However, if you want your "change the codegen" patch to be taken
> seriously, you should probably send it to the wireless maintainers like
> this one, and they can decide. Personally, I don't really care either
> way.

I have checked the code paths there and I found no evidence that short can't be
used. That's why my patch.

Okay, I will formally send it to the corresponding maintainers.

But if they want, they can always download this thread using `b4` tool and at
least comment on it.

-- 
With Best Regards,
Andy Shevchenko


