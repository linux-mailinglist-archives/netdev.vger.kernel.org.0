Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622D612766B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLTHUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:20:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:39708 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfLTHUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 02:20:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 23:20:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="241419924"
Received: from cbenkese-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.34.236])
  by fmsmga004.fm.intel.com with ESMTP; 19 Dec 2019 23:20:49 -0800
Subject: Re: [PATCH bpf-next] libbpf: fix AF_XDP helper program to support
 kernels without the JMP32 eBPF instruction class
To:     Alex Forster <aforster@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>
References: <20191219201601.7378-1-aforster@cloudflare.com>
 <CAADnVQLrsgGzVcBea68gf+yZ2R-iYzCJupE6jzaqR5ctbCKxNw@mail.gmail.com>
 <CAKxSbF19OsyE8B9mM+nB6676R6oA0duXSLn6_GGr1A+tCKhY9w@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c02dbf12-f1ae-8cb1-13fc-a7bb2fbff3aa@intel.com>
Date:   Fri, 20 Dec 2019 08:20:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAKxSbF19OsyE8B9mM+nB6676R6oA0duXSLn6_GGr1A+tCKhY9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-19 23:29, Alex Forster wrote:
>> I though af_xdp landed after jmp32 ?
> 
> They were indeed pretty close together, but AF_XDP became usable in
> late 2018 with either 4.18 or 4.19. JMP32 landed in early 2019 with
> 5.1.
>

Correct, but is anyone really using AF_XDP pre-5.1?

The rationale for doing JMP32:
https://lore.kernel.org/bpf/87v9sip0i8.fsf@toke.dk/

I think going forward, a route where different AF_XDP programs is loaded
based on what currently running kernel supports. "Every s^Hcycle is
sacred", and we're actually paying for the extra checks.

Then again, failing to load is still pretty bad. :-) Thanks for fixing this.


Acked-by: Björn Töpel <bjorn.topel@intel.com>


> Alex Forster
> 
