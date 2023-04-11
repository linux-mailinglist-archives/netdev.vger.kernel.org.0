Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418926DDEE8
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDKPGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjDKPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:06:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32C05277
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:06:47 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-75d1e0ff8ecso9366439f.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681225607; x=1683817607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OYepsyffP+bRFs4kNPAOND04VK6YGwmZGIYnadMN3s=;
        b=792+fXLP/FHebQi7o8brLl0/wf6r76sAIguiRhTgOJQQkkTZUSz2HXPDdehnQD2BML
         MKxNxOGQtl9Ov0M9/6nVS8ciEnwHF8Kwpf1ZxOKQf7IVL5JyVce7xSvCrH8e150s9xJl
         7aK2TWgnIj2y8ALm5hHYWgCkY+wUH5PYOLMX31BjhIH+BhDYBI5SrMTO13lyBURH+KW1
         8WQ3E2lE/y4aSrGllZyxOLENQBWX1nDBOtqqDrRvw7Vt7h1J3D9WCoX8K4VXFSsm4Zho
         tiDfoRsadNE+ikLKwxg4WKf66snOv3Whqzhju56oZJEofZoIOCDF7mtigLMU9gz2aIER
         7M8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681225607; x=1683817607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5OYepsyffP+bRFs4kNPAOND04VK6YGwmZGIYnadMN3s=;
        b=rdrzhT2DTN3cVXdkjvS54zYc6ov8++e9u4XfSMovCUHecHf7GWox0h5yQaa/pt5s32
         3BTNQrWAq9ZvJdbmDLtg6MVT9mOSETOqqm0OMXht+ZdfaPGMMfFQu5FJFD0mUF5RnTnu
         5kIQy0cjDqb6OUJPLpczijcuUS5xEBMnWKuYQWRKtPP1hM6YyqhHy9k/arOcNAtFldlQ
         BHMQCdoCMBdLXzTPpVgtIQTIbD+zeqO0LgRFaEgKzs/89Dg5eZkFPI5cqnGRvbTW6gSg
         asnsDlFq3q0Su98v47rY7NQIa6cRlvm8zfyjAEOV4y2w/acK/RGzMdeUmpkD1GlQ2CNu
         a1zw==
X-Gm-Message-State: AAQBX9eAuD+V5+RHA9H/ivxtFkk7sXkwbzZkOcPu5flnvGovbQP9eo0b
        Cgu9Nr1EBz3Uys7ZVaPRQZ6q5w==
X-Google-Smtp-Source: AKy350ZAFK23oTWxlt6R1NG+aT0+Hmhpij+N+kVIqD6SwGBSCEX384WUI1EZYpyAD9/oH3B0BsXLcw==
X-Received: by 2002:a05:6602:2d08:b0:758:9dcb:5d1a with SMTP id c8-20020a0566022d0800b007589dcb5d1amr6177264iow.2.1681225607059;
        Tue, 11 Apr 2023 08:06:47 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v8-20020a056602014800b007046e9e138esm3847948iot.22.2023.04.11.08.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 08:06:46 -0700 (PDT)
Message-ID: <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
Date:   Tue, 11 Apr 2023 09:06:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 9:00?AM, Willem de Bruijn wrote:
> Jens Axboe wrote:
>> On 4/11/23 8:51?AM, Willem de Bruijn wrote:
>>> Jens Axboe wrote:
>>>> On 4/11/23 8:36?AM, David Ahern wrote:
>>>>> On 4/11/23 6:00 AM, Breno Leitao wrote:
>>>>>> I am not sure if avoiding io_uring details in network code is possible.
>>>>>>
>>>>>> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
>>>>>> in the TCP case) could be somewhere else, such as in the io_uring/
>>>>>> directory, but, I think it might be cleaner if these implementations are
>>>>>> closer to function assignment (in the network subsystem).
>>>>>>
>>>>>> And this function (tcp_uring_cmd() for instance) is the one that I am
>>>>>> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
>>>>>> -> SIOCINQ.
>>>>>>
>>>>>> Please let me know if you have any other idea in mind.
>>>>>
>>>>> I am not convinced that this io_uring_cmd is needed. This is one
>>>>> in-kernel subsystem calling into another, and there are APIs for that.
>>>>> All of this set is ioctl based and as Willem noted a little refactoring
>>>>> separates the get_user/put_user out so that in-kernel can call can be
>>>>> made with existing ops.
>>>>
>>>> How do you want to wire it up then? We can't use fops->unlocked_ioctl()
>>>> obviously, and we already have ->uring_cmd() for this purpose.
>>>
>>> Does this suggestion not work?
>>
>> Not sure I follow, what suggestion?
>>
> 
> This quote from earlier in the thread:
> 
> I was thinking just having sock_uring_cmd call sock->ops->ioctl, like
> sock_do_ioctl.

But that doesn't work, because sock->ops->ioctl() assumes the arg is
memory in userspace. Or do you mean change all of the sock->ops->ioctl()
to pass in on-stack memory (or similar) and have it work with a kernel
address?

>>>> I do think the right thing to do is have a common helper that returns
>>>> whatever value you want (or sets it), and split the ioctl parts into a
>>>> wrapper around that that simply copies in/out as needed. Then
>>>> ->uring_cmd() could call that, or you could some exported function that
>>>> does supports that.
>>>>
>>>> This works for the basic cases, though I do suspect we'll want to go
>>>> down the ->uring_cmd() at some point for more advanced cases or cases
>>>> that cannot sanely be done in an ioctl fashion.
>>>
>>> Right now the two examples are ioctls that return an integer. Do you 
>>> already have other calls in mind? That would help estimate whether
>>> ->uring_cmd() indeed will be needed and we might as well do it now.
>>
>> Right, it's a proof of concept. But we'd want to support anything that
>> setsockopt/getsockopt would do. This is necessary so that direct
>> descriptors (eg ones that describe a struct file that isn't in the
>> process file table or have a regular fd) can be used for anything that a
>> regular file can. Beyond that, perhaps various things necessary for
>> efficient zero copy rx.
>>
>> I do think we can make the ->uring_cmd() hookup a bit more palatable in
>> terms of API. It really should be just a sub-opcode and then arguments
>> to support that. The grunt of the work is really refactoring the ioctl
>> and set/getsockopt bits so that they can be called in-kernel rather than
>> assuming copy in/out is needed. Once that is done, the actual uring_cmd
>> hookup should be simple and trivial.
> 
> That sounds like what I proposed above. That suggestion was only for
> the narrow case where ioctls return an integer. The general approach
> has to handle any put_user.

Right

> Though my initial skim of TCP, UDP and RAW did not bring up any other
> forms.
> 
> getsockopt indeed has plenty of examples, such as receive zerocopy.

-- 
Jens Axboe

