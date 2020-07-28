Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E15231021
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgG1Qxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731558AbgG1Qxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:53:50 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C378FC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:53:50 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id g20so2298230uan.7
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yvpeg2Hti/Lz6KJkvcbKXpV9L6rmb3s/f9V+aV3VkrA=;
        b=OlTI5XA+ZU7Eo568gSfdlWA6MNxaxKrClrzkgduxaM/FEXkDPxXZvNQnLBmu+3IxLU
         acAo2NhLc2fnCjvigk781R0yc19BV8juQIEXZ0HFT+sQbOqIfYMHzhnLZ/ng8ZWap5+1
         X14YoTNoMOybWBoUNlj+U9K+rSVqb4ofqZWRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yvpeg2Hti/Lz6KJkvcbKXpV9L6rmb3s/f9V+aV3VkrA=;
        b=IXB45Y+k5wmqIa/Dvi50CLzAUs+7u0BpbOpiA9JeNzsz5+suopLLo90UbJdGt0oFjN
         MGMd1Okj/tTBQp02VYZLD2OqcF0kF9QlMi2QM+NvgyDjLm63V7X8OLUGzaqgtpGQHgQg
         UqIB8DYYfUqvUF2kpqzchd2swh2NdPAw325FWN1Aeo9eVEzOJXo2K9OXWrCR8YKExuPM
         RHqfUgx/ykwTn2CkWw1W1o4Y3Z/dPCRnuXLu1TlGBkmHg5jkjXSNeUSIEMkGmKqUT2Cs
         z0L8YzyVaMzKrLtLgedxu+5LjVVPp35SIYj0nH/qvYuH9UYafuTBWG7nT2zSn+VQnbUv
         7u7w==
X-Gm-Message-State: AOAM5315zuqXRj2CLHxLehacgUGwTM+zIHbsIccA9P/oxd6dR+5B0i8W
        DX6sKRrPNofbd5cjJeq5zqkytu5gJj9BtIoV1k6RmA==
X-Google-Smtp-Source: ABdhPJz8G6Fxjs1PqttEWpFqjr3j1q3Jg+4zJ9wdpz3qudY9juV0OmietcvOJPOBkBwrKuQbpn9Oj2Y49/sEf5+FtdM=
X-Received: by 2002:a9f:2197:: with SMTP id 23mr10603446uac.60.1595955229872;
 Tue, 28 Jul 2020 09:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200728095253.v2.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
In-Reply-To: <20200728095253.v2.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Tue, 28 Jul 2020 09:53:37 -0700
Message-ID: <CANFp7mUYSJi5WWZ5nEkxyJd-LXgOzJ_gfgWJC2tPkrswtXu-0w@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Fix suspend notifier race
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I sent this a bit too quick without a Fixes tag. Please disregard. v3 coming up.

On Tue, Jul 28, 2020 at 9:53 AM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> Unregister from suspend notifications and cancel suspend preparations
> before running hci_dev_do_close. Otherwise, the suspend notifier may
> race with unregister and cause cmd_timeout even after hdev has been
> freed.
>
> Below is the trace from when this panic was seen:
>
> [  832.578518] Bluetooth: hci_core.c:hci_cmd_timeout() hci0: command 0x0c05 tx timeout
> [  832.586200] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  832.586203] #PF: supervisor read access in kernel mode
> [  832.586205] #PF: error_code(0x0000) - not-present page
> [  832.586206] PGD 0 P4D 0
> [  832.586210] PM: suspend exit
> [  832.608870] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  832.613232] CPU: 3 PID: 10755 Comm: kworker/3:7 Not tainted 5.4.44-04894-g1e9dbb96a161 #1
> [  832.630036] Workqueue: events hci_cmd_timeout [bluetooth]
> [  832.630046] RIP: 0010:__queue_work+0xf0/0x374
> [  832.630051] RSP: 0018:ffff9b5285f1fdf8 EFLAGS: 00010046
> [  832.674033] RAX: ffff8a97681bac00 RBX: 0000000000000000 RCX: ffff8a976a000600
> [  832.681162] RDX: 0000000000000000 RSI: 0000000000000009 RDI: ffff8a976a000748
> [  832.688289] RBP: ffff9b5285f1fe38 R08: 0000000000000000 R09: ffff8a97681bac00
> [  832.695418] R10: 0000000000000002 R11: ffff8a976a0006d8 R12: ffff8a9745107600
> [  832.698045] usb 1-6: new full-speed USB device number 119 using xhci_hcd
> [  832.702547] R13: ffff8a9673658850 R14: 0000000000000040 R15: 000000000000001e
> [  832.702549] FS:  0000000000000000(0000) GS:ffff8a976af80000(0000) knlGS:0000000000000000
> [  832.702550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  832.702550] CR2: 0000000000000000 CR3: 000000010415a000 CR4: 00000000003406e0
> [  832.702551] Call Trace:
> [  832.702558]  queue_work_on+0x3f/0x68
> [  832.702562]  process_one_work+0x1db/0x396
> [  832.747397]  worker_thread+0x216/0x375
> [  832.751147]  kthread+0x138/0x140
> [  832.754377]  ? pr_cont_work+0x58/0x58
> [  832.758037]  ? kthread_blkcg+0x2e/0x2e
> [  832.761787]  ret_from_fork+0x22/0x40
> [  832.846191] ---[ end trace fa93f466da517212 ]---
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> Hi Marcel,
>
> This fixes a race between hci_unregister_dev and the suspend notifier.
>
> The suspend notifier handler seemed to be scheduling commands even after
> it was cleaned up and this was resulting in a panic in cmd_timeout (when
> it tries to requeue the cmd_timer).
>
> This was tested on 5.4 kernel with a suspend+resume stress test for 500+
> iterations. I also confirmed that after a usb disconnect, the suspend
> notifier times out before the USB device is probed again (fixing the
> original race between the usb_disconnect + probe and the notifier).
>
> Thanks
> Abhishek
>
>
> Changes in v2:
> * Moved oops into commit message
>
>  net/bluetooth/hci_core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5394ab56c915a9..4ba23b821cbf4a 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3767,9 +3767,10 @@ void hci_unregister_dev(struct hci_dev *hdev)
>
>         cancel_work_sync(&hdev->power_on);
>
> -       hci_dev_do_close(hdev);
> -
>         unregister_pm_notifier(&hdev->suspend_notifier);
> +       cancel_work_sync(&hdev->suspend_prepare);
> +
> +       hci_dev_do_close(hdev);
>
>         if (!test_bit(HCI_INIT, &hdev->flags) &&
>             !hci_dev_test_flag(hdev, HCI_SETUP) &&
> --
> 2.28.0.rc0.142.g3c755180ce-goog
>
