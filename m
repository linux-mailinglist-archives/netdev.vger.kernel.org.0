Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC195703FF
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiGKNQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiGKNQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:16:24 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25953F335;
        Mon, 11 Jul 2022 06:16:21 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-10c0119dd16so6631543fac.6;
        Mon, 11 Jul 2022 06:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3w648xSE+rcJKTvNdyXERDjQNCJb3jaHtEQzPygYFY=;
        b=iX4ZaqHu72v0xD/rGJLs5RBCMorkup6Zpug1ld/RhBeeDwfdDOCfSAx1pqWGit6Pw0
         1NSiKv14MkaDc/07mOyOkc52bTekpdbzZjsUp0+aTTADL/NXO/mRXtuymP0l6iJDSQP4
         fdaEqFQAQAGMBpUus7TqrV+DjIfzYjK/0ckyFONHPI44EuwvgTfD/x74fveRRbauW+Ts
         dK63F0Fy4xh5lbmLcsUWqAgV7Scdfq4B28UNu1no6KQEgq3n5ul80Ce090W9rrOHzpcH
         69YwITAaobSKbZDKcMO6QXqQY0biuv0y2Gu/1eyT/ZzugX9BAiH4eEcuGfW+IImSwfR0
         Q8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3w648xSE+rcJKTvNdyXERDjQNCJb3jaHtEQzPygYFY=;
        b=Xj5iq8ecbotCgfceFakb9lPhQSDZ+YBb0542OtjD/Fcwf3UFgIzkjAc6l+eU0Y8Jlz
         ismxOSh9h+K+gCgu0Id13IhYufZt3iVzxhN0AIBIxeUIQbhG9FKExHvJSZe5IzpYvTox
         tNuajjtSUVy6XKSfF2vLWxw4+3wkid4aLNT3ZV1I4rad2Fk4uYkx6pI4A07u+2wtew8q
         AltnBCrL0rsvf8QvQNZRuj+Y1Kl7PUCxo4SHhS6AxgTwT8Fx0I2rMXgq5aPFn+93ny06
         +eBqJwS1PWihmMIw4cjrNZ7OmYER5GgYOzweH7Df9tm6LD+ttPYu+zYWlmxxxwRx836L
         Tnhg==
X-Gm-Message-State: AJIora+rMxLN1P5ufetwazgw3DeKfknZzWZPYsCs+HtzDPBu0YEHNdgU
        RUOU7IFVwG/Rd108l8er1p7A9mcP/LK5odLtyUU=
X-Google-Smtp-Source: AGRyM1vHUwMfzsAuyFfGAtwXj66YEBhPY1/EKrt5hIUCsTBDWoEbm6tCw4w8T9poyEk0kDAxCe/USrdGcFWqXAfF4Cs=
X-Received: by 2002:a05:6870:c093:b0:10c:4f6f:d0ab with SMTP id
 c19-20020a056870c09300b0010c4f6fd0abmr7254468oad.194.1657545380424; Mon, 11
 Jul 2022 06:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220711005319.2619-1-liubo03@inspur.com>
In-Reply-To: <20220711005319.2619-1-liubo03@inspur.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 11 Jul 2022 16:16:08 +0300
Message-ID: <CAHNKnsSoBMDC4P1nFXT+FGDyGYKSinLyhPDCNZ3RdQgkNA9f3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] net: wwan: call ida_free when device_register fails
To:     Bo Liu <liubo03@inspur.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
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

Hello Bo,

generally the patch looks good to me, but it needs improvement in the
wwan_create_dev() part. Sorry that I missed this part in the previous
review. See details below.

On Mon, Jul 11, 2022 at 3:54 AM Bo Liu <liubo03@inspur.com> wrote:
>
> when device_register() fails, we should call ida_free().
>
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  Changes from v1:
>  -Add a Fixes tag pointing to the commit
>
>  drivers/net/wwan/wwan_core.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index b8c7843730ed..0f653e320b2b 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -228,8 +228,7 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
>         wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
>         if (!wwandev) {
>                 wwandev = ERR_PTR(-ENOMEM);
> -               ida_free(&wwan_dev_ids, id);
> -               goto done_unlock;
> +               goto error_free_ida;
>         }
>
>         wwandev->dev.parent = parent;
> @@ -242,7 +241,7 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
>         if (err) {
>                 put_device(&wwandev->dev);
>                 wwandev = ERR_PTR(err);
> -               goto done_unlock;
> +               goto error_free_ida;
>         }
>
>  #ifdef CONFIG_WWAN_DEBUGFS
> @@ -251,6 +250,8 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
>                                            wwan_debugfs_dir);
>  #endif
>
> +error_free_ida:
> +       ida_free(&wwan_dev_ids, id);
>  done_unlock:
>         mutex_unlock(&wwan_register_lock);
>

This hunk misses the case of a successful device registration. After
patching, the code will look like this:

    err = device_register(&wwandev->dev);
    if (err) {
        put_device(&wwandev->dev);
        wwandev = ERR_PTR(err);
        goto error_free_ida;
    }

    wwandev->debugfs_dir =
debugfs_create_dir(kobject_name(&wwandev->dev.kobj),
wwan_debugfs_dir);

error_free_ida:
    ida_free(&wwan_dev_ids, id);
done_unlock:
    mutex_unlock(&wwan_register_lock);

As you can see, even if the device will be registered successfully,
the allocated id will be unconditionally freed.

The easiest way to fix this is to add "goto done_unlock" right after
the debugfs directory creation call. So the hunk should become
something like this:

@@ -249,8 +248,12 @@ static struct wwan_device *wwan_create_dev(struct
device *parent)
        wwandev->debugfs_dir =
                     debugfs_create_dir(kobject_name(&wwandev->dev.kobj),
                                           wwan_debugfs_dir);
 #endif

+      goto done_unlock;
+
+error_free_ida:
+       ida_free(&wwan_dev_ids, id);
 done_unlock:
        mutex_unlock(&wwan_register_lock);

-- 
Sergey
