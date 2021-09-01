Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFFA3FE2A5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343991AbhIAS5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:57:40 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56000 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbhIAS5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:57:20 -0400
Received: by mail-io1-f72.google.com with SMTP id o128-20020a6bbe86000000b005bd06eaeca6so140358iof.22
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 11:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=BRYCKM+nxgazLvQShkHFc3x7TJQDmFoQrg4gb1LVEIc=;
        b=kLQf8v0+r2fyuN6PPwRr/Y6kpLqFnaPG8SzmxHqCDVqEqbbJulY7oukrO22ar35WIL
         +TahMPU2qb5Lrhg7DoGtoDX8dfr0x6sCFCqIkN6/fKzzzCuXeC4/4G2ZLR3jsTFxCyPb
         KEp+AuSFzqmkoapt/yTP/RqEv9spkp9DyEeFZmtDDdLtIAvCmgaG0qnyccw6AFtjzaUD
         vP+FzwCMfQAefwgHLUxfZiboFCx24voTttDdI5WBgFmEGviYDUirhY3RsaItUgjgfom6
         2qe4eGdOO5ulS4fEETz+uhhtMp43/7dg+hAws0IwWLyv9Zw1lGMaDHTwkhljze2rp0+i
         TLfQ==
X-Gm-Message-State: AOAM533p5FmLAruMPR3VO7Kr5l2lDyodx7ZGs1t5nG8dbDj5gakKV3lA
        pmefhjhnxioJPAxnzVGwYR67EP61jg9uVTmiDigaO+PtSkHI
X-Google-Smtp-Source: ABdhPJwad03f8v2Lfev3U5fW80KvsNT3Z1PqVPwR06oKqGJRZh4TBdZM47GPSqbQMiEFcJYYEHGp5qZsoLx/oez3+adGnRkZjcnY
MIME-Version: 1.0
X-Received: by 2002:a92:7305:: with SMTP id o5mr682775ilc.70.1630522582863;
 Wed, 01 Sep 2021 11:56:22 -0700 (PDT)
Date:   Wed, 01 Sep 2021 11:56:22 -0700
In-Reply-To: <52d33ff4-5ddc-0103-9312-f75b7e7cb5b6@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000059938905caf39fce@google.com>
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
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/52d33ff4-5ddc-0103-9312-f75b7e7cb5b6%40gmail.com.
