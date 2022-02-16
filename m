Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A73E4B7DAC
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343642AbiBPCZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:25:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239898AbiBPCY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:24:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC13D5DDC;
        Tue, 15 Feb 2022 18:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644978289; x=1676514289;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fquB9QZghnxGWBz5pPSJYamkV4+WuUlxXGz53I//1Ho=;
  b=SESRbSlPYsuHl/eQXLGE8RHawujfdC2GH+1jRhxZLlCjbOzQqpNx+BV2
   91AOycOL+WhMVapc27+xFiaXcxdgg4zEJJFnGdvVH+HDbXwydlgBM2S6P
   v/52qA+6BnWVe0dP4lifkbpgiaObAEsaa+JIRkk8gGPBnTJqt+4QdiS4e
   6zwIRmnHqNH9EokxnQomoeHqi2gvuSRc6kBk9yItcMiKnUyc6kK7VeyDl
   d0Ey6EdyHmwD4Ycy6mo1ib8frvH1YUcwewB19UpHgF7nY/lll3SHBmycG
   FZI6W17oVpj8dALjn6eXMoCeMXHiOPKfO2Ms90OlmNXSdBm0/AlLFzdcC
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="248103911"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="248103911"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:24:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="704086177"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.241.199]) ([10.212.241.199])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:24:46 -0800
Message-ID: <c1040c2c-477e-9598-8a7b-bfea88a0375b@linux.intel.com>
Date:   Tue, 15 Feb 2022 18:24:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
 <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
 <4a4b2848-d665-c9ba-c66a-dd4408e94ea5@linux.intel.com>
 <CAHNKnsT9y0ssM3zVriEdEzoRMuJyianKrOx4BAcmT80PCJBigg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsT9y0ssM3zVriEdEzoRMuJyianKrOx4BAcmT80PCJBigg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/10/2022 4:25 PM, Sergey Ryazanov wrote:
> Hello Ricardo,
>
> On Wed, Jan 19, 2022 at 1:22 AM Martinez, Ricardo
> <ricardo.martinez@linux.intel.com> wrote:
>> On 1/18/2022 6:13 AM, Ilpo Järvinen wrote:
>>> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
>> ...
>>>> +#define CLDMA_NUM 2
>>> I tried to understand its purpose but it seems that only one of the
>>> indexes is used in the arrays where this define gives the size? Related to
>>> this, ID_CLDMA0 is not used anywhere?
>> The modem HW has 2 CLDMAs, idx 0 for the app processor (SAP) and idx 1
>> for the modem (MD).
>>
>> CLDMA_NUM is defined as 2 to reflect the HW capabilities but mainly to
>> have a cleaner upcoming patches, which will use ID_CLDMA0.
>>
>> If having array's of size 1 is not a problem then we can define
>> CLDMA_NUM as 1 and play with the CLDMA indexes.
> Please keep CLDMA_NUM defined as 2. Especially if you have a plan for
> further driver development. Saving a few bytes in the structure for a
> short term is not worth the jungling with indexes, possible errors and
> further rework. Just document them as suggested by Ilpo and mark idx 0
> as unused at the moment.
>
> BTW, did you consider to define the cldma_id enum something like this:
>
> /**
>   * ...
>   * @CLDMA_ID_AP: ... (unused ATM)
>   * @CLDMA_ID_MD: ...
>   */
> enum cldma_id {
>      CLDMA_ID_AP = 0,
>      CLDMA_ID_MD = 1,
>
>      CLDMA_NUM
> };
>
> This way elements will be self descriptive as well as CLDMA_NUM value
> will be less puzzled.

I agree.

Actually, we already did the enum name changes, we'll incorporate the 
rest of the feedback.

>
