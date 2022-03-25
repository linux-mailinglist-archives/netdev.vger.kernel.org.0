Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC504E7465
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356928AbiCYNqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352215AbiCYNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:46:18 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A66866230;
        Fri, 25 Mar 2022 06:44:43 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id u16so10960331wru.4;
        Fri, 25 Mar 2022 06:44:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kl2Li9Z++CqTUC0lFLJ2VWDkw/259+VgBxfob6qn0zM=;
        b=z1MTAtIH2+7E8+Lcw0A8nK0YRQjl/BmfoxANv+FNRy7PA5A/OYSXsmFTld3inzNGB5
         9JjZaIyqGOg/83/mYMN9yrx9jkrltygH+Hd0LPvIz+8EyCn5nJq9Wn3Xd+7tYVOixRM6
         +S5gsa4bmTQLZ0DiMF+Hj2hY3vSw7m08IhuH4e7UOr1sAqIsxSi5pJ2jowYaUxAxjMVM
         HILY59TKB/phILU4nrNAu+69/Qbq6wFf9V2ZOOgKXEj1T1sLYuufkM/ZcCWYfsMg4VqY
         hic7/GI4lXJ+9TCGk7sZraCF/h14Pzzksab8vyKFHahgVoMRnFvpB6U0j0tz17Nz+agD
         fH3Q==
X-Gm-Message-State: AOAM533i6TlFh5AxbsAbHD5tpLf0L0fB330Ka4KORBLxHnr9Alq3ok9p
        zIuA1LD1cH9I/oxLRwJlF74=
X-Google-Smtp-Source: ABdhPJyY3wUgcYloufU4hlto44Bj2E0GeWFQeH2zowBSPUGINM50QEh6VWnApasWISFuX5BW6KsdRA==
X-Received: by 2002:adf:eb89:0:b0:1e4:b8f4:da74 with SMTP id t9-20020adfeb89000000b001e4b8f4da74mr9603386wrn.408.1648215882150;
        Fri, 25 Mar 2022 06:44:42 -0700 (PDT)
Received: from [10.100.102.14] (85.65.206.129.dynamic.barak-online.net. [85.65.206.129])
        by smtp.gmail.com with ESMTPSA id e8-20020a056000178800b00203da3bb4d2sm5945955wrg.41.2022.03.25.06.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:44:40 -0700 (PDT)
Message-ID: <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
Date:   Fri, 25 Mar 2022 16:44:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Content-Language: en-US
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
References: <20220311103414.8255-1-sunmingbao@tom.com>
 <20220311103414.8255-2-sunmingbao@tom.com>
 <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
 <20220325201123.00002f28@tom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220325201123.00002f28@tom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/22 15:11, Mingbao Sun wrote:
>> 1. Can you please provide your measurements that support your claims?
> 
> Yes. I would provide a series of the testing result.
> In the bottom of this mail, I would provide the first one.
> 
>>
>> 2. Can you please provide a real, existing use-case where this provides
>> true, measureable value? And more specifically, please clarify how the
>> use-case needs a local tuning for nvme-tcp that would not hold for
>> other tcp streams that are running on the host (and vice-versa).
>>
> 
> As for the use-case.
> I think multiple NVMe/TCP hosts simultaneously write data to a single target
> is a much common use-case.
> And this patchset just addresses the performance issue of this use-case.

Thanks Mingbao,

Long email, haven't read it all yet.

But this doesn't answer my specific question. I was asking why should
the tcp congestion be controlled locally to nvme. You could just as
easily change these knobs via sysctl and achieve the expected result
that dctcp handles congestion better than cubic (which was not even
testing nvme btw).

As I said, TCP can be tuned in various ways, congestion being just one
of them. I'm sure you can find a workload where rmem/wmem will make
a difference.

In addition, based on my knowledge, application specific TCP level
tuning (like congestion) is not really a common thing to do. So why in
nvme-tcp?

So to me at least, it is not clear why we should add it to the driver.
