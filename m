Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D9C6DDFB6
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDKP30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjDKP3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:29:23 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF79525E
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:29:17 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7606d7ca422so4687239f.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681226956; x=1683818956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LY7YABVANJBpnoGShMcSEGz2zmHaSs72D2YD+dvEB/o=;
        b=ZWrZYfxohRGNPyYVlwzZUd5gQvb0wTWEee+Sxa0LCjDgo/Nx9goOCVGN1ZhnS2P0jL
         i5DPkiH3Puod6ziLgypR/OS5UxpWT2TBfaSCSpCF+tHebPCFT7ESdPLULIunYzFtzNW/
         k31xn+gNlN+5maMjymgBg5DTnosmu/WZnPXv5IgkBgn/BI2t4I5B+vC9/zSJIQS67DbX
         HjtA/YuQ3zHqcqjx9MTEwJMU0YbMKcVmB/gJMBfo+kMTvxVMGOdinj5BHkVRobw1fnH6
         YAPqyTXFdGmroG0hI2ZCyRs4Va2oHUoCSrVqj4IGVYvCyByZSsFDcrIuCEqU3odnT9Tw
         qw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681226956; x=1683818956;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LY7YABVANJBpnoGShMcSEGz2zmHaSs72D2YD+dvEB/o=;
        b=0P1yPH7QAXUNAHGMuF8Dd8ZRnB8aVR9yYP483Rjl1vY3F2bCsGxjw4m/571JougOuq
         Wr/xwFi3Rey+xG/c7qCVAaHItHtBodHgGGJ1l361UG8OqeFXc3Lot12GzfrnE+LZvF1w
         z43YxSVqS9eaaVcsKRkW89c7kqvuxcFaikIHpLoxFuCLy1y7mNaA54souinRL/SYyvsC
         rxZmUZZapDIF/14BfCmHtMvtmeDv3i/TGgI3vrPkH8rWbaqwm09H8kvl/2FWbUFg+kfG
         z6RACGew5e+tlFu+VirRkfMOusm2rQYB0xMdRrrX1q11cWluir7xxkUrcuPtlesBX8rJ
         9Bsw==
X-Gm-Message-State: AAQBX9e5QMrCY/HpfX+dWapRSD/NVOG7YCDdSUEEy6SfASX4FLf1FNWL
        AjVRntHy9EulLJuDGvh6pIe55A==
X-Google-Smtp-Source: AKy350YTQzwtVs+fobpu4VlZXmN6QjQ8Crt7xuEhF8qtkl8AUI5eJ6G7pwRhzeqzoKUNI7xlvPDHKg==
X-Received: by 2002:a05:6602:2d08:b0:758:9dcb:5d1a with SMTP id c8-20020a0566022d0800b007589dcb5d1amr6232653iow.2.1681226956457;
        Tue, 11 Apr 2023 08:29:16 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h35-20020a05663833a300b0040bce6160e1sm1554966jav.12.2023.04.11.08.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 08:29:16 -0700 (PDT)
Message-ID: <78abce6b-709b-7309-2ee1-5370d05748b6@kernel.dk>
Date:   Tue, 11 Apr 2023 09:29:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
 <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
 <67831406-8d2f-feff-f56b-d0f002a95d96@kernel.dk>
 <ea36790d-b2fe-0b4d-1bfc-be7b20b1614b@kernel.org>
 <b56c03b3-d948-2fdf-bc5d-635ecfdf1592@kernel.dk>
 <a9858183-8f69-7aff-51ac-122f627ba66f@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a9858183-8f69-7aff-51ac-122f627ba66f@kernel.org>
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

On 4/11/23 9:27?AM, David Ahern wrote:
> On 4/11/23 9:17 AM, Jens Axboe wrote:
>> On 4/11/23 9:10?AM, David Ahern wrote:
>>> On 4/11/23 8:41 AM, Jens Axboe wrote:
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
>>>>
>>>> I do think the right thing to do is have a common helper that returns
>>>> whatever value you want (or sets it), and split the ioctl parts into a
>>>> wrapper around that that simply copies in/out as needed. Then
>>>> ->uring_cmd() could call that, or you could some exported function that
>>>> does supports that.
>>>>
>>>> This works for the basic cases, though I do suspect we'll want to go
>>>> down the ->uring_cmd() at some point for more advanced cases or cases
>>>> that cannot sanely be done in an ioctl fashion.
>>>>
>>>
>>> My meta point is that there are uapis today to return this information
>>> to applications (and I suspect this is just the start of more networking
>>> changes - both data retrieval and adjusting settings). io_uring is
>>> wanting to do this on behalf of the application without a syscall. That
>>> makes io_uring yet another subsystem / component managing a socket. Any
>>> change to the networking stack required by io_uring should be usable by
>>> all other in-kernel socket owners or managers. ie., there is no reason
>>> for io_uring specific code here.
>>
>> I think we are in violent agreement here, what I'm describing is exactly
>> that - it'd make ioctl/{set,get}sockopt call into the same helpers that
>> ->uring_cmd() would, with the only difference being that the former
>> would need copy in/out and the latter would not.
>>
>> But let me just stress that for direct descriptors, we cannot currently
>> call ioctl or set/getsockopt. This means we have to instantiate a
>> regular descriptor first, do those things, then register it to never use
>> the regular file descriptor again. That's wasteful, and this is what we
>> want to enable (direct use of ioctl set/getsockopt WITHOUT a normal file
>> descriptor). It's not just for "oh it'd be handy to also do this from
>> io_uring" even if that would be a worthwhile goal in itself.
>>
> 
> Christoph's patch set a few years back that removed set_fs broke the
> ability to do in-kernel ioctl and {s,g}setsockopt calls. I did not
> follow that change; was it a deliberate intent to not allow these
> in-kernel calls vs wanting to remove the set_fs? e.g., can we add a
> kioctl variant for in-kernel use of the APIs?

I think it'd be much better to cleanly split it out rather than try and
hack around it.

-- 
Jens Axboe

