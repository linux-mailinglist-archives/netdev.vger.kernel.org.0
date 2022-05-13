Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8115266ED
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357506AbiEMQWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 12:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiEMQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 12:22:15 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F085F614F
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 09:22:14 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2fb9a85a124so92266127b3.13
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Mhi80tFd5qe+q83Vn1efq22Z/fqRqLLO6UPF4M1W7s=;
        b=mIaBHk2T94fLfLsPoKicOk7+siyWNyYni8kgjb8gF1zT5pVeIHPOhBcy/TZx9qB3XR
         q46E3wfaK4SiSe1MAI6snftc4dAB927fUywgasrbkaiDKproU/65ATB3x2dLn+P+cIBl
         yRbA8vJVIRZ9IG2Z1w/uRaZkkeRpgMGSAXM5wXT6AJ2yWFtBwuWaUo52hGsqBiO0nxcq
         Av/jqXTBDBtfhwh1fblLdd4gXM19jvCNUQYC8jYMEChQetvAiFvb0BH25Bih15JAnxqm
         pr5PXnq/0BHiQWUem4SduwuReqXigqba0GhTSvN6xEeFszzpsCFBYwtJDDMEkL+ZIkWA
         COXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Mhi80tFd5qe+q83Vn1efq22Z/fqRqLLO6UPF4M1W7s=;
        b=PLu9VaZS7+6s7wr3HTbiCVSpKpyLUZZc0zx/tRAAMs9+nrh4qz9LUB9K7+t1DKnAWS
         veSWF7LfcBD3ovm4Jhk1PH+XNuLKFmox6pqHo3b4MTBUxCQsnZdOa7XfuH0C3G6J9cSx
         Xh2LaUFo+76iAG9NxAzYA9Hv0Q+It/EnCQsr0yFhN3M8BySa1BMo3eAMLrBtG5v9GkNd
         AcElUfxjFr/R/UjeDE53oHsfqaG1Da+O30gTkyRMo1u5YZlwtTBklXRP4Y6M6E5kijUR
         9TKPRFFLGMB7xsqDzoLtvEhIgnw/Kz2NG/o61v9iurIvE+XdoHbgxAjM6YS17QHg5HWh
         ap+w==
X-Gm-Message-State: AOAM530RMIt1YJER3cDY2psDB6KHxGgYVSlJXXOSr3TlQ+ubEvpELHjL
        qV8tqCSwH+nPGgi1TInN2M3TXAame/ZhOWe5shEihA==
X-Google-Smtp-Source: ABdhPJwkwXCl2yI+IBKsiwbz6JNx9jTz4hBM8jL4m9dPxY01c+vDghx7X5djecKzpf/YCtV2r4j7HBbbrD72aPkGd1Y=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr6629443ywd.278.1652458933924; Fri, 13
 May 2022 09:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <01a8af8654b87058ecd421e471d760a43784ab96.1652456873.git.lucien.xin@gmail.com>
In-Reply-To: <01a8af8654b87058ecd421e471d760a43784ab96.1652456873.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 May 2022 09:22:02 -0700
Message-ID: <CANn89iJxkikxKmN7JM_-1dohhb7TvH0Ok7CWxAajz_Lqi3y3Dw@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: set dst dev to blackhole_netdev instead of
 loopback_dev in ifdown
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 8:47 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> The global blackhole_netdev has replaced pernet loopback_dev to become the
> one given to the object that holds an netdev when ifdown in many places of
> ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
> blackhole_netdev to invalidate dst entries").
>
> Especially after commit faab39f63c1f ("net: allow out-of-order netdev
> unregistration"), it's no longer safe to use loopback_dev that may be
> freed before other netdev.

Maybe add it formally in Fixes: tag.

>
> This patch is to set dst dev to blackhole_netdev instead of loopback_dev
> in ifdown.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/xfrm/xfrm_policy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 00bd0ecff5a1..f1876ea61fdc 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3744,7 +3744,7 @@ static int stale_bundle(struct dst_entry *dst)
>  void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
>  {
>         while ((dst = xfrm_dst_child(dst)) && dst->xfrm && dst->dev == dev) {
> -               dst->dev = dev_net(dev)->loopback_dev;
> +               dst->dev = blackhole_netdev;

I assume the XFRM layer is ready to deal with dst->dev set to blackhole ?

No initial setup needed ?

Thanks

>                 dev_hold(dst->dev);
>                 dev_put(dev);
>         }
> --
> 2.31.1
>
