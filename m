Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B762A420
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiKOV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiKOV3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:29:45 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4326150;
        Tue, 15 Nov 2022 13:29:42 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id d6so26484667lfs.10;
        Tue, 15 Nov 2022 13:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gkXebYtR/SDA/6KCm0r07yRiyQWYsGdlZHzkghBpwSU=;
        b=cqaNxotrQ7QjQ/xbJJnBn5nzvcugQfh8ZiGnhqFUpvMrijeY5PJ4ZUeY6ekU9DuORE
         ucjLwPCBd31v/9agH7p72veVy6NmvCycWqhXye5xGbcMPFAabmfc7aZAmoTylI6wv0GB
         O0hTH8KRgkNXK5RhvPsL7DW8dT2JZ5CkLRhG4a4T+3ShMWGD/SiJxgi14xaettmNLNvm
         6J2wDCsvY6pB6TfowhQRv+/6kI4pC4RB8hiNjRMnE27Kyw4Wxyn/o5ByKIkpHFPWtlwh
         OD/biZismMBmV3MpICnee2bTZJ4XyApnqPEdI3VeS+NgjL+BDhQElDwfAxG+9yrUjbEf
         uBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkXebYtR/SDA/6KCm0r07yRiyQWYsGdlZHzkghBpwSU=;
        b=LV6MOXM+YcSkwsXr1SwcrsGsPPHjvYZKw8cVQl51T33dLzToG60SDLUpDaws5lMdSD
         ev6RtXzCeWM7Mli1EPy2IhvIik5yG5Q0PR3f1U5XbvFDBGgl1ojRXq1BzeAj7YQ28/5k
         sBrm+TsDzPyGHcP1vA1175dZ5DjMt76Mu+TbPE43uxUuIhYyXmFXUJ2luQxvJwQN0bEb
         y9uARxCrVLe/n1P3u1U2nJDY9IN/KAjHjjeQD9XVPVXsRSiOBB88FzcFWTAvZ99v5QQ3
         XyDJsL5fLQqbe1/czgkLjeBn34ot2/MTM1l1fJe6mlhNDQbkjuhOyCHoAaHjhzw/X2CZ
         Blgg==
X-Gm-Message-State: ANoB5pkTmyYipeq7oL53YoFsHgakvziT75QretiENMpxyrq8iYJWattz
        stAxCkXNpNKml+AZ6hSn2m3TGQ4C7yHpauDC7AyMH8tIn9db+Q==
X-Google-Smtp-Source: AA0mqf62Liai2zVYR3sDpnzPf95puLU7258NR+JAQug3aXxae5p2vNJwG/Dmryw/Wnac++x56ZYUmiK/2DXkQjoIXu4=
X-Received: by 2002:a19:dc15:0:b0:4b1:18a2:2fbd with SMTP id
 t21-20020a19dc15000000b004b118a22fbdmr6034442lfg.564.1668547780309; Tue, 15
 Nov 2022 13:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20221115195802.415956561@linutronix.de> <20221115202117.849485477@linutronix.de>
In-Reply-To: <20221115202117.849485477@linutronix.de>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 15 Nov 2022 13:29:28 -0800
Message-ID: <CABBYNZ+ebSMcF0PpH47Bumm-KtQ7M_doDAGXq_Ai8z_kHcXjZA@mail.gmail.com>
Subject: Re: [patch 15/15] Bluetooth: hci_qca: Fix the teardown problem for real
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Tue, Nov 15, 2022 at 12:28 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> While discussing solutions for the teardown problem which results from
> circular dependencies between timers and workqueues, where timers schedule
> work from their timer callback and workqueues arm the timers from work
> items, it was discovered that the recent fix to the QCA code is incorrect.
>
> That commit fixes the obvious problem of using del_timer() instead of
> del_timer_sync() and reorders the teardown calls to
>
>    destroy_workqueue(wq);
>    del_timer_sync(t);
>
> This makes it less likely to explode, but it's still broken:
>
>    destroy_workqueue(wq);
>    /* After this point @wq cannot be touched anymore */
>
>    ---> timer expires
>          queue_work(wq) <---- Results in a NULl pointer dereference
>                               deep in the work queue core code.
>    del_timer_sync(t);
>
> Use the new timer_shutdown_sync() function to ensure that the timers are
> disarmed, no timer callbacks are running and the timers cannot be armed
> again. This restores the original teardown sequence:
>
>    timer_shutdown_sync(t);
>    destroy_workqueue(wq);
>
> which is now correct because the timer core silently ignores potential
> rearming attempts which can happen when destroy_workqueue() drains pending
> work before mopping up the workqueue.
>
> Fixes: 72ef98445aca ("Bluetooth: hci_qca: Use del_timer_sync() before freeing")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Link: https://lore.kernel.org/all/87iljhsftt.ffs@tglx
> ---
>  drivers/bluetooth/hci_qca.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -696,9 +696,15 @@ static int qca_close(struct hci_uart *hu
>         skb_queue_purge(&qca->tx_wait_q);
>         skb_queue_purge(&qca->txq);
>         skb_queue_purge(&qca->rx_memdump_q);
> +       /*
> +        * Shut the timers down so they can't be rearmed when
> +        * destroy_workqueue() drains pending work which in turn might try
> +        * to arm a timer.  After shutdown rearm attempts are silently
> +        * ignored by the timer core code.
> +        */
> +       timer_shutdown_sync(&qca->tx_idle_timer);
> +       timer_shutdown_sync(&qca->wake_retrans_timer);
>         destroy_workqueue(qca->workqueue);
> -       del_timer_sync(&qca->tx_idle_timer);
> -       del_timer_sync(&qca->wake_retrans_timer);
>         qca->hu = NULL;
>
>         kfree_skb(qca->rx_skb);
>

Acked-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

-- 
Luiz Augusto von Dentz
