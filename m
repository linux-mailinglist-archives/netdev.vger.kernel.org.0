Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBE76422B6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiLEFZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiLEFZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:25:30 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03D19591
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:25:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id v206so13108369ybv.7
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 21:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h8AkiS2Qfxp4kAJlb5zxEpYsW01DD5z1qyB1/NcGlCU=;
        b=jRMfCPVIXHdaUPlDFQX14oqQwK/ECBMzc+1qN6zwVN90FJM+Uee6n6QODpuu3UhVfY
         1klgUmDInvjv/yf5Fd79wrynLJeg0sfU7gtF+0iawuIY8wYTib+HWsyDuBQc0psygD1L
         q8V3Ltl3iEXghaA1Crzyg8EnHSBfUGBT9ll+7xoX9ZH55t+YNIWGk79B8Lt9m1Qe+yGf
         Qgc2teWHmNo5j3rvOccKHA1orS36SbOKU1vN/o+LjOudpRy72n42CzPgjzkmGeTe8Z/9
         91Aku0G41bWd2XJZJotted3NkqW0UybR64KuC7l0EOk18PPyzWyHlQn+mLackLiAVPvm
         aZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h8AkiS2Qfxp4kAJlb5zxEpYsW01DD5z1qyB1/NcGlCU=;
        b=GY2y+G5GqDw/LMnU9Lgpa5oDOEvH2vZquYI1/kD3Q4N5Y9yL/bDnYNhqVs72YdIXH7
         TwymnY/uPmRSHG5+OtxgzRxQnPlMQQ83u2BqsPHO9RoxUhqP3jWCoFZTs12RFmnro2ZD
         QUc0cH5aM7rLCGnD4YtDpM6rp4zVkU5ecBsddvCrk8+4cC3/L91h/VebL16E13tIi1CL
         P8+uW+/f84K77YbcZu6anE9SJEbhRi6j4FdgkbJ9TIab1vowlT/AfSogdQPGaxkWKES3
         YgDWawlsQvDOCzsU9jIROk+Wr2WHxH5r/TsdMAGrTV2JInnfMILs7jg3KkQ8HeVc0WEO
         xGOw==
X-Gm-Message-State: ANoB5pkCs/6xshJEeBv6HIEItjGmkEFUKv1Z94B5k3NE8sJKzIMAzwSN
        y2MeMePTUcmytz+zCkfhe2kxd1QxodGTbxd5dkR8Sg==
X-Google-Smtp-Source: AA0mqf6CuUZoAffgj4lZ4AOfj/mxkdpNHXOHGtOqAIbKcbvfSRxACN2WnuOEJVOcB3Z2Hbx1dX8FUOOTGLV7sH1tqL0=
X-Received: by 2002:a25:d655:0:b0:6fc:1c96:c9fe with SMTP id
 n82-20020a25d655000000b006fc1c96c9femr16557533ybg.36.1670217901547; Sun, 04
 Dec 2022 21:25:01 -0800 (PST)
MIME-Version: 1.0
References: <adc33d6c7dd01e29c848b9519b6a601219ba6780.1670086158.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <adc33d6c7dd01e29c848b9519b6a601219ba6780.1670086158.git.christophe.jaillet@wanadoo.fr>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 06:24:50 +0100
Message-ID: <CANn89i+YnmoAunWzwG1KvCH0WUOCXfA6SztW3Xdf0vN4QktRGQ@mail.gmail.com>
Subject: Re: [PATCH] packet: Don't include <linux/rculist.h>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

On Sat, Dec 3, 2022 at 5:49 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> There is no need to include <linux/rculist.h> here.
>
> Prefer the less invasive <linux/types.h> which is needed for 'hlist_head'.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Let see if build-bots agree with me!
>

net/packet/af_packet.c does not explicitly include linux/rculist.h

It might be provided by include/linux/netdevice.h, but I wonder if
this is best practice.

> Just declaring 'struct mutex' and 'struct hlist_head' would also be an
> option.

I do not get it, see [1]

> It would remove the need of any include, but is more likely to break
> something.

I do not see why you are even trying this ?

> ---
>  include/net/netns/packet.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/netns/packet.h b/include/net/netns/packet.h
> index aae69bb43cde..74750865df36 100644
> --- a/include/net/netns/packet.h
> +++ b/include/net/netns/packet.h
> @@ -5,8 +5,8 @@
>  #ifndef __NETNS_PACKET_H__
>  #define __NETNS_PACKET_H__
>
> -#include <linux/rculist.h>
>  #include <linux/mutex.h>
> +#include <linux/types.h>
>
>  struct netns_packet {
>         struct mutex            sklist_lock;

[1] Definition of 'struct mutex' is definitely needed here.

> --
> 2.34.1
>
