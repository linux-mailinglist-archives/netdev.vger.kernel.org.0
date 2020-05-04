Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E691C37FB
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgEDLXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:23:31 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:40343 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDLXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 07:23:31 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 49e0af25;
        Mon, 4 May 2020 11:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=MshPdTivdQoEaiICWNo3xWGuO00=; b=IpF0KA
        T3Flp86mw4XwuAySVKKGzTvzRvxgd+j/1OZCgygCNJwSvUzC0qvPrGi6FzHBlKjP
        /uZZwjfgGZ9b9joUdSY6SmPbW8L6OCpaGwUS6iCvGOFEdJ9aAEEvDDqrVChDkFjc
        cg0ssL+i9ZZKKKmjgwwi15OvOq9Z6MyEIcLT34fmi15OJpmk/vrzmXdSYYcW9g1U
        TW/vLuvXbatTOna8Dja3WBuynAdtA6nn7nsCnG0C6hpxejT5d6LjLixcZmDZSuIG
        H+KqlweT4z0GjEkZuIRhqyGJVU5A82pmDFfLg8VxlVC+LOR9uVVXnLCaHPy3ejxF
        ywUgzniriikoQC4g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b89c4137 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 4 May 2020 11:11:05 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id w6so10874770ilg.1;
        Mon, 04 May 2020 04:23:28 -0700 (PDT)
X-Gm-Message-State: AGi0PubGAMAGEIpIOAfqwZdpRlTiYqHAsCoJ9ZauaBxFWIRowFJzrCD8
        O192DZVqMcY0F0dqhSBooDBaxkCEhK/l3BqFeCg=
X-Google-Smtp-Source: APiQypKKfDzUtssMsRFuPB9MBgpCxpRDJrla4OQThGgQpXh+dzwUnDUeYrjOVDcBl/9bz1EkcmaNqR/+tP+3OIoMfzU=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr16079991ilg.231.1588591408099;
 Mon, 04 May 2020 04:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd19505a4355311@google.com> <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
 <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
 <f2eb18ea-b32a-4b64-0417-9b5b2df98e33@gmail.com> <29bd64f4-5fe0-605e-59cc-1afa199b1141@gmail.com>
 <CAHmME9rR-_KvENZyBrRhYNWD+hVD-FraxPJiofsmuXBh651QXw@mail.gmail.com> <85e76f66-f807-ad12-df9d-0805b68133fa@gmail.com>
In-Reply-To: <85e76f66-f807-ad12-df9d-0805b68133fa@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 4 May 2020 05:23:17 -0600
X-Gmail-Original-Message-ID: <CAHmME9ocB-LUYwJTxsqui1Bh+cbKixEP-sayVNa9puY25hEASA@mail.gmail.com>
Message-ID: <CAHmME9ocB-LUYwJTxsqui1Bh+cbKixEP-sayVNa9puY25hEASA@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, kvalo@codeaurora.org,
        leon@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>, vivien.didelot@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So in spite of this Syzkaller bug being unrelated in the end, I've
continued to think about the stacktrace a bit, and combined with some
other [potentially false alarm] bug reports I'm trying to wrap my head
around, I'm a bit a curious about ideal usage for the udp_tunnel API.

All the uses I've seen in the kernel (including wireguard) follow this pattern:

rcu_read_lock_bh();
sock = rcu_dereference(obj->sock);
...
udp_tunnel_xmit_skb(..., sock, ...);
rcu_read_unlock_bh();

udp_tunnel_xmit_skb calls iptunnel_xmit, which winds up in the usual
ip_local_out path, which eventually winds up calling some other
devices' ndo_xmit, or gets queued up in a qdisc. Calls to
udp_tunnel_xmit_skb aren't exactly cheap. So I wonder: is holding the
rcu lock for all that time really a good thing?

A different pattern that avoids holding the rcu lock would be:

rcu_read_lock_bh();
sock = rcu_dereference(obj->sock);
sock_hold(sock);
rcu_read_unlock_bh();
...
udp_tunnel_xmit_skb(..., sock, ...);
sock_put(sock);

This seems better, but I wonder if it has some drawbacks too. For
example, sock_put has some comment that warns against incrementing it
in response to forwarded packets. And if this isn't necessary to do,
it's marginally more costly than the first pattern.

Any opinions about this?

Jason
