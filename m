Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E1A15054
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfEFPep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:34:45 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34828 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFPeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:34:44 -0400
Received: by mail-qk1-f195.google.com with SMTP id c15so723312qkl.2;
        Mon, 06 May 2019 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3whM21l/5k3wD/196qnqRvvbZFhQ6svjKi2cNIBMnxM=;
        b=UeUYFa5yrh6sDIKlJmkpN48spGcdjrx4uNdA9xv3T6qB5KfxEnWLzbBmYTxRqHceCB
         Fh/qmFCd3fZjzbB+mrnico2Y4HYFznQYDAaWZtbI0P+C4JHRaNNxyAvBpbxEOJcJE66A
         uy1yRu+h7l4Jun9ugsVsHAdxj/5cK3hn3gRp96hEiZ/MQZm85ychyg+vxG12hMKjLWEx
         t095QjVNYWSGDIwv8DkwaIW1eje5zeHoFEDOAhap+55lG7g45ujomrmD8gCTyNX4QDhZ
         bhWblBtANA5kFMOh70SW5Y3mR/aE+KHpDb3oQHwnqNH40ngi7J38cSR9bGcNJUQNNFUA
         C5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3whM21l/5k3wD/196qnqRvvbZFhQ6svjKi2cNIBMnxM=;
        b=pZzlfPPmLaW3aNkb+B2AeQGuNwG2pFW+KnSuWXM0ey07NJoXkyVZJb5qx16yGPiExs
         w774A7Xi4PgMD5vlxkWr8IA6tAIehgH1vI5EZlmcLjsi5MS518GpuHjy3+ccJBNdn4UV
         qHQWrjTgw5VjYKYccCfxy+gMsEbRELE3Ys8e/6nISZTz+BFAsX00m2/J79H8SzszFhEa
         zJ4Ca83m5j0Z3Ws/n+kZgzG6+Uab9QSfEx1Z4AhyGPqmPbBy6Dj4Koe3VNdEiwYvENA4
         Oj/RQO7r+Y9OlOCIO6OSRO1HXuIdWri0XZDp92ZxrFqRok+dzqeZhUrMNORmiYSX5BWF
         4JZg==
X-Gm-Message-State: APjAAAV6Vl4AKCVtN46CjSBAivYwkz4m/fH1SLfcqnyH4+h7ZGJBvQD5
        cdr6y62yj+eGsiVd1Y6fPr0=
X-Google-Smtp-Source: APXvYqyeDpF42Hm9TpCOadbjNSahvA6dvHHEmS9zY/hf6BIpqe2+W/T7aXd5DkhKSEr0muxJkNQTWw==
X-Received: by 2002:a05:620a:141a:: with SMTP id d26mr1781882qkj.238.1557156883641;
        Mon, 06 May 2019 08:34:43 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u22sm445609qkk.61.2019.05.06.08.34.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 08:34:43 -0700 (PDT)
Date:   Mon, 6 May 2019 11:34:42 -0400
Message-ID: <20190506113442.GB32197@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH] net: dsa: Fix error cleanup path in dsa_init_module
In-Reply-To: <20190506152529.6292-1-yuehaibing@huawei.com>
References: <20190506152529.6292-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 23:25:29 +0800, YueHaibing <yuehaibing@huawei.com> wrote:
> BUG: unable to handle kernel paging request at ffffffffa01c5430
> PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bc5067 PTE 0
> Oops: 0000 [#1
> CPU: 0 PID: 6159 Comm: modprobe Not tainted 5.1.0+ #33
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
> RIP: 0010:raw_notifier_chain_register+0x16/0x40
> Code: 63 f8 66 90 e9 5d ff ff ff 90 90 90 90 90 90 90 90 90 90 90 55 48 8b 07 48 89 e5 48 85 c0 74 1c 8b 56 10 3b 50 10 7e 07 eb 12 <39> 50 10 7c 0d 48 8d 78 08 48 8b 40 08 48 85 c0 75 ee 48 89 46 08
> RSP: 0018:ffffc90001c33c08 EFLAGS: 00010282
> RAX: ffffffffa01c5420 RBX: ffffffffa01db420 RCX: 4fcef45928070a8b
> RDX: 0000000000000000 RSI: ffffffffa01db420 RDI: ffffffffa01b0068
> RBP: ffffc90001c33c08 R08: 000000003e0a33d0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000094443661 R12: ffff88822c320700
> R13: ffff88823109be80 R14: 0000000000000000 R15: ffffc90001c33e78
> FS:  00007fab8bd08540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa01c5430 CR3: 00000002297ea000 CR4: 00000000000006f0
> Call Trace:
>  register_netdevice_notifier+0x43/0x250
>  ? 0xffffffffa01e0000
>  dsa_slave_register_notifier+0x13/0x70 [dsa_core
>  ? 0xffffffffa01e0000
>  dsa_init_module+0x2e/0x1000 [dsa_core
>  do_one_initcall+0x6c/0x3cc
>  ? do_init_module+0x22/0x1f1
>  ? rcu_read_lock_sched_held+0x97/0xb0
>  ? kmem_cache_alloc_trace+0x325/0x3b0
>  do_init_module+0x5b/0x1f1
>  load_module+0x1db1/0x2690
>  ? m_show+0x1d0/0x1d0
>  __do_sys_finit_module+0xc5/0xd0
>  __x64_sys_finit_module+0x15/0x20
>  do_syscall_64+0x6b/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Cleanup allocated resourses if there are errors,
> otherwise it will trgger memleak.
> 
> Fixes: c9eb3e0f8701 ("net: dsa: Add support for learning FDB through notification")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
