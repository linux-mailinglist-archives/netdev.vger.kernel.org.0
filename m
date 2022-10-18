Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6CB60341A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJRUlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJRUll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:41:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E3E58084;
        Tue, 18 Oct 2022 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666125666; x=1697661666;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h4GeoGqkMQvfqFU2jQajYgDMnOjpIkPLpUI3afDMASg=;
  b=mJ00N/Iv5n4FsrM4zuD3ZepkkY7fG+wR/JTD6B7cVAt5XVq2RMgIsXF8
   Dziziy2JV4b7q5f4B4Gzwteqyzn8ddux8C2H2wmzD5zVLr5lAfJH9sxPr
   SuA/sWVKo2FyRgcw6T+zRbHuA9t4SJBHR70dn12aXyNZbJ2Q32IAortEj
   7eO9C6RO6+4H5vSwBEw+FzQKMFqlYdsVN9bsXfabPUpKHNs3Yzr7Vt/R1
   fdTS2lkJ2B/jdO2SOJDXsQfvVuRvWJc+gVCXwT+vOAwoS8QRmXIl6u/7D
   O2lABLfqZ4iBf3uRIfOAkZlonlbX4vxo7DUUFC+D0bj0e6Q7iBVA9hj9k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="392533573"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="392533573"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 13:40:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="733840135"
X-IronPort-AV: E=Sophos;i="5.95,194,1661842800"; 
   d="scan'208";a="733840135"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 18 Oct 2022 13:40:56 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oktOR-009Y1O-0H;
        Tue, 18 Oct 2022 23:40:55 +0300
Date:   Tue, 18 Oct 2022 23:40:54 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Message-ID: <Y08PVnsTw75sHfbg@smile.fi.intel.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
 <20221018202734.140489-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018202734.140489-1-Jason@zx2c4.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> On some platforms, `char` is unsigned, which makes casting -7 to char
> overflow, which in turn makes the clamping operation bogus. Instead,
> deal with an explicit `s8` type, so that the comparison is always
> signed, and return an s8 result from the function as well. Note that
> this function's result is assigned to a `short`, which is always signed.

Why not to use short? See my patch I just sent.

-- 
With Best Regards,
Andy Shevchenko


