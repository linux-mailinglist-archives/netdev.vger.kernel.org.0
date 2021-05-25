Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBD39095D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhEYTDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhEYTC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 15:02:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237B8C061574;
        Tue, 25 May 2021 12:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=P9Aa6sjzqr3comczSUqTSJnMMVooMAwTrpOa77UBks8=; b=4r8ofo52cSZjzB358cWP0dRx5G
        eNZ3kuTpB8MSVvVlmzfDBopadV4P1dJtzIH/MPvjF63kT/VoDQsRch4X7zF+K8VFZWk/Qo+h0UhZU
        5LQjvJbEkKeApwLTZS6vHou1ywF8sV+syiBLTgTjGYsR02qepld5PLphj55m4LY033LimxKPZ6iiX
        vgbYcgOSehmsQj4JdyH6uWEz/uFeGNQsN4mHOiWlc1CZAwMXrvICSxFIEw4DPZpGhA0Mpf5PvVpmI
        9yhy0FdUJKdK2TnSDAAdNiZ8JTW5ZjApyz3Z46OVgPtUO1l6mDbQfeFFZoiRk5W4HXJrSPOkztQ6L
        m8mAVzVw==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1llcIx-007Vje-LO; Tue, 25 May 2021 19:01:27 +0000
Subject: Re: linux-next: Tree for May 18 (kernel/bpf/bpf_lsm.o)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <f816246b-1136-cf00-ff47-554d40ecfb38@infradead.org>
 <7955d9e2-a584-1693-749a-5983187e0306@infradead.org>
 <166d8da3-1f1f-c245-cc46-c40e12fb71ab@iogearbox.net>
 <bd4198d8-f8d3-f2bb-0fcf-ecfb7ef41ca2@iogearbox.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f6473baa-f526-6f5b-eb9d-7db657515a2b@infradead.org>
Date:   Tue, 25 May 2021 12:01:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <bd4198d8-f8d3-f2bb-0fcf-ecfb7ef41ca2@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/21 11:31 AM, Daniel Borkmann wrote:
> Hi Randy,
> 
> On 5/25/21 8:26 PM, Daniel Borkmann wrote:
>> On 5/25/21 7:30 PM, Randy Dunlap wrote:
>>> On 5/18/21 10:02 AM, Randy Dunlap wrote:
>>>> On 5/18/21 2:27 AM, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20210514:
>>>>>
>>>>
>>>> on i386:
>>>> # CONFIG_NET is not set
>>>>
>>>> ld: kernel/bpf/bpf_lsm.o: in function `bpf_lsm_func_proto':
>>>> bpf_lsm.c:(.text+0x1a0): undefined reference to `bpf_sk_storage_get_proto'
>>>> ld: bpf_lsm.c:(.text+0x1b8): undefined reference to `bpf_sk_storage_delete_proto'
>>>>
>>>>
>>>> Full randconfig file is attached.
>>>>
>>>
>>> Hi,
>>> I am still seeing this build error in linux-next-20210525.
>>
>> Will take a look and get back.
> 
> This should resolve it:

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested


Thanks.

> 
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 5efb2b24012c..da471bf01b97 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -107,10 +107,12 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         return &bpf_inode_storage_get_proto;
>     case BPF_FUNC_inode_storage_delete:
>         return &bpf_inode_storage_delete_proto;
> +#ifdef CONFIG_NET
>     case BPF_FUNC_sk_storage_get:
>         return &bpf_sk_storage_get_proto;
>     case BPF_FUNC_sk_storage_delete:
>         return &bpf_sk_storage_delete_proto;
> +#endif /* CONFIG_NET */
>     case BPF_FUNC_spin_lock:
>         return &bpf_spin_lock_proto;
>     case BPF_FUNC_spin_unlock:


-- 
~Randy

