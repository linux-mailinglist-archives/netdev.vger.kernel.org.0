Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A2573EA4
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiGMVOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiGMVOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:14:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EA21A38C
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 14:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657746853; x=1689282853;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZWAvEoknWuRPjalNB9Qc6q8QPFG7GyRXYSKFX+1PNJA=;
  b=n2ypJ1grhJFin3EsSaDKszOVPacQV5VNfenRxRmTARv2iIZ7RTTSeymR
   5HihhLpIL7wXAcVbb0jxD2aq8cf1t9oKaMiTY9evKn0BdPnBw8XjceNMw
   VQthNEf+NI5wxdqKt824hSuFTxBFmQ3A4U7nfYWM+S3aI4f8HW00T1Dd3
   a0I6kltqkyntNPYtCpQgxpT+Q1fnmVNvzA2a6kidgEkqHR6iXcM3Tiu8y
   owRXmcvTCfASZEHAGD6vd0nSvAd/f+4Dsen6/H4RUbmiwgbfrQEjS1ze0
   Xc9SLAkLrdqUBPg5RxbEhE65Es2P8uEFq/v1yxhLfWydqYbD10MCLA0ep
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="268380040"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="268380040"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 14:14:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="653576648"
Received: from jkrieger-desk.amr.corp.intel.com (HELO [10.209.51.145]) ([10.209.51.145])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 14:14:11 -0700
Message-ID: <18532582-90b8-d128-bcc6-7548ce2d107b@linux.intel.com>
Date:   Wed, 13 Jul 2022 14:14:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v3 1/1] net: wwan: t7xx: Add AP CLDMA
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        ram.mohan.reddy.boggala@intel.com,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220713170653.11328-1-moises.veleta@linux.intel.com>
 <CAHNKnsTq+-_sgPsuqG1ohqVVwJfU-Gq_QJ7kQO8gwyLbQHKwiA@mail.gmail.com>
 <06e9db15-f5a2-c4ca-8750-c1909fdaf0a9@linux.intel.com>
 <CAHNKnsQ-WG7_-Z6zxbe193D-kXzN1SbC76r3eQmo5oAhCNqr0w@mail.gmail.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <CAHNKnsQ-WG7_-Z6zxbe193D-kXzN1SbC76r3eQmo5oAhCNqr0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/13/22 14:03, Sergey Ryazanov wrote:
> On Wed, Jul 13, 2022 at 11:53 PM moises.veleta
> <moises.veleta@linux.intel.com> wrote:
>> Hi Sergey
>>
>> On 7/13/22 13:39, Sergey Ryazanov wrote:
>>> Hello Moises,
>>>
>>> On Wed, Jul 13, 2022 at 8:07 PM Moises Veleta
>>> <moises.veleta@linux.intel.com> wrote:
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>> communicate with AP and Modem processors respectively. So far only
>>>> MD-CLDMA was being used, this patch enables AP-CLDMA.
>>> What is the purpose of adding the driver interface to the hardware
>>> function without a user counterpart?
>>>
>> We have follow-on features/submissiona that are dependent on this AP
>> control port: PCIe rescan,  FW flashing via devlink, & Coredump log
>> collection. They will be submitted for review upon completion by
>> different individuals. This foreruns their efforts.
> Thanks for the explanation. Is it possible to send these parts as a
> single series? If not all at once, then at least AP-CLDMA + FW
> flashing or AP-CLDMA + logs collection or some other provider + user
> composition. What do you think?
>
I believe this is possible. I will share this information with them and 
see how we can package them into a series. Since, it appears this patch 
has been reviewed well by the community, it should not be hindrance for 
their later submissions. Thanks for guidance and feedback.


Regards,
Moises

