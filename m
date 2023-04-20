Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE46E99EF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDTQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjDTQwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:52:05 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203492710
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:52:04 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-32abc2e7da8so2925985ab.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682009523; x=1684601523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAJ+43MM6KEvzaABLNFdNF8eDPx+cG7dKXBJJZKWHdo=;
        b=euqN9UhnPPwR2K6DB36iaouH9aCiBQwKpdJjlSq9XDhKeoRGVZGxZUG1M1hCMa38D6
         tD064MoAvPgGPH9KtwklUEAK9mX7ZCmCRDn+zbagNp5NEyVVtMuJwtl3k1g7Cw867N74
         RuvhKME5KfX4wqHWg2Y9FrxWe3WYDrOlRjwYBg1E1gN+uGth0CkTG3IhFhdorbWToztF
         o/5ImBcvb8YZvfS+Q+jfcIHp5gYIaNJu0At+LO0IhW6a0eHuh41cI1FfeK8AhKZTxAjY
         xDR9VaszUyK3y63IINmdLZcgxJHMgHuEr3aEaeKqzEImLANtyCYe790TLDxiuTVxNiZ6
         fU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009523; x=1684601523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAJ+43MM6KEvzaABLNFdNF8eDPx+cG7dKXBJJZKWHdo=;
        b=BB9s6vzgzCPOwLBKesv+HuJ0/dzOu94l9vf9o8rptIAyTt4JIKkCJqhXWFv2bmktIA
         DCjoYzJJkSEuFDJi41obrHTmzhBGnZZEeyTtsvs1ktkiQqvReH3ThjdXFcuMCR2mBGPv
         QR/bshXTcZ63sA+vLPwHJgDwbuToAfqg8Y2UQK96y9amcBp+MqEwguWQDXHnuJw9TzG9
         7VluUpNnZOCHYVztCPbAQlhvxq5TFEhYkPN+FwM9WsD3vjhz/+V1sHcjsPy+E7n993ec
         iRRqlkOZxDiVaZr6tR7bKjFP1F8YIpEqqmyT0SOPVXjhe7+PjzKDrSOTZ0l9EP5G2XF2
         iSqg==
X-Gm-Message-State: AAQBX9emtgrj3CO4I5oJ1YI5FTT/aVgyuziORc53g6TdZFIVgwq/EGF0
        5rBFzkJ8fjFM7CM7fVecbm4A+7rPE+A6LweO/3QHPA==
X-Google-Smtp-Source: AKy350aW6dWXPZYOI+NmVa6dJyKVIvnfM06XB/eMsKXndFPCsDff5V0SmxzZnJA3fkz/ljiahCUHAYErcI2RtnWZXYY=
X-Received: by 2002:a05:6e02:24b:b0:32b:7258:70f1 with SMTP id
 w11-20020a056e02024b00b0032b725870f1mr1054618ilr.6.1682009523237; Thu, 20 Apr
 2023 09:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681906552.git.leon@kernel.org> <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
In-Reply-To: <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Apr 2023 18:51:52 +0200
Message-ID: <CANn89i+3SDjwYb=0CAuGgUyGieCqHKso9cHCf=iSKYhV3rdi=Q@mail.gmail.com>
Subject: Re: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 2:19=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Failure to add offloaded policy will cause to the following
> error once user will try to reload driver.
>
> Unregister_netdevice: waiting for eth3 to become free. Usage count =3D 2
>
> This was caused by xfrm_dev_policy_add() which increments reference
> to net_device. That reference was supposed to be decremented
> in xfrm_dev_policy_free(). However the latter wasn't called.
>
>  unregister_netdevice: waiting for eth3 to become free. Usage count =3D 2
>  leaked reference.
>   xfrm_dev_policy_add+0xff/0x3d0
>   xfrm_policy_construct+0x352/0x420
>   xfrm_add_policy+0x179/0x320
>   xfrm_user_rcv_msg+0x1d2/0x3d0
>   netlink_rcv_skb+0xe0/0x210
>   xfrm_netlink_rcv+0x45/0x50
>   netlink_unicast+0x346/0x490
>   netlink_sendmsg+0x3b0/0x6c0
>   sock_sendmsg+0x73/0xc0
>   sock_write_iter+0x13b/0x1f0
>   vfs_write+0x528/0x5d0
>   ksys_write+0x120/0x150
>   do_syscall_64+0x3d/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

While reviewing this patch, I also saw xfrm_dev_policy_add() could use
GFP_KERNEL ?

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index bef28c6187ebdd0cfc34c8594aab96ac0b13dd24..508c96c90b3911eb88063ad680c=
77af2b317c95f
100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -363,7 +363,7 @@ int xfrm_dev_policy_add(struct net *net, struct
xfrm_policy *xp,
        }

        xdo->dev =3D dev;
-       netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
+       netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_KERNEL);
        xdo->real_dev =3D dev;
        xdo->type =3D XFRM_DEV_OFFLOAD_PACKET;
        switch (dir) {
