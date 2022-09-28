Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E218F5EE673
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiI1UNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiI1UNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:13:09 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CB5A6AEB;
        Wed, 28 Sep 2022 13:13:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id i203-20020a1c3bd4000000b003b3df9a5ecbso1990459wma.1;
        Wed, 28 Sep 2022 13:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=10t7BKsJhvVp+ktQziGfsMnwH37YwSSJBUjKC1VriSk=;
        b=WlSTvecDnP7Gc15LVIT0twe22jo/aUVeaUMHAQTffQ7CRDBEQIRmtNd7zMNSopbtEk
         8d/T1XmATTPrFyUnpTYeVz3Sj5bhop9EUHb7r6GNWgrWk4MVoYlObsekKjDsLIsyF9x7
         9LeKr12KaCYKNtMDlk5ySUTapfQUHmCIRojuAOE8P1CCQyfriPKIyMXzmfMfxtAls1U2
         6izpfMn2cqQ/t1ljxZBqeIsW23nCU+sNjmgZPssj1GoSyKO0B87PMIREC9N70R8uVSi8
         r7Lg7kWg4Fal9oiPCFujrLNQ3hM80mtCgNnqiAu0i308XzlTOayghCNmbXfHpAHQCjqb
         +NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=10t7BKsJhvVp+ktQziGfsMnwH37YwSSJBUjKC1VriSk=;
        b=N3ZgrkrmDv/2KOlZ/M2z3fAg4RuoBsMGkaEnBDpLnWLQygDUu0c3Mc7sTcIIPyCx6f
         G704PE2buwkWg2Ti3VBleK8n/2Tm6A/fG2GD8m9Aq1rRddFonqVVGsZbv92wPiEs+P/H
         /lQ78875ztoO7vT+2QhzYiyW+9aEHgIxfG4znTgB/756sw6HeNeK/qbZ01HSdfODTPQy
         HCq5EOoPDnF7U5Txv2GTAzstSWSsi+qX2FZLDvdvAnYMbu5mE2kIa5ikD42OnEAwYFNJ
         CU6DUNaJURtlpKChmJGYeCbI6FsMxUgaGsI2dJG/+LItImWLPU57o+l8uqMb8IqUMxFX
         Jrag==
X-Gm-Message-State: ACrzQf1IY8OwsKY+X4fVeCs+Umm05hS4NjsEk6yfeejiAKo7T8p7xl4Q
        tpFIThRN4sStB+czzX97dIs=
X-Google-Smtp-Source: AMsMyM6Gy0XdMLXZRr1ADyeALlD+vQmHs4sVLxXzqOKMQ0Ri8C3sWW+rn43kFg7gqYjQdXoc9ys4dA==
X-Received: by 2002:a7b:ce99:0:b0:3b4:9031:fc02 with SMTP id q25-20020a7bce99000000b003b49031fc02mr8352171wmj.154.1664395985334;
        Wed, 28 Sep 2022 13:13:05 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id s3-20020adff803000000b00228aea99efcsm1900938wrp.14.2022.09.28.13.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 13:13:04 -0700 (PDT)
Message-ID: <b9554bf1-9f48-b472-e15c-e850964aa108@gmail.com>
Date:   Wed, 28 Sep 2022 21:11:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
 <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
 <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
 <24b050e0-433f-dc97-7aab-15c9175f49fa@gmail.com>
 <3cccec37-ef58-cccb-7ab8-499ebfe133be@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3cccec37-ef58-cccb-7ab8-499ebfe133be@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 20:31, David Ahern wrote:
> On 9/26/22 1:08 PM, Pavel Begunkov wrote:
>> Tried it out, the branch below fixes a small problem, adds a couple
>> of extra optimisations and now it actually uses registered buffers.
>>
>>      https://github.com/isilence/iperf iou-sendzc
> 
> thanks for the patch; will it pull it in.
> 
>> Still, the submission loop looked a bit weird, i.e. it submits I/O
>> to io_uring only when it exhausts sqes instead of sending right
>> away with some notion of QD and/or sending in batches. The approach
>> is good for batching (SQ size =16 here), but not so for latency.
>>
>> I also see some CPU cycles being burnt in select(2). io_uring wait
>> would be more natural and perhaps more performant, but I didn't
>> spend enough time with iperf to say for sure.
> 
> ok. It will be a while before I have time to come back to it. In the
> meantime it seems like some io_uring changes happened between your dev
> branch and what was merged into liburing (compile worked on your branch
> but fails with upstream). Is the ZC support in liburing now?

It is. I forgot to put a note that I also adapted your patches
to uapi changes.No more notification slots but a zc send request
now can post a second CQE if IORING_CQE_F_MORE is set in the
first one. Better described in io_uring_enter(2) man, e.g.

https://git.kernel.dk/cgit/liburing/tree/man/io_uring_enter.2#n1063

-- 
Pavel Begunkov
