Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C950A6F4683
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbjEBO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbjEBO6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:58:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5602114
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 07:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683039434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15zhWnNnUv6N+Qv+v/91mVtnb9crmK+0j2EjkR4cdzk=;
        b=Xc4jVMrFEIZlA4y98rP50vEVhdXsloq8JE9RIRAee3nigY0L0IRLzgHfCLGfdQbyxOlQca
        qBK42ZaSbO8t8YX2wcdEghZJrQEu2TYymI0tXue1pCcL115XvcI9VkknzCoqEJKLGpty/K
        lF+oiGpeN4tRJJoBcm1sRmRiX8MmeeE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-VLAiXj1HNXS0YYdBxg_7vA-1; Tue, 02 May 2023 10:57:13 -0400
X-MC-Unique: VLAiXj1HNXS0YYdBxg_7vA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30629b36d9bso1010627f8f.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 07:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683039432; x=1685631432;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15zhWnNnUv6N+Qv+v/91mVtnb9crmK+0j2EjkR4cdzk=;
        b=SwhRSAoFGcaPArf6xiHzzFABi8MTB5+F9/HU7T1gNaA0G6EE8O0Jr5rJbR3gmi/d1E
         kgbECTdcorKGnmaIyY2EXwznzvgozn4v+86gAcvwtaPJSrLa7KAcnZteP3qAgV8c8qnm
         17BmgslsHqovKZoNw+ULNqmZcxAFwQ6cleALDohA+brdiyp60FwuKETWs4+DpKqpaKxU
         m2PYLYzelVd+D1rXVzDc3KXHWuJEeQwLfZW8x+Z/fUUEHFEvOrwhv9D7n/d3GCc8WPak
         Sx4Wr5ZpI3pwV5cCftBNiVEQgXy+4HJQmIwR+/x4A8ggdzt2Zi7hgeo3zufKUvH6kTjd
         +rXA==
X-Gm-Message-State: AC+VfDxFGkSolxSE38W6MJvkl40Ie3jNoh4LRKzcJS0JBXwznYIpoUgC
        sSi8Hc+H/fojzSU2VMeI24yyfqzjgT9Xmj2UknP7YydD97a9Y5ZnbIwI0QyP/YD7iDzau7m6Ax6
        hrG/7eHB/RlYVpDAd
X-Received: by 2002:adf:e582:0:b0:306:3382:721d with SMTP id l2-20020adfe582000000b003063382721dmr3300032wrm.38.1683039431958;
        Tue, 02 May 2023 07:57:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ475CGduIpgjlDxsGxpLL5lhRcGF08NepGsYJMzG5SoRIDtlUYjiVEpzVfjvt29SmQGLcE2OA==
X-Received: by 2002:adf:e582:0:b0:306:3382:721d with SMTP id l2-20020adfe582000000b003063382721dmr3299967wrm.38.1683039431553;
        Tue, 02 May 2023 07:57:11 -0700 (PDT)
Received: from ?IPV6:2003:cb:c700:2400:6b79:2aa:9602:7016? (p200300cbc70024006b7902aa96027016.dip0.t-ipconnect.de. [2003:cb:c700:2400:6b79:2aa:9602:7016])
        by smtp.gmail.com with ESMTPSA id b10-20020a5d550a000000b0030639a86f9dsm1577608wrv.51.2023.05.02.07.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 07:57:10 -0700 (PDT)
Message-ID: <203a8ed7-47fa-0830-c691-71d00517fecb@redhat.com>
Date:   Tue, 2 May 2023 16:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to
 file-backed mappings
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <651bfe55-6e2a-0337-d755-c8d606f5317e@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <651bfe55-6e2a-0337-d755-c8d606f5317e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.23 15:35, Matthew Rosato wrote:
> On 5/2/23 9:04 AM, Christian Borntraeger wrote:
>>
>>
>> Am 02.05.23 um 14:54 schrieb Lorenzo Stoakes:
>>> On Tue, May 02, 2023 at 02:46:28PM +0200, Christian Borntraeger wrote:
>>>> Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
>>>>> Writing to file-backed dirty-tracked mappings via GUP is inherently broken
>>>>> as we cannot rule out folios being cleaned and then a GUP user writing to
>>>>> them again and possibly marking them dirty unexpectedly.
>>>>>
>>>>> This is especially egregious for long-term mappings (as indicated by the
>>>>> use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
>>>>> we have already done in the slow path.
>>>>
>>>> Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
>>>> It would no longer work with file backed memory, correct?
>>>>
>>>> See
>>>> arch/s390/kvm/pci.c
>>>>
>>>> kvm_s390_pci_aif_enable
>>>> which does have
>>>> FOLL_WRITE | FOLL_LONGTERM
>>>> to
>>>>
>>>
>>> Does this memory map a dirty-tracked file? It's kind of hard to dig into where
>>> the address originates from without going through a ton of code. In worst case
>>> if the fast code doesn't find a whitelist it'll fall back to slow path which
>>> explicitly checks for dirty-tracked filesystem.
>>
>> It does pin from whatever QEMU uses as backing for the guest.
>>>
>>> We can reintroduce a flag to permit exceptions if this is really broken, are you
>>> able to test? I don't have an s390 sat around :)
>>
>> Matt (Rosato on cc) probably can. In the end, it would mean having
>>    <memoryBacking>
>>      <source type="file"/>
>>    </memoryBacking>
>>
>> In libvirt I guess.
> 
> I am running with this series applied using a QEMU guest with memory-backend-file (using the above libvirt snippet) for a few different PCI device types and AEN forwarding (e.g. what is setup in kvm_s390_pci_aif_enable) is still working.
> 

That's ... unexpected. :)

Either this series doesn't work as expected or you end up using a 
filesystem that is still compatible. But I guess most applicable 
filesystems (ext4, btrfs, xfs) all have a page_mkwrite callback and 
should, therefore, disallow long-term pinning with this series.

-- 
Thanks,

David / dhildenb

