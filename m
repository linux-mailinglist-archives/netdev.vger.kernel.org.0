Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88799374A0E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 23:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhEEVW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 17:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhEEVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 17:22:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2955C061574;
        Wed,  5 May 2021 14:22:00 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b3so1856017plg.11;
        Wed, 05 May 2021 14:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fsfJTKBSbE2PAHK2o8J7hn2S5K4ZbOrNhvSf+kUW8Ts=;
        b=rM9NJXQZ8StJfLiGp37CLfrApoHKaTluw03zCAV6oiG66r6nkhyd97qBnJmIscBb72
         DbIGwCKo5BKdVWG7Yl+86+1EucTmqFLXxq0Gfat4o70mjdAZ+O6uIQbcR13g9qJwm2R+
         naqsUMs8qE2RO39G4dCNs0uyHQ8zZPExm2u7nEva/l5RrhfleIhGWKO3MgPy/HJ7N/lh
         7x19l+iNULWYiQw/euQEmunb1vyUJyXE/EePX8O87fIWT2ky76wN/GOefLulqsAiIiv2
         QbDjpz6tWc3pd1G/tORxu51idvYXSLa0fSQPFaNNWb51rAW2hB3lM37YGXiZFR1bUTZg
         rexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fsfJTKBSbE2PAHK2o8J7hn2S5K4ZbOrNhvSf+kUW8Ts=;
        b=MQl5+zWY+fOWt2XRATuBTBduCieTayUjBsfFlqxSCapiUpI4CAzz+0nCY73xY9ZJoA
         S5XujpuigYfaIv3Ha+TyFNQGrZsubqkG7THKyQewQZTO9U3ZoG9uW1vgEMHHFmEJkj6B
         6l6QOhc3gNdksKlzH0PGOsG8jT2Sj+m8ys+bQMm3xT9NoOUFOxE5qPD8Nx18n7EkGYMo
         nRvJkEfk3xlRv1kynytL/abZFk1/UsxDD1CN82brrEG400WV33/Hjx5G7vzA4WiRoD+F
         ieUcBYuXUs+h+31Du4zfBYN5nJDuoO6rWMM7S33Tu4nSfFhiCJxO6UNYn3myvM3V/I+v
         OSZA==
X-Gm-Message-State: AOAM530Ei19vYDO5hfsJYc5USgRcrF7ImZgRt7LVQyNj8YqlVT02HHNP
        34lxyqg/DDZOTEfgjl/PGdGbJBCvDeLkig==
X-Google-Smtp-Source: ABdhPJyZwqi7ia80abMVnffqb/98ndtGUHRb+eNV8IS5kPZOlzHnhflgA9mlU2Z25LKkoOu5K6WGYw==
X-Received: by 2002:a17:902:c3c5:b029:ed:3ff4:70f3 with SMTP id j5-20020a170902c3c5b02900ed3ff470f3mr1163394plj.12.1620249720189;
        Wed, 05 May 2021 14:22:00 -0700 (PDT)
Received: from [172.18.1.216] (b-fw-1-nat-campusvpn.ucr.edu. [169.235.64.254])
        by smtp.gmail.com with ESMTPSA id e65sm158797pfe.9.2021.05.05.14.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 14:21:59 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in __lock_sock (high-risk primitives
 found)
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>
References: <000000000000b98a67057ad7158a@google.com>
 <CADvbK_f3CpK=qJFngBGmO3VXFLsJm9=qqZVtxYOeBS8rwE=9Ew@mail.gmail.com>
 <20181122131344.GD31918@localhost.localdomain>
 <CADvbK_f0n64K==prdcM0KzU0S3pbo1oMW3HhE8zMngCUZp3-iQ@mail.gmail.com>
 <20181122143743.GE31918@localhost.localdomain>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <8a57568e-9f4e-bfb7-cfbe-5463c3bbd3fb@gmail.com>
Date:   Wed, 5 May 2021 14:21:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20181122143743.GE31918@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is SyzScope, a research project that aims to reveal high-risk 
primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).

We are currently testing seemingly low-risk bugs on syzbot's open 
section(https://syzkaller.appspot.com/upstream), and try to reach out to 
kernel developers if SyzScope discovers any high-risk primitives.

Regrading the bug "KASAN: use-after-free Read in __lock_sock", it seems 
that this bug is still missing a valid patch.

SyzScope reports 8 memory write primitives, and 1 control flow hijacking 
primitives from this bug.

The detailed comments can be found at 
https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-lock_sock

Please let us know if SyzScope indeed helps, and any suggestions/feedback.

On 11/22/2018 6:37 AM, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 22, 2018 at 10:44:16PM +0900, Xin Long wrote:
>> On Thu, Nov 22, 2018 at 10:13 PM Marcelo Ricardo Leitner
>> <marcelo.leitner@gmail.com> wrote:
>>> On Mon, Nov 19, 2018 at 05:57:33PM +0900, Xin Long wrote:
>>>> On Sat, Nov 17, 2018 at 4:18 PM syzbot
>>>> <syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com> wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following crash on:
>>>>>
>>>>> HEAD commit:    ccda4af0f4b9 Linux 4.20-rc2
>>>>> git tree:       upstream
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=156cd533400000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=9276d76e83e3bcde6c99
>>>>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this crash yet.
>>>>>
>>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>>> Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
>>>>>
>>>>> netlink: 5 bytes leftover after parsing attributes in process
>>>>> `syz-executor5'.
>>>>> ==================================================================
>>>>> BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
>>>>> kernel/locking/lockdep.c:3218
>>>>> Read of size 8 at addr ffff8881d26d60e0 by task syz-executor1/13725
>>>>>
>>>>> CPU: 0 PID: 13725 Comm: syz-executor1 Not tainted 4.20.0-rc2+ #333
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>>>>> Google 01/01/2011
>>>>> Call Trace:
>>>>>    __dump_stack lib/dump_stack.c:77 [inline]
>>>>>    dump_stack+0x244/0x39d lib/dump_stack.c:113
>>>>>    print_address_description.cold.7+0x9/0x1ff mm/kasan/report.c:256
>>>>>    kasan_report_error mm/kasan/report.c:354 [inline]
>>>>>    kasan_report.cold.8+0x242/0x309 mm/kasan/report.c:412
>>>>>    __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
>>>>>    __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
>>>>>    lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>>>>>    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>>>>>    _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
>>>>>    spin_lock_bh include/linux/spinlock.h:334 [inline]
>>>>>    __lock_sock+0x203/0x350 net/core/sock.c:2253
>>>>>    lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
>>>>>    lock_sock include/net/sock.h:1492 [inline]
>>>>>    sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
>>>> static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
>>>> {
>>>>          struct sctp_endpoint *ep = tsp->asoc->ep;
>>>>          struct sctp_comm_param *commp = p;
>>>>          struct sock *sk = ep->base.sk; <--- [1]
>>>> ...
>>>>          int err = 0;
>>>>
>>>>          lock_sock(sk);  <--- [2]
>>>>
>>>> Between [1] and [2], an asoc peeloff may happen, still thinking
>>>> how to avoid this.
>>> This race cannot happen more than once for an asoc, so something
>>> like this may be doable:
>>>
>>>          struct sctp_comm_param *commp = p;
>>>          struct sctp_endpoint *ep;
>>>          struct sock *sk;
>>> ...
>>>          int err = 0;
>>>
>>> again:
>>>          ep = tsp->asoc->ep;
>>>          sk = ep->base.sk; <---[3]
>>>          lock_sock(sk);  <--- [2]
>> if peel-off happens between [3] and [2], and sk is freed
>> somewhere, it will panic on [2] when trying to get the
>> sk->lock, no?
> Not sure what protects it, but this construct is also used in BH processing at
> sctp_rcv():
> ...
>          bh_lock_sock(sk); [4]
>
>          if (sk != rcvr->sk) {
>                  /* Our cached sk is different from the rcvr->sk.  This is
>                   * because migrate()/accept() may have moved the association
>                   * to a new socket and released all the sockets.  So now we
>                   * are holding a lock on the old socket while the user may
>                   * be doing something with the new socket.  Switch our veiw
>                   * of the current sk.
>                   */
>                  bh_unlock_sock(sk);
>                  sk = rcvr->sk;
>                  bh_lock_sock(sk);
>          }
> ...
>
> If it is not safe, then we have an issue there too.
> And by [4] that copy on sk is pretty old already.
>
>>>          if (sk != tsp->asoc->ep->base.sk) {
>>>                  /* Asoc was peeloff'd */
>>>                  unlock_sock(sk);
>>>                  goto again;
>>>          }
>>>
>>> Similarly to what we did on cea0cc80a677 ("sctp: use the right sk
>>> after waking up from wait_buf sleep").
