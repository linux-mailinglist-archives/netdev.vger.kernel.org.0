Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598E125089C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 20:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHXS6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 14:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgHXS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 14:58:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3BEC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 11:58:11 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id si26so13269062ejb.12
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 11:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kr/ilKP3KtnpaNLBR4Wfqo2ibtevdlA/61dd3WxVQbQ=;
        b=bqOH7tKogCiyKYB3sMzalRYYv42T8tBwVa1C577l6dLDiQqHISTeBcw3/rVMjcQVRr
         +oeKkG0mXbC9eLC33+u8/ltcR8dvp2UukEC9uSYpxY/C3Gkwd5Y8jfWXavf3P3sBT+Er
         X0gXWdng+UeTkQ4qPQxDaSxZZL7g5raQtCJsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kr/ilKP3KtnpaNLBR4Wfqo2ibtevdlA/61dd3WxVQbQ=;
        b=X1e/peFtwowtD6t5e9FJiOnNaUUuZkh8rx0XmoxtPdmzYk9RSpBPniHdx/lyRcgETE
         zcRyFrziPQx3fNPDRoZZDvkoL2s2Xbe/OdrvF0aWwqds3U6hkEhD4zyw40g/yF+tcKyO
         AWwpG6O2qf6jGR+njlSKb3530tbEUTXUKJRYCoiEQhJmktGDV9/ysk+EEHv7LRqrXu/o
         IRP2FsBwmvMjfkarF3q5F7/Pimqq9OP/0KZa+oWRgoReqIIQ7TSAe84QsQSWZGzKum2s
         xNpWXl6SZKBN4p7UxmHvbbBpwnGLKBh+sYDX59pDrQ4zqoRjkoZn0RaqBxdwVE6/Cwwx
         DEYg==
X-Gm-Message-State: AOAM532LTN7QvOwKGLJTH4vOmqBzib6K+3LVjY+o+zeIuvLJOkgOnT7R
        eV+p4aMsfZ3VyXd9dMEu5ANM3guWWglYUA==
X-Google-Smtp-Source: ABdhPJxUVHhSkIvogXMTXgS5wicexFdMRzbDtz03BjzWRr0thRB2gnvfTXoj+9E8fmgN4PsXiF8wGQ==
X-Received: by 2002:a17:906:5812:: with SMTP id m18mr6957022ejq.66.1598295489038;
        Mon, 24 Aug 2020 11:58:09 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id p3sm10370898edx.75.2020.08.24.11.58.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:58:08 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id di22so9028145edb.12
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 11:58:08 -0700 (PDT)
X-Received: by 2002:a05:651c:d5:: with SMTP id 21mr2906073ljr.276.1598295186265;
 Mon, 24 Aug 2020 11:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR18MB2637D7C742BC235FE38367F0A09C0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20200821082720.7716-1-penguin-kernel@I-love.SAKURA.ne.jp>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 24 Aug 2020 11:52:53 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOHDU+SWmr+7aOUtbuzC22T-UWhZXJ5UXtcsev5ZTbqMw@mail.gmail.com>
Message-ID: <CA+ASDXOHDU+SWmr+7aOUtbuzC22T-UWhZXJ5UXtcsev5ZTbqMw@mail.gmail.com>
Subject: Re: [PATCH v2] mwifiex: don't call del_timer_sync() on uninitialized timer
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        amit karwar <amitkarwar@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>,
        syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 1:28 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> syzbot is reporting that del_timer_sync() is called from
> mwifiex_usb_cleanup_tx_aggr() from mwifiex_unregister_dev() without
> checking timer_setup() from mwifiex_usb_tx_init() was called [1].
>
> Ganapathi Bhat proposed a possibly cleaner fix, but it seems that
> that fix was forgotten [2].
>
> "grep -FrB1 'del_timer' drivers/ | grep -FA1 '.function)'" says that
> currently there are 28 locations which call del_timer[_sync]() only if
> that timer's function field was initialized (because timer_setup() sets
> that timer's function field). Therefore, let's use same approach here.
>
> [1] https://syzkaller.appspot.com/bug?id=26525f643f454dd7be0078423e3cdb0d57744959
> [2] https://lkml.kernel.org/r/CA+ASDXMHt2gq9Hy+iP_BYkWXsSreWdp3_bAfMkNcuqJ3K+-jbQ@mail.gmail.com
>
> Reported-by: syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

This seems good to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/marvell/mwifiex/usb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index 6f3cfde4654c..426e39d4ccf0 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -1353,7 +1353,8 @@ static void mwifiex_usb_cleanup_tx_aggr(struct mwifiex_adapter *adapter)
>                                 skb_dequeue(&port->tx_aggr.aggr_list)))
>                                 mwifiex_write_data_complete(adapter, skb_tmp,
>                                                             0, -1);
> -               del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
> +               if (port->tx_aggr.timer_cnxt.hold_timer.function)
> +                       del_timer_sync(&port->tx_aggr.timer_cnxt.hold_timer);
>                 port->tx_aggr.timer_cnxt.is_hold_timer_set = false;
>                 port->tx_aggr.timer_cnxt.hold_tmo_msecs = 0;
>         }
> --
> 2.18.4
>
