Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58D42FD433
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbhATPhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:37:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:63833 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732643AbhATOu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 09:50:59 -0500
IronPort-SDR: 0iRRWc3+TjBNYVEDuVkrTWvCNnqXux9Khm0Zv049pcDtq348WCG7tFvN0e/R2hPI0Q+2l2PksA
 tMSKz54+xAxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="240653458"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="240653458"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 06:49:54 -0800
IronPort-SDR: Cgknxy8wC4GI7dELKyOBMOYTKx0plb+KBBjx9ESmaGcSRhFM9H6B/AfabE8pOM8KB02kDXgYdJ
 NlsyqefErLJQ==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384861257"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 06:49:49 -0800
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
Message-ID: <6cda7383-663e-ed92-45dd-bbf87ca45eef@intel.com>
Date:   Wed, 20 Jan 2021 15:49:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 14:25, Björn Töpel wrote:
> On 2021-01-20 13:52, Toke Høiland-Jørgensen wrote:
>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> Add detection for kernel version, and adapt the BPF program based on
>>> kernel support. This way, users will get the best possible performance
>>> from the BPF program.
>>
>> Please do explicit feature detection instead of relying on the kernel
>> version number; some distro kernels are known to have a creative notion
>> of their own version, which is not really related to the features they
>> actually support (I'm sure you know which one I'm referring to ;)).
>>
> 
> Right. For a *new* helper, like bpf_redirect_xsk, we rely on rejection
> from the verifier to detect support. What about "bpf_redirect_map() now
> supports passing return value as flags"? Any ideas how to do that in a
> robust, non-version number-based scheme?
>

Just so that I understand this correctly. Red^WSome distro vendors
backport the world, and call that franken kernel, say, 3.10. Is that
interpretation correct? My hope was that wasn't the case. :-(

Would it make sense with some kind of BPF-specific "supported features"
mechanism? Something else with a bigger scope (whole kernel)?



Cheers,
Björn

