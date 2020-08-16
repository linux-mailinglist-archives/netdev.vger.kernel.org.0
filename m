Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7202459AF
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgHPVVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 17:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgHPVVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 17:21:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2246C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:21:42 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y2so6294730ljc.1
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 14:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jLdvBxkhgXN8QYtBsA/9F246LrrD9Upsa4yWFJN4e9o=;
        b=a0aLRcylV4FKVPVM3ukc/msOCx1eufp0WQF1lBykwaAxpQkcCNrZDigRQPKiP5JSFE
         +DMJVmyA9TAyxFvU9EDmHRgRMcWS/shgOHuMlApPwBCxrGyt53EOjwzjpDy/i4GFK4hK
         KtDVW6vZZq/dq+1leLeuzg8tn6oPOFL0xnYUPGOCFWWkvhivQRGyz0X1ygelpOn1FDiU
         McJissZjSGON4Z6RV9B31IdkMmFJzdcGfFKRBWFKcH0HeZH/jz5KrJB44zOabdBunhHQ
         ji4gflwdG2T3cOxXbNi7+bbxMNjYJAex+9gnZRa0gRwZ2P48myFGa3M2ME7Wazyrg6pO
         UkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jLdvBxkhgXN8QYtBsA/9F246LrrD9Upsa4yWFJN4e9o=;
        b=WMVHRN1Y2LWNoQhPg90FFCVSn9mabHEw76gI5Ln/BMVVqpBMgIhn3PWha4laOu6Li3
         +JuJWo6tYYTHt5OH+pmxeAsKILunk5nohTza6RaUArJSf7jJdcwumzYwlId38NzNka+a
         fidHpJJguSvUBR+NI/m/S8dXU4/V91xZirHySb/Q2XQn8FS6R6o2xwwQvysIX8R1nfyK
         /WGyOeHyEJXvJqJEFFUnGq7rHst3av9DtRCSWYbYaryFaGn6yzSyL5nih60a5rV2QYZY
         D4s/S7sMQOROAA87o6kpY06XabbYoHbD4U5lA5VZ+qKEh0ur6621yj449aSp56TG8q+X
         0vug==
X-Gm-Message-State: AOAM5307IpdOKZ/JnQnoiQ3DVPB5TyVnOWfYXxz/reYE3cCdh01/SqFu
        9XT4Y8R6VU14sQ/88EfprnDW25q811N9eLchtmc=
X-Google-Smtp-Source: ABdhPJz78ewlSLhG7f8ufGSvTItcfAKzZNneTuiE7XA0AVS895FJpPX0hbmO+PgqshN40o04VavspteTIfAJriZUBlg=
X-Received: by 2002:a05:651c:294:: with SMTP id b20mr5561304ljo.4.1597612901249;
 Sun, 16 Aug 2020 14:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200816192638.2291010-1-andrew@lunn.ch>
In-Reply-To: <20200816192638.2291010-1-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 16 Aug 2020 14:21:30 -0700
Message-ID: <CAFXsbZoszFgR7vXfNHQcTnK=c2Y1+=hLuQHHh36fAfsGxozPmQ@mail.gmail.com>
Subject: Re: [PATCH] net: devlink: Remove overzealous WARN_ON with snapshots
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, jiri@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch applied, I no longer experience the kernel warning messages.

Tested-by: Chris Healy <cphealy@gmail.com>

On Sun, Aug 16, 2020 at 12:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> It is possible to trigger this WARN_ON from user space by triggering a
> devlink snapshot with an ID which already exists. We don't need both
> -EEXISTS being reported and spamming the kernel log.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/core/devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index e674f0f46dc2..e5feb87beca7 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4063,7 +4063,7 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
>  {
>         lockdep_assert_held(&devlink->lock);
>
> -       if (WARN_ON(xa_load(&devlink->snapshot_ids, id)))
> +       if (xa_load(&devlink->snapshot_ids, id))
>                 return -EEXIST;
>
>         return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
> --
> 2.28.0
>
