Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA7E1F7859
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgFLNDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgFLNDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:03:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F3C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:03:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so4276631pfg.2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 06:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tmE0l2CccWJ1gmfer+TT0hZtE0DUzxX2WZi+1iF9+aI=;
        b=jGGIlHc60EoI4xt94hi5otd/6kF7Xf5bb5HwUoG1QCyuRIJXbMugM9wSNIzJXRC0oK
         ptj+9Rvi6caiERbdiVTmSFQFGZCeCGOIWUBvZhSb0/3oPs0kSiLPKMOYPIklCZs8UFMw
         wIRFnabiLOxIVVZ4X9s8QMZU98YcgZAdue8ffJjwcbFeWFi33nsIYa4Lbqg0wWM6P6f2
         FDj+Ff9p9ucwnIX2NHU7dPAD0LT/Z/O1VyrZIu6183/Y7GKFjnsq5euKCduqYjMYePzE
         quKqz3jLgxvnvz4EVUhhnnWOn87fgPaizOvjekxbJqMlp3J2BuXrmTJD9sKDcG0/lUvb
         sP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tmE0l2CccWJ1gmfer+TT0hZtE0DUzxX2WZi+1iF9+aI=;
        b=KunIcjcUcauy7NBI06+4BY/b8v9UrNbWdy9H4+nLShhuP1TvMrgxelvp2he0D0IUSf
         nb7K/wSlJTwqj0zL1yWz1V3lxatUa5qFObDi92ByjdNMAxIy/9aGM+YE2Zhnqv39M9Ww
         bxGzud3Ojs4soCC2UndjxxyFh9RMcGu+3Hk5o3e9QyHTtBj6ArnFmp+6ir0CleiS9JSG
         n84AxlkbrxBghGv3C9gzpLdJ6WJc2QbWIxgo0avAEXbWYeL3Dq10n0lFs8X9fL1ZMJ8X
         ZlmsixZb94eMWCmbDRT2NS7mz5Ak90NEYKCOdswSzQbjIek/qeH+au0Cqgj3BVUGntwT
         5otw==
X-Gm-Message-State: AOAM530uyRkP+JttCzmF72DPefqH+gpIE2PekyZ0R5K19sX1cc8TjDeI
        QCB4+IL1gZWrYP29lme7PsG2SP2VDaVBucbDrU1vSw==
X-Google-Smtp-Source: ABdhPJyOMjrl2nTTPMW68N+jKyo424DDpNd9djS/GWGINRFJL+dzzaOKWFbAGb1YzkLnhDrqAcX98HRSws9f1yVfb9A=
X-Received: by 2002:a62:1681:: with SMTP id 123mr11054302pfw.306.1591967026975;
 Fri, 12 Jun 2020 06:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005d13df05a1c05dfb@google.com>
In-Reply-To: <0000000000005d13df05a1c05dfb@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Fri, 12 Jun 2020 15:03:36 +0200
Message-ID: <CAAeHK+xhdbU0vLmb=Qr0=RL1fz3sYXi4GrZ6dh-uBoNgu45xqQ@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in ath9k_htc_rx_msg
To:     syzbot <syzbot+694d40a36a6452d77f36@syzkaller.appspotmail.com>
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

On Thu, Mar 26, 2020 at 12:34 PM syzbot
<syzbot+694d40a36a6452d77f36@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=1409ca5be00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
> dashboard link: https://syzkaller.appspot.com/bug?extid=694d40a36a6452d77f36
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122d48f3e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122511e5e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+694d40a36a6452d77f36@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
> BUG: KASAN: slab-out-of-bounds in ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
> Write of size 2 at addr ffff8881ced8a7f0 by task swapper/0/0
>
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0xef/0x16e lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
>  __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
>  ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
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
