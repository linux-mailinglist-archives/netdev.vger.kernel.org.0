Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0654D0CFC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244165AbiCHAtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241674AbiCHAtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:49:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DEB1E3E1;
        Mon,  7 Mar 2022 16:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646700490; x=1678236490;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5XayvTxq+LGUw2mM2TQ4y3Ox+YjJhBLEdvRjTWL/HIQ=;
  b=gPFfUUKEGuDYE/PR+wE3ab615kasCHKRx2540EZCYCRHpx+PNqDH4Szw
   7TfaUNLoLmycyiet0c6f67pC5V923kO0R36FWbkxJHEp99rbRVlopip0W
   za1JxHeGJIxtgsmccQ5kJ2kO1ygy2OU2QnNn4oEnxEi/yaGV1j9crYBSk
   6H+Snkv7kEo5J9y5dOZ/S6aQWbJGX5GCLyFbLM9Dq5L0yE6fpJRTWeYUM
   Z5lIYmGbU/S+LFFVAZuG7a3Eqgrxs+NrIcL1SzXNEnA9MakKYh6r7G/sf
   8dcEoMUEpcOeAC549pdJF3ab8zpilrc3le0SNV4MXOfVsa5u0kh2Ke7eZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254276662"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="254276662"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:48:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="512899945"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.10.64]) ([10.251.10.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:48:09 -0800
Message-ID: <de37e3be-45bd-eee8-ebaf-97f2fbe918b0@linux.intel.com>
Date:   Mon, 7 Mar 2022 16:48:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
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
 <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
 <b7b7c5d1-e6c8-4c74-d5aa-b12443d5aee@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <b7b7c5d1-e6c8-4c74-d5aa-b12443d5aee@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/25/2022 3:47 AM, Ilpo Järvinen wrote:
> On Wed, 23 Feb 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Port-proxy provides a common interface to interact with different types
>> of ports. Ports export their configuration via `struct t7xx_port` and
>> operate as defined by `struct port_ops`.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>
>> >From a WWAN framework perspective:
>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>> ---
...
>> +
>> +	seq_num = FIELD_GET(CCCI_H_SEQ_FLD, le32_to_cpu(ccci_h->status));
>> +	next_seq_num = (seq_num + 1) & FIELD_MAX(CCCI_H_SEQ_FLD);
>> +	assert_bit = !!(le32_to_cpu(ccci_h->status) & CCCI_H_AST_BIT);
>> +	if (!assert_bit || port->seq_nums[MTK_RX] > FIELD_MAX(CCCI_H_SEQ_FLD))
> Is this an obfuscated way to say:
> 	... || port->seq_nums[MTK_RX] == INVALID_SEQ_NUM
> ?

Right, that condition is true only for the first packet, when seq num is 
set to INVALID_SEQ_NUM.

The next version will explicitly compare seq_nums[MTK_RX] against 
INVALID_SEQ_NUM.


