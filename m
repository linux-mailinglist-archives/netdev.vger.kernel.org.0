Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C65377C16
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 08:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhEJGLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 02:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 02:10:59 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1353DC061574
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 23:09:55 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id y12so11166837qtx.11
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 23:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eGZtaov/2jLp363MbdipRXDLJ+YxSvxBrC/OhuvnYEY=;
        b=Tv8XwToGZImRnH+ZMmuLTzHnVD5UsM8Ex7xEdqPm1D286RgzDjkHSFL0rdq9Uztdcm
         JKvFQjM9F6f3o3Edwo3OuHurfKBFErCcapmgs0Rk92eOaFWQ3WWXHM54dbH+bSk+l3ih
         EaeWoHl1D7IbFxHdBPgNQdDRqiR4X3JIXrYFss6a1TeAV98Z/tc1QJEAJEND5qfAQ7nE
         BJK+uRT2WRin8d3NqVW71PZxNHSzckNzDtUPnF8N96GpRdhvXRwUmAcBEgPvRyXjtvf/
         eV65vqynzK4bNnmHBUkr2Ab9QZ9AOxK0VTC2iL7nqSy5LcjR4e2NOK9qYcuoYPJKiSQz
         tKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eGZtaov/2jLp363MbdipRXDLJ+YxSvxBrC/OhuvnYEY=;
        b=PWXIUHJDtWkjnDYW1r+aLi0rtTOP6JBGpYMfQSKkBe7qFn7hDT6S028OZuinhbZWs6
         1hRPD/tj6uaXC1vGVIxMjJUFKb54dntFdJeqmuxIcoarBDkvb9YUgmJv6vIfXmBaVzr2
         5YKQKDP+x2t0B6WGxyQTzoy8U10GYDoyKjCQpZ2SFpfvCyCVx6xyzKj8pGf6oJhBeVVn
         994zbA7N1liWnDb8MhvvM0dOHStsHfVupjdDOouVTOJVpU01dwMSvAj8+Im7UqOjovpG
         3Orj+wDw4lvbPPdIlxdQcrHo6fqSlWNyjy7GcaldefF141Rdm3aTX9KE0unpf2V8dbSi
         jrhQ==
X-Gm-Message-State: AOAM531eOyOeQTpBXqp66eD5jRLGPK5rEu/NPBRqoKMuMbpbFBKpcT2Y
        49EEcAc+7WnkG8JI6D9zGdVjvCRA1UCZAFcJBHQg6g==
X-Google-Smtp-Source: ABdhPJwDXNAJ7rqPdsxdvS37L/b6fPAlZK2aUqvtF7QMNjEjv477/3kILJBGFyURKDos3ry5nTQ9UROQCms1gkuN9xY=
X-Received: by 2002:ac8:110d:: with SMTP id c13mr20896043qtj.337.1620626993742;
 Sun, 09 May 2021 23:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009f94c1057e772431@google.com> <000000000000e5b92105c1e723d5@google.com>
In-Reply-To: <000000000000e5b92105c1e723d5@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 10 May 2021 08:09:42 +0200
Message-ID: <CACT4Y+a-WdDEJEx=E7gr2ci0F6U8ncvMgVSzph00H7U_qmc+_Q@mail.gmail.com>
Subject: Re: [syzbot] WARNING in hsr_forward_skb
To:     syzbot <syzbot+fdce8f2a8903f3ba0e6b@syzkaller.appspotmail.com>
Cc:     arvid.brodin@alten.se, Jens Axboe <axboe@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Jakub Kicinski <kuba@kernel.org>, kurt@linutronix.de,
        linux-block <linux-block@vger.kernel.org>,
        linux-can@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        m-karicheri2@ti.com, Ming Lei <ming.lei@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 9, 2021 at 5:16 PM syzbot
<syzbot+fdce8f2a8903f3ba0e6b@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 9d6803921a16f4d768dc41a75375629828f4d91e
> Author: Kurt Kanzenbach <kurt@linutronix.de>
> Date:   Tue Apr 6 07:35:09 2021 +0000
>
>     net: hsr: Reset MAC header for Tx path
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119c7fedd00000
> start commit:   3af409ca net: enetc: fix destroyed phylink dereference dur..
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8cb23303ddb9411f
> dashboard link: https://syzkaller.appspot.com/bug?extid=fdce8f2a8903f3ba0e6b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1525467ad00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114c0b12d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: net: hsr: Reset MAC header for Tx path
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

The patch references this exact warning.

#syz fix: net: hsr: Reset MAC header for Tx path
