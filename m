Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEEF2FFD52
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbhAVHYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbhAVHYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:24:40 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC66C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:23:59 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 15so5061980oix.8
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2cnartO5VSigxEhPJCDzt4hVZPHOHRMZn656f4qH9k=;
        b=g5QR4ZtUmJDjkmnh3DTuoxiYrAcmWMYo0up4e1Vv9+gyTD1rA7CO/gPK59cLO7cBmP
         V5NeWoLxVAsWM8y7enfl2uumiysE2Dcsglkds30d26UasufFkTRUsTQK4Ur3HPLlJqsN
         2IZhPV+gi35UDfmHX4ZzgdKCPnHyIPuwcU6+mOlqaCHm9zRmY0m34JVbB7O1evv6Pduk
         ZC+hp+hAES8ShaMt2OiD52gJmargt/U1oNTk3ApLBs6Vh2KquFfsAKg5PfoBOihh3IJr
         ial0jb05bA7B2C9LvmADd0iZbmwOplN5Z13hrJdeQKAChl1EupvbkUZi5A2+lcYtuoV8
         1t2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2cnartO5VSigxEhPJCDzt4hVZPHOHRMZn656f4qH9k=;
        b=NVjvlgE80t2kfYlC6kYb7k5cFgG+76c2CYVEWkf2l7PqT3uUMoWLupIWDYcLmf29Nv
         UZIbzthKsPt7BxJ+oUB8em+DxM3xqYwHhiAnYPEtQGOTjCaF8p1q5zW5FqTVZb9jMGaY
         cqWfrg7ERbvBnJ8O8InIl3bxHOVSpTXZ1Ny5Bs8lFjcHlW2rMUElXFrWwfTHaJ9GniSb
         479+ktOndODaR60Q5PjoMn85jzDeUVRCibnttKQXoMKaO6TMz9ojD+Rv8XC2lDNSk1ro
         aD4DJyTs5N5/OM4JfUiNZo+vpy0CCBJz+MggjvcSr/Thc14WJanTM+do6I/F+ywVhiyj
         lDVA==
X-Gm-Message-State: AOAM530AEb4g64tVKtnk828GXqgGYNnEUJF0EylnxRXCssEdNLX+HtSU
        5NhAcz9Ddpueh9dmDLwIyQBij2THsV0a2kWeKO3fYg==
X-Google-Smtp-Source: ABdhPJxu/9BWIQb+68tCu13kU7fTlmvXhna/Cn3pz2Yb3dAIRdE06yGxjj3qjHcd2XbwGNlMXlvx2A/E4pCLLUr/J70=
X-Received: by 2002:aca:58d6:: with SMTP id m205mr2402924oib.121.1611300238833;
 Thu, 21 Jan 2021 23:23:58 -0800 (PST)
MIME-Version: 1.0
References: <0000000000004c9e3505b96c58eb@google.com> <000000000000d0e9a705b96d4332@google.com>
In-Reply-To: <000000000000d0e9a705b96d4332@google.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 22 Jan 2021 08:23:47 +0100
Message-ID: <CANpmjNNkvG1vBMpsE9ORTrz4sVTdW3KW4CvHiaA_c7vDD5+B7A@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in decode_data
To:     syzbot <syzbot+70ba6cae2f44c82dcb76@syzkaller.appspotmail.com>
Cc:     ajk@comnets.uni-bremen.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 at 19:30, syzbot
<syzbot+70ba6cae2f44c82dcb76@syzkaller.appspotmail.com> wrote:
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    9791581c Merge tag 'for-5.11-rc4-tag' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13cd09a4d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=39701af622f054a9
> dashboard link: https://syzkaller.appspot.com/bug?extid=70ba6cae2f44c82dcb76
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133d8030d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+70ba6cae2f44c82dcb76@syzkaller.appspotmail.com
>
> ================================================================================
> UBSAN: array-index-out-of-bounds in drivers/net/hamradio/6pack.c:845:16
> index 400 is out of range for type 'unsigned char [400]'
> CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.11.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound flush_to_ldisc
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:356
>  decode_data.part.0+0x2c8/0x2e0 drivers/net/hamradio/6pack.c:845

It looks like this might be due to a race condition; syzbot had
detected a data race in this code a while back, but it seems this was
never fixed: https://lore.kernel.org/lkml/000000000000bbb17d05a19540cd@google.com/

>  decode_data drivers/net/hamradio/6pack.c:965 [inline]
>  sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
>  sixpack_receive_buf drivers/net/hamradio/6pack.c:458 [inline]
>  sixpack_receive_buf+0xd8c/0x1320 drivers/net/hamradio/6pack.c:435
>  tty_ldisc_receive_buf+0x14a/0x190 drivers/tty/tty_buffer.c:465
>  tty_port_default_receive_buf+0x6e/0xa0 drivers/tty/tty_port.c:38
>  receive_buf drivers/tty/tty_buffer.c:481 [inline]
>  flush_to_ldisc+0x20d/0x380 drivers/tty/tty_buffer.c:533
>  process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> ================================================================================

Thanks,
-- Marco
