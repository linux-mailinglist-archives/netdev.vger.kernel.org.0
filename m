Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7795328326D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJEIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:47:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:46728 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgJEIrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 04:47:22 -0400
IronPort-SDR: KNulN2BH7DJOdNAtAPUt84hiOwe3KVR0N1T1Z62GS+2uBUUkLLttnbvH/Mopn0iaLh1FK0t38k
 1uyW6r9EQH2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="142747450"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="142747450"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 01:47:19 -0700
IronPort-SDR: tNhnvKVyQsfqGlpCl1ryPs3O+BpRW2CuJcIYFI44oRZTVYB3NqPoIheh68nU7iGutpwC7RWdru
 8GkhLN7lBZ9A==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="524545084"
Received: from merezmax-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.32.228])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 01:47:14 -0700
Subject: Re: please revert [PATCH bpf-next v5 03/15] xsk: create and free
 buffer pool independently from umem
To:     Christoph Hellwig <hch@infradead.org>, davem@davemloft.net,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
 <1598603189-32145-4-git-send-email-magnus.karlsson@intel.com>
 <20201005083535.GA512@infradead.org> <20201005084341.GA3224@infradead.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <88fbfe56-8847-25a5-9301-a573788ca91a@intel.com>
Date:   Mon, 5 Oct 2020 10:47:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201005084341.GA3224@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-05 10:43, Christoph Hellwig wrote:
> On Mon, Oct 05, 2020 at 09:35:35AM +0100, Christoph Hellwig wrote:
>> Hi Dave,
>>
>> please can you rever this?  This is the second xsk patch this year
>> that pokes into dma-mapping internals for absolutely not reason.
>>
>> And we discussed this in detail the last time around: drivers have
>> absolutely no business poking into dma-direct.h and dma-noncoherent.h.
>> In fact because people do this crap I have a patch to remove these
>> headers that I'm about to queue up, so if this doesn't get reverted
>> the linux-next build will break soon.
> 
> Looks like it doesn't actually use any functionality and just
> pointlessly includes internal headers.  So just removing dma-direct.h,
> dma-noncoherent.h and swiotlb.h should do the job as well.
> 
> But guys, don't do this.
> 

Yeah, this commit just moves the work you helped out with [1], and by 
accident/sloppiness the internal dma headers were included in the move.

Sorry about that, and we'll try not to repeat this. Apologies for the 
extra work on your side.

I'll spin up a patch to fix this asap.


Thanks,
Björn


[1] https://lore.kernel.org/bpf/20200629130359.2690853-5-hch@lst.de/
