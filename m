Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868813DB7F0
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhG3Lkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbhG3Lkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 07:40:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1875C061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 04:40:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so6179277wms.0
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 04:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=eZH6ID6JN6iX0H3pPHAq1xYGdgcDUQKy1n9bHToJ928=;
        b=HWUF9Y4NgzTcYZZLnJUPsF1QvXF8YbymIcp4lFLeCle6cVTtT6h+IsA94OKZZixU+J
         6g2f+h8gUBYPlAPF/kaaou5vto+6Z2iMdRBzFCUBC8mqNlt88QwZbegyzxQFVSuNzbOW
         bwdiM6q1m/5AZD5+XVkGuuv7foFvR0c+KaGqMo7UGJNxt89XBf9NaUA/OJycq9IurAOr
         +YT+i5gekHV7uTqP4msfkiVGvTm3E4es7FOcmvExBJP4NPgSCHJE2hkm/kSgSNEYE7TP
         uX8595kc4G3fKpb86ocVrqK52Opzq6Pdza5P/T7R+VQcqBQgCD9QEFtdLt5Cw5LTqkPX
         Sg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eZH6ID6JN6iX0H3pPHAq1xYGdgcDUQKy1n9bHToJ928=;
        b=JWQ3JFJ05CkZNYtkGhITyAMXcBflFUyYUc4eE8xlT0QbsMPGfrgEGmZMwRlR2s1WSz
         VEFXluWgxUhlhnFe9r+2B4JmTOVoElaPNfBwGR+bwPJZolbvJ2lmbhfn63IM2/0JndSx
         kyC2+8h9QRrV1nYpYD0usVqzXwH5dpqOFRaZBoMWryX6YICkJSsjQVVzlNhvuRub16oV
         npyJO0aXBvfhVGuuAWihc4ptvsduyDsJHZDkqpU9cBlRoTgScMGMT/BtZ6biUrBnBrAx
         AtBmwO8yGos26Er2zK7jFBBaflf8cfkwXQyPdzdn1m8gyvTcK8h9VEHgQjqgXMUDaBp6
         3pyg==
X-Gm-Message-State: AOAM531K2D3D5RHc7nzgW21zSB1FhDjb2hb1htWIbxljhlJby3BZQsMe
        3yEzJPJnCpZdwTpXg/UT9m1SHQ==
X-Google-Smtp-Source: ABdhPJwprO6/RUuUoMkZkjV7JSEVyItBgBNITiCGe0AkHiuRssPPVkhgdLfgu9hP75Ut7M4rIJrO5g==
X-Received: by 2002:a05:600c:3593:: with SMTP id p19mr2357910wmq.33.1627645235158;
        Fri, 30 Jul 2021 04:40:35 -0700 (PDT)
Received: from localhost ([2a01:cb19:826e:8e00:6536:8a22:58a3:a175])
        by smtp.gmail.com with ESMTPSA id 9sm1431619wmf.34.2021.07.30.04.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 04:40:34 -0700 (PDT)
From:   Mattijs Korpershoek <mkorpershoek@baylibre.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Bluetooth: Shutdown controller after workqueues are
 flushed or cancelled
In-Reply-To: <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
References: <20210514071452.25220-1-kai.heng.feng@canonical.com>
 <576B26FD-81F8-4632-82F6-57C4A7C096C4@holtmann.org>
 <8735ryk0o7.fsf@baylibre.com>
 <CAAd53p7Zc3Zk21rwj_x1BLgf8tWRxaKBmXARkM6d7Kpkb+fDZA@mail.gmail.com>
Date:   Fri, 30 Jul 2021 13:40:33 +0200
Message-ID: <87y29o58su.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,

Kai-Heng Feng <kai.heng.feng@canonical.com> writes:

> On Wed, Jul 28, 2021 at 9:50 PM Mattijs Korpershoek
> <mkorpershoek@baylibre.com> wrote:
>>
>> Hi Kai-Heng, Marcel,
>>
>> Marcel Holtmann <marcel@holtmann.org> writes:
>>
>> > Hi Kai-Heng,
>> >
>> >> Rfkill block and unblock Intel USB Bluetooth [8087:0026] may make it
>> >> stops working:
>> >> [  509.691509] Bluetooth: hci0: HCI reset during shutdown failed
>> >> [  514.897584] Bluetooth: hci0: MSFT filter_enable is already on
>> >> [  530.044751] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
>> >> [  545.660350] usb 3-10: device descriptor read/64, error -110
>> >> [  561.283530] usb 3-10: device descriptor read/64, error -110
>> >> [  561.519682] usb 3-10: reset full-speed USB device number 5 using xhci_hcd
>> >> [  566.686650] Bluetooth: hci0: unexpected event for opcode 0x0500
>> >> [  568.752452] Bluetooth: hci0: urb 0000000096cd309b failed to resubmit (113)
>> >> [  578.797955] Bluetooth: hci0: Failed to read MSFT supported features (-110)
>> >> [  586.286565] Bluetooth: hci0: urb 00000000c522f633 failed to resubmit (113)
>> >> [  596.215302] Bluetooth: hci0: Failed to read MSFT supported features (-110)
>> >>
>> >> Or kernel panics because other workqueues already freed skb:
>> >> [ 2048.663763] BUG: kernel NULL pointer dereference, address: 0000000000000000
>> >> [ 2048.663775] #PF: supervisor read access in kernel mode
>> >> [ 2048.663779] #PF: error_code(0x0000) - not-present page
>> >> [ 2048.663782] PGD 0 P4D 0
>> >> [ 2048.663787] Oops: 0000 [#1] SMP NOPTI
>> >> [ 2048.663793] CPU: 3 PID: 4491 Comm: rfkill Tainted: G        W         5.13.0-rc1-next-20210510+ #20
>> >> [ 2048.663799] Hardware name: HP HP EliteBook 850 G8 Notebook PC/8846, BIOS T76 Ver. 01.01.04 12/02/2020
>> >> [ 2048.663801] RIP: 0010:__skb_ext_put+0x6/0x50
>> >> [ 2048.663814] Code: 8b 1b 48 85 db 75 db 5b 41 5c 5d c3 be 01 00 00 00 e8 de 13 c0 ff eb e7 be 02 00 00 00 e8 d2 13 c0 ff eb db 0f 1f 44 00 00 55 <8b> 07 48 89 e5 83 f8 01 74 14 b8 ff ff ff ff f0 0f c1
>> >> 07 83 f8 01
>> >> [ 2048.663819] RSP: 0018:ffffc1d105b6fd80 EFLAGS: 00010286
>> >> [ 2048.663824] RAX: 0000000000000000 RBX: ffff9d9ac5649000 RCX: 0000000000000000
>> >> [ 2048.663827] RDX: ffffffffc0d1daf6 RSI: 0000000000000206 RDI: 0000000000000000
>> >> [ 2048.663830] RBP: ffffc1d105b6fd98 R08: 0000000000000001 R09: ffff9d9ace8ceac0
>> >> [ 2048.663834] R10: ffff9d9ace8ceac0 R11: 0000000000000001 R12: ffff9d9ac5649000
>> >> [ 2048.663838] R13: 0000000000000000 R14: 00007ffe0354d650 R15: 0000000000000000
>> >> [ 2048.663843] FS:  00007fe02ab19740(0000) GS:ffff9d9e5f8c0000(0000) knlGS:0000000000000000
>> >> [ 2048.663849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >> [ 2048.663853] CR2: 0000000000000000 CR3: 0000000111a52004 CR4: 0000000000770ee0
>> >> [ 2048.663856] PKRU: 55555554
>> >> [ 2048.663859] Call Trace:
>> >> [ 2048.663865]  ? skb_release_head_state+0x5e/0x80
>> >> [ 2048.663873]  kfree_skb+0x2f/0xb0
>> >> [ 2048.663881]  btusb_shutdown_intel_new+0x36/0x60 [btusb]
>> >> [ 2048.663905]  hci_dev_do_close+0x48c/0x5e0 [bluetooth]
>> >> [ 2048.663954]  ? __cond_resched+0x1a/0x50
>> >> [ 2048.663962]  hci_rfkill_set_block+0x56/0xa0 [bluetooth]
>> >> [ 2048.664007]  rfkill_set_block+0x98/0x170
>> >> [ 2048.664016]  rfkill_fop_write+0x136/0x1e0
>> >> [ 2048.664022]  vfs_write+0xc7/0x260
>> >> [ 2048.664030]  ksys_write+0xb1/0xe0
>> >> [ 2048.664035]  ? exit_to_user_mode_prepare+0x37/0x1c0
>> >> [ 2048.664042]  __x64_sys_write+0x1a/0x20
>> >> [ 2048.664048]  do_syscall_64+0x40/0xb0
>> >> [ 2048.664055]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> >> [ 2048.664060] RIP: 0033:0x7fe02ac23c27
>> >> [ 2048.664066] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
>> >> [ 2048.664070] RSP: 002b:00007ffe0354d638 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> >> [ 2048.664075] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe02ac23c27
>> >> [ 2048.664078] RDX: 0000000000000008 RSI: 00007ffe0354d650 RDI: 0000000000000003
>> >> [ 2048.664081] RBP: 0000000000000000 R08: 0000559b05998440 R09: 0000559b05998440
>> >> [ 2048.664084] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
>> >> [ 2048.664086] R13: 0000000000000000 R14: ffffffff00000000 R15: 00000000ffffffff
>> >>
>> >> So move the shutdown callback to a place where workqueues are either
>> >> flushed or cancelled to resolve the issue.
>> >>
>> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> >> ---
>> >> v2:
>> >> - Rebased on bluetooth-next.
>> >>
>> >> net/bluetooth/hci_core.c | 16 ++++++++--------
>> >> 1 file changed, 8 insertions(+), 8 deletions(-)
>> >
>> > patch has been applied to bluetooth-next tree.
>>
>> This patch seems to introduce a regression in the btmtksdio driver.
>> With this patch applied, I can't enable the hci0 interface anymore on mt8183-pumpkin:
>>
>> i500-pumpkin login: root
>> root@i500-pumpkin:~# uname -a
>> Linux i500-pumpkin 5.14.0-rc3 #94 SMP PREEMPT Wed Jul 28 11:58:20 CEST 2021 aarch64 aarch64 aarch64 GNU/Linux
>> root@i500-pumpkin:~# hciconfig hci0 up
>> Can't init device hci0: Connection timed out (110)
>> root@i500-pumpkin:~# hciconfig hci0 down
>> root@i500-pumpkin:~# hciconfig hci0 up
>> Can't init device hci0: Input/output error (5)
>>
>> Reverting it fixes the above issue.
>> Any suggestion on how to fix this without touching hci_core ?
>> Maybe the btmtksdio driver needs some rework. As I'm not familiar with the code, I would appreciate any tips.
>
> Can you please attach dmesg?  Also, full ftrace log on btmtksdio can
> also be helpful.
Thank you for your help. Sorry I did not post the logs previously.

dmesg: https://pastebin.com/tpWDNyQr
ftrace on btmtksdio: https://pastebin.com/jmhvmwUw

Mattijs
>
> Kai-Heng
>
>>
>> Thanks,
>> Mattijs Korpershoek
>>
>>
>> >
>> > Regards
>> >
>> > Marcel
