Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3611B93F0
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDZU1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726176AbgDZU1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:27:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B68C061A0F;
        Sun, 26 Apr 2020 13:27:00 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so4096400pfx.7;
        Sun, 26 Apr 2020 13:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vTJAHAMO4w1usv9r2nAHSyTTMt/8kF833Hejpn2JxlM=;
        b=T82Gpc8ptWG7LSO05/xKP5AayQbZ/sxluy3IIF6ePxiLktxwR1NcI7S4/Fh5Kf8uMJ
         2IAtNszONmRCHxApd07MJ1/u6umxPD7SEA5NA9qWxaSodQyr6i6rfAMCeNOu9ardVS1y
         pFW96vxRkeGqoH//3ZNNaIoiRLFguw3pEoVHMhktijYKLPrxoYmg162WKhc9qmzNvKXG
         htMHhLhtaIFDRyup/rCHRYEZAfbWl+cR5UcZKN9YAho23nfpmWYkKAWUvgfrQifQpT0O
         STiiFB0mSPD/Y2lDNI7LHksfdneo2QKiy+rBXbJCzXzGoQGMI3FI7XBfudOHSiz00YwK
         88bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vTJAHAMO4w1usv9r2nAHSyTTMt/8kF833Hejpn2JxlM=;
        b=IC7QQB9l9w2EqSDU2NuiLAqNki0okTIVRf4b0fwN4cytBfye309GblIdkAMKZPDohG
         kVTaFXqEJ65bfVujTELta5YyIH//GcgwfrFqokep8JszDTZJ5f+TPrA+Al9McbGC0i0e
         b2cJLhEZpM4ct1G1zTsoQ54ywyyIxA1MeAB2S8nsGqbmjw4aEeXO1iajlzvh8gVNKjaf
         9m2YSOevjdtT46zv57vCzHpxAzxtFpm/Po6F9YNFG1oySafz5vdwWt6F6L3WsiODqsmO
         Zbtfmznx/QnRTwlsv6C48meCGzBfjg/DeLlFO4NT0+HvtlkW3pje3MScmgsRD34taCqN
         UF+g==
X-Gm-Message-State: AGi0PuZZ0dvm8zkqL3meH640e/d7XDTSisTvdCSb7ciDrgk3DMKYn0VR
        ZfIonVGCU+vE0D3Nx9f2enU=
X-Google-Smtp-Source: APiQypLyIrqWODgQRUdxnMw09DNhDjdNmLBUAU5v04X/9Ys2aG7jfmfTcPaQ3XhPbkpvF3De46nfJA==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr20467058pgm.322.1587932819918;
        Sun, 26 Apr 2020 13:26:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q11sm3748378pfl.97.2020.04.26.13.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:26:59 -0700 (PDT)
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jhs@mojatatu.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Krzysztof Kozlowski <krzk@kernel.org>, kuba@kernel.org,
        kvalo@codeaurora.org, leon@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>, vivien.didelot@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <0000000000005fd19505a4355311@google.com>
 <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
 <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f2eb18ea-b32a-4b64-0417-9b5b2df98e33@gmail.com>
Date:   Sun, 26 Apr 2020 13:26:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/20 12:42 PM, Jason A. Donenfeld wrote:
> On Sun, Apr 26, 2020 at 1:40 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 4/26/20 10:57 AM, syzbot wrote:
>>> syzbot has bisected this bug to:
>>>
>>> commit e7096c131e5161fa3b8e52a650d7719d2857adfd
>>> Author: Jason A. Donenfeld <Jason@zx2c4.com>
>>> Date:   Sun Dec 8 23:27:34 2019 +0000
>>>
>>>     net: WireGuard secure network tunnel
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15258fcfe00000
>>> start commit:   b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
>>> git tree:       upstream
>>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17258fcfe00000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13258fcfe00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
>>> userspace arch: i386
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000
>>>
>>> Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
>>> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
>>>
>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>
>>
>> I have not looked at the repro closely, but WireGuard has some workers
>> that might loop forever, cond_resched() might help a bit.
> 
> I'm working on this right now. Having a bit difficult of a time
> getting it to reproduce locally...
> 
> The reports show the stall happening always at:
> 
> static struct sk_buff *
> sfq_dequeue(struct Qdisc *sch)
> {
>        struct sfq_sched_data *q = qdisc_priv(sch);
>        struct sk_buff *skb;
>        sfq_index a, next_a;
>        struct sfq_slot *slot;
> 
>        /* No active slots */
>        if (q->tail == NULL)
>                return NULL;
> 
> next_slot:
>        a = q->tail->next;
>        slot = &q->slots[a];
> 
> Which is kind of interesting, because it's not like that should block
> or anything, unless there's some kasan faulting happening.
> 

I am not really sure WireGuard is involved, the repro does not rely on it anyway.


