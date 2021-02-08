Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2873132EF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBHNIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhBHNIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:08:20 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35AC06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 05:07:39 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id s17so3887536vsn.11
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 05:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q9Lnou6eX+Zd+gwTwesC/efPmGOGWWLzMGlqwzv2rt0=;
        b=oePKnSNfeI0UK4muyPGY/ru0jUlhoYs+j5TVlGjCaYRXsVX+kVQyxqjnC/dwx+VtIG
         QGx3zO/4twrhLUQSzhQ5Em1+sCforUN8PxIJ9UXTIP/JxSH0FsMvmqEDuohqjPxMWLS1
         sWFro9vkIq3Ur3ReeY5F4U6sdA4+ex8ydYWli+DdHx0EzMIKmOBSDsYMBCXrOW+oJZQk
         K0aF0H06loyA1bhgHPAENrCptWQDxnen4qEjbTcrghHsYojYHFlphwoL48XM1vQvr6Ws
         SoWLm8rizbQpFfKSWT3f1dIr3xOzH+5eye0bqf27FJBMNJtoz68oQzyYVHtLe3FQhXpJ
         gJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q9Lnou6eX+Zd+gwTwesC/efPmGOGWWLzMGlqwzv2rt0=;
        b=RTuKSgDZWzmUyxA/VNhNIrbVV4A8ANsXyfw9F6w+kCoJjt6vj4cemewB+hIgw2WqWL
         9MV7A3Nfz+5vUVme5xh1bg5XulPIXZEtlpdhlj1Zu2QmbipLrPJKjDIyhsL/2tQU78qB
         WMF/ofVvNWAWyYNCQM09PNv+pWdwGcy9Etn/909qu1izKmpG+nGFoHAuSiJK1DjH14+4
         49PT4IGrsQINQ1ImRCOKYQUwvNucQvUsF8vz//O1vfHbUQVZaI0PSmc7x5qHyzuiQmAb
         3ltUa9c3Or3C1V/TZvtjqdTYUCxIM5VMvwEZvRto3gl7rqJzNLVcoQx9qYiemHnjx2iW
         FKbA==
X-Gm-Message-State: AOAM531/5QK9JS1kExeKLRAY/wOqCEJk5UGOB3/u6oTAzxArQtYtiwnJ
        FuZ62I3RWSLvqrzEIIdFjDni6i45DnI=
X-Google-Smtp-Source: ABdhPJwJa+yW5bERRHjBcIIJmwUVBqeBI9QDR2k36gAcVGGxa7QRpnjQ8/Jjav0baTM6XFtfCFCXDA==
X-Received: by 2002:a67:581:: with SMTP id 123mr10048909vsf.14.1612789658544;
        Mon, 08 Feb 2021 05:07:38 -0800 (PST)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id f26sm733321vsr.6.2021.02.08.05.07.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 05:07:37 -0800 (PST)
Received: by mail-vs1-f45.google.com with SMTP id z3so4809562vsn.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 05:07:36 -0800 (PST)
X-Received: by 2002:a67:581:: with SMTP id 123mr10048669vsf.14.1612789656311;
 Mon, 08 Feb 2021 05:07:36 -0800 (PST)
MIME-Version: 1.0
References: <20210208113810.11118-1-hxseverything@gmail.com>
In-Reply-To: <20210208113810.11118-1-hxseverything@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 8 Feb 2021 08:06:59 -0500
X-Gmail-Original-Message-ID: <CA+FuTScScC2o6uDjua0T3Eucbjt8-YPf65h3xgxMpTtWvgjWmg@mail.gmail.com>
Message-ID: <CA+FuTScScC2o6uDjua0T3Eucbjt8-YPf65h3xgxMpTtWvgjWmg@mail.gmail.com>
Subject: Re: [PATCH] bpf: in bpf_skb_adjust_room correct inner protocol for vxlan
To:     huangxuesen <hxseverything@gmail.com>
Cc:     David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        huangxuesen <huangxuesen@kuaishou.com>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 7:16 AM huangxuesen <hxseverything@gmail.com> wrote:
>
> From: huangxuesen <huangxuesen@kuaishou.com>
>
> When pushing vxlan tunnel header, set inner protocol as ETH_P_TEB in skb
> to avoid HW device disabling udp tunnel segmentation offload, just like
> vxlan_build_skb does.
>
> Drivers for NIC may invoke vxlan_features_check to check the
> inner_protocol in skb for vxlan packets to decide whether to disable
> NETIF_F_GSO_MASK. Currently it sets inner_protocol as the original
> skb->protocol, that will make mlx5_core disable TSO and lead to huge
> performance degradation.
>
> Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
> Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
> Signed-off-by: wangli <wangli09@kuaishou.com>
> ---
>  net/core/filter.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 255aeee72402..f8d3ba3fe10f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3466,7 +3466,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
>                 skb->inner_mac_header = inner_net - inner_mac_len;
>                 skb->inner_network_header = inner_net;
>                 skb->inner_transport_header = inner_trans;
> -               skb_set_inner_protocol(skb, skb->protocol);
> +
> +               if (flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP &&
> +                   inner_mac_len == ETH_HLEN)
> +                       skb_set_inner_protocol(skb, htons(ETH_P_TEB));

This may be used by vxlan, but it does not imply it.

Adding ETH_HLEN bytes likely means pushing an Ethernet header, but same point.

Conversely, pushing an Ethernet header is not limited to UDP encap.

This probably needs a new explicit BPF_F_ADJ_ROOM_.. flag, rather than
trying to infer from imprecise heuristics.
