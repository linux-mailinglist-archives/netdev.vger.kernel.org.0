Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40173FA199
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 00:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhH0Wm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 18:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhH0Wm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 18:42:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C390FC0613D9;
        Fri, 27 Aug 2021 15:41:36 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so11975225edt.5;
        Fri, 27 Aug 2021 15:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZze2kXw1GqozYBFIt5cZT7bkr7jV4DexjrT5UOwl5w=;
        b=WYqYIPpRr7hz1zsAqib1Su0/B8OPv5AG/9e+IL12N501J/tNnWMGZQBx3+KJzoV3dg
         JZypnCcfvTKm3Ns0I/Wkhg0AK4f5iPmDxFNno0Yljq1M1HcxdXYNbvgWrZthfIBppwyz
         Fz8ReHpAftQ1seaB9ZoXHHJ/sbHlswCBr+tgzSx4YrCOV8svmbIcLN1IRV/qdFTIieze
         uw3wiKNbPBYCOpufathlzW3KhdHHxNBn8VrdV2kNXMA1H6i+XpjcoWQtHFNC69vBibCY
         r8e7IvHzsTAdQCWvg8vjyLj6lCi13l3Bch0ownjgLB+/gTgCV2TKeG8tpCeydsKJGDwj
         9l0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZze2kXw1GqozYBFIt5cZT7bkr7jV4DexjrT5UOwl5w=;
        b=nn0DeN2g3TO9fh0QR1VNFZQCq/mKYnO4UdWqOVgzTQyRpP5sKoB5rppJE2M9R1vVs9
         CVDvoe14ajdUThOP2sBEypd9Z2FOQEUErzONAq5cSyHhKTqIdEoN+8z/if3XByWIltRJ
         46c9SopKEqlpd13JkQJm80DPlfAP5NNs0OMRfh7LefAfeOjsjd8kM8Y31bU1e5DAV2Ri
         NZoBeiM7u+sszV8vxYqnhf9hmwbrkaJRsEBEMf/uJkVSY/lZ+s2+9UmH8Y7eoT/Ho2hQ
         y/Wv3PddPDb5Kj5H26mozIbCv3j3/VSEbMRBO6/cv6JsQmripG1sxCZYtzTNFITjlBuU
         jwuQ==
X-Gm-Message-State: AOAM532udhwLcuLgvooY9zJSzT+zJHjJ4kwnBiwgP/W30p3bz4j7c6jp
        jZjcRlVBy3N6kBbKidTcUMjdOkpv5nU=
X-Google-Smtp-Source: ABdhPJyfEfKqRfYPyu4DoVykgTYH+zSrQKn5x1Ok7dfHZHfLY+QvSkBL10YccOyIV7IFI5MaleksTw==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr12153412edb.268.1630104095356;
        Fri, 27 Aug 2021 15:41:35 -0700 (PDT)
Received: from ?IPv6:2001:981:6fec:1:c857:3b83:8809:ffc9? ([2001:981:6fec:1:c857:3b83:8809:ffc9])
        by smtp.gmail.com with ESMTPSA id kw10sm3394920ejc.111.2021.08.27.15.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 15:41:34 -0700 (PDT)
Subject: Re: Crash on unplug smsc95xx on 5.14.0-rc6
From:   Ferry Toth <fntoth@gmail.com>
To:     UNGLinuxDriver@microchip.com
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        stern@rowland.harvard.edu
References: <07628a9b-1370-98b7-c1f3-98b9bf8cc38f@gmail.com>
Message-ID: <529eae08-397f-13c8-833f-ee04275e5470@gmail.com>
Date:   Sat, 28 Aug 2021 00:41:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <07628a9b-1370-98b7-c1f3-98b9bf8cc38f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

Op 25-08-2021 om 22:42 schreef Ferry Toth:
> With 5.14.0-rc6 smsc9504 attached to dwc3 host (Intel Merrifield) 
> unplugging leads to the following stack trace:
> 
> kernel: kernfs: can not remove 'attached_dev', no directory
> kernel: WARNING: CPU: 0 PID: 23 at fs/kernfs/dir.c:1508 
> kernfs_remove_by_name_ns+0x7e/0x90
> kernel: Modules linked in: rfcomm iptable_nat bnep snd_sof_nocodec 
> spi_pxa2xx_platform dw_dmac smsc smsc95xx pwm_lpss_pci dw_dmac_pci 
> pwm_lpss dw_dmac_core snd_sof_pc>
> kernel: CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 
> 5.14.0-rc6-edison-acpi-standard #1
> kernel: Hardware name: Intel Corporation Merrifield/BODEGA BAY, BIOS 542 
> 2015.01.21:18.19.48
> kernel: Workqueue: usb_hub_wq hub_event
> kernel: RIP: 0010:kernfs_remove_by_name_ns+0x7e/0x90
> kernel: Code: ff 9a 00 31 c0 5d 41 5c 41 5d c3 48 c7 c7 e0 48 f6 b2 e8 
> 15 ff 9a 00 b8 fe ff ff ff eb e7 48 c7 c7 d0 fa a8 b2 e8 cb c6 94 00 
> <0f> 0b b8 fe ff ff ff eb >
> kernel: RSP: 0018:ffffa514000cfa10 EFLAGS: 00010282
> kernel: RAX: 0000000000000000 RBX: ffff9a9008a3d8c0 RCX: ffff9a903e217478
> kernel: RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9a903e217470
> kernel: RBP: ffff9a90023d3000 R08: ffffffffb2f341c8 R09: 0000000000009ffb
> kernel: R10: 00000000ffffe000 R11: 3fffffffffffffff R12: ffffffffb2af705d
> kernel: R13: ffff9a9008a3d8c0 R14: ffffa514000cfb10 R15: 0000000000000003
> kernel: FS:  0000000000000000(0000) GS:ffff9a903e200000(0000) 
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 00007fe6971fcca0 CR3: 0000000007b02000 CR4: 00000000001006f0
> kernel: Call Trace:
> kernel:  phy_detach+0x10b/0x170
> kernel:  smsc95xx_disconnect_phy+0x2a/0x30 [smsc95xx]
> kernel:  usbnet_stop+0x5d/0x130
> kernel:  __dev_close_many+0x99/0x110
> kernel:  dev_close_many+0x76/0x120
> kernel:  unregister_netdevice_many+0x13d/0x750
> kernel:  unregister_netdevice_queue+0x80/0xc0
> kernel:  unregister_netdev+0x13/0x20
> kernel:  usbnet_disconnect+0x54/0xb0
> kernel:  usb_unbind_interface+0x85/0x270
> kernel:  ? kernfs_find_ns+0x30/0xc0
> kernel:  __device_release_driver+0x175/0x230
> kernel:  device_release_driver+0x1f/0x30
> kernel:  bus_remove_device+0xd3/0x140
> kernel:  device_del+0x186/0x3e0
> kernel:  ? kobject_put+0x91/0x1d0
> kernel:  usb_disable_device+0xc1/0x1e0
> kernel:  usb_disconnect.cold+0x7a/0x1f7
> kernel:  usb_disconnect.cold+0x29/0x1f7
> kernel:  hub_event+0xbb9/0x1830
> kernel:  ? __switch_to_asm+0x42/0x70
> kernel:  ? __switch_to_asm+0x36/0x70
> kernel:  process_one_work+0x1cf/0x370
> kernel:  worker_thread+0x48/0x3d0
> kernel:  ? rescuer_thread+0x360/0x360
> kernel:  kthread+0x122/0x140
> kernel:  ? set_kthread_struct+0x40/0x40
> kernel:  ret_from_fork+0x22/0x30
> 
> The unplug event happen when switching dwc3 from host  to device mode.
> 
> I'm not sure when this behavior started exactly, but al least since 
> 5.14.0-rc1.

Ideas how to continue welcome.

> Maybe related: smsc95xx plugin seems to trigger:
> 
> DMA-API: cacheline tracking EEXIST, overlapping mappings aren't supported
> 
OTOH the cache line error might be due to reporting the error is 
relatively new:
https://lore.kernel.org/lkml/20210518125443.34148-1-someguy@effective-light.com/

So maybe unrelated to crash.
