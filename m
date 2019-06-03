Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68CC326E6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFCD3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:29:19 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40473 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFCD3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 23:29:18 -0400
Received: by mail-pl1-f195.google.com with SMTP id g69so6410461plb.7
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 20:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qolUrxKgA0je1UdGJ7G6NKw5HG97+OI5EAAYtHD1LCE=;
        b=g1X1dIQMihMW3tOr67Ij4jUP7LN7atfVHgozSz3z7EmiG7rLJEJhiY0JVPQktjCpHL
         1XR6L9CHOxfzEelsm7/uh8xoypKptlhIFHyQI48DjjoDFmtnzdPRv+XP2gM7DNwwngAE
         SUHDtJllQfwpHqQNKgt5CsfkGOBbRTQVUUupSJlB1kyszhfpqUQ9krp1Q6BG6NuPGcZR
         WzjAQplOhNx8bjFRZ6F9DaUIR4UCajfQh/mbSVTeJOHzyo7mfURQ2BRL8hCazLj7c8p1
         zCDvu6qIFir2/sg61O5GBdeyiGptgUh1iPdnAObmbmIj0KqUuTL3sRhjiw9s6lw2Rc58
         0niA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qolUrxKgA0je1UdGJ7G6NKw5HG97+OI5EAAYtHD1LCE=;
        b=S2bnRmTqk0z8HQOyRHd0kGo1am2k2PDXYFDJZ4SjCLNVcu8EdS0f5e2wsGMQbk0XX/
         Sw/FisS+RLm0bDs0rsu44DLqCAkpEImUTqUEgyovuBOclyMUWrrrlIdC74VRutG05hIu
         myajUAm4KU/Dg7b4E+LTCLuiwVYjy+DJIFxWeK92pqh/OkCCsjsUjlPdDsSfLAqDHE1A
         KiLOKrK9ovXWGE0o8zu2QG4Ph6KwTJFtaLOcljrf5jKYhEDld+krHCiwHBp4SeT/hNzx
         RWSkz/mQ9s0csooEvdeSN3Ex8iBPTCF9sJ16F4/o+BUP3zlkLYC6U6uxJcJ71rYeKfm8
         ri2A==
X-Gm-Message-State: APjAAAXXaA6gXD8wnGSMV3wuNZTYw0pNXYMRQQ7F4zD/mftZPsGFy5BH
        NavDakma3SATusq4sCwJxCY=
X-Google-Smtp-Source: APXvYqx4ch/irVVyNRy7v62LZCp8nMFJ9AssMyh4wxz4SST8HWb8rYIGsPcAWUFdYz5OPvQN+n26Xw==
X-Received: by 2002:a17:902:b407:: with SMTP id x7mr27108549plr.28.1559532558356;
        Sun, 02 Jun 2019 20:29:18 -0700 (PDT)
Received: from [172.27.227.194] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t5sm10566659pgh.46.2019.06.02.20.29.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 20:29:17 -0700 (PDT)
Subject: Re: general protection fault in tcp_v6_connect
To:     syzbot <syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000aa7a27058a3ce9aa@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <250fba08-9cd7-7c79-f00a-d116e76fb51b@gmail.com>
Date:   Sun, 2 Jun 2019 21:29:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000aa7a27058a3ce9aa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/19 12:05 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    f4aa8012 cxgb4: Make t4_get_tp_e2c_map static
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1662cb12a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d137eb988ffd93c3
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=5ee26b4e30c45930bd3c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+5ee26b4e30c45930bd3c@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 17324 Comm: syz-executor.5 Not tainted 5.2.0-rc1+ #2
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
> RIP: 0010:rt6_get_cookie include/net/ip6_fib.h:264 [inline]
> RIP: 0010:ip6_dst_store include/net/ip6_route.h:213 [inline]
> RIP: 0010:tcp_v6_connect+0xfd0/0x20a0 net/ipv6/tcp_ipv6.c:298
> Code: 89 e6 e8 83 a2 48 fb 45 84 e4 0f 84 90 09 00 00 e8 35 a1 48 fb 49
> 8d 7e 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02
> 00 0f 85 57 0e 00 00 4d 8b 66 70 e8 4d 88 35 fb 31 ff 89
> RSP: 0018:ffff888066547800 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: ffff888064e839f0 RCX: ffffc90010e49000
> RDX: 000000000000002b RSI: ffffffff8628033b RDI: 000000000000015f
> RBP: ffff888066547980 R08: ffff8880a9412080 R09: ffffed1015d26be0

This one is not so obvious.

The error has to be a bad dst from ip6_dst_lookup_flow called by
tcp_v6_connect which then is attempted to be stored in the socket via
ip6_dst_store. ip6_dst_store calls rt6_get_cookie with dst as the
argument. RDI (first arg for x86) shows 0x15f which is not a valid and
would cause a fault.

None of the ip6_dst_* functions in net/ipv6/ip6_output.c have changed
recently (5.2-next definitely but I believe this true for many releases
prior). Further, all of the FIB lookup functions (called by
ip6_dst_lookup_flow) always return a non-NULL dst.

If my hunch about the other splat is correct (pcpu corruption) that
could explain this one: FIB lookup is fine and finds an entry, the entry
has a pcpu cache entry so it is returned. If the pcpu entry was stomped
on then it would be invalid and the above would result.
