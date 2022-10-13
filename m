Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40835FDD49
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJMPhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJMPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:37:21 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB27BC60C
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:37:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 203so2468044ybc.10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gFTFokgNHTGaQylOsGEna9aC1ySQtkamEeN27nYYtMo=;
        b=ZfLz0QdiG9JBjp7/wEbV0kPjVt5hjZm/ZfmjnY7krnW3YJ51i4IZNCm/42GSkTLfsi
         96OYRIV113x7VnJuK0maHfWcnG8QFdVZIjHe/0PNePOvzphvuxlgmYwqSAd+Sb5FUOSd
         XpcqG7xnc/ayC4mGz7aPyPDM+koPWVNEfndV/AQr7XoatkXvw/DbdiOOgPATeZWELPch
         loJ5aCEYuTaZiSCH6eohOgmCB3LoCp7/MYBx/4P4+x8XF+v3ZK/nY38AoaHpgIP8aHMz
         241UX7NA0+zvmIw4JsTmNUbAurwfxxl+Vn8spwjRfKusHAORCRndam+Fh33IAn3iSh0w
         nOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFTFokgNHTGaQylOsGEna9aC1ySQtkamEeN27nYYtMo=;
        b=EoykxTZR71kJxSWeXUqNHA2ZVGPqbxfkwzhsnHgpCZ/UqWFJyskLfQFs8jRI5DqyMJ
         9LHpim/whLe5DXRBeJ2awrQeIJhRFJoRw2d08iw3scCoIYWNVJUPzMBhk5vOVmuKfdRh
         wRhQZhogfzyV9dpukCJAWlEqHPfbqON9pbbEopf1ost8jC6r7PfjpnU6O2y1PX3gT4EI
         bUkaq+vbVsnr24RJzZOU80WdtQjgYayvcyZxufm170y7hjnXbzAwLwOhhwboCS+jhgyd
         3a/aMXm8OuiWM3Kxdt7mXcKBGUpglAQMy1EtftVyISChU2G20TexnK1+nc6fIZAdgC1W
         0S9g==
X-Gm-Message-State: ACrzQf0I/vIO8agH5x0mMq3xAFyRYI0N5cMo/fAgtcCa+/Ejb79deC4a
        w8ZE4tcbHGrPDsEMm0U0r20XBZgASYo2ZGwcu2Dqug==
X-Google-Smtp-Source: AMsMyM6rJSajVfrXSduoobUcD898rHe8tr9JXQscVFW1kDtIR1T+kP3FtiVCYE63367gGKceFY3ty5zTsJzzc9y3p54=
X-Received: by 2002:a25:ccd0:0:b0:6bf:d596:72ff with SMTP id
 l199-20020a25ccd0000000b006bfd59672ffmr542750ybf.598.1665675439989; Thu, 13
 Oct 2022 08:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20221013151901.29368-1-cppcoffee@gmail.com>
In-Reply-To: <20221013151901.29368-1-cppcoffee@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Oct 2022 08:37:08 -0700
Message-ID: <CANn89iKJQCmEPxf=296_dGt9Wb3MD=0mp0vP6X4exWUPML=UUw@mail.gmail.com>
Subject: Re: [PATCH] net/atm: fix proc_mpc_write 1 byte less calculated
To:     Xiaobo Liu <cppcoffee@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Oct 13, 2022 at 8:19 AM Xiaobo Liu <cppcoffee@gmail.com> wrote:
>
> Then the input contains '\0' or '\n', proc_mpc_write has read them,
> so the return value needs +1.
>
> Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
> ---
>  net/atm/mpoa_proc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
> index 829db9eba..444ceda60 100755
> --- a/net/atm/mpoa_proc.c
> +++ b/net/atm/mpoa_proc.c
> @@ -224,8 +224,11 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
>                         free_page((unsigned long)page);
>                         return -EFAULT;
>                 }
> -               if (*p == '\0' || *p == '\n')
> +
> +               if (*p == '\0' || *p == '\n') {
> +                       len += 1
>                         break;
> +               }
>         }
>
>         *p = '\0';
> --
> 2.21.0 (Apple Git-122.2)
>

Hi Xiaobo

Can you submit a v2, with this added tag ?

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Also, I would switch to something cleaner like

diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 829db9eba0cb95ac9cfe775e8eaad712943a8dbe..df530e9725fa63820a7adcd44e750db0733f9d94
100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -219,11 +219,12 @@ static ssize_t proc_mpc_write(struct file *file,
const char __user *buff,
        if (!page)
                return -ENOMEM;

-       for (p = page, len = 0; len < nbytes; p++, len++) {
+       for (p = page, len = 0; len < nbytes; p++) {
                if (get_user(*p, buff++)) {
                        free_page((unsigned long)page);
                        return -EFAULT;
                }
+               len++;
                if (*p == '\0' || *p == '\n')
                        break;
        }
