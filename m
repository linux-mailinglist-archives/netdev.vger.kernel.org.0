Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F2640DAF5
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbhIPNTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240008AbhIPNTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:19:46 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19819C061574;
        Thu, 16 Sep 2021 06:18:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v5so16550270edc.2;
        Thu, 16 Sep 2021 06:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1HQo36S2SAHi10l4Plwbvr+TQ7qaOaP8erlSdtEXJIo=;
        b=VCGQ0n++Orguv084LpCCiGVPbUJ2JJAEZ4MukWORUfsvit6BnZI9f7+BTUUXGFTMVn
         VTDNA8mO2hQ9Y078IWrk8FLWPLJLP0udqeTLMsq6aVdRoHOnHGP0oa0gGNgvAO6VlFoU
         MAtGH1cP7x8Yh8aHjsQt36wlqDW20xPhug0/2CSYkUwlafxzy/JmGRmg78WkG7blYfmt
         vM36KUli8K7MxN4toSvfV0Ll6cAphHBpoAgRTPOcTlGyfOv+eA+6ThD+2ZmJB7Zwzn+B
         X2S+Y8lUVbgg218Ett6mhUmmaGYyJECQPtR/4vQSDWHKJX+ZagLBSAjSwjv6e7tXsg0J
         s5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1HQo36S2SAHi10l4Plwbvr+TQ7qaOaP8erlSdtEXJIo=;
        b=j2NTHchy3GIgoeL59PgjrYTpYAaKytTK2t6oPE5ad+6lJga30bxyAu41EO6n4PCvdD
         A4LrV9qwkknmIsar4Q0e3ICVHGmJBC9EjsB2/rbBbNL+5CUMg/78TsJ7UyTTVFrRPndP
         mAlX2ol5i4vHoXZXxq8Sr2CqjjZz1GPSYDWmCLbg/pbPjzZ1orW2oxmxtHFSgdj+Kepb
         LbAOxBLP2v0X8AIszct3rk+N54eFimmBvcAzRDYr6EO91iUAOjVPN136LtzGEgiOIW39
         78Y0Tu1xffGZSJbfP9g2HyGljgGohSp1GxqoRHXElMf3spxC3OBTR0bIMizPhDJKkJKa
         Oj7Q==
X-Gm-Message-State: AOAM533IdkSQ0yN0oo3I2+6doaaLbEl6YZNcwBHufXs9MbVNrUrfXwcd
        esf35TddjGF4OeVmd/Biis0=
X-Google-Smtp-Source: ABdhPJy21MaAUz5yM9u1NeyxW5YealjvoLniuvLctwNWV4B+jv12hqsrQskpEV0mvuSRtEcEve8F6Q==
X-Received: by 2002:a17:906:704e:: with SMTP id r14mr6205527ejj.293.1631798302934;
        Thu, 16 Sep 2021 06:18:22 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id ba29sm1445933edb.5.2021.09.16.06.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 06:18:22 -0700 (PDT)
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, hdanton@sina.com,
        io-uring@vger.kernel.org, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
References: <0000000000006e9e0705bd91f762@google.com>
 <0000000000006ab57905cbdd002c@google.com>
 <CACT4Y+avszKiyXYBTRus9DqeSUoGrWC8d2uEiJN3z=oYQSdz0g@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
Message-ID: <0ddad8d7-03c2-4432-64a4-b717bbc90fb4@gmail.com>
Date:   Thu, 16 Sep 2021 14:17:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+avszKiyXYBTRus9DqeSUoGrWC8d2uEiJN3z=oYQSdz0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 8:59 AM, Dmitry Vyukov wrote:
> On Mon, 13 Sept 2021 at 11:22, syzbot
> <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com> wrote:
>>
>> syzbot suspects this issue was fixed by commit:
>>
>> commit 43016d02cf6e46edfc4696452251d34bba0c0435
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Mon May 3 11:51:15 2021 +0000
>>
>>     netfilter: arptables: use pernet ops struct during unregister
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10acd273300000
>> start commit:   c98ff1d013d2 Merge tag 'scsi-fixes' of git://git.kernel.or..
>> git tree:       upstream
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c70e618af4c2e92
>> dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145cb2b6d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157b72b1d00000
>>
>> If the result looks correct, please mark the issue as fixed by replying with:
>>
>> #syz fix: netfilter: arptables: use pernet ops struct during unregister
>>
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> I guess this is a wrong commit and it was fixed by something in io_uring.
> Searching for refcount fixes I see
> a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 "io_uring: fix link timeout
> refs".
> Pavel, does it look right to you?

I don't remember to be honest, if the dates fit, it can pretty well be it.
Let's test one thing to be sure it hasn't been shut just by coincidence.

#syz test: https://github.com/isilence/linux.git syz_test_quiesce_files


-- 
Pavel Begunkov
