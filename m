Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238342AF219
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgKKN0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgKKN0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:26:52 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9754FC0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:26:52 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id 199so1556421qkg.9
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NHIkjhd5hEAN/PFoCYfMQ2iwZKBSPt0aiwevXUMhafo=;
        b=hCnxeq4RuMjbnaxs58cXtHsdAKn9gPRITgfWcNPiN4pyNlZFRWOtv6ziGX0gSVTtPU
         o6cv4KCceO5UnPBuHZYLIQMwvnswLTn9XvYMkK3l0v/50mFdi6YcZ9Y/ZFT6yA/7RKSK
         A8OhUrcjrKV/jVzqXIK5C/0rdRkFrkcr1z1gVZ0N6T/WDEp7Zfbzq7JSr6q4TAav41KG
         bZ5sLrt6GhB8rwXNbRO4+clb4BjTXIgoZCmVlR7MX4sF7fiUdpYyMrnDV3c6T9QZ/Ht1
         e5aIX6X/gPgrvp0Y8iKblpQ2Ve8Kxtyx158S+UY67lWwEVP36SZIRDCDZoUkD+nmeUPH
         SS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NHIkjhd5hEAN/PFoCYfMQ2iwZKBSPt0aiwevXUMhafo=;
        b=BPaf9CtTwg8llSEYv5CDv0SCHCxbPbYr2+1mkzjrV84N3B52GBhleGlUx+bMDCBm4Z
         e7eXV/xJKZunth0M8i/5BU5DXONgzkkVCXwfc+dpSz+0CbgXvIHp3Z9eOj1J8XKxu9H3
         bN9lNlXzWdzTzVRRQoHhtA+ugQubvKjfUh5jFrPlDvpck8u1gzI/F8RVUH6Hj3TJlWFs
         o5uaoqSNrfZ398X2RsIIEAT683WTztMOT2qUcL7GROSKVJgrO8BM3F6C4BuKeUAUC2M7
         Qk6WV5gIOiTnCzXbxjYxesCIsEh38eWLGkE0VaCGGvVbw9rPBD8kO26j7M8Xd2OJ1Tgv
         xCbQ==
X-Gm-Message-State: AOAM533soY9sl9PgRwfuqJN1x5RsQFzbwkZ8Rd2/PDHLouwF1hib1SHO
        LCc6hWrmDnKDbfFaYjwIH8I639Q/9LD4RJaJmy1XqA==
X-Google-Smtp-Source: ABdhPJyoeut2NJQrJGqqBr/mOd8RvxNenUNqRJlhaByIFumXC5KznKgMyawu+bDLqyP9cqH+6IEg/SLRCycXpfJmqoU=
X-Received: by 2002:a05:620a:15ce:: with SMTP id o14mr25818286qkm.231.1605101211622;
 Wed, 11 Nov 2020 05:26:51 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000cce30059f4e27e9@google.com> <0000000000005fc62d05ae9ab8c2@google.com>
In-Reply-To: <0000000000005fc62d05ae9ab8c2@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:26:40 +0100
Message-ID: <CACT4Y+YF9==+4mgHfjkNYdD+J0u2VSZeipgZTXc4y07fur_6pA@mail.gmail.com>
Subject: Re: WARNING: refcount bug in l2cap_chan_put
To:     syzbot <syzbot+198362c76088d1515529@syzkaller.appspotmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 3:07 AM syzbot
<syzbot+198362c76088d1515529@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit b83764f9220a4a14525657466f299850bbc98de9
> Author: Miao-chen Chou <mcchou@chromium.org>
> Date:   Tue Jun 30 03:15:00 2020 +0000
>
>     Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11aaff5d900000
> start commit:   fffe3ae0 Merge tag 'for-linus-hmm' of git://git.kernel.org..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=18bb86f2e4ebfda2
> dashboard link: https://syzkaller.appspot.com/bug?extid=198362c76088d1515529
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152a482c900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109b781a900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
