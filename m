Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E3968F0CD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjBHO2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjBHO2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:28:14 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F67C7D9A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:28:04 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id t1so12933366ybd.4
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h4pOMG6YpkiABQLyH/sLxYVSsc0vPZYaYRnkZNdzgsI=;
        b=Z2y+ubSqVGhEqzTF30JKTNflyXHtTcxSiVBt+IWB5CyU9GEVZy/J0H8TX4U2cL7LX6
         HisFThJc1KkAfKTcxOw/6THJY9e+i+0sF3inCT1/EU+u3+bUw/179Ep0fT6EYDIGfH2V
         UuIpjJ+roCcL1E0x2OSL/An4qOHzKOd7Q2BQ0MKiyUyUe3dgeA0+gfKi4miXLtcHe9cH
         yAhYqZKqBVA0ILBaBGzDgyl2TlLUf1bIwrMiet8+/xjKxdu1Kc6tML/kSmp8lFBfUqij
         QFPLdUnYrCdYEZ3eiuVYukqQ4lnbfGG7JYwj23JKHgxro+MvugL3/wZXnX/VZxuBzM6o
         PbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4pOMG6YpkiABQLyH/sLxYVSsc0vPZYaYRnkZNdzgsI=;
        b=18Z1VBABZfMPMQZuQykGohi3CaURRADZr4PW+77xQD8Qutl9lACbIfd4+Ripl67PIV
         gCBErz+Rb8nTp6fkpSg0tVNyGZLYJjFW7OF6T6tlsU2HpMqP1DcBeHc3VPCG7SZM0GX2
         KaPFHa9CfSVMJXSmQzgkjMUN1KkrnaY2BcO3guOwIO/Kf236nROsspJa8dBPpyVBj2Hs
         zuQuoinQmMyVbTQJQp8ry0yZgqBn9HEhmr/NaXNc7+dEaiG8uVv9Sd6m7B4KYw9t4GMK
         IcOw4XCt9TlxP7GXaqAzCRAqHG8hFlkM90XANOHvcCq/N90CLE9FC8jU+XMpieS7zw4b
         NWww==
X-Gm-Message-State: AO0yUKXP48ouD6hHU22iesp6fmPEuudD1OCdXhc4lfmcEoGxQmkYHvFL
        ba9LbAEP9JQG06DPyLW2i1ST+dCOI3r9Xf1ELruVLQ==
X-Google-Smtp-Source: AK7set82KqX1v+2xEsRz4He8bLas+NCnVJDHbalwjCtcuFZdSrJRNu5h5sP6tJ02eDzZow2LKH/0DZDexMOKzyW79j4=
X-Received: by 2002:a25:9286:0:b0:8b9:30b8:3b80 with SMTP id
 y6-20020a259286000000b008b930b83b80mr533826ybl.538.1675866482968; Wed, 08 Feb
 2023 06:28:02 -0800 (PST)
MIME-Version: 1.0
References: <20230208142508.3278406-1-edumazet@google.com>
In-Reply-To: <20230208142508.3278406-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 8 Feb 2023 09:27:26 -0500
Message-ID: <CACSApvaEcGvU+k7PabwbdvyZVJBHZjwdgNJogyOKVUqsqUYFMw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: enable usercopy for skb_small_head_cache
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 9:25 AM Eric Dumazet <edumazet@google.com> wrote:
>
> syzbot and other bots reported that we have to enable
> user copy to/from skb->head. [1]
>
> We can prevent access to skb_shared_info, which is a nice
> improvement over standard kmem_cache.
>
> Layout of these kmem_cache objects is:
>
> < SKB_SMALL_HEAD_HEADROOM >< struct skb_shared_info >
>
> usercopy: Kernel memory overwrite attempt detected to SLUB object 'skbuff_small_head' (offset 32, size 20)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102 !
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc6-syzkaller-01425-gcb6b2e11a42d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
> RIP: 0010:usercopy_abort+0xbd/0xbf mm/usercopy.c:102
> Code: e8 ee ad ba f7 49 89 d9 4d 89 e8 4c 89 e1 41 56 48 89 ee 48 c7 c7 20 2b 5b 8a ff 74 24 08 41 57 48 8b 54 24 20 e8 7a 17 fe ff <0f> 0b e8 c2 ad ba f7 e8 7d fb 08 f8 48 8b 0c 24 49 89 d8 44 89 ea
> RSP: 0000:ffffc90000067a48 EFLAGS: 00010286
> RAX: 000000000000006b RBX: ffffffff8b5b6ea0 RCX: 0000000000000000
> RDX: ffff8881401c0000 RSI: ffffffff8166195c RDI: fffff5200000cf3b
> RBP: ffffffff8a5b2a60 R08: 000000000000006b R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8bf2a925
> R13: ffffffff8a5b29a0 R14: 0000000000000014 R15: ffffffff8a5b2960
> FS: 0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000c48e000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> __check_heap_object+0xdd/0x110 mm/slub.c:4761
> check_heap_object mm/usercopy.c:196 [inline]
> __check_object_size mm/usercopy.c:251 [inline]
> __check_object_size+0x1da/0x5a0 mm/usercopy.c:213
> check_object_size include/linux/thread_info.h:199 [inline]
> check_copy_size include/linux/thread_info.h:235 [inline]
> copy_from_iter include/linux/uio.h:186 [inline]
> copy_from_iter_full include/linux/uio.h:194 [inline]
> memcpy_from_msg include/linux/skbuff.h:3977 [inline]
> qrtr_sendmsg+0x65f/0x970 net/qrtr/af_qrtr.c:965
> sock_sendmsg_nosec net/socket.c:722 [inline]
> sock_sendmsg+0xde/0x190 net/socket.c:745
> say_hello+0xf6/0x170 net/qrtr/ns.c:325
> qrtr_ns_init+0x220/0x2b0 net/qrtr/ns.c:804
> qrtr_proto_init+0x59/0x95 net/qrtr/af_qrtr.c:1296
> do_one_initcall+0x141/0x790 init/main.c:1306
> do_initcall_level init/main.c:1379 [inline]
> do_initcalls init/main.c:1395 [inline]
> do_basic_setup init/main.c:1414 [inline]
> kernel_init_freeable+0x6f9/0x782 init/main.c:1634
> kernel_init+0x1e/0x1d0 init/main.c:1522
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> </TASK>
>
> Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the quick fix!

> ---
>  net/core/skbuff.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index bdb1e015e32b9386139e9ad73acd6efb3c357118..70a6088e832682efccf081fa3e6a97cbdeb747ac 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4690,10 +4690,16 @@ void __init skb_init(void)
>                                                 SLAB_HWCACHE_ALIGN|SLAB_PANIC,
>                                                 NULL);
>  #ifdef HAVE_SKB_SMALL_HEAD_CACHE
> -       skb_small_head_cache = kmem_cache_create("skbuff_small_head",
> +       /* usercopy should only access first SKB_SMALL_HEAD_HEADROOM bytes.
> +        * struct skb_shared_info is located at the end of skb->head,
> +        * and should not be copied to/from user.
> +        */
> +       skb_small_head_cache = kmem_cache_create_usercopy("skbuff_small_head",
>                                                 SKB_SMALL_HEAD_CACHE_SIZE,
>                                                 0,
>                                                 SLAB_HWCACHE_ALIGN | SLAB_PANIC,
> +                                               0,
> +                                               SKB_SMALL_HEAD_HEADROOM,
>                                                 NULL);
>  #endif
>         skb_extensions_init();
> --
> 2.39.1.519.gcb327c4b5f-goog
>
