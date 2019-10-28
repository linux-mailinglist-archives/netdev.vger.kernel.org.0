Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89800E7B3C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfJ1VSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:18:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40876 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfJ1VSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:18:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id p5so1136907plr.7;
        Mon, 28 Oct 2019 14:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+VUOkQQ0cS09JPSi71tIBBT1mTYHRZxM9Rky7eoOSgw=;
        b=OjidU2oR2T7Q2hn+YlY+Tct62hI1mB5Kifm4bnkpc+vSlhdG07Rbxu78tVTb8ktGnw
         AeaEcsZIAYA8VkjeezkHxk1P7mIAYRvIpF3nRii9vtvBaRXi83Y9cDUNVTQSfoDUQv4v
         jnrL5/gPGgrjp3aBrI31twYk8mH4R9yHZLoM7MzgIs6GkMZco5UQq6nj2AntGx7ZvuAD
         Tt/b/oLd9t8AhWziSH3Mc1M8/wVvg0JACvkoFrEeOk21xPCwxjwGHfygrgUu9yt9IM0K
         zH46rQ2jlG3LMyYQc/Q0CeBltTYHOUN0uRHxDXyR17KejlePM+MBN+cKGxlVsjjE+xk+
         e1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+VUOkQQ0cS09JPSi71tIBBT1mTYHRZxM9Rky7eoOSgw=;
        b=t/0cQXoR6uWkl4YmmO5FQOEYq531wOQ7Zhl2yoN7RYUPP5415vll2Sxh23gM4kfY42
         EY1kqL+561bN0Jf9ZbyIldSV4/kwOMeOIOMwvCWKpQxnF3pNXM169XJWavvhfHSOmuXN
         3/IyTqkPA4muchcPOkb2KFNG0e8dgapLq3hUJ/RtVqBjVIXlkLBK5usRmplvQIJaDIYT
         Hom25krdpvEL6QPp8zQa1+K5FK2j2Me3zl99NlsR3ymznYkLoa8eidE9EVWrQDLdvSy1
         jZyAU9TZoivc3G4YeB+JIHD3/hgknhscXuHlXvkcJ5puS7nFDAzGTZPrKvtyiT1xSIZh
         QwIw==
X-Gm-Message-State: APjAAAXnRe/hVpwgj0Ec9QNN51pszCQtgs2G8tlio4CuHh7wqClqUgsI
        mzGhSET64LNO3s2j9yjBsDU=
X-Google-Smtp-Source: APXvYqyo7XTKvgWX6tPjauNCdnz4UEC3+PRaUMgcyu5WG2/v8b20G+1O971o5O5DlU8wpP/ywNzsxw==
X-Received: by 2002:a17:902:6b4c:: with SMTP id g12mr163578plt.78.1572297488315;
        Mon, 28 Oct 2019 14:18:08 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c19sm11424797pfn.44.2019.10.28.14.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 14:18:07 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in sctp_sock_dump
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        syzbot <syzbot+e5b57b8780297657b25b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, roid@mellanox.com,
        saeedm@mellanox.com, syzkaller-bugs@googlegroups.com,
        vladbu@mellanox.com, vyasevich@gmail.com
References: <000000000000e68ee20595fa33be@google.com>
 <20191028153648.GF4250@localhost.localdomain>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <82f699fc-7509-b8fd-f2d0-b1ceb808e37b@gmail.com>
Date:   Mon, 28 Oct 2019 14:18:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028153648.GF4250@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/19 8:36 AM, Marcelo Ricardo Leitner wrote:
> On Mon, Oct 28, 2019 at 08:32:08AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    d6d5df1d Linux 5.4-rc5
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ef5a70e00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2bcb64e504d04eff
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e5b57b8780297657b25b
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> userspace arch: i386
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cd8800e00000
>>
>> The bug was bisected to:
>>
>> commit 61086f391044fd587af9d70a9b8f6f800dd474ba
>> Author: Vlad Buslov <vladbu@mellanox.com>
>> Date:   Fri Aug 2 19:21:56 2019 +0000
>>
>>     net/mlx5e: Protect encap hash table with mutex
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135960af600000
> 
> This is weird. This mlx5e commit has nothing to do with SCTP diag
> dump.

syzbot bisections results might be wrong, it happens quite often.

But the SCTP bug is probably real.
