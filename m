Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2E5F6D21
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiJFRnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiJFRnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:43:03 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E72B40E8;
        Thu,  6 Oct 2022 10:43:01 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4MjzLB6Ky2z9t0M;
        Thu,  6 Oct 2022 19:42:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Fq7hDkCWiCvc; Thu,  6 Oct 2022 19:42:58 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4MjzLB4vNFz9syB;
        Thu,  6 Oct 2022 19:42:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 84B508B78B;
        Thu,  6 Oct 2022 19:42:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id mbcF0I0xUYNn; Thu,  6 Oct 2022 19:42:58 +0200 (CEST)
Received: from [192.168.233.27] (po19210.idsi0.si.c-s.fr [192.168.233.27])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4E53E8B77D;
        Thu,  6 Oct 2022 19:42:56 +0200 (CEST)
Message-ID: <6396875c-146a-acf5-dd9e-7f93ba1b4bc3@csgroup.eu>
Date:   Thu, 6 Oct 2022 19:42:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 3/5] treewide: use get_random_u32() when possible
Content-Language: fr-FR
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgens?= =?UTF-8?Q?en?= 
        <toke@toke.dk>, Chuck Lever <chuck.lever@oracle.com>,
        Jan Kara <jack@suse.cz>
References: <20221006165346.73159-1-Jason@zx2c4.com>
 <20221006165346.73159-4-Jason@zx2c4.com>
 <848ed24c-13ef-6c38-fd13-639b33809194@csgroup.eu>
 <CAHmME9raQ4E00r9r8NyWJ17iSXE_KniTG0onCNAfMmfcGar1eg@mail.gmail.com>
 <f10fcfbf-2da6-cf2d-6027-fbf8b52803e9@csgroup.eu>
In-Reply-To: <f10fcfbf-2da6-cf2d-6027-fbf8b52803e9@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 06/10/2022 à 19:31, Christophe Leroy a écrit :
> 
> 
> Le 06/10/2022 à 19:24, Jason A. Donenfeld a écrit :
>> Hi Christophe,
>>
>> On Thu, Oct 6, 2022 at 11:21 AM Christophe Leroy
>> <christophe.leroy@csgroup.eu> wrote:
>>> Le 06/10/2022 à 18:53, Jason A. Donenfeld a écrit :
>>>> The prandom_u32() function has been a deprecated inline wrapper around
>>>> get_random_u32() for several releases now, and compiles down to the
>>>> exact same code. Replace the deprecated wrapper with a direct call to
>>>> the real function. The same also applies to get_random_int(), which is
>>>> just a wrapper around get_random_u32().
>>>>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk> # for sch_cake
>>>> Acked-by: Chuck Lever <chuck.lever@oracle.com> # for nfsd
>>>> Reviewed-by: Jan Kara <jack@suse.cz> # for ext4
>>>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>>>> ---
>>>
>>>> diff --git a/arch/powerpc/kernel/process.c 
>>>> b/arch/powerpc/kernel/process.c
>>>> index 0fbda89cd1bb..9c4c15afbbe8 100644
>>>> --- a/arch/powerpc/kernel/process.c
>>>> +++ b/arch/powerpc/kernel/process.c
>>>> @@ -2308,6 +2308,6 @@ void notrace __ppc64_runlatch_off(void)
>>>>    unsigned long arch_align_stack(unsigned long sp)
>>>>    {
>>>>        if (!(current->personality & ADDR_NO_RANDOMIZE) && 
>>>> randomize_va_space)
>>>> -             sp -= get_random_int() & ~PAGE_MASK;
>>>> +             sp -= get_random_u32() & ~PAGE_MASK;
>>>>        return sp & ~0xf;
>>>
>>> Isn't that a candidate for prandom_u32_max() ?
>>>
>>> Note that sp is deemed to be 16 bytes aligned at all time.
>>
>> Yes, probably. It seemed non-trivial to think about, so I didn't. But
>> let's see here... maybe it's not too bad:
>>
>> If PAGE_MASK is always ~(PAGE_SIZE-1), then ~PAGE_MASK is
>> (PAGE_SIZE-1), so prandom_u32_max(PAGE_SIZE) should yield the same
>> thing? Is that accurate? And holds across platforms (this comes up a
>> few places)? If so, I'll do that for a v4.
>>
> 
> On powerpc it is always (from arch/powerpc/include/asm/page.h) :
> 
> /*
>   * Subtle: (1 << PAGE_SHIFT) is an int, not an unsigned long. So if we
>   * assign PAGE_MASK to a larger type it gets extended the way we want
>   * (i.e. with 1s in the high bits)
>   */
> #define PAGE_MASK      (~((1 << PAGE_SHIFT) - 1))
> 
> #define PAGE_SIZE        (1UL << PAGE_SHIFT)
> 
> 
> So it would work I guess.

But taking into account that sp must remain 16 bytes aligned, would it 
be better to do something like ?

	sp -= prandom_u32_max(PAGE_SIZE >> 4) << 4;

	return sp;


