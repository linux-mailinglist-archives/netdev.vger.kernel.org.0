Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281E4560586
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiF2QMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiF2QMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:12:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5992F3B7
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656519164; x=1688055164;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BA9zKfnyXZGpE4ZTkYC9kyc58/Me7B/1YZrnab85cGs=;
  b=KiFtMnBCN/rj24SLGn6R806rhceBJ9VhrnA/71AKwHTRHvHjhioJR/oQ
   UULeWnnP5q9/f/YyuFRmnf6e1y35c2/XMQyl/ctW/X0o/SGQnbzjlQUTe
   rPuAEV/aIn2U1njoOAnaBVnF6dvxq25i8QAQJsvG6jEcRGDBYsr4Rk/Op
   NTkbc/zhtk9EFjjb0FcmujxNDcy1QES5Tr1SgaSB6acX6n0AGjJyz/Utx
   2SzQIylN/YzMFX2fum7udhcyQ/Z+vmCK03GdbyE/zLcNb5A0tt0A6iJtZ
   3OHr+xNYvpyLwBoGt3LOd8JIja18l80b3V8T1qsrnrey3/4pqyBcONft9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="279615338"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="279615338"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 09:10:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="658606557"
Received: from agopala1-mobl.amr.corp.intel.com (HELO [10.209.100.146]) ([10.209.100.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 09:10:38 -0700
Message-ID: <e52d9425-b482-be5f-c458-407d58ad9257@linux.intel.com>
Date:   Wed, 29 Jun 2022 09:10:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
 <8447d962-2a45-7487-ee7b-821c7b35eba9@linux.intel.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <8447d962-2a45-7487-ee7b-821c7b35eba9@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/29/22 00:28, Ilpo Järvinen wrote:
> On Tue, 28 Jun 2022, Moises Veleta wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
>>
>> GNSS AT control port allows Modem Manager to control GPS for:
>> - Start/Stop GNSS sessions,
>> - Configuration commands to support Assisted GNSS positioning
>> - Crash & reboot (notifications when resetting device (AP) & host)
>> - Settings to Enable/Disable GNSS solution
>> - Geofencing
>>
>> Rename small Application Processor (sAP) to AP.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>
> (I already gave that tag for v1, please carry rev-by over next time when
> sending new versions.)
>
Will do, thanks for catching that.

Regards,
Moises

