Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3D23F7D46
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbhHYUnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 16:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbhHYUnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 16:43:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF1EC061757;
        Wed, 25 Aug 2021 13:42:33 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so1034408ejz.1;
        Wed, 25 Aug 2021 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=dabBHAyYMNJrMunVHxQpPmbHkWUexAisLjuitLVnyCU=;
        b=drB8cHzFMpEkUIXSe30YWp8fzHrXOS5C6cuxuw6HmDy3VjLCNveuBDMaobh4xfXll5
         pQVH1TOjT7NGCgZKTMvrZQ2koMkZCJabc5w1rLFDqqxU1dowo1OEl2Wv58hm6/6uqC0a
         vAy3XIGQcJarzrRpY51YJkKURLSjMQ/JklrH8t6SNBlhXiPas3ZU/mtoIlVnPYCLK0PS
         VtZi4ChACDboM8f2K77PFuWvjxRAMAU9pYCxB7kTr5N/XgAGzwF5dSmjzrG52rCi1Nro
         A+R/muvVbIVWnEqD7dMjruetbuxHHSLwCzvbfiLpQQFhXsA9wqLFlc0+kdVt/0WpkWvY
         LxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=dabBHAyYMNJrMunVHxQpPmbHkWUexAisLjuitLVnyCU=;
        b=JTPy/qopbTXy1Zni6/T3ZkmC9IFbj46JzPmVGQNEjNLIoMCUtG5b2Fp2znv+q1sWmp
         b0ivqzQPgQ20Hq3maUxHaueJlmmT1WhuR0iwARCvW8GZ9D0jJKeb2H+A/xp6FDl6ioIz
         GZiU2ZjMRe/xq+Ifnvv9wkj2Z8psentXlBILVQvwhMJsOwwlvkA3LfabiIYO/OxNaZ4J
         XH4wHc+eNgK6wFSHVSgeNzH8tjh4rWENqRyCMZIFsiJEbw2ecwwz5CvDV3PRWuInLscA
         t/lkqUILYy/nJZIf0l9YiXcGwXJdF7PwVxAvdGgLriWJO5WfK5UeHzWR7jYOThnlXbkz
         HACA==
X-Gm-Message-State: AOAM532uqELOuhjpTYkVAB0mLs1oISoQf3OkvqnTg6PKR4ZcXkWcF2v6
        JTIC4Dbha1AYKXwRm5kwwssIh64moDg=
X-Google-Smtp-Source: ABdhPJw0s7s3hrC7CNamNGiQnz/WoJziS49ap6Sl0XBBpHQvfysiByi6MQVxm3zd6dIQjyS22swzlw==
X-Received: by 2002:a17:907:384:: with SMTP id ss4mr528779ejb.478.1629924152236;
        Wed, 25 Aug 2021 13:42:32 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:2090:c45b:fc0a:29b3? ([2001:981:6fec:1:2090:c45b:fc0a:29b3])
        by smtp.gmail.com with ESMTPSA id f30sm312558ejl.78.2021.08.25.13.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 13:42:31 -0700 (PDT)
To:     UNGLinuxDriver@microchip.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
From:   Ferry Toth <fntoth@gmail.com>
Subject: Crash on unplug smsc95xx on 5.14.0-rc6
Message-ID: <07628a9b-1370-98b7-c1f3-98b9bf8cc38f@gmail.com>
Date:   Wed, 25 Aug 2021 22:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With 5.14.0-rc6 smsc9504 attached to dwc3 host (Intel Merrifield) 
unplugging leads to the following stack trace:

kernel: kernfs: can not remove 'attached_dev', no directory
kernel: WARNING: CPU: 0 PID: 23 at fs/kernfs/dir.c:1508 
kernfs_remove_by_name_ns+0x7e/0x90
kernel: Modules linked in: rfcomm iptable_nat bnep snd_sof_nocodec 
spi_pxa2xx_platform dw_dmac smsc smsc95xx pwm_lpss_pci dw_dmac_pci 
pwm_lpss dw_dmac_core snd_sof_pc>
kernel: CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 
5.14.0-rc6-edison-acpi-standard #1
kernel: Hardware name: Intel Corporation Merrifield/BODEGA BAY, BIOS 542 
2015.01.21:18.19.48
kernel: Workqueue: usb_hub_wq hub_event
kernel: RIP: 0010:kernfs_remove_by_name_ns+0x7e/0x90
kernel: Code: ff 9a 00 31 c0 5d 41 5c 41 5d c3 48 c7 c7 e0 48 f6 b2 e8 
15 ff 9a 00 b8 fe ff ff ff eb e7 48 c7 c7 d0 fa a8 b2 e8 cb c6 94 00 
<0f> 0b b8 fe ff ff ff eb >
kernel: RSP: 0018:ffffa514000cfa10 EFLAGS: 00010282
kernel: RAX: 0000000000000000 RBX: ffff9a9008a3d8c0 RCX: ffff9a903e217478
kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9a903e217470
kernel: RBP: ffff9a90023d3000 R08: ffffffffb2f341c8 R09: 0000000000009ffb
kernel: R10: 00000000ffffe000 R11: 3fffffffffffffff R12: ffffffffb2af705d
kernel: R13: ffff9a9008a3d8c0 R14: ffffa514000cfb10 R15: 0000000000000003
kernel: FS:  0000000000000000(0000) GS:ffff9a903e200000(0000) 
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007fe6971fcca0 CR3: 0000000007b02000 CR4: 00000000001006f0
kernel: Call Trace:
kernel:  phy_detach+0x10b/0x170
kernel:  smsc95xx_disconnect_phy+0x2a/0x30 [smsc95xx]
kernel:  usbnet_stop+0x5d/0x130
kernel:  __dev_close_many+0x99/0x110
kernel:  dev_close_many+0x76/0x120
kernel:  unregister_netdevice_many+0x13d/0x750
kernel:  unregister_netdevice_queue+0x80/0xc0
kernel:  unregister_netdev+0x13/0x20
kernel:  usbnet_disconnect+0x54/0xb0
kernel:  usb_unbind_interface+0x85/0x270
kernel:  ? kernfs_find_ns+0x30/0xc0
kernel:  __device_release_driver+0x175/0x230
kernel:  device_release_driver+0x1f/0x30
kernel:  bus_remove_device+0xd3/0x140
kernel:  device_del+0x186/0x3e0
kernel:  ? kobject_put+0x91/0x1d0
kernel:  usb_disable_device+0xc1/0x1e0
kernel:  usb_disconnect.cold+0x7a/0x1f7
kernel:  usb_disconnect.cold+0x29/0x1f7
kernel:  hub_event+0xbb9/0x1830
kernel:  ? __switch_to_asm+0x42/0x70
kernel:  ? __switch_to_asm+0x36/0x70
kernel:  process_one_work+0x1cf/0x370
kernel:  worker_thread+0x48/0x3d0
kernel:  ? rescuer_thread+0x360/0x360
kernel:  kthread+0x122/0x140
kernel:  ? set_kthread_struct+0x40/0x40
kernel:  ret_from_fork+0x22/0x30

The unplug event happen when switching dwc3 from host  to device mode.

I'm not sure when this behavior started exactly, but al least since 
5.14.0-rc1.

Maybe related: smsc95xx plugin seems to trigger:

DMA-API: cacheline tracking EEXIST, overlapping mappings aren't supported


