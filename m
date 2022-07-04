Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3C565E35
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbiGDT5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGDT5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:57:11 -0400
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01D35F91
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:57:08 -0700 (PDT)
Received: (wp-smtpd smtp.tlen.pl 24291 invoked from network); 4 Jul 2022 21:57:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1656964625; bh=JAPDsnJCAOoJpyKrd8cy2v9k90C1Stc2pfXNgFAfZqU=;
          h=From:Subject:To:Cc;
          b=Bl7LEahpMO/syyT85vclH0SRb1OfXVYTWvJaZ78xyqVa7UHN2Fg7af1Lzg0YbJgCC
           0ei2ecwLTEEwakGpvN+KSGBiJipSBajD8XillMdF0rve5GXmZqb5O+YITDhikq+NQ/
           PYx9xxLLwdoa+ODb9gZHn1SYVkSprHrFPq4x0RTA=
Received: from aafi210.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.138.210])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <max.oss.09@gmail.com>; 4 Jul 2022 21:57:04 +0200
Message-ID: <1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl>
Date:   Mon, 4 Jul 2022 21:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
Subject: Re: [PATCH v1] Revert "Bluetooth: core: Fix missing power_on work
 cancel on HCI close"
To:     Max Krummenacher <max.oss.09@gmail.com>,
        max.krummenacher@toradex.com,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220614181706.26513-1-max.oss.09@gmail.com>
Content-Language: en-GB
In-Reply-To: <20220614181706.26513-1-max.oss.09@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 9db1f93d5b2afb0feb3e16567f79cb6e
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000001 [EeJ1]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 14.06.2022 o 20:17, Max Krummenacher pisze:
> From: Max Krummenacher <max.krummenacher@toradex.com>
>
> This reverts commit ff7f2926114d3a50f5ffe461a9bce8d761748da5.
>
> The commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work
> cancel on HCI close") introduced between v5.18 and v5.19-rc1 makes
> going to suspend freeze. v5.19-rc2 is equally affected.
>
> This has been seen on a Colibri iMX6ULL WB which has a Marvell 8997
> based WiFi / Bluetooth module connected over SDIO.
> [...]

Hello,

commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")

causes problems also on my laptop (HP 17-by0001nw with a Realtek Bluetooth adapter).

I have Bluetooth disabled by default on startup (via systemd-rfkill.service ) and
vanilla kernel 5.19.0-rc5 fails to suspend (the screen turns black, but I am then able to
touch a trackpad and log in). Reverting that commit on top of 5.19.0-rc5 fixes the issue.

On bare 5.19.0-rc5, after startup, the kworker/u9:0+hci0 process hangs indefinitely
with this stacktrace (obtained through "cat /proc/163/stack" )

        [<0>] __flush_work+0x143/0x220
        [<0>] __cancel_work_timer+0x122/0x1a0
        [<0>] cancel_work_sync+0x10/0x20
        [<0>] hci_dev_close_sync+0x2a/0x550 [bluetooth]
        [<0>] hci_dev_do_close+0x2a/0x60 [bluetooth]
        [<0>] hci_power_on+0x91/0x200 [bluetooth]
        [<0>] process_one_work+0x21c/0x3c0
        [<0>] worker_thread+0x4a/0x3a0
        [<0>] kthread+0xcf/0xf0
        [<0>] ret_from_fork+0x22/0x30

It appears that the hci_power_on() function calls hci_dev_do_close() in this block:

    if (hci_dev_test_flag(hdev, HCI_RFKILLED) ||
         /* [...] */ ) {
        hci_dev_clear_flag(hdev, HCI_AUTO_OFF);
        hci_dev_do_close(hdev);
    } else /* [...] */

which then calls hci_dev_close_sync(). With the problematic commit, that function
calls

       cancel_work_sync(&hdev->power_on)

which tries to cancel the execution of the hci_power_on() function's itself, which leads to a deadlock.

When trying to suspend, the "/lib/systemd/systemd-sleep suspend" process hangs on

        [<0>] hci_suspend_dev+0x87/0xf0 [bluetooth]
        [<0>] hci_suspend_notifier+0x38/0x80 [bluetooth]
        [<0>] notifier_call_chain_robust+0x5e/0xc0
        [<0>] blocking_notifier_call_chain_robust+0x42/0x60
        [<0>] pm_notifier_call_chain_robust+0x1d/0x40
        [<0>] pm_suspend+0x116/0x5a0
        [<0>] state_store+0x82/0xe0
        [<0>] kobj_attr_store+0x12/0x20
        [<0>] sysfs_kf_write+0x3e/0x50
        [<0>] kernfs_fop_write_iter+0x138/0x1c0
        [<0>] new_sync_write+0x104/0x180
        [<0>] vfs_write+0x1d7/0x260
        [<0>] ksys_write+0x67/0xe0
        [<0>] __x64_sys_write+0x1a/0x20
        [<0>] do_syscall_64+0x3b/0x90
        [<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

My device is:

Bus 001 Device 005: ID 0bda:b00b Realtek Semiconductor Corp. Bluetooth Radio

So probably the
commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
should be reverted or corrected.

Greetings,

Mateusz Jończyk

> Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
> ---
>
>  net/bluetooth/hci_core.c | 2 ++
>  net/bluetooth/hci_sync.c | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 59a5c1341c26..19df3905c5f8 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2675,6 +2675,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
>  	list_del(&hdev->list);
>  	write_unlock(&hci_dev_list_lock);
>  
> +	cancel_work_sync(&hdev->power_on);
> +
>  	hci_cmd_sync_clear(hdev);
>  
>  	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 286d6767f017..1739e8cb3291 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4088,7 +4088,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>  
>  	bt_dev_dbg(hdev, "");
>  
> -	cancel_work_sync(&hdev->power_on);
>  	cancel_delayed_work(&hdev->power_off);
>  	cancel_delayed_work(&hdev->ncmd_timer);
>  


