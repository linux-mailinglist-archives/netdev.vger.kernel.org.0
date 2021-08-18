Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ACA3EFEE7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhHRINH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbhHRIMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:12:53 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DB2C0613A3;
        Wed, 18 Aug 2021 01:12:18 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u22so2811720lfq.13;
        Wed, 18 Aug 2021 01:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PTS7SWHnSmVv8p2NQxDXlrhf0E7nyl4f8snQpT8Hk1c=;
        b=LhwAKdjewrNZyym18Y20xB2PlyK+1HBxUWDL7a+euwXTx6n7lo1jEUaX7sEgID88Vt
         7WgYYtDLBLvaCmJBlNjVBjl8Af8YnXKAEJ3docnMdVC+aSv/T0IXtLXYtt2+xJvkXswh
         X613y9Cm+QRK5fjZNF/c0ReA1UFxCq39Yh+0NEKbLYxCtG/t0wCtpzgdM/FcI3sB8iKG
         PGxAvLPtbIkvzNUGu1GiUPx50rAPWQ0HP0w3xOg7ap12sLNqMcycmWxYS0LUTDsfally
         R/dBPmgWSGtqjRW+3+LL52krI9DRsVURNM6DnfVtBdinRklkCD126jHs+CwlGChCIYuY
         UUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PTS7SWHnSmVv8p2NQxDXlrhf0E7nyl4f8snQpT8Hk1c=;
        b=jU2s5ta3QOHDylhI7bdEUusNBfbuDLbwJQitHgQ0Rq8wzp9EcCMrEFU9h8HwZxYqpn
         VIEh5QHdYrws85AZ4eCI4gaI5syCViWoFZc8BEXtz9Oz4BbGE6oildaNEuFSwlkISbts
         vTYMyeIu4m3JCx1feBm0IrCRfUpBSbAj/FLvpaAc2Ql+0G6i7QnKOzMUV6jwzIWxiFQA
         VKuQiUiBlbKoU0l5/dqtWUsF5PQF1FvAA98Q7unA25G8YxdqvnihaJObycNwMETOcWtd
         p7SQncAic6TqK5GIpDIBKyiUKJC4StbM8K3+z6BRsw+5Gg9dlHBvyClgZv4rG0ehcLDO
         1krA==
X-Gm-Message-State: AOAM531Aklc/LKOIrLIkMbA9E/poVJlaX35ttWA1ye97TzMq/LN17fOR
        gD8b3ncfCnq3RFtgrhZQwmM=
X-Google-Smtp-Source: ABdhPJx7KSNTMK3kkYNGgAIPyPysjnZ6xRm3jCX93PeQoj3olBx+9dtiB4E7wvg0Cc+UlZwYR7+Dow==
X-Received: by 2002:ac2:5e8f:: with SMTP id b15mr2992334lfq.656.1629274336450;
        Wed, 18 Aug 2021 01:12:16 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id b4sm386693lfo.94.2021.08.18.01.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 01:12:15 -0700 (PDT)
Subject: Re: [syzbot] KFENCE: use-after-free in kvm_fastop_exception
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        syzbot <syzbot+7b938780d5deeaaf938f@syzkaller.appspotmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000012030e05c9c8bc85@google.com>
 <58cef9e0-69de-efdb-4035-7c1ed3d23132@tessares.net>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <6736a510-20a1-9fb5-caf4-86334cabbbb6@gmail.com>
Date:   Wed, 18 Aug 2021 11:12:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <58cef9e0-69de-efdb-4035-7c1ed3d23132@tessares.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 11:02 AM, Matthieu Baerts wrote:
> Hello,
> 
> On 18/08/2021 00:21, syzbot wrote:
>> syzbot has bisected this issue to:
>> 
>> commit c4512c63b1193c73b3f09c598a6d0a7f88da1dd8
>> Author: Matthieu Baerts <matthieu.baerts@tessares.net>
>> Date:   Fri Jun 25 21:25:22 2021 +0000
>> 
>>     mptcp: fix 'masking a bool' warning
>> 
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122b0655300000
>> start commit:   b9011c7e671d Add linux-next specific files for 20210816
>> git tree:       linux-next
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=112b0655300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=162b0655300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7b938780d5deeaaf938f
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157a41ee300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f78ff9300000
> 
> I'm pretty sure the commit c4512c63b119 ("mptcp: fix 'masking a bool'
> warning") doesn't introduce the reported bug. This minor fix is specific
> to MPTCP which doesn't seem to be used here.
> 
> I'm not sure how I can tell syzbot this is a false positive.
> 


looks like it's fs/namei bug. Similar reports:

https://syzkaller.appspot.com/bug?id=517fa734b92b7db404c409b924cf5c997640e324

https://syzkaller.appspot.com/bug?id=484483daf3652b40dae18531923aa9175d392a4d


It's not false positive. I've suggested the fix here:
https://groups.google.com/g/syzkaller-bugs/c/HE3c2fP5nic/m/1Yk17GBeAwAJ
I am waiting for author comments about the fix :)

But, yes, syzbot bisection is often wrong, so don't rely on it much :)


With regards,
Pavel Skripkin
