Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EE02C1B2B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 03:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgKXCCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 21:02:02 -0500
Received: from mail-m973.mail.163.com ([123.126.97.3]:59922 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgKXCCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 21:02:01 -0500
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 21:01:58 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=6r91/
        gblPlfY3VjpDG0v/gGBK+gnmvk0PnBPhavBt2k=; b=efGMrdeO+z5SZUZ3wlaDx
        leogD40yBeaidFWdLsp7dC4tuN9ERvVmf4YWygqaUT/LrG5xo36nASCj/aznRTjG
        hxKClBoQC7VXohO68nKKlSUu1FAa7uRsyOufBRUB3zYy+6zSsXX+C/KDp3XI0mNL
        dH9EnymuQbfV83NKl6WXfU=
Received: from [172.20.6.128] (unknown [113.57.95.61])
        by smtp3 (Coremail) with SMTP id G9xpCgBH1M3xZbxffEocMw--.27721S2;
        Tue, 24 Nov 2020 09:46:25 +0800 (CST)
Subject: Re: [PATCH v2] brmcfmac: fix compile when DEBUG is defined
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201122100606.20289-1-hby2003@163.com>
 <87r1okqd2n.fsf@codeaurora.org>
From:   hby <hby2003@163.com>
Message-ID: <c3b297cf-268e-6f28-f585-5452dd8696f8@163.com>
Date:   Tue, 24 Nov 2020 09:46:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <87r1okqd2n.fsf@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgBH1M3xZbxffEocMw--.27721S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw17Cr13Zw13KF4xuw43Awb_yoW5ZF1fpw
        srGa4qyry8u3yakay8JF9rAF1rKas7Gw1qkay8Zw13WFykAw1Fqr40gFyrCr109FWxJ3y7
        JFy0qr9xJFW7K3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j6XdUUUUUU=
X-Originating-IP: [113.57.95.61]
X-CM-SenderInfo: hke1jiiqt6il2tof0z/1tbiVBHmHFUMO8dmfgAAsC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry for the HTML email, and I change the email client. The patch 
update.

 From b87d429158b4efc3f6835828f495a261e17d5af4 Mon Sep 17 00:00:00 2001
From: hby <hby2003@163.com>
Date: Tue, 24 Nov 2020 09:16:24 +0800
Subject: [PATCH] brmcfmac: fix compile when DEBUG is defined

The steps:
1. add "#define DEBUG" in 
drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c line 61.
2. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux 
bcm2835_defconfig
3. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux/ 
zImage modules dtbs -j8

Then, it will fail, the compile log described below:

Kernel: arch/arm/boot/zImage is ready
MODPOST Module.symvers
ERROR: modpost: "brcmf_debugfs_add_entry" 
[drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
ERROR: modpost: "brcmf_debugfs_get_devdir" 
[drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
ERROR: modpost: "__brcmf_dbg" 
[drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
scripts/Makefile.modpost:111: recipe for target 'Module.symvers' failed
make[2]: *** [Module.symvers] Error 1
make[2]: *** Deleting file 'Module.symvers'
Makefile:1390: recipe for target 'modules' failed
make[1]: *** [modules] Error 2
make[1]: Leaving directory '/home/hby/gitee/linux_origin/Out_Linux'
Makefile:185: recipe for target '__sub-make' failed
make: *** [__sub-make] Error 2

Signed-off-by: hby <hby2003@163.com>
---
  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 4146faeed..c2eb3aa67 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -60,7 +60,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char 
*func, const char *fmt, ...);
                    ##__VA_ARGS__);            \
      } while (0)

-#if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
+#if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)

  /* For debug/tracing purposes treat info messages as errors */
  #define brcmf_info brcmf_err
@@ -114,7 +114,7 @@ extern int brcmf_msg_level;

  struct brcmf_bus;
  struct brcmf_pub;
-#ifdef DEBUG
+#if defined(CONFIG_BRCMDBG)
  struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
  void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
                   int (*read_fn)(struct seq_file *seq, void *data));
-- 
2.17.1

在 2020/11/23 23:59, Kalle Valo 写道:
> hby <hby2003@163.com> writes:
>
>> enable the DEBUG in source code, and it will compile fail,
>> modify the DEBUG macro, to adapt the compile
>>
>> Signed-off-by: hby <hby2003@163.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
> This has nothing to do with Raspberry Pi, so the title should be:
>
> brmcfmac: fix compile when DEBUG is defined
>

