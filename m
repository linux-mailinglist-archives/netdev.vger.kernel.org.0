Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B845361D4B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbhDPJ2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:28:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49772 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbhDPJ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:28:17 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13G9QoXq061900;
        Fri, 16 Apr 2021 04:26:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618565210;
        bh=iUN+ZAwoZO98VUtAbHnorakjrh71xOPMrXkAMJ4Hqpo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=q6CHJQ5yHhCUxTvsb7LWnrHojwq4z5fdGhcq05XBA0YlrsKJOlZL44mFXdrMXAW0R
         wUKB5uUpmeYwcbTk0M0RI9dOZ3CPFoP6cgHnph+X7GsjlxLhWiVAP157Q4A/cGg0Yj
         nGxzGQi4XUQ1CBnf2HhNuMpn9s6wtsVxUbfTVjAk=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13G9Qotj047995
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Apr 2021 04:26:50 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Apr 2021 04:26:49 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 16 Apr 2021 04:26:49 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13G9QjO8101592;
        Fri, 16 Apr 2021 04:26:46 -0500
Subject: Re: Bogus struct page layout on 32-bit
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Matthew Wilcox <willy@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Linux-MM <linux-mm@kvack.org>, <kbuild-all@lists.01.org>,
        <clang-built-linux@googlegroups.com>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210409185105.188284-3-willy@infradead.org>
 <202104100656.N7EVvkNZ-lkp@intel.com>
 <20210410024313.GX2531743@casper.infradead.org>
 <20210410082158.79ad09a6@carbon>
 <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <ab9f1a6c-4099-2b59-457d-fcc45d2396f4@ti.com>
Date:   Fri, 16 Apr 2021 12:26:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAC_iWjLXZ6-hhvmvee6r4R_N64u-hrnLqE_CSS1nQk+YaMQQnA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias, All,

On 10/04/2021 11:52, Ilias Apalodimas wrote:
> +CC Grygorii for the cpsw part as Ivan's email is not valid anymore
> 
> Thanks for catching this. Interesting indeed...
> 
> On Sat, 10 Apr 2021 at 09:22, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>
>> On Sat, 10 Apr 2021 03:43:13 +0100
>> Matthew Wilcox <willy@infradead.org> wrote:
>>
>>> On Sat, Apr 10, 2021 at 06:45:35AM +0800, kernel test robot wrote:
>>>>>> include/linux/mm_types.h:274:1: error: static_assert failed due to requirement '__builtin_offsetof(struct page, lru) == __builtin_offsetof(struct folio, lru)' "offsetof(struct page, lru) == offsetof(struct folio, lru)"
>>>>     FOLIO_MATCH(lru, lru);
>>>>     include/linux/mm_types.h:272:2: note: expanded from macro 'FOLIO_MATCH'
>>>>             static_assert(offsetof(struct page, pg) == offsetof(struct folio, fl))
>>>
>>> Well, this is interesting.  pahole reports:
>>>
>>> struct page {
>>>          long unsigned int          flags;                /*     0     4 */
>>>          /* XXX 4 bytes hole, try to pack */
>>>          union {
>>>                  struct {
>>>                          struct list_head lru;            /*     8     8 */
>>> ...
>>> struct folio {
>>>          union {
>>>                  struct {
>>>                          long unsigned int flags;         /*     0     4 */
>>>                          struct list_head lru;            /*     4     8 */
>>>
>>> so this assert has absolutely done its job.
>>>
>>> But why has this assert triggered?  Why is struct page layout not what
>>> we thought it was?  Turns out it's the dma_addr added in 2019 by commit
>>> c25fff7171be ("mm: add dma_addr_t to struct page").  On this particular
>>> config, it's 64-bit, and ppc32 requires alignment to 64-bit.  So
>>> the whole union gets moved out by 4 bytes.
>>
>> Argh, good that you are catching this!
>>
>>> Unfortunately, we can't just fix this by putting an 'unsigned long pad'
>>> in front of it.  It still aligns the entire union to 8 bytes, and then
>>> it skips another 4 bytes after the pad.
>>>
>>> We can fix it like this ...
>>>
>>> +++ b/include/linux/mm_types.h
>>> @@ -96,11 +96,12 @@ struct page {
>>>                          unsigned long private;
>>>                  };
>>>                  struct {        /* page_pool used by netstack */
>>> +                       unsigned long _page_pool_pad;
>>
>> I'm fine with this pad.  Matteo is currently proposing[1] to add a 32-bit
>> value after @dma_addr, and he could use this area instead.
>>
>> [1] https://lore.kernel.org/netdev/20210409223801.104657-3-mcroce@linux.microsoft.com/
>>
>> When adding/changing this, we need to make sure that it doesn't overlap
>> member @index, because network stack use/check page_is_pfmemalloc().
>> As far as my calculations this is safe to add.  I always try to keep an
>> eye out for this, but I wonder if we could have a build check like yours.
>>
>>
>>>                          /**
>>>                           * @dma_addr: might require a 64-bit value even on
>>>                           * 32-bit architectures.
>>>                           */
>>> -                       dma_addr_t dma_addr;
>>> +                       dma_addr_t dma_addr __packed;
>>>                  };
>>>                  struct {        /* slab, slob and slub */
>>>                          union {
>>>
>>> but I don't know if GCC is smart enough to realise that dma_addr is now
>>> on an 8 byte boundary and it can use a normal instruction to access it,
>>> or whether it'll do something daft like use byte loads to access it.
>>>
>>> We could also do:
>>>
>>> +                       dma_addr_t dma_addr __packed __aligned(sizeof(void *));
>>>
>>> and I see pahole, at least sees this correctly:
>>>
>>>                  struct {
>>>                          long unsigned int _page_pool_pad; /*     4     4 */
>>>                          dma_addr_t dma_addr __attribute__((__aligned__(4))); /*     8     8 */
>>>                  } __attribute__((__packed__)) __attribute__((__aligned__(4)));
>>>
>>> This presumably affects any 32-bit architecture with a 64-bit phys_addr_t
>>> / dma_addr_t.  Advice, please?
>>
>> I'm not sure that the 32-bit behavior is with 64-bit (dma) addrs.
>>
>> I don't have any 32-bit boards with 64-bit DMA.  Cc. Ivan, wasn't your
>> board (572x ?) 32-bit with driver 'cpsw' this case (where Ivan added
>> XDP+page_pool) ?

Sry, for delayed reply.

The TI platforms am3/4/5 (cpsw) and Keystone 2 (netcp) can do only 32bit DMA even in case of LPAE (dma-ranges are used).
Originally, as I remember, CONFIG_ARCH_DMA_ADDR_T_64BIT has not been selected for the LPAE case
on TI platforms and the fact that it became set is the result of multi-paltform/allXXXconfig/DMA
optimizations and unification.
(just checked - not set in 4.14)

Probable commit 4965a68780c5 ("arch: define the ARCH_DMA_ADDR_T_64BIT config symbol in lib/Kconfig").

The TI drivers have been updated, finally to accept ARCH_DMA_ADDR_T_64BIT=y by using things like (__force u32)
for example.

Honestly, I've done sanity check of CPSW with LPAE=y (ARCH_DMA_ADDR_T_64BIT=y) very long time ago.

-- 
Best regards,
grygorii
