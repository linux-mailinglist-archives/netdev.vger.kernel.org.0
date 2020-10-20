Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43747293953
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393286AbgJTKq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390220AbgJTKq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:46:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFC8C061755;
        Tue, 20 Oct 2020 03:46:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b6so734107pju.1;
        Tue, 20 Oct 2020 03:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=99HMp6xP6U4EJWWuPPlFUYXlX0aPrirULUMTBK3L+7w=;
        b=Ukk7kRSnCLP8kR6GWakro8s/kCSTUO+EOEMojB/CqNUL7rwIYrWohKeqDHCNGPo2II
         4sYwaqOwqYqAomEfNgem/Q0vDWzcHLQkljClYM/dsTt/3xmPw4ozLNnGNuMSswRxuK3A
         CcywkGbBh3kDXsymKfeCg7Mi19zJnr7HgzePPgdMlRutNF56nbeNChy7wQuWQgitwFc/
         PAeC4fbA8C3dRvKdLG1v5C9l7xrbsa3oFf123gLqKF2phzcoruKLed69xVcFDj1F9Thj
         oFjBkxdAhqMm8P9Ael9hCcc09P2lZSUnor5vwfsTieLmFEy9u7BAI3SuIZfItG8VukPN
         EW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=99HMp6xP6U4EJWWuPPlFUYXlX0aPrirULUMTBK3L+7w=;
        b=RW44Fx+R+DaxcNuoayPF0zj71VMaJFkx0sHOnjhDSgQnFSTiseXosHxHu4HdueRL81
         2VNK8TRbQyo/H0hiWoJ8MU3e608eVnxs9B6Pki4g1h87CFGtBhERLfBpJwtrcBmDrOs6
         Sjyv6mFvXsvzww8KrMDGIWjE9aLtNBiK4ovF5l9cXpCMMJgBEbH2H/8xDhTgOIRO7+x5
         WdqmXAJBmzlHexlk9Ck0PRELqXggV1eNnJ87Fwe4aN7Ybr4pzQF9Gbp8GVAHrisQttkF
         +CO9NQgsvC1hVrZ8Y7e0AIUX8dS548qAJSVYz0tmx5Ol9HrTXcf+TzVxLQ1ZCB1N+ygZ
         9yLg==
X-Gm-Message-State: AOAM531AAAHE063iN1SpLSFppK4a+hawfrtAGXtOAnjFS8Kbbb0BdLZ9
        jsWCFJaDzOeJB8pNwRE1ewE=
X-Google-Smtp-Source: ABdhPJxXB7dN1+tlPvqmqbIJ9fH69L68cCgg46nTEHIsfaYY/ZQ2gGlxKAd5k25Xs8rQHBLJ4aZ2MA==
X-Received: by 2002:a17:90a:d341:: with SMTP id i1mr2324630pjx.18.1603190787019;
        Tue, 20 Oct 2020 03:46:27 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id n12sm1725170pjt.16.2020.10.20.03.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 03:46:26 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Tue, 20 Oct 2020 18:46:06 +0800
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201020104606.swblxgvfnjosafkk@Rk>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
 <20201016115407.170821-3-coiby.xu@gmail.com>
 <20201020085711.GM7183@syu-laptop>
 <20201020102741.GE23594@syu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201020102741.GE23594@syu-laptop>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for testing this patch!

On Tue, Oct 20, 2020 at 06:27:41PM +0800, Shung-Hsi Yu wrote:
>On Tue, Oct 20, 2020 at 04:57:11PM +0800, Shung-Hsi Yu wrote:
>> Hi,
>>
>> This patch trigger the following KASAN error inside qlge_init_device().
>>
>> [...] general protection fault, probably for non-canonical address 0xdffffc000000004b: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
>> [...] KASAN: null-ptr-deref in range [0x0000000000000258-0x000000000000025f]
>> [...] CPU: 0 PID: 438 Comm: systemd-udevd Tainted: G         C  E     5.9.0-kvmsmall+ #7
>> [...] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-
>> g...ilt.opensuse.org 04/01/2014
>> [...] RIP: 0010:qlge_get_8000_flash_params+0x377/0x6e0 [qlge]
>> [...] Code: 03 80 3c 02 00 0f 85 57 03 00 00 49 8b af 68 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bd 5f 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 c6 02 00 00
>> [...] RSP: 0018:ffffc90000f97788 EFLAGS: 00010207
>> [...] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> [...] RDX: 000000000000004b RSI: ffffffffc08cb843 RDI: 000000000000025f
>> [...] R10: fffffbfff5f718a0 R11: 0000000000000001 R12: dffffc0000000000
>> [...] R13: ffff888111085d40 R14: ffff888111085d40 R15: ffff888111080280
>> [...] FS:  00007f315f5db280(0000) GS:ffff8881f5200000(0000) knlGS:0000000000000000
>> [...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [...] CR2: 000055bb25297170 CR3: 0000000110674000 CR4: 00000000000006f0
>> [...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [...] Call Trace:
>> [...]  ? qlge_get_8012_flash_params+0x600/0x600 [qlge]
>> [...]  ? static_obj+0x8a/0xc0
>> [...]  ? lockdep_init_map_waits+0x26a/0x700
>> [...]  qlge_init_device+0x425/0x1000 [qlge]
>> [...]  ? debug_mutex_init+0x31/0x60
>> [...]  qlge_probe+0xfe/0x6c0 [qlge]
>> <snip>
>>
>> With qlge_get_8000_flash_params+0x377/0x6e0 corresponding to the following:
>>
>> 	if (qdev->flash.flash_params_8000.data_type1 == 2)
>> 		memcpy(mac_addr,
>> 		       qdev->flash.flash_params_8000.mac_addr1,
>> 		       qdev->ndev->addr_len); // <---- Here
>
>This is because qdev->ndev == 0.
>
>The reason is that before qlge_get_8000_flash_params() get called qdev is memset-ed inside qlge_init_device().
>
>static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
>				    int cards_found)
>	{
>	struct net_device *ndev = qdev->ndev;
>	int err = 0;
>
>	memset((void *)qdev, 0, sizeof(*qdev));
>
>	// ...
>
>	// qlge_get_8000_flash_params() get's called
>	err = qdev->nic_ops->get_flash(qdev);
>
>	// ...
>	}
>

Thank you for reporting this issue and providing the fix. I was a bit
confused after reading previous email because I dind't notice memset
and the address of ((struct net_device *) 0)->addr_len is 0x026f
which is outside the range reported by KASAN,

> [...] KASAN: null-ptr-deref in range [0x0000000000000258-0x000000000000025f]


--
Best regards,
Coiby
