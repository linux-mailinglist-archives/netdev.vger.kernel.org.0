Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684E754E75A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiFPQcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiFPQcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:32:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97F22E1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655397150; x=1686933150;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QIJQT0Xxnv4GCzZYz2NIvdhgvbdbjtUvf5067orZsSU=;
  b=AVBxzlurC8VwAsHAClxAoWZOMRQodWfSd1VUoErya2N5iEf7gAzkqtDW
   /hWa8vm90Q/tp86J+YC/+N4npsJBPrpv9rK3GwKQTcoXiERwdMufjBTmR
   1I8JE3uIvqArFFz820zSnhvYbwJvSw1fIs/7yiri/q/blze7M+418C8yf
   8bD13UzCYnV3a2KhhXC4R48UgteDYEjqgPWCniIG6BQyR4H2zfQCLshYC
   XMwFkdypfxRAUI7PTudFnUtuthdP20FChvfEracVXP1c2HUrfP2CE9fir
   NenJKHdNJQBc7hiyGrF1rzmwNVrS141pwRFnoVjZFnpGkLKv3hBRaogfG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="262309460"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="262309460"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 09:32:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="589714394"
Received: from msheikh-mobl1.amr.corp.intel.com (HELO [10.209.44.76]) ([10.209.44.76])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 09:32:16 -0700
Message-ID: <83ce5da4-65c1-1f66-b5a9-a88273749c1b@linux.intel.com>
Date:   Thu, 16 Jun 2022 09:32:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
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
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <bb56f67-7353-39c7-a3fa-a237e15f3b95@linux.intel.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <bb56f67-7353-39c7-a3fa-a237e15f3b95@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/16/22 02:37, Ilpo Järvinen wrote:
> On Tue, 14 Jun 2022, Moises Veleta wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>> communicate with AP and Modem processors respectively. So far only
>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>> port which requires such channel.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>> ---
> Look fine to me. One nit below.
>
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>
>> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
>> index dc4133eb433a..3d27f04e2a1f 100644
>> --- a/drivers/net/wwan/t7xx/t7xx_port.h
>> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
>> @@ -36,9 +36,17 @@
>>   /* Channel ID and Message ID definitions.
>>    * The channel number consists of peer_id(15:12) , channel_id(11:0)
>>    * peer_id:
>> - * 0:reserved, 1: to sAP, 2: to MD
>> + * 0:reserved, 1: to AP, 2: to MD
>>    */
>>   enum port_ch {
>> +	/* to AP */
>> +	PORT_CH_AP_CONTROL_RX = 0X1000,
>> +	PORT_CH_AP_CONTROL_TX = 0X1001,
> Please use lowercase x.
>
>
Will make these changes. Thanks


Regards,
Moises

