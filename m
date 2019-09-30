Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D45C2419
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbfI3PQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:16:55 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37801 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730780AbfI3PQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:16:55 -0400
Received: by mail-yb1-f193.google.com with SMTP id z125so1180479ybc.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I388+Z01uFqRgCbtUk48+rgrz9rQmtEtuuf2g+o19pY=;
        b=a5ukSfvY6P980pqVkLsW+uEWbZ9VaQLXqugiRcX/MQr1VBPIla0++Qo+7mM1hv4k6w
         vqilxzUFnQvz9ohd+HeDPd7J+oYdWcasbakPijayk83FA1ovIy5xVhRmxzWhM2KfoOS5
         fUuN7TCt2BP3zUBa46ZIHwvCOCJPpI3HKpJWDiP8RuSUNNes+5b7YbBUrpXFCbNyuLVR
         h4iz7768WqAZiH/3v1FJwmdcDeDOoIap2IPhyXE7umYuQoJQbxyS20mpDG8zC0sfWdXf
         mn0CFUr0263Eeng+NhSdMnpEglJic/HJ4s1j6jjeIFZ5jWlqLCTy4THjST0+9S8DRvtg
         jJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I388+Z01uFqRgCbtUk48+rgrz9rQmtEtuuf2g+o19pY=;
        b=P1qTgYnaaQC5YYmRbYW7rgQuYUbgih0+YBkxjWIsTkBp4ogJM1KqcLtFZM9RoN1Uw8
         fak+F/kGg9/jkzaunJK3RrtOQ2/siNZZeJHgOen8koqKjw7AzelX2a2RWqce8ShLwdpi
         R2ky9DVShFOg5S8tbqwzLPs0Mac/TWtvAewA2xrnXGl66mjzDK1tZvhE2FLAYkNYac//
         QjxCyNqGVOhq0BvPxXxUeEC7yLZBDlT/YDKbAMdncJjSMIiLIbzlL0SU29eYt52cqtde
         R2zvQw4qChTBIBNzhrbqriJfUzkS890F+IBpEgXQAiZxu7zhgU5HWBe3kuvzK1NJp6so
         E9hA==
X-Gm-Message-State: APjAAAW+6GVujAdfn3UKSQgMihdBeeujsfVHFu3VEzQQBTUokb0Q0kta
        d2HfOgelrpCyitPpq5HhvkrG8oaj
X-Google-Smtp-Source: APXvYqz7iECvt5Kg8ARlq45NR5GHLqhX1MSb9H/kO5Ey3izLDvlIzT7vTn8adtYB745N9CdEl3exWw==
X-Received: by 2002:a25:9a03:: with SMTP id x3mr14878985ybn.439.1569856613605;
        Mon, 30 Sep 2019 08:16:53 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id q2sm2831908ywd.12.2019.09.30.08.16.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:16:53 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id n11so3631865ywn.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:16:52 -0700 (PDT)
X-Received: by 2002:a81:5883:: with SMTP id m125mr12936784ywb.64.1569856611672;
 Mon, 30 Sep 2019 08:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <1569646705-10585-1-git-send-email-srirakr2@cisco.com>
In-Reply-To: <1569646705-10585-1-git-send-email-srirakr2@cisco.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 30 Sep 2019 11:16:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfN5=xkYUKiafM3uKF37kV6mg0Cn5WGv2QF887Pyw5A5g@mail.gmail.com>
Message-ID: <CA+FuTSfN5=xkYUKiafM3uKF37kV6mg0Cn5WGv2QF887Pyw5A5g@mail.gmail.com>
Subject: Re: [PATCH] AF_PACKET doesnt strip VLAN information
To:     Sriram Krishnan <srirakr2@cisco.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 1:24 AM Sriram Krishnan <srirakr2@cisco.com> wrote:
>
> When an application sends with AF_PACKET and places a vlan header on
> the raw packet; then the AF_PACKET needs to move the tag into the skb
> so that it gets processed normally through the rest of the transmit
> path.
>
> This is particularly a problem on Hyper-V where the host only allows
> vlan in the offload info.

This sounds like behavior that needs to be addressed in the driver, instead?

> Cc: xe-linux-external@cisco.com
> ---
>  net/packet/af_packet.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index e2742b0..cfe0904 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1849,15 +1849,35 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
>         return 0;
>  }
>
> -static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
> +static int packet_parse_headers(struct sk_buff *skb, struct socket *sock)
>  {
>         if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
>             sock->type == SOCK_RAW) {

If inside this branch, may miss packets with skb->protocol set to one
of the VLAN Ethertypes.

> +               __be16 ethertype;
> +
>                 skb_reset_mac_header(skb);
> +
> +               ethertype = eth_hdr(skb)->h_proto;
> +               /*
> +                * If Vlan tag is present in the packet
> +                *  move it to skb
> +               */
> +               if (eth_type_vlan(ethertype)) {
> +                       int err;
> +                       __be16 vlan_tci;
> +
> +                       err = __skb_vlan_pop(skb, &vlan_tci);
> +                       if (unlikely(err))
> +                               return err;
> +
> +                       __vlan_hwaccel_put_tag(skb, ethertype, vlan_tci);

What happens with multiple tags (QinQ)?

> +               }
> +
>                 skb->protocol = dev_parse_header_protocol(skb);
>         }
>
>         skb_probe_transport_header(skb);
> +       return 0;
>  }
>
>  /*
> @@ -1979,7 +1999,9 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
>         if (unlikely(extra_len == 4))
>                 skb->no_fcs = 1;
>
> -       packet_parse_headers(skb, sock);
> +       err = packet_parse_headers(skb, sock);
> +       if (err)
> +               goto out_unlock;

This only tests the new return value in one of three callers of
packet_sendmsg_spkt.
