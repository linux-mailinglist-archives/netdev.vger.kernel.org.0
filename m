Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA547C3CA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhLUQaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbhLUQaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:30:08 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52365C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 08:30:08 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x6so18254581iol.13
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 08:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7sxBQCeGbgjg8hdOqmzJbuJh118tuNeNWeBKOPnBuj4=;
        b=rM9txxh7bVyOpYeNcdnZq54+VIKIAdv3C2Uk5i2GQHXci67nad8NG1VDX7GftZ34a4
         9kTd49eJXYwM5buP3S28M0gwynJO8BYyHxGt1eIXuyD/4LmYYqSevnocjs+dLT47gIH8
         CpC7lfe+pjRjxTzjbUP4BtWNJ8lPsB3tr/qMaSjF93hrNPMbRptcp/6dp+hHHHDxDGfj
         7pOrkIN9UQzA3G21lFS4Fh6ItJK8ytCftF0jhRoceLXU8Wj71bbhlcpORzudbjBebTL1
         uRM+u3ZJgB8Y86UOz4M1XPPodXoJ9x7L+ayWis/6168qL30F5ZLuWdZlQzaxpbGXRYC7
         ynQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7sxBQCeGbgjg8hdOqmzJbuJh118tuNeNWeBKOPnBuj4=;
        b=Ds36WdABFAWTGLx0DgbjqXiWVeOnGfn33CHqveuV0eM53DN5MmZoS/uMVLibYTNQSl
         RmHHx+t7RrblI/D/egA7zhN/Hh5/n7VzH+rckPKAFtx5pGmPOHtghyIPVhDpzmh8BvIZ
         HLJOFL7PcR7KDRlA242kEDEzl+qlEB0BKHNjSg8Fs2iuf2AzAmTqHJGrt5V4P7h3JOyk
         wGEl7K/C2VS9Kgc5XWZzwAH+X4PCfi6f9muUoqgGGr9IW129yZtsoi2oUSVHhnUbemQL
         +lbH1eCoOsaIihB3lAj07JWfj8FAnUuBFbaRtECpw3om4Y4UUuJGO7hyqIMsb/NH2LbZ
         43oA==
X-Gm-Message-State: AOAM531YrpD3UcPnh/iwygBJuUSNOrh1KLI3giRgiSsOT1bNuqf4ldFR
        dlr1c92cIVZJFhOYzCWJ1+fbeg==
X-Google-Smtp-Source: ABdhPJw2g4+qQmGEDfi6OpYTcH6TRPryOo0x8DjOmFSCt7NLQFDpv0qCcviUcJbXAr1pzpmSKSc4zQ==
X-Received: by 2002:a6b:f018:: with SMTP id w24mr2073095ioc.124.1640104207248;
        Tue, 21 Dec 2021 08:30:07 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f10sm4326211ilu.88.2021.12.21.08.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 08:30:06 -0800 (PST)
Subject: Re: [syzbot] general protection fault in set_task_ioprio
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+8836466a79f4175961b0@syzkaller.appspotmail.com>,
        Christoph Hellwig <hch@lst.de>, changbin.du@intel.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-block@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>
References: <000000000000c70eef05d39f42a5@google.com>
 <00000000000066073805d3a4f598@google.com>
 <CANn89i++5O_4_j3KO0wAiJHkEj=1zAeAHv=s9Lub_B6=cguwXQ@mail.gmail.com>
 <e3a30c8c-3f1a-47b5-57e7-1b456bbc8719@kernel.dk>
 <CANn89iJfEgkJCBqO9d7t9BHHMEh-6DQ1BJkqkiOQ59dxSHB2EQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4019677f-7225-c359-a411-e4290cc717b0@kernel.dk>
Date:   Tue, 21 Dec 2021 09:30:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJfEgkJCBqO9d7t9BHHMEh-6DQ1BJkqkiOQ59dxSHB2EQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/21 9:03 AM, Eric Dumazet wrote:
> On Tue, Dec 21, 2021 at 7:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/21/21 3:44 AM, Eric Dumazet wrote:
>>> On Tue, Dec 21, 2021 at 1:52 AM syzbot
>>> <syzbot+8836466a79f4175961b0@syzkaller.appspotmail.com> wrote:
>>>>
>>>> syzbot has bisected this issue to:
>>>>
>>>> commit e4b8954074f6d0db01c8c97d338a67f9389c042f
>>>> Author: Eric Dumazet <edumazet@google.com>
>>>> Date:   Tue Dec 7 01:30:37 2021 +0000
>>>>
>>>>     netlink: add net device refcount tracker to struct ethnl_req_info
>>>>
>>>
>>> Unfortunately this commit will be in the way of many bisections.
>>>
>>> Real bug was added in
>>>
>>> commit 5fc11eebb4a98df5324a4de369bb5ab7f0007ff7
>>> Author: Christoph Hellwig <hch@lst.de>
>>> Date:   Thu Dec 9 07:31:29 2021 +0100
>>>
>>>     block: open code create_task_io_context in set_task_ioprio
>>>
>>>     The flow in set_task_ioprio can be simplified by simply open coding
>>>     create_task_io_context, which removes a refcount roundtrip on the I/O
>>>     context.
>>>
>>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>     Reviewed-by: Jan Kara <jack@suse.cz>
>>>     Link: https://lore.kernel.org/r/20211209063131.18537-10-hch@lst.de
>>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> There are only really 5 patches in between the broken commit and the one
>> that fixes it, and it only affects things trying to set the ioprio with
>> a dead task. Is this a huge issue? I don't see why this would cause a
>> lot of bisection headaches.
>>
> 
> I was saying that my commit was polluting syzbot bisection, this is a
> distraction in this report.
> (Or if you prefer, please ignore syzbot bisection)

Ah got it, yes makes sense.

> linux-next has still this bug in set_task_ioprio()

linux-next often trails by a few days, once it catches up hopefully
this will be behind us.

-- 
Jens Axboe

