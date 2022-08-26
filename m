Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75555A2DEA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344782AbiHZR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiHZR6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:58:25 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066A5E1ABC
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 10:58:24 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-334dc616f86so54738257b3.8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=FH3gjPhg+AmVieSzS7u71P7VJ9AmkcT7Mzf6GQo+Jvc=;
        b=qdTmxcqgrfxU0O/xm3zMOxyXy1cd2vIhIrgbql8hF8WCRA3SjzQUqmO5sFF9ru41cI
         8wn3AQ3evuw4K4ZwxoZvis/B0+SISP+E1tM4C8cqdO4G4aFG21Z0FPY0Saqqav72pcAT
         q4XExvPM5tB/nIoxZz9jAcjFw0/MaDUmn7a3FjsSTsUoDFqF5Yv2uFSwI+0Iju0tmtbi
         mA9oouAot73WsQy6xPlwliU4Qo6SLkGEn/ae9N0wwR6135XH6D7gW1z7lGUhzwY5SSu8
         U/ePFFpb7DjgsL/amSjV1HkTMfvo0711IgzrlhwP4bBHy+eV7+JCGCvfqs7FOoEbxdCz
         aW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=FH3gjPhg+AmVieSzS7u71P7VJ9AmkcT7Mzf6GQo+Jvc=;
        b=5MDPTHLx01Wwyv9qgH14GbdX9+mkaAYGXeRnWx0nn+F1xQWWBSHfvNVcuRxlnQE7UL
         11hEDEqqRyetoW/Su/z/GURabnRyY06cN98SoeGIkErT82oEijmgmlMVYMTAAPNEWMU+
         ua5aGB7873zVegpZGY47IHQllaToq+nW7gur/JtyTUv8/qFikxJL7wLF1jTuJaQO9NwJ
         BvctPXDxniKXn5+zP9lBWF/9q+vKfUzeFb+SgqYaaNmIumKeKRRTXLP9c/6zbvrcG6aj
         jhzSYMm6IKsLrnOsBqllX5H6ORCDWaP2O5RdWkYb93EoiebsGyDdka5uqgX/8AOzMLtF
         jqTw==
X-Gm-Message-State: ACgBeo0ywkLRlaSw4M7H5PK1J2Gr2vGiplV0O5p19Scc1Vp+eMpFBAeL
        HNjG4j0SDsKT4/rqluZN4kRIxZJXA8Eyl0eagsLERAZYgY6C4g==
X-Google-Smtp-Source: AA6agR48B59DNLm6mzvhAFz71UcA/hr3q94vYul3OhxHzva45uZUP9A9pJbFMdAf5WBFQRHll2OFQrFCZ4SwUiXhWvs=
X-Received: by 2002:a0d:fd06:0:b0:324:e4fe:9e6c with SMTP id
 n6-20020a0dfd06000000b00324e4fe9e6cmr872876ywf.332.1661536702870; Fri, 26 Aug
 2022 10:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <YwkH9zTmLRvDHHbP@krava>
In-Reply-To: <YwkH9zTmLRvDHHbP@krava>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 26 Aug 2022 10:58:11 -0700
Message-ID: <CANn89i+rh2T9eaNm1vmZVhdk3ponmOicoU=LQi6t0hkNrug8-Q@mail.gmail.com>
Subject: Re: memory leaks after running bpf selftests
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 10:50 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> hi,
> I'm getting memory leaks report after running test_progs,
> on latest bpf-next/master, looks networking related
>
> jirka
>
>
> ---
> unreferenced object 0xffff888102b816c0 (size 232):
>   comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
>   hex dump (first 32 bytes):
>     18 17 3c 19 81 88 ff ff c0 0a b8 02 81 88 ff ff  ..<.............
>     00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
>     [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50

This is a bit strange, because napi_get_frags_check() seems very self-contained
with no obvious leak...

>     [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
>     [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
>     [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
>     [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
>     [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
>     [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
>     [<ffffffff81c3b678>] ops_init+0x38/0x160
>     [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
>     [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
>     [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
>     [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
>     [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
> unreferenced object 0xffff888102b80ac0 (size 232):
>   comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
>   hex dump (first 32 bytes):
>     c0 16 b8 02 81 88 ff ff 40 00 b8 02 81 88 ff ff  ........@.......
>     00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
>     [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
>     [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
>     [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
>     [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
>     [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
>     [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
>     [<ffffffff81c3b678>] ops_init+0x38/0x160
>     [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
>     [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
>     [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
>     [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
>     [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
> unreferenced object 0xffff888102b80040 (size 232):
>   comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
>   hex dump (first 32 bytes):
>     c0 0a b8 02 81 88 ff ff c0 0d b8 02 81 88 ff ff  ................
>     00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
>     [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
>     [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
>     [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
>     [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
>     [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
>     [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
>     [<ffffffff81c3b678>] ops_init+0x38/0x160
>     [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
>     [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
>     [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
>     [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
>     [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
> unreferenced object 0xffff888102b80dc0 (size 232):
>   comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.893s)
>   hex dump (first 32 bytes):
>     40 00 b8 02 81 88 ff ff 18 17 3c 19 81 88 ff ff  @.........<.....
>     00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
>     [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
>     [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
>     [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
>     [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
>     [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
>     [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
>     [<ffffffff81c3b678>] ops_init+0x38/0x160
>     [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
>     [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
>     [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
>     [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
>     [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
> unreferenced object 0xffff88812c3a3400 (size 1024):
>   comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
>   hex dump (first 32 bytes):
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>   backtrace:
>     [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
>     [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
>     [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
>     [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
>     [<ffffffff81439205>] vfs_writev+0xc5/0x290
>     [<ffffffff8143944f>] do_writev+0x7f/0x160
>     [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
>     [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> unreferenced object 0xffff88812c3a4000 (size 1024):
>   comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
>   hex dump (first 32 bytes):
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>   backtrace:
>     [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
>     [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
>     [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
>     [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
>     [<ffffffff81439205>] vfs_writev+0xc5/0x290
>     [<ffffffff8143944f>] do_writev+0x7f/0x160
>     [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
>     [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> unreferenced object 0xffff88812c3a1000 (size 1024):
>   comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
>   hex dump (first 32 bytes):
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>   backtrace:
>     [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
>     [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
>     [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
>     [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
>     [<ffffffff81439205>] vfs_writev+0xc5/0x290
>     [<ffffffff8143944f>] do_writev+0x7f/0x160
>     [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
>     [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> unreferenced object 0xffff88812c3a1c00 (size 1024):
>   comm "test_progs", pid 686, jiffies 4294713342 (age 663.741s)
>   hex dump (first 32 bytes):
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>     6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>   backtrace:
>     [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
>     [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
>     [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
>     [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
>     [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
>     [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
>     [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
>     [<ffffffff81439205>] vfs_writev+0xc5/0x290
>     [<ffffffff8143944f>] do_writev+0x7f/0x160
>     [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
>     [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
