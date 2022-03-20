Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14164E1E0F
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbiCTV4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 17:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbiCTV4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 17:56:45 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFF3366BF
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 14:55:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j15so12427256eje.9
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 14:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hLKx8CAJntsK0yBMQmBZFOxm4LBOx6McrSplLJdiGGU=;
        b=mt8PQVn28lw9ZHmv9OluD/+rddZETi2CpFWyYRqwb8NOFOEKEPefD2ZeOSIqiomg+U
         42GPEuyszn5IR7qcqzUSgYnLuzC4lypVbf1Rp1HWkSaE94p5exbSQZHDPV8lEQ5/cwoc
         uf+h0LihV/ns0Ho0ApGkeA/oPr417gvK/KGfPxBYQQpMDQgFnqnRjUd3oQj24HEiqqoF
         fev9lCRq3YFc6EnxRHEVmOzFvxUvosjPhrykYOEaSX3L8Qh3Awd0cg+rydCMCX5jyKvL
         SJmXvjkqMFD/ev084ruGBMZTJdfCaSO+sIpIk89gcc85G2l8rs+78eDerkDLe5DyAnwk
         Eciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hLKx8CAJntsK0yBMQmBZFOxm4LBOx6McrSplLJdiGGU=;
        b=j2drK01RPVNo6+OzqfGqW+E/yjqSgKWkjU5gjwAjzQekJVOeKFi2zCnptvMaC2v2Wr
         WWZiMatPBvJwG2xKWh9gQ5zf5DOz0It58B9JYWir5wc+TyRNBOu8L9hwRwmza2HDyLT2
         FxsPBZeJiidwbcTc0YCeSUzK3cR0CkqmFushahfr9wgJv5+EsfgEJeE9i9Nly1xPFKZB
         KRZS9LpVTSBpVU1MjzauQzTZP9LW48Y5PhCh9m0/I4bHVbokQ8tJIpwWGVvNJ9IQ45zv
         DgGHsgzfiYcvTayTRknNMX4CKN17H5QQbhBlhfz4W5XRgbqHf5y6MLNcdPhKgID7TH5/
         Tl4w==
X-Gm-Message-State: AOAM533iOuermWu4xTAixXAxhHJHMUr4/YBkVFKX2tFj2WiVENetihVI
        /2z0MoBdq5FwmjQUL4L5GF2+w4vWP7V20YiOyuCR
X-Google-Smtp-Source: ABdhPJzWwblOJWMtONe7CR9um3g6A8nTZL8q/qL8GvVJTw4AHssVaTYZmSsnltemJdLy060xvql+tgQpRva1eqsC0MM=
X-Received: by 2002:a17:907:1b09:b0:6d8:faa8:4a06 with SMTP id
 mp9-20020a1709071b0900b006d8faa84a06mr17885084ejc.701.1647813313849; Sun, 20
 Mar 2022 14:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220318063508.1348148-1-wangyufen@huawei.com>
In-Reply-To: <20220318063508.1348148-1-wangyufen@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 20 Mar 2022 17:55:02 -0400
Message-ID: <CAHC9VhSTWOEr-OQiJKgz+Xt1R3OzsfToWLxDcGjiKbb8U0hJpg@mail.gmail.com>
Subject: Re: [PATCH net-next] netlabel: fix out-of-bounds memory accesses
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 2:17 AM Wang Yufen <wangyufen@huawei.com> wrote:
>
> In calipso_map_cat_ntoh(), in the for loop, if the return value of
> netlbl_bitmap_walk() is equal to (net_clen_bits - 1), when
> netlbl_bitmap_walk() is called next time, out-of-bounds memory accesses
> of bitmap[byte_offset] occurs.
>
> The bug was found during fuzzing. The following is the fuzzing report
>  BUG: KASAN: slab-out-of-bounds in netlbl_bitmap_walk+0x3c/0xd0
>  Read of size 1 at addr ffffff8107bf6f70 by task err_OH/252
>
>  CPU: 7 PID: 252 Comm: err_OH Not tainted 5.17.0-rc7+ #17
>  Hardware name: linux,dummy-virt (DT)
>  Call trace:
>   dump_backtrace+0x21c/0x230
>   show_stack+0x1c/0x60
>   dump_stack_lvl+0x64/0x7c
>   print_address_description.constprop.0+0x70/0x2d0
>   __kasan_report+0x158/0x16c
>   kasan_report+0x74/0x120
>   __asan_load1+0x80/0xa0
>   netlbl_bitmap_walk+0x3c/0xd0
>   calipso_opt_getattr+0x1a8/0x230
>   calipso_sock_getattr+0x218/0x340
>   calipso_sock_getattr+0x44/0x60
>   netlbl_sock_getattr+0x44/0x80
>   selinux_netlbl_socket_setsockopt+0x138/0x170
>   selinux_socket_setsockopt+0x4c/0x60
>   security_socket_setsockopt+0x4c/0x90
>   __sys_setsockopt+0xbc/0x2b0
>   __arm64_sys_setsockopt+0x6c/0x84
>   invoke_syscall+0x64/0x190
>   el0_svc_common.constprop.0+0x88/0x200
>   do_el0_svc+0x88/0xa0
>   el0_svc+0x128/0x1b0
>   el0t_64_sync_handler+0x9c/0x120
>   el0t_64_sync+0x16c/0x170
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/netlabel/netlabel_kapi.c | 2 ++
>  1 file changed, 2 insertions(+)

Looks good to me, thanks for catching this and submitting a fix.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index beb0e573266d..54c083003947 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -885,6 +885,8 @@ int netlbl_bitmap_walk(const unsigned char *bitmap, u32 bitmap_len,
>         unsigned char bitmask;
>         unsigned char byte;
>
> +       if (offset >= bitmap_len)
> +               return -1;
>         byte_offset = offset / 8;
>         byte = bitmap[byte_offset];
>         bit_spot = offset;

-- 
paul-moore.com
