Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F424D0D10
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiCHAzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344135AbiCHAzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:55:12 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDC7B7F6;
        Mon,  7 Mar 2022 16:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646700856; x=1678236856;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mhvsr/RBR324xqUw2EB4HFdbuxkQrAyfM/cXZOm+Kf0=;
  b=LnDjjRH+Vyh1UCaUNvb/gu9YKQyyA1uEBTlD8moAftAe99DXv63w0heq
   XPqO7ZS2KiC8xP+nqZ3a44RsDocPEyswDSAGtLL/yTtdCdJdWfK+qrmcL
   qECy7s5z7HvNbh4kWBsPt4iOerruF/Y2l/L8LJYGcNQHl5joacB8nxTZi
   CsG2MphSJw9/BlOHNLqfn5dRuS1lVnDxHvX7wOyMNqFWT1/Nt58TvZDvs
   lmXj7h1qEDWYcU32zI1FihIrZg2+6WMq/RhPhwSURykj8hqiIoZ6NllhF
   pdqzXnhJGa97xSRcLPmgXvJ7XC9pAR+HI1Qa6uRmcyHWINAxTfPp5Dv39
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="253378867"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="253378867"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:54:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="512902157"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.10.64]) ([10.251.10.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:54:14 -0800
Message-ID: <2493227c-4489-22ac-0561-f52d1de27fec@linux.intel.com>
Date:   Mon, 7 Mar 2022 16:54:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 10/13] net: wwan: t7xx: Introduce power
 management
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-11-ricardo.martinez@linux.intel.com>
 <3fe7f932-57b7-14c7-4966-7484df7f8250@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <3fe7f932-57b7-14c7-4966-7484df7f8250@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/1/2022 5:26 AM, Ilpo Järvinen wrote:
> On Wed, 23 Feb 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Implements suspend, resumes, freeze, thaw, poweroff, and restore
>> `dev_pm_ops` callbacks.
>>
>> >From the host point of view, the t7xx driver is one entity. But, the
>> device has several modules that need to be addressed in different ways
>> during power management (PM) flows.
>> The driver uses the term 'PM entities' to refer to the 2 DPMA and
>> 2 CLDMA HW blocks that need to be managed during PM flows.
>> When a dev_pm_ops function is called, the PM entities list is iterated
>> and the matching function is called for each entry in the list.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> ---
>> +static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
>> +{
> ...
>> +	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
>> +	return 0;
> The success path does this same iowrite32 to DIS_ASPM_LOWPWR_CLR_0
> as the failure paths. Is that intended?

Yes, that's intended.

This function disables low power mode at the beginning and it has to 
re-enable it before

returning, regardless of the success or failure path.

The next iteration will contain some naming changes to avoid double 
negatives :

- iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);

+ iowrite32(T7XX_L1_BIT(0), IREG_BASE(t7xx_dev) + DISABLE_ASPM_LOWPWR);


> The function looks much better now!
>
>
