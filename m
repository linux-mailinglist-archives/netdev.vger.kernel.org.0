Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DA03FE2A1
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245638AbhIAS5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:57:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33369 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243467AbhIAS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:57:19 -0400
Received: by mail-il1-f197.google.com with SMTP id h10-20020a056e020d4a00b00227fc2e6687so207002ilj.0
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 11:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=VQewuGl8vlvT5VzG8aIWIaodwgdkpe70I+5H3eoMzUQ=;
        b=qNJOKQjbVWJHBN6mhMNJI1TEUr4DlJrfhCi7QzxO8GSucMe93y5hlG1GTguIf9I7VT
         ZPt/6rXV+A0KYVJKWFSwOs9ZkTa9YSHoobf60gDUql+fkWe9d/+WRymEFPph5EMWtcUk
         VWsqwx3+O9bkrRp8NRuuTwnMI8ZdsTucJuBZcL9QdTl000zS8Tzo2QGHE7ZkhZ1PbHPr
         qZty2S5uhDDeu6piohoR8k2/kj2H7BOVdh77oJh9Lekx2gbUDu4n4rS4ivt2CAycZ5+D
         EY0CEueg2ZURn0evkrCgQGmwZDNDO1jDMANK+IWI1qYg4TT6g88yWUsfePuSGqS6nifc
         PCDA==
X-Gm-Message-State: AOAM530xBcKpMFGtizbNoKYl6zhervVx999NxRP0xcAo07w+nHU5fss7
        XOH046/p0dF3k5uPrME/PDZfHVxNInC5xND6Kty1pT7cgq6m
X-Google-Smtp-Source: ABdhPJxM7yX6hRmvluGE6iCdPwlVbRSElMJ6CqdrDZmLZzCmeZMG1VGsAztdYS5AollssH6Y3DRleo5zbPs0rl1vufRyPrTo/V7p
MIME-Version: 1.0
X-Received: by 2002:a5e:c905:: with SMTP id z5mr852876iol.33.1630522581929;
 Wed, 01 Sep 2021 11:56:21 -0700 (PDT)
Date:   Wed, 01 Sep 2021 11:56:21 -0700
In-Reply-To: <52d33ff4-5ddc-0103-9312-f75b7e7cb5b6@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b552c05caf39fd8@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
From:   syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 8/30/21 23:19, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    eaf2aaec0be4 Merge tag 'wireless-drivers-next-2021-08-29' ..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1219326d300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f9d4c9ff8c5ae7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e6e3a9300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10de8a6d300000
>> 
>> The issue was bisected to:
>> 
>> commit 2d151d39073aff498358543801fca0f670fea981
>> Author: Steffen Klassert <steffen.klassert@secunet.com>
>> Date:   Sun Jul 18 07:11:06 2021 +0000
>> 
>>      xfrm: Add possibility to set the default to block if we have no policy
>> 
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114523fe300000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=134523fe300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=154523fe300000
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
>> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
>> 
>> netlink: 172 bytes leftover after parsing attributes in process `syz-executor354'.
>> ================================================================================
>> UBSAN: shift-out-of-bounds in net/xfrm/xfrm_user.c:2010:49
>> shift exponent 224 is too large for 32-bit type 'int'
>
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

want 2 args (repo, branch), got 3

>
>
>
>
> With regards,
> Pavel Skripkin
