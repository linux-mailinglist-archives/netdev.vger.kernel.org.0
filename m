Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E94124FA7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfLRRse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:48:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:57578 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfLRRse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 12:48:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 09:48:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="218219842"
Received: from cbenkese-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.34.236])
  by orsmga003.jf.intel.com with ESMTP; 18 Dec 2019 09:48:30 -0800
Subject: Re: [PATCH bpf-next 2/8] xdp: simplify cpumap cleanup
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
 <20191218105400.2895-3-bjorn.topel@gmail.com>
 <20191218094723.13ab0d54@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <77fabe3b-2314-8826-a5a3-3a530f41eb0c@intel.com>
Date:   Wed, 18 Dec 2019 18:48:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191218094723.13ab0d54@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-18 18:47, Jakub Kicinski wrote:
> On Wed, 18 Dec 2019 11:53:54 +0100, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> After the RCU flavor consolidation [1], call_rcu() and
>> synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
>> to the read-side critical sections. As a result of this, the cleanup
>> code in cpumap can be simplified
>>
>> * There is no longer a need to flush in __cpu_map_entry_free, since we
>>    know that this has been done when the call_rcu() callback is
>>    triggered.
>>
>> * When freeing the map, there is no need to explicitly wait for a
>>    flush. It's guaranteed to be done after the synchronize_rcu() call
>>    in cpu_map_free().
>>
>> [1] https://lwn.net/Articles/777036/
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Probably transient but:
> 
> ../kernel/bpf/cpumap.c: In function "cpu_map_free":
> ../kernel/bpf/cpumap.c:502:6: warning: unused variable "cpu" [-Wunused-variable]
>    502 |  int cpu;
>        |      ^~~
> 
> I think there are also warnings in patch 4.
> 

Ugh. Thanks, I'll respin!


Björn
