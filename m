Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151E4712F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfGWHf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:35:27 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36355 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbfGWHf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 03:35:26 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so79844058iom.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 00:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMJt7LYpGZYAS3qDDFAugtw9Yp/06nPuXjE/LheYSLE=;
        b=K6jrhJo253IdbXHUQ2A27o9l6p5GATnAvxI8zT3N0y6X+QAGISnKFWgEul1wxcxXGM
         PeDkddGcyjMaJoMx9RBdkn4BfmkMZj8kFiWcvSOX5j7ZOSbvxSaKvwcVJALnECsiV1NV
         Z25LOuY8DcmviCyU/Q5C/DzjpoNMRfUKHg8TWzZu6YHqw8gpswZx7yWdR0/3XGKuLisr
         d8uaaxIP4y7dZnuWe50t82UvtrxC5qBk1X7vYhT08svGoWBPQsS4UDSVJE3kb/A65+HU
         ucqlw77a6ABvZaKPt28RJAjoCQptAPZKkeJj4AYa+44K3U8HjFkfAb9G1SOmNEdgUAWw
         cXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMJt7LYpGZYAS3qDDFAugtw9Yp/06nPuXjE/LheYSLE=;
        b=jyjZa2P+KPDhlf0h5syXr43hUtbxnEKQfABhrolDhDIgQpDzof57fJzTYsEm5Bt71I
         tAGeMQoRl9uiMsY2BTnOcMkM7K95QoBDT1zNu5f/jOpvPtkx2myayHDxfamudVu3Rdse
         N63COFi3Jo/ZkwMXmHQirZRupILbETUhEyr/EBvMl0NpWV5o5JAKbt4T/4pT8e+vpZPC
         PoJui2WsuLEWnX6YV7Pt8JBTj9yCztqZ3twdcTYr9o0NmamZ+fuL31pvcMd2g8iok2IC
         Y9raxIgRygQjUq7kCczUXSurpwKeKGFZYzMUNozGkG3noqHESSyfX8nE2Oa8jso5pYKJ
         ukVQ==
X-Gm-Message-State: APjAAAW992GWF1xkAdrv4mvf6qyUqeezDknzVRZTxQJRIKluoLidk8Ww
        SUZDcTG3iVRZummSbViAwrqM8E5raAkH6qiUGh9aYw==
X-Google-Smtp-Source: APXvYqwo3nEQtK25A6u2jl/OWx72I0xFP+EZmhFdqZw8kcmY6COIeDdHSlCvnyVYiaHf7SdPzJX1ISu7/izvxj92zSE=
X-Received: by 2002:a6b:4101:: with SMTP id n1mr42213427ioa.138.1563867325471;
 Tue, 23 Jul 2019 00:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d8b010058e03aaf8@google.com> <000000000000fcdf6c058e076819@google.com>
In-Reply-To: <000000000000fcdf6c058e076819@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 23 Jul 2019 09:35:14 +0200
Message-ID: <CACT4Y+Z7r7iLnccJtZGJhmEY=EESw6XYKTJZwGXwvSKVNfHW1Q@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in corrupted (2)
To:     syzbot <syzbot+08b7a2c58acdfa12c82d@syzkaller.appspotmail.com>
Cc:     dave.stevenson@raspberrypi.org, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        unglinuxdriver@microchip.com, woojung.huh@microchip.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 1:56 PM syzbot
<syzbot+08b7a2c58acdfa12c82d@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 9343ac87f2a4e09bf6e27b5f31e72e9e3a82abff
> Author: Dave Stevenson <dave.stevenson@raspberrypi.org>
> Date:   Mon Jun 25 14:07:15 2018 +0000
>
>      net: lan78xx: Use s/w csum check on VLANs without tag stripping
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102feb84600000
> start commit:   49d05fe2 ipv6: rt6_check should return NULL if 'from' is N..
> git tree:       net
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=122feb84600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=142feb84600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=87305c3ca9c25c70
> dashboard link: https://syzkaller.appspot.com/bug?extid=08b7a2c58acdfa12c82d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143a78f4600000
>
> Reported-by: syzbot+08b7a2c58acdfa12c82d@syzkaller.appspotmail.com
> Fixes: 9343ac87f2a4 ("net: lan78xx: Use s/w csum check on VLANs without tag
> stripping")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

From the repro it looks like the same bpf stack overflow bug. +John
We need to dup them onto some canonical report for this bug, or this
becomes unmanageable.

#syz dup: kernel panic: corrupted stack end in dput
