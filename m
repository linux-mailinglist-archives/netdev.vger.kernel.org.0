Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1E43EA723
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbhHLPIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbhHLPIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:08:23 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B730DC061756;
        Thu, 12 Aug 2021 08:07:57 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h11so10987372ljo.12;
        Thu, 12 Aug 2021 08:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KbwI5nkv84JbtE0W/FpgChBt/az9dsz8O/EOPEH7OUc=;
        b=IrdDX1uv/TRDEcYXJa+KTyT/g5dVq4mmdfuXKwROpeCIQrnm09UI++QF6w2uWrCOk3
         2+TxN4FtrejJ7i0edP5Qz5J9x7l/W4OJ1N/S3k/W/4djWHzG5CeKp5xRRCDOkeoH7K42
         RwB8AA/9YWCWuDyRL+bmnB/fvX73jcaHhoCSx6Ytl08N+Jzt8MnutXbJG68+oAAU1Wor
         vtISuNIrurzhFqwLPv/jN5i+ezunF7vt3rrSQCX13QWhibbieBn0Z3OPICqMi6sXmRgR
         Ou9eH1l5xAxzEoKwjdyXsuyV2+0+dOlb7Y/vXTDq8Y1rsJYPOi3JtcjLUfEMSDNA83ET
         /ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KbwI5nkv84JbtE0W/FpgChBt/az9dsz8O/EOPEH7OUc=;
        b=Rp1tiKfNDXyTnzHS3/yJpqWqhIhzFnMbF9aoUvUPxsy2gNKgd6PMDMSEPZTphyqa2n
         MTM/vJs2jSP1+gKZKGFZ5f1ErpTBJdWY0PXNjxww7SHJh4OUs48pg7oo8gGk5cLUIsaG
         ojNEWDgloNlTXweJZx2rE3xRjbcU57j3ySPk2ZqWI/2Q+lxjMhHaGD5T93cZAd8YpbiB
         f0rg9pLdwUbJ786WgAxjNFYwI9b1tr0TPhbzbEHUbtg59DezR+6d4rV3c7TGUCbSO5BV
         TR8CVul95OF5xkQ3eCYDHNQ7hr4ADeNtiX5Xud7rKXdB76BJrzvI1Ii8db8HzcoGIe+5
         sNCg==
X-Gm-Message-State: AOAM530pHwV2Gkuj1mMQhbgqrRlzl0c5BbtppZtjuxj6sOLvbGXmIF//
        TJcBQgBH/pW2qhRgxOgl6yE=
X-Google-Smtp-Source: ABdhPJx1VO2Hk/bH+vN19yFMA8Y+g6f8evoqGLSdU73TN0vmDm6WDxkpxL76COTRtWGH9/iaDPZ6Rg==
X-Received: by 2002:a05:651c:4cc:: with SMTP id e12mr3281304lji.369.1628780876013;
        Thu, 12 Aug 2021 08:07:56 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id t4sm313477lft.140.2021.08.12.08.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:07:55 -0700 (PDT)
Subject: Re: [syzbot] WARNING in destroy_conntrack
To:     syzbot <syzbot+a1eb62c681423ee5c0d7@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000004601605c9222d92@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <5450d0a7-8dc8-57a3-85bd-95cf4dfa8d11@gmail.com>
Date:   Thu, 12 Aug 2021 18:07:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <00000000000004601605c9222d92@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/21 6:38 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12755626300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
> dashboard link: https://syzkaller.appspot.com/bug?extid=a1eb62c681423ee5c0d7
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1241d9d6300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168e66e9300000
> 
> The issue was bisected to:
> 
> commit 65038428b2c6c5be79d3f78a6b79c0cdc3a58a41
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue Mar 17 13:13:46 2020 +0000
> 
>      netfilter: nf_tables: allow to specify stateful expression in set definition
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1683f1f1300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1583f1f1300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1183f1f1300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a1eb62c681423ee5c0d7@syzkaller.appspotmail.com
> Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8989 at net/netfilter/nf_conntrack_core.c:610 destroy_conntrack+0x232/0x2c0 net/netfilter/nf_conntrack_core.c:610
> Modules linked in:
> CPU: 0 PID: 8989 Comm: syz-executor188 Not tainted 5.14.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:destroy_conntrack+0x232/0x2c0 net/netfilter/nf_conntrack_core.c:610
> Code: da fc ff eb 90 e8 ae 27 19 fa 48 89 ef e8 c6 53 02 00 48 89 ef e8 ee 1c 5f fa 5b 5d 41 5c 41 5d e9 93 27 19 fa e8 8e 27 19 fa <0f> 0b e9 2f fe ff ff e8 82 27 19 fa 4c 8d a5 e8 00 00 00 48 b8 00
> RSP: 0018:ffffc90002d7f080 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
> RDX: ffff88802eeb8000 RSI: ffffffff875c8632 RDI: 0000000000000003
> RBP: ffff888147d35400 R08: 0000000000000000 R09: ffff888147d35403
> R10: ffffffff875c8460 R11: 0000000000000000 R12: ffff888147d35400
> R13: ffffffff8b31b880 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007fb18d49a700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f37c403d088 CR3: 00000000182c1000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   nf_conntrack_destroy+0xab/0x230 net/netfilter/core.c:677
>   nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:34 [inline]
>   nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
>   nft_ct_tmpl_put_pcpu+0x15e/0x1e0 net/netfilter/nft_ct.c:356


Hm... Calltrace looks similar to 
https://syzkaller.appspot.com/bug?id=34b3d29c783f19d70086206194da85e59c448167 
and my debug logs say that right before this check

	WARN_ON(atomic_read(&nfct->use) != 0);

nfct->use is zero. Reproducer is threaded, so, I think, 2 netns 
concurrently doing inc/dec somewhere. This should be fixed by my 
previous netfilter patch.


Also, with my previous netfilter patch applied I cannot reproduce this 
bug locally, so

#syz fix: netfilter: nft_ct: protect nft_ct_pcpu_template_refcnt with mutex


With regards,
Pavel Skripkin
