Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0796D7A09
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbjDEKmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237800AbjDEKmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:42:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942B84ED0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 03:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680691333; x=1712227333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K6wFcXFK28iKXCbQpaOUgNcQdauJtP8Sp9MYTKRwDS4=;
  b=QCRUvC3UCLdkOxgcpGpwzFhcs1AOXvsWlZgsuw1gk+yA3MNhB9mCdbX0
   59+2uguuwKVCSsnCBdbbXAeZzZigWXIBjlN1ANwEmHF8zuJoThOenE/pZ
   brjTR/jaZ74zLjRdekKLfhaoMRL5d8JHIZc1UQjI0b8ZzOUEyNJtKbaYO
   yBFw2nCeOgJwoKB1wqgXfsWNvjLedV5IbM348cY8sG3b1dRgxkXjMWmJR
   JoqRwS9zgDM1OnGlakbMzStv7iOJXovpCrlDRYWKcN0zIhBgKK5qRYsYA
   GTrPmw1T8qPcd0XYO8S2lqhCzMspleo3p6O866fHKzXPJAhyGQWyzCa5f
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370245128"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="370245128"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 03:42:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="689234147"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="689234147"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 05 Apr 2023 03:42:11 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pk0af-00CnGd-0t;
        Wed, 05 Apr 2023 13:42:09 +0300
Date:   Wed, 5 Apr 2023 13:42:08 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: thunderbolt: Fix sparse warnings
Message-ID: <ZC1QgGW5HZqcYIug@smile.fi.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
 <20230404053636.51597-2-mika.westerberg@linux.intel.com>
 <ZC01N8tU9SN70GDh@smile.fi.intel.com>
 <20230405095224.GT33314@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405095224.GT33314@black.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 12:52:24PM +0300, Mika Westerberg wrote:
> On Wed, Apr 05, 2023 at 11:45:43AM +0300, Andy Shevchenko wrote:
> > On Tue, Apr 04, 2023 at 08:36:35AM +0300, Mika Westerberg wrote:

...

> > > drivers/net/thunderbolt/main.c:993:23:    expected restricted __wsum [usertype] wsum
> > > drivers/net/thunderbolt/main.c:993:23:    got restricted __be32 [usertype]
> > 
> > You can drop the whole part with file name and line numbers to make the above
> > neater.
> 
> I guess it is good to leave the filename, there like this, no?
> 
> main.c:993:23:    expected restricted __wsum [usertype] wsum
> main.c:993:23:    got restricted __be32 [usertype]

Fine by me.

...

> > > +		net->rx_hdr.frame_size = hdr->frame_size;
> > > +		net->rx_hdr.frame_count = hdr->frame_count;
> > > +		net->rx_hdr.frame_index = hdr->frame_index;
> > > +		net->rx_hdr.frame_id = hdr->frame_id;
> > > +		last = le16_to_cpu(net->rx_hdr.frame_index) ==
> > > +		       le32_to_cpu(net->rx_hdr.frame_count) - 1;

...

> > > -	__wsum wsum = htonl(skb->len - skb_transport_offset(skb));
> > > +	/* Remove payload length from checksum */
> > > +	u32 paylen = skb->len - skb_transport_offset(skb);
> > > +	__wsum wsum = (__force __wsum)htonl(paylen);

> > I would split wsum fix from the above as they are of different nature.
> 
> How they are different? The complain is pretty much the same for all
> these AFAICT:
> 
> expected restricted xxx [usertype] yyy
> got restricted zzz [usertype]

While the main part is about header data type and endianess conversion between
protocol and CPU (with cpu_*() and *_cpu() macros) this one is completely network
related stuff as it's using hton*() and ntoh*() conversion macros. Yes, underneeth
it may be the same, but semantically these two parts are not of the same thing.

-- 
With Best Regards,
Andy Shevchenko


