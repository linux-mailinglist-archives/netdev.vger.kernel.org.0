Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B874FECAE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiDMCDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiDMCDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:03:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BBE340E1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:01:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso551352pjf.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 19:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d+B7toDDnlhIXj0EwTtcGO+6X68xALKstEMS1mzMMHc=;
        b=IS+TmkGIXZSFsHvWky5utQ8zskIDVuCgau4myXbPCH7CNj0Xv8bGLqpTeA/Xb/4g6k
         AAVv4og6RRgTyjc9BuDhmEtx5DHA/EDU90kMZYeUvlawwNJ8A1BjP4+2/fmR8OP4rTHi
         nXGioksUIpJStU9I63Q/4bWVr9z87yjgd6vaWO+AoGxDOBIvhzfgFZRkFUeZCLwy/eO6
         2C65N9mQx7bCW5Tpp8wb5hZgs3rKm1vGQDpKg20ty+m+7swzNRFIloCp0UFaT7q/QJoR
         FMNs5XD1s7b7l5v2QhuIf5V5a1mYbpt6yKAUGBFv3ZW5DwhMpZRZtTQCLWNYaEg4+vfF
         32ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d+B7toDDnlhIXj0EwTtcGO+6X68xALKstEMS1mzMMHc=;
        b=T0H+ecSmdr0A5Q4vLb7SOLat2vaQhUQxyAkKZLsiFtaQhv1N9TcDuy+38/eNOdB9cA
         Ko0OVLtk6ti716YcBo+u7HJJuOzgg6lbCztbOeOh52yK+yJhqjwiedsPQSSRwXHGXKMY
         2eCQmSSwBBcDAgOhcL5lOwH2w/JK4AFf5pbTfCvHO9sR5ql4btPIiH6jMeITF5BeCWVJ
         8aSoU+amPcqIJER3fyy63xyv+QMaPlWRPLs7q0DMO+k8xfTTcU+hn3vYho+Gp5xVpQbL
         GrJd0h3qttOPuouS0MDiRBuQJ8Wffn2QGVvNMWHv8Xs+skzsIu112Goi7Btm3RVgFcqE
         wUKA==
X-Gm-Message-State: AOAM533ako/8NLXMU0K3R2sRtcZvRl2stALdDFyUYIZTWM0rGkDG41/Z
        NhjezMKPV08al/haIMy/mrdfmA==
X-Google-Smtp-Source: ABdhPJw6+cpbQ05rIVDSFOFR7lt/U5Sc/aUvJzWG68uTzGNYqmhXV3n+94h27SDdK/mRbwQt3rPYEw==
X-Received: by 2002:a17:902:7795:b0:157:c50:53a6 with SMTP id o21-20020a170902779500b001570c5053a6mr28147892pll.40.1649815272344;
        Tue, 12 Apr 2022 19:01:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k8-20020aa790c8000000b00505d6016097sm6597370pfk.94.2022.04.12.19.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 19:01:11 -0700 (PDT)
Message-ID: <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk>
Date:   Tue, 12 Apr 2022 20:01:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
References: <20220412202613.234896-1-axboe@kernel.dk>
 <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk>
 <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/22 7:54 PM, Eric Dumazet wrote:
> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
>>>
>>> On 4/12/22 13:26, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> If we accept a connection directly, eg without installing a file
>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
>>>> we have a socket for recv/send that we can fully serialize access to.
>>>>
>>>> With that in mind, we can feasibly skip locking on the socket for TCP
>>>> in that case. Some of the testing I've done has shown as much as 15%
>>>> of overhead in the lock_sock/release_sock part, with this change then
>>>> we see none.
>>>>
>>>> Comments welcome!
>>>>
>>> How BH handlers (including TCP timers) and io_uring are going to run
>>> safely ? Even if a tcp socket had one user, (private fd opened by a
>>> non multi-threaded program), we would still to use the spinlock.
>>
>> But we don't even hold the spinlock over lock_sock() and release_sock(),
>> just the mutex. And we do check for running eg the backlog on release,
>> which I believe is done safely and similarly in other places too.
> 
> So lets say TCP stack receives a packet in BH handler... it proceeds
> using many tcp sock fields.
> 
> Then io_uring wants to read/write stuff from another cpu, while BH
> handler(s) is(are) not done yet,
> and will happily read/change many of the same fields

But how is that currently protected? The bh spinlock is only held
briefly while locking the socket, and ditto on the relase. Outside of
that, the owner field is used. At least as far as I can tell. I'm
assuming the mutex exists solely to serialize acess to eg send/recv on
the system call side.

Hence if we can just make the owner check/set sane, then it would seem
to be that it'd work just fine. Unless I'm still missing something here.

> Writing a 1 and a 0 in a bit field to ensure mutual exclusion is not
> going to work,
> even with the smp_rmb() and smp_wmb() you added (adding more costs for
> non io_uring users
> which already pay a high lock tax)

Right, that's what the set was supposed to improve :-)

In all fairness, the rmb/wmb doesn't even measure compared to the
current socket locking, so I highly doubt that any high frequency TCP
would notice _any_ difference there. It's dwarfed by fiddling the mutex
and spinlock already.

But I agree, it may not be 100% bullet proof. May need actual bitops to
be totally safe. Outside of that, I'm still failing to see what kind of
mutual exclusion exists between BH handlers and a system call doing a
send or receive on the socket.

> If we want to optimize the lock_sock()/release_sock() for common cases
> (a single user thread per TCP socket),
> then maybe we can play games with some kind of cmpxchg() games, but
> that would be a generic change.

Sure, not disagreeing on that, but you'd supposedly still need the mutex
to serialize send or receives on the socket for those cases.

-- 
Jens Axboe

