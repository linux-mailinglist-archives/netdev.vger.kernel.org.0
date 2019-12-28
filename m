Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE41612BDD4
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 16:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfL1PBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 10:01:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55648 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfL1PBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 10:01:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so8853488wmj.5;
        Sat, 28 Dec 2019 07:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yC8Wr593B5wtduw4VrkVjj/ZwxY8V1O2vaeIv87237A=;
        b=bVnktZvqowVmBzHkkb0JPOie+l2SpZIWi0alFHTXC6F/3uqR0LNh6CcsdgK4WQGBT7
         vHMu6QDUKXNR6VRT0HSYKbrclT9VKVAe3Vf1RS6VJlOnac+LmiZaY5OFFGLsUc3sR5GG
         ZiGsBCTkLahtxwYU4Z+q5He0lY2wK98WVr5n+TN4XdOICJ4snmDHC0VZmlB2Q8voGnIt
         SQMbt5fHtjiolFYe1qaK4z88olCwGdzUjzDLwXAqzJMsBFuSC/d8ZgMxICA/3gsbuOdN
         HtT8f3Y8Nq5jzs6rCJq8b9kHNRm+p8HNRPIZ/BLhrfC3k+Ulw7SWMflugrRCU3mh9UjP
         3cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yC8Wr593B5wtduw4VrkVjj/ZwxY8V1O2vaeIv87237A=;
        b=VM0SUJd/VGO2xkf154axv+9W3PjYr3O0L1023lLXOC8wZ5NP778cH6n3ipeIboAMZ9
         XeLqyMHtRFvgFgnihu0OIT4zrITj0qvSiBbRuVoZFMin3zIBkTCe3sEEOFbwQSxU6BlE
         BdjvpCBiy+x5Dl2p7X44l49wYl0A1LFz3YkXi/wA1kJS67XEcGNezL+tkFmRWslG09v2
         QSKQ0BX7oF9O1w1m0YfizPz3N5G+dmgSR36Kciiq0onh8UyBaZNc/nzyMFua1oHKPVLj
         Map90cyDF384pXkK3zAHEXGQGz6omq/FsADGIlAnESJYf3NkSSQLMYflBmEu24UpRY9i
         hNTA==
X-Gm-Message-State: APjAAAWoYrDYwzDB9C0xz0M0jzzn1X3kVkhs+vrgqjEbv4+muT/n8kcB
        i6cumg+C1ALuedNgIUb+smA=
X-Google-Smtp-Source: APXvYqxzyRETFWCnJn23zt24iJDf9apLhnEN+OkRL+WGG0/53gfZkDaWbVVE9rd6Z9oCawAQPrJGZA==
X-Received: by 2002:a1c:7e0b:: with SMTP id z11mr23123806wmc.88.1577545306424;
        Sat, 28 Dec 2019 07:01:46 -0800 (PST)
Received: from [192.168.8.147] (252.165.185.81.rev.sfr.net. [81.185.165.252])
        by smtp.gmail.com with ESMTPSA id z123sm14770824wme.18.2019.12.28.07.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 07:01:45 -0800 (PST)
Subject: Re: INFO: rcu detected stall in br_handle_frame (2)
To:     Florian Westphal <fw@strlen.de>,
        syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        eric.dumazet@gmail.com
References: <000000000000f9f9a8059a737d7e@google.com>
 <20191228111548.GI795@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <30e6a8c6-b857-00b8-24d8-076b92409636@gmail.com>
Date:   Sat, 28 Dec 2019 07:01:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191228111548.GI795@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/28/19 3:15 AM, Florian Westphal wrote:
> syzbot <syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com> wrote:
> 
> [ CC Eric, fq related ]
> 
>> syzbot found the following crash on:
>>
>> HEAD commit:    7e0165b2 Merge branch 'akpm' (patches from Andrew)
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=116ec09ee00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1b59a3066828ac4c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dc9071cc5a85950bdfce
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159182c1e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1221218ee00000
>>
>> Bisection is inconclusive: the bug happens on the oldest tested release.
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158224c1e00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=178224c1e00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=138224c1e00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
>>
>> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>> 	(detected by 0, t=10502 jiffies, g=10149, q=201)
>> rcu: All QSes seen, last rcu_preempt kthread activity 10502
>> (4294978441-4294967939), jiffies_till_next_fqs=1, root ->qsmask 0x0
>> sshd            R  running task    26584 10034   9965 0x00000008
>> Call Trace:
>>  <IRQ>
>>  sched_show_task kernel/sched/core.c:5954 [inline]
> [..]
> 
> The reproducer sets up 'fq' sched with TCA_FQ_QUANTUM == 0x80000000
> 
> This causes infinite loop in fq_dequeue:
> 
> if (f->credit <= 0) {
>   f->credit += q->quantum;
>   goto begin;
> }
> 
> ... because f->credit is either 0 or -2147483648.
> 
> Eric, what is a 'sane' ->quantum value?
> 
> One could simply add a 'quantum > 0 && quantum < INT_MAX'
> constraint afaics.
> 
> If you don't have a better idea/suggestion for an upperlimit INT_MAX
> would be enough to prevent perpetual <= 0 condition.
> 

Thanks Florian for the analysis.

I guess we could use a conservative upper bound value of (1 << 20)
( about 16 64KB packets )

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index ff4c5e9d0d7778d86f20f4bd67cc627eed0713d9..12f1d1c6044fac9db987f7ce3a50a7e2c711358b 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -786,15 +786,20 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
        if (tb[TCA_FQ_QUANTUM]) {
                u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
 
-               if (quantum > 0)
+               if (quantum > 0 && quantum <= (1 << 20))
                        q->quantum = quantum;
                else
                        err = -EINVAL;
        }
 
-       if (tb[TCA_FQ_INITIAL_QUANTUM])
-               q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
+       if (tb[TCA_FQ_INITIAL_QUANTUM]) {
+               u32 quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
 
+               if (quantum > 0 && quantum <= (1 << 20))
+                       q->initial_quantum = quantum;
+               else
+                       err = -EINVAL;
+       }
        if (tb[TCA_FQ_FLOW_DEFAULT_RATE])
                pr_warn_ratelimited("sch_fq: defrate %u ignored.\n",
                                    nla_get_u32(tb[TCA_FQ_FLOW_DEFAULT_RATE]));

