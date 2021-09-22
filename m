Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E6414CCE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhIVPRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbhIVPRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 11:17:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9A3C061757
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 08:15:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e82so3697191iof.5
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 08:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SUFlIgkF97LliXUlJb/5UYv8rypWABdjmrEwhMUl3f0=;
        b=uX2F8zHrzXKQl6pQhFIFZIDJz1njgUJghfXzdm/WO4M+wRGvJEa/6vga8wDPzXm6YM
         nxFbW6eD9w0uensRtXFDY6a+EMujRuGrs/MIEi1VqQRm+xF7NpkR3wItQ4jn/jTJU+8P
         91qT+UkOs83TWgJdnxr12rKFtsQKH1RXeYGdzGjuHI3yelzTEtnAYgf5JuhyR57k7QjH
         03RRqXMqVdFYds4wK5ISU8pWziZ4r95//7xHwsrn2ki/0tH9RUeqCvNMYgUpnoU4bkcT
         6spoMet5tlJzYAz3rWekUp0Rfo0dNUh8NS8bzjFuxJMLs+6BGyhiofIVlYF0+yHblNk0
         GN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SUFlIgkF97LliXUlJb/5UYv8rypWABdjmrEwhMUl3f0=;
        b=thB3Og5At99Y6a5IlcUSGh8ewEt2WsGDkZzn3RoIcVXyTpb3aKuRquSg7yBBrxI2Mx
         BFPR1Acz7iiCpy1d4ZezFkxItuRBVccsgysciFC9MrHOErytyxkLhSOlGOcN+uecw/sB
         zIb6vpuv0y9vpKp9LhFZLWWbqIWtyiH6yGw1onWVTucEQ5FFqEqj8iDdTO2/JaxIC1Qk
         bNc8XFapOUVWZx6LP7CBv34Sime9VMUrN1xeLR3CxfBf671V2ep7fiq5yCKKWqyxbfOn
         ZCjvmNV3VIgLvxpQFIvvWl+XmablM2JTw18JYAK2Gn/9NEigffGhbscluYYlS6t3lbkf
         3kSA==
X-Gm-Message-State: AOAM5309Mss0Zn4Lz0K/Qw0SSRWqFMr5bdJz/Se+CF0zOI1Ne/IdWi1s
        yGZCfQDPwFbrz55/0zqiOBfRPQ==
X-Google-Smtp-Source: ABdhPJxPX7caP6ZoDNZKXdHXDn97sVpv2Jh7Xuz7w6ET4m37RfPtwclpL1tJnUZj6ns0sm4V3IBCPQ==
X-Received: by 2002:a6b:6b08:: with SMTP id g8mr92580ioc.199.1632323747923;
        Wed, 22 Sep 2021 08:15:47 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b12sm1142541ilv.46.2021.09.22.08.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:15:47 -0700 (PDT)
Subject: Re: [syzbot] INFO: rcu detected stall in sys_recvmmsg
To:     Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com>,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        dkadashev@gmail.com, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
References: <0000000000003216d705cc8a62d6@google.com>
 <89d72aca4e30335a03322612cf164420be11d8eb.camel@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <16c414f0-8399-e945-825e-fe8ac1be4e08@kernel.dk>
Date:   Wed, 22 Sep 2021 09:15:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89d72aca4e30335a03322612cf164420be11d8eb.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 9:13 AM, Paolo Abeni wrote:
> On Tue, 2021-09-21 at 17:13 -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    1f77990c4b79 Add linux-next specific files for 20210920
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1383891d300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ab1346371f2e6884
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3360da629681aa0d22fe
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1625f1ab300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17eb1b3b300000
>>
>> The issue was bisected to:
>>
>> commit 020250f31c4c75ac7687a673e29c00786582a5f4
>> Author: Dmitry Kadashev <dkadashev@gmail.com>
>> Date:   Thu Jul 8 06:34:43 2021 +0000
>>
>>     namei: make do_linkat() take struct filename
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f5ef77300000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17f5ef77300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=13f5ef77300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com
>> Fixes: 020250f31c4c ("namei: make do_linkat() take struct filename")
> 
> I'm unsure why the bisection points to this commit. This looks like an
> MPTCP specific issue, due to bad handling of MSG_WAITALL recvmsg()
> flag.

This seems to happen quite often, and I'm guessing it's mostly likely
due to the test being run not always triggering the issue. Hence you end
up with git bisection results that go off into the weeds.

-- 
Jens Axboe

