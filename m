Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA9259E9B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfF1PRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:17:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35568 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfF1PRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:17:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so3419511plp.2;
        Fri, 28 Jun 2019 08:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=08U5q1pt2W+YM1rIatW1uXCddvaCPZQ1ACknIlDj2y4=;
        b=kLEsghuThznChptBzFvzk6m1ix8/alSy5C9QQbAzVmrg2t68sVhUMRUaDPW+Kvpu2h
         YRkcwimqeFaSXKvWK7Zl8R2nOCIPxSEKe7/1llcm1Z83NoTUmP0mdYlf65rYbjCBP2UJ
         qrlR7H9o9rg2bOIXMZD2kvvWrUQSP445pmGgSyYAwz4EpAxvLYDsQFUO1MVZFiDFHrJA
         obaUnIMoiI0IDdFVNbuB8ZKOTZwfIcF2Hr6/RimrcuhDDvugHCOhm8aRZnNBfqo4ii3y
         ro3mDAaXOx/Lwu9NWI80Jp+A9aGAuRrgLQY45W+12utqHVh7aI8azgm0SKWjjySRFrjX
         wbPw==
X-Gm-Message-State: APjAAAXa+EUlIeOAexujdLiNM/KtybIWT6c4jwaKU4jTp2vUrQ6YS9Hx
        nhzUIW1WsHgVEZXP4dOl7o0=
X-Google-Smtp-Source: APXvYqy6BruVFpT+atnt6vuKZwUyXTZc4F4Iz59vx0pXbfCiYbMdSN3HzP8L529KkVDl7Km+IkcRCg==
X-Received: by 2002:a17:902:8205:: with SMTP id x5mr12403394pln.279.1561735039122;
        Fri, 28 Jun 2019 08:17:19 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id e20sm4758253pfh.50.2019.06.28.08.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 08:17:17 -0700 (PDT)
Subject: Re: WARNING in is_bpf_text_address
To:     syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com,
        Dmitry Vyukov <dvyukov@google.com>
References: <000000000000104b00058c61eda4@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c0e440a1-30aa-a636-fe5c-44f71705857b@acm.org>
Date:   Fri, 28 Jun 2019 08:17:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <000000000000104b00058c61eda4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 6:05 AM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Thu Feb 14 23:00:46 2019 +0000
> 
>      locking/lockdep: Free lock classes that are no longer in use
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
> start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of 
> git://git.kernel.org/pu..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae828aa00000
> 
> Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
> Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no 
> longer in use")
> 
> For information about bisection process see: 
> https://goo.gl/tpsmEJ#bisection

Dmitry, this bisection result does not make any sense to me. Can I mark 
this bisection result myself as invalid?

Thanks,

Bart.
