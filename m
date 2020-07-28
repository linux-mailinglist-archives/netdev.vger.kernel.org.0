Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BDE2310E4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbgG1R3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731779AbgG1R3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:29:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5340EC061794;
        Tue, 28 Jul 2020 10:29:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k4so10229088pld.12;
        Tue, 28 Jul 2020 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvC33c6lX0M+cpFedrNCLZ1U+Zo7I7ibJkFG+4mqa48=;
        b=SyxYachVFhddv9xgQSCtTM81YnnLRQvfAdfCIXYBJGywlbTOAe56WaqrxZkelpcZIT
         aNeRE6VXBeiAy5H78OHAkA7DnlhlX+t7hT21JkI323wKse2v24CpNdfbMabKqMQe2YO6
         oM68s0417RsaCNEoYuZWj7/pHwFh8Db0UmapN9NGhzshWV7AlQiMeZZfAlBgD932u81/
         wS7yRsYxLcYm95RzQZCavC3QsXMWUeshoGCdpnDY1a18OkaX7v2PYlK8QoXrH9pb3HqH
         llvex8HxTkmdy00dKr5uJpUZ8/Vnck432yidHnv7ckh+aYCixUkwarEkmeAdaFEN7KBi
         DGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvC33c6lX0M+cpFedrNCLZ1U+Zo7I7ibJkFG+4mqa48=;
        b=lBAucCNCrpqdBYwqGfrSZwOgMxXCHbGs6U17frRdS49aA4foRxhn6me0df56QSj/Ze
         ZcoZetnyr8cjyhGaajTyPQfmoD3sNlwfWPz0q8HFVZc4t6KX0EwOgM9CUu6wLtxq/k36
         TxS0aB32/wgmtBKNwmv0gHAGM9udh+NKMNp6PbB9ailSw/GrJ4F8Lf0CkktEjiGCGk9q
         v2bLVMlvYnmI8+0zgtKsawRwjUK2p9QK5dagUNumypUAFazncK6e/abD/2AYR6poFRKe
         38bWQAs1d/fJR3T4v1Exb6wlc9mRqpPx4KWiQ6Wn7KAQf5vfR2KJIqejSPz+JzEDY8Rv
         l+Cw==
X-Gm-Message-State: AOAM5327vqbLtFUsEgQtTJv/F/0vYv3QTyZc4ucoCE4rcwA6l/pwIh/a
        UR4Nk4gUqdxtlmbZn0J/h7PZkCOQOldPehfdNWc=
X-Google-Smtp-Source: ABdhPJyo6Up0HxgUu0YXezBBId8olJiV2HxsKPkSX/2vuB9eJTZdnOqNu8a+sLck2iCAvE4kWHW/kPzUymSyxIghXfM=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr5714267pjp.228.1595957360726;
 Tue, 28 Jul 2020 10:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <1595900652-3842-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <1595900652-3842-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jul 2020 20:29:05 +0300
Message-ID: <CAHp75Vdta2xGDH=0CwRf8yK30JQimSGj70-pXz7QUFSgjxoatQ@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: don't call del_timer_sync() on uninitialized timer
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     gbhat@marvell.com, amitkarwar@gmail.com, andreyknvl@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>, huxinming820@gmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        syzbot+dc4127f950da51639216@syzkaller.appspotmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 4:46 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is reporting that del_timer_sync() is called from
> mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
> checking timer_setup() from mwifiex_usb_tx_init() was called [1].
> Since mwifiex_usb_prepare_tx_aggr_skb() is calling del_timer() if
> is_hold_timer_set == true, use the same condition for del_timer_sync().
>
> [1] https://syzkaller.appspot.com/bug?id=fdeef9cf7348be8b8ab5b847f2ed993aba8ea7b6
>

Can you use BugLink: tag for above?

> Reported-by: syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
> Cc: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> A patch from Ganapathi Bhat ( https://patchwork.kernel.org/patch/10990275/ ) is stalling
> at https://lore.kernel.org/linux-usb/MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com/ .
> syzbot by now got this report for 10000 times. Do we want to go with this simple patch?
>
>  drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index 6f3cfde..04a1461 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -1353,7 +1353,8 @@ static void mwifiex_usb_cleanup_tx_aggr(struct mwifiex_adapter *adapter)
>                                 skb_dequeue(&port->tx_aggr.aggr_list)))
>                                 mwifiex_write_data_complete(adapter, skb_tmp,
>                                                             0, -1);
> -               del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
> +               if (port->tx_aggr.timer_cnxt.is_hold_timer_set)
> +                       del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
>                 port->tx_aggr.timer_cnxt.is_hold_timer_set = false;
>                 port->tx_aggr.timer_cnxt.hold_tmo_msecs = 0;
>         }
> --
> 1.8.3.1
>


-- 
With Best Regards,
Andy Shevchenko
