Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C96F1B46
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbjD1PPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjD1PPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:15:14 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2CE2109
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:15:12 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-32b27bf4499so1473875ab.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682694911; x=1685286911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KvymAYqQK8KafKPQ5ggpjpSP3LazlAMFXcBeQlY3Tv8=;
        b=v9IxTveS3HPmNDFvCE4PdJhCt4toAfvjEZHmytNPmIa3Tm64QwiVEScxyI1hdHU6FF
         eH4V3Hmcfch8d5rp5bxbizVx9JFdZQ5DMpeZvSuqnKZ6Wy/1pDhEj95DYpUW+cCkQPPJ
         ZR9b8KsQlfhtM7lVA/4ZuvuuMSdpJmXUC43fPEdRrnVMW6TVjqKOuvsEIUG68Vju0UyW
         bnTKYEAb6CEhsT9Jhlp2YGhJy5OqTb+UuHMS41JelIi5lxgjBN1fzOT4aSasCDIKKDTf
         l0Lx9nMuplJa1gY29e9SvXtEmd3ibLyo8w6epMBLhKibHnhlDzX8VkcpFriagsO4nMuL
         rdAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682694911; x=1685286911;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KvymAYqQK8KafKPQ5ggpjpSP3LazlAMFXcBeQlY3Tv8=;
        b=CIhCE7FsZEDFjID8QZseOUSJ7l1jUzucbkrEC5/EnTLYj01eaV9X5xogpWDUmN4cVU
         3Y4Piztz7FSceCP8CK28wpbQ8Yy07A0RqzHapn1H8lLoRpeom2E6N0LuJkF7tWv6x52+
         Rnaj/j79GcAFvs5CGHBjRGZJVcShEeOt05AUZAzKja8skhdQX69Xp3+HOX5Idyw42KAb
         GK+vnoZ6qExryvcjvj/Ei23NKPWd2WvJl7gOuzkMIaf59p2DBzvx9yGfnv21R2L85YtS
         k2r9imfd+OdX5Yg/2GXYGpiN+V0e2ceiqKRFjdT2rLrhSpb7vNCMayV0DyspxF3Azjjb
         yR3g==
X-Gm-Message-State: AC+VfDy7i55GjST9jHGj+yRYHCGGgxdPoSos1kSj6+29HqIqBZ7T4qh4
        RAIDnn+KBBgQsHgvBlo/BPiCXg==
X-Google-Smtp-Source: ACHHUZ7hkEKonWLs0qWMkb0o+prXhuaF3QWK2pa6XoVDvYzAG0Ws5Agj+FneE7A1Jf5T+LYM0qMG6w==
X-Received: by 2002:a05:6e02:1be4:b0:32a:a8d7:f099 with SMTP id y4-20020a056e021be400b0032aa8d7f099mr1824171ilv.3.1682694911349;
        Fri, 28 Apr 2023 08:15:11 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x7-20020a92dc47000000b0032f493364c1sm697858ilq.52.2023.04.28.08.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 08:15:10 -0700 (PDT)
Message-ID: <447d0270-9c0e-23f4-3c62-33c3eff325af@kernel.dk>
Date:   Fri, 28 Apr 2023 09:15:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
 <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/23 9:13?AM, David Hildenbrand wrote:
>>> I know, Jason und John will disagree, but I don't think we want to be very
>>> careful with changing the default.
>>>
>>> Sure, we could warn, or convert individual users using a flag (io_uring).
>>> But maybe we should invest more energy on a fix?
>>
>> This is proactively blocking a cleanup (eliminating vmas) that I believe
>> will be useful in moving things forward. I am not against an opt-in option
>> (I have been responding to community feedback in adapting my approach),
>> which is the way I implemented it all the way back then :)
> 
> There are alternatives: just use a flag as Jason initially suggested
> and use that in io_uring code. Then, you can also bail out on the
> GUP-fast path as "cannot support it right now, never do GUP-fast".

Since I've seen this brougth up a few times, what's the issue on the
io_uring side? We already dropped the special vma checking, it's in -git
right. Hence I don't believe there are any special cases left for
io_uring at all, and we certainly don't allow real file backings either,
never have done.

-- 
Jens Axboe

