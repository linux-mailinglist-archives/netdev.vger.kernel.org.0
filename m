Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1794AEC881
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfKASbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:31:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:48099 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfKASbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 14:31:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 11:31:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400"; 
   d="scan'208";a="194755221"
Received: from unknown (HELO [10.241.228.226]) ([10.241.228.226])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2019 11:31:11 -0700
Subject: Re: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     bjorn.topel@gmail.com, alexei.starovoitov@gmail.com,
        bjorn.topel@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        tom.herbert@intel.com, David Miller <davem@davemloft.net>
References: <CAJ+HfNigHWVk2b+UJPhdCWCTcW=Eh=yfRNHg4=Fr1mv98Pq=cA@mail.gmail.com>
 <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
 <20191031172148.0290b11f@cakuba.netronome.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <8481fe0a-fa7b-c689-1e51-1a3253176509@intel.com>
Date:   Fri, 1 Nov 2019 11:31:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031172148.0290b11f@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/2019 5:21 PM, Jakub Kicinski wrote:
> On Thu, 31 Oct 2019 15:38:42 -0700, Samudrala, Sridhar wrote:
>> Do you think it will be possible to avoid this overhead when mitigations are turned ON?
>> The other part of the overhead is going through the redirect path.
> 
> Yes, you should help Maciej with the XDP bulking.
> 
>> Can i assume that your silence as an indication that you are now okay with optional bypass
>> flag as long as it doesn't effect the normal XDP datapath. If so, i will respin and submit
>> the patches against the latest bpf-next
> 
> This logic baffles me. I absolutely hate when people repost patches
> after I nack them without even as much as mentioning my objections in
> the cover letter.

Sorry if you got the impression that i didn't take your feedback. I CCed you
and also included the kernel rxdrop data that you requested in the original
series.

> 
> My concern was that we want the applications to encode fast path logic
> in BPF and load that into the kernel. So your patch works fundamentally
> against that goal:

So looks like you are saying that the fundamental requirement is that all AF_XDP
packets need to go via a BPF program.

The reason i proposed direct receive is because of the overhead we are seeing
with going via BPF program for apps that want to receive all the packets on a
specific queue.

I agree that there is work going on to reduce this overhead with bulking and avoiding
the retpoline.
We can revisit after these optimizations get in and then see if it is still useful
to provide a direct receive option.

-Sridhar
