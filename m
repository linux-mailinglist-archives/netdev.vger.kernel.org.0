Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EE937249
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfFFK7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:59:25 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:46200 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfFFK7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:59:23 -0400
Received: by mail-ua1-f65.google.com with SMTP id o19so674948uap.13
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 03:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BCQjT/dN+S6PT9bic2mJjb0lJGYLVQpNMvJ1zYghNDc=;
        b=QXtKos/kTzNpN15u7L22xuMZ+X/tFCdNDCGyhWw3JEmjnGpckmY3Zb26rEOzKhwUHv
         3TJl3S0bbQrdyx2biZbkTcf3pmj7tvyArojCPmJiBpZOj6UJUAPt/4hZVXyXHPDuJOFP
         XnI5PBY8mSW3ckXI+YKfEo73RtS6W8u4G8sxCW3rZMzkTMdnXd8NfpAzzII4cr1ZAa6t
         vDzcfoys+KvDh2DCYEsRAaUO0Uz7fIcasFW7q8aHe1qb+IiNRTyruKmqHGbbBsZXfA9i
         9TvyeqtcK73tS8KYsHvAKCUKY6LxPaeQwnY/EeDD0QqIwVfmtW64Wx2zBvMnShUiTs35
         PR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BCQjT/dN+S6PT9bic2mJjb0lJGYLVQpNMvJ1zYghNDc=;
        b=tIYXEuR7cofV4yi0wTe1u7jIyh/ieWuryq45J4riAC7qHIur2G2uQLIwsIHh02Mxp5
         aS36zn3wrzLPc4IlvN2I1OafMcP1as2txVEbKWonNGWoQ1H8N8zfvd1x/tBJL29+jzWA
         oFur1vxuN5tgCCTCUtDDTu7RJ9uJaWa/EC+2WGFNTaKnoDjeclHu0KagE9fxzswjZLt2
         /f365K7SyUSo3T/X/P26A84Im/jBrOh6ZAvgJhBEBmI+djTkWA26O8Se32Xvb64fJvtg
         d9d3yc2ibMAZl9BS+QVL1NwVAm5uEYiD0rL25gTxKx8boLq1Jdc3drENkdu3VehV7pG3
         JB8A==
X-Gm-Message-State: APjAAAUDUkx9Xv1RSlPlx5joh2Hx1IWDrpf2g4Jdb9xKsKh2+4nbQL3e
        f5swSji83mXD2HcILNRVvC57Mt9pVJRaWmCUcVkeUQ==
X-Google-Smtp-Source: APXvYqxIqsPCf+QjrfA+yoMATC25AYnBEKSnSLTLpDgMldaWwYiUA0Otk95MzrliXpVNkDVeZpPEawnhtSpG+00cfWQ=
X-Received: by 2002:ab0:64cc:: with SMTP id j12mr11087480uaq.110.1559818761644;
 Thu, 06 Jun 2019 03:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cf6a70058aa48695@google.com>
In-Reply-To: <000000000000cf6a70058aa48695@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 6 Jun 2019 12:59:10 +0200
Message-ID: <CAG_fn=Vk-7VH74e=E6fssHP25Jf84RDaJX_0z77xRNsnZquhvw@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in rt2500usb_bbp_read
To:     syzbot <syzbot+a106a5b084a6890d2607@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, sgruszka@redhat.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 11:42 AM syzbot
<syzbot+a106a5b084a6890d2607@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
> git tree:       kmsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12f8b01ea0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D602468164ccdc=
30a
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Da106a5b084a6890=
d2607
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14f746f2a00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D153072d2a0000=
0
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+a106a5b084a6890d2607@syzkaller.appspotmail.com
>
> usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
> usb 1-1: config 0 descriptor??
> usb 1-1: reset high-speed USB device number 2 using dummy_hcd
> usb 1-1: device descriptor read/64, error -71
> ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x09
> failed for offset 0x0000 with error -71
> ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x07
As this line suggests:
> failed for offset 0x04d0 with error -71
, rt2x00usb_vendor_req_buff_lock() fails with error -71, which means
it doesn't initialize the buffer.
But rt2500usb_register_read_lock() ignores that status code and just
assumes the data is always initialized.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in rt2500usb_regbusy_read
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:116 [inline]
> BUG: KMSAN: uninit-value in rt2500usb_bbp_read+0x174/0x640
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
> CPU: 1 PID: 4943 Comm: kworker/1:2 Not tainted 5.1.0+ #1
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
>   __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
>   rt2500usb_regbusy_read drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1=
16
> [inline]
>   rt2500usb_bbp_read+0x174/0x640
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
>   rt2500usb_validate_eeprom
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1387 [inline]
>   rt2500usb_probe_hw+0x3b1/0x2230
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1764
>   rt2x00lib_probe_dev+0xb81/0x3090
> drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1427
>   rt2x00usb_probe+0x7c7/0xf70
> drivers/net/wireless/ralink/rt2x00/rt2x00usb.c:837
>   rt2500usb_probe+0x50/0x60
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1977
>   usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
>   really_probe+0xdae/0x1d80 drivers/base/dd.c:513
>   driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
>   __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
>   bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
>   __device_attach+0x454/0x730 drivers/base/dd.c:844
>   device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
>   bus_probe_device+0x137/0x390 drivers/base/bus.c:514
>   device_add+0x288d/0x30e0 drivers/base/core.c:2106
>   usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
>   generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
>   usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
>   really_probe+0xdae/0x1d80 drivers/base/dd.c:513
>   driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
>   __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
>   bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
>   __device_attach+0x454/0x730 drivers/base/dd.c:844
>   device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
>   bus_probe_device+0x137/0x390 drivers/base/bus.c:514
>   device_add+0x288d/0x30e0 drivers/base/core.c:2106
>   usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
>   process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
>   worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
>   kthread+0x4b5/0x4f0 kernel/kthread.c:254
>   ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355
>
> Local variable description: ----reg.i.i@rt2500usb_bbp_read
> Variable was created at:
>   rt2500usb_register_read_lock
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:72 [inline]
>   rt2500usb_regbusy_read drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1=
15
> [inline]
>   rt2500usb_bbp_read+0xa4/0x640
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:172
>   rt2500usb_validate_eeprom
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1387 [inline]
>   rt2500usb_probe_hw+0x3b1/0x2230
> drivers/net/wireless/ralink/rt2x00/rt2500usb.c:1764
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
