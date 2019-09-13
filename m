Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF44B1C12
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388066AbfIMLRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:17:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:42862 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfIMLRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:17:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 04:17:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,500,1559545200"; 
   d="scan'208";a="210318077"
Received: from sjuba-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.54.243])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2019 04:17:31 -0700
Subject: Re: [PATCH bpf-next] libbpf: add xsk_umem__adjust_offset
To:     "Laatz, Kevin" <kevin.laatz@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com, bpf <bpf@vger.kernel.org>
References: <20190912072840.20947-1-kevin.laatz@intel.com>
 <CAJ+HfNgQY6muwzGgBW6xLFzKeiCMQUwrz_yrywB3F_VSKbaadQ@mail.gmail.com>
 <847dcd1e-81ba-4364-7242-d280a17f9244@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1fda8ef3-0169-007f-147c-af8cb460758c@intel.com>
Date:   Fri, 13 Sep 2019 13:17:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <847dcd1e-81ba-4364-7242-d280a17f9244@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-13 12:21, Laatz, Kevin wrote:
> On 13/09/2019 05:59, Björn Töpel wrote:
>> On Thu, 12 Sep 2019 at 17:47, Kevin Laatz <kevin.laatz@intel.com> wrote:
>>> Currently, xsk_umem_adjust_offset exists as a kernel internal function.
>>> This patch adds xsk_umem__adjust_offset to libbpf so that it can be used
>>> from userspace. This will take the responsibility of properly storing 
>>> the
>>> offset away from the application, making it less error prone.
>>>
>>> Since xsk_umem__adjust_offset is called on a per-packet basis, we 
>>> need to
>>> inline the function to avoid any performance regressions.  In order to
>>> inline xsk_umem__adjust_offset, we need to add it to xsk.h. 
>>> Unfortunately
>>> this means that we can't dereference the xsk_umem_config struct directly
>>> since it is defined only in xsk.c. We therefore add an extra API to 
>>> return
>>> the flags field to the user from the structure, and have the inline
>>> function use this flags field directly.
>>>
>> Can you expand this to a series, with an additional patch where these
>> functions are used in XDP socket sample application, so it's more
>> clear for users?
> 
> These functions are currently not required in the xdpsock application 
> and I think forcing them in would be messy :-). However, an example of 
> the use of these functions could be seen in the DPDK AF_XDP PMD. There 
> is a patch herehttp://patches.dpdk.org/patch/58624/  where we currently 
> do the offset adjustment to the handle manually, but with this patch we 
> could replace it with xsk_umem__adjust_offset and have a real use 
> example of the functions being used.
> 
> Would this be enough for an example?
>

Fair enough! :-)

Acked-by: Björn Töpel <bjorn.topel@intel.com>


> Thanks,
> Kevin
> 
