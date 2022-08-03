Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35B588AF3
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiHCLNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiHCLNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:13:24 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30C4140B9
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 04:13:18 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c24so12503192qkm.4
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/gsUS5aRQ2wcwLPfgmbGdsd4rEH8jZ0+iQSkfmcd31A=;
        b=evHltuSBtAvd5WHbJRwoatFaQNhlSD0OsKLEXY0aPRK83QCD2tvHIMjvgUajSXZy2K
         1HxEGo+VeFsGrddOVd6mlKL2dHC62e4Nx6qc1Le2Rnhc9QIPqX+cF9lvR0kWgBh9PX5S
         Pzhc2DuWz17gqXyZA06b6uHuPqsGqr+2YwsPnx+muHjah9glx9nIX50HSe74wVEcb1Om
         oQIGhj8T+fa6vsr1o8Jr0GDB6vCSyd8I1p3M7sVrfScDTAwq4W7+s+Glhe2xUE89fFhc
         P/LwZZ+38BDVKL/rz5DGmD7ZnPzK5vdg5Qo23CYY8fNv8HLZ8HLfNhyW3pmrt+sP1KzA
         /L0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/gsUS5aRQ2wcwLPfgmbGdsd4rEH8jZ0+iQSkfmcd31A=;
        b=SNCnBz7qVFAGp2l+eUyFgrvmtLiYQPcru3akXG4/WgBqtbcD/spgawWeWlSRq7NYg3
         sQcqdg5AofguR6Q0uYuhKil6vPR3Gw1KaB9wwStlXjE/SWP+cm3BqRAMprA/LkMk8Ti0
         rO2cN6gOX/Nb0KrzqIrBVLIlGJhGLadAz2C0EwrWcOqzMVw0QODrpav5BTiOge5ZnpkF
         AovbSM+WEeEZ3sCEuEeKvrjCkvrr3xX8xBDkyTe3vIbL/mGH34ec8KH8IzGUWGDyjTo0
         5a33UMtj/LGj/9BtiZ6lfFgHIoyAufOjLIfG9QSFV/divQmQSLwp3E2a5Og8UnMF7w2x
         Dmog==
X-Gm-Message-State: AJIora9LHPu+rdfbWSkXEv8lNJUueUQFVMQnePmrVEJTvzioAe0EhXov
        jSF+PS/8pPQNfrmxD4PHRj0CA/lioNN/9g==
X-Google-Smtp-Source: AGRyM1sPF5I07wRMcPCcoSdooXC0Nd92ua7XHcxvywv3t9gaJaChDnVjIdZjGt8CFwJ7QPxiYDHHlw==
X-Received: by 2002:a05:620a:240f:b0:6b5:e3c7:d54a with SMTP id d15-20020a05620a240f00b006b5e3c7d54amr17893877qkn.557.1659525197888;
        Wed, 03 Aug 2022 04:13:17 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id bi39-20020a05620a31a700b006b555509398sm11601232qkb.136.2022.08.03.04.13.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 04:13:17 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id 7so27868158ybw.0
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 04:13:17 -0700 (PDT)
X-Received: by 2002:a25:d617:0:b0:671:79bd:69bf with SMTP id
 n23-20020a25d617000000b0067179bd69bfmr20227165ybg.85.1659525197201; Wed, 03
 Aug 2022 04:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220803062759.3967-1-cbulinaru@gmail.com>
In-Reply-To: <20220803062759.3967-1-cbulinaru@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Aug 2022 07:12:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdp6_=4+J-ooz0vhjvthUAr6yLgQcAYR+Sgf=kbmzJV5A@mail.gmail.com>
Message-ID: <CA+FuTSdp6_=4+J-ooz0vhjvthUAr6yLgQcAYR+Sgf=kbmzJV5A@mail.gmail.com>
Subject: Re: [PATCH v5 net] net: tap: NULL pointer derefence in
 dev_parse_header_protocol when skb->dev is null
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 2:28 AM Cezar Bulinaru <cbulinaru@gmail.com> wrote:
>
> Fixes a NULL pointer derefence bug triggered from tap driver.
> When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
> (in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
> virtio_net_hdr_to_skb calls dev_parse_header_protocol which
> needs skb->dev field to be valid.
>
> The line that trigers the bug is in dev_parse_header_protocol
> (dev is at offset 0x10 from skb and is stored in RAX register)
>   if (!dev->header_ops || !dev->header_ops->parse_protocol)
>   22e1:   mov    0x10(%rbx),%rax
>   22e5:   mov    0x230(%rax),%rax
>
> Setting skb->dev before the call in tap.c fixes the issue.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000230
> RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
> Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
> RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
> RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
> RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
> R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
> FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
> Call Trace:
>  tap_get_user+0x3f1/0x540 [tap]
>  tap_sendmsg+0x56/0x362 [tap]
>  ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
>  handle_tx_copy+0x114/0x670 [vhost_net]
>  handle_tx+0xb0/0xe0 [vhost_net]
>  handle_tx_kick+0x15/0x20 [vhost_net]
>  vhost_worker+0x7b/0xc0 [vhost]
>  ? vhost_vring_call_reset+0x40/0x40 [vhost]
>  kthread+0xfa/0x120
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x1f/0x30
>
> Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
