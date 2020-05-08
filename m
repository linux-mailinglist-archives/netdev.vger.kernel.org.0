Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B001CAAA7
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEHMcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:32:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:62090 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgEHMcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 08:32:19 -0400
IronPort-SDR: iEZNRyOpP6sR6ThX6V+KNurYCsbZMWT9fsiPLQNYjTvBLXjfanjUQf3uUhi6Flx3of/yyxyHK4
 xvs3dwgA8wAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 05:32:19 -0700
IronPort-SDR: yDbbUwJ/+I6+agKFR3clR5N5lZrH5ZzlH2DcJJTJPeT9lTE7vbb5OeOLw8HYGulPA5om33sfXg
 VK52A2cKjCJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,367,1583222400"; 
   d="scan'208";a="305438106"
Received: from aghafar1-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.248])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2020 05:32:16 -0700
Subject: Re: [PATCH bpf-next 04/14] xsk: introduce AF_XDP buffer allocation
 API
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-5-bjorn.topel@gmail.com>
 <be945166-cb5e-143b-e850-8fe60ecbece6@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c11b7ee7-23e2-65be-6983-2d260aeb90df@intel.com>
Date:   Fri, 8 May 2020 14:32:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <be945166-cb5e-143b-e850-8fe60ecbece6@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-08 13:55, Maxim Mikityanskiy wrote:
> On 2020-05-07 13:42, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> In order to simplify AF_XDP zero-copy enablement for NIC driver
>> developers, a new AF_XDP buffer allocation API is added. The
>> implementation is based on a single core (single producer/consumer)
>> buffer pool for the AF_XDP UMEM.
>>
>> A buffer is allocated using the xsk_buff_alloc() function, and
>> returned using xsk_buff_free(). If a buffer is disassociated with the
>> pool, e.g. when a buffer is passed to an AF_XDP socket, a buffer is
>> said to be released. Currently, the release function is only used by
>> the AF_XDP internals and not visible to the driver.
>>
>> Drivers using this API should register the XDP memory model with the
>> new MEM_TYPE_XSK_BUFF_POOL type.
>>
>> The API is defined in net/xdp_sock_drv.h.
>>
>> The buffer type is struct xdp_buff, and follows the lifetime of
>> regular xdp_buffs, i.e.  the lifetime of an xdp_buff is restricted to
>> a NAPI context. In other words, the API is not replacing xdp_frames.
>>
>> In addition to introducing the API and implementations, the AF_XDP
>> core is migrated to use the new APIs.
>>
>> rfc->v1: Fixed build errors/warnings for m68k and riscv. (kbuild test
>>           robot)
>>           Added headroom/chunk size getter. (Maxim/Björn)
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Björn's signoff should go first (as the original author).
>

Oh, I didn't know that. I'll fix in the next revision!
