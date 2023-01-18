Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0521C67113F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjARCik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARCij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:38:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4194D4FC0B;
        Tue, 17 Jan 2023 18:38:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x10so44908565edd.10;
        Tue, 17 Jan 2023 18:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ddle79ToA5Bpr6HlzIXW7XP/tPvJO0M1hIh+6wWxTyo=;
        b=IlmvO7TKNh2nK2vJHhzcr7t37yCVF9dZp0Y+0f9GGWT917TX87O1eLNNRHFgAtF4WC
         ryH4AMVhOJR9TPF+7W8m3S4FpSwOSLs1UyyZKXQw712/dVDJxreUZZvElKha9EP5uSR9
         6AQXiVZHDZEOwG8rg90hNkwplfvr/E0L4OUbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ddle79ToA5Bpr6HlzIXW7XP/tPvJO0M1hIh+6wWxTyo=;
        b=xWFdWB4UUvm+JkBTkRCvX1I2vfq/wgjK7xaVZEnxQwenbgOA3C4l3G7yv5dGzS2A+G
         idXq6A74THPOLgRNcNbCal0NQjRyOlGpMRNcv3O9eFrVUG01rI1nfwlJADDywI3RpRKJ
         ngmTYfXXIHu6431OfuajdrxNdZl0yzODKQJjTp/L9fKhOpXOE4XodhXYkdeUfx61u1/W
         xImlFJrnATJfFPBbVwQ7VxrUc66UOAORIGepMHVSirElIRw6PSnmiDUbrAKV4KvLPaZF
         1aglhzxMiAl78JFV4lC0F4HBiM0nD6fLlfcgypboq34xTONwx1Ivxe4DJvOmzYVPO25l
         6jog==
X-Gm-Message-State: AFqh2kreP2gcaXJnS9qygI3oWMp5JJ70l8Daw2AoY5lbAi7Qtzt6iJOU
        Y2rPnmpkGstz4+CD6VKb8twkXUgN40hx5Bh5ZZ8=
X-Google-Smtp-Source: AMrXdXu4mQ/ljXNqUeyIfURUtsQWcFG38FnD62YdKNkxKIrsEy2bCfDuK9365sT/beFFy5Hb334q77gAdC/PXrwjnJk=
X-Received: by 2002:aa7:dd59:0:b0:49c:8b1f:b9d with SMTP id
 o25-20020aa7dd59000000b0049c8b1f0b9dmr620012edw.289.1674009516784; Tue, 17
 Jan 2023 18:38:36 -0800 (PST)
MIME-Version: 1.0
References: <20221202212418.never.837-kees@kernel.org>
In-Reply-To: <20221202212418.never.837-kees@kernel.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 18 Jan 2023 02:38:24 +0000
Message-ID: <CACPK8Xde2zgr5c-Oy30+3HM6PoGf+=1YdEJuYpsHL2CVVDvOoA@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Silence runtime memcpy() false positive warning
To:     Kees Cook <keescook@chromium.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Dec 2022 at 21:24, Kees Cook <keescook@chromium.org> wrote:
>
> The memcpy() in ncsi_cmd_handler_oem deserializes nca->data into a
> flexible array structure that overlapping with non-flex-array members
> (mfr_id) intentionally. Since the mem_to_flex() API is not finished,
> temporarily silence this warning, since it is a false positive, using
> unsafe_memcpy().

Thanks for sending the fix Kees. I got a bit busy towards the end of the year.

I spent some time looking at how the netlink api was used, and tried
to convince myself that a user couldn't send an OEM command that
triggered the overflow. It all got a bit tangled up so I didn't come
to a conclusion.

Cheers,

Joel

>
> Reported-by: Joel Stanley <joel@jms.id.au>
> Link: https://lore.kernel.org/netdev/CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com/
> Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/ncsi/ncsi-cmd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index dda8b76b7798..fd2236ee9a79 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -228,7 +228,8 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
>         len += max(payload, padding_bytes);
>
>         cmd = skb_put_zero(skb, len);
> -       memcpy(&cmd->mfr_id, nca->data, nca->payload);
> +       unsafe_memcpy(&cmd->mfr_id, nca->data, nca->payload,
> +                     /* skb allocated with enough to load the payload */);
>         ncsi_cmd_build_header(&cmd->cmd.common, nca);
>
>         return 0;
> --
> 2.34.1
>
