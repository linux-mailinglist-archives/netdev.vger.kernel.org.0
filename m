Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1ED30DC2E
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhBCOF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbhBCOF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 09:05:27 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5A3C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 06:04:46 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id p20so13156797vsq.7
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6nTKr9a9KbMyQ5PVc45yzdvnuMs4sI/fsFatqytVm4=;
        b=rNkL5An5oo7d2vXesCWEuEiZeiJmK6K/eKUKjOsptNEgCfyEbIczYcMlDrobJorjp4
         eQJ6RvQdDbcb/uEyYEupIlDiC6K68tdhdu+oCZ6modfMCKtMM5tXANxgeeh6yevc4XtM
         Xi+qNTMlmeGSrkIUGzgv0EqLsyiHcUE+q26t2WvBrwiy4IyeecBmDrE1xAS4mcOli3m+
         46yDj7SI4l2x9O/lbq2XQT2GDCtACWgSl9icisja1h0nxuqxtaXSuxx9v0BSKW6/92IW
         fjp5fN4u4lc8tLBf0lF2LmQavWrw6KjV0kpsoAg8XLq6h3F7ZFTVl/H6nnKT19lxTp9V
         ALSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6nTKr9a9KbMyQ5PVc45yzdvnuMs4sI/fsFatqytVm4=;
        b=QhmXCwT1DHofTFwg2mIYfo6KwLD5ITmOWsmoZU9TGz0X9hTUR8zIP646g7mIszM7a6
         7YukjRzHUEDam2dUJZoy8z85LjsccxsoAYwjBcWSIhnknFUtkLVajmtluthGHk2ymm0E
         A24bcj6pSq5rULeWc5H3JKualMwOkSfBF8WEUUPkCKfm0YoXOgmGUVGoYckN98QyEC+V
         z1SkTVkw3cNfK+Lh3YKncagidvvDju7/eT/iZR3oJ1LSG1g9zkg/a0OHySBhMLUKGf3Q
         HXvB3bMZs3bRr12F1sVQ+OUBQ1nZK69k8Z7HDZCrqXtRuc1N7iVO9DvPSp24JvkHPK0w
         MJvw==
X-Gm-Message-State: AOAM531llNX+QLou4CXsKJecJzQkkQ2p6qZ45CmSJoTA8H87bcOT5ltk
        vVPg2uR6uh+Fyl0P8m5xIKP9eHCFyA0=
X-Google-Smtp-Source: ABdhPJxPMC/6RveJVm3Tw9or0aPhYhEwAWp/1l5BLXUHX5EDYk/wq0wSFjLFPFjXQgwvH4DKB+Pr2g==
X-Received: by 2002:a67:cd89:: with SMTP id r9mr1506144vsl.35.1612361085427;
        Wed, 03 Feb 2021 06:04:45 -0800 (PST)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id w3sm254374vsq.14.2021.02.03.06.04.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 06:04:44 -0800 (PST)
Received: by mail-vs1-f49.google.com with SMTP id v19so13120692vsf.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 06:04:43 -0800 (PST)
X-Received: by 2002:a67:581:: with SMTP id 123mr597701vsf.14.1612361083367;
 Wed, 03 Feb 2021 06:04:43 -0800 (PST)
MIME-Version: 1.0
References: <1612358476-19556-1-git-send-email-loic.poulain@linaro.org> <1612358476-19556-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1612358476-19556-2-git-send-email-loic.poulain@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 09:04:07 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfw0wWmpY27BVMxtKL3moL+X+rq27DJuJKi7-OkLwJxwA@mail.gmail.com>
Message-ID: <CA+FuTSfw0wWmpY27BVMxtKL3moL+X+rq27DJuJKi7-OkLwJxwA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: qualcomm: rmnet: Fix rx_handler for
 non-linear skbs
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        stranche@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 8:17 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> There is no guarantee that rmnet rx_handler is only fed with linear
> skbs, but current rmnet implementation does not check that, leading
> to crash in case of non linear skbs processed as linear ones.
>
> Fix that by ensuring skb linearization before processing.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  v2: Add this patch to the series to prevent crash
>  v3: no change
>
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 3d7d3ab..2776c32 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -180,7 +180,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
>         struct rmnet_port *port;
>         struct net_device *dev;
>
> -       if (!skb)
> +       if (!skb || skb_linearize(skb))
>                 goto done;

Actually, if skb_linearize fails, the skb must be freed.
