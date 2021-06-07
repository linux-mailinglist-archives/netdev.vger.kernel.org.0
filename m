Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF13039E455
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFGQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:49:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43783 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhFGQtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:49:14 -0400
Received: by mail-io1-f70.google.com with SMTP id p7-20020a5d8d070000b02904c0978ed194so1070802ioj.10
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 09:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5sWTD7ZtJJvFb5Hd+ZcQxV3BC6zm39TRieMzIj8ghAE=;
        b=XAQTWG97Uime+oHPvDk0emATxPxp7RIUXglzk6oXRn+prcnBjO0WQ3CfUPt3rzGi9K
         sgnynPpKp+LEbMllCKulXMDENdVnnsQIMmlVl0K5QxtpVCcRndqa4/jUMVkyc7/+nEDK
         rSMBQPXug+9pPbimltWj1yys4imMS7suLud3x3HN7nYkhBQNcnDG23NFnPTbmEKh6Ruk
         mXBVev1k6kyGOtMX5p7InKxGUKTA1DZ4jK93bdaYqfbpxsjrZuZDWYN/BbLmrGk31dka
         ZL+KXWKh+ZuAuCStOnwwNEDWBrlqAavocOaD6DseCGwMnO1ZkDCl2uQ1LENeYuLFjUEj
         AIig==
X-Gm-Message-State: AOAM5312ZcV8HTACmeZ4u+9HCWWi1QxGPPKdEBlAbFd2UHhto6cuMU8d
        6jBOw8ZyfOCd0X25VstALl8YCdDGZWsG2cRk71oWiTskryRo
X-Google-Smtp-Source: ABdhPJyDXPNYTwfbSAd6P+4H7FvAg0x1fEf6Q0O5hD6MvbI9qvTgusV4qviPUlvsH2Fzk78BjCH5i0R7y+J5mBz6CGfrRiefw9Wq
MIME-Version: 1.0
X-Received: by 2002:a92:c7b0:: with SMTP id f16mr14813184ilk.169.1623084427231;
 Mon, 07 Jun 2021 09:47:07 -0700 (PDT)
Date:   Mon, 07 Jun 2021 09:47:07 -0700
In-Reply-To: <000000000000a363b205a74ca6a2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9c68205c42fcacb@google.com>
Subject: Re: [syzbot] BUG: using smp_processor_id() in preemptible code in radix_tree_node_alloc
From:   syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, brookebasile@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ducheng2@gmail.com, ebiggers@kernel.org, fw@strlen.de,
        gregkh@linuxfoundation.org, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, skhan@linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 43016d02cf6e46edfc4696452251d34bba0c0435
Author: Florian Westphal <fw@strlen.de>
Date:   Mon May 3 11:51:15 2021 +0000

    netfilter: arptables: use pernet ops struct during unregister

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dfdf47d00000
start commit:   acf25aa6 Merge tag 'Smack-for-5.8' of git://github.com/csc..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5263d9b5bce03c67
dashboard link: https://syzkaller.appspot.com/bug?extid=3eec59e770685e3dc879
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd4c1e100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1520c9de100000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: arptables: use pernet ops struct during unregister

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
