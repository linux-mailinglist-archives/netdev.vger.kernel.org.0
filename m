Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DBA3077AD
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhA1OIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhA1OH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:07:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD20C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:07:17 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g1so6753161edu.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 06:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMPYygI8qWFUJ/h7SU6E70xYVW6aDWlFuFuWteQUrzw=;
        b=WEWfpJgCBEEgc+463IJAjx1FcTPgSpmX0lSpLkqqdeuerqxXOKirSCkE+b/vWMK9dG
         /PV7ub1tfA1NUvHf2k0s7cq7UsG1Qjuo0emWBYeJ0YjrWjcex8IThZNiLkgaQYTpWRc0
         mcKaSOQ7X69MYBkgDkbUu7nonP3xSGtz437E6hVp6q3e1YAE190jFe1sydb8uDLle8S0
         w9/S4IdKv+beYlCnwK/sIgA+PQAYLmd6gwdk0GL9QrUVUvqNQxogpKYohAbYaGPENlgy
         py4nc1s/G5L9OFGsd1fCbIjKqg4ZSXrX388VwSPOEXM/7ElfpVaI6+9M6OlolCQ1TWgi
         V7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMPYygI8qWFUJ/h7SU6E70xYVW6aDWlFuFuWteQUrzw=;
        b=JS73kEaHyQ5ShQ2CmXhtJ/mrkJXVSYMitH3yGC/hUdPsgZijMFbLODaz4tAEnpaLBX
         wJt3dRTEWdzzjtF3SlGxlF5RuxYL0UMQ8IwaEsUNACw9ULpJLRAjrVB4PXIqDqeCao/h
         OHBW+M0PB8cUMJyV9gFgT4UeBOXSDam903XKNyOEpsCl60yMQw3xAVWGgMbPrC1BZHLW
         ZTobW15rI6P7MCq5SQWpvw+zacJsVWCVsDZDafmxKfWUgKV+/9wsQeCgW6EK2g0MX+sc
         NnGlhKf/LDrDpQlrZeIOHqPgUkYMcvn3AIpAhRHwwRlmOGjnJXTrdHLGn6ey50rpCYjA
         11/A==
X-Gm-Message-State: AOAM532W+qsXKqMs9PHN+2mp669+JQe3LzHoDhikCjZ/9a2awpQg8kwd
        lSiONVEJrmAnkcqkvN1PNn5tLlbBfe+pm2/b9Yc=
X-Google-Smtp-Source: ABdhPJxT7MIyvRUMQtvsxSHpprrn6otrJh1ZaUP259J/GkwRAXFE9+TbypXftrufPhHSQFfIJt23PIdB/fqEClDk3v0=
X-Received: by 2002:aa7:d1d7:: with SMTP id g23mr14233804edp.6.1611842836492;
 Thu, 28 Jan 2021 06:07:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611825446.git.lucien.xin@gmail.com> <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
In-Reply-To: <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 09:06:40 -0500
Message-ID: <CAF=yD-JXJwn4HX1kbeJpVoN1GgvpddxU55gan_hiLEx4xrSsgg@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 4:29 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
> while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
> for HW, which includes not only for TCP/UDP csum, but also for other
> protocols' csum like GRE's.
>
> However, in skb_csum_hwoffload_help() it only checks features against
> NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
> packet and the features doesn't support NETIF_F_HW_CSUM, but supports
> NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
> to do csum.
>
> This patch is to support ip generic csum processing by checking
> NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
> NETIF_F_IPV6_CSUM) only for TCP and UDP.
>
> Note that we're using skb->csum_offset to check if it's a TCP/UDP
> proctol, this might be fragile. However, as Alex said, for now we
> only have a few L4 protocols that are requesting Tx csum offload,
> we'd better fix this until a new protocol comes with a same csum
> offset.
>
> v1->v2:
>   - not extend skb->csum_not_inet, but use skb->csum_offset to tell
>     if it's an UDP/TCP csum packet.
> v2->v3:
>   - add a note in the changelog, as Willem suggested.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/dev.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6df3f1b..aae116d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
>                 return !!(features & NETIF_F_SCTP_CRC) ? 0 :
>                         skb_crc32c_csum_help(skb);
>
> -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> +       if (features & NETIF_F_HW_CSUM)
> +               return 0;
> +
> +       if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {

Should this check the specific feature flag against skb->protocol? I
don't know if there are actually instances that only support one of
the two flags.

> +               switch (skb->csum_offset) {
> +               case offsetof(struct tcphdr, check):
> +               case offsetof(struct udphdr, check):
> +                       return 0;
> +               }
> +       }
> +
> +       return skb_checksum_help(skb);
>  }
>  EXPORT_SYMBOL(skb_csum_hwoffload_help);
>
> --
> 2.1.0
>
