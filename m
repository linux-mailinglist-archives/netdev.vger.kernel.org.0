Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32131D560D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgEOQaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgEOQaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:30:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7447AC061A0C;
        Fri, 15 May 2020 09:30:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id x20so2688749ejb.11;
        Fri, 15 May 2020 09:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hbfeRIKdWre9WvsAQKF446bIFocBJT9zt7xvIEJNE8U=;
        b=Aw48zZmWUp8zyE2RVrFrRfE6jdinw/kwE65P1fNNbNUot+CswwkN0SxtZv46YVC49O
         TYfMIfDAWeYur9yj/1Qji+smQ9EV71thycX/Rs3KSQkRzueejFvzXfd0S1BOZnggvE8j
         kwAdSqJUJnQl8Pv+bGr4ZbhMLZ68ylyAFrCTJKggunxY8wwZDI2XYs4TlnSinXAqWcsc
         5ObekLJNZ3poxKkPruq2VXAAk6tps1mkGwWg0Id5GpRgJ1zchGxTq2krRkXgcw+7QRXQ
         yWJMmXmiCAQ7RY8a0p8pqtVieHOBKfSTZYAXMhn+nNN43W5FXnu9sghD43XGgy+COl4I
         Hu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hbfeRIKdWre9WvsAQKF446bIFocBJT9zt7xvIEJNE8U=;
        b=CriWyVjBftDdTu6sRjqqbzO+0NesgyjpH/20fYXP1h2g3hH6muAVIzpGxAIDkj+sr6
         uc26ObF+eCgDVnoLC8h0D7kmO4juxM/O4SyeN61kmmehtVXl8uhDOoPHM0axtcMnQNPM
         wTr530Li0YpOSxO0b4PHhThMOUrabmufZ29WltP4WHp0AdrgBID9ToanFpdgFnkwupC6
         Qpyk1qmIbrSBgkdCqr+6x/2IbA1X0o68BYiN0yP/VFQAxAVK0/TQ7l1pEPvaImbFqyjN
         y8UuZzOOL68bF4I/gREF2vWb48CJ6P7epTozJS0tvLXpNPiFF5u1kjIz4XcfAo4PYI2J
         NC6w==
X-Gm-Message-State: AOAM531xJYpxxoQ13JQGhRHlTUfvdL3NoxNGYIXtpUANzy+ju7D3FM0L
        pYWLaOcQw+TgujDBfUFMiKRTWRScw6ZYPbgFjTs=
X-Google-Smtp-Source: ABdhPJw/hoHIGtZ88S8c8KUEHlOImAzFp7L0wnH7gS4sCyYz4HLzzXQD78TY6vWYmDSpC9K6SumOL39cKjrsSZejF+w=
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr3731728ejb.6.1589560215122;
 Fri, 15 May 2020 09:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200515031813.30283-1-xulin.sun@windriver.com>
In-Reply-To: <20200515031813.30283-1-xulin.sun@windriver.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 15 May 2020 19:30:04 +0300
Message-ID: <CA+h21hqOOdaogK2SqWioLz9+=9LPqPsZ1xgvrwDA0G_kotN8ew@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: replace readx_poll_timeout with readx_poll_timeout_atomic
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, xulinsun@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xulin,

On Fri, 15 May 2020 at 06:23, Xulin Sun <xulin.sun@windriver.com> wrote:
>
> This fixes call trace like below to use atomic safe API:
>
> BUG: sleeping function called from invalid context at drivers/net/ethernet/mscc/ocelot.c:59
> in_atomic(): 1, irqs_disabled(): 0, pid: 3778, name: ifconfig
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffff2b163c83b78c>] dev_set_rx_mode+0x24/0x40
> Hardware name: LS1028A RDB Board (DT)
> Call trace:
> dump_backtrace+0x0/0x140
> show_stack+0x24/0x30
> dump_stack+0xc4/0x10c
> ___might_sleep+0x194/0x230
> __might_sleep+0x58/0x90
> ocelot_mact_forget+0x74/0xf8
> ocelot_mc_unsync+0x2c/0x38
> __hw_addr_sync_dev+0x6c/0x130
> ocelot_set_rx_mode+0x8c/0xa0
> __dev_set_rx_mode+0x58/0xa0
> dev_set_rx_mode+0x2c/0x40
> __dev_open+0x120/0x190
> __dev_change_flags+0x168/0x1c0
> dev_change_flags+0x3c/0x78
> devinet_ioctl+0x6c4/0x7c8
> inet_ioctl+0x2b8/0x2f8
> sock_do_ioctl+0x54/0x260
> sock_ioctl+0x21c/0x4d0
> do_vfs_ioctl+0x6d4/0x968
> ksys_ioctl+0x84/0xb8
> __arm64_sys_ioctl+0x28/0x38
> el0_svc_common.constprop.0+0x78/0x190
> el0_svc_handler+0x70/0x90
> el0_svc+0x8/0xc
>
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
> ---

The code path which you presented in your stack trace is impossible
using code available currently in mainline.

>  drivers/net/ethernet/mscc/ocelot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index b4731df186f4..6c82ab1b3fa6 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -56,7 +56,7 @@ static inline int ocelot_mact_wait_for_completion(struct ocelot *ocelot)
>  {
>         u32 val;
>
> -       return readx_poll_timeout(ocelot_mact_read_macaccess,
> +       return readx_poll_timeout_atomic(ocelot_mact_read_macaccess,
>                 ocelot, val,
>                 (val & ANA_TABLES_MACACCESS_MAC_TABLE_CMD_M) ==
>                 MACACCESS_CMD_IDLE,
> --
> 2.17.1
>

Regards,
-Vladimir
