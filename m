Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A859E505A51
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbiDROyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 10:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbiDROxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 10:53:55 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86738B6D;
        Mon, 18 Apr 2022 06:41:37 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id z8so14793705oix.3;
        Mon, 18 Apr 2022 06:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ubhpGHFm7fEE+X8m8UI6hc3ul0maTC3658iNeOw7TAY=;
        b=X1fIQ3C0f/dmi+lxG8SHihJHytTYm6s7FC8V/gRLYwqsPBCemryemlPNU4HjfwXGei
         Jud4et1Q+XFryinXvIP7652iPWkvTTx4qzhmBPIk5/vKGsKVJvF61DkZs9Itr47BwDVL
         CFL02MyVLCGUNyGd4wAKAtIonZXW8fhkzdL6AHZkNB7nxj50APoN9qPTWV3LwzJ7sFvl
         0cUL7dUv9D9pptuo8QnMB92Uvj8qgJu2+82kblvR1mJcqjMk0zc1ZCbahI4lkAjfCmGi
         7R5drwtvBHKzx2PJys4TP4H44tqNUWV6QOzt8lqHZU1VdaGqlNVB5gwnzZKcNMSMBp1F
         6hNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ubhpGHFm7fEE+X8m8UI6hc3ul0maTC3658iNeOw7TAY=;
        b=DxHJo5M0rlBs3tor6+Zso7FJ4a9sdG1Rgnf5DgL9IJc2qnq8jALLu2eQLpZZ9o7QRZ
         tc47XxkmJjs9oYHR1h5FlJopW2ASoW/L4HAn4E4uWULtxaCc8A2NSPd0bX+BgqYx9Wvi
         dZuTevcb2xJpSN1eWgR7KB+DGm+CdkVGWZVLcZgaf3pyJkCsCLwCEHSKt64odsNY/EdY
         RLfnmCpyiWP/hC+ISR5VHNBiIDJmJin15lEwNR4AA5nHBJlJ6F2o5q/DPOtb/H7yaAAs
         LTxBQ5Y05GVpaujFtLJZhTtBSN75EdX+ReOMV3q0+w4IFgL+64Kw6Ro95Nh3x0GY2Mev
         gp2A==
X-Gm-Message-State: AOAM5319ZJ2WDRe2ZPh3GvvEFhDQvVWgyLbHIvluHydibmH69VwT1Mef
        YEaNhRiiO9dW7/m+IPu/xXE=
X-Google-Smtp-Source: ABdhPJxe/5f38q7xHC0JZap0vWgJrQeiMxC+J+P92aDcVm+6vWHzXxjEYEjOPaueJZkxl8C711eWzQ==
X-Received: by 2002:aca:d1a:0:b0:322:35db:2c0 with SMTP id 26-20020aca0d1a000000b0032235db02c0mr5290438oin.82.1650289295359;
        Mon, 18 Apr 2022 06:41:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16-20020a056870d41000b000e1a3a897basm4126947oag.26.2022.04.18.06.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 06:41:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 06:41:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
Subject: Re: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
Message-ID: <20220418134133.GA872670@roeck-us.net>
References: <20220412160430.11581-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412160430.11581-1-linma@zju.edu.cn>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:04:30AM +0800, Lin Ma wrote:
> Our detector found a concurrent use-after-free bug when detaching an
> NCI device. The main reason for this bug is the unexpected scheduling
> between the used delayed mechanism (timer and workqueue).
> 
> The race can be demonstrated below:
> 
> Thread-1                           Thread-2
>                                  | nci_dev_up()
>                                  |   nci_open_device()
>                                  |     __nci_request(nci_reset_req)
>                                  |       nci_send_cmd
>                                  |         queue_work(cmd_work)
> nci_unregister_device()          |
>   nci_close_device()             | ...
>     del_timer_sync(cmd_timer)[1] |
> ...                              | Worker
> nci_free_device()                | nci_cmd_work()
>   kfree(ndev)[3]                 |   mod_timer(cmd_timer)[2]
> 
> In short, the cleanup routine thought that the cmd_timer has already
> been detached by [1] but the mod_timer can re-attach the timer [2], even
> it is already released [3], resulting in UAF.
> 
> This UAF is easy to trigger, crash trace by POC is like below
> 
> [   66.703713] ==================================================================
> [   66.703974] BUG: KASAN: use-after-free in enqueue_timer+0x448/0x490
> [   66.703974] Write of size 8 at addr ffff888009fb7058 by task kworker/u4:1/33
> [   66.703974]
> [   66.703974] CPU: 1 PID: 33 Comm: kworker/u4:1 Not tainted 5.18.0-rc2 #5
> [   66.703974] Workqueue: nfc2_nci_cmd_wq nci_cmd_work
> [   66.703974] Call Trace:
> [   66.703974]  <TASK>
> [   66.703974]  dump_stack_lvl+0x57/0x7d
> [   66.703974]  print_report.cold+0x5e/0x5db
> [   66.703974]  ? enqueue_timer+0x448/0x490
> [   66.703974]  kasan_report+0xbe/0x1c0
> [   66.703974]  ? enqueue_timer+0x448/0x490
> [   66.703974]  enqueue_timer+0x448/0x490
> [   66.703974]  __mod_timer+0x5e6/0xb80
> [   66.703974]  ? mark_held_locks+0x9e/0xe0
> [   66.703974]  ? try_to_del_timer_sync+0xf0/0xf0
> [   66.703974]  ? lockdep_hardirqs_on_prepare+0x17b/0x410
> [   66.703974]  ? queue_work_on+0x61/0x80
> [   66.703974]  ? lockdep_hardirqs_on+0xbf/0x130
> [   66.703974]  process_one_work+0x8bb/0x1510
> [   66.703974]  ? lockdep_hardirqs_on_prepare+0x410/0x410
> [   66.703974]  ? pwq_dec_nr_in_flight+0x230/0x230
> [   66.703974]  ? rwlock_bug.part.0+0x90/0x90
> [   66.703974]  ? _raw_spin_lock_irq+0x41/0x50
> [   66.703974]  worker_thread+0x575/0x1190
> [   66.703974]  ? process_one_work+0x1510/0x1510
> [   66.703974]  kthread+0x2a0/0x340
> [   66.703974]  ? kthread_complete_and_exit+0x20/0x20
> [   66.703974]  ret_from_fork+0x22/0x30
> [   66.703974]  </TASK>
> [   66.703974]
> [   66.703974] Allocated by task 267:
> [   66.703974]  kasan_save_stack+0x1e/0x40
> [   66.703974]  __kasan_kmalloc+0x81/0xa0
> [   66.703974]  nci_allocate_device+0xd3/0x390
> [   66.703974]  nfcmrvl_nci_register_dev+0x183/0x2c0
> [   66.703974]  nfcmrvl_nci_uart_open+0xf2/0x1dd
> [   66.703974]  nci_uart_tty_ioctl+0x2c3/0x4a0
> [   66.703974]  tty_ioctl+0x764/0x1310
> [   66.703974]  __x64_sys_ioctl+0x122/0x190
> [   66.703974]  do_syscall_64+0x3b/0x90
> [   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   66.703974]
> [   66.703974] Freed by task 406:
> [   66.703974]  kasan_save_stack+0x1e/0x40
> [   66.703974]  kasan_set_track+0x21/0x30
> [   66.703974]  kasan_set_free_info+0x20/0x30
> [   66.703974]  __kasan_slab_free+0x108/0x170
> [   66.703974]  kfree+0xb0/0x330
> [   66.703974]  nfcmrvl_nci_unregister_dev+0x90/0xd0
> [   66.703974]  nci_uart_tty_close+0xdf/0x180
> [   66.703974]  tty_ldisc_kill+0x73/0x110
> [   66.703974]  tty_ldisc_hangup+0x281/0x5b0
> [   66.703974]  __tty_hangup.part.0+0x431/0x890
> [   66.703974]  tty_release+0x3a8/0xc80
> [   66.703974]  __fput+0x1f0/0x8c0
> [   66.703974]  task_work_run+0xc9/0x170
> [   66.703974]  exit_to_user_mode_prepare+0x194/0x1a0
> [   66.703974]  syscall_exit_to_user_mode+0x19/0x50
> [   66.703974]  do_syscall_64+0x48/0x90
> [   66.703974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> To fix the UAF, this patch adds flush_workqueue() to ensure the
> nci_cmd_work is finished before the following del_timer_sync.
> This combination will promise the timer is actually detached.
> 
> Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  net/nfc/nci/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index d2537383a3e8..0d7763c322b5 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -560,6 +560,10 @@ static int nci_close_device(struct nci_dev *ndev)
>  	mutex_lock(&ndev->req_lock);
>  
>  	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
> +		/* Need to flush the cmd wq in case
> +		 * there is a queued/running cmd_work
> +		 */
> +		flush_workqueue(ndev->cmd_wq);
>  		del_timer_sync(&ndev->cmd_timer);

I have been wondering about this and the same code further below.
What prevents the command timer from firing after the call to
flush_workqueue() ?

Thanks,
Guenter

>  		del_timer_sync(&ndev->data_timer);
>  		mutex_unlock(&ndev->req_lock);
