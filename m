Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72C22AF20C
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgKKNZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKNZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:25:33 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9415EC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:25:33 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id g19so856910qvy.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=FKEbwQJZmRNwkVX9YGHSP4rPuoQ5U5pdFiZu5vgyAhY=;
        b=CQH4xLgZGd0Q7mJrHl0G80Gmrc9hbeqgs3ko6+jmS+J9PoGhQQI8GhDWCxAgSyGA/w
         SGWlIIMm36QTsXHAogUG1dLNFo2XRPM+rWQwRNftYrkKBv5+FkXNohlKKGMlsMiAW0nS
         +s4/I7wDAmRoNcjPoSJNcDISgIFWk2BWcuybL/3ZqkZqXkU7OMFLx4NFsI/S+yT7M8zD
         wd5uYdcnf5LYP+YJuSGy/W9Kzh15MOLBlx0pIl6SK9vII39hN/0UbWodXs7WHHm8KAnu
         Q3aLfidvktdVKOorTYCsHG2Cc/JmqEejmjK8/NNJNSklpgQIx06FZNJSZRmeoOyk4o3+
         F2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=FKEbwQJZmRNwkVX9YGHSP4rPuoQ5U5pdFiZu5vgyAhY=;
        b=TMJ73KQlBv85geopmYS4w/kB4FbTeRTKLU0q1OJ21S0oQ1rZyw3JOGEQKtBk37dDzf
         96OmrwIg1xD29rnwwhGidAwW8gHxjCGIEfn750Gkhnfsc95EnnVDYrnvsfUpBd929dgj
         a+WCI9QhMx4pwRQNUBdxYx9+xyOITncu902nkMjnM00W/NU90RaBHhBZ1BEmHHLCAvgo
         VaokNnrYGaYl2yRR8N3OizszO8fiE1aF+GYMsTZhb/2yoOdIUccurF7aen9qp1UQ/+v+
         i5a3m+J7EyAcjnvMLjN3VH0d/xghxDOsBkEgeQEDC6cGmoy9HTMIeVWdjIeV5Yk3WS1A
         HO5g==
X-Gm-Message-State: AOAM531Qe1NaddQ7UGK2lB1799N9bUgb1oJqsjAL00Wr3RLG5cl2sYG6
        FBskyOIubvGpJFnN9o7+DOFoHpGKha8D+ucNGGNfqg==
X-Google-Smtp-Source: ABdhPJw+zL/j1fjqkk71AlpEkNH7Cl9BQVxUcYF2rFrvs/jsNTblKTZCB1e79W5MS3x3QzUVy27ok1kNJU6caWzrry4=
X-Received: by 2002:ad4:46cb:: with SMTP id g11mr24903255qvw.37.1605101132594;
 Wed, 11 Nov 2020 05:25:32 -0800 (PST)
MIME-Version: 1.0
References: <00000000000055e1a9059f9e169f@google.com> <000000000000c8101605ae7de686@google.com>
In-Reply-To: <000000000000c8101605ae7de686@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:25:21 +0100
Message-ID: <CACT4Y+ak0Enm0CZ5rmUwyWRDkityJx9yzp1yyVDx2shpC5tL_A@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in refcount_warn_saturate
To:     syzbot <syzbot+7dd7f2f77a7a01d1dc14@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 4:44 PM syzbot
<syzbot+7dd7f2f77a7a01d1dc14@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit b83764f9220a4a14525657466f299850bbc98de9
> Author: Miao-chen Chou <mcchou@chromium.org>
> Date:   Tue Jun 30 03:15:00 2020 +0000
>
>     Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10f92e3e900000
> start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cf567e8c7428377e
> dashboard link: https://syzkaller.appspot.com/bug?extid=7dd7f2f77a7a01d1dc14
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b606dc900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123e87cc900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: Bluetooth: Fix kernel oops triggered by hci_adv_monitors_clear()
