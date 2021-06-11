Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11853A4B0D
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 01:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFKXHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhFKXHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 19:07:38 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FD5C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 16:05:24 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id he7so6725244ejc.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 16:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4K10XBALODv1W6k2TEM7jmG7R3p87EEFGTZ8MoCMmWo=;
        b=E6rk1+dcXYmF/WxCMNigVKA7vFO/ayTWeYveSOBEBbq1kW9R2TA6eBCf87S8EdPpEX
         xZ7iCCG3uBhSZjax7u674XfUBElXHYBn5WG3lQrSQ4fXSlqt6YOSDPoqNYjFBEsRMV34
         dHPy1La77pI3XPU5nnDUewUlOy9Uso4jbx0xfccy9pIwDwkGg2L74uUtLfQYKP5bUM2G
         g4bXxQj2BItT0b6xoJogr929a2JrUbu/kEhUck/Sy1ijkKTqDBoGEZac8F9re5/vlUC0
         l6KEOnrHOsj/L8rrPLoFT9qOgHjnpH0EpFllylTNhXjw8MYoWMdiy9DutSPL05m5HyYq
         wlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4K10XBALODv1W6k2TEM7jmG7R3p87EEFGTZ8MoCMmWo=;
        b=itgHXIeTIlh/WTl+RnA2Ii0TLbCOB1kLncnxVFLZNviE78EsqIZP0oog1oVSH8TkZA
         vE5OtbOrSzbW7WrvC2Ex/T3Ac9B7abf+r19RPVuXM/Y2wtElbMa0fke8t2dV81PFBzu0
         fCFRQT9OsN6OAM2dYVhdPIZUUifqLA3jXXXTC/QxUqJ2frjNzhMO6rUky8sCn4qLVsOx
         MEjU/+9pna1D+xvmzEheuxmXZxLDrqelFwaqeQ4+Zv/MNUH5MaoO//h3eFnwlCPYDh3q
         GNSe0D7iNi3juRWEDgYRR1epzgCSx27B1ToAjqXlaEv5gxil6e4ni0G5NxIM+leijS+U
         hAxQ==
X-Gm-Message-State: AOAM530TPrYBORx2QiZc45Dq7jJj9xqEkpIBOV3/0qPeMthHEvmQAg8e
        uc1kIuprr7u9heyKrY2R1KkETeema0/HFLwVdlDpuRV6gSc=
X-Google-Smtp-Source: ABdhPJwq8JUA9p0O0p0+4fvPrse8TJ5/2cH9fr7M2g48+4SC//Df8yNC5t20fzWkAkLq0UBcS/PomKGwm1kykD/j5hg=
X-Received: by 2002:a17:906:dbc2:: with SMTP id yc2mr5680834ejb.390.1623452722492;
 Fri, 11 Jun 2021 16:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAK3+h2x2pxbU0BS=mxCZPJxy702BXFjJrQfvt4q9Ls=sijCo=w@mail.gmail.com>
In-Reply-To: <CAK3+h2x2pxbU0BS=mxCZPJxy702BXFjJrQfvt4q9Ls=sijCo=w@mail.gmail.com>
From:   Vincent Li <vincent.mc.li@gmail.com>
Date:   Fri, 11 Jun 2021 16:05:11 -0700
Message-ID: <CAK3+h2yQtrd_7P4jQ+eJwB8ciA9994ipHk3Sdo3FtXXRpX-XXw@mail.gmail.com>
Subject: Re: packet seems disappeared after vxlan_rcv/gro_cells_receive/napi_schedule(&cell->napi)
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just reply myself for conclusion, I figured out the problem in
https://github.com/cilium/cilium/issues/16462#issuecomment-859680801

On Wed, Jun 9, 2021 at 4:50 PM Vincent Li <vincent.mc.li@gmail.com> wrote:
>
> Hi Experts,
>
> I am doing a tunnel communication  test between Cilium eBPF tunnel and
> Linux VXLAN vni key based tunnel device (to simulate BIG-IP VXLAN vni
> key based device), https://github.com/cilium/cilium/issues/16462
>
> I came across a problem when packet is handled by
> vxlan_rcv->gro_cells_receive->napi_schedule(&cell->napi),  the packet
> seems getting dropped somewhere after that. I suspect I might have
> done something wrong to setup the VXLAN device.
>
> Here is how I setup the vxlan device  test on my Centos 8 with most
> recent mainline git kernel build (5.13.0-rc4+ )
>
> ====start of the script====
> #!/bin/bash
>
>
> ip link add vxlan666 type vxlan id 666 dstport 8472 local
> 10.169.72.236 dev ens192 nolearning l2miss l3miss proxy
>
> ip link set vxlan666 up
>
> ip a add 10.0.4.236/24 dev vxlan666
>
> ip route add 10.0.1.0/24 dev vxlan666  proto kernel  scope link  src 10.0.4.236
>
> arp -i vxlan666 -s 10.0.1.17 6a:29:d2:78:63:7d
>
> bridge fdb append 6a:29:d2:78:63:7d dst 10.169.72.238 dev vxlan666
>
> ====end of the script====
>
> then I run tcpdump in the background
>
> #tcpdump -nn -e -i vxlan666 &
>
> and start to ping the IP 10.0.1.17 which is a POD IP in Cilium managed
> K8S cluster
>
> #ping -c 1 10.0.1.17
>
>
> PING 10.0.1.17 (10.0.1.17) 56(84) bytes of data.
>
> 19:06:44.452994 d6:04:7c:b2:93:54 > 6a:29:d2:78:63:7d, ethertype IPv4
> (0x0800), length 98: 10.0.4.236 > 10.0.1.17: ICMP echo request, id
> 1522, seq 1, length 64
>
> 19:06:44.454515 56:3d:9c:3a:09:78 > b2:1c:3c:57:9e:97, ethertype IPv4
> (0x0800), length 98: 10.0.1.17 > 10.0.4.236: ICMP echo reply, id 1522,
> seq 1, length 64
>
>
> ^C
>
> --- 10.0.1.17 ping statistics ---
>
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
>
> You can see the tcpdump shows ICMP echo reply, but ping did not get
> the ICMP echo reply  and shows 100% packet loss.
>
> I added netdev_info log below and I can see the kernel log:
>
> @@ -35,13 +39,17 @@ int gro_cells_receive(struct gro_cells *gcells,
> struct sk_buff *skb)
>
>         }
>
>
>         __skb_queue_tail(&cell->napi_skbs, skb);
> -       if (skb_queue_len(&cell->napi_skbs) == 1)
> +       if (skb_queue_len(&cell->napi_skbs) == 1) {
> +               netdev_info(skb->dev, "gro_cells_receive: napi_schedule\n");
>                 napi_schedule(&cell->napi);
> +       }
> +       netdev_info(skb->dev, "gro_cells_receive: NET_RX_SUCCESS\n");
>         res = NET_RX_SUCCESS;
>
> Jun  9 19:06:44 kernel-dev kernel: vxlan666: gro_cells_receive: napi_schedule
>
> Jun  9 19:06:44 kernel-dev kernel: vxlan666: gro_cells_receive: NET_RX_SUCCESS
>
>
>  I don't know where I have done wrong, any help is appreciated ! :)
