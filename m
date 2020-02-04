Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9940A15230C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 00:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBDXk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 18:40:28 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55615 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbgBDXk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 18:40:28 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so117662pjz.5;
        Tue, 04 Feb 2020 15:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AuKl94TVo6mkfdN2jlde8F62+0Ds+RYZaGHAl/YB5GM=;
        b=Lkv60p7LHGEIs1aeMxJVgf1XrV2+SHx0pc6zjfYjxglh+fyMMaFTcgHCtuNP1ooUEX
         Y5I3l/MklFQRbIvnWGFxw/q9liwrsJ0znXA7eGYFyziNbEmOk7p4gWSQG1uiKbwPRVHW
         mifNqF/ydnrSxcGWHXzODu5Pi7esqsvrmPa/+4HTHZKx1HMG6t8fiNlOSckXlTA32ZQj
         OQc63d8VZhUNQzezE1mBkgnz0VS/8a6E0i4q5dfO3MbzVXZCh57Afj1MaRWEhTAP8ZJR
         fKgGN2QhB9x5yJLCGvjYPN9TfusqjxkpcNbEggSlGczMObyjjiJoLgsz3xmJDiRiDrmA
         GShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AuKl94TVo6mkfdN2jlde8F62+0Ds+RYZaGHAl/YB5GM=;
        b=h2Jes37SXfZI7TW2l8EqbHEMzQrShm6BsMQoLBA920dZ5A40LzHI0ic1Bfo/+cK0mW
         aC6cd346vf0XpkrhmS4DQR39uFQ6w5J+nkBASbm8sqz0p9A8iO7QjVlzHYBsmQCh4BA0
         n8Lrh1uLcBZhD8NRenStv3mw3Fu93fGfTdSEwHkIZKPDeq4W1MiZYhnleLgPMA5RcBEH
         W6MXaGaQO+pVP/1nILafmzKby9xV0GOUjUmilUXIKU9Q6rJ0SM3xKJeYWKMGrSuUfyTD
         eFZCNQnpkI8wGRV8VKAUWQ83OIoaiXnpkoTvRfrwWeaz7oHgdGNXHaZbq265InFbmYVX
         FuJA==
X-Gm-Message-State: APjAAAU0L2E2TlShMReChfxEBp9kCwrxizarCVB3MouCCpjGMaO1dFzs
        EagjRQExqQiqCQMbLr+LUgA=
X-Google-Smtp-Source: APXvYqxUYqgrxXhDBuc1ZHCkZDpZ+ygztjXvWAtKEJEjnmr4KFmtiCCiksj6ydhDXfMaCbklJKq+DQ==
X-Received: by 2002:a17:90a:b106:: with SMTP id z6mr2041760pjq.91.1580859627881;
        Tue, 04 Feb 2020 15:40:27 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w8sm24922419pfn.186.2020.02.04.15.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 15:40:27 -0800 (PST)
Subject: Re: memory leak in tcindex_set_parms
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <0000000000009a59d2059dc3c8e9@google.com>
 <a1673e4f-6382-d7df-6942-6e4ffd2b81ce@gmail.com>
 <20200204.222245.1920371518669295397.davem@davemloft.net>
 <CAM_iQpVE=B+LDpG=DpiHh_ydUxxhTj_ge-20zgdB4J1OqAfCtQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <787030ee-ff3e-8eae-3526-24aa8251bcc6@gmail.com>
Date:   Tue, 4 Feb 2020 15:40:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVE=B+LDpG=DpiHh_ydUxxhTj_ge-20zgdB4J1OqAfCtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/20 2:26 PM, Cong Wang wrote:
> On Tue, Feb 4, 2020 at 1:22 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Tue, 4 Feb 2020 10:03:16 -0800
>>
>>>
>>>
>>> On 2/4/20 9:58 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following crash on:
>>>>
>>>> HEAD commit:    322bf2d3 Merge branch 'for-5.6' of git://git.kernel.org/pu..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1111f8e6e00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d0490614a000a37
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=f0bbb2287b8993d4fa74
>>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db90f6e00000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a94511e00000
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>>> Reported-by: syzbot+f0bbb2287b8993d4fa74@syzkaller.appspotmail.com
>>>>
>>>>
>>>
>>> Might have been fixed already ?
>>>
>>> commit 599be01ee567b61f4471ee8078870847d0a11e8e    net_sched: fix an OOB access in cls_tcindex
>>
>> My reaction was actually that this bug is caused by this commit :)
> 
> I think it is neither of the cases, I will test the following change:
> 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 09b7dc5fe7e0..2495b15ca78c 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -454,6 +454,7 @@ tcindex_set_parms(struct net *net, struct
> tcf_proto *tp, unsigned long base,
>         oldp = p;
>         r->res = cr;
>         tcf_exts_change(&r->exts, &e);
> +       tcf_exts_destroy(&e);
> 

The only thing the repro fires for me on latest net tree is an UBSAN warning about a silly ->shift

I have not tried it on the old kernel.

[  170.331009] UBSAN: Undefined behaviour in net/sched/cls_tcindex.c:239:29
[  170.337729] shift exponent 19375 is too large for 32-bit type 'int'


diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 0323aee03de7efbb99c7943be078765c74dfdf2e..42436ae61b7a64a7244a9df03dc397e5aa103a86 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -339,9 +339,13 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
        if (tb[TCA_TCINDEX_MASK])
                cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
 
-       if (tb[TCA_TCINDEX_SHIFT])
+       if (tb[TCA_TCINDEX_SHIFT]) {
                cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-
+               if (cp->shift > 16) {
+                       err = -EINVAL;
+                       goto errout;
+               }
+       }
        if (!cp->hash) {
                /* Hash not specified, use perfect hash if the upper limit
                 * of the hashing index is below the threshold.
