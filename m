Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB296593076
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242739AbiHOOK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiHOOKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:10:54 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5986265F;
        Mon, 15 Aug 2022 07:10:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id s23so3891916wmj.4;
        Mon, 15 Aug 2022 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9Ly9QT+qhOGC59U1DUD2uSyTYH7l3lh3lsWLdiMn2B4=;
        b=Q+VAsP/zUox4R9ZtptQ9CPO6SOOuZwy8gTu5/HHaCgbJ9A8PeOmomNu7touZ1YwZia
         Xq5yddwVTi8VkFcCWisz6W83zI0FiUgSYAGJ34HGf8mpsFzF1wt54zJpK0Isn93GeKyL
         rZELMT8OZ7CTBP5i8dcM9jjg5DNeHPvb8cgU9r1PLOmQWqDBWg9Vg747ZtGXOVd8Zf6J
         m0TdDdoO1C8fbI4n/7sYXU55a1wk7Qg72aaPWyuS51bIc5tQPwTduCNP4aJI9uj22MKD
         pGASvHTORMkmtZskX809CrNRLRScUaEgdcgMF3efYrXyRDPfLgpdg6/1uXjw1P5YQEdf
         4kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9Ly9QT+qhOGC59U1DUD2uSyTYH7l3lh3lsWLdiMn2B4=;
        b=l9be95TpxD5cXyVoe7lBFQpKk4kHqwALtj86RSmf8lRpYwUkvenmvdTdVsyn2MrIEr
         P94e+MpbnvHHrlMZ9o+Q2ks3pKfvr76NMNCEYPWjc7pXB2AwWF3ce58jcHwTL8bGk42o
         7e5SxeG4Z8zeCp8MEi4t+iiL0OyF1wPVYC1EpLMliIhKl3JLtFloTsORSi+nqG0R5w1a
         HWna24BoUzDtW2ZKDhMlOsjQfRa6Xenu0HC8lvJ2zt0OGAa6wkVbuRVOFsRMqyyhlfql
         F2jYcUBSEW9SUb9QldTU0Wt5y0cEdjjFlflnEMJB2RWYoaYMufPtI5CVyKyiTSzJw3dE
         6YTg==
X-Gm-Message-State: ACgBeo2EdRaZcP6nnO+WmStagvzBQGi6sVRz85EG9RMHpi7n3gkmy2KI
        TRM9UIvnkrg23BgHndR8qXc=
X-Google-Smtp-Source: AA6agR5UeqRKuFdjj0gviU/Icyv3O78DXsXSkCw56ypPklVO6ZoNvUoWSyVDG5++50iTIPaUUsFReQ==
X-Received: by 2002:a1c:ed19:0:b0:3a5:4fb5:bcd6 with SMTP id l25-20020a1ced19000000b003a54fb5bcd6mr15839364wmh.100.1660572652336;
        Mon, 15 Aug 2022 07:10:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id n21-20020a05600c4f9500b003a5f3f5883dsm4713146wmq.17.2022.08.15.07.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 07:10:51 -0700 (PDT)
Message-ID: <66945bc6-e567-b5a8-9b4d-2b620cf1bdc5@gmail.com>
Date:   Mon, 15 Aug 2022 15:09:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
 <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
 <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
 <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
 <db7bbfcd-fdd0-ed8e-3d8e-78d76f278af8@gmail.com>
 <246ef163-5711-01d6-feac-396fc176e14e@samba.org>
 <9edd5970-504c-b088-d2b1-3a2b7ad9b345@gmail.com>
 <f8ec9b9e-80b5-a24f-eb12-4069b7b90bea@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f8ec9b9e-80b5-a24f-eb12-4069b7b90bea@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/22 14:30, Stefan Metzmacher wrote:
[...]
>>> that causes io_ring_exit_work() to wait for it.> It would be great if you or someone else could explain this in detail
>>> and maybe adding some comments into the code.
>>
>> Almost, the mechanism is absolutely the same as with requests,
>> and notifiers are actually requests for internal purposes.
>>
>> In __io_alloc_req_refill() we grab ctx->refs, which are waited
>> for in io_ring_exit_work(). We usually put requests into a cache,
>> so when a request is complete we don't put the ref and therefore
>> in io_ring_exit_work() we also have a call to io_req_caches_free(),
>> which puts ctx->refs.
> 
> Ok, thanks.
> 
> Would a close() on the ring fd block? I guess not, but the exit_work may block, correct?

Right, close doesn't block, it queues exit_work to get executed async.
exit_work() will wait for ctx->refs and then will free most of
io_uring resources.

> So a process would be a zombie until net released all references?

The userspace process will exit normally, but you can find a kernel
thread (kworker) doing the job.

-- 
Pavel Begunkov
