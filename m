Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D632DC5FC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgLPSMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbgLPSMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:12:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24033C061794;
        Wed, 16 Dec 2020 10:11:58 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m5so2091454pjv.5;
        Wed, 16 Dec 2020 10:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MoM0QOrttNDmqB2jq4Q8+3+4bGHdnVDY4snfv2F9MW8=;
        b=GOqcFVXBXD3kZ3E2Fj+lUGpeNWjU+dVes9tjvPFA7CjH16JZ8NDQ4tpc7+JrHwCw4c
         PdsfEj6XV4cy19YvrEpf3SLMCf1TjDmw7wfE4w2Gpb+soC+ikPgsBXkb8f/mRUTzJwCq
         Jmk/Z+N0QNTB8SYtS17c11G4VeMcAGSlKaJMle+IkV0cfmq+uyFl2G8YInY258jzLNhJ
         1zoezZ1OXTE1gyQyVbsx9krTbshJch5eEAnr/vOQ1NDlddv/rl0JEs9mvRHoesL4Jcse
         VYaaLxsYoYLPU3iKqvhNl+gyWhY56pMcfCwAWHym0rR6hxYv2dlhazwB6A+Cf05I3ZjF
         wIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MoM0QOrttNDmqB2jq4Q8+3+4bGHdnVDY4snfv2F9MW8=;
        b=mQ3i58/wAQJ7beU1hEFsp5OPeaRRplBoVVP9o5Gu1Ih9clHWy7IYg43SCZ2pNG6YV4
         vCl+nXV0pVhbI14NWhnoFcw+2Z0xebgaCZkrRdOGEdoJ5YZCA9oHqY1EkjY7W6HRV8tH
         RtvzqeTJ8YEM3mVxfaOqhnQXhZweDcBGCpBaNasdNdqtVCtTexQAniCTveeooOI6PUCc
         it/HxiAL4/wQTSPRRkfqqrTfOXcuZ+2lCLe9JmAUoHeI+tYDX3Bn+v4nZdl0enmzqiQw
         JS1VFrsj/b5O5CrJiRTci/1OW1DT4Jk081UviLejyBDdIp3Yg0NSpO8Sy/y52kgZ8lZ/
         vCeg==
X-Gm-Message-State: AOAM531+tfEyR4RNkdfKf8+iPey5mgkZ8zhzdOuk8GMXJpz58abEU5Pn
        RYUWgF6AzK3vbNe89USZK8HaRUnMqdnZ/X8=
X-Google-Smtp-Source: ABdhPJx0TPjLXdmPHeYFKEuRG7aVcagguJHauwL7gnfBW9YwYiJELj+uMIYgG3ooUtvZaZFoslVQnQ==
X-Received: by 2002:a17:90a:f683:: with SMTP id cl3mr4120692pjb.136.1608142317653;
        Wed, 16 Dec 2020 10:11:57 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id j16sm3530775pgl.50.2020.12.16.10.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 10:11:51 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:11:35 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     syzbot <syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in xskq_create
Message-ID: <20201216181135.GA94576@PWN>
References: <0000000000002aca2e05b659af04@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002aca2e05b659af04@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Sun, Dec 13, 2020 at 06:53:10AM -0800, syzbot wrote:
> BUG: memory leak
> unreferenced object 0xffff88810f897940 (size 64):
>   comm "syz-executor991", pid 8502, jiffies 4294942194 (age 14.080s)
>   hex dump (first 32 bytes):
>     7f 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 a0 37 0c 81 88 ff ff 00 00 00 00 00 00 00 00  ..7.............
>   backtrace:
>     [<00000000639d0dd1>] xskq_create+0x23/0xd0 include/linux/slab.h:552
>     [<00000000b680b035>] xsk_init_queue net/xdp/xsk.c:508 [inline]
>     [<00000000b680b035>] xsk_setsockopt+0x1c4/0x590 net/xdp/xsk.c:875
>     [<000000002b302260>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
>     [<00000000ae03723e>] __do_sys_setsockopt net/socket.c:2143 [inline]
>     [<00000000ae03723e>] __se_sys_setsockopt net/socket.c:2140 [inline]
>     [<00000000ae03723e>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
>     [<0000000005c2b4a0>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000003db140f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

I have tested the following diff locally against syzbot's reproducer,
and sent a patch to it [1] for testing.  I will send a real patch here
tomorrow if syzbot is happy about it.  Please see explanation below.

--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -37,6 +37,9 @@ void xp_destroy(struct xsk_buff_pool *pool)
        if (!pool)
                return;

+       xskq_destroy(pool->fq);
+       xskq_destroy(pool->cq);
+
        kvfree(pool->heads);
        kvfree(pool);
 }
@@ -234,16 +237,6 @@ static void xp_release_deferred(struct work_struct *work)
        xp_clear_dev(pool);
        rtnl_unlock();

-       if (pool->fq) {
-               xskq_destroy(pool->fq);
-               pool->fq = NULL;
-       }
-
-       if (pool->cq) {
-               xskq_destroy(pool->cq);
-               pool->cq = NULL;
-       }
-
        xdp_put_umem(pool->umem, false);
        xp_destroy(pool);
 }

When xsk_bind() allocates `xs->pool` but something else goes wrong:

		xs->pool = xp_create_and_assign_umem(xs, xs->umem);
		[...]
		if (err) {
			xp_destroy(xs->pool);

xp_destroy() doesn't free `pool->{f,c}q`, causing a memory leak.  Move
`xskq_destroy(pool->{f,c}q)` from xp_release_deferred() to xp_destroy().

Also, since xskq_destroy() already does null check, I think it's
unnecessary to do it again here?

Thanks,
Peilin Ye

[1] https://syzkaller.appspot.com/bug?id=fea808dfe3c6dfdd6ba9778becbffe0b14e91294
