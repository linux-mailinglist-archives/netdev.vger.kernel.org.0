Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9AF198327
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgC3SPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:15:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3SPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=dvRAfacYVv+Eg59W06vLytYBlTZBs40NGpdohyB+NkQ=; b=fPoTDl7EdNYPZpuNoPdIeJMcPs
        yV1QBNGt+wL39bdrB0aKvr+/q34qR3g+GOlPPkw7EUCijLY5agDcVNihR2RZIYvO4/menEVoHdl4R
        ZQWdVPq/JCjKDx/zhmKuZbLjxZAF6xOIk0bFltJlu1X4YOPEn9hEfvwFGS+EqTEcqcDAFpdN/cpOS
        eBhpvEqWogUgyPVsZZlLDef3UKwUjtJ1Vx8BeUwSK+WzGMdGbFLEjUDTC39w+JMYY2GNWNvjHaVV0
        LWUXjPfry4xwYng/6WTxjWhF/ZF46QDy3+DCtrGo1oaCzSAeUTWm7WvZF0ai4ESgwCbl1RG3mtgI5
        fOyRYRfg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jIyws-0001iQ-9l; Mon, 30 Mar 2020 18:15:46 +0000
Subject: Re: linux-next: Tree for Mar 30 (bpf)
To:     KP Singh <kpsingh@chromium.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200330204307.669bbb4d@canb.auug.org.au>
 <86f7031a-57c6-5d50-2788-ae0e06a7c138@infradead.org>
 <d5b4bd95-7ef9-58cb-1955-900e6edb2467@iogearbox.net>
 <CACYkzJ72Uy9mnenO04OJaKH=Bk4ZENKJb9yw6i+EhJUa+ygngQ@mail.gmail.com>
 <20200330180538.GA180081@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <08026861-d198-add1-feb8-c43f2e006cb6@infradead.org>
Date:   Mon, 30 Mar 2020 11:15:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330180538.GA180081@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 11:05 AM, KP Singh wrote:
> On 30-Mar 19:54, KP Singh wrote:
> 
> So, it looks like bpf_tracing_func_proto is only defined when
> CONFIG_BPF_EVENTS is set:
> 
>         obj-$(CONFIG_BPF_EVENTS) += bpf_trace.o
> 
> We have a few options:
> 
> * Add a __weak symbol for bpf_tracing_func_proto which we have done in
>   the past for similar issues. This however, does not make much sense,
>   as CONFIG_BPF_LSM cannot really do much without its helpers.
> * Make CONFIG_BPF_LSM depend on CONFIG_BPF_EVENTS, this should solve
>   it, but not for this particular Kconfig that was generated. Randy,
>   I am assuming if we add the dependency, this particular Kconfig
>   won't be generated.

Hi KP,
That sounds reasonable.

Thanks.

> 
> I am assuming this patch now needs to be sent for "bpf" and not
> "bpf-next" as the merge window has opened?
> 
> - KP
> 
>> Thanks for adding me Daniel, taking a look.
>>
>> - KP
>>
>> On Mon, Mar 30, 2020 at 7:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>
>>> [Cc KP, ptal]
>>>
>>> On 3/30/20 7:15 PM, Randy Dunlap wrote:
>>>> On 3/30/20 2:43 AM, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> The merge window has opened, so please do not add any material for the
>>>>> next release into your linux-next included trees/branches until after
>>>>> the merge window closes.
>>>>>
>>>>> Changes since 20200327:
>>>>
>>>> (note: linux-next is based on linux 5.6-rc7)
>>>>
>>>>
>>>> on i386:
>>>>
>>>> ld: kernel/bpf/bpf_lsm.o:(.rodata+0x0): undefined reference to `bpf_tracing_func_proto'
>>>>
>>>>
>>>> Full randconfig file is attached.


-- 
~Randy

