Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7C2349D07
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhCYXvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhCYXuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 19:50:39 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90066C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 16:50:38 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y1so5316588ljm.10
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 16:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbsnYzAr1vIwu63VeM0+zYhvC4ZXoIEN09OHYbDZCuE=;
        b=p1D9ev92CKCLw6WbOgKo/piH3PjpYqTOqXfvomxaawWjNFFLi/9O1B3ImfggOkvM6g
         l1LOqefJzNCLtaIpNaJMps7OtkSQMbrOXQVJ6TOD7G9Z/pUXGl7oUZluzkqrR3jCoFA8
         /fQFTQ/F1vFC6Sv1miBsjQ0E85tXm+yWNYq/Nt1Tvc1VpwNZL7WupeZCA8cDXFCNGUmg
         s3t0JWr09kVE6lovfoKxRTLYGQtDni+CAzOZR7I/v3yiau4RhjUNX+CQPym1CdUxEvAb
         vCFQvYYHn+vfDIYHH8TFqE/18BocUCYtGoPb5jMaJHJqNbhbs7PFALUArXzh8Lay7Xtk
         O+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbsnYzAr1vIwu63VeM0+zYhvC4ZXoIEN09OHYbDZCuE=;
        b=T6g4nQmuGeC+A8Tj6o+weafampBp/HEluEqWt5i4a+cgvhnzMrtbtLWdTXrZJmY7QE
         Nj7pUbClL0YV3ttBF1Fm12MmG9tyXO5t66I3VRcKjNarGxYU966wUWfVDA6La5lgv8Zv
         aErw5ckYhmtKf5SH6iiN6P9B3mLLzVroK0Tg40i0HUnjqOiIBTC59A9LcPKgevLSi7k9
         Th/eM5vfzltEqF4uZ1Ygrv6+ZCXuLQWY4JkTIiwZRkmEwKBpb/Ek1NxTPJTNLt1Xg6XK
         zGacFQulC2uvVNYudL/0s1gxhpszjjJ8bFvUi6mOzkBqA2o4If3MSW5tdoEbMHbqBH1n
         qmyg==
X-Gm-Message-State: AOAM530Oun8+560CMIAAJMDI9AIdOQBDoFa0c+zTzor7DMStOx05hpzh
        mdq7coc9rHHXjntZYZkgx5wDOd5wToWERqGmP0BRKw==
X-Google-Smtp-Source: ABdhPJzTJm9NlCiw4eXdvem2Z84ESR1B6gb7koRUPIt6hevVHeY8aDHW22DlLW8QflmOUNBMdc0p9ubbz9ygsGxweQw=
X-Received: by 2002:a2e:9f45:: with SMTP id v5mr7121903ljk.183.1616716236496;
 Thu, 25 Mar 2021 16:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <1616658992-135804-1-git-send-email-huangdaode@huawei.com> <1616658992-135804-2-git-send-email-huangdaode@huawei.com>
In-Reply-To: <1616658992-135804-2-git-send-email-huangdaode@huawei.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Thu, 25 Mar 2021 16:49:56 -0700
Message-ID: <CAH_-1qyg9xxCkRQWqMpughTzigBLfhVoAyZzyX32Rmq2t7YqrQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: gve: convert strlcpy to strscpy
To:     Daode Huang <huangdaode@huawei.com>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Kuo Zhao <kuozhao@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 1:01 AM Daode Huang <huangdaode@huawei.com> wrote:
>
> Usage of strlcpy in linux kernel has been recently deprecated[1], so
> convert gve driver to strscpy
>
> [1] https://lore.kernel.org/lkml/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL
> =V6A6G1oUZcprmknw@mail.gmail.com/
>
> Signed-off-by: Daode Huang <huangdaode@huawei.com>

Reviewed-by: Catherine Sullivan <csully@google.com>

> ---
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index 0901fa6..e40e052 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -14,9 +14,9 @@ static void gve_get_drvinfo(struct net_device *netdev,
>  {
>         struct gve_priv *priv = netdev_priv(netdev);
>
> -       strlcpy(info->driver, "gve", sizeof(info->driver));
> -       strlcpy(info->version, gve_version_str, sizeof(info->version));
> -       strlcpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
> +       strscpy(info->driver, "gve", sizeof(info->driver));
> +       strscpy(info->version, gve_version_str, sizeof(info->version));
> +       strscpy(info->bus_info, pci_name(priv->pdev), sizeof(info->bus_info));
>  }
>
>  static void gve_set_msglevel(struct net_device *netdev, u32 value)
> --
> 2.8.1
>
