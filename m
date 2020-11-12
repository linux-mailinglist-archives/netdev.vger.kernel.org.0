Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0CA2B02B3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgKLK3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKLK3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:29:24 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E39C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:29:24 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id p93so5542094edd.7
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=OGB+0eVlpKST7AEok2um0T6HWUbTJ5tet2/fOaUC+S8=;
        b=h6uy+pPYDVp/SWq1LKWYxLi1b3yy2Pi5q84zaAJ6ulfMWJuWXOrIS9p2s0vOh8GNoC
         d946wbLbYN4Yt4rBtj/be2ED2duKz7xK9dmixOaaWyddFSKpWnGOtWYWZywgPuBDn6tP
         foUbqL+OQU+cYvMsHVTVY4vkSzwyPig9j3+g/3AIZAbtDBfQa3G+fp880mpUth1tl4/Z
         caJ2wnuYE1SecS1itGV+On165a+YSa7MsXK5vrL16Bwn0orIqTT/JuHrv4KMNXm/5S1t
         iSmRk+bepT4Cm1yspnnuF0GKLwt9Igxvu7UsdtMmpAQkz0YB6efz+/9u1c17vfiMoPQN
         rGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=OGB+0eVlpKST7AEok2um0T6HWUbTJ5tet2/fOaUC+S8=;
        b=NHZyfv/6IRuuiXWVXYZ2qcDAO6ue975F16qWkZH8XsW2W8cXiVnQ37+k2pjH+6ofJL
         FEJVnrJsmgnpT3s2BABi4C7bDDGJodMvGYJ6tEcnx5Ss8E4OUjm5mGm6jVP/SabCyAIW
         MrEHcLIuwzXQWFwP2dCqt8UyAQFreU2v2syHokIwlRmwTYYJVNJx8siEYqXH3yCz9XgY
         WEZUVO2c9kRtdmS5kcpWk92Uu9ZaEf7zq+7ja8K2jQhx8DSNLGZOCaBRJnJSE/fLFHNw
         0ng5XH79N4CCPO1qA4IaOOku6/5TFQoUQhWy7nftlVtQGO9Zkz0NOI/Ep+3S2PA0VOPE
         MnMQ==
X-Gm-Message-State: AOAM531z+T9vqwYYge6yjBTBf2jJmCnyx+zBpaGw+0/9s6NZLenDMol2
        STPfivZoitxGo1rCfN6NJHjMO9F7uXxkZQ==
X-Google-Smtp-Source: ABdhPJwTZQPFtUlV7kiY5nambAITOiBuzestg3zHbNYJWNWUccKRuYrNGjpAzUll3PDBn42mATt24Q==
X-Received: by 2002:a50:9fc1:: with SMTP id c59mr4164480edf.59.1605176962080;
        Thu, 12 Nov 2020 02:29:22 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:c66:2555:ef54:fee? (p200300ea8f2328000c662555ef540fee.dip0.t-ipconnect.de. [2003:ea:8f23:2800:c66:2555:ef54:fee])
        by smtp.googlemail.com with ESMTPSA id cz14sm2133159edb.46.2020.11.12.02.29.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 02:29:21 -0800 (PST)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: WARNING: CPU: 2 PID: 2320 at net/core/stream.c:207
 sk_stream_kill_queues+0x10d/0x120
Message-ID: <f1d03519-97a3-9214-a2f0-9d17e34588d8@gmail.com>
Date:   Thu, 12 Nov 2020 11:29:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just got the following when running iperf3 on linux-next from yesterday.
Haven't seen this error before.


[   91.508431] ------------[ cut here ]------------
[   91.508642] WARNING: CPU: 2 PID: 2320 at net/core/stream.c:207 sk_stream_kill_queues+0x10d/0x120
[   91.508755] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class vfat fat x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd i915 glue_helper intel_gtt i2c_algo_bit r8169 drm_kms_helper snd_hda_intel snd_intel_dspcfg syscopyarea realtek sysfillrect snd_hda_codec sysimgblt mdio_devres fb_sys_fops libphy i2c_i801 snd_hda_core snd_pcm i2c_smbus snd_timer mei_me snd mei sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 ums_realtek serio_raw atkbd libps2 crc32c_intel ahci libahci libata i8042 serio
[   91.509764] CPU: 2 PID: 2320 Comm: iperf3 Not tainted 5.10.0-rc3-next-20201111+ #1
[   91.509861] Hardware name: NA ZBOX-CI327NANO-GS-01/ZBOX-CI327NANO-GS-01, BIOS 5.12 04/28/2020
[   91.509972] RIP: 0010:sk_stream_kill_queues+0x10d/0x120
[   91.510083] Code: 83 68 02 00 00 85 c0 75 21 85 f6 75 23 5b 41 5c 5d c3 48 89 df e8 f3 ef fe ff 8b 83 68 02 00 00 8b b3 20 02 00 00 85 c0 74 df <0f> 0b 85 f6 74 dd 0f 0b 5b 41 5c 5d c3 0f 0b eb a8 66 90 55 48 89
[   91.510304] RSP: 0000:ffff9baa80104ab0 EFLAGS: 00010282
[   91.510389] RAX: 00000000fffffe40 RBX: ffff9693ca293ac0 RCX: 0000000000000007
[   91.510480] RDX: 0000000000000020 RSI: 00000000000001c0 RDI: ffff9693ca293c10
[   91.510570] RBP: ffff9baa80104ac0 R08: 0000000000000000 R09: 0000000000000001
[   91.510661] R10: 0000000000000001 R11: 0000000000000046 R12: ffff9693ca293c10
[   91.510751] R13: 0000000000000000 R14: 0000000000000005 R15: 0000000000000065
[   91.510843] FS:  00007f8081d2f740(0000) GS:ffff96943bd00000(0000) knlGS:0000000000000000
[   91.510949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.511058] CR2: 00007f8081d2e000 CR3: 0000000103a42000 CR4: 00000000003506e0
[   91.511154] Call Trace:
[   91.511196]  <IRQ>
[   91.511238]  inet_csk_destroy_sock+0x5f/0x150
[   91.511303]  tcp_done+0xc5/0x130
[   91.511357]  tcp_time_wait+0x1b7/0x2d0
[   91.511414]  tcp_rcv_state_process+0x10f4/0x1130
[   91.511481]  ? sk_filter_trim_cap+0x154/0x350
[   91.511544]  tcp_v4_do_rcv+0xb9/0x1f0
[   91.511599]  tcp_v4_rcv+0xe1a/0xfd0
[   91.511655]  ip_protocol_deliver_rcu+0x2d/0x230
[   91.511720]  ip_local_deliver+0xd0/0x180
[   91.511779]  ip_sublist_rcv_finish+0x2d/0x80
[   91.511842]  ip_list_rcv_finish.constprop.0+0x119/0x160
[   91.511915]  ip_list_rcv+0xe9/0x110
[   91.511971]  __netif_receive_skb_list_core+0x223/0x250
[   91.512080]  netif_receive_skb_list_internal+0x1ce/0x380
[   91.512155]  ? dev_gro_receive+0x35c/0x810
[   91.512216]  napi_complete_done+0x75/0x1b0
[   91.512283]  rtl8169_poll+0x4ab/0x510 [r8169]
[   91.512347]  net_rx_action+0xed/0x430
[   91.512405]  __do_softirq+0xc1/0x454
[   91.512460]  asm_call_irq_on_stack+0x12/0x20
[   91.512520]  </IRQ>
[   91.512561]  do_softirq_own_stack+0x5c/0x70
[   91.512625]  irq_exit_rcu+0x9f/0xe0
[   91.512681]  sysvec_apic_timer_interrupt+0x4a/0xb0
[   91.512749]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[   91.512821]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   91.512891] RIP: 0033:0x7f808227cc8a
[   91.512947] Code: 0d 5b a4 11 00 0f 84 b5 f6 ff ff 48 8b 84 24 90 00 00 00 0f b6 18 80 fb 24 0f 84 58 f1 ff ff 8d 43 e0 3c 5a 0f 87 41 f1 ff ff <e9> fc fc ff ff 90 f3 0f 1e fa f6 44 24 48 01 0f 85 b9 12 00 00 44
[   91.513200] RSP: 002b:00007ffdf0129480 EFLAGS: 00000287
[   91.513280] RAX: 000000000000000e RBX: 000000000000002e RCX: 00007f80823fa37a
[   91.513371] RDX: 0000000000000000 RSI: 00007f808227bdcb RDI: 00007ffdf0129510
[   91.513461] RBP: 00007ffdf01299d0 R08: 00007f8082397040 R09: 00007f80823970c0
[   91.513552] R10: 00007f8082396fc0 R11: 0000000000000000 R12: 0000000000000000
[   91.513642] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdf0129b10
[   91.513734] irq event stamp: 14860380
[   91.513792] hardirqs last  enabled at (14860388): [<ffffffffb08d029b>] console_unlock+0x4db/0x5d0
[   91.513905] hardirqs last disabled at (14860395): [<ffffffffb08d020e>] console_unlock+0x44e/0x5d0
[   91.514051] softirqs last  enabled at (14859584): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.514171] softirqs last disabled at (14859587): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.514287] ---[ end trace c9c13e8bcc59c429 ]---
[   91.514372] ------------[ cut here ]------------
[   91.514441] WARNING: CPU: 2 PID: 2320 at net/core/stream.c:208 sk_stream_kill_queues+0x113/0x120
[   91.514553] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class vfat fat x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd i915 glue_helper intel_gtt i2c_algo_bit r8169 drm_kms_helper snd_hda_intel snd_intel_dspcfg syscopyarea realtek sysfillrect snd_hda_codec sysimgblt mdio_devres fb_sys_fops libphy i2c_i801 snd_hda_core snd_pcm i2c_smbus snd_timer mei_me snd mei sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 ums_realtek serio_raw atkbd libps2 crc32c_intel ahci libahci libata i8042 serio
[   91.515518] CPU: 2 PID: 2320 Comm: iperf3 Tainted: G        W         5.10.0-rc3-next-20201111+ #1
[   91.515632] Hardware name: NA ZBOX-CI327NANO-GS-01/ZBOX-CI327NANO-GS-01, BIOS 5.12 04/28/2020
[   91.515742] RIP: 0010:sk_stream_kill_queues+0x113/0x120
[   91.515815] Code: c0 75 21 85 f6 75 23 5b 41 5c 5d c3 48 89 df e8 f3 ef fe ff 8b 83 68 02 00 00 8b b3 20 02 00 00 85 c0 74 df 0f 0b 85 f6 74 dd <0f> 0b 5b 41 5c 5d c3 0f 0b eb a8 66 90 55 48 89 e5 41 56 41 55 41
[   91.516069] RSP: 0000:ffff9baa80104ab0 EFLAGS: 00010206
[   91.516148] RAX: 00000000fffffe40 RBX: ffff9693ca293ac0 RCX: 0000000000000007
[   91.516239] RDX: 0000000000000020 RSI: 00000000000001c0 RDI: ffff9693ca293c10
[   91.516329] RBP: ffff9baa80104ac0 R08: 0000000000000000 R09: 0000000000000001
[   91.516422] R10: 0000000000000001 R11: 0000000000000046 R12: ffff9693ca293c10
[   91.516513] R13: 0000000000000000 R14: 0000000000000005 R15: 0000000000000065
[   91.516607] FS:  00007f8081d2f740(0000) GS:ffff96943bd00000(0000) knlGS:0000000000000000
[   91.516712] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.516788] CR2: 00007f8081d2e000 CR3: 0000000103a42000 CR4: 00000000003506e0
[   91.516878] Call Trace:
[   91.516919]  <IRQ>
[   91.516958]  inet_csk_destroy_sock+0x5f/0x150
[   91.517056]  tcp_done+0xc5/0x130
[   91.517109]  tcp_time_wait+0x1b7/0x2d0
[   91.517165]  tcp_rcv_state_process+0x10f4/0x1130
[   91.517231]  ? sk_filter_trim_cap+0x154/0x350
[   91.517295]  tcp_v4_do_rcv+0xb9/0x1f0
[   91.517350]  tcp_v4_rcv+0xe1a/0xfd0
[   91.517405]  ip_protocol_deliver_rcu+0x2d/0x230
[   91.517473]  ip_local_deliver+0xd0/0x180
[   91.517532]  ip_sublist_rcv_finish+0x2d/0x80
[   91.517595]  ip_list_rcv_finish.constprop.0+0x119/0x160
[   91.517668]  ip_list_rcv+0xe9/0x110
[   91.517723]  __netif_receive_skb_list_core+0x223/0x250
[   91.517795]  netif_receive_skb_list_internal+0x1ce/0x380
[   91.517869]  ? dev_gro_receive+0x35c/0x810
[   91.517930]  napi_complete_done+0x75/0x1b0
[   91.517994]  rtl8169_poll+0x4ab/0x510 [r8169]
[   91.518093]  net_rx_action+0xed/0x430
[   91.518150]  __do_softirq+0xc1/0x454
[   91.518206]  asm_call_irq_on_stack+0x12/0x20
[   91.518266]  </IRQ>
[   91.518305]  do_softirq_own_stack+0x5c/0x70
[   91.518367]  irq_exit_rcu+0x9f/0xe0
[   91.518422]  sysvec_apic_timer_interrupt+0x4a/0xb0
[   91.518489]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[   91.518561]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   91.518633] RIP: 0033:0x7f808227cc8a
[   91.518688] Code: 0d 5b a4 11 00 0f 84 b5 f6 ff ff 48 8b 84 24 90 00 00 00 0f b6 18 80 fb 24 0f 84 58 f1 ff ff 8d 43 e0 3c 5a 0f 87 41 f1 ff ff <e9> fc fc ff ff 90 f3 0f 1e fa f6 44 24 48 01 0f 85 b9 12 00 00 44
[   91.518907] RSP: 002b:00007ffdf0129480 EFLAGS: 00000287
[   91.518985] RAX: 000000000000000e RBX: 000000000000002e RCX: 00007f80823fa37a
[   91.519108] RDX: 0000000000000000 RSI: 00007f808227bdcb RDI: 00007ffdf0129510
[   91.519203] RBP: 00007ffdf01299d0 R08: 00007f8082397040 R09: 00007f80823970c0
[   91.519294] R10: 00007f8082396fc0 R11: 0000000000000000 R12: 0000000000000000
[   91.519384] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdf0129b10
[   91.519476] irq event stamp: 14861192
[   91.519533] hardirqs last  enabled at (14861200): [<ffffffffb08d029b>] console_unlock+0x4db/0x5d0
[   91.519646] hardirqs last disabled at (14861207): [<ffffffffb08d020e>] console_unlock+0x44e/0x5d0
[   91.519759] softirqs last  enabled at (14859584): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.519877] softirqs last disabled at (14859587): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.519993] ---[ end trace c9c13e8bcc59c42a ]---
[   91.520117] ------------[ cut here ]------------
[   91.520236] WARNING: CPU: 2 PID: 2320 at net/ipv4/af_inet.c:156 inet_sock_destruct+0x1bf/0x1d0
[   91.520341] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class vfat fat x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd i915 glue_helper intel_gtt i2c_algo_bit r8169 drm_kms_helper snd_hda_intel snd_intel_dspcfg syscopyarea realtek sysfillrect snd_hda_codec sysimgblt mdio_devres fb_sys_fops libphy i2c_i801 snd_hda_core snd_pcm i2c_smbus snd_timer mei_me snd mei sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 ums_realtek serio_raw atkbd libps2 crc32c_intel ahci libahci libata i8042 serio
[   91.521247] CPU: 2 PID: 2320 Comm: iperf3 Tainted: G        W         5.10.0-rc3-next-20201111+ #1
[   91.521357] Hardware name: NA ZBOX-CI327NANO-GS-01/ZBOX-CI327NANO-GS-01, BIOS 5.12 04/28/2020
[   91.521462] RIP: 0010:inet_sock_destruct+0x1bf/0x1d0
[   91.521528] Code: e8 86 be ef ff e9 66 ff ff ff 0f 0b eb b9 0f 0b 41 8b 84 24 6c 02 00 00 85 c0 74 93 0f 0b 41 8b 94 24 68 02 00 00 85 d2 74 91 <0f> 0b eb 8d 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 55 48 89 e5 41
[   91.521735] RSP: 0000:ffff9baa80104b50 EFLAGS: 00010282
[   91.521808] RAX: 0000000000000000 RBX: ffff9693ca293c10 RCX: 0000000000000000
[   91.521895] RDX: 00000000fffffe40 RSI: 00000000000001c0 RDI: ffff9693ca293c10
[   91.521980] RBP: ffff9baa80104b60 R08: 0000000000000000 R09: 0000000000000001
[   91.522100] R10: 0000000000000001 R11: 0000000000000246 R12: ffff9693ca293ac0
[   91.522187] R13: ffff9693ca293f58 R14: ffff9693ca293ac0 R15: ffff9693ca293b48
[   91.522273] FS:  00007f8081d2f740(0000) GS:ffff96943bd00000(0000) knlGS:0000000000000000
[   91.522371] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.522443] CR2: 00007f8081d2e000 CR3: 0000000103a42000 CR4: 00000000003506e0
[   91.522528] Call Trace:
[   91.522567]  <IRQ>
[   91.522605]  __sk_destruct+0x26/0x1e0
[   91.522658]  __sk_free+0x6c/0x110
[   91.522707]  sk_free+0x21/0x40
[   91.522754]  sock_put+0x21/0x40
[   91.522801]  tcp_v4_rcv+0xe51/0xfd0
[   91.522854]  ip_protocol_deliver_rcu+0x2d/0x230
[   91.522917]  ip_local_deliver+0xd0/0x180
[   91.522973]  ip_sublist_rcv_finish+0x2d/0x80
[   91.523070]  ip_list_rcv_finish.constprop.0+0x119/0x160
[   91.523141]  ip_list_rcv+0xe9/0x110
[   91.523195]  __netif_receive_skb_list_core+0x223/0x250
[   91.523263]  netif_receive_skb_list_internal+0x1ce/0x380
[   91.523332]  ? dev_gro_receive+0x35c/0x810
[   91.523390]  napi_complete_done+0x75/0x1b0
[   91.523451]  rtl8169_poll+0x4ab/0x510 [r8169]
[   91.523512]  net_rx_action+0xed/0x430
[   91.523566]  __do_softirq+0xc1/0x454
[   91.523618]  asm_call_irq_on_stack+0x12/0x20
[   91.523675]  </IRQ>
[   91.523713]  do_softirq_own_stack+0x5c/0x70
[   91.523772]  irq_exit_rcu+0x9f/0xe0
[   91.523823]  sysvec_apic_timer_interrupt+0x4a/0xb0
[   91.523887]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[   91.523954]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   91.524055] RIP: 0033:0x7f808227cc8a
[   91.524109] Code: 0d 5b a4 11 00 0f 84 b5 f6 ff ff 48 8b 84 24 90 00 00 00 0f b6 18 80 fb 24 0f 84 58 f1 ff ff 8d 43 e0 3c 5a 0f 87 41 f1 ff ff <e9> fc fc ff ff 90 f3 0f 1e fa f6 44 24 48 01 0f 85 b9 12 00 00 44
[   91.524315] RSP: 002b:00007ffdf0129480 EFLAGS: 00000287
[   91.524388] RAX: 000000000000000e RBX: 000000000000002e RCX: 00007f80823fa37a
[   91.524476] RDX: 0000000000000000 RSI: 00007f808227bdcb RDI: 00007ffdf0129510
[   91.524562] RBP: 00007ffdf01299d0 R08: 00007f8082397040 R09: 00007f80823970c0
[   91.524647] R10: 00007f8082396fc0 R11: 0000000000000000 R12: 0000000000000000
[   91.524732] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdf0129b10
[   91.524818] irq event stamp: 14861994
[   91.524872] hardirqs last  enabled at (14862002): [<ffffffffb08d029b>] console_unlock+0x4db/0x5d0
[   91.524979] hardirqs last disabled at (14862009): [<ffffffffb08d020e>] console_unlock+0x44e/0x5d0
[   91.525122] softirqs last  enabled at (14859584): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.525235] softirqs last disabled at (14859587): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.525344] ---[ end trace c9c13e8bcc59c42b ]---
[   91.525432] ------------[ cut here ]------------
[   91.525496] WARNING: CPU: 2 PID: 2320 at net/ipv4/af_inet.c:157 inet_sock_destruct+0x19f/0x1d0
[   91.525598] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class vfat fat x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd i915 glue_helper intel_gtt i2c_algo_bit r8169 drm_kms_helper snd_hda_intel snd_intel_dspcfg syscopyarea realtek sysfillrect snd_hda_codec sysimgblt mdio_devres fb_sys_fops libphy i2c_i801 snd_hda_core snd_pcm i2c_smbus snd_timer mei_me snd mei sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 ums_realtek serio_raw atkbd libps2 crc32c_intel ahci libahci libata i8042 serio
[   91.526501] CPU: 2 PID: 2320 Comm: iperf3 Tainted: G        W         5.10.0-rc3-next-20201111+ #1
[   91.526611] Hardware name: NA ZBOX-CI327NANO-GS-01/ZBOX-CI327NANO-GS-01, BIOS 5.12 04/28/2020
[   91.526716] RIP: 0010:inet_sock_destruct+0x19f/0x1d0
[   91.526782] Code: bc 24 58 02 00 00 e8 90 9e f2 ff 49 8b bc 24 50 02 00 00 e8 83 9e f2 ff 5b 41 5c 5d c3 4c 89 e7 e8 86 be ef ff e9 66 ff ff ff <0f> 0b eb b9 0f 0b 41 8b 84 24 6c 02 00 00 85 c0 74 93 0f 0b 41 8b
[   91.526988] RSP: 0000:ffff9baa80104b50 EFLAGS: 00010206
[   91.527096] RAX: 00000000000001c0 RBX: ffff9693ca293c10 RCX: 0000000000000000
[   91.527183] RDX: 00000000fffffe40 RSI: 00000000000001c0 RDI: ffff9693ca293c10
[   91.527272] RBP: ffff9baa80104b60 R08: 0000000000000000 R09: 0000000000000001
[   91.527357] R10: 0000000000000001 R11: 0000000000000246 R12: ffff9693ca293ac0
[   91.527443] R13: ffff9693ca293f58 R14: ffff9693ca293ac0 R15: ffff9693ca293b48
[   91.527532] FS:  00007f8081d2f740(0000) GS:ffff96943bd00000(0000) knlGS:0000000000000000
[   91.527629] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.527702] CR2: 00007f8081d2e000 CR3: 0000000103a42000 CR4: 00000000003506e0
[   91.527786] Call Trace:
[   91.527825]  <IRQ>
[   91.527863]  __sk_destruct+0x26/0x1e0
[   91.527916]  __sk_free+0x6c/0x110
[   91.527967]  sk_free+0x21/0x40
[   91.528048]  sock_put+0x21/0x40
[   91.528097]  tcp_v4_rcv+0xe51/0xfd0
[   91.528150]  ip_protocol_deliver_rcu+0x2d/0x230
[   91.528212]  ip_local_deliver+0xd0/0x180
[   91.528268]  ip_sublist_rcv_finish+0x2d/0x80
[   91.528327]  ip_list_rcv_finish.constprop.0+0x119/0x160
[   91.528396]  ip_list_rcv+0xe9/0x110
[   91.528448]  __netif_receive_skb_list_core+0x223/0x250
[   91.528516]  netif_receive_skb_list_internal+0x1ce/0x380
[   91.528586]  ? dev_gro_receive+0x35c/0x810
[   91.528643]  napi_complete_done+0x75/0x1b0
[   91.528705]  rtl8169_poll+0x4ab/0x510 [r8169]
[   91.528768]  net_rx_action+0xed/0x430
[   91.528821]  __do_softirq+0xc1/0x454
[   91.528873]  asm_call_irq_on_stack+0x12/0x20
[   91.528934]  </IRQ>
[   91.528971]  do_softirq_own_stack+0x5c/0x70
[   91.529074]  irq_exit_rcu+0x9f/0xe0
[   91.529145]  sysvec_apic_timer_interrupt+0x4a/0xb0
[   91.529204]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[   91.529267]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[   91.529332] RIP: 0033:0x7f808227cc8a
[   91.529380] Code: 0d 5b a4 11 00 0f 84 b5 f6 ff ff 48 8b 84 24 90 00 00 00 0f b6 18 80 fb 24 0f 84 58 f1 ff ff 8d 43 e0 3c 5a 0f 87 41 f1 ff ff <e9> fc fc ff ff 90 f3 0f 1e fa f6 44 24 48 01 0f 85 b9 12 00 00 44
[   91.529570] RSP: 002b:00007ffdf0129480 EFLAGS: 00000287
[   91.529638] RAX: 000000000000000e RBX: 000000000000002e RCX: 00007f80823fa37a
[   91.529717] RDX: 0000000000000000 RSI: 00007f808227bdcb RDI: 00007ffdf0129510
[   91.529797] RBP: 00007ffdf01299d0 R08: 00007f8082397040 R09: 00007f80823970c0
[   91.529875] R10: 00007f8082396fc0 R11: 0000000000000000 R12: 0000000000000000
[   91.529955] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdf0129b10
[   91.530066] irq event stamp: 14862796
[   91.530116] hardirqs last  enabled at (14862804): [<ffffffffb08d029b>] console_unlock+0x4db/0x5d0
[   91.530215] hardirqs last disabled at (14862811): [<ffffffffb08d020e>] console_unlock+0x44e/0x5d0
[   91.530314] softirqs last  enabled at (14859584): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.530417] softirqs last disabled at (14859587): [<ffffffffb1000f12>] asm_call_irq_on_stack+0x12/0x20
[   91.530517] ---[ end trace c9c13e8bcc59c42c ]---
