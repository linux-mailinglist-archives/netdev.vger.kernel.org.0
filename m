Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5576525DE16
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIDPqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgIDPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:46:29 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD08AC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 08:46:28 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id b16so3871598vsl.6
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBjj6Z6R/+X4N410jUAaQIpfhsJ1Uab1XRHbJdH8dAw=;
        b=YPEHwTgWCTHCsBvkvb5iNWOgPL18jzf9kn1lZwE7bMbG/qsoaRUJRlLUiUvn7UsbRU
         xWLq78s6Zjx5M+gG58MQqK96A/z90GODiLUBY2tVybORIeD8qd024KcU4cb1NR6XsgSn
         k983Ey58HmvF9RsaKL58l0jJP0KrwZnsNQM8PoZHbbnvUCuJHhjEw1GXNIBVxpF62edn
         KMo2pe2VNgqUeJmIdtchr7g/1nTuwFfqudj/hGk0bfmJ7rFSBscLHMQulfYZ5FocwPKN
         /nX3LomJ6Z444F3tjBV8ady3IH3z3bUSgaLw/RDtnRvhpMA957RyTett0X5LUpPhocoX
         KTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBjj6Z6R/+X4N410jUAaQIpfhsJ1Uab1XRHbJdH8dAw=;
        b=Y4u428SfK4RLOUgZq7Rpfg+ocqvZvm7Yk2DVJ3h49MqZJ/PfOlcxvsdD3icpRt2JQc
         ioBSGMi2hTWyPM00rmJJqpCTegmAp41RSg30TgtvSHAy08pG5qsEN0cc4M2LaHEaWfAf
         d9J5B3/zH6Ww9MCAXq7oP/XzWSCuqSdAoUQNdV9jmh7Tq8CxBgRXHfkMiA0HXthFRL+J
         tBPpNR5WqRHbVSo0zYnEYbRGelAZN7tJ0+5QFeepz1nZ83efv+Tot4k6FV5Wh5Uc81lm
         TINXV1Nen2iNlAU74enKmcnCwLFaWNJ1Uem9TLc591eE5cQ8NrL1D/W0gASUKfjXOgcb
         hVzQ==
X-Gm-Message-State: AOAM533w+lk0Mz2eHsBo4lgPeyBf+xMKmgmq8mn+RzCApWU7nPNveaCv
        dMNeK4sg5wLrz4nilA5+U4rF750TQMFEYA==
X-Google-Smtp-Source: ABdhPJy5F10yJmcY32yoranv8bryUDyzIwVos9pQzpkYgT28Uovzj+WeHKP4d+b3bU1czKiX3fiNAg==
X-Received: by 2002:a67:2f0a:: with SMTP id v10mr5606923vsv.7.1599234387585;
        Fri, 04 Sep 2020 08:46:27 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id l134sm1063543vkl.55.2020.09.04.08.46.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:46:26 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id j185so3887965vsc.3
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:46:26 -0700 (PDT)
X-Received: by 2002:a67:8783:: with SMTP id j125mr5978201vsd.174.1599234385835;
 Fri, 04 Sep 2020 08:46:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200901195415.4840-1-m-karicheri2@ti.com> <20200901195415.4840-2-m-karicheri2@ti.com>
In-Reply-To: <20200901195415.4840-2-m-karicheri2@ti.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Sep 2020 17:45:48 +0200
X-Gmail-Original-Message-ID: <CA+FuTScPZ5sfHBwbFKQza6w4G1UcO8DaqrcpFuSvr9svgMEepw@mail.gmail.com>
Message-ID: <CA+FuTScPZ5sfHBwbFKQza6w4G1UcO8DaqrcpFuSvr9svgMEepw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: hsr/prp: add vlan support
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nsekhar@ti.com,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 9:54 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
>
> This patch add support for creating vlan interfaces
> over hsr/prp interface.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  net/hsr/hsr_device.c  |  4 ----
>  net/hsr/hsr_forward.c | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index ab953a1a0d6c..e1951579a3ad 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -477,10 +477,6 @@ void hsr_dev_setup(struct net_device *dev)
>
>         /* Prevent recursive tx locking */
>         dev->features |= NETIF_F_LLTX;
> -       /* VLAN on top of HSR needs testing and probably some work on
> -        * hsr_header_create() etc.
> -        */
> -       dev->features |= NETIF_F_VLAN_CHALLENGED;
>         /* Not sure about this. Taken from bridge code. netdev_features.h says
>          * it means "Does not change network namespaces".
>          */
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index cadfccd7876e..de21df30b0d9 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -208,6 +208,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
>                                     struct hsr_port *port, u8 proto_version)
>  {
>         struct hsr_ethhdr *hsr_ethhdr;
> +       unsigned char *pc;
>         int lsdu_size;
>
>         /* pad to minimum packet size which is 60 + 6 (HSR tag) */
> @@ -218,7 +219,18 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
>         if (frame->is_vlan)
>                 lsdu_size -= 4;
>
> -       hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
> +       pc = skb_mac_header(skb);
> +       if (frame->is_vlan)
> +               /* This 4-byte shift (size of a vlan tag) does not
> +                * mean that the ethhdr starts there. But rather it
> +                * provides the proper environment for accessing
> +                * the fields, such as hsr_tag etc., just like
> +                * when the vlan tag is not there. This is because
> +                * the hsr tag is after the vlan tag.
> +                */
> +               hsr_ethhdr = (struct hsr_ethhdr *)(pc + VLAN_HLEN);
> +       else
> +               hsr_ethhdr = (struct hsr_ethhdr *)pc;

Instead, I would pass the header from the caller, which knows the
offset because it moves the previous headers to make space.

Also, supporting VLAN probably also requires supporting 802.1ad QinQ,
which means code should parse the headers instead of hardcoding
VLAN_HLEN.

>         hsr_set_path_id(hsr_ethhdr, port);
>         set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
> @@ -511,8 +523,6 @@ static int fill_frame_info(struct hsr_frame_info *frame,
>         if (frame->is_vlan) {
>                 vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
>                 proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
> -               /* FIXME: */
> -               netdev_warn_once(skb->dev, "VLAN not yet supported");
>         }
>
>         frame->is_from_san = false;
> --
> 2.17.1
>
