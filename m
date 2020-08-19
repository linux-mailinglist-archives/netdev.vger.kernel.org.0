Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8113249841
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHSIbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:31:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:41536 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSIbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 04:31:08 -0400
IronPort-SDR: Z+SgsLmguy7uygjSr8gpUYr1qkWtqUduFE2/ILSImMoVS5ZlbevCpLYaScFuDtV9soBOFGtcFV
 9uWKugrPBZ0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="152485905"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="152485905"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 01:31:07 -0700
IronPort-SDR: nr4QPHBurlUlXmKW2U6aYGO1vaY4Zx4aXEo8b30aHCAt7iBdbwxTZ8t/rq5o4AW8koO9DtWtSA
 dhe5UpMfsCtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="497163000"
Received: from skirillo-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.32.199])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2020 01:31:04 -0700
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFU?=
 =?UTF-8?Q?CH_0/2=5d_intel/xdp_fixes_for_fliping_rx_buffer?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
 <4268316b200049d58b9973ec4dc4725c@baidu.com>
 <83e45ec2-1c66-59f6-e817-d4c523879007@intel.com>
 <c3695fc71ca140d08a795bbd32d8522f@baidu.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c691e3d2-8b16-744c-8918-5be042bd37dc@intel.com>
Date:   Wed, 19 Aug 2020 10:31:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c3695fc71ca140d08a795bbd32d8522f@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-19 10:17, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Björn Töpel [mailto:bjorn.topel@intel.com]
>> 发送时间: 2020年8月19日 14:45
>> 收件人: Li,Rongqing <lirongqing@baidu.com>; Björn Töpel
>> <bjorn.topel@gmail.com>
>> 抄送: Netdev <netdev@vger.kernel.org>; intel-wired-lan
>> <intel-wired-lan@lists.osuosl.org>; Karlsson, Magnus
>> <magnus.karlsson@intel.com>; bpf <bpf@vger.kernel.org>; Maciej Fijalkowski
>> <maciej.fijalkowski@intel.com>; Piotr <piotr.raczynski@intel.com>; Maciej
>> <maciej.machnikowski@intel.com>
>> 主题: Re: 答复: [Intel-wired-lan] [PATCH 0/2] intel/xdp fixes for fliping rx buffer
>>
>> On 2020-08-19 03:37, Li,Rongqing wrote:
>> [...]
>>   > Hi:
>>   >
>>   > Thanks for your explanation.
>>   >
>>   > But we can reproduce this bug
>>   >
>>   > We use ebpf to redirect only-Vxlan packets to non-zerocopy AF_XDP, First we
>> see panic on tcp stack, in tcp_collapse: BUG_ON(offset < 0); it is very hard to
>> reproduce.
>>   >
>>   > Then we use the scp to do test, and has lots of vxlan packet at the same
>> time, scp will be broken frequently.
>>   >
>>
>> Ok! Just so that I'm certain of your setup. You receive packets to an i40e netdev
>> where there's an XDP program. The program does XDP_PASS or XDP_REDIRECT
>> to e.g. devmap for non-vxlan packets. However, vxlan packets are redirected to
>> AF_XDP socket(s) in *copy-mode*. Am I understanding that correct?
>>
> Similar as your description,
> 
> but the xdp program only redirects vxlan packets to af_xdp socket, other packets will go to Linux kernel networking stack, like scp/ssh packets
> 
> 
>> I'm assuming this is an x86-64 with 4k page size, right? :-) The page flipping is a
>> bit different if the PAGE_SIZE is not 4k.
>>
> 
> We use 4k page size, page flipping is 4k, we did not change the i40e drivers, 4.19 stable kernel
>

Would you mind testing on a newer kernel? Say the latest stable 5.8.2?


>>   > With this fixes, scp has not been broken again, and kernel is not panic
>> again  >
>>
>> Let's dig into your scenario.
>>
>> Are you saying the following:
>>
>> Page A:
>> +------------
>> | "first skb" ----> Rx HW ring entry X
>> +------------
>> | "second skb"----> Rx HW ring entry X+1 (or X+n)
>> +------------
>>
> 
> Like:
> 
> First skb will be into tcp socket rx queue
> 
> Seconds skb is vxlan packet, will be copy to af_xdp socket, and released.
> 
>> This is a scenario that shouldn't be allowed, because there are now two users
>> of the page. If that's the case, the refcounting is broken. Is that the case?
>>
> 
> True, it is broken for copy mode xsk
>

Ok. However, the fix is not avoiding the page_frag_free, but finding and 
fixing the refcount bug. I'll have a deeper look.

But please, try to reproduce with a newer kernel.


Thanks,
Björn
