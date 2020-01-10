Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317FD1379A6
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgAJW2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:28:23 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:58527 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbgAJW2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 17:28:23 -0500
Received: from [192.168.0.12] (127.19.86.79.rev.sfr.net [79.86.19.127])
        (Authenticated sender: alexandre@ghiti.fr)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2EFE3240002;
        Fri, 10 Jan 2020 22:28:18 +0000 (UTC)
Subject: Re: Re: linux-next: build warning after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, zong.li@sifive.com
References: <20191018105657.4584ec67@canb.auug.org.au>
 <20191028110257.6d6dba6e@canb.auug.org.au>
From:   Alexandre Ghiti <alexandre@ghiti.fr>
Message-ID: <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
Date:   Fri, 10 Jan 2020 17:28:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028110257.6d6dba6e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: sv-FI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

On 10/27/19 8:02 PM, Stephen Rothwell wrote:
> Hi all,
>
> On Fri, 18 Oct 2019 10:56:57 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the bpf-next tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced this warning:
>>
>> WARNING: 2 bad relocations
>> c000000001998a48 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_start
>> c000000001998a50 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_end
>>
>> Introduced by commit
>>
>>    8580ac9404f6 ("bpf: Process in-kernel BTF")
> This warning now appears in the net-next tree build.
>
>
I bump that thread up because Zong also noticed that 2 new relocations for
those symbols appeared in my riscv relocatable kernel branch following 
that commit.

I also noticed 2 new relocations R_AARCH64_ABS64 appearing in arm64 kernel.

Those 2 weak undefined symbols have existed since commit
341dfcf8d78e ("btf: expose BTF info through sysfs") but this is the fact
to declare those symbols into btf.c that produced those relocations.

I'm not sure what this all means, but this is not something I expected 
for riscv for
a kernel linked with -shared/-fpie. Maybe should we just leave them to 
zero ?

I think that deserves a deeper look if someone understands all this 
better than I do.

Alex

