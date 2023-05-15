Return-Path: <netdev+bounces-2520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4977024F7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BD202811B8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6CE79E6;
	Mon, 15 May 2023 06:36:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4506C46AA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:36:31 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77491186
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684132589; x=1715668589;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eHmH3019/p8gFNtuPJ8dToVG1E2ns0dE1FAPZsNc1XU=;
  b=Gho6euZ52sscEETnEfbgmthBFBG5QdmYxSOFtdMlsHGEsVchoubhoJtv
   DRuxNdmaPI59S4CFRnkmyKRZE35ywBwamgjMwP7F3KgnGKwdxvJiLUVs2
   tPu5ioERLxppWF/b5C4GjeD/+svdgBA7FVTP/SCamaSxRTe3iGDmgn+qe
   vKoS9BFegN3xjktjRrt7rMvXHUwSt1+Ay/SWT5gZVoQFIKxI0sYlokd4S
   kZsrcm9gI7R5JSoyEuTBYr9NkXbUZyHVAmQLhoCx37beK/0rPnNgxU8u0
   7x2g8m9dWfD0YGphKb8mnN4thjtSoNfXLRx1+EdHu0IOUOVGTKwkPkwmJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="416772617"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="416772617"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 23:36:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="1030786628"
X-IronPort-AV: E=Sophos;i="5.99,275,1677571200"; 
   d="scan'208";a="1030786628"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.125.186]) ([10.215.125.186])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2023 23:36:25 -0700
Message-ID: <c99dca8e-1628-b3ef-3ca1-09a4e10e6981@linux.intel.com>
Date: Mon, 15 May 2023 12:06:05 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net] net: wwan: iosm: fix NULL pointer dereference when
 removing device
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
 linuxwwan@intel.com, m.chetan.kumar@intel.com, edumazet@google.com,
 pabeni@redhat.com, Samuel Wein PhD <sam@samwein.com>
References: <a9b0a086a7fc9de0994fd00cedf6bbbda34805b5.1683798621.git.m.chetan.kumar@linux.intel.com>
 <ZF5x3OK2+Rm2njd6@corigine.com>
Content-Language: en-US
From: "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <ZF5x3OK2+Rm2njd6@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/12/2023 10:35 PM, Simon Horman wrote:
> On Thu, May 11, 2023 at 03:34:44PM +0530, m.chetan.kumar@linux.intel.com wrote:
>> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>>
>> In suspend and resume cycle, the removal and rescan of device ends
>> up in NULL pointer dereference.
>>
>> During driver initialization, if the ipc_imem_wwan_channel_init()
>> fails to get the valid device capabilities it returns an error and
>> further no resource (wwan struct) will be allocated. Now in this
>> situation if driver removal procedure is initiated it would result
>> in NULL pointer exception since unallocated wwan struct is dereferenced
>> inside ipc_wwan_deinit().
>>
>> ipc_imem_run_state_worker() to handle the called functions return value
>> and to release the resource in failure case. It also reports the link
>> down event in failure cases. The user space application can handle this
>> event to do a device reset for restoring the device communication.
>>
>> Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
>> Reported-by: Samuel Wein PhD <sam@samwein.com>
>> Closes: https://lore.kernel.org/netdev/20230427140819.1310f4bd@kernel.org/T/
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 

<skip>

> err_out:
> 	ipc_mux_deinit(ipc_imem->mux);
> 	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);
> 
>>   }

Thank you for reviewing the patch and sharing the feedback.
I will post the v2 with the above suggested changes.

