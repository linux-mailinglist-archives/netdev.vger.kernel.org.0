Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D6A225077
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgGSHlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGSHlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:41:50 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86C4C0619D2
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 00:41:49 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z24so16985860ljn.8
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 00:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fLlSgU2du9zPWb16ppA5XVZXrlf8UIhSjUtmQ0H+tTI=;
        b=MpFNLPJ2NKBkQ340R7Y2whTmYg6tFCk6kL/oTHH26Gc/3nyzLqOcIsN7191Xj4OEBd
         GHs0Vopmx7cpC8OrBVhvu4MlDQ5aD3PB9rqGBC5KSrhQV1Vfw7xxKKYPoN+xFui3UUXX
         V+85lgRgGDmT1PTB1j4ZqlO6uHfoSI6qWTE+eNNiwHHGXhg2RyhfCchZLMLtnKDapyRF
         RIsji9mulK7h8TRVfFCPkBW+TLG55LC8LE7rjxP1UxBc7C7Zg6xcZGwspVRJBegsr+em
         ABVP4kGKI976V04i/8zQfQ9WxZhuBUHM/xr8LTHSmMPJeRysFn0d4iX7X5ANu2CGpCa1
         S3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fLlSgU2du9zPWb16ppA5XVZXrlf8UIhSjUtmQ0H+tTI=;
        b=hASQG+KXtI/IJVeX9pB2ghgjxX+SKbNE5wN4g8i1cCiW0va2VSJlMhn2i9AyUewNpr
         Xmha+DtNuKN9Le3zZ2DRm0xHXUYM6wK3mySckH8mMwdf8C+hOw+bobdQls2qsskU4hcz
         19bys6BYtkmcuogZ0avLMl60IXVLbRHwIDH8mEkUtZQlJnEXgUOAr0UU9NWjMTsvHSlL
         mHlKA2y8w0sbWqHF1dXLEQUktuHUakUpgZOs1OrCseoPZWYUjTE4pG/D89uGRx4LSRF+
         3Kfi98leCzVGqQT+1t9GbJlaoCRE9QXXBqkGuQICOekB+LItWTEioyuw1OCxLcllXfMW
         EIYQ==
X-Gm-Message-State: AOAM532RpwxqqiD+9LX55zIIv6/GOErEb1pZbSfkBBop3CsUDBNaY/Io
        u8plxQ7/7T0cpS90uvqo3O8jJLGjhje2quh+Niw=
X-Google-Smtp-Source: ABdhPJz82e279eN1Sq/gDJ7CQI+p3ZcvnAoel0UGKyK1zZr4tVnKNOMZDp4lIkCiQTTAMcFarBM4mh89M+RPdNNSk6s=
X-Received: by 2002:a2e:a407:: with SMTP id p7mr7364811ljn.440.1595144508305;
 Sun, 19 Jul 2020 00:41:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200718071306.9734-1-ap420073@gmail.com> <CAM_iQpU+ROfk4PAjB4sZawCSb0Q8QSn5kLJ9cczd=L+svx33Hw@mail.gmail.com>
In-Reply-To: <CAM_iQpU+ROfk4PAjB4sZawCSb0Q8QSn5kLJ9cczd=L+svx33Hw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 19 Jul 2020 16:41:36 +0900
Message-ID: <CAMArcTV_uNO29rkaR2kZ-ft035DJSXwmZxpBzTXumOuhhLit9A@mail.gmail.com>
Subject: Re: [PATCH net] bonding: check error value of register_netdevice() immediately
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jul 2020 at 05:06, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,
Thanks a lot for your review!

> On Sat, Jul 18, 2020 at 12:14 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > If register_netdevice() is failed, net_device should not be used
> > because variables are uninitialized or freed.
> > So, the routine should be stopped immediately.
> > But, bond_create() doesn't check return value of register_netdevice()
> > immediately. That will result in a panic because of using uninitialized
> > or freed memory.
> >
> > Test commands:
> >     modprobe netdev-notifier-error-inject
> >     echo -22 > /sys/kernel/debug/notifier-error-inject/netdev/\
> > actions/NETDEV_REGISTER/error
> >     modprobe bonding max_bonds=3
> >
> > Splat looks like:
> > [  375.028492][  T193] general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
> > [  375.033207][  T193] CPU: 2 PID: 193 Comm: kworker/2:2 Not tainted 5.8.0-rc4+ #645
> > [  375.036068][  T193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> > [  375.039673][  T193] Workqueue: events linkwatch_event
> > [  375.041557][  T193] RIP: 0010:dev_activate+0x4a/0x340
> > [  375.043381][  T193] Code: 40 a8 04 0f 85 db 00 00 00 8b 83 08 04 00 00 85 c0 0f 84 0d 01 00 00 31 d2 89 d0 48 8d 04 40 48 c1 e0 07 48 03 83 00 04 00 00 <48> 8b 48 10 f6 41 10 01 75 08 f0 80 a1 a0 01 00 00 fd 48 89 48 08
> > [  375.050267][  T193] RSP: 0018:ffff9f8facfcfdd8 EFLAGS: 00010202
> > [  375.052410][  T193] RAX: 6b6b6b6b6b6b6b6b RBX: ffff9f8fae6ea000 RCX: 0000000000000006
> > [  375.055178][  T193] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9f8fae6ea000
> > [  375.057762][  T193] RBP: ffff9f8fae6ea000 R08: 0000000000000000 R09: 0000000000000000
> > [  375.059810][  T193] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9f8facfcfe08
> > [  375.061892][  T193] R13: ffffffff883587e0 R14: 0000000000000000 R15: ffff9f8fae6ea580
> > [  375.063931][  T193] FS:  0000000000000000(0000) GS:ffff9f8fbae00000(0000) knlGS:0000000000000000
> > [  375.066239][  T193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  375.067841][  T193] CR2: 00007f2f542167a0 CR3: 000000012cee6002 CR4: 00000000003606e0
> > [  375.069657][  T193] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  375.071471][  T193] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  375.073269][  T193] Call Trace:
> > [  375.074005][  T193]  linkwatch_do_dev+0x4d/0x50
> > [  375.075052][  T193]  __linkwatch_run_queue+0x10b/0x200
> > [  375.076244][  T193]  linkwatch_event+0x21/0x30
> > [  375.077274][  T193]  process_one_work+0x252/0x600
> > [  375.078379][  T193]  ? process_one_work+0x600/0x600
> > [  375.079518][  T193]  worker_thread+0x3c/0x380
> > [  375.080534][  T193]  ? process_one_work+0x600/0x600
> > [  375.081668][  T193]  kthread+0x139/0x150
> > [  375.082567][  T193]  ? kthread_park+0x90/0x90
> > [  375.083567][  T193]  ret_from_fork+0x22/0x30
> >
> > Fixes: 9e2e61fbf8ad ("bonding: fix potential deadlock in bond_uninit()")
>
> I doubt this is the first offending commit. At that time, the only
> thing after register_netdevice() was rtnl_unlock(). I think it is
> commit e826eafa65c6f1f7c8db5a237556cebac57ebcc5 which
> introduced the bug, as it is the first commit puts something between
> register_netdevice() and rtnl_unlock().
>

I checked for it.
You're right.
The bug was actually introduced by commit e826eafa65c6.
So, I will send a v2 patch to change a fixes tag.

Thanks a lot!
Taehee Yoo

> But this patch itself is obviously correct.
>
> Thanks.
