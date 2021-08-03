Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B5B3DE6DD
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhHCGpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:45:39 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:50794
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233763AbhHCGph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 02:45:37 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id B12EB3F349
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 06:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627973125;
        bh=+Q2rAlAYYBVNir2KVDyLluGwoDwyo43cwd78CINIXVo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=VPEeMng3F8wAvr2BWRfbId2OL3DEXTnM7NKK1nebZ/lapP0fd4vjBP0+CPBN5MAvE
         t4nwyNJq01tO1ia0tNvQk5vn1TNSX2PtzXNm/ecypGoNl2JhfCkjKa9aDa1FMcBvTO
         ddeIiDXk8HPutp4BUtAXLOVbvtaSXOZgvkBTUbXsVVXMBArvwC8eXAAqEqJxKy9SZr
         SdSH3Htoss3pPECkIkViutDmzbATZPnDO+L73IhBabHg7uS3iSQsMtH57lHkvsr50h
         VEOSaW1PUcJJYYkG1NNOxHZFyl/UoQXSX2ZBz14rt0aecZLfdv/UrPWtN0ZMW+nrWN
         qfyl4fiqb4aWA==
Received: by mail-ej1-f71.google.com with SMTP id a19-20020a1709063e93b0290551ea218ea2so5609669ejj.5
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 23:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Q2rAlAYYBVNir2KVDyLluGwoDwyo43cwd78CINIXVo=;
        b=hs347xugKBPi9/SS5CYjZdQLsMLMpiai4S3w1ixqopQaexmKpGFUmHSMSf+ox9J1LR
         caQr3IDccdiynzGNttkluAM8fQ4epTK8LVefh4NazrBpdMZZ0Kuexgs+wKf6WaPwwbHq
         jrJblKtTjYKbdF+nrMAO7Xk8S7gEbSzABWua7ZZZ3uDefcsDX8ydm5wKEqRnJSF6i3m7
         mTG+CijvvuQoaCtRYF8uOc/9L1cvSTDIoIyNPK2t2AjpM+G4AHy1r/XUK2W/Sm8I76wp
         QVfVEzblIQIqxW2hMh5oIkqZA2MVVAgAt6hfzsAVS/LuIqASjauCTl84tzmC1BOvpnLt
         LP9Q==
X-Gm-Message-State: AOAM530ArCJtwhTAv0iQnm/U4txWIdzc9lhSp37Xd768/PGebEyLCAv7
        JAThN4xz0SFg+kqEohbRAeOvg5yBovrnGeSGwe4OwIpPRe3wI3pW5+XabVbs9/zxdfKmG04cqT7
        SG1+cN3IyqFuFvP9EWKzicPNFmSTR6myl6vmxXlPoOf7Pk6dnXg==
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr23818678edt.79.1627973125243;
        Mon, 02 Aug 2021 23:45:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLkC8p9FNTiDt95bzvMlWJVYp0CJLWGQCw1rd7id3mzuNI0MXf3HZeHn0QQNFn3RnVQoebmB4qC+ueQDx0M7c=
X-Received: by 2002:aa7:c9d8:: with SMTP id i24mr23818655edt.79.1627973124999;
 Mon, 02 Aug 2021 23:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210514071452.25220-1-kai.heng.feng@canonical.com> <20210802030538.2023-1-hdanton@sina.com>
In-Reply-To: <20210802030538.2023-1-hdanton@sina.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 3 Aug 2021 14:45:07 +0800
Message-ID: <CAAd53p4NO3KJkn2Zp=hxQOtR8vynkJpcPmNtwv2R6z=zei056Q@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
To:     Hillf Danton <hdanton@sina.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
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

On Mon, Aug 2, 2021 at 11:05 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Fri, 14 May 2021 15:14:52 +0800 Kai-Heng Feng wrote:
> > Rfkill block and unblock Intel USB Bluetooth [8087:0026] may make it
> > stops working:
> > [  509.691509] Bluetooth: hci0: HCI reset during shutdown failed
> > [  514.897584] Bluetooth: hci0: MSFT filter_enable is already on
> > [  530.044751] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
> > [  545.660350] usb 3-10: device descriptor read/64, error -110
> > [  561.283530] usb 3-10: device descriptor read/64, error -110
> > [  561.519682] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
> > [  566.686650] Bluetooth: hci0: unexpected event for opcode 0x0500
> > [  568.752452] Bluetooth: hci0: urb 0000000096cd309b failed to resubmit (113)
> > [  578.797955] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> > [  586.286565] Bluetooth: hci0: urb 00000000c522f633 failed to resubmit (113)
> > [  596.215302] Bluetooth: hci0: Failed to read MSFT supported features (-110)
> >
> > Or kernel panics because other workqueues already freed skb:
> > [ 2048.663763] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > [ 2048.663775] #PF: supervisor read access in kernel mode
> > [ 2048.663779] #PF: error_code(0x0000) - not-present page
> > [ 2048.663782] PGD 0 P4D 0
> > [ 2048.663787] Oops: 0000 [#1] SMP NOPTI
> > [ 2048.663793] CPU: 3 PID: 4491 Comm: rfkill Tainted: G        W         5.13.0-rc1-next-20210510+ #20
> > [ 2048.663799] Hardware name: HP HP EliteBook 850 G8 Notebook PC/8846, BIOS T76 Ver. 01.01.04 12/02/2020
> > [ 2048.663801] RIP: 0010:__skb_ext_put+0x6/0x50
> > [ 2048.663814] Code: 8b 1b 48 85 db 75 db 5b 41 5c 5d c3 be 01 00 00 00 e8 de 13 c0 ff eb e7 be 02 00 00 00 e8 d2 13 c0 ff eb db 0f 1f 44 00 00 55 <8b> 07 48 89 e5 83 f8 01 74 14 b8 ff ff ff ff f0 0f c1
> > 07 83 f8 01
> > [ 2048.663819] RSP: 0018:ffffc1d105b6fd80 EFLAGS: 00010286
> > [ 2048.663824] RAX: 0000000000000000 RBX: ffff9d9ac5649000 RCX: 0000000000000000
> > [ 2048.663827] RDX: ffffffffc0d1daf6 RSI: 0000000000000206 RDI: 0000000000000000
> > [ 2048.663830] RBP: ffffc1d105b6fd98 R08: 0000000000000001 R09: ffff9d9ace8ceac0
> > [ 2048.663834] R10: ffff9d9ace8ceac0 R11: 0000000000000001 R12: ffff9d9ac5649000
> > [ 2048.663838] R13: 0000000000000000 R14: 00007ffe0354d650 R15: 0000000000000000
> > [ 2048.663843] FS:  00007fe02ab19740(0000) GS:ffff9d9e5f8c0000(0000) knlGS:0000000000000000
> > [ 2048.663849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 2048.663853] CR2: 0000000000000000 CR3: 0000000111a52004 CR4: 0000000000770ee0
> > [ 2048.663856] PKRU: 55555554
> > [ 2048.663859] Call Trace:
> > [ 2048.663865]  ? skb_release_head_state+0x5e/0x80
> > [ 2048.663873]  kfree_skb+0x2f/0xb0
> > [ 2048.663881]  btusb_shutdown_intel_new+0x36/0x60 [btusb]
> > [ 2048.663905]  hci_dev_do_close+0x48c/0x5e0 [bluetooth]
> > [ 2048.663954]  ? __cond_resched+0x1a/0x50
> > [ 2048.663962]  hci_rfkill_set_block+0x56/0xa0 [bluetooth]
> > [ 2048.664007]  rfkill_set_block+0x98/0x170
> > [ 2048.664016]  rfkill_fop_write+0x136/0x1e0
> > [ 2048.664022]  vfs_write+0xc7/0x260
> > [ 2048.664030]  ksys_write+0xb1/0xe0
> > [ 2048.664035]  ? exit_to_user_mode_prepare+0x37/0x1c0
> > [ 2048.664042]  __x64_sys_write+0x1a/0x20
> > [ 2048.664048]  do_syscall_64+0x40/0xb0
> > [ 2048.664055]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [ 2048.664060] RIP: 0033:0x7fe02ac23c27
> > [ 2048.664066] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> > [ 2048.664070] RSP: 002b:00007ffe0354d638 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > [ 2048.664075] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe02ac23c27
> > [ 2048.664078] RDX: 0000000000000008 RSI: 00007ffe0354d650 RDI: 0000000000000003
> > [ 2048.664081] RBP: 0000000000000000 R08: 0000559b05998440 R09: 0000559b05998440
> > [ 2048.664084] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> > [ 2048.664086] R13: 0000000000000000 R14: ffffffff00000000 R15: 00000000ffffffff
> >
> > So move the shutdown callback to a place where workqueues are either
> > flushed or cancelled to resolve the issue.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >  - Rebased on bluetooth-next.
> >
> >  net/bluetooth/hci_core.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 7baf93eda936..6eedf334f943 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1716,14 +1716,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >
> >       BT_DBG("%s %p", hdev->name, hdev);
> >
> > -     if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > -         !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > -         test_bit(HCI_UP, &hdev->flags)) {
> > -             /* Execute vendor specific shutdown routine */
> > -             if (hdev->shutdown)
> > -                     hdev->shutdown(hdev);
> > -     }
> > -
> >       cancel_delayed_work(&hdev->power_off);
> >       cancel_delayed_work(&hdev->ncmd_timer);
> >
> > @@ -1801,6 +1793,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >               clear_bit(HCI_INIT, &hdev->flags);
> >       }
> >
> > +     if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > +         !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +         test_bit(HCI_UP, &hdev->flags)) {
> > +             /* Execute vendor specific shutdown routine */
> > +             if (hdev->shutdown)
> > +                     hdev->shutdown(hdev);
> > +     }
> > +
> >       /* flush cmd  work */
> >       flush_work(&hdev->cmd_work);
> >
> > --
> > 2.30.2
>
> btusb_shutdown_intel_new
>   __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL, HCI_INIT_TIMEOUT);
>     __hci_cmd_sync_ev(hdev, opcode, plen, param, 0, timeout);
>       hci_req_run_skb(&req, hci_req_sync_complete);
>
> hci_req_sync_complete
>   if (skb)
>         hdev->req_skb = skb_get(skb);
>
> Given the skb_get in hci_req_sync_complete makes it safe to free skb on
> driver side, I doubt this patch is the correct fix as it is.

Some workqueues are still active.
The shutdown() should be called at least after hci_request_cancel_all().

Kai-Heng
