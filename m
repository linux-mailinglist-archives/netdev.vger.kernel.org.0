Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54D45A5E07
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 10:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiH3I1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 04:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiH3I1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 04:27:15 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEF2A2D8E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 01:27:14 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-33dc345ad78so255191417b3.3
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=qP76g331Mn+G1UGQAFYJHIuAxM6OJvcEkogUmZEGdRw=;
        b=ABanFcH/gUEytycehKlipSkpajI7IMsR5uGtjoxb/zC1I3B07GB4QBDLEctaB6UCTI
         tRlRM4BGCLHs4xca5Oq0By5MLD2lVJs9dN+kpSjYkx4g4IQM/kP8DJGoMxYWBHKlxPud
         NDFyv/JP/7zuxR9vVMUCKS2KnGEL1/TPXUGPwMAb0dlzSP9dXPGYOHRGP5sTwAnOajoh
         L4C6wc81ZAA5hwBke6EQKo8tuXnUnOz7RoDwVmr7niRfBTNNe6H3nDxEUW+qe36VUKRw
         Fq7R8EDC4xr2m6Srw9C41/YPTGRtMX4vqBqHM5nacNzqugh9jBhfPIDXXYz4PU0xLDvo
         5/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=qP76g331Mn+G1UGQAFYJHIuAxM6OJvcEkogUmZEGdRw=;
        b=eidagyx9trA+AQ7833Me93ox7Xifro9MfmGdngAp2kjA7WFYoByqB3M82ZdFefNq/E
         YcNfEzsmeWxJ2YHKMyg3f8XvD5WO7eReJOixM82lSFGdspK4NOjP07M78umRL9myl9Lt
         3iZfzjzQhckaxGrCwxhNXCtYtx1hxERAbJRYz78lhFWfI6Zgf/SobGNkoaOLPTi8RLrG
         6XxaqAIPBFQB4l3fxyXgW1EJB8O0Ug1CfZ3pLBEt2RfMH9H7rPoMkUaqWMZMBNiHg03j
         zuZ8E3vRutIs2FSt/FfNtD9zOEmkmmJOEBIvxV1+Z/pGvxBt/HHeGyqonr8I8rjj4cbo
         87kw==
X-Gm-Message-State: ACgBeo3VDNGDJFHD5KiakvWVdcaB1LX+7EKIqp6dfqJOboBXuLKXO0/T
        lYYf1bTjemt4Y27bOKzdP+/ayRPA0JiTJJPZjubfVA==
X-Google-Smtp-Source: AA6agR5S4rNJ2NTIdmsPR1IfCAg+TNtONHLUEv8d0PffhiWeLtfcMLmgOuWE4mL4Vd/Lirg3PEYOPJ+eP6Gz/oZs1jU=
X-Received: by 2002:a5b:18d:0:b0:695:a9d7:44b5 with SMTP id
 r13-20020a5b018d000000b00695a9d744b5mr10696014ybl.549.1661848033082; Tue, 30
 Aug 2022 01:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f71859058a7cfdc8@google.com> <b15ccfc3-4b86-4a6c-b72c-880963d842f6n@googlegroups.com>
In-Reply-To: <b15ccfc3-4b86-4a6c-b72c-880963d842f6n@googlegroups.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 30 Aug 2022 10:26:36 +0200
Message-ID: <CAG_fn=XTM+GDFn0K6Za7eAdOhhodLWx+1GYF33W7sYV6QyUUiA@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in mii_nway_restart
To:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        David Miller <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding the original recipients back)

On Fri, Aug 26, 2022 at 10:44 AM Alexander Potapenko <glider@google.com> wr=
ote:
>
>
>
> On Tuesday, June 4, 2019 at 12:32:05 PM UTC+2 syzbot wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit: f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
>> git tree: kmsan
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1180360ea000=
00
>> kernel config: https://syzkaller.appspot.com/x/.config?x=3D602468164ccdc=
30a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D1f53a30781af65=
d2c955
>> compiler: clang version 9.0.0 (/home/glider/llvm/clang
>> 06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=3D16a2b4f2a00000
>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=3D107f4e86a00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commi=
t:
>> Reported-by: syzbot+1f53a3...@syzkaller.appspotmail.com
>>
>> ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to
>> write reg index 0x000d: -71
>> ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to
>> write reg index 0x000e: -71
>> ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to
>> write reg index 0x000d: -71
>> ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to
>> write reg index 0x000e: -71
>> ax88179_178a 1-1:0.186 (unnamed net_device) (uninitialized): Failed to r=
ead
>> reg index 0x0000: -71
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KMSAN: uninit-value in mii_nway_restart+0x141/0x260
>> drivers/net/mii.c:467
>> CPU: 1 PID: 3353 Comm: kworker/1:2 Not tainted 5.1.0+ #1
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Workqueue: usb_hub_wq hub_event
>> Call Trace:
>> __dump_stack lib/dump_stack.c:77 [inline]
>> dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>> kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
>> __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
>> mii_nway_restart+0x141/0x260 drivers/net/mii.c:467
>> ax88179_bind+0xee3/0x1a10 drivers/net/usb/ax88179_178a.c:1329
>> usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
>> usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
>> really_probe+0xdae/0x1d80 drivers/base/dd.c:513
>> driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
>> __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
>> bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
>> __device_attach+0x454/0x730 drivers/base/dd.c:844
>> device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
>> bus_probe_device+0x137/0x390 drivers/base/bus.c:514
>> device_add+0x288d/0x30e0 drivers/base/core.c:2106
>> usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
>> generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
>> usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
>> really_probe+0xdae/0x1d80 drivers/base/dd.c:513
>> driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
>> __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
>> bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
>> __device_attach+0x454/0x730 drivers/base/dd.c:844
>> device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
>> bus_probe_device+0x137/0x390 drivers/base/bus.c:514
>> device_add+0x288d/0x30e0 drivers/base/core.c:2106
>> usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
>> hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>> hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>> port_event drivers/usb/core/hub.c:5350 [inline]
>> hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
>> process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
>> worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
>> kthread+0x4b5/0x4f0 kernel/kthread.c:254
>> ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355
>>
>> Local variable description: ----buf.i@ax88179_mdio_read
>> Variable was created at:
>> __ax88179_read_cmd drivers/net/usb/ax88179_178a.c:199 [inline]
>> ax88179_read_cmd drivers/net/usb/ax88179_178a.c:311 [inline]
>> ax88179_mdio_read+0x7b/0x240 drivers/net/usb/ax88179_178a.c:369
>> mii_nway_restart+0xcf/0x260 drivers/net/mii.c:465
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>
>>
>>
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzk...@googlegroups.com.
>>
>> syzbot will keep track of this bug report. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this bug, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>
>
> This bug is still triggerable by KMSAN (https://syzkaller.appspot.com/bug=
?id=3D835562bfa4dd92c72f323f29ad388c9cb4b0e63f):
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in mii_nway_restart+0x117/0x1d0 drivers/net/mii.=
c:465
>  mii_nway_restart+0x117/0x1d0 drivers/net/mii.c:465
>  dm9601_bind+0xa17/0xb50 drivers/net/usb/dm9601.c:431
>  usbnet_probe+0xebb/0x3cc0 drivers/net/usb/usbnet.c:1747
>  usb_probe_interface+0xc4b/0x11f0 drivers/usb/core/driver.c:396
>  really_probe+0x499/0xf50 drivers/base/dd.c:634
>  __driver_probe_device+0x2fa/0x3d0 drivers/base/dd.c:764
>  driver_probe_device+0x72/0x7a0 drivers/base/dd.c:794
>  __device_attach_driver+0x6f1/0x890 drivers/base/dd.c:917
>  bus_for_each_drv+0x1fc/0x360 drivers/base/bus.c:427
>  __device_attach+0x42a/0x720 drivers/base/dd.c:989
>  device_initial_probe+0x2e/0x40 drivers/base/dd.c:1038
>  bus_probe_device+0x13c/0x3b0 drivers/base/bus.c:487
>  device_add+0x1d4b/0x26c0 drivers/base/core.c:3428
>  usb_set_configuration+0x30f8/0x37e0 drivers/usb/core/message.c:2170
>  usb_generic_driver_probe+0x105/0x290 drivers/usb/core/generic.c:238
>  usb_probe_device+0x288/0x490 drivers/usb/core/driver.c:293
>  really_probe+0x499/0xf50 drivers/base/dd.c:634
>  __driver_probe_device+0x2fa/0x3d0 drivers/base/dd.c:764
>  driver_probe_device+0x72/0x7a0 drivers/base/dd.c:794
>  __device_attach_driver+0x6f1/0x890 drivers/base/dd.c:917
>  bus_for_each_drv+0x1fc/0x360 drivers/base/bus.c:427
>  __device_attach+0x42a/0x720 drivers/base/dd.c:989
>  device_initial_probe+0x2e/0x40 drivers/base/dd.c:1038
>  bus_probe_device+0x13c/0x3b0 drivers/base/bus.c:487
>  device_add+0x1d4b/0x26c0 drivers/base/core.c:3428
>  usb_new_device+0x17a1/0x2360 drivers/usb/core/hub.c:2566
>  hub_port_connect drivers/usb/core/hub.c:5363 [inline]
>  hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
>  port_event drivers/usb/core/hub.c:5663 [inline]
>  hub_event+0x5559/0x8050 drivers/usb/core/hub.c:5745
>  process_one_work+0xb27/0x13e0 kernel/workqueue.c:2289
>  worker_thread+0x1076/0x1d60 kernel/workqueue.c:2436
>  kthread+0x31b/0x430 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30
>
> Local variable res created at:
>  dm9601_mdio_read+0x49/0xf0 drivers/net/usb/dm9601.c:226
>  mii_nway_restart+0x84/0x1d0 drivers/net/mii.c:463
>
> CPU: 0 PID: 28 Comm: kworker/0:1 Not tainted 5.19.0-syzkaller-32655-g1b07=
0a5d1a2c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/22/2022
> Workqueue: usb_hub_wq hub_event
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> I believe we should either be always checking the return value of dm_read=
_shared_word(), or make it unconditionally initialize *value.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
