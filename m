Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51E39DAE7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhFGLQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhFGLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:16:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F447C061766;
        Mon,  7 Jun 2021 04:14:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ci15so25969390ejc.10;
        Mon, 07 Jun 2021 04:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ACEmrf8lqyzWj1iuROjfn+lhLVzwVCH6LojGY7H628=;
        b=RCl/z9d6IftfWrwk+FiDXEW1F4Mn9b/AoqsKhGfflCHlNXvTJ9X7vqkXg7AnJ4pOOj
         o/VpRMuHVuKIdT8beFckHMwzGGwmrDRVwOdiVBRZjJqi5gxGjx3g38TBe1oKxBflbWZp
         LWb8CbXm1Mgz/28+iLRyJSNOFEES4p4Pr52NVOdG5nMToeDwr0OIOk1w1ZyuICd8bfDF
         XmKNvV5HZ2rWQoWxLsZLnFUxv4He3otR1Q1dek1YAyT9p/ugydwXu5LNCSqtL1nFkGj5
         Tl+eUz5HV2mC+qj3eljITRiR9G34f9AcVuOys+Zq/0jiHeNanhlG841eL8H6JN2haIiS
         Qybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ACEmrf8lqyzWj1iuROjfn+lhLVzwVCH6LojGY7H628=;
        b=bS6GUXaJt2Snb0E7YJJhRL1WGjBD4FDBfQH7TQ0JqUcWupqS4rjzE192O/3K3OKv9x
         ZbFAVBbz5z+1wwpd/Ogz2uDuVvwUIVoalC6yHi4a4H4Bmi41prWFZSVfh0vZ0YtUak8T
         ao8gArxVsvtT/LCAMkZWTxjGUs8nZfJ4HgAE1S+A50/uj2nPmIuUU5VX2gw8rM42Hyny
         nV4CXL0snewABpZcsmyduWecOiT4FJNykPwpxGfl0ZPMxC/dm2FXf1Ro4FZ28WwIiM6n
         nyBXflu3utG7/0dfV9rd0LdBFHnE2oBeymkV3Q0YohmywQFK/suJ4tkHf3dB/HFbORwX
         YHtQ==
X-Gm-Message-State: AOAM53193lFqXeXXb/0J1N/xnTERR7onPRo+iIEU6ZwmIUYqJtyGdvky
        GQ7Xy6rILg8ToMY3ZtVuXa8=
X-Google-Smtp-Source: ABdhPJzNG5U7CaGFJ2FroWgLRHUbZCTGdl28A+OP49yMVYxN4U/jR63PAV3SoCKJ/2fQz9vRC40ZsA==
X-Received: by 2002:a17:906:9713:: with SMTP id k19mr17643598ejx.516.1623064455283;
        Mon, 07 Jun 2021 04:14:15 -0700 (PDT)
Received: from [10.80.22.114] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id n15sm6383140ejz.36.2021.06.07.04.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 04:14:14 -0700 (PDT)
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB
 recycling
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>,
        David Ahern <dsahern@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
 <20210521161527.34607-4-mcroce@linux.microsoft.com>
 <badedf51-ce74-061d-732c-61d0678180b3@huawei.com>
 <YLnnaRLMlnm+LKwX@iliass-mbp>
 <722e5567-d8ee-228c-978e-9d5966257bb1@gmail.com>
 <CAFnufp3rWwFgknBUBy9mHB36zpTKRiTeUAFeJXKVvp2DzvG3bw@mail.gmail.com>
 <63a4ea45-9938-3106-9eda-0f7e8fe079ce@gmail.com>
 <YL2i0wcXcqluttNx@Iliass-MBP>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <cacde7b2-6bc4-bd30-8cd3-6f802c737ce5@gmail.com>
Date:   Mon, 7 Jun 2021 14:14:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YL2i0wcXcqluttNx@Iliass-MBP>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 7:38 AM, Ilias Apalodimas wrote:
> Hi Tariq,
> 
>>>>>
>>>>> Yes the comment is there to prohibit people (mlx5 only actually) to add the
>>>>> recycling bit on their driver.  Because if they do it will *probably* work
>>>>> but they might get random corrupted packets which will be hard to debug.
>>>>>
>>>>
>>>> What's the complexity for getting it to work with split page model?
>>>> Since 1500 is the default MTU, requiring a page per packet means a lot
>>>> of wasted memory.
>>>
>>> We could create a new memory model, e.g. MEM_TYPE_PAGE_SPLIT, and
>>> restore the behavior present in the previous versions of this serie,
>>> which is, save xdp_mem_info in struct page.
>>> As this could slightly impact the performances, this can be added in a
>>> future change when the drivers which are doing it want to use this
>>> recycling api.
>>>
>>
>> page-split model doesn't only help reduce memory waste, but increase
>> cache-locality, especially for aggregated GRO SKBs.
>>
>> I'm looking forward to integrating the page-pool SKB recycling API into
>> mlx5e datapath. For this we need it to support the page-split model.
>>
>> Let's see what's missing and how we can help making this happen.
> 
> Yes that's the final goal.  As I said I don't think adding the page split
> model will fundamentally change the current patchset.  So imho we should
> get this in first, make sure that everything is fine, and then add code for
> the mlx cards.
> 

Sounds good
