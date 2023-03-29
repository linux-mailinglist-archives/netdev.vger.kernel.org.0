Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AB56CF0C1
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjC2RLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjC2RKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:10:34 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B60170F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:10:32 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id y35so9700444pgl.4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680109832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDmi5nIzQ70fO+hjyQnBiw9NgsY6gNFOjMjgjeQVLyY=;
        b=KXcn6zmbpN1M3gcya4O4ccYSiYOSrk7sCFSQ28QSSpmhG6AybjJemKXpkAj4MT0Dhr
         ywToksTDJF+/QQUfgaEizigYWE+PbHAJlyPL+6ierR+AVCqQ1t0oUeA6VTstfK8FxODV
         ofYz+eNYRzLMgeVGCcvu0B05EoSEhQCk9HWCFJOxMErywO0TczUw+u77tHfMxS0EjMKH
         hLNbic8bLfJ4lz2SbU/MOkWzuR733LyncrFdyqhtxOSTvOpaXhQ1jYnd3ovruWm1HytI
         e81yUWDcbmDLAn8V93ozWx1zcempx0O/RTsLTGtKORwQ06z8RoxGboIj69sjNpZ6M1No
         6CKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680109832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDmi5nIzQ70fO+hjyQnBiw9NgsY6gNFOjMjgjeQVLyY=;
        b=qTl0dxv/2cmJ31gNZP//HTueZOzYsIeyTpt3+PkbsKckM2nPrpwX6MugbU2v4xwS0T
         qXRYjFiTE3bkooBu34PoFOdbM3aeWO9isoHnwdfi/9jflNc1Ne/tQbmdfmJIu2nAfjtL
         MCKL5HDs9FQKCak5d34uK+Z7FwCd7yVKm+jcXsMV4+8q69NPS3bVfatKySkX93kJawPn
         R+Tz59iKOneX60EeLZggnU1NlZlAJWzoR7LMqh8UnSI8J+Mdy+Rj/g/mICWK+jS4SnNW
         W8vOtwGJq2ZRw8PY18vPJwRYSfuOr9tw8V7gabjVWfeyS15OEW5MJDcJ8VOXlMNs57Q8
         /Z6g==
X-Gm-Message-State: AAQBX9dqzylDUrN/Q8FiGZmMyWvvOURydO/3Jage9WJNkTkMrEYi8lbj
        5YquZmawVGqawlc3ARLLIrWap5Fhx0WJjY/Y4HNx3g==
X-Google-Smtp-Source: AKy350bWZdIG/SMXJ5jjXgQ+jvkVz1QEcKUw/EApMWnq33HK+hbMlilKegbYaO56L4/yrJAlzF34bRvpT1yKWbXyjCQ=
X-Received: by 2002:a63:444:0:b0:513:6b94:8907 with SMTP id
 65-20020a630444000000b005136b948907mr2794117pge.1.1680109831654; Wed, 29 Mar
 2023 10:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
In-Reply-To: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 29 Mar 2023 10:10:20 -0700
Message-ID: <CAKwvOdmcpESfN-9X2pzuxyj5q0wkH=kFwhaAhbaEJHwatyQLQA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: ti: Fix format specifier in netcp_create_interface()
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, trix@redhat.com, razor@blackwall.org,
        kerneljasonxing@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 8:08=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After commit 3948b05950fd ("net: introduce a config option to tweak
> MAX_SKB_FRAGS"), clang warns:
>
>   drivers/net/ethernet/ti/netcp_core.c:2085:4: warning: format specifies =
type 'long' but the argument has type 'int' [-Wformat]
>                           MAX_SKB_FRAGS);
>                           ^~~~~~~~~~~~~
>   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
>           dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##=
__VA_ARGS__)
>                                                                  ~~~     =
^~~~~~~~~~~
>   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_print=
k_index_wrap'
>                   _p_func(dev, fmt, ##__VA_ARGS__);                      =
 \
>                                ~~~    ^~~~~~~~~~~
>   include/linux/skbuff.h:352:23: note: expanded from macro 'MAX_SKB_FRAGS=
'
>   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
>                         ^~~~~~~~~~~~~~~~~~~~
>   ./include/generated/autoconf.h:11789:30: note: expanded from macro 'CON=
FIG_MAX_SKB_FRAGS'
>   #define CONFIG_MAX_SKB_FRAGS 17
>                                ^~
>   1 warning generated.
>
> Follow the pattern of the rest of the tree by changing the specifier to
> '%u' and casting MAX_SKB_FRAGS explicitly to 'unsigned int', which
> eliminates the warning.
>
> Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRA=
GS")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I am a little confused as to why the solution for this warning is
> casting to 'unsigned int' rather than just updating all the specifiers
> to be '%d', as I do not see how MAX_SKB_FRAGS can be any type other than
> just 'int' but I figured I would be consistent with the other fixes I
> have seen around this issue.

MAX_SKB_FRAGS might be defined by Kconfig, see:
 352 #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
in include/linux/skbuff.h. The Kconfig is declared in
net/Kconfig:254.

Because integer literals in C are signed, the cast is necessary to
avoid the format specifier from warning about the wrong signedness.
It would be preferable to have a `U` suffix on the literal value, then
the cast would be unnecessary.

Untested:
```
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 494a23a976b0..67cb6bfc4056 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -349,7 +349,7 @@ struct sk_buff;
 # define CONFIG_MAX_SKB_FRAGS 17
 #endif

-#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
+#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS ## U

 extern int sysctl_max_skb_frags;
```
Perhaps other code using MAX_SKB_FRAGS might have to worry about
signedness and conversions.

But I think what you have is fine for now.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Though the above might be a longer-term solution since this might pop up ag=
ain.

> ---
>  drivers/net/ethernet/ti/netcp_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/=
ti/netcp_core.c
> index 1bb596a9d8a2..d829113c16ee 100644
> --- a/drivers/net/ethernet/ti/netcp_core.c
> +++ b/drivers/net/ethernet/ti/netcp_core.c
> @@ -2081,8 +2081,8 @@ static int netcp_create_interface(struct netcp_devi=
ce *netcp_device,
>         netcp->tx_pool_region_id =3D temp[1];
>
>         if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
> -               dev_err(dev, "tx-pool size too small, must be at least %l=
d\n",
> -                       MAX_SKB_FRAGS);
> +               dev_err(dev, "tx-pool size too small, must be at least %u=
\n",
> +                       (unsigned int)MAX_SKB_FRAGS);
>                 ret =3D -ENODEV;
>                 goto quit;
>         }
>
> ---
> base-commit: 3b064f541be822dc095991c6dda20a75eb51db5e
> change-id: 20230329-net-ethernet-ti-wformat-acaa86350657
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
Thanks,
~Nick Desaulniers
