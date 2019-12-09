Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B4A116B5C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfLIKqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:46:50 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41346 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfLIKqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 05:46:50 -0500
Received: by mail-ot1-f66.google.com with SMTP id r27so11740295otc.8;
        Mon, 09 Dec 2019 02:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMCpmtHEymGRf2uYDS22W75VCH1rWvIp47d3HDSdxPk=;
        b=TX+2fZk2v1lHegoxun80Qz/RbiIHk0fL/CzSsuSJPTstXhoY16+jy5Ny8RIBMnZLyX
         46jvuaesTFYweSpY+AckY9MDKNVHvnh8BO8t+0a3b4QjRu5tH3GZMMVEhCdm8CPvuunV
         1GlKTFWTVL82FGde22jt2PBTnnSnGQMZPxDm3sXn9Qms1GeHOjYAHAEJD0CK1QLPmgF/
         3xya/o4bUN9sfU+pGYipWtoUdBTBS0NfPBXBGqipfaDYRxOB2GXurHorXlDxbCoE9V2m
         w9OE6hSFbUnzC9JaT5udukoltr3Z4Ph/q+vRrA/nfmo9laTJJ+8fvHzfIgOVQssxQWB/
         yZug==
X-Gm-Message-State: APjAAAXRJRPKWi5nICzQhht5cdq8121+f17Fm2brlW7A4HPE0yzMY7FS
        BDrrPP3ktYps9xjDFHsuUObIQFcpkgvuv8EGTRU=
X-Google-Smtp-Source: APXvYqxC0e4TyWaYo05PrHXasVR3WmtOxIS00iV6KcOJtMmVpMEPmJaaxStauoMEG+erOWUSPYztN8GVusxDIz1ppyA=
X-Received: by 2002:a05:6830:91:: with SMTP id a17mr19596278oto.107.1575888409127;
 Mon, 09 Dec 2019 02:46:49 -0800 (PST)
MIME-Version: 1.0
References: <20191208.012032.1258816267132319518.davem@redhat.com>
In-Reply-To: <20191208.012032.1258816267132319518.davem@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Dec 2019 11:46:37 +0100
Message-ID: <CAMuHMdXKNMgAQHAE4f-0=srAZtDNUPB6Hmdm277XTgukrtiJ4Q@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@redhat.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Komachi-san,

On Sun, Dec 8, 2019 at 10:25 AM David Miller <davem@redhat.com> wrote:
> Yoshiki Komachi (1):
>       cls_flower: Fix the behavior using port ranges with hw-offload

I have bisected the below boot warning on m68k/ARAnyM to commit
8ffb055beae58574 ("cls_flower: Fix the behavior using port ranges with
hw-offload").  Reverting the commit on top of v5.5-rc1 fixes the issue.

WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x54/0x100
refcount_t: underflow; use-after-free.
Modules linked in:
CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted
5.4.0-atari-10298-g8ffb055beae58574 #223
Stack from 00c31e88:
        00c31e88 0038237c 00023d0a 00395a16 0000001c 00000009 00a67c80 00023d4e
        00395a16 0000001c 001a7c30 00000009 00000000 00c31ed0 00000001 00000000
        04208040 0000000a 00395a51 00c31ef0 00c30000 001a7c30 00395a16 0000001c
        00000009 00395a51 0026b1bc 0032253c 00000003 003224f8 0026c2be 00000001
        0032253c 00000000 00a67c80 00241d8c 00a67c80 00000000 00000200 000ab192
        0004859e 00a67c80 0000000a 003facd8 003f5b90 002f2b46 003facd8 002f2dfe
Call Trace: [<00023d0a>] __warn+0xb2/0xb4
 [<00023d4e>] warn_slowpath_fmt+0x42/0x64
 [<001a7c30>] refcount_warn_saturate+0x54/0x100
 [<001a7c30>] refcount_warn_saturate+0x54/0x100
 [<0026b1bc>] refcount_sub_and_test.constprop.73+0x38/0x3e
 [<0026c2be>] ipv4_dst_destroy+0x24/0x42
 [<00241d8c>] dst_destroy+0x40/0xae
 [<000ab192>] kfree+0x0/0x3e
 [<0004859e>] rcu_process_callbacks+0x9a/0x9c
 [<002f2b46>] __do_softirq+0x146/0x182
 [<002f2dfe>] schedule+0x0/0xb4
 [<00035e76>] kthread_parkme+0x0/0x10
 [<000359be>] __init_completion+0x0/0x20
 [<00038308>] smpboot_thread_fn+0x0/0x100
 [<00035fda>] kthread_should_stop+0x0/0x12
 [<00035fce>] kthread_should_park+0x0/0xc
 [<00025b9c>] run_ksoftirqd+0x12/0x20
 [<00038402>] smpboot_thread_fn+0xfa/0x100
 [<00024888>] do_exit+0x0/0x6d4
 [<0003f590>] complete+0x0/0x34
 [<00036594>] kthread+0xb2/0xbc
 [<000359be>] __init_completion+0x0/0x20
 [<000364e2>] kthread+0x0/0xbc
 [<00002a1c>] ret_from_kernel_thread+0xc/0x14
---[ end trace 126b6dd25f47053b ]---

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
