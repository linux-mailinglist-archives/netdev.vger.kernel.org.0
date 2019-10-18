Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF8DCD12
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505577AbfJRRy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:54:26 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44787 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502168AbfJRRyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:54:25 -0400
Received: by mail-qk1-f196.google.com with SMTP id u22so6057475qkk.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 10:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=s8mguofZ5g2z9BEXRZzmtqhsRhBPNE30erCrJ75SXPI=;
        b=eqE2vqJ6jR9z2w7DpMb9so6iePE9d1xCV5vyxx9EgxLl6W7pvXM0PuOQjrE9Q11nlF
         HyJnhhiyexjjkzOdCdykcaSqdufAnybc1yrNruPNejHubTppgdZdvcrFNsU67w1mxFfo
         1xdiMpKxs9i95IBNNpe30k2XjSXYQA8LcES90uJAiRoi2lzT5ET63KmyWfkln/RG4bq5
         4w7JP7Le7VzexrQAeqHFTVpbfzl/XP4bhziuDarX+iBkLh8UWLOapkR1lbv+B5iEz7lM
         mDEcoMs1y+nQKZbjVtp/HTeXZa6sH7o9NxQbZzcCYeVIOjm7fIftIzXAoCbTtdKktUj4
         f6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=s8mguofZ5g2z9BEXRZzmtqhsRhBPNE30erCrJ75SXPI=;
        b=blgMM6Rhm2i/5n5s8tst+RMjSpbmWGE5Iw1xSfI4Sh7sDatw4I/5XxRQdG90g8HYh6
         J/gK8lH2yrCJ7XfwI7+Txod6Mvgr4At8dis73DP0dDnWDPHLaJNglAX4PEXfBb91KNgO
         /fLnqwGppo6kRx5l4Zo6QxLEA7W/blsdSUNg0f3ooOTlWLgVHVEU26IQ1dDQ9heQbaQ7
         +dE330B9A9kVM2oeRF1gCVi7Kgi8P13692LF3i2/2hPpqq0SE6jqTvUAoOenaNM2fEfZ
         g6z0lUpiiGvIns3Hd64VqLVeEsfljguewSxLGwM+tC5jsZozsfiXHMuoA7RK2QVE5r2s
         w04g==
X-Gm-Message-State: APjAAAXHUqJGcw32ziRI6E9JKP/oQrDlQyVwpBC5gHgifdL5U9lBJU3T
        QkUG0qGiB+9pmcTWaMY8ajeDYn/QvKmRaHET+0st7FQT
X-Google-Smtp-Source: APXvYqysEdg4GPrP1dmiapyi/Z/MJGXlotgKzAw3se670H2BallYfN6xZ+t83dQvimZ4+yqyiS4wlolXSBbJAmj5cHY=
X-Received: by 2002:a37:e407:: with SMTP id y7mr9528245qkf.77.1571421264548;
 Fri, 18 Oct 2019 10:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAN1eFqgZQ4exQSbZVk+dPMQHEjD87Q7C5C5ADqgD_-0_rZ7GDg@mail.gmail.com>
In-Reply-To: <CAN1eFqgZQ4exQSbZVk+dPMQHEjD87Q7C5C5ADqgD_-0_rZ7GDg@mail.gmail.com>
From:   Rajendra Dendukuri <rajen83@gmail.com>
Date:   Fri, 18 Oct 2019 13:54:13 -0400
Message-ID: <CAN1eFqgvpM36Wvr6HtXrmb4HnxVZMZXacLwasj4-hj2KNFoe9A@mail.gmail.com>
Subject: Re: Crash in in __skb_unlink during net_rx_action
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I find that below patch  was not applied 4.9.y. Can this be a possible
fix for the crash that is observed here.

net: properly flush delay-freed skbs
f52dffe049ee11ecc02588a118fbe4092672fbaa

On Tue, Oct 15, 2019 at 8:31 PM Rajendra Dendukuri <rajen83@gmail.com> wrote:
>
> Observed below kernel oops on "Linux version 4.9.0-9-2-amd64" from Debian 9.
>
> This was observed when bridge vlan netdevs were getting deleted while
> packets were being received. I observed this only once, but wanted to
> put it out there for the record. Below is the decoded call path. It
> appears to be in the elementary pkt handling function. I searched for
> upstream commits for any patches around this code but could not find
> anything. Any thoughts on what it might be about while I try to figure
> out the test case to simulate the panic condition again.
>
> process_backlog()  ---- __skb_dequeue()  --- __skb_unlink()  --
> next->prev = prev; (Panic)
>
>
> [12106.283243] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000008
> [12106.292014] IP: [<ffffffff9ab1265c>] process_backlog+0x7c/0x130
> [12106.298643] PGD 0 [12106.300691]
> [12106.302356] Oops: 0002 1 SMP
> <SNIP>
> [12106.456408] task: ffff8a0aad1ed140 task.stack: ffff950741980000
> [12106.463027] RIP: 0010:[<ffffffff9ab1265c>] [<ffffffff9ab1265c>]
> process_backlog+0x7c/0x130
> <SNIP>
> [12106.584667] Call Trace:
> [12106.587403] [<ffffffff9ab11df6>] ? net_rx_action+0x246/0x380
> [12106.593827] [<ffffffff9ac1e81d>] ? __do_softirq+0x10d/0x2b0
> [12106.600152] [<ffffffff9a69d560>] ? sort_range+0x20/0x20
> [12106.606090] [<ffffffff9a67ff5e>] ? run_ksoftirqd+0x1e/0x40
> [12106.612318] [<ffffffff9a69d66e>] ? smpboot_thread_fn+0x10e/0x160
> [12106.619130] [<ffffffff9a699dd9>] ? kthread+0xd9/0xf0
> [12106.624776] [<ffffffff9a699d00>] ? kthread_park+0x60/0x60
> [12106.630908] [<ffffffff9ac1aeb7>] ? ret_from_fork+0x57/0x70
