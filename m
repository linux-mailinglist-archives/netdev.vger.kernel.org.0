Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823CF524CDE
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353757AbiELMbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353748AbiELMba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:31:30 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25C644A34;
        Thu, 12 May 2022 05:31:27 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ba17so6059451edb.5;
        Thu, 12 May 2022 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bq27qi36uNFUZk8ZL5NHNoP0jxC4Lj73Ft3Qq22TL74=;
        b=Qk8rV4hBpcnrZIIFrzc/vy+LEr0x/YF0jGYVH/2JoeLnlhcEkoEyW6u7MCYVLBpTwW
         0UumpuhBgXYujASXv6zPNQZE/t+l0dy7fEFjfdVJgM4hX1FP1FiLxVdPW93dDS05NOz9
         Va5lU5hHPLCevXlTLXD7RuJ4W/qoEQU3bPLWhxTP3kEnRp8HN8hdzpZm3j+WsSWN8R2S
         yFH9GuhpHb3xXHpWdtMMIUuPlFhk8sajKQ2vum+CAhDPwsEtrkmP3SiIxzTHM/dkjixI
         MzjhrM/YG+Brra4Rn5sGf0fpAa545XCgKJEwAuQu/gWEx4/k2Ou5DzGO5noNhyqVxsX3
         Gh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bq27qi36uNFUZk8ZL5NHNoP0jxC4Lj73Ft3Qq22TL74=;
        b=NtvvU7Oe2c80eFjC3Rqz5Q2IjDljxviiXkUaBlJzY5kILB2chNJCLxUSjXisKKBNg1
         vfa3Qf3mEEAJgi58y3wzeej4RkJ/8aFC3RV5i11Ie+0FNSAQjErz94GIsq7bVEt4QdyI
         ZCJHrGRLnQ/WdDwl9dbgT/mYhKZYUhdPUpT7g7LHSQacbUsWvH3G5+UTk4gI1w8R1w99
         QDz+AYeX2kUcfyXAAKyYOYlsTXndd73Z0WiqsW01T5UY5N3mAxCece8dJcZcuaFx1pfM
         UuXwX6AAThrZFf4oVTv9jZfTjDQBRS3uDP/uwjDTgvMMpWrUfyPIDhTGKbdLZnI81I5x
         uvZQ==
X-Gm-Message-State: AOAM531TTTht5FCHOq4dd4aGewwPNWSevE4X7fgeP21XotR/Jth5RQQD
        pxF604HFBvE9kBXH0N38kE7hOmv6K/nAgRsDTAE=
X-Google-Smtp-Source: ABdhPJxgS+gzIYhIWSduRKTHnDYBo2Hhbf1EvSfO1rLZIPmd6sXvnqror3k4ncBq1qt3HJCjLcuDwDS5zZN3zQDyQPM=
X-Received: by 2002:a05:6402:1f0b:b0:427:b390:2020 with SMTP id
 b11-20020a0564021f0b00b00427b3902020mr34676701edb.70.1652358686409; Thu, 12
 May 2022 05:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220512062629.10286-1-imagedong@tencent.com>
In-Reply-To: <20220512062629.10286-1-imagedong@tencent.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 12 May 2022 20:31:14 +0800
Message-ID: <CADxym3Zqe=9TA_JBYCEX2tqeVxLN_LbH_F_zQuoXBG4XK=mc7g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: skb: check the boundrary of skb drop reason
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin Lau <kafai@fb.com>, Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>, asml.silence@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        vasily.averin@linux.dev,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 2:26 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In the commit 1330b6ef3313 ("skb: make drop reason booleanable"),
> SKB_NOT_DROPPED_YET is added to the enum skb_drop_reason, which makes
> the invalid drop reason SKB_NOT_DROPPED_YET can leak to the kfree_skb
> tracepoint. Once this happen (it happened, as 4th patch says), it can
> cause NULL pointer in drop monitor and result in kernel panic.
>
> Therefore, check the boundrary of drop reason in both kfree_skb_reason
> (2th patch) and drop monitor (1th patch).
>
> Meanwhile, fix the invalid drop reason passed to kfree_skb_reason() in
> tcp_v4_rcv().
>

tcp_v6_rcv() is forgeted, I'll send a V2 :/

> Menglong Dong (4):
>   net: dm: check the boundary of skb drop reasons
>   net: skb: check the boundrary of drop reason in kfree_skb_reason()
>   net: skb: change the definition SKB_DR_SET()
>   net: tcp: reset skb drop reason to NOT_SPCIFIED in tcp_v4_rcv()
>
>  include/linux/skbuff.h  | 3 ++-
>  net/core/drop_monitor.c | 2 +-
>  net/core/skbuff.c       | 5 +++++
>  net/ipv4/tcp_ipv4.c     | 1 +
>  4 files changed, 9 insertions(+), 2 deletions(-)
>
> --
> 2.36.1
>
