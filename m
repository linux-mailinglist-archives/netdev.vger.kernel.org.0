Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D3C37ED13
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385137AbhELUGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381218AbhELTdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 15:33:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFD2C061760;
        Wed, 12 May 2021 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=LHg4QUj5UkmNjZ90ZWWzvd65Yq2JWCT78FpIYI4LQ20=; b=fnUNWfD3iiuAeVKX3ZVuYcF/z8
        qF1eDicZVrUDZDt6/BmbAPQCqqPgkQlAxmFUFs3AxjUxK4usArXTnbazf7HbwcZ0f56C6b3hS6jNK
        krjmT7Xt74OrAP2MD+hYUf4BIMq6xECmTGvBCQqFd1kp0xolVYgrALedajmCKaMk1RJ1Z62wqZol6
        SckgUULmPTz0u0Qeo8DLSL4/nIJuNyDwUTToCcuqugdXwdOjZ4klcjWg3yKC9UperQvU+hobf47Xw
        63lv9/QZfl/I5s99cqlrmTh7s57OYOqFb6bUKxurD4S4x3cX3imSdNF4KT29DX7HvNJ0UVcRVnN8d
        LjllBMPg==;
Received: from c-73-157-219-8.hsd1.or.comcast.net ([73.157.219.8] helo=[10.0.0.253])
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lguUn-00AlF6-1D; Wed, 12 May 2021 19:26:13 +0000
Subject: Re: linux-next: Tree for May 12 (arch/x86/net/bpf_jit_comp32.o)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20210512175623.2687ac6f@canb.auug.org.au>
 <08f677a5-7634-b5d2-a532-ea6d3f35200c@infradead.org>
 <daf46ee7-1a18-9d5a-c3b3-7fc55ec23b30@iogearbox.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <751025d2-9c46-a4b9-4f54-fbe5fa7a2564@infradead.org>
Date:   Wed, 12 May 2021 12:26:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <daf46ee7-1a18-9d5a-c3b3-7fc55ec23b30@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/21 11:53 AM, Daniel Borkmann wrote:
> Hi Randy,
> 
> On 5/12/21 8:01 PM, Randy Dunlap wrote:
>> On 5/12/21 12:56 AM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20210511:
>>>
>>
>> on i386:
>>
>> ld: arch/x86/net/bpf_jit_comp32.o: in function `do_jit':
>> bpf_jit_comp32.c:(.text+0x28c9): undefined reference to `__bpf_call_base'
>> ld: arch/x86/net/bpf_jit_comp32.o: in function `bpf_int_jit_compile':
>> bpf_jit_comp32.c:(.text+0x3694): undefined reference to `bpf_jit_blind_constants'
>> ld: bpf_jit_comp32.c:(.text+0x3719): undefined reference to `bpf_jit_binary_free'
>> ld: bpf_jit_comp32.c:(.text+0x3745): undefined reference to `bpf_jit_binary_alloc'
>> ld: bpf_jit_comp32.c:(.text+0x37d3): undefined reference to `bpf_jit_prog_release_other'
>> ld: kernel/extable.o: in function `search_exception_tables':
>> extable.c:(.text+0x42): undefined reference to `search_bpf_extables'
>> ld: kernel/extable.o: in function `kernel_text_address':
>> extable.c:(.text+0xee): undefined reference to `is_bpf_text_address'
>> ld: kernel/kallsyms.o: in function `kallsyms_lookup_size_offset':
>> kallsyms.c:(.text+0x254): undefined reference to `__bpf_address_lookup'
>> ld: kernel/kallsyms.o: in function `kallsyms_lookup_buildid':
>> kallsyms.c:(.text+0x2ee): undefined reference to `__bpf_address_lookup'
> 
> Thanks for reporting, could you double check the following diff:
> 
> diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
> index 26b591e23f16..bd04f4a44c01 100644
> --- a/kernel/bpf/Kconfig
> +++ b/kernel/bpf/Kconfig
> @@ -37,6 +37,7 @@ config BPF_SYSCALL
> 
> config BPF_JIT
>     bool "Enable BPF Just In Time compiler"
> +    depends on BPF
>     depends on HAVE_CBPF_JIT || HAVE_EBPF_JIT
>     depends on MODULES
>     help

That's good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested


-- 
~Randy

