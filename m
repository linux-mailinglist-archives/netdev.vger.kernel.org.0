Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6937C43D08E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240004AbhJ0SWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231530AbhJ0SWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635358812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fHL8U/ZQJJWFEflWR8JykfHUlV09wWEBVk/S1a/68vE=;
        b=ECo87Bvfrh9eq67uUcWa5iSTgtF6uxrbc9hDC2Ey7JMLUcyaXJp23w40gwuM51i4QvshPL
        XhDm5KWsaq3BoJBZAA8gkPHqqW6z3HPK2vvu/YMsDDt/S0p+HK3JUkHbsdIQE+KfA+jfsg
        uSZ28N38ZgA9li7BzIBj9nqpR/3pk6k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-v3yYHlvPOcSapPHg8swZcA-1; Wed, 27 Oct 2021 14:20:11 -0400
X-MC-Unique: v3yYHlvPOcSapPHg8swZcA-1
Received: by mail-wr1-f70.google.com with SMTP id m5-20020a5d56c5000000b00168861c65f9so1000533wrw.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 11:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=fHL8U/ZQJJWFEflWR8JykfHUlV09wWEBVk/S1a/68vE=;
        b=MTcOGrfhmov0w8lcnKxof+QcGG0LoLuzA3dSt3v4QF9AyyFoU51n0iL6QaTPBRpq7d
         M9XLNVKe2xPnRJ8LtxOyqXCgWnXFY69yN7Hi11CAZJLEbbHwfJTICXUcxINCW7v6YcJW
         S9376aBhu2nYlLCFAiB4Y0NyP8u1w5t0zuG/Yiw8BCD347Je81OD5X9knSOY9aaMz4Sp
         hrFnFdiL3wsmdr3PdOmvH2GMdx83ZRygtc0XzZ8SEWsZJzQbKXMkLRNy5Mu1CoEJhr5q
         kyNzRVkHKkOVQAIUPCgc9f/UReRtBh3ddboWiJOQqzV3dz0gotlK4jl3NjNWcSXJRFnx
         BZRQ==
X-Gm-Message-State: AOAM533Ti1G8ZGHT6hIeri2i8w0RfarrP6BZdTVh8T90G/kM3OjX9qfw
        Potg/kj1RlmuaRLbJlcyBes10oL5PnFod9zV5bNiDeSzfJFln/vj32c5vAE6MER+eDVcd8tDG9V
        iuxIOzzusXt1FxTDZ
X-Received: by 2002:a5d:614d:: with SMTP id y13mr43766546wrt.199.1635358810390;
        Wed, 27 Oct 2021 11:20:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywlSOhKpI8SvbmuEboOoMaeDgerhBBvtAQkWnNqvPZZpw6tCGPccHyjl4kAG23JmGd3fU5BA==
X-Received: by 2002:a5d:614d:: with SMTP id y13mr43766508wrt.199.1635358810124;
        Wed, 27 Oct 2021 11:20:10 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.14.190])
        by smtp.gmail.com with ESMTPSA id p18sm535005wmq.4.2021.10.27.11.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 11:20:09 -0700 (PDT)
Message-ID: <1c0652f7-bb1b-99e1-7e8b-0613cc764ddd@redhat.com>
Date:   Wed, 27 Oct 2021 20:20:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in copy_data
Content-Language: en-US
From:   Laurent Vivier <lvivier@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, jiri@nvidia.com,
        kuba@kernel.org, leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a4cd2105cf441e76@google.com>
 <eab57f0e-d3c6-7619-97cc-9bc3a7a07219@redhat.com>
 <CACT4Y+amyT9dk-6iVqru-wQnotmwW=bt4VwaysgzjH9=PkxGww@mail.gmail.com>
 <20211027111300-mutt-send-email-mst@kernel.org>
 <589f86e0-af0e-c172-7ec6-72148ba7b3b0@redhat.com>
 <8b5fb6ae-ab66-607f-b7c8-993c483846ca@redhat.com>
In-Reply-To: <8b5fb6ae-ab66-607f-b7c8-993c483846ca@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:03, Laurent Vivier wrote:
> On 27/10/2021 18:25, Laurent Vivier wrote:
>> On 27/10/2021 17:28, Michael S. Tsirkin wrote:
>>> On Wed, Oct 27, 2021 at 03:36:19PM +0200, Dmitry Vyukov wrote:
>>>> On Wed, 27 Oct 2021 at 15:11, Laurent Vivier <lvivier@redhat.com> wrote:
>>>>>
>>>>> On 26/10/2021 18:39, syzbot wrote:
>>>>>> Hello,
>>>>>>
>>>>>> syzbot found the following issue on:
>>>>>>
>>>>>> HEAD commit:    9ae1fbdeabd3 Add linux-next specific files for 20211025
>>>>>> git tree:       linux-next
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1331363cb00000
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=aeb17e42bc109064
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for 
>>>>>> Debian) 2.35.2
>>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116ce954b00000
>>>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132fcf62b00000
>>>>>>
>>>>>> The issue was bisected to:
>>>>>>
>>>>>> commit 22849b5ea5952d853547cc5e0651f34a246b2a4f
>>>>>> Author: Leon Romanovsky <leonro@nvidia.com>
>>>>>> Date:   Thu Oct 21 14:16:14 2021 +0000
>>>>>>
>>>>>>       devlink: Remove not-executed trap policer notifications
>>>>>>
>>>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=137d8bfcb00000
>>>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10fd8bfcb00000
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=177d8bfcb00000
>>>>>>
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>> Reported-by: syzbot+b86736b5935e0d25b446@syzkaller.appspotmail.com
>>>>>> Fixes: 22849b5ea595 ("devlink: Remove not-executed trap policer notifications")
>>>>>>
>>>>>> ==================================================================
>>>>>> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:225 [inline]
>>>>>> BUG: KASAN: slab-out-of-bounds in copy_data+0xf3/0x2e0 
>>>>>> drivers/char/hw_random/virtio-rng.c:68
>>>>>> Read of size 64 at addr ffff88801a7a1580 by task syz-executor989/6542
>>>>>>
>>>>>
>>>>> I'm not able to reproduce the problem with next-20211026 and the C reproducer.
>>>>>
>>>>> And reviewing the code in copy_data() I don't see any issue.
>>>>>
>>>>> Is it possible to know what it the VM configuration used to test it?
>>>>
>>>> Hi Laurent,
>>>>
>>>> syzbot used e2-standard-2 GCE VM when that happened.
>>>> You can see some info about these VMs under the "VM info" link on the dashboard.
>>>
>>> Could you pls confirm whether reverting
>>> caaf2874ba27b92bca6f0298bf88bad94067ec37 addresses this?
>>>
>>
>> I've restarted the syzbot on top of "hwrng: virtio - don't wait on cleanup" [1] and the 
>> problem has not been triggered.
>>
>> See https://syzkaller.appspot.com/bug?extid=b86736b5935e0d25b446
> 
> The problem seems to be introduced by the last patch:
> 
> "hwrng: virtio - always add a pending request"

I think I understand the problem.

As we check data_avail != 0 before waiting on the completion, we can have a data_idx != 0.

The following change fixes the problem for me:

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -52,6 +52,8 @@ static void request_entropy(struct virtrng_info *vi)
         struct scatterlist sg;

         reinit_completion(&vi->have_data);
+       vi->data_avail = 0;
+       vi->data_idx = 0;

         sg_init_one(&sg, vi->data, sizeof(vi->data));


MST, do you update the patch or do you want I send a new version?

Thanks,
Laurent

