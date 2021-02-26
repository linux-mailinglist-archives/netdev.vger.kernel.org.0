Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9AF326210
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBZLlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:41:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:38734 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhBZLlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 06:41:21 -0500
IronPort-SDR: mllxYMT6Vv80LhIstDVmpuUV4wagSss1e8oia6FtbRTXjB6xETVgjx9w/+cc1cCVlBkPylGkhx
 M9J2jWzYsnaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="247270453"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="247270453"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 03:40:39 -0800
IronPort-SDR: DBZg24Q9WsSuy43MLbPH3EiJepjCxQ91VVRCQocFUb/kZNeU1vhkmiIr8jOvH9yY/gmxd5LEVP
 7fmiLIEQU1IA==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="404867794"
Received: from hkarray-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.60.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 03:40:35 -0800
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
 <20210226112322.144927-2-bjorn.topel@gmail.com> <87sg5jys8r.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <694101a1-c8e2-538c-fdd5-c23f8e2605bb@intel.com>
Date:   Fri, 26 Feb 2021 12:40:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87sg5jys8r.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-26 12:37, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Currently the bpf_redirect_map() implementation dispatches to the
>> correct map-lookup function via a switch-statement. To avoid the
>> dispatching, this change adds bpf_redirect_map() as a map
>> operation. Each map provides its bpf_redirect_map() version, and
>> correct function is automatically selected by the BPF verifier.
>>
>> A nice side-effect of the code movement is that the map lookup
>> functions are now local to the map implementation files, which removes
>> one additional function call.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Nice! I agree that this is a much nicer approach! :)
> 
> (That last paragraph above is why I asked if you updated the performance
> numbers in the cover letter; removing an additional function call should
> affect those, right?)
>

Yeah, it should. Let me spend some more time benchmarking on the DEVMAP
scenario.

@Jesper Do you have a CPUMAP benchmark that you can point me to? I just
did functional testing for CPUMAP

> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 

Thank you!


Björn
