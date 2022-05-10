Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5169152119E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiEJKF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbiEJKFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:05:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B103EAB8;
        Tue, 10 May 2022 03:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652176876; x=1683712876;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8DH0BNbpwE8GijAGJt1CM+7tdMZJzjE1yk74ezgb6wg=;
  b=g/C5d34IjaChbxaAQMLxjHoaPTzK6beWw525cN3Tl3IAzYYAH+tPE9jY
   DsoW6ytsr6H+DhbRxTKL+NEgCL6z2QkKjwXpRr1ExJddhsfRKCkHkIfpG
   jqCyzQ0dVXjoczp6FdejjevuXCWGI7uPZIduUPO69C/2bc7k1yihZooI5
   cZ78xOtF6QmM5mRuVEhW0ie/gGMKtVC2gdiMX4Kmw056Yk5HN/QdFYu/7
   6EVEj7fZLIdtfjsV/T5oRt5hH8GdWsXBtjNDLD/3oua5ypbK6+nRjdIYm
   WPWM+qvRLGiupFYuJhkxRNm+VYj7QkUViPBrb6fyEhH7/xmP0CsC0F3/0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="269259525"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="269259525"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 03:01:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="541704741"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 03:01:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1noMfy-00EHy4-NP;
        Tue, 10 May 2022 13:01:06 +0300
Date:   Tue, 10 May 2022 13:01:06 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        Haijun Liu =?utf-8?B?KCDliJjmtbflhpsp?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Subject: Re: [PATCH net-next v8 02/14] net: skb: introduce
 skb_data_area_size()
Message-ID: <Yno34pDxbkW0Aqkv@smile.fi.intel.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
 <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
 <20220509094930.6d5db0f8@kernel.org>
 <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
 <20220509125008.6d1c3b9b@kernel.org>
 <c4892d58-9d97-8fd7-800d-8433181cbda5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4892d58-9d97-8fd7-800d-8433181cbda5@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 02:37:26PM -0700, Martinez, Ricardo wrote:
> On 5/9/2022 12:50 PM, Jakub Kicinski wrote:
> > On Mon, 9 May 2022 21:34:58 +0300 Sergey Ryazanov wrote:

...

> > We have two cases:
> >   - for Tx - drivers should use skb_headlen();
> >   - for Rx - I presume we are either dealing with fresh or correctly
> >     reset skbs, so we can use skb_tailroom().
> Thanks for the information, looks like indeed we can avoid the helper in
> t7xx driver by following those guidelines.

I think this can be done as a follow up patch.

-- 
With Best Regards,
Andy Shevchenko


