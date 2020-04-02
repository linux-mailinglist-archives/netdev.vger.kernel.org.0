Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1CE19CD17
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389521AbgDBWvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:51:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:35076 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbgDBWvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:51:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8gK-0004OD-FO; Fri, 03 Apr 2020 00:51:28 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8gK-000XgO-4b; Fri, 03 Apr 2020 00:51:28 +0200
Subject: Re: [PATCH bpf] riscv: remove BPF JIT for nommu builds
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org
Cc:     linux-riscv@lists.infradead.org, Damien.LeMoal@wdc.com,
        hch@infradead.org, kbuild test robot <lkp@intel.com>
References: <20200331101046.23252-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <92890a1f-12d6-6505-c3a9-60cf9753dc2b@iogearbox.net>
Date:   Fri, 3 Apr 2020 00:51:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200331101046.23252-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25770/Thu Apr  2 14:58:54 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 12:10 PM, Björn Töpel wrote:
> The BPF JIT fails to build for kernels configured to !MMU. Without an
> MMU, the BPF JIT does not make much sense, therefore this patch
> disables the JIT for nommu builds.
> 
> This was reported by the kbuild test robot:
> 
>     All errors (new ones prefixed by >>):
> 
>        arch/riscv/net/bpf_jit_comp64.c: In function 'bpf_jit_alloc_exec':
>     >> arch/riscv/net/bpf_jit_comp64.c:1094:47: error: 'BPF_JIT_REGION_START' undeclared (first use in this function)
>         1094 |  return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
>              |                                               ^~~~~~~~~~~~~~~~~~~~
>        arch/riscv/net/bpf_jit_comp64.c:1094:47: note: each undeclared identifier is reported only once for each function it appears in
>     >> arch/riscv/net/bpf_jit_comp64.c:1095:9: error: 'BPF_JIT_REGION_END' undeclared (first use in this function)
>         1095 |         BPF_JIT_REGION_END, GFP_KERNEL,
>              |         ^~~~~~~~~~~~~~~~~~
>        arch/riscv/net/bpf_jit_comp64.c:1098:1: warning: control reaches end of non-void function [-Wreturn-type]
>         1098 | }
>              | ^
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>

Applied, thanks!
