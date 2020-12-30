Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74172E7D1F
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 00:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgL3XR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 18:17:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:52584 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgL3XR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 18:17:28 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kukhu-0007Ya-U3; Thu, 31 Dec 2020 00:16:42 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kukhu-000CRM-Mf; Thu, 31 Dec 2020 00:16:42 +0100
Subject: Re: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
 <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
 <63bcde67-4124-121d-e96a-066493542ca9@iogearbox.net>
 <CAJ0CqmVsr=cv+0ndg3g4RDqVmKt=X6qQ7sbArNVrB+98e_3Sag@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b76a6fc5-55fa-1ca8-f2b9-ae0332450333@iogearbox.net>
Date:   Thu, 31 Dec 2020 00:16:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ0CqmVsr=cv+0ndg3g4RDqVmKt=X6qQ7sbArNVrB+98e_3Sag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26033/Wed Dec 30 13:42:10 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/29/20 7:09 PM, Lorenzo Bianconi wrote:
>>> +                     hard_start = page_address(rx_buffer->page) +
>>> +                                  rx_buffer->page_offset - offset;
>>> +                     xdp_prepare_buff(&xdp, hard_start, offset, size, true);
>>>    #if (PAGE_SIZE > 4096)
>>>                        /* At larger PAGE_SIZE, frame_sz depend on len size */
>>>                        xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);
> 
> Hi Daniel,
> 
> thx for the review.
> 
>> [...]
>> The design is very similar for most of the Intel drivers. Why the inconsistency on
>> ice driver compared to the rest, what's the rationale there to do it in one but not
>> the others? Generated code better there?
> 
> I applied the same logic for the ice driver but the code is just
> slightly different.
> 
>> Couldn't you even move the 'unsigned int offset = xyz_rx_offset(rx_ring)' out of the
>> while loop altogether for all of them? (You already use the xyz_rx_offset() implicitly
>> for most of them when setting xdp.frame_sz.)
> 
> We discussed moving "offset = xyz_rx_offset(rx_ring)" out of the while
> loop before but Saeed asked to address it in a dedicated series since
> it is a little bit out of the scope. I have no strong opinion on it,
> do you prefer to address it directly here?

Fair enough, I might have preferred it in this series as part of the overall cleanup,
but if you plan to follow up on this then this is also fine by me. Applied the v5 to
bpf-next in that case, thanks!
