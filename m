Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEE4242B39
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHLOTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 10:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgHLOTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 10:19:50 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF772C061383;
        Wed, 12 Aug 2020 07:19:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 185so2424788ljj.7;
        Wed, 12 Aug 2020 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qaFF1cuZrCftEln/DvH88Nq1YmHTHq4hx2BD8n/L0fY=;
        b=lp6jMlnl6BK6p0xieLueLjdqJUlck6HCCDZjySQqhQ39kDY6XdMKdlExwuw1eFNMj3
         aDoK4waKQhJUA9ahJsaWTIrJCthhDRBjD6PDMJF9qgVmQBFT3/emqXHGfeOR+YkmC5LL
         h4UL3SsFS+qk8sTx1opNUGN10Dn9OwtNISblR2fhtY0I0FODDy8GZd/wXSoyWAF1ySRN
         uHV0RGU+34GehGuUjSPPg0hXOxEDv1q8EMXToql7vKQb5tq5kCeDRflnLNdwed5sHOuY
         0FTbImxF8t1nuFJkLFAJtOdofP2xFfXecKtxrMbd41rttKfewXHqFLnpTJUw9qOeF/Nc
         X8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qaFF1cuZrCftEln/DvH88Nq1YmHTHq4hx2BD8n/L0fY=;
        b=bAqL26RdNfVMFgLRhfe7f6Kdh11cXqENBHiYN3oXe+KywmmLj4LovX40LFzmGXnEQs
         SU1TTy7y5hLIkNzCN+g5lmxTS9sLTWdBekBf+itlXe68bwAFAoM0CSbbUatm03VfQXmv
         tFWdg6oSF4rEp0ZR4DZFZ79rjuylu8pWyeV2P3c/mzIe3KN5VB1+zQp0NVAi8VkMINX+
         dv0GahCMfDzmTq/kqdsPgl1RfHOA+Wy4QQFTqYEe0ruouNeInVhz0fHtbG6hBdX0E9qF
         57/MfD/y6Sk6w5F5Xijh8qFPAxr1r60sL3EMsOrQ+2c5rYCunosT9N55IHy7uJV5zOsO
         QvtQ==
X-Gm-Message-State: AOAM532SYEl9idnHqL7BVYhNSVXYku2+StFC957me9Zi1Ly+JOjwTFs8
        KyPyodte/bnHnJuMflCuht29Hk8y9Rj1M5PBqWw=
X-Google-Smtp-Source: ABdhPJzmO9mppslO1BW3Hc8I1cyCZqztX+Oc6RwKl++4PtZHahW4B/NtkTBcXE5ywquMXs9+LlZeOr26GDvLTDbPM/M=
X-Received: by 2002:a2e:9f02:: with SMTP id u2mr5549862ljk.128.1597241988380;
 Wed, 12 Aug 2020 07:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d4adc705ac87ba8e@google.com> <20200810183057.GF3399@localhost.localdomain>
In-Reply-To: <20200810183057.GF3399@localhost.localdomain>
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Wed, 12 Aug 2020 16:19:37 +0200
Message-ID: <CABUN9aDV4yKcoQvMf=griMsx40_tr5sEH9Dod2NnakoC6UwrJg@mail.gmail.com>
Subject: Re: general protection fault in sctp_ulpevent_notify_peer_addr_change
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     syzbot <syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 8:31 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Aug 10, 2020 at 08:37:18AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12f34d3a900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=50463ec6729f9706
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8f2165a7b1f2820feffc
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1517701c900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b7e0e2900000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8f2165a7b1f2820feffc@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc000000004c: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000260-0x0000000000000267]
> > CPU: 0 PID: 12765 Comm: syz-executor391 Not tainted 5.8.0-syzkaller #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0xa9/0xad0 net/sctp/ulpevent.c:346
>
> Crashed in code added by 45ebf73ebcec ("sctp: check assoc before
> SCTP_ADDR_{MADE_PRIM, ADDED} event"), but it would have crashed a
> couple of instructions later on already anyway.
>
> I can't reproduce this crash, with the same commit and kernel config.
> I'm not seeing how transport->asoc can be null at there.
>
I haven't been able to reproduce this yet either.

Doesn't this report have similarities with "general protection fault
in sctp_ulpevent_nofity_peer_addr_change" from 19 March 2020?
https://syzkaller.appspot.com/bug?extid=3950016bd95c2ca0377b
