Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130B6418E2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408107AbfFKX17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 19:27:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46930 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404692AbfFKX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 19:27:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so14776810wrw.13
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rhGOTsIRjma82lR9hgcwIBuPREH7Y2gvfF3jNKJe9WI=;
        b=iFsKyowMm53e2eFD33zYjnWHoLE4G1oLqca2QrQrtl+4Ojxr1CIvWR+2iDYMJ5PMn+
         Oq0doctNOeAkKfAO4Ld8E5HCXpZjY35k6LqRha7rjRwe1nzyRvITuoftOAnCU3aiqyah
         YHvx/Dk9Qx5Lq0VXDkWYnOjCuDPLptTqxx5dSRUMdtFJeSarBiv7J9L/sl/biR/fwxnP
         FJFWsiTm+M+d4hoWPEqQQ6JMyaslzlDAuwq2iuFCOHEG2tAFcOwr1j33dX+AmIoJHNX7
         Qs01uo+cUeZa6PSjyVJPZYne2+vTfFXMntW5eqFOvtGTTzpGdtAlR0qTqcKgnu0SwTI/
         vAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rhGOTsIRjma82lR9hgcwIBuPREH7Y2gvfF3jNKJe9WI=;
        b=oLaqAOHBIpZeVZsF8p6LEQbSDAbvadVMfYAwQCrw6t5eb4vLGLtxUAJ6k/NQZWS0ax
         uEga8oISGSp0rnAsUzs2NxlPNBwfLwSYBQ7aWm55tXZl/ZwU1u8o3epp1ngfs3k7Ci5K
         WWRe/Et0V6Gry8s483/8yAO62htNXdpL11dOPELk/+YbamWslAm4Fl7XaVjN7g2oglul
         1yFRrI787ADHgjIahgOhFQBqoq6So54Q5E0UNexIqvo8wma8dL76mDmBWOPtBngIBlHg
         xKb7b5ff+QEdLYsDV7ab6SqVI5LhLAqBUOQe9PCQmCWMxQi1s5bhPSuMH25egXL4EpRP
         SZow==
X-Gm-Message-State: APjAAAUMlte2zFGAx7ZR9tUu8IN3VBoko62ohutGa1QquCYrcn56ST2q
        Cpbz/miLnc4NAEOU43vyPUs=
X-Google-Smtp-Source: APXvYqyJu2yUb4StXTHwHxUhO0zneg6qqf+0i3W6P5TwDv7AMm8RyDENUvQsmD5j8KTuufJtc6UIMA==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr42842227wrs.225.1560295675949;
        Tue, 11 Jun 2019 16:27:55 -0700 (PDT)
Received: from [10.67.49.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s10sm4021587wmf.8.2019.06.11.16.27.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:27:55 -0700 (PDT)
Subject: Re: net-next: KSZ switch driver oops in ksz_mib_read_work
To:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
References: <6dc8cc46-6225-011c-68bc-c96a819fa00d@sedsystems.ca>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <3f8ee5e5-9996-dd74-807a-a4b24cd9ee4c@gmail.com>
Date:   Tue, 11 Jun 2019 16:27:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6dc8cc46-6225-011c-68bc-c96a819fa00d@sedsystems.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 10:57 AM, Robert Hancock wrote:
> We are using an embedded platform with a KSZ9897 switch. I am getting
> the oops below in ksz_mib_read_work when testing with net-next branch.
> After adding in some debug output, the problem is in this code:
> 
> 	for (i = 0; i < dev->mib_port_cnt; i++) {
> 		p = &dev->ports[i];
> 		mib = &p->mib;
> 		mutex_lock(&mib->cnt_mutex);
> 
> 		/* Only read MIB counters when the port is told to do.
> 		 * If not, read only dropped counters when link is not up.
> 		 */
> 		if (!p->read) {
> 			const struct dsa_port *dp = dsa_to_port(dev->ds, i);
> 
> 			if (!netif_carrier_ok(dp->slave))
> 				mib->cnt_ptr = dev->reg_mib_cnt;
> 		}
> 
> The oops is happening on port index 3 (i.e. 4th port) which is not
> connected on our platform and so has no entry in the device tree. For
> that port, dp->slave is NULL and so netif_carrier_ok explodes.
> 
> If I change the code to skip the port entirely in the loop if dp->slave
> is NULL it seems to fix the crash, but I'm not that familiar with this
> code. Can someone confirm whether that is the proper fix?

Yes, the following should do it, if you confirm that is the case, I can
send that later with your Tested-by.

diff --git a/drivers/net/dsa/microchip/ksz_common.c
b/drivers/net/dsa/microchip/ksz_common.c
index 39dace8e3512..5470b28332cf 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -93,6 +93,9 @@ static void ksz_mib_read_work(struct work_struct *work)
                if (!p->read) {
                        const struct dsa_port *dp = dsa_to_port(dev->ds, i);

+                       if (dsa_is_unused_port(dp))
+                               continue;
+
                        if (!netif_carrier_ok(dp->slave))
                                mib->cnt_ptr = dev->reg_mib_cnt;
                }


> 
> [   17.842829] Unable to handle kernel NULL pointer dereference at
> virtual address 0000002c
> [   17.850983] pgd = (ptrval)
> [   17.853711] [0000002c] *pgd=00000000
> [   17.857317] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [   17.862632] Modules linked in:
> [   17.865695] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.2.0-rc3 #1
> [   17.872142] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [   17.878688] Workqueue: events ksz_mib_read_work
> [   17.883227] PC is at ksz_mib_read_work+0x58/0x94
> [   17.887848] LR is at ksz_mib_read_work+0x38/0x94
> [   17.887852] pc : [<c04843dc>]    lr : [<c04843bc>]    psr: 60070113
> [   17.887857] sp : e8147f08  ip : e8148000  fp : ffffe000
> [   17.887860] r10: 00000000  r9 : e8aa7040  r8 : e867cc44
> [   17.887865] r7 : 00000c20  r6 : e8aa7120  r5 : 00000003  r4 : e867c958
> [   17.887868] r3 : 00000000  r2 : 00000000  r1 : 00000003  r0 : e8aa7040
> [   17.887879] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment none
> [   17.948224] Control: 10c5387d  Table: 38d9404a  DAC: 00000051
> [   17.948230] Process kworker/1:1 (pid: 21, stack limit = 0x(ptrval))
> [   17.948236] Stack: (0xe8147f08 to 0xe8148000)
> [   17.948245] 7f00:                   e8aa7120 e80a8080 eb7aef40
> eb7b2000 00000000 e8aa7124
> [   17.948254] 7f20: 00000000 c013865c 00000008 c0b03d00 e80a8080
> e80a8094 eb7aef40 00000008
> [   17.958073] systemd[1]: storage.mount: Unit is bound to inactive unit
> dev-mmcblk1p2.device. Stopping, too.
> [   17.963306] 7f40: c0b03d00 eb7aef58 eb7aef40 c01393a0 ffffe000
> c0b46b09 c084e464 00000000
> [   17.963314] 7f60: ffffe000 e8053140 e80530c0 00000000 e8146000
> e80a8080 c013935c e80a1eac
> [   17.963322] 7f80: e805315c c013e78c 00000000 e80530c0 c013e648
> 00000000 00000000 00000000
> [   17.969893] random: systemd: uninitialized urandom read (16 bytes read)
> [   17.973942] 7fa0: 00000000 00000000 00000000 c01010e8 00000000
> 00000000 00000000 00000000
> [   17.973949] 7fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [   17.973958] 7fe0: 00000000 00000000 00000000 00000000 00000013
> 00000000 00000000 00000000
> [   17.982246] random: systemd: uninitialized urandom read (16 bytes read)
> [   17.990329] [<c04843dc>] (ksz_mib_read_work) from [<c013865c>]
> (process_one_work+0x17c/0x390)
> [   17.990345] [<c013865c>] (process_one_work) from [<c01393a0>]
> (worker_thread+0x44/0x518)
> [   18.009394] random: systemd: uninitialized urandom read (16 bytes read)
> [   18.016344] [<c01393a0>] (worker_thread) from [<c013e78c>]
> (kthread+0x144/0x14c)
> [   18.016358] [<c013e78c>] (kthread) from [<c01010e8>]
> (ret_from_fork+0x14/0x2c)
> [   18.016362] Exception stack(0xe8147fb0 to 0xe8147ff8)
> [   18.016369] 7fa0:                                     00000000
> 00000000 00000000 00000000
> [   18.031159] 7fc0: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000
> [   18.031166] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   18.031176] Code: 1a000006 e51630e0 e0833405 e5933050 (e593302c)
> [   18.031279] ---[ end trace ca82392a6c2aa959 ]---
> 
> 


-- 
Florian
