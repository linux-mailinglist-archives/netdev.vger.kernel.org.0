Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D067AFCC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbjAYKiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbjAYKiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:38:00 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6439EEF94
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674643078; x=1706179078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l/a76dR3DNdIFjk9AoRrJrSuRI8dACos29wIPLbOMb0=;
  b=PJTWxmuCUcE4wESHlje/LEtBP/uBWjbF7BTZv/cWzaLFVJlxjuGvgxxx
   FQbH2oadyIAEqWtC/S5UMSNA/aFUq/TKKJEZAOkafp9bkFrIoMqSdky74
   v8ozsm6Cl3RuSuBbu8evJX6hjW94ObNxRqvSicbzuR78B/JAvYrkn+Zy6
   SXPo80qqEDLXSZ3J7WGxHqzR+GEnzQTlZ9AvECHlNzjtgYcJH9PK3EqyM
   WACQRuDp/yg0Lt4l/EI0t9FJ8XKneMOfr8dPCPKHayGjw+6jMsyBNyqV1
   Ly/HGEST9yPmkGI0Ll/tNav/W+cJvazuBXWm7HIcYK+z/gT1+MynYxReh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="353806035"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="353806035"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:37:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="664399811"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="664399811"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.86.11]) ([10.213.86.11])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:37:52 -0800
Message-ID: <35f9613b-ac56-fdef-4020-af35b16321bb@linux.intel.com>
Date:   Wed, 25 Jan 2023 16:07:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 net-next 4/5] net: wwan: t7xx: Enable devlink based fw
 flashing and coredump collection
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, ilpo.jarvinen@linux.intel.com,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
 <fc8bbb0b66a5ff3a489ea9857d79b374508090ef.1674307425.git.m.chetan.kumar@linux.intel.com>
 <20230124205356.2bd6683e@kernel.org>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20230124205356.2bd6683e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/2023 10:23 AM, Jakub Kicinski wrote:
> On Sat, 21 Jan 2023 19:03:38 +0530 m.chetan.kumar@linux.intel.com wrote:
>> 1> Driver Registers with Devlink framework.
>> 2> Implements devlink ops flash_update callback that programs modem fw.
>> 3> Creates region & snapshot required for device coredump log collection.
> 
> Sounds like these should be 3 patches?

Flashing and coredump feature implementation is kept under single
patch. I can revist and break it into 2 patches to seperate out
flashing and coredump logic. I hope this fine.

> 
>> +	devlink_params_register(dl_ctx, t7xx_devlink_params, ARRAY_SIZE(t7xx_devlink_params));
>> +	value.vbool = false;
>> +	devlink_param_driverinit_value_set(dl_ctx, T7XX_DEVLINK_PARAM_ID_FASTBOOT, value);
>> +	devlink_set_features(dl_ctx, DEVLINK_F_RELOAD);
>> +	devlink_register(dl_ctx);
> 
> Please take the devl_lock() explicitly and use the devl_
> version of those calls.

Ok. will modify it as per your suggestion.

-- 
Chetan
