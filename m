Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FE01F7850
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgFLNDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgFLNDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:03:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C4C08C5C3
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:03:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d66so4271211pfd.6
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PytiBtg5DiE4gf2+6m75JiLQ89Uld1p0/vuwXEKhqsc=;
        b=WpQLKCEOTt5jEZ6pxxZnc4Oucoloca659YlByuWVV8ZRz4icKvlgMLqx2FCYwlhaEf
         9XI6+xjr1MUHS0Hmz+X2p3HpsEhPXKQThsekeV1DipYKbPAe6H9Hak8qOXOvOLPWse92
         fl5X5ocCnaip/Mf6jeYvBzHQKFEg4+7GXD2eQghdmwSzhwURZ+qC/iyTBF6R406e200e
         I7SrZRTb4AGrMMXWL1pW0WZhPfgltkckUUuVG4VhH6Dz2XFrIQc5aUw/GQave+cb9/NA
         Z1Y7iL1hv1FCtH8JzNRULgH9nUdFHMuRf2UMx6zF4P4LM/YwIbQamRGoZ8Vr4zxAQfKj
         gtFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PytiBtg5DiE4gf2+6m75JiLQ89Uld1p0/vuwXEKhqsc=;
        b=LTAsRb/BTQu5JJBp9DBkAlXA4Zlc1z9EbsvrWCrFkgGPzKXoGusgXOnY98geC6LXP0
         XbKPd46srv+mVfFQrt3xhZBpHDjVP8RPssuBa1cADdcfOWcbnwx7sk9YVYYEqEkRl+dw
         dGsC6arbpJ2Fo7EEfO4MsPpDqX2fi5nNwiX+JR8SkuoUwnIqp3DouRIJsd+0M/a4Z0si
         SAMECGWZaztx7ZfKIEY+DCOffoXeAZBxp05QquI1p5SKFHhk7daVPUPWWCxmt+bZy9eg
         445ub8XQNFcENJ6LEeApj8pF2o0LIHmtG0r8zeYz07cJpBqqX4VFqVyqqPwXz2Sj0RXA
         fULQ==
X-Gm-Message-State: AOAM532deA201Om6gu5m0+xmbR/9fST+K1qMp8tWQF7BwICLO7r9zJro
        dAr8GVpRIm1m2CucVphrTV9FemRokat+R4JM7hygUg==
X-Google-Smtp-Source: ABdhPJzb09SSzvhrboajMNPzCMmBq38q31idi5TNI6fOUwqoPa+HeKbjw14g3M1flPR5MFX5lhx73PbjMOoz7ZGl5Ks=
X-Received: by 2002:a62:1681:: with SMTP id 123mr11051908pfw.306.1591966996127;
 Fri, 12 Jun 2020 06:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000055c12d05a1c3701e@google.com>
In-Reply-To: <00000000000055c12d05a1c3701e@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 12 Jun 2020 15:03:05 +0200
Message-ID: <CAAeHK+xrjfrmzNzbVFiQJmO6gvE2nX3UGvFK1bcob1oQxgDAAA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in ath9k_htc_rx_msg
To:     syzbot <syzbot+666280b21749af5d36db@syzkaller.appspotmail.com>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 4:14 PM syzbot
<syzbot+666280b21749af5d36db@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=113938c5e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
> dashboard link: https://syzkaller.appspot.com/bug?extid=666280b21749af5d36db
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fdc1e5e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1507178de00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+666280b21749af5d36db@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in __wake_up_common+0x634/0x650 kernel/sched/wait.c:86
> Read of size 8 at addr ffff8881cec10000 by task swapper/1/0
>
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  __wake_up_common+0x634/0x650 kernel/sched/wait.c:86
>  complete+0x51/0x70 kernel/sched/completion.c:36
>  htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:138 [inline]
>  ath9k_htc_rx_msg+0x7c2/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
>  ath9k_hif_usb_reg_in_cb+0x1ba/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:718
>  __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>  dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz dup: KASAN: use-after-free Write in ath9k_htc_rx_msg
