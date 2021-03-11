Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE7336CA3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCKHAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:00:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:27367 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229731AbhCKG7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:59:54 -0500
IronPort-SDR: zEntlNvJppVsZhHetCbT3/ecJMa9qbOYPC8rBONy8qKdadmLJ1Rt/ldEfdyVNxGaYNk+rURefp
 eq2Y6vdFoegg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="273662898"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="273662898"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 22:59:54 -0800
IronPort-SDR: etC1/Qix5RDSZFoTajB90yb4CFzzecsx1G7yzSSOWXTlITDi7yEXly3N8mhF7SsKL8x0yc6CEx
 vAPpTUFpQw8A==
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="410506705"
Received: from eefimov-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.48.42])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 22:59:50 -0800
Subject: Re: [PATCH bpf-next 2/2] libbpf: xsk: move barriers from
 libbpf_util.h to xsk.h
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andrii@kernel.org, magnus.karlsson@intel.com,
        maximmi@nvidia.com, ciara.loftus@intel.com
References: <20210310080929.641212-1-bjorn.topel@gmail.com>
 <20210310080929.641212-3-bjorn.topel@gmail.com>
 <20210311000605.tuo7rg4b7keo76iy@bsd-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0535ce9f-0db6-40f7-e512-e327f6f54c35@intel.com>
Date:   Thu, 11 Mar 2021 07:59:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311000605.tuo7rg4b7keo76iy@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-11 01:06, Jonathan Lemon wrote:
> On Wed, Mar 10, 2021 at 09:09:29AM +0100, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> The only user of libbpf_util.h is xsk.h. Move the barriers to xsk.h,
>> and remove libbpf_util.h. The barriers are used as an implementation
>> detail, and should not be considered part of the stable API.
> 
> Does that mean that anything else which uses the same type of
> shared rings (bpf ringbuffer, io_uring, zctap) have to implement
> the same primitives that xsk.h has?
> 

Jonathan, there's a longer explanation on back-/forward-compatibility in
the commit message [1]. Again, this is for the XDP socket rings, so I
wont comment on the other rings. I would not assume compatibility
between different rings (e.g. the bpf ringbuffer and XDP sockets rings),
not even prior the barrier change.


Björn

[1] 
https://lore.kernel.org/bpf/20210305094113.413544-2-bjorn.topel@gmail.com/ 

