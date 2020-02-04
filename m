Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E6C15202A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgBDSDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:03:19 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36043 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgBDSDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:03:19 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so10038543pgc.3;
        Tue, 04 Feb 2020 10:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E8TOUJb1LB1CGjhRZlBmQYfzHnpM6fLCA335raKvA2E=;
        b=MLQxWerqYuNYbiSuIddhGPcw/f2KrN+IYw9SJLGy3qyOjA+Ux1wMpnyc/zWnle0AlK
         bAb1WtyMcY7alctYQTVQQcinJaoqkMOzRE3UAYXco3OFid/MXm6q1SlmETLRK51m7+iN
         xqOcxIedAgSPRfOuRylvDKysGj60wPSZ2dTPrJKUU6WpL53y8Gdog2li7PFyvzdtCYPz
         yR3vC/HuccTRevBQy8eeWnFN5qFlVRgKOu5Edvm9UqVfHFqZ7Mc+pRsq0LJCWx/TB8ic
         U+bXabrIHvoJO8uMu5An9CpQmjNNyTZOCRYlyMFMzXgl1DuwsCafCXBP24keqA66EERk
         wfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8TOUJb1LB1CGjhRZlBmQYfzHnpM6fLCA335raKvA2E=;
        b=AZp603gJ7ltvYDlaGu7hgcIhv9HddJMw/lUplDpcfD2LqZLJ1h4mfJtXGpSR1pUfPc
         UGzOngTLC34SZ6BVtrdWdAYB6+lKDmIrJE79BdRx2OlGfAoQoIauXmrexIzDJ7YKizLE
         c+mb1Ni+IEY7DRIArxDhfYZWbTj209+Au4KQ+ZWI26m6GKMBEoG/jHfUq/MmTpkfe1r+
         4AlrqIH66vYzL7bDZcEYDLBMFxw4tMB9idQ/7tfDYKEbPGfCHjrI2GGIvAAUpMoljbO4
         lTxWbqJP086b3vBj9y1ya6D18KIxQGlBua5xrGwpvNIBeUkT/3qZFa/QYW7DijuEwbSk
         8oWA==
X-Gm-Message-State: APjAAAVk2yAoFvlMVjzHRyRoUU3sXzwxWzlb9X9lZ6o9bN1Gxb0PNbBe
        6gYXZkSI+OIvQGW/Wpqj22qXzCxE
X-Google-Smtp-Source: APXvYqwpCEt7Ve+QDFk7hfb8VlqxpZPJCjxtg1oAHNkMcmdWpBb398WQboTbu4dVUuImidW2CetKMw==
X-Received: by 2002:a63:515d:: with SMTP id r29mr24456711pgl.265.1580839398398;
        Tue, 04 Feb 2020 10:03:18 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w14sm3022453pgi.22.2020.02.04.10.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 10:03:17 -0800 (PST)
Subject: Re: memory leak in tcindex_set_parms
To:     syzbot <syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com>,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
References: <0000000000009a59d2059dc3c8e9@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a1673e4f-6382-d7df-6942-6e4ffd2b81ce@gmail.com>
Date:   Tue, 4 Feb 2020 10:03:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0000000000009a59d2059dc3c8e9@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/20 9:58 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1111f8e6e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d0490614a000a37
> dashboard link: https://syzkaller.appspot.com/bug?extid=f0bbb2287b8993d4fa74
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db90f6e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a94511e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
> 
>

Might have been fixed already ?

commit 599be01ee567b61f4471ee8078870847d0a11e8e    net_sched: fix an OOB access in cls_tcindex

