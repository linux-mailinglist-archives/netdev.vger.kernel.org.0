Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E59E1B93CC
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgDZT6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:58:35 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36819 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgDZT6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 15:58:34 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2286339d;
        Sun, 26 Apr 2020 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Tji6nhcoiQ4mNmbOVGUplvpgPlU=; b=DGuTRL
        wAO4D7sQUj9rbyz5PQi4REziJ46zX8MAl/xxRdTvZs2GH1bzQEziClrBWTGpuSkw
        DPpoKoZR4iViGSmbg66NJO6XCo7IITjOxhlf7+2dmnasfxtwXGznREWzMVa1QbK+
        Sa0fFXVJc5XAPokH8Unv4P8r9iAa2kYN4xTQOU0QC89t8QW3RYSCcI8xXRfmwqb8
        RYK8R36Lqs8LKbUEzkbEJRrqxHIIdt+ccEchMmBIJw0bcUElJVsb1BAB/zewQuaJ
        9yPA/s/jJdX9fjxGevj7o5Ak9Tdr1N+IpuNsChcFuo76b7u3kw4WW9nKKic99m3T
        DRKjz9W+M5OZHF4A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e650dba7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 26 Apr 2020 19:47:07 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id e9so16582671iok.9;
        Sun, 26 Apr 2020 12:58:32 -0700 (PDT)
X-Gm-Message-State: AGi0PuZckDh7XgB7kdP5EAVLDndxt1+eDBhH863a3APzR0tnXrJXwrMf
        b5gP1fTdUZ9baPwdhSELyA7vC+JGJzB+0ZguzpQ=
X-Google-Smtp-Source: APiQypJhlOdeUIY7eyvappiPYS4AodHmJxQ4hDLTjQ93EdBxFvUDW6WI3qbfdHV2mBNdM+uKlj5w7Qt4ca+CDLryJek=
X-Received: by 2002:a6b:7114:: with SMTP id q20mr17580244iog.79.1587931111259;
 Sun, 26 Apr 2020 12:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd19505a4355311@google.com> <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
 <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com> <CAHmME9rxYkDhH3Fj-U24Ho7oGcdABK9hXsACPDQ1rz9WUcEuSQ@mail.gmail.com>
In-Reply-To: <CAHmME9rxYkDhH3Fj-U24Ho7oGcdABK9hXsACPDQ1rz9WUcEuSQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 26 Apr 2020 13:58:20 -0600
X-Gmail-Original-Message-ID: <CAHmME9rzqNVf24jw8YxJfck2m=4ZUSfVx1w5LUP4qNxQv2Purw@mail.gmail.com>
Message-ID: <CAHmME9rzqNVf24jw8YxJfck2m=4ZUSfVx1w5LUP4qNxQv2Purw@mail.gmail.com>
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

On Sun, Apr 26, 2020 at 1:52 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> It looks like part of the issue might be that I call
> udp_tunnel6_xmit_skb while holding rcu_read_lock_bh, in
> drivers/net/wireguard/socket.c. But I think there's good reason to do
> so, and udp_tunnel6_xmit_skb should be rcu safe. In fact,
> every.single.other user of udp_tunnel6_xmit_skb in the kernel uses it
> with rcu locked. So, hm...

In the syzkaller log, it looks like several runs are hitting:

run #0: crashed: INFO: rcu detected stall in netlink_sendmsg

And other runs are hitting yet different functions. So actually, it's
not clear that this is the fault of the call to udp_tunnel6_xmit_skb.
