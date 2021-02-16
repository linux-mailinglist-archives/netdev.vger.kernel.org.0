Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050C631C7E9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhBPJRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:17:25 -0500
Received: from mga07.intel.com ([134.134.136.100]:8550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBPJQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 04:16:45 -0500
IronPort-SDR: zDxI73BNMWCAb7HFQ5AH9kli+f25PJzgFX6ej2fIPEUrHa/NUAJsSOnIJy3QxpKBRUdwAbjBdz
 ljItz3eaXzTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="246904880"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="246904880"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:16:06 -0800
IronPort-SDR: PbnAm1zo36oT86R4PHdaUXlPRuL/0XPIscyUzLXc0dqjf7m0CjaGZ0BvsKRlKzUPQhEk/cRI7B
 yY4SBBtFyjEw==
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="399437778"
Received: from tkanteck-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.159])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:15:59 -0800
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com> <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com> <875z2tcef2.fsf@toke.dk>
 <20210216020128.GA9572@ranger.igk.intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <33b54a25-a35a-6991-6831-f551670f5556@intel.com>
Date:   Tue, 16 Feb 2021 10:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210216020128.GA9572@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-16 03:01, Maciej Fijalkowski wrote:
> On Mon, Feb 15, 2021 at 08:35:29PM +0100, Toke Høiland-Jørgensen wrote:
>> Björn Töpel <bjorn.topel@intel.com> writes:

[...]

>>>
>>> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
>>> we're months ahead, then I'd really like to see this in libbpf until the
>>> merge. However, I'll leave that for Magnus/you to decide!
> 
> WDYM by libbpf 1.0/libxdp merge? I glanced through thread and I saw that
> John was also not aware of that. Not sure where it was discussed?
>

Oh, right. Yeah, we've had some offlist discussions about moving the
AF_XDP functionality from libbpf to libxdp in the libbpf 1.0 timeframe.

> If you're saying 'merge', then is libxdp going to be a part of kernel or
> as an AF-XDP related guy I would be forced to include yet another
> repository in the BPF developer toolchain? :<
>

The AF_XDP functionality of libbpf will be part of libxdp, which is not
in the kernel tree. libxdp depend on libbpf, which includes the core BPF
functionality. For AF_XDP this is a good thing IMO. libxdp includes more
higher lever abstractions than libbpf, which is more aligned to AF_XDP.

Yes, that would mean that you would get another dependency for AF_XDP,
and one that is not in the kernel tree. For most *users* this is not a
problem, in fact it might be easier to consume and to contribute for
most users. We can't optimize just for the kernel hackers. ;-)


Björn

[...]
