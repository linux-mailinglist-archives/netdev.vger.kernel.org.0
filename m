Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA31B9403
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgDZUqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:46:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33857 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZUqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 16:46:21 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 39088fed;
        Sun, 26 Apr 2020 20:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Ugp9J23dMwybD+BDDgKHZnVK/uQ=; b=M93KN1
        ims8o7fabG8/3QNssmzDkhKoonmWf+LPFGKE32qJUrW8Z9fiuA4J1XsJpPmcsRAe
        0d3EuIEyyX5VXdKVQku9Y0zOjGz/R3v80OKwPryYM3+igeWXQZzg0B7JSDJ12R8v
        hQzwhSATbPnA+oERLyN7UFXlq5lG0tBKLt2pv/DHDzcWGFVfAZY/1OZs7aGYS42O
        yR2RuBpCvQGOVUOZsSBTqNIQnrjVeKIudHLjWUq1cq7sBJqej2bZOGLsseywhglc
        nGlKv8ckvQeOI3PFGBtshQF1H7jhSjxGKxXrwIMWYMfPDbafq89M8d5lEqqvhN4v
        2CV87IyEaw1TS8UQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7397de7a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 26 Apr 2020 20:34:52 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id o127so16713472iof.0;
        Sun, 26 Apr 2020 13:46:17 -0700 (PDT)
X-Gm-Message-State: AGi0PuZOiASB2NqESmK4+wEVWpZD+T8wGgWAgS5nK1EMZTJRuHRJPWtr
        tDs6wHVTdsaDhIuRrnH1jQqewATj21n9uocCyjE=
X-Google-Smtp-Source: APiQypIOFLRFU/qIcLAa17exOMXrSKTlgt3AbZGePL0ys5e9a3KrxK4I6jN7+7FaQuIL/ajx3eFVKkj9+14titKCq0U=
X-Received: by 2002:a02:b88e:: with SMTP id p14mr16955187jam.36.1587933976357;
 Sun, 26 Apr 2020 13:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd19505a4355311@google.com> <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
 <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
 <f2eb18ea-b32a-4b64-0417-9b5b2df98e33@gmail.com> <29bd64f4-5fe0-605e-59cc-1afa199b1141@gmail.com>
In-Reply-To: <29bd64f4-5fe0-605e-59cc-1afa199b1141@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 26 Apr 2020 14:46:05 -0600
X-Gmail-Original-Message-ID: <CAHmME9rR-_KvENZyBrRhYNWD+hVD-FraxPJiofsmuXBh651QXw@mail.gmail.com>
Message-ID: <CAHmME9rR-_KvENZyBrRhYNWD+hVD-FraxPJiofsmuXBh651QXw@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     Eric Dumazet <eric.dumazet@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 2:38 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 4/26/20 1:26 PM, Eric Dumazet wrote:
> >
> >
> > On 4/26/20 12:42 PM, Jason A. Donenfeld wrote:
> >> On Sun, Apr 26, 2020 at 1:40 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>>
> >>>
> >>>
> >>> On 4/26/20 10:57 AM, syzbot wrote:
> >>>> syzbot has bisected this bug to:
> >>>>
> >>>> commit e7096c131e5161fa3b8e52a650d7719d2857adfd
> >>>> Author: Jason A. Donenfeld <Jason@zx2c4.com>
> >>>> Date:   Sun Dec 8 23:27:34 2019 +0000
> >>>>
> >>>>     net: WireGuard secure network tunnel
> >>>>
> >>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15258fcfe00000
> >>>> start commit:   b2768df2 Merge branch 'for-linus' of git://git.kernel.org/..
> >>>> git tree:       upstream
> >>>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17258fcfe00000
> >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13258fcfe00000
> >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=0251e883fe39e7a0cb0a
> >>>> userspace arch: i386
> >>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f5f47fe00000
> >>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e8efb4100000
> >>>>
> >>>> Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
> >>>> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> >>>>
> >>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> >>>>
> >>>
> >>> I have not looked at the repro closely, but WireGuard has some workers
> >>> that might loop forever, cond_resched() might help a bit.
> >>
> >> I'm working on this right now. Having a bit difficult of a time
> >> getting it to reproduce locally...
> >>
> >> The reports show the stall happening always at:
> >>
> >> static struct sk_buff *
> >> sfq_dequeue(struct Qdisc *sch)
> >> {
> >>        struct sfq_sched_data *q = qdisc_priv(sch);
> >>        struct sk_buff *skb;
> >>        sfq_index a, next_a;
> >>        struct sfq_slot *slot;
> >>
> >>        /* No active slots */
> >>        if (q->tail == NULL)
> >>                return NULL;
> >>
> >> next_slot:
> >>        a = q->tail->next;
> >>        slot = &q->slots[a];
> >>
> >> Which is kind of interesting, because it's not like that should block
> >> or anything, unless there's some kasan faulting happening.
> >>
> >
> > I am not really sure WireGuard is involved, the repro does not rely on it anyway.
> >
>
> Yes, do not spend too much time on this.
>
> syzbot found its way into crazy qdisc settings these last days.
>
> ( I sent a patch yesterday for choke qdisc, it seems similar checks are needed in sfq )

Ah, whew, okay. I had just begun instrumenting sfq (the highly
technical term for "adding printks everywhere") to figure out what's
going on. Looks like you've got a handle on it, so I'll let you have
at it.

On the brighter side, it seems like Dmitry's and my effort to get full
coverage of WireGuard has paid off in the sense that tons of packets
wind up being shoveled through it in one way or another, which is
good.
