Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B24468393
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384468AbhLDJfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384460AbhLDJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:35:36 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81FCC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 01:32:11 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id r26so10883310oiw.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dp2mOcmnCUzYV/E9OQFo/xxl9rHZk/eGzBOBjZN1XYM=;
        b=WSTQ5SrqnlJYb5MwWXeSFWwAIj+R4+Bn1eUxHR+003PnwHgtvHR/tKMkX4wh48f4ud
         nlReAt7US/Ey/8pQ203BdU5uK7s5ZiQd6d6Fieh1nqfKJChGXOU4GE7yrmDfpHX9n0W0
         7SpCq7c28PvftiP9zRbNIpzjnQoe2Z4IDYL10DdcNFGAarkTJWcEBVw3HzTneEfkXGFz
         kEga0ebNY2oOFHlh4KbYekS7mA8PiehapP3sOnumOMu6QIWZJtzZVYY4y04W1Ti7Xxr7
         tRfo/2ISAGL5qK3E8WskkTo6NNmQrKkh5XM/80FMs9ji48HtM8UkEmnZi883zYj15RVH
         F6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dp2mOcmnCUzYV/E9OQFo/xxl9rHZk/eGzBOBjZN1XYM=;
        b=A8MLHAlInIfkeJOp2nuwNaGrYJ0g8piBWqcjGzTRifO1VJeLxHkQZVPdNLhbPffv3l
         GL0TFZSIIamuqwg1Xe81/Mnik7qLqwxfA1dlbJqa62LV3i7W9EhVOxQGkK02IBoCUVLD
         o2ngehvrYXIQWNlVMtX/z3B5GIIHUG2qsLmud2WkXqXkfBYgqcFW0nzxONLRpawYfTR6
         NFUUsBZd3bVXoDV7LvYVILVsdpUcha6/uCyVxf922PTHvPBzGJ0Xa/kiz07LV/yLo8dW
         1MWkVkqF39Q43KHTbFb2U2Rz5DWle72mai2AexW4GyNMMQaTUAybWkNJvAmJ4me5shja
         bizQ==
X-Gm-Message-State: AOAM533QgwbH20xA/s0WtZiDdUYs7mT4zgY6PMfjpP/Fq+HLvfXu7lbx
        4j09R3bxvKoNvN7zzyRj7Sb8tdKf8YOiw7phz+wgNA==
X-Google-Smtp-Source: ABdhPJwHT61kOEJ6OKmVIbikhcKXSAgYjacMdWWfxmWruZekkbmJkcsbN+UN0YGjvX52pd7TgLy63T2wrCG4P4k6CM0=
X-Received: by 2002:a05:6808:120b:: with SMTP id a11mr14692196oil.128.1638610330910;
 Sat, 04 Dec 2021 01:32:10 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f5964705b7d47d8c@google.com> <000000000000dc091705d203eac6@google.com>
In-Reply-To: <000000000000dc091705d203eac6@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 4 Dec 2021 10:32:00 +0100
Message-ID: <CACT4Y+bN9OX1t4v80n5OPN68fySSVWxx0FKOsTHRTff9Xuokng@mail.gmail.com>
Subject: Re: [syzbot] INFO: trying to register non-static key in l2cap_sock_teardown_cb
To:     syzbot <syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        bobo.shaobowang@huawei.com, davem@davemloft.net, hdanton@sina.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        mareklindner@neomailbox.ch, miklos@szeredi.hu, mszeredi@redhat.com,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 at 17:19, syzbot
<syzbot+a41dfef1d2e04910eb2e@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 1bff51ea59a9afb67d2dd78518ab0582a54a472c
> Author: Wang ShaoBo <bobo.shaobowang@huawei.com>
> Date:   Wed Sep 1 00:35:37 2021 +0000
>
>     Bluetooth: fix use-after-free error in lock_sock_nested()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=134c881eb00000
> start commit:   73b7a6047971 net: dsa: bcm_sf2: support BCM4908's integrat..
> git tree:       net-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9ce34124da4c882b
> dashboard link: https://syzkaller.appspot.com/bug?extid=a41dfef1d2e04910eb2e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166ee4cf500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1337172f500000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: fix use-after-free error in lock_sock_nested()
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

A use-after-free can lead to other random consequences, and there
actually was a KASAN report after the lockdep report in the original
report. So w/o a better candidate let's do:

#syz fix: Bluetooth: fix use-after-free error in lock_sock_nested()
