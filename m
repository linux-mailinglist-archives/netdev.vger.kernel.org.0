Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7359E573E44
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiGMUyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbiGMUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:53:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C341C138
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657745622; x=1689281622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/T51GKIP7+2O6OmMEZBo597+1J1ZXXJcIYLy9CALUv8=;
  b=Etbkd77T9c9uT26OghTZx6zzp/X8gbrSDQw6s0dOKSqDkggXnhgWhMwJ
   ijZozvgBcjlzGc7UKNISOzFRXzSwjknqwxMxUb/jkhu95m/BWP4zYFuUD
   4a0zq3UzmCQKLs12+lnHu4X1M2DIu9XYa2VsSbj6MF88c3UZ2PrtPDC2P
   3MDl6wqoix4H4/Z1qT3KSb3rGTamrqoigKzCb+SsgcBkRJ7gAm8e7qjAE
   E8KfJFdZQpOT2Cntwf3dozzI91nlrzP1+rnqH+iGOuvTMpFZHn3O0+21+
   GJZFZEfKGpaiiS1UpkXUy6koal4tWbHFNRnzs3QqxyA4ToM7EXl73uq1y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="310987824"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="310987824"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 13:53:42 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="653568156"
Received: from jkrieger-desk.amr.corp.intel.com (HELO [10.209.51.145]) ([10.209.51.145])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 13:53:41 -0700
Message-ID: <06e9db15-f5a2-c4ca-8750-c1909fdaf0a9@linux.intel.com>
Date:   Wed, 13 Jul 2022 13:53:33 -0700
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
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <CAHNKnsTq+-_sgPsuqG1ohqVVwJfU-Gq_QJ7kQO8gwyLbQHKwiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey

On 7/13/22 13:39, Sergey Ryazanov wrote:
> Hello Moises,
>
> On Wed, Jul 13, 2022 at 8:07 PM Moises Veleta
> <moises.veleta@linux.intel.com> wrote:
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA.
> What is the purpose of adding the driver interface to the hardware
> function without a user counterpart?
>
We have follow-on features/submissiona that are dependent on this AP 
control port: PCIe rescan,  FW flashing via devlink, & Coredump log 
collection. They will be submitted for review upon completion by 
different individuals. This foreruns their efforts.


