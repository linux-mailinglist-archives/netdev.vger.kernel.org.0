Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989BA450619
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhKON54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:57:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:65200 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhKON5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:57:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="232162978"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="232162978"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 05:54:53 -0800
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="494026503"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.188.166]) ([10.215.188.166])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 05:54:50 -0800
Message-ID: <8a6e9a45-2307-f3e3-04b1-2c7cefe53614@linux.intel.com>
Date:   Mon, 15 Nov 2021 19:24:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net: wwan: iosm: device trace collection using
 relayfs
Content-Language: en-US
To:     Denis Kirjanov <dkirjanov@suse.de>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
References: <20211115105659.331730-1-m.chetan.kumar@linux.intel.com>
 <33704bcc-a4a7-9933-0d5c-56f602b6a163@suse.de>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <33704bcc-a4a7-9933-0d5c-56f602b6a163@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/2021 6:59 PM, Denis Kirjanov wrote:

>>   /* Check the wwan ips if it is valid with Channel as input. */
>>   static int ipc_imem_check_wwan_ips(struct ipc_mem_channel *chnl)
>> @@ -265,9 +266,14 @@ static void ipc_imem_dl_skb_process(struct 
>> iosm_imem *ipc_imem,
>>       switch (pipe->channel->ctype) {
>>       case IPC_CTYPE_CTRL:
>>           port_id = pipe->channel->channel_id;
>> +        ipc_pcie_addr_unmap(ipc_imem->pcie, IPC_CB(skb)->len,
>> +                    IPC_CB(skb)->mapping,
>> +                    IPC_CB(skb)->direction);
> Looks like the hunk above is not related to the subject, right?

It is related.
Trace SKB->data is unmapped before passing SKB->data to relayfs.


