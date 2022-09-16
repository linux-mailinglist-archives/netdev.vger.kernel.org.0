Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF725BA439
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 03:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIPB5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 21:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiIPB5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 21:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588F532BBF
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 18:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663293418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5cRPoSqEkfts6JJdZaTUOhVXmeLMI8jRcy1TXnHcJ+8=;
        b=AKWIfvoxIkaL64f06jbRN1gCDyjF0gI+v6ppfySwwAnUhf7KSToogXbxY0VHx42akKsW70
        JNteNdEXNw8KN4a8cWr7Uo3arEULQAydc9KcO2mKYysTi/pTqkNpf61wZZjOXioD3bROd1
        1aVuNnR8nzSnUgklWOCjhb9qXBNeqgY=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-573-IJVkhu7EM6ek77vCBURfjA-1; Thu, 15 Sep 2022 21:56:57 -0400
X-MC-Unique: IJVkhu7EM6ek77vCBURfjA-1
Received: by mail-vs1-f72.google.com with SMTP id 124-20020a670882000000b00388cd45f433so2389220vsi.8
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 18:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5cRPoSqEkfts6JJdZaTUOhVXmeLMI8jRcy1TXnHcJ+8=;
        b=nG/V1JVFbN77Er3P+tSUtTm2q4CfnJMlXZkmZgrr+QLLFSAEn6fCyiY/D6nVk/XkZm
         dKzhs3DcBnayAzsZLnzxAjwKV/usIJTRxy3SpPYp9qUrXASXFCx56MYnaUsqjlRzWEt6
         qVRpwccCtc46+puKpkQNr7HOZ7VwpUdeW+KHyglST2uCsJyl6/pNsnfxrhuhXw1DAAdH
         rlDHTqeoOLNNMSJR8VCJ9sSlzIacSzz1tT3WZx0BnVnKcO7AAkywQZrwKcOyN/1jtk+U
         L86Y/7oenRWBBQ+D9b+UWlgK8Uia+keTb2tL2fuyQxEmW9aWox0odutF/MuVh3jRvzbM
         BAaw==
X-Gm-Message-State: ACrzQf2BLJViRNZ/PIxEV2hCtduKaHuy0Cogc5jwujeMYvsOPtBYmuYM
        S/eiXba6UpkMvVPQ7OqrfohyOZEnZ5t/uygkPFWiOXfZ/dscdKZIOL7+EvtI5niLgHSEgQcBCM5
        siMbgVszmRphlrIUuNKTQK9Bn7j3YMf+d
X-Received: by 2002:a05:6102:a84:b0:357:c234:8041 with SMTP id n4-20020a0561020a8400b00357c2348041mr1243302vsg.25.1663293416065;
        Thu, 15 Sep 2022 18:56:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7m//TE3C+2BsNHE+6EYbUuamuB6Tyywk+iA9GNrB7kzjI9SnzG9SRud/sKdMqHlJCfqVXNmkC0dhZxItFwC8g=
X-Received: by 2002:a05:6102:a84:b0:357:c234:8041 with SMTP id
 n4-20020a0561020a8400b00357c2348041mr1243297vsg.25.1663293415869; Thu, 15 Sep
 2022 18:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220915123539.35956-1-liujian56@huawei.com>
In-Reply-To: <20220915123539.35956-1-liujian56@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 16 Sep 2022 09:56:45 +0800
Message-ID: <CACGkMEsXYAHTb40jbtr35=O2NgJHHNkC_E2b8bqxygrmLOtRbQ@mail.gmail.com>
Subject: Re: [PATCH net v2] tun: Check tun device queue status in tun_chr_write_iter
To:     Liu Jian <liujian56@huawei.com>
Cc:     davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 8:34 PM Liu Jian <liujian56@huawei.com> wrote:
>
> syzbot found below warning:
>
> ------------[ cut here ]------------
> geneve0 received packet on queue 3, but number of RX queues is 3
> WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_get_rxqueue net/core/dev.c:4611 [inline]
> WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> Modules linked in:
> CPU: 1 PID: 29734 Comm: syz-executor.0 Not tainted 5.10.0 #5
> Hardware name: linux,dummy-virt (DT)
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
> pc : netif_get_rxqueue net/core/dev.c:4611 [inline]
> pc : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> lr : netif_get_rxqueue net/core/dev.c:4611 [inline]
> lr : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
> sp : ffffa00016127770
> x29: ffffa00016127770 x28: ffff3f4607d6acb4
> x27: ffff3f4607d6acb0 x26: ffff3f4607d6ad20
> x25: ffff3f461de3c000 x24: ffff3f4607d6ad28
> x23: ffffa00010059000 x22: ffff3f4608719100
> x21: 0000000000000003 x20: ffffa000161278a0
> x19: ffff3f4607d6ac40 x18: 0000000000000000
> x17: 0000000000000000 x16: 00000000f2f2f204
> x15: 00000000f2f20000 x14: 6465766965636572
> x13: 20306576656e6567 x12: ffff98b8ed3b924d
> x11: 1ffff8b8ed3b924c x10: ffff98b8ed3b924c
> x9 : ffffc5c76525c9c4 x8 : 0000000000000000
> x7 : 0000000000000001 x6 : ffff98b8ed3b924c
> x5 : ffff3f460f3b29c0 x4 : dfffa00000000000
> x3 : ffffc5c765000000 x2 : 0000000000000000
> x1 : 0000000000000000 x0 : ffff3f460f3b29c0
> Call trace:
>  netif_get_rxqueue net/core/dev.c:4611 [inline]
>  netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
>  do_xdp_generic net/core/dev.c:4777 [inline]
>  do_xdp_generic+0x9c/0x190 net/core/dev.c:4770
>  tun_get_user+0xd94/0x2010 drivers/net/tun.c:1938
>  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
>  call_write_iter include/linux/fs.h:1960 [inline]
>  new_sync_write+0x260/0x370 fs/read_write.c:515
>  vfs_write+0x51c/0x61c fs/read_write.c:602
>  ksys_write+0xfc/0x200 fs/read_write.c:655
>  __do_sys_write fs/read_write.c:667 [inline]
>  __se_sys_write fs/read_write.c:664 [inline]
>  __arm64_sys_write+0x50/0x60 fs/read_write.c:664
>  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>  el0_svc_common.constprop.0+0xf4/0x414 arch/arm64/kernel/syscall.c:155
>  do_el0_svc+0x50/0x11c arch/arm64/kernel/syscall.c:217
>  el0_svc+0x20/0x30 arch/arm64/kernel/entry-common.c:353
>  el0_sync_handler+0xe4/0x1e0 arch/arm64/kernel/entry-common.c:369
>  el0_sync+0x148/0x180 arch/arm64/kernel/entry.S:683
>
> This is because the detached queue is used to send data. Therefore, we need
> to check the queue status in the tun_chr_write_iter function.
>
> Fixes: cde8b15f1aab ("tuntap: add ioctl to attach or detach a file form tuntap device")

Not sure this deserves a stable.

> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: add fixes tag
>  drivers/net/tun.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 259b2b84b2b3..261411c1a6bb 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2019,6 +2019,11 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         if (!tun)
>                 return -EBADFD;
>
> +       if (tfile->detached) {

tfile->detached is synchronized through rtnl_lock which is probably
not suitable for the datapath. We probably need to rcuify this.

> +               tun_put(tun);
> +               return -ENETDOWN;

Another question is that can some user space depend on this behaviour?
I wonder if it's more safe to pretend the packet was received here?

Thanks

> +       }
> +
>         if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
>                 noblock = 1;
>
> --
> 2.17.1
>

