Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77F269602D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjBNKDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjBNKDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:03:03 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DEE25B8B;
        Tue, 14 Feb 2023 02:01:20 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id a2so15024551wrd.6;
        Tue, 14 Feb 2023 02:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+4q5IkASDXEOzqDRgEB04f5mJrlc9Cp/e1e4SAOKD0=;
        b=JUM0SIjv/72hQQRAQcJyDNCQ+whnUbXuUfkRtOqQWv0Wz4R6k0t1cGlgWxbhb0wn7I
         YZJxg//qBfff23n9zLIgbcyDGqGlT98jge8I6tEwphEVFPsOBBsXqJkMksVYZwP95rpf
         NaHQg3o5aXedIUOEQzCikdlnXpW1f+dGHX5w9KyMpOYOCJvc/M6j1m8gAST/lDMKeLjf
         sQP+UhiMwtYLmfL8HtZ7M2lSmbQiBCyOc6Z3ZwMZESBdCbRjAzkNoESTawrLCDkpJMwL
         gQYmTkihdlEDN3/ixLlUvepGGDov4UaWjGVJWNFieGXsN3wryy4joA1ClVDCiPCW1q0i
         EeBw==
X-Gm-Message-State: AO0yUKUx6MICgfCkstSucoRknxRwS9lB6va3ayu+rIvDfXOJ3jeKuvDI
        8FzKQAolAZaP6c/avWb2fSg=
X-Google-Smtp-Source: AK7set/Xt318zL6GpRHvNDie0q0HDZBwJM0D3FvTdggCnwo+e1rq7L2KeAk+JzfimJ/dU2UHVJJwgA==
X-Received: by 2002:a5d:6045:0:b0:2c5:60e2:ed68 with SMTP id j5-20020a5d6045000000b002c560e2ed68mr1150417wrt.0.1676368878424;
        Tue, 14 Feb 2023 02:01:18 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id x8-20020adfdd88000000b002c5691f13eesm634637wrl.50.2023.02.14.02.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 02:01:17 -0800 (PST)
Message-ID: <c3c636b4-b46b-ddab-6446-bc55349a96e3@grimberg.me>
Date:   Tue, 14 Feb 2023 12:01:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <20230118073654.GC27048@lst.de>
 <ac48766a-b861-4fc0-3171-7b23f175c672@nvidia.com>
 <20230130123505.GA19948@lst.de>
 <e8c35d5d-d855-a38c-2f3b-6887df208360@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <e8c35d5d-d855-a38c-2f3b-6887df208360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> Today, if one would like to run both features using a capable device 
>>> then
>>> the PI will be offloaded (no SW fallback) and the Encryption will be 
>>> using
>>> SW fallback.
>> It's not just running both - it's offering both as currently registering
>> these fatures is mutally incompatible.
> 
> For sure we would like to offer both, but as mentioned before, this will 
> require blk layer instrumentation and ib_core instrumentation to some 
> pipeline_mr or something like that.

Can you explain what is needed in the block layer that prevents queueing
a request that has PI and crypto ctx?

As for the rdma portion, I don't know enough if this is something
that is supported by the HW and lacks a SW interface, or inherently
unsupported in HW...
