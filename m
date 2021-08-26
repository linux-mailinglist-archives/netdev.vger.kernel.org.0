Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E683F8F2B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243606AbhHZTs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbhHZTs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:48:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45356C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:48:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b6so6770359wrh.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dMDFVnjoFtKuliCaT9z36pJ6LfmG3Y44Dky0mkGS32s=;
        b=C9g8lT2y/fE8BDwIYO7CwZ1wmrJepmm/ArIdyxBdgQVSz5HLP0hCvwKE3F5i1Y85Dy
         8FHv0KX4ptNoOcUNtzCtnVKrIysmrL4QEU2slsLUeuFMqV2BfKS4mE4EjCOZM2dRp6Kb
         J6/eH6xJd9/lry2pfisWmG++60+rcGnnoysecpHgpZGc9cmv3aQE8L6wqbyusT3zobiz
         KJppZB9WA2JVQtEE4d44GjAMUZ88GJY0sD7b3V+dM25OpSylPoD3Si5JXiujuJ9zNcqd
         5uVMOMA6sHEXtyADG7k7ODQe132k+1zuJVTWTE0ieiCOy5cStZjwGlbKLDnJ3aO9OBlg
         H7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dMDFVnjoFtKuliCaT9z36pJ6LfmG3Y44Dky0mkGS32s=;
        b=IcuY3ALiv4Np9FCPlCcowWPd1T+LIDF9zVHi5QnP8uCyYMCHD1EAlAw+5a9pn3sqma
         jd1Fv7ZPG059OzHpSHWw2yiCP4yMwXAFdcElCaWwgvrO7/IOuQc4f+WnLMbOUmHfTMSY
         lxat5Ugu3d+2asxmMzupuOIO5cmtwZugcV6Jtt+WatEhlkt4x8DrMg4BwKy12m3nQptm
         dTWwdPY+dI1Yi2UcLqAGWexXykakddsB5bEgLGHa3KHf8wK0g2Yoa6uHqfngVf4irEte
         PKgdxPeYVA60YTzQcq4IQwvSyW+qhxSO6zlp2FUbyCOUhzMwTPU0At2aNzT7WeUV0JGl
         Q6dw==
X-Gm-Message-State: AOAM5301XJJYhpX+urmETUvOqC5Sf3xBTcGGSD2MSgPeHfK36FTUuP51
        NP5qn4mja56DI2u6OnW4Ht+9eaqXCUJdvQ==
X-Google-Smtp-Source: ABdhPJxEacnzFvwVFE9Ccq8bIh5ScxTkcPHIHp7W/cS8Qz3d3KW831LmGU3oqJbRzhj35AP6XfNJQQ==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr5933982wrp.381.1630007286643;
        Thu, 26 Aug 2021 12:48:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2? (p200300ea8f084500b5d8a3dcf88fcae2.dip0.t-ipconnect.de. [2003:ea:8f08:4500:b5d8:a3dc:f88f:cae2])
        by smtp.googlemail.com with ESMTPSA id x18sm4149363wrw.19.2021.08.26.12.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 12:48:06 -0700 (PDT)
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: cxgb3: error when removing driver module
Message-ID: <fafb7c49-45e7-8096-45fd-e4b7984d7b06@gmail.com>
Date:   Thu, 26 Aug 2021 21:47:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the driver module w/o bringing an interface up
before then the error below occurs. Reason seems to be that
cancel_work_sync() is called in t3_sge_stop() for a queue
that hasn't been initialized yet.

Root cause may be 5e0b8928927f ("net:cxgb3: replace tasklets with works").

[10085.941785] ------------[ cut here ]------------
[10085.941799] WARNING: CPU: 1 PID: 5850 at kernel/workqueue.c:3074 __flush_work+0x3ff/0x480
[10085.941819] Modules linked in: vfat snd_hda_codec_hdmi fat snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class ee1004 iTCO_
wdt intel_tcc_cooling x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core r
8169 snd_pcm realtek mdio_devres snd_timer snd i2c_i801 i2c_smbus libphy i915 i2c_algo_bit cxgb3(-) intel_gtt ttm mdio drm_kms_helper mei_me s
yscopyarea sysfillrect sysimgblt mei fb_sys_fops acpi_pad sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 crc32c_intel
[10085.941944] CPU: 1 PID: 5850 Comm: rmmod Not tainted 5.14.0-rc7-next-20210826+ #6
[10085.941974] Hardware name: System manufacturer System Product Name/PRIME H310I-PLUS, BIOS 2603 10/21/2019
[10085.941992] RIP: 0010:__flush_work+0x3ff/0x480
[10085.942003] Code: c0 74 6b 65 ff 0d d1 bd 78 75 e8 bc 2f 06 00 48 c7 c6 68 b1 88 8a 48 c7 c7 e0 5f b4 8b 45 31 ff e8 e6 66 04 00 e9 4b fe ff ff <0f> 0b 45 31 ff e9 41 fe ff ff e8 72 c1 79 00 85 c0 74 87 80 3d 22
[10085.942036] RSP: 0018:ffffa1744383fc08 EFLAGS: 00010246
[10085.942048] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000923
[10085.942062] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff91c901710a88
[10085.942076] RBP: ffffa1744383fce8 R08: 0000000000000001 R09: 0000000000000001
[10085.942090] R10: 00000000000000c2 R11: 0000000000000000 R12: ffff91c901710a88
[10085.942104] R13: 0000000000000000 R14: ffff91c909a96100 R15: 0000000000000001
[10085.942118] FS:  00007fe417837740(0000) GS:ffff91c969d00000(0000) knlGS:0000000000000000
[10085.942134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10085.942146] CR2: 000055a8d567ecd8 CR3: 0000000121690003 CR4: 00000000003706e0
[10085.942160] Call Trace:
[10085.942166]  ? __lock_acquire+0x3af/0x22e0
[10085.942177]  ? cancel_work_sync+0xb/0x10
[10085.942187]  __cancel_work_timer+0x128/0x1b0
[10085.942197]  ? __pm_runtime_resume+0x5b/0x90
[10085.942208]  cancel_work_sync+0xb/0x10
[10085.942217]  t3_sge_stop+0x2f/0x50 [cxgb3]
[10085.942234]  remove_one+0x26/0x190 [cxgb3]
[10085.942248]  pci_device_remove+0x39/0xa0
[10085.942258]  __device_release_driver+0x15e/0x240
[10085.942269]  driver_detach+0xd9/0x120
[10085.942278]  bus_remove_driver+0x53/0xd0
[10085.942288]  driver_unregister+0x2c/0x50
[10085.942298]  pci_unregister_driver+0x31/0x90
[10085.942307]  cxgb3_cleanup_module+0x10/0x18c [cxgb3]
[10085.942324]  __do_sys_delete_module+0x191/0x250
[10085.942336]  ? syscall_enter_from_user_mode+0x21/0x60
[10085.942347]  ? trace_hardirqs_on+0x2a/0xe0
[10085.942357]  __x64_sys_delete_module+0x13/0x20
[10085.942368]  do_syscall_64+0x40/0x90
[10085.942377]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10085.942389] RIP: 0033:0x7fe41796323b
