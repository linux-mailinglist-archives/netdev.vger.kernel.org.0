Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BC754D139
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 20:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358506AbiFOSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 14:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244398AbiFOSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 14:54:14 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7B23587F
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 11:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655319253; x=1686855253;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kfQVWOVhcIs8Q1P6d+Vs+AZzPVyRPMluazQQ9DRSKm8=;
  b=CLLXHEdt7JN3GhbPOmVu2ZU4pPmPB3XE9jTaaG9uYYtJwF3ewGWbvNeW
   Fl2puIId6rCCGlc4gZAreGngayOqL+LWoXpdStUIF5BTsa5Is4rn+4TN0
   cQUa142OvStOVlZbhftQUzCft7lJv2mwgjrRd64CvsrvLkRz+f7/1RE5a
   fjdEE/oSCAj85rcisZx9IlEEn5fUqcWQJQjMyHA6ECNP6i4yLIXIalL5X
   fuUBdttTCYMYIrcjY9UNxESvzkzUrVOIx0M5AJXRe6x+CGQZGMNWeN9Ta
   G7nQCEUEPB2qKuwpOV84+hd6GSjmbLTohUqI0gTjufBNhX/2hms9KsPuS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="365427621"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="365427621"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 11:49:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="583341602"
Received: from clmark-mobl2.amr.corp.intel.com (HELO [10.209.46.90]) ([10.209.46.90])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 11:49:49 -0700
Message-ID: <321ecbc9-7033-1caa-356c-8bac1338ecb3@linux.intel.com>
Date:   Wed, 15 Jun 2022 11:49:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <YqmgFcwVSucDGgZ6@smile.fi.intel.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <YqmgFcwVSucDGgZ6@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/15/22 02:02, Andy Shevchenko wrote:
> On Tue, Jun 14, 2022 at 01:57:56PM -0700, Moises Veleta wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
> This doesn't explain the sAP -> AP renaming in a several cases.
> If that renaming is needed, it perhaps requires a separate patch or
> at least a good paragraph to explain why.
>
The renaming was done since sAP (small Application Processor) represents 
Application Processor succinctly. The word "small" only adds unnecessary 
word that would confuse readers if we kept both "sAP" and "AP". I will 
add that information as an additional paragraph.
