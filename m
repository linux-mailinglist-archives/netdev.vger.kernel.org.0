Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B653E0DF8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 08:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhHEGMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 02:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhHEGMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 02:12:50 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F6AC0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 23:12:36 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 188so3631466ioa.8
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 23:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gU4DcyTuEfs53h2u5rnsqBhluzfPKtNUI3JuZEnf8Vw=;
        b=QaFuazGqXKXVUefNfbHpKyMO2kZOt2tmGh6GlIXAYbiNGTZK3quOcskLunHY1oBsw7
         cXQa9BCUXwsZiuBfWi3l1mUStvnlKWPBFzb/zCaaLlrhK4PeAItAGfXIiCKOChsIbIw1
         imtfU8KUUFt+GlqdrPpgzUf6tdFKojOjJZchA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gU4DcyTuEfs53h2u5rnsqBhluzfPKtNUI3JuZEnf8Vw=;
        b=Jr75BXlzr8ViSI3e8O9mvUfkNHCgFKG2WDEQ5ZGYsa9bI4uwot4hM3MOoYOyptfU5k
         PEIaPN0HWLf/E35ppedWHRBhXYgtOlt7k55114pqA+YfusNih9k8HO+g30I273Vj2LZ3
         T2uzixrHq+WIRfOPo+et3tzPlJPDylhPtY80onpFBuNwCYy7RW7680hrWfwxNON1f6cC
         OiXtPMhgUp10m/QMGYZVgMbq5a0vs8oJvExaK/um7qhgrSgSWz/LZIvAdMSsNsA5LkLa
         OeSDuBrDRi+CJsA1/LG67IKxMSjdtzdzW1Q+rMvDmHAQPY9tZEhXwq/TSpIRuaSfRQNw
         idYw==
X-Gm-Message-State: AOAM5320W+IQZEpNTzsidS1aY2TaL0guhR6C357KahtQ+3GhbR3w2dNB
        y/PPONQqHz/obuJiFji/20ocRXwR/oYgFiZBC60qBA==
X-Google-Smtp-Source: ABdhPJzXqUglAP+NmPtfQU0dkX+5cbEMg5HBIIPjOt4LrWhXBRw9EtrOQxlXsDnGe7CIPi1CS6RfrPR6ZgSwCPKtbKE=
X-Received: by 2002:a02:6a24:: with SMTP id l36mr3020270jac.4.1628143955837;
 Wed, 04 Aug 2021 23:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <20210802030538.2023-1-hdanton@sina.com> <CAAd53p4NO3KJkn2Zp=hxQOtR8vynkJpcPmNtwv2R6z=zei056Q@mail.gmail.com>
In-Reply-To: <CAAd53p4NO3KJkn2Zp=hxQOtR8vynkJpcPmNtwv2R6z=zei056Q@mail.gmail.com>
From:   Hsin-Yi Wang <hsinyi@chromium.org>
Date:   Thu, 5 Aug 2021 14:12:10 +0800
Message-ID: <CAJMQK-gT4e_xTc8WY+n52DJPUagPGce-0FJEtqZSwPm3U=LViQ@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
        <linux-bluetooth@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 2:45 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> On Mon, Aug 2, 2021 at 11:05 AM Hillf Danton <hdanton@sina.com> wrote:
> >
> > On Fri, 14 May 2021 15:14:52 +0800 Kai-Heng Feng wrote:
> > > Rfkill block and unblock Intel USB Bluetooth [8087:0026] may make it
> > > stops working:
> > > [  509.691509] Bluetooth: hci0: HCI reset during shutdown failed
> > > [  514.897584] Bluetooth: hci0: MSFT filter_enable is already on
> > > [  530.044751] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
> > > [  545.660350] usb 3-10: device descriptor read/64, error -110
> > > [  561.283530] usb 3-10: device descriptor read/64, error -110
> > > [  561.519682] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
> > > [  566.686650] Bluetooth: hci0: unexpected event for opcode 0x0500
> > > [  568.752452] Bluetooth: hci0: urb 0000000096cd309b failed to resubmit (113)
> > > [  578.797955] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> > > [  586.286565] Bluetooth: hci0: urb 00000000c522f633 failed to resubmit (113)
> > > [  596.215302] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> > >
> > > Or kernel panics because other workqueues already freed skb:
> > > [ 2048.663763] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > [ 2048.663775] #PF: supervisor read access in kernel mode
> > > [ 2048.663779] #PF: error_code(0x0000) - not-present page
> > > [ 2048.663782] PGD 0 P4D 0
> > > [ 2048.663787] Oops: 0000 [#1] SMP NOPTI
> > > [ 2048.663793] CPU: 3 PID: 4491 Comm: rfkill Tainted: G        W         5.13.0-rc1-next-20210510+ #20
> > > [ 2048.663799] Hardware name: HP HP EliteBook 850 G8 Notebook PC/8846, BIOS T76 Ver. 01.01.04 12/02/2020
> > > [ 2048.663801] RIP: 0010:__skb_ext_put+0x6/0x50
> > > [ 2048.663814] Code: 8b 1b 48 85 db 75 db 5b 41 5c 5d c3 be 01 00 00 00 e8 de 13 c0 ff eb e7 be 02 00 00 00 e8 d2 13 c0 ff eb db 0f 1f 44 00 00 55 <8b> 07 48 89 e5 83 f8 01 74 14 b8 ff ff ff ff f0 0f c1
> > > 07 83 f8 01
> > > [ 2048.663819] RSP: 0018:ffffc1d105b6fd80 EFLAGS: 00010286
> > > [ 2048.663824] RAX: 0000000000000000 RBX: ffff9d9ac5649000 RCX: 0000000000000000
> > > [ 2048.663827] RDX: ffffffffc0d1daf6 RSI: 0000000000000206 RDI: 0000000000000000
> > > [ 2048.663830] RBP: ffffc1d105b6fd98 R08: 0000000000000001 R09: ffff9d9ace8ceac0
> > > [ 2048.663834] R10: ffff9d9ace8ceac0 R11: 0000000000000001 R12: ffff9d9ac5649000
> > > [ 2048.663838] R13: 0000000000000000 R14: 00007ffe0354d650 R15: 0000000000000000
> > > [ 2048.663843] FS:  00007fe02ab19740(0000) GS:ffff9d9e5f8c0000(0000) knlGS:0000000000000000
> > > [ 2048.663849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [ 2048.663853] CR2: 0000000000000000 CR3: 0000000111a52004 CR4: 0000000000770ee0
> > > [ 2048.663856] PKRU: 55555554
> > > [ 2048.663859] Call Trace:
> > > [ 2048.663865]  ? skb_release_head_state+0x5e/0x80
> > > [ 2048.663873]  kfree_skb+0x2f/0xb0
> > > [ 2048.663881]  btusb_shutdown_intel_new+0x36/0x60 [btusb]
> > > [ 2048.663905]  hci_dev_do_close+0x48c/0x5e0 [bluetooth]
> > > [ 2048.663954]  ? __cond_resched+0x1a/0x50
> > > [ 2048.663962]  hci_rfkill_set_block+0x56/0xa0 [bluetooth]
> > > [ 2048.664007]  rfkill_set_block+0x98/0x170
> > > [ 2048.664016]  rfkill_fop_write+0x136/0x1e0
> > > [ 2048.664022]  vfs_write+0xc7/0x260
> > > [ 2048.664030]  ksys_write+0xb1/0xe0
> > > [ 2048.664035]  ? exit_to_user_mode_prepare+0x37/0x1c0
> > > [ 2048.664042]  __x64_sys_write+0x1a/0x20
> > > [ 2048.664048]  do_syscall_64+0x40/0xb0
> > > [ 2048.664055]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [ 2048.664060] RIP: 0033:0x7fe02ac23c27
> > > [ 2048.664066] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> > > [ 2048.664070] RSP: 002b:00007ffe0354d638 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > > [ 2048.664075] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe02ac23c27
> > > [ 2048.664078] RDX: 0000000000000008 RSI: 00007ffe0354d650 RDI: 0000000000000003
> > > [ 2048.664081] RBP: 0000000000000000 R08: 0000559b05998440 R09: 0000559b05998440
> > > [ 2048.664084] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> > > [ 2048.664086] R13: 0000000000000000 R14: ffffffff00000000 R15: 00000000ffffffff
> > >
> > > So move the shutdown callback to a place where workqueues are either
> > > flushed or cancelled to resolve the issue.
> > >
> > > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > ---
> > > v2:
> > >  - Rebased on bluetooth-next.
> > >
> > >  net/bluetooth/hci_core.c | 16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index 7baf93eda936..6eedf334f943 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -1716,14 +1716,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
> > >
> > >       BT_DBG("%s %p", hdev->name, hdev);
> > >
> > > -     if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > > -         !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > > -         test_bit(HCI_UP, &hdev->flags)) {
> > > -             /* Execute vendor specific shutdown routine */
> > > -             if (hdev->shutdown)
> > > -                     hdev->shutdown(hdev);
> > > -     }
> > > -
> > >       cancel_delayed_work(&hdev->power_off);
> > >       cancel_delayed_work(&hdev->ncmd_timer);
> > >
> > > @@ -1801,6 +1793,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> > >               clear_bit(HCI_INIT, &hdev->flags);
> > >       }
> > >
> > > +     if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > > +         !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > > +         test_bit(HCI_UP, &hdev->flags)) {
> > > +             /* Execute vendor specific shutdown routine */
> > > +             if (hdev->shutdown)
> > > +                     hdev->shutdown(hdev);
> > > +     }
> > > +
> > >       /* flush cmd  work */
> > >       flush_work(&hdev->cmd_work);
> > >
> > > --
> > > 2.30.2
> >
> > btusb_shutdown_intel_new
> >   __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL, HCI_INIT_TIMEOUT);
> >     __hci_cmd_sync_ev(hdev, opcode, plen, param, 0, timeout);
> >       hci_req_run_skb(&req, hci_req_sync_complete);
> >
> > hci_req_sync_complete
> >   if (skb)
> >         hdev->req_skb = skb_get(skb);
> >
> > Given the skb_get in hci_req_sync_complete makes it safe to free skb on
> > driver side, I doubt this patch is the correct fix as it is.
>
> Some workqueues are still active.
> The shutdown() should be called at least after hci_request_cancel_all().
>
Hello,

The original patch 60789afc02f592b8d91217b60930e7a76271ae07
("Bluetooth: Shutdown controller after workqueues are flushed or
cancelled") is causing the tx fail when downloading fw on mediatek
mt8183 device using QCA bluetooth:

[  225.205061] Bluetooth: qca_download_firmware() hci0: QCA
Downloading qca/rampatch_00440302.bin
[  227.252653] Bluetooth: hci_cmd_timeout() hci0: command 0xfc00 tx timeout
...
follows by a lot of:
[  223.604971] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)
[  223.605027] Bluetooth: qca_recv() hci0: Frame reassembly failed (-84)

After applying the fixup to allow tx, the issue is solved.


> Kai-Heng
