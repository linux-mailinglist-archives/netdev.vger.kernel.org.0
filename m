Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A40583C77
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiG1Ksz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbiG1Kso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:48:44 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10E41013
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:48:40 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r14so1544926ljp.2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EYLN2VgFPShJvkoh7oJtGxXStSJxN1cfz1bpPXRcJLM=;
        b=a+Dj/mYhB8H1Bp+5HLk5zHgeUYIKBPfd7Yo+ipogyQ3BXiEoDKeRLhR1S/YwL2OmaS
         E1A06DTnla0zeAljOyHhRQMruZlceg6qHB9sQGGoJrvAPWsJot3Zvi8gJBXzakTKzYhP
         7sZ1Nz+zP+fVgCfS2JlVWNUeXkWgJNZyHBbKuT6BOmWOr/7L9y8N9AurxpWGAb1nf338
         mmPyfVLmA70r8mCWrfeNwPur8tNSKVSth3eixf4nGGuSrIrHJA812nUGMCPns59eXjR9
         iTtB0qopT7eOf4W2US7gjDOS+JfO3InU/ZOaYdYSKEobdJMyBu/tVYAjV3JIvyvIrtic
         f/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EYLN2VgFPShJvkoh7oJtGxXStSJxN1cfz1bpPXRcJLM=;
        b=yAXEk1pDA6o4/EXxULYrAMsgj3KU8J1a3weLQVX13J/kogMqKdmUN88hS5IDaITx3f
         /JhDS7OOA1MTI9z4qRyBZtSvj/Yk80H8uaYmyCKnOooTjxzD1KeiPVsAgmnnycb3iPjl
         2kixOlewkukugez5Qb6tAkCSRII5J1OSgfQOmQZzFBV3u9xiwjIT7opqpcWzFnB13pHG
         lZjl5lh40jEtYC29UE67nLSashvVflljyU9T4Tm0bR8NtoxjB3JL26SWcTX9vJqeOIif
         g/YO9cv5rst29CWuzggCvYwNUvs2LXrpHDunqjLfnYterkxLUhJJQHCQIYKLO0n0W20T
         XwDQ==
X-Gm-Message-State: AJIora/ez3DjQaS6mFPJbJJQ7TMS+1eVA8Gg0BDgkwbY45FKC9pEQviT
        2a0p1HoCCD5j35sTDtjKb8yfRXR+M1CFQcV/qksdXg==
X-Google-Smtp-Source: AGRyM1v0PalcgYlIcJ0DZQcgyrxJwJ31CaZnUffSCZOp+2Ho1FbpEAoopHkS2fCpuqbTQnTWL1WcoxUwQCKwOJPqYTo=
X-Received: by 2002:a05:651c:1147:b0:25d:eb36:755d with SMTP id
 h7-20020a05651c114700b0025deb36755dmr8521602ljo.16.1659005319133; Thu, 28 Jul
 2022 03:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220727185012.3255200-1-saravanak@google.com> <20220727185012.3255200-4-saravanak@google.com>
In-Reply-To: <20220727185012.3255200-4-saravanak@google.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 28 Jul 2022 12:48:02 +0200
Message-ID: <CAPDyKFrBuNfs5-mQbtGMjokxAFrbJ5rmQw3tgks16p0mO0uuNg@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] Revert "PM: domains: Delete usage of driver_deferred_probe_check_state()"
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, naresh.kamboju@linaro.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 at 20:50, Saravana Kannan <saravanak@google.com> wrote:
>
> This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.
>
> There are a few more issues to fix that have been reported in the thread
> for the original series [1]. We'll need to fix those before this will
> work. So, revert it for now.
>
> [1] - https://lore.kernel.org/lkml/20220601070707.3946847-1-saravanak@google.com/
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 3e86772d5fac..739e52cd4aba 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2730,7 +2730,7 @@ static int __genpd_dev_pm_attach(struct device *dev, struct device *base_dev,
>                 mutex_unlock(&gpd_list_lock);
>                 dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
>                         __func__, PTR_ERR(pd));
> -               return -ENODEV;
> +               return driver_deferred_probe_check_state(base_dev);
>         }
>
>         dev_dbg(dev, "adding to PM domain %s\n", pd->name);
> --
> 2.37.1.359.gd136c6c3e2-goog
>
