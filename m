Return-Path: <netdev+bounces-3246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E8770634A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26704281060
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421F75258;
	Wed, 17 May 2023 08:49:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7333F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:49:10 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0522101;
	Wed, 17 May 2023 01:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684313348; x=1715849348;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mwtRWrqDrj4nDmvAX7hgqry3RYlAqjIVusKkkudDzPQ=;
  b=YHsIvEE7zLNzAzVjY3xMDTaY/EPMssQhPls0dbtgd8kpv+tgAfa0kDG7
   0ec60gRbUvNSHbXd0nVKdtWm6yi0V+rNt6AuTglC7/8OTyjK5SK6lxdq8
   Mnqm5ssAMFO2prDnnabk16VKZG4uiGdKRxeTfuCLzBl4YUGEkkI9uiRqB
   RlwmBT2n/XCHHeOV+VLlSYfDTT5lQRuh+xmkaSwT0/pgzUnQcPAkJMBi+
   m360WlX3s7N7CTqL/rrL34Oj+MCpwTolpHM9PAEFELn6qSHYUpQ+WSJP4
   Lk0ekg+472WqmE5DENDQKc8YSuchef3ZRokcSj/6igfiUoXtBav2ipwhq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="341089511"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="341089511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 01:49:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="701671954"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="701671954"
Received: from mylly.fi.intel.com (HELO [10.237.72.160]) ([10.237.72.160])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2023 01:49:03 -0700
Message-ID: <85d058cd-2dd9-2a7b-efd0-e4c8d512ae29@linux.intel.com>
Date: Wed, 17 May 2023 11:49:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v8 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Content-Language: en-US
To: andy.shevchenko@gmail.com, Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, andriy.shevchenko@linux.intel.com,
 mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com,
 andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
 mengyuanlou@net-swift.com, Piotr Raczynski <piotr.raczynski@intel.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-3-jiawenwu@trustnetic.com>
 <ZGH6TmeiR0icT6Tc@surfacebook>
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <ZGH6TmeiR0icT6Tc@surfacebook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 12:24, andy.shevchenko@gmail.com wrote:
> Mon, May 15, 2023 at 02:31:53PM +0800, Jiawen Wu kirjoitti:
>> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
>> with SFP.
>>
>> Introduce the property "snps,i2c-platform" to match device data for Wangxun
>> in software node case. Since IO resource was mapped on the ethernet driver,
>> add a model quirk to get regmap from parent device.
>>
>> The exists IP limitations are dealt as workarounds:
>> - IP does not support interrupt mode, it works on polling mode.
>> - Additionally set FIFO depth address the chip issue.
> 
> ...
> 
>>   	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
>> +	if (device_property_present(&pdev->dev, "snps,i2c-platform"))
>> +		dev->flags |= MODEL_WANGXUN_SP;
> 
> What I meant here is to use device_property_present() _iff_ you have decided to
> go with the _vendor-specific_ property name.
> 
> Otherwise it should be handled differently, i.e. with reading the actual value
> of that property. Hence it should correspond the model enum, which you need to
> declare in the Device Tree bindings before use.
> 
> So, either
> 
> 	if (device_property_present(&pdev->dev, "wx,..."))
> 		dev->flags |= MODEL_WANGXUN_SP;
> 
> or
> 
> 	if ((dev->flags & MODEL_MASK) == MODEL_NONE) {
> 	// you now have to distinguish that there is no model set in driver data
> 		u32 model;
> 
> 		ret = device_property_read_u32(dev, "snps,i2c-platform");
> 		if (ret) {
> 			...handle error...
> 		}
> 		dev->flags |= model
> 
I'm not a device tree expert but I wonder would it be possible somehow 
combine this and compatible properties in dw_i2c_of_match[]? They set 
model flag for MODEL_MSCC_OCELOT and MODEL_BAIKAL_BT1.

Then I'm thinking is "snps,i2c-platform" descriptive enough name for a 
model and does it confuse with "snps,designware-i2c" compatible property?

