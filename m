Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18A62FF30C
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389576AbhAUSRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389720AbhAUSNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:13:55 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3A8C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:13:14 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id z22so5852852ioh.9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 10:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TvxxGYipDVXxzql+x1pmGPOXIn14KzztN6HRts4mx14=;
        b=kN+lYrp8x6O0MSV2IKbXiyA/o13SHAj9BZk6pA4ls/mhtMKz16J+30KRpYp+Dvo4Dk
         ORZkyibq+9uVVopU3PXQeGZocNnrwftuzJgwiY8ccLZS24zSZDUTt2w6VykPTicHAmfT
         GL5Zzgt/+siknPNdRrlhysWvCW8FntSE6EWb+l4P7ST2PK7fdzNlYiV2pBQiEhuccbKR
         lzRb28XvVIVSx6kV1vmEAYmUGkQpy3sfPLhVFFqhgu8zAtThsLTnQkc5s9hh2UzWEuzj
         fglLBEI+UKCGcG6NqFg+L0HcfN21RP+ofrxddwmMMTSqe23WDsPZz7qVim63XEtYtkE1
         dFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TvxxGYipDVXxzql+x1pmGPOXIn14KzztN6HRts4mx14=;
        b=tuywIwdOwKN0KdE3He2tOAbhEoIwYNNyH+ixuagcknpfJGgGKrRpHzfbw3elO4mlRK
         XtalzvJKfDUNSs9CB5B5H0cmhfrXztX1/nqfsSf7yS7hbxoVoVBmipx25iL2l3CN17W1
         /AJ3v4017XxcH/0wsrhunIx+OyKw0cWFeuw06NFLZckMb5kV+LBONoCdHfd1EjyC0/Pz
         V5GtRjLhXDN5s5YbwbUQunEMRWFJIdTLSEa0sDO4SU2wEjmxi7mdC7NqGDJCGe0SQi4U
         WTHnYNCMRUEnalORQP4d7W/i36z+yoMUppUvmMqdmwo/2NvENDX8hGh8G7MW+EwYXT3F
         QJWQ==
X-Gm-Message-State: AOAM532l6cXgYIO/xI1C/IPY/rKadui8JQM83wGeQ1iNI550KxHitZRU
        fvTP/+KoZDP90ndXs6ID4V1jgDwkN24155vxVnc=
X-Google-Smtp-Source: ABdhPJwuCjvKue5yIEmTiha8edCAP373v4s22rnSdnOuNdHb1sP8J9CxuxErdu4Cip6BKV/XgGrqjGNYizt6z0g0w/I=
X-Received: by 2002:a92:cf04:: with SMTP id c4mr832373ilo.237.1611252794212;
 Thu, 21 Jan 2021 10:13:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611218673.git.lucien.xin@gmail.com> <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
 <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
In-Reply-To: <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 21 Jan 2021 10:13:03 -0800
Message-ID: <CAKgT0Ucb6EO45+AxWAL8Vgwy4e7b=88TagW+xE-XizedOvmQEw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: add CSUM_T_IP_GENERIC csum_type
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:46 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch is to extend csum_type field to 2 bits, and introduce
> CSUM_T_IP_GENERIC csum type, and add the support for this in
> skb_csum_hwoffload_help(), just like CSUM_T_SCTP_CRC.
>
> Note here it moves dst_pending_confirm field below ndisc_nodetype
> to avoid a memory hole.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/skbuff.h |  5 +++--
>  net/core/dev.c         | 17 +++++++++++++----
>  2 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 67b0a01..d5011fb 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -224,6 +224,7 @@
>
>  #define CSUM_T_INET            0
>  #define CSUM_T_SCTP_CRC                1
> +#define CSUM_T_IP_GENERIC      2
>
>  /* Maximum value in skb->csum_level */
>  #define SKB_MAX_CSUM_LEVEL     3
> @@ -839,11 +840,11 @@ struct sk_buff {
>         __u8                    vlan_present:1;
>         __u8                    csum_complete_sw:1;
>         __u8                    csum_level:2;
> -       __u8                    csum_type:1;
> -       __u8                    dst_pending_confirm:1;
> +       __u8                    csum_type:2;
>  #ifdef CONFIG_IPV6_NDISC_NODETYPE
>         __u8                    ndisc_nodetype:2;
>  #endif
> +       __u8                    dst_pending_confirm:1;
>
>         __u8                    ipvs_property:1;
>         __u8                    inner_protocol_type:1;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3241de2..6d48af2 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3617,11 +3617,20 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
>  int skb_csum_hwoffload_help(struct sk_buff *skb,
>                             const netdev_features_t features)
>  {
> -       if (unlikely(skb_csum_is_sctp(skb)))
> -               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> -                       skb_crc32c_csum_help(skb);
> +       if (likely(!skb->csum_type))
> +               return !!(features & NETIF_F_CSUM_MASK) ? 0 :
> +                      skb_checksum_help(skb);
>
> -       return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
> +       if (skb_csum_is_sctp(skb)) {
> +               return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> +                      skb_crc32c_csum_help(skb);
> +       } else if (skb->csum_type == CSUM_T_IP_GENERIC) {
> +               return !!(features & NETIF_F_HW_CSUM) ? 0 :
> +                      skb_checksum_help(skb);
> +       } else {
> +               pr_warn("Wrong csum type: %d\n", skb->csum_type);
> +               return 1;
> +       }

Is the only difference between CSUM_T_IP_GENERIC the fact that we
check for NETIF_F_HW_CSUM versus using NETIF_F_CSUM_MASK? If so I
don't think adding the new bit is adding all that much value. Instead
you could probably just catch this in the testing logic here.

You could very easily just fold CSUM_T_IP_GENERIC into CSUM_T_INET,
and then in the checks here you split up the checks for
NETIF_F_HW_CSUM as follows:

 if (skb_csum_is_sctp(skb))
    return !!(features & NETIF_F_SCTP_CRC) ? 0 : skb_crc32c_csum_help(skb);

if (skb->csum_type) {
    pr_warn("Wrong csum type: %d\n", skb->csum_type);
    return 1;
}

if (features & NETIF_F_HW_CSUM)
    return 0;

if (features & NETIF_F_CSUM_MASK) {
    switch (skb->csum_offset) {
    case offsetof(struct tcphdr, check):
    case offsetof(struct udphdr, check):
            return 0;
    }
}

return skb_checksum_help(skb);
